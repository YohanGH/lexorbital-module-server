#!/usr/bin/env bash
# ============================================================================
# LexOrbital Server Update Script
# ============================================================================
# Automated server update script
# Performs apt-get update, dist-upgrade, and cleanup of unused packages
#
# Usage: ./update-server.sh [--dry-run]
# Cron: 0 4 * * 0 /usr/local/bin/lexorbital-update-server.sh >> /var/log/lexorbital/update.log 2>&1
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
LOG_FILE="${LOG_FILE:-/var/log/${APP_NAME}/update.log}"
DRY_RUN="${DRY_RUN:-false}"

# Parse command line arguments
if [[ "${1:-}" == "--dry-run" ]] || [[ "${1:-}" == "-n" ]]; then
  DRY_RUN=true
  info_msg "DRY RUN MODE: No changes will be made"
fi

# Validate APP_NAME format
if [[ ! "$APP_NAME" =~ ^[a-zA-Z0-9_-]+$ ]]; then
  error "Invalid APP_NAME format: '$APP_NAME'"
  exit 1
fi

# Check if running as root
if [ "$EUID" -ne 0 ]; then
  error "This script must be run as root (use sudo)"
  exit 1
fi

# Create log directory if necessary
mkdir -p "$(dirname "$LOG_FILE")" 2>/dev/null || true

# Logging function
log() {
  local message="[$(date '+%Y-%m-%d %H:%M:%S')] $*"
  echo "$message" | tee -a "$LOG_FILE" 2>/dev/null || echo "$message"
}

# Track update status
UPDATE_SUCCESS=true
PACKAGES_UPDATED=0
PACKAGES_REMOVED=0

log "=== LexOrbital Server Update ==="
log "Mode: ${DRY_RUN:+DRY RUN }$(date '+%Y-%m-%d %H:%M:%S')"
log ""

# 1. Update package lists
log "1. Updating package lists:"
if [ "$DRY_RUN" = true ]; then
  info_msg "DRY RUN: Would run 'apt-get update'"
  log "ℹ️  DRY RUN: Would run 'apt-get update'"
else
  if apt-get update -qq; then
    success_msg "Package lists updated successfully"
    log "✅ Package lists updated successfully"
  else
    error "Failed to update package lists"
    log "❌ Error: Failed to update package lists"
    UPDATE_SUCCESS=false
  fi
fi
log ""

# 2. Check for available updates
log "2. Checking for available updates:"
if [ "$DRY_RUN" = true ]; then
  info_msg "DRY RUN: Would check for available updates"
  log "ℹ️  DRY RUN: Would check for available updates"
else
  UPGRADABLE=$(apt-get -s dist-upgrade | grep -c "^Inst " || echo "0")
  if [ "$UPGRADABLE" -gt 0 ]; then
    info_msg "Found $UPGRADABLE package(s) available for upgrade"
    log "ℹ️  Found $UPGRADABLE package(s) available for upgrade"
    PACKAGES_UPDATED=$UPGRADABLE
  else
    success_msg "System is up to date"
    log "✅ System is up to date"
  fi
fi
log ""

# 3. Perform dist-upgrade
log "3. Performing distribution upgrade:"
if [ "$DRY_RUN" = true ]; then
  info_msg "DRY RUN: Would run 'apt-get dist-upgrade -y'"
  log "ℹ️  DRY RUN: Would run 'apt-get dist-upgrade -y'"
  # Show what would be upgraded
  apt-get -s dist-upgrade | grep "^Inst " | head -10 | while IFS= read -r line; do
    log "  Would upgrade: $line"
  done
else
  if apt-get dist-upgrade -y -qq; then
    success_msg "Distribution upgrade completed successfully"
    log "✅ Distribution upgrade completed successfully"
  else
    error "Failed to perform distribution upgrade"
    log "❌ Error: Failed to perform distribution upgrade"
    UPDATE_SUCCESS=false
  fi
fi
log ""

# 4. Clean up unused packages
log "4. Cleaning up unused packages:"
if [ "$DRY_RUN" = true ]; then
  info_msg "DRY RUN: Would run 'apt-get purge --autoremove -y'"
  log "ℹ️  DRY RUN: Would run 'apt-get purge --autoremove -y'"
  # Show what would be removed
  AUTOREMOVABLE=$(apt-get -s autoremove | grep "^Remv " | wc -l || echo "0")
  if [ "$AUTOREMOVABLE" -gt 0 ]; then
    log "ℹ️  Would remove $AUTOREMOVABLE unused package(s)"
    apt-get -s autoremove | grep "^Remv " | head -10 | while IFS= read -r line; do
      log "  Would remove: $line"
    done
  else
    log "ℹ️  No unused packages to remove"
  fi
else
  AUTOREMOVABLE_BEFORE=$(apt-get -s autoremove | grep -c "^Remv " || echo "0")
  if [ "$AUTOREMOVABLE_BEFORE" -gt 0 ]; then
    info_msg "Removing $AUTOREMOVABLE_BEFORE unused package(s)"
    log "ℹ️  Removing $AUTOREMOVABLE_BEFORE unused package(s)"
    if apt-get purge --autoremove -y -qq; then
      success_msg "Unused packages removed successfully"
      log "✅ Unused packages removed successfully"
      PACKAGES_REMOVED=$AUTOREMOVABLE_BEFORE
    else
      warning_msg "Some packages could not be removed (may require manual intervention)"
      log "⚠️  Some packages could not be removed (may require manual intervention)"
    fi
  else
    success_msg "No unused packages to remove"
    log "✅ No unused packages to remove"
  fi
fi
log ""

# 5. Clean package cache (optional)
log "5. Cleaning package cache:"
if [ "$DRY_RUN" = true ]; then
  info_msg "DRY RUN: Would run 'apt-get clean'"
  log "ℹ️  DRY RUN: Would run 'apt-get clean'"
else
  CACHE_SIZE_BEFORE=$(du -sh /var/cache/apt/archives 2>/dev/null | cut -f1 || echo "unknown")
  log "ℹ️  Package cache size before cleanup: $CACHE_SIZE_BEFORE"
  if apt-get clean -qq; then
    CACHE_SIZE_AFTER=$(du -sh /var/cache/apt/archives 2>/dev/null | cut -f1 || echo "unknown")
    success_msg "Package cache cleaned (was: $CACHE_SIZE_BEFORE, now: $CACHE_SIZE_AFTER)"
    log "✅ Package cache cleaned (was: $CACHE_SIZE_BEFORE, now: $CACHE_SIZE_AFTER)"
  else
    warning_msg "Package cache cleanup had issues"
    log "⚠️  Package cache cleanup had issues"
  fi
fi
log ""

# Summary
log "=== Update Summary ==="
if [ "$DRY_RUN" = true ]; then
  info_msg "DRY RUN completed - no changes made"
  log "ℹ️  DRY RUN completed - no changes made"
elif [ "$UPDATE_SUCCESS" = true ]; then
  success_msg "Server update completed successfully"
  log "✅ Server update completed successfully"
  if [ $PACKAGES_UPDATED -gt 0 ]; then
    log "ℹ️  Packages updated: $PACKAGES_UPDATED"
  fi
  if [ $PACKAGES_REMOVED -gt 0 ]; then
    log "ℹ️  Packages removed: $PACKAGES_REMOVED"
  fi
else
  warning_msg "Server update completed with errors"
  log "⚠️  Server update completed with errors"
  log "⚠️  Please review the log above for details"
fi
log ""
log "Complete report available in: $LOG_FILE"
log ""

# Exit code: 0 if OK, 1 if errors
if [ "$UPDATE_SUCCESS" = true ]; then
  exit 0
else
  exit 1
fi

