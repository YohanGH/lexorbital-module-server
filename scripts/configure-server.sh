#!/usr/bin/env bash
# ============================================================================
# LexOrbital Server Configuration Script
# ============================================================================
# Configuration and verification script for server setup
# Verifies and configures APT sources, security tools, and system settings
#
# Usage: ./configure-server.sh
# Cron: N/A (run once during initial setup or when configuration changes)
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
LOG_FILE="${LOG_FILE:-/var/log/${APP_NAME}/server-config.log}"
DEBIAN_RELEASE="${DEBIAN_RELEASE:-stretch}"
BACKPORTS_REPO="deb http://deb.debian.org/debian ${DEBIAN_RELEASE}-backports main"
SOURCES_LIST="${SOURCES_LIST:-/etc/apt/sources.list}"
SOURCES_LIST_D="${SOURCES_LIST_D:-/etc/apt/sources.list.d}"

# Security packages to ensure are installed
SECURITY_PACKAGES=(
  "apt-transport-https"
  "gnupg"
  "debian-archive-keyring"
  "ca-certificates"
)

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

# Track changes made
CHANGES_MADE=0

log "=== LexOrbital Server Configuration ==="
log ""

# 1. Check and add backports repository
log "1. Checking backports repository configuration:"
if [ ! -f "$SOURCES_LIST" ]; then
  warning_msg "Sources list file not found: $SOURCES_LIST"
  log "WARNING: Sources list file not found: $SOURCES_LIST"
  log "Skipping backports repository check"
else
  # Check if backports line exists in main sources.list
  if grep -q "backports" "$SOURCES_LIST" 2>/dev/null; then
    success_msg "Backports repository already configured in $SOURCES_LIST"
    log "✅ Backports repository already configured in $SOURCES_LIST"
  else
    info_msg "Adding backports repository to $SOURCES_LIST"
    log "ℹ️  Adding backports repository: $BACKPORTS_REPO"
    echo "" >> "$SOURCES_LIST"
    echo "# LexOrbital: Backports repository" >> "$SOURCES_LIST"
    echo "$BACKPORTS_REPO" >> "$SOURCES_LIST"
    success_msg "Backports repository added successfully"
    log "✅ Backports repository added successfully"
    CHANGES_MADE=$((CHANGES_MADE + 1))
  fi
  
  # Also check in sources.list.d directory
  if [ -d "$SOURCES_LIST_D" ]; then
    BACKPORTS_FOUND=false
    for file in "$SOURCES_LIST_D"/*.list; do
      [ -f "$file" ] || continue
      if grep -q "backports" "$file" 2>/dev/null; then
        BACKPORTS_FOUND=true
        log "ℹ️  Backports repository found in: $file"
        break
      fi
    done
    if [ "$BACKPORTS_FOUND" = false ]; then
      log "ℹ️  No backports repository found in sources.list.d (this is OK if configured in main sources.list)"
    fi
  fi
fi
log ""

# 2. Verify and install security packages for APT sources
log "2. Verifying security packages for APT sources:"
MISSING_PACKAGES=()
for package in "${SECURITY_PACKAGES[@]}"; do
  if dpkg -l | grep -q "^ii  ${package} " 2>/dev/null; then
    success_msg "Package installed: $package"
    log "✅ Package installed: $package"
  else
    warning_msg "Package missing: $package"
    log "⚠️  Package missing: $package"
    MISSING_PACKAGES+=("$package")
  fi
done

if [ ${#MISSING_PACKAGES[@]} -gt 0 ]; then
  info_msg "Installing missing security packages..."
  log "ℹ️  Installing missing security packages: ${MISSING_PACKAGES[*]}"
  if apt-get update -qq && apt-get install -y -qq "${MISSING_PACKAGES[@]}"; then
    success_msg "Security packages installed successfully"
    log "✅ Security packages installed successfully"
    CHANGES_MADE=$((CHANGES_MADE + 1))
  else
    error "Failed to install security packages"
    log "❌ Error: Failed to install security packages"
    exit 1
  fi
else
  success_msg "All security packages are installed"
  log "✅ All security packages are installed"
fi
log ""

# 3. Verify APT GPG keys
log "3. Verifying APT GPG keys:"
if [ -d /etc/apt/trusted.gpg.d ] && [ "$(ls -A /etc/apt/trusted.gpg.d 2>/dev/null)" ]; then
  KEY_COUNT=$(ls -1 /etc/apt/trusted.gpg.d/*.gpg 2>/dev/null | wc -l)
  if [ "$KEY_COUNT" -gt 0 ]; then
    success_msg "APT GPG keys directory exists with $KEY_COUNT key(s)"
    log "✅ APT GPG keys directory exists with $KEY_COUNT key(s)"
  else
    warning_msg "APT GPG keys directory exists but is empty"
    log "⚠️  APT GPG keys directory exists but is empty"
  fi
else
  info_msg "APT GPG keys directory structure verified"
  log "ℹ️  APT GPG keys directory structure verified"
fi
log ""

# 4. Verify HTTPS transport support
log "4. Verifying HTTPS transport support:"
if command -v apt-transport-https >/dev/null 2>&1 || dpkg -l | grep -q "^ii  apt-transport-https "; then
  success_msg "HTTPS transport support available"
  log "✅ HTTPS transport support available"
else
  warning_msg "HTTPS transport support not available (may be built into apt)"
  log "⚠️  HTTPS transport support not available (may be built into apt)"
  # Modern apt versions have HTTPS built-in, so this is not necessarily an error
fi
log ""

# 5. Check for HTTPS sources
log "5. Checking for HTTPS sources:"
HTTPS_SOURCES=$(grep -h "^deb https://" "$SOURCES_LIST" "$SOURCES_LIST_D"/*.list 2>/dev/null | wc -l || echo "0")
if [ "$HTTPS_SOURCES" -gt 0 ]; then
  success_msg "Found $HTTPS_SOURCES HTTPS source(s)"
  log "✅ Found $HTTPS_SOURCES HTTPS source(s)"
else
  info_msg "No HTTPS sources found (using HTTP sources)"
  log "ℹ️  No HTTPS sources found (using HTTP sources)"
fi
log ""

# Summary
log "=== Configuration Summary ==="
if [ $CHANGES_MADE -eq 0 ]; then
  success_msg "No configuration changes needed"
  log "✅ No configuration changes needed"
else
  info_msg "${CHANGES_MADE} configuration change(s) made"
  log "ℹ️  ${CHANGES_MADE} configuration change(s) made"
  warning_msg "You may need to run 'apt-get update' to refresh package lists"
  log "⚠️  Recommendation: Run 'apt-get update' to refresh package lists"
fi
log ""
log "Complete report available in: $LOG_FILE"
log ""

# Exit code: 0 if OK
exit 0

