#!/usr/bin/env bash
# ============================================================================
# Database Backup Script - GDPR Compliant
# ============================================================================
# LexOrbital automated database backup
#
# Usage: ./backup-db.sh
# Cron: 0 2 * * * /usr/local/bin/lexorbital-backup-db.sh
# ============================================================================

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
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

# Configuration
APP_NAME="${APP_NAME:-lexorbital}"
BACKUP_DIR="${BACKUP_DIR:-/var/backups/${APP_NAME}}"
RETENTION_DAYS="${RETENTION_DAYS:-30}"  # GDPR: Document retention period
DATE=$(date +%F_%H-%M-%S)
LOG_FILE="${LOG_FILE:-/var/log/${APP_NAME}/backup.log}"

# Validate APP_NAME format (alphanumeric, hyphens, underscores only)
if [[ ! "$APP_NAME" =~ ^[a-zA-Z0-9_-]+$ ]]; then
  error "Invalid APP_NAME format: '$APP_NAME'"
  exit 1
fi

# Create backup directory with proper error handling
if ! mkdir -p "$BACKUP_DIR" 2>/dev/null; then
  error "Failed to create backup directory: $BACKUP_DIR"
  error "Check permissions or set BACKUP_DIR environment variable"
  exit 1
fi

# Create log directory
if ! mkdir -p "$(dirname "$LOG_FILE")" 2>/dev/null; then
  warning "Failed to create log directory, logging to stdout only"
  LOG_FILE="/dev/stdout"
fi

# Logging function
log() {
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*" | tee -a "$LOG_FILE" 2>/dev/null || echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*"
}

# Cleanup function for failed backups
cleanup_on_failure() {
  if [ -f "${BACKUP_DIR}/db-${DATE}.sql.gz" ]; then
    rm -f "${BACKUP_DIR}/db-${DATE}.sql.gz"
    log "Cleaned up failed backup file"
  fi
}

# Trap to cleanup on exit if backup fails
trap cleanup_on_failure ERR

log "Starting database backup..."

# Validate PGDATABASE environment variable
if [ -z "${PGDATABASE:-}" ]; then
  error "PGDATABASE environment variable not set"
  exit 1
fi

# Validate database name format (alphanumeric, underscores, hyphens only)
if [[ ! "$PGDATABASE" =~ ^[a-zA-Z0-9_-]+$ ]]; then
  error "Invalid database name format: '$PGDATABASE'"
  exit 1
fi

# Database credentials (use environment variables or Docker secrets)
# Example with Docker container:
# DB_CONTAINER="${APP_NAME}-postgres"
# if docker exec "$DB_CONTAINER" pg_dump -U postgres "$PGDATABASE" | gzip > "${BACKUP_DIR}/db-${DATE}.sql.gz"; then
#   log "Backup created from Docker container"
# else
#   error "Failed to create backup from Docker container"
#   exit 1
# fi

# Example with local PostgreSQL:
BACKUP_FILE="${BACKUP_DIR}/db-${DATE}.sql.gz"

# Create backup and verify pg_dump success
log "Creating backup of database: $PGDATABASE"
if ! pg_dump "$PGDATABASE" | gzip > "$BACKUP_FILE"; then
  error "pg_dump failed"
  exit 1
fi

# Verify backup file was created
if [ ! -f "$BACKUP_FILE" ]; then
  error "Backup file not created: $BACKUP_FILE"
  exit 1
fi

# Check backup file size (should be > 0)
BACKUP_SIZE=$(stat -f%z "$BACKUP_FILE" 2>/dev/null || stat -c%s "$BACKUP_FILE" 2>/dev/null || echo "0")
if [ "$BACKUP_SIZE" -eq 0 ]; then
  error "Backup file is empty"
  exit 1
fi

SIZE=$(du -h "$BACKUP_FILE" | cut -f1)
log "SUCCESS: Backup created -> $BACKUP_FILE (${SIZE})"

# Verify backup integrity
log "Verifying backup integrity..."
if command -v gunzip &> /dev/null; then
  if gunzip -t "$BACKUP_FILE" 2>/dev/null; then
    log "Backup integrity verified"
  else
    error "Backup integrity check failed"
    exit 1
  fi
else
  warning "gunzip not available, skipping integrity check"
fi

# Retention cleanup (GDPR: automated deletion)
log "Cleaning up old backups (retention: ${RETENTION_DAYS} days)..."
DELETED_COUNT=0
while IFS= read -r old_backup; do
  if [ -n "$old_backup" ] && [ -f "$old_backup" ]; then
    rm -f "$old_backup"
    DELETED_COUNT=$((DELETED_COUNT + 1))
    log "Deleted old backup: $old_backup"
  fi
done < <(find "$BACKUP_DIR" -type f -name "db-*.sql.gz" -mtime +${RETENTION_DAYS} 2>/dev/null || true)

log "Deleted ${DELETED_COUNT} old backup(s)"

# Remove trap on successful completion
trap - ERR

log "Backup completed successfully"
