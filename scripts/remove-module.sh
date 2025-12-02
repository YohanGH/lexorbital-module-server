#!/usr/bin/env bash

# Script: remove-module.sh
# Purpose: Remove a module from the project
# Usage: ./scripts/remove-module.sh <module-name> [--force]
# Example: ./scripts/remove-module.sh lexorbital-module-auth

# Exit on error, undefined variables, and pipe failures
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
  echo "${BLUE}🗑️  $1${NC}"
}

# Validate module name format (alphanumeric, hyphens, underscores only)
validate_module_name() {
  local name="$1"
  if [[ ! "$name" =~ ^[a-zA-Z0-9_-]+$ ]]; then
    error "Invalid module name format: '$name'"
    echo "   Module name must contain only alphanumeric characters, hyphens, and underscores"
    return 1
  fi
  
  # Prevent path traversal attacks
  if [[ "$name" =~ \.\. ]]; then
    error "Invalid module name: path traversal detected"
    return 1
  fi
  
  return 0
}

# Check if we're in a git repository
check_git_repo() {
  if ! git rev-parse --git-dir > /dev/null 2>&1; then
    error "Not in a git repository"
    exit 1
  fi
}

# Check if module exists
check_module_exists() {
  local module_name="$1"
  local target_dir="modules/${module_name}"
  
  if [ ! -d "$target_dir" ]; then
    error "Module '$module_name' does not exist in '$target_dir'"
    exit 1
  fi
}

# Check for uncommitted changes
check_uncommitted_changes() {
  if ! git diff-index --quiet HEAD -- 2>/dev/null; then
    warning "You have uncommitted changes"
    echo "   Consider committing or stashing them before removing a module"
    return 1
  fi
  return 0
}

# Confirm deletion
confirm_deletion() {
  local module_name="$1"
  echo ""
  warning "You are about to remove module: ${module_name}"
  echo "   This will delete the directory: modules/${module_name}"
  echo "   This action cannot be undone!"
  echo ""
  read -p "Are you sure you want to continue? (yes/no): " confirmation
  
  if [ "$confirmation" != "yes" ]; then
    echo "Operation cancelled"
    exit 0
  fi
}

# Main script
MODULE_NAME="${1:-}"
FORCE_FLAG="${2:-}"
TARGET_DIR="modules/${MODULE_NAME}"

# Validate inputs
if [ -z "$MODULE_NAME" ]; then
  echo "Usage: ./scripts/remove-module.sh <module-name> [--force]"
  echo "Example: ./scripts/remove-module.sh lexorbital-module-auth"
  echo ""
  echo "Options:"
  echo "  --force    Skip confirmation prompt"
  exit 1
fi

# Validate module name format
if ! validate_module_name "$MODULE_NAME"; then
  exit 1
fi

# Verify environment
check_git_repo
check_module_exists "$MODULE_NAME"

# Check for uncommitted changes (warning only)
if ! check_uncommitted_changes; then
  if [ "$FORCE_FLAG" != "--force" ]; then
    read -p "Continue anyway? (yes/no): " continue_anyway
    if [ "$continue_anyway" != "yes" ]; then
      echo "Operation cancelled"
      exit 0
    fi
  fi
fi

# Confirm deletion unless --force flag is used
if [ "$FORCE_FLAG" != "--force" ]; then
  confirm_deletion "$MODULE_NAME"
fi

info "Removing module ${MODULE_NAME}..."

# Remove the directory
if ! git rm -rf "$TARGET_DIR" 2>/dev/null; then
  error "Failed to remove module directory '$TARGET_DIR'"
  exit 1
fi

# Check if there are changes to commit
if git diff --cached --quiet; then
  warning "No changes to commit (module may have already been removed)"
  exit 0
fi

# Commit the removal
if ! git commit -m "chore(modules): remove ${MODULE_NAME}"; then
  error "Failed to commit module removal"
  exit 1
fi

success "Module ${MODULE_NAME} successfully removed"
