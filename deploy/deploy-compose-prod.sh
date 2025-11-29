#!/usr/bin/env bash
# ============================================================================
# Docker Compose Production Deployment Script
# ============================================================================
# LexOrbital production deployment
#
# Usage: ./deploy-compose-prod.sh [version]
# Example: ./deploy-compose-prod.sh v1.2.3
# ============================================================================

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Helper functions
error() {
  echo "${RED}❌ Error: $1${NC}" >&2
}

success() {
  echo "${GREEN}✅ $1${NC}"
}

warning() {
  echo "${YELLOW}⚠️  $1${NC}"
}

info() {
  echo "${BLUE}ℹ️  $1${NC}"
}

# Configuration
APP_NAME="${APP_NAME:-lexorbital}"
PROJECT_NAME="${APP_NAME}-core-prod"
VERSION="${1:-latest}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
COMPOSE_FILE="${COMPOSE_FILE:-${SCRIPT_DIR}/../docker/docker-compose.prod.yml}"
BACKUP_RETENTION_DAYS="${BACKUP_RETENTION_DAYS:-7}"

# Validate APP_NAME format
if [[ ! "$APP_NAME" =~ ^[a-zA-Z0-9_-]+$ ]]; then
  error "Invalid APP_NAME format: '$APP_NAME'"
  exit 1
fi

# Logging function
log() {
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*"
}

# Check if Docker is available
if ! command -v docker &> /dev/null; then
  error "Docker is not installed or not in PATH"
  exit 1
fi

# Check if docker compose is available
if ! docker compose version &> /dev/null; then
  error "Docker Compose is not available"
  exit 1
fi

# Load environment variables if .env exists (safer method)
if [ -f "${SCRIPT_DIR}/.env" ]; then
  log "Loading environment variables from .env"
  # Use a safer method to load .env file
  set -o allexport
  # Only load lines that look like KEY=VALUE (no comments, no code execution)
  while IFS= read -r line || [ -n "$line" ]; do
    # Skip comments and empty lines
    [[ "$line" =~ ^[[:space:]]*# ]] && continue
    [[ -z "${line// }" ]] && continue
    # Only process lines with = sign
    if [[ "$line" =~ ^[[:space:]]*[A-Za-z_][A-Za-z0-9_]*= ]]; then
      export "$line"
    fi
  done < "${SCRIPT_DIR}/.env"
  set +o allexport
fi

# Export version for docker-compose
export VERSION

log "Starting deployment of ${PROJECT_NAME} version ${VERSION}"

# Check if compose file exists
if [ ! -f "$COMPOSE_FILE" ]; then
  error "Compose file not found: $COMPOSE_FILE"
  exit 1
fi

# Pre-deployment checks
log "Running pre-deployment checks..."

# Check disk space (at least 1GB free)
AVAILABLE_SPACE=$(df -BG "$(dirname "$COMPOSE_FILE")" | tail -1 | awk '{print $4}' | sed 's/G//')
if [ "$AVAILABLE_SPACE" -lt 1 ]; then
  warning "Low disk space: ${AVAILABLE_SPACE}GB available"
  read -p "Continue anyway? (yes/no): " confirm
  if [ "$confirm" != "yes" ]; then
    log "Deployment cancelled"
    exit 0
  fi
fi

# Backup current state
BACKUP_DIR="${SCRIPT_DIR}/backups"
mkdir -p "$BACKUP_DIR"
BACKUP_FILE="${BACKUP_DIR}/compose-$(date +%F_%H-%M-%S).yml"
log "Creating backup of current configuration..."
if cp "$COMPOSE_FILE" "$BACKUP_FILE" 2>/dev/null; then
  log "Backup created: $BACKUP_FILE"
else
  warning "Failed to create backup (continuing anyway)"
fi

# Cleanup old backups
log "Cleaning up old backups..."
find "$BACKUP_DIR" -name "compose-*.yml" -mtime +${BACKUP_RETENTION_DAYS} -delete 2>/dev/null || true

# Pull latest images
log "Pulling latest images..."
if ! docker compose -f "$COMPOSE_FILE" --project-name "$PROJECT_NAME" pull; then
  error "Failed to pull images"
  exit 1
fi

# Stop current containers
log "Stopping current containers..."
if ! docker compose -f "$COMPOSE_FILE" --project-name "$PROJECT_NAME" down; then
  warning "Some containers may not have stopped cleanly"
fi

# Start new containers
log "Starting new containers..."
if ! docker compose -f "$COMPOSE_FILE" --project-name "$PROJECT_NAME" up -d; then
  error "Failed to start containers"
  log "Attempting rollback..."
  # Attempt to start previous containers if backup exists
  if [ -f "$BACKUP_FILE" ]; then
    warning "Rollback not fully implemented - manual intervention may be required"
  fi
  exit 1
fi

# Verify deployment with retry logic
log "Verifying deployment..."
MAX_RETRIES=6
RETRY_COUNT=0
DEPLOYMENT_OK=false

while [ $RETRY_COUNT -lt $MAX_RETRIES ]; do
  sleep 5
  if docker compose -f "$COMPOSE_FILE" --project-name "$PROJECT_NAME" ps | grep -q "Up"; then
    DEPLOYMENT_OK=true
    break
  fi
  RETRY_COUNT=$((RETRY_COUNT + 1))
  log "Waiting for services to start... (attempt ${RETRY_COUNT}/${MAX_RETRIES})"
done

if [ "$DEPLOYMENT_OK" = true ]; then
  docker compose -f "$COMPOSE_FILE" --project-name "$PROJECT_NAME" ps
  success "Deployment completed successfully!"
else
  error "Deployment verification failed - services may not be running"
  docker compose -f "$COMPOSE_FILE" --project-name "$PROJECT_NAME" ps
  exit 1
fi

log "Check logs with: docker compose -f $COMPOSE_FILE --project-name $PROJECT_NAME logs -f"
