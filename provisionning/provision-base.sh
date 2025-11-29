#!/usr/bin/env bash
# ============================================================================
# Base Server Provisioning Script
# ============================================================================
# LexOrbital server provisioning
#
# This script creates the system user and group for LexOrbital
# Usage: sudo ./provision-base.sh
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
APP_HOME="${APP_HOME:-/srv/${APP_NAME}}"

# Validate APP_NAME format (alphanumeric, hyphens, underscores only)
if [[ ! "$APP_NAME" =~ ^[a-zA-Z0-9_-]+$ ]]; then
  error "Invalid APP_NAME format: '$APP_NAME'"
  exit 1
fi

# Check if running as root
if [ "$EUID" -ne 0 ]; then
  error "This script must be run as root"
  exit 1
fi

echo "Creating system user and group for ${APP_NAME}..."

# Check if group already exists
if getent group "$APP_NAME" > /dev/null 2>&1; then
  warning "Group '${APP_NAME}' already exists"
else
  # Create dedicated group for the application
  if groupadd --system "$APP_NAME"; then
    success "System group '${APP_NAME}' created"
  else
    error "Failed to create system group"
    exit 1
  fi
fi

# Check if user already exists
if id "$APP_NAME" &> /dev/null; then
  warning "User '${APP_NAME}' already exists"
  echo "User '${APP_NAME}' already exists"
  echo "Home directory: $(getent passwd "$APP_NAME" | cut -d: -f6)"
else
  # Create system user with no login shell
  if useradd --system \
      --create-home \
      --home-dir "$APP_HOME" \
      --shell /usr/sbin/nologin \
      --gid "$APP_NAME" \
      "$APP_NAME"; then
    success "System user '${APP_NAME}' created"
  else
    error "Failed to create system user"
    exit 1
  fi
fi

# Create and set permissions on home directory
if [ ! -d "$APP_HOME" ]; then
  if mkdir -p "$APP_HOME"; then
    success "Created home directory: $APP_HOME"
  else
    error "Failed to create home directory"
    exit 1
  fi
fi

# Set proper ownership and permissions
if chown -R "${APP_NAME}:${APP_NAME}" "$APP_HOME"; then
  success "Set ownership on home directory"
else
  error "Failed to set ownership"
  exit 1
fi

if chmod 755 "$APP_HOME"; then
  success "Set permissions on home directory"
else
  error "Failed to set permissions"
  exit 1
fi

# Create necessary subdirectories
for dir in "logs" "data" "config"; do
  DIR_PATH="${APP_HOME}/${dir}"
  if [ ! -d "$DIR_PATH" ]; then
    if mkdir -p "$DIR_PATH" && chown "${APP_NAME}:${APP_NAME}" "$DIR_PATH" && chmod 750 "$DIR_PATH"; then
      success "Created directory: $DIR_PATH"
    else
      warning "Failed to create directory: $DIR_PATH"
    fi
  fi
done

success "System user '${APP_NAME}' setup completed successfully"
echo ""
echo "User: ${APP_NAME}"
echo "Group: ${APP_NAME}"
echo "Home directory: $APP_HOME"
echo ""
echo "To switch to this user: sudo su -s /bin/bash ${APP_NAME}"
