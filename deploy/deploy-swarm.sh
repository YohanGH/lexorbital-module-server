#!/usr/bin/env bash
# ============================================================================
# Docker Swarm Stack Deployment Script
# ============================================================================
# LexOrbital swarm stack deployment
#
# Prerequisites: docker swarm init
# Usage: ./deploy-swarm.sh [version]
# Example: ./deploy-swarm.sh v1.2.3
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
STACK_NAME="${STACK_NAME:-lexorbital-core}"
VERSION="${1:-latest}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
COMPOSE_FILE="${COMPOSE_FILE:-${SCRIPT_DIR}/../docker/docker-compose.prod.yml}"

# Validate stack name format
if [[ ! "$STACK_NAME" =~ ^[a-zA-Z0-9_-]+$ ]]; then
  error "Invalid stack name format: '$STACK_NAME'"
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

# Check if Swarm is initialized
if ! docker info --format '{{.Swarm.LocalNodeState}}' 2>/dev/null | grep -q active; then
  error "Docker Swarm is not initialized"
  log "Run: docker swarm init"
  exit 1
fi

# Check if compose file exists
if [ ! -f "$COMPOSE_FILE" ]; then
  error "Compose file not found: $COMPOSE_FILE"
  exit 1
fi

log "Deploying stack ${STACK_NAME} (version: ${VERSION})..."

# Export version for docker-compose
export VERSION

# Deploy stack (rolling update if already deployed)
if ! docker stack deploy -c "$COMPOSE_FILE" "$STACK_NAME"; then
  error "Failed to deploy stack"
  exit 1
fi

# Wait for services to be ready
log "Waiting for services to be ready..."
sleep 5

# Verify deployment by checking service status
log "Verifying deployment..."
SERVICES=$(docker stack services "$STACK_NAME" --format '{{.Name}}' 2>/dev/null || true)

if [ -z "$SERVICES" ]; then
  warning "No services found in stack (may still be starting)"
else
  for service in $SERVICES; do
    REPLICAS=$(docker service ls --filter "name=${service}" --format '{{.Replicas}}' 2>/dev/null || echo "0/0")
    log "Service ${service}: ${REPLICAS}"
  done
fi

success "Stack ${STACK_NAME} deployed successfully!"
log ""
info "Useful commands:"
log "  View services:  docker stack services ${STACK_NAME}"
log "  View tasks:     docker stack ps ${STACK_NAME}"
log "  View logs:      docker service logs ${STACK_NAME}_backend"
log "  Scale service:  docker service scale ${STACK_NAME}_backend=3"
log "  Remove stack:   docker stack rm ${STACK_NAME}"

