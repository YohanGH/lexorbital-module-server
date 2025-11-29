#!/usr/bin/env bash
# ============================================================================
# LexOrbital Permissions Audit Script
# ============================================================================
# Security audit script for file and directory permissions
#
# Usage: ./audit-permissions.sh
# Cron: 0 3 * * 0 /usr/local/bin/lexorbital-audit-permissions.sh >> /var/log/lexorbital/audit.log 2>&1
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

success_msg() {
  echo "${GREEN}✅ $1${NC}"
}

warning_msg() {
  echo "${YELLOW}⚠️  $1${NC}"
}

info_msg() {
  echo "${BLUE}ℹ️  $1${NC}"
}

# Configuration
APP_NAME="${APP_NAME:-lexorbital}"
APP_HOME="${APP_HOME:-/srv/${APP_NAME}}"
LOG_FILE="${LOG_FILE:-/var/log/${APP_NAME}/audit.log}"
EXPECTED_LOG_PERMS="${EXPECTED_LOG_PERMS:-640}"
EXPECTED_BACKUP_PERMS="${EXPECTED_BACKUP_PERMS:-640}"

# Validate APP_NAME format
if [[ ! "$APP_NAME" =~ ^[a-zA-Z0-9_-]+$ ]]; then
  error "Invalid APP_NAME format: '$APP_NAME'"
  exit 1
fi

# Create log directory if necessary
mkdir -p "$(dirname "$LOG_FILE")" 2>/dev/null || true

# Logging function
log() {
  local message="[$(date '+%Y-%m-%d %H:%M:%S')] $*"
  echo "$message" | tee -a "$LOG_FILE" 2>/dev/null || echo "$message"
}

# Track issues found
ISSUES_FOUND=0

log "=== LexOrbital Permissions Audit ==="
log ""

# Check if APP_HOME exists
if [ ! -d "$APP_HOME" ]; then
  warning_msg "Application home directory does not exist: $APP_HOME"
  log "WARNING: Application home directory does not exist: $APP_HOME"
  log "Skipping file system checks"
else
  log "Auditing directory: $APP_HOME"
  log ""

  # 1. World-writable files (CRITICAL)
  log "1. World-writable files (CRITICAL):"
  WORLD_WRITABLE_FILES=$(find "$APP_HOME" -type f -perm /o+w 2>/dev/null || true)
  if [ -n "$WORLD_WRITABLE_FILES" ]; then
    echo "$WORLD_WRITABLE_FILES" | while IFS= read -r file; do
      [ -n "$file" ] && log "  $file"
    done
    warning_msg "ATTENTION: World-writable files detected!"
    log "⚠️  ATTENTION: World-writable files detected!"
    ISSUES_FOUND=$((ISSUES_FOUND + 1))
  else
    success_msg "No world-writable files"
    log "✅ No world-writable files"
  fi
  log ""

  # 2. World-writable directories (CRITICAL)
  log "2. World-writable directories (CRITICAL):"
  WORLD_WRITABLE_DIRS=$(find "$APP_HOME" -type d -perm /o+w 2>/dev/null || true)
  if [ -n "$WORLD_WRITABLE_DIRS" ]; then
    echo "$WORLD_WRITABLE_DIRS" | while IFS= read -r dir; do
      [ -n "$dir" ] && log "  $dir"
    done
    warning_msg "ATTENTION: World-writable directories detected!"
    log "⚠️  ATTENTION: World-writable directories detected!"
    ISSUES_FOUND=$((ISSUES_FOUND + 1))
  else
    success_msg "No world-writable directories"
    log "✅ No world-writable directories"
  fi
  log ""

  # 3. World-readable sensitive files
  log "3. World-readable sensitive files:"
  SENSITIVE_FILES=$(find "$APP_HOME" -type f \( -name "*.env" -o -name "*.key" -o -name "*.pem" -o -name "*.crt" \) -perm /o+r 2>/dev/null || true)
  if [ -n "$SENSITIVE_FILES" ]; then
    echo "$SENSITIVE_FILES" | while IFS= read -r file; do
      [ -n "$file" ] && log "  $file"
    done
    warning_msg "ATTENTION: World-readable sensitive files detected!"
    log "⚠️  ATTENTION: World-readable sensitive files detected!"
    ISSUES_FOUND=$((ISSUES_FOUND + 1))
  else
    success_msg "No world-readable sensitive files"
    log "✅ No world-readable sensitive files"
  fi
  log ""

  # 4. Files owned by root or other users
  log "4. Files owned by root or other users:"
  WRONG_OWNER_FILES=$(find "$APP_HOME" ! -user "$APP_NAME" 2>/dev/null || true)
  if [ -n "$WRONG_OWNER_FILES" ]; then
    echo "$WRONG_OWNER_FILES" | while IFS= read -r file; do
      [ -n "$file" ] && log "  $file ($(stat -c '%U' "$file" 2>/dev/null || stat -f '%Su' "$file" 2>/dev/null || echo 'unknown'))"
    done
    warning_msg "ATTENTION: Files with incorrect ownership detected!"
    log "⚠️  ATTENTION: Files with incorrect ownership detected!"
    ISSUES_FOUND=$((ISSUES_FOUND + 1))
  else
    success_msg "All files belong to ${APP_NAME}"
    log "✅ All files belong to ${APP_NAME}"
  fi
  log ""

  # 5. Files belonging to other groups
  log "5. Files belonging to other groups:"
  WRONG_GROUP_FILES=$(find "$APP_HOME" ! -group "$APP_NAME" 2>/dev/null || true)
  if [ -n "$WRONG_GROUP_FILES" ]; then
    echo "$WRONG_GROUP_FILES" | while IFS= read -r file; do
      [ -n "$file" ] && log "  $file ($(stat -c '%G' "$file" 2>/dev/null || stat -f '%Sg' "$file" 2>/dev/null || echo 'unknown'))"
    done
    warning_msg "ATTENTION: Files with incorrect group detected!"
    log "⚠️  ATTENTION: Files with incorrect group detected!"
    ISSUES_FOUND=$((ISSUES_FOUND + 1))
  else
    success_msg "All files belong to group ${APP_NAME}"
    log "✅ All files belong to group ${APP_NAME}"
  fi
  log ""

  # 6. Files with setuid/setgid (potentially dangerous)
  log "6. Files with setuid/setgid (potentially dangerous):"
  SETUID_FILES=$(find "$APP_HOME" -type f \( -perm -4000 -o -perm -2000 \) 2>/dev/null || true)
  if [ -n "$SETUID_FILES" ]; then
    echo "$SETUID_FILES" | while IFS= read -r file; do
      [ -n "$file" ] && log "  $file"
    done
    warning_msg "ATTENTION: Files with setuid/setgid detected!"
    log "⚠️  ATTENTION: Files with setuid/setgid detected!"
    ISSUES_FOUND=$((ISSUES_FOUND + 1))
  else
    success_msg "No files with setuid/setgid"
    log "✅ No files with setuid/setgid"
  fi
  log ""

  # 7. Directories with sticky bit
  log "7. Directories with sticky bit:"
  STICKY_DIRS=$(find "$APP_HOME" -type d -perm -1000 2>/dev/null || true)
  if [ -n "$STICKY_DIRS" ]; then
    echo "$STICKY_DIRS" | while IFS= read -r dir; do
      [ -n "$dir" ] && log "  $dir"
    done
    info_msg "Directories with sticky bit (may be intentional)"
    log "ℹ️  Directories with sticky bit (may be intentional)"
  else
    success_msg "No directories with sticky bit"
    log "✅ No directories with sticky bit"
  fi
  log ""

  # 8. World-executable files (potential security risk)
  log "8. World-executable files:"
  WORLD_EXEC_FILES=$(find "$APP_HOME" -type f -perm /o+x ! -perm /u+x 2>/dev/null || true)
  if [ -n "$WORLD_EXEC_FILES" ]; then
    echo "$WORLD_EXEC_FILES" | while IFS= read -r file; do
      [ -n "$file" ] && log "  $file"
    done
    warning_msg "ATTENTION: World-executable files detected!"
    log "⚠️  ATTENTION: World-executable files detected!"
    ISSUES_FOUND=$((ISSUES_FOUND + 1))
  else
    success_msg "No suspicious world-executable files"
    log "✅ No suspicious world-executable files"
  fi
  log ""
fi

# 9. Log file permissions
log "9. Log file permissions:"
LOG_DIR="/var/log/${APP_NAME}"
if [ -d "$LOG_DIR" ]; then
  WRONG_PERM_LOGS=$(find "$LOG_DIR" -type f ! -perm "$EXPECTED_LOG_PERMS" 2>/dev/null || true)
  if [ -n "$WRONG_PERM_LOGS" ]; then
    echo "$WRONG_PERM_LOGS" | while IFS= read -r file; do
      [ -n "$file" ] && log "  $file (current: $(stat -c '%a' "$file" 2>/dev/null || stat -f '%OLp' "$file" 2>/dev/null || echo 'unknown'), expected: ${EXPECTED_LOG_PERMS})"
    done
    warning_msg "ATTENTION: Logs with incorrect permissions!"
    log "⚠️  ATTENTION: Logs with incorrect permissions!"
    ISSUES_FOUND=$((ISSUES_FOUND + 1))
  else
    success_msg "All logs have correct permissions (${EXPECTED_LOG_PERMS})"
    log "✅ All logs have correct permissions (${EXPECTED_LOG_PERMS})"
  fi
else
  info_msg "Log directory does not exist yet: $LOG_DIR"
  log "ℹ️  Log directory does not exist yet: $LOG_DIR"
fi
log ""

# 10. Backup file permissions
log "10. Backup file permissions:"
BACKUP_DIR="/var/backups/${APP_NAME}"
if [ -d "$BACKUP_DIR" ]; then
  WRONG_PERM_BACKUPS=$(find "$BACKUP_DIR" -type f ! -perm "$EXPECTED_BACKUP_PERMS" 2>/dev/null || true)
  if [ -n "$WRONG_PERM_BACKUPS" ]; then
    echo "$WRONG_PERM_BACKUPS" | while IFS= read -r file; do
      [ -n "$file" ] && log "  $file (current: $(stat -c '%a' "$file" 2>/dev/null || stat -f '%OLp' "$file" 2>/dev/null || echo 'unknown'), expected: ${EXPECTED_BACKUP_PERMS})"
    done
    warning_msg "ATTENTION: Backups with incorrect permissions!"
    log "⚠️  ATTENTION: Backups with incorrect permissions!"
    ISSUES_FOUND=$((ISSUES_FOUND + 1))
  else
    success_msg "All backups have correct permissions (${EXPECTED_BACKUP_PERMS})"
    log "✅ All backups have correct permissions (${EXPECTED_BACKUP_PERMS})"
  fi
else
  info_msg "Backup directory does not exist yet: $BACKUP_DIR"
  log "ℹ️  Backup directory does not exist yet: $BACKUP_DIR"
fi
log ""

# Summary
log "=== Audit Summary ==="
if [ $ISSUES_FOUND -eq 0 ]; then
  success_msg "No security issues found"
  log "✅ No security issues found"
else
  warning_msg "${ISSUES_FOUND} security issue(s) detected"
  log "⚠️  ${ISSUES_FOUND} security issue(s) detected"
fi
log ""
log "Complete report available in: $LOG_FILE"
log ""

# Exit code: 0 if OK, 1 if issues detected
exit $ISSUES_FOUND
