#!/usr/bin/env bash

# Script: add-module.sh
# Purpose: Add a new module to the project using git subtree
# Usage: ./scripts/add-module.sh <module-name> <repo-url> [branch]
# Example: ./scripts/add-module.sh lexorbital-module-auth https://github.com/lexorbital/lexorbital-module-auth.git main

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
  echo "${BLUE}🛰️  $1${NC}"
}

# Validate module name format (alphanumeric, hyphens, underscores only)
validate_module_name() {
  local name="$1"
  if [[ ! "$name" =~ ^[a-zA-Z0-9_-]+$ ]]; then
    error "Invalid module name format: '$name'"
    echo "   Module name must contain only alphanumeric characters, hyphens, and underscores"
    return 1
  fi
  return 0
}

# Validate repository URL format
validate_repo_url() {
  local url="$1"
  # Basic URL validation (http, https, git, ssh)
  if [[ ! "$url" =~ ^(https?|git|ssh)://.+\.git$ ]] && [[ ! "$url" =~ ^[a-zA-Z0-9._-]+@[a-zA-Z0-9._-]+:.+\.git$ ]]; then
    error "Invalid repository URL format: '$url'"
    echo "   URL must be a valid git repository URL ending in .git"
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

# Check if git subtree command is available
check_git_subtree() {
  if ! git subtree --help > /dev/null 2>&1; then
    error "git subtree command is not available"
    echo "   Install git-subtree or use a Git version that includes it"
    exit 1
  fi
}

# Check if module already exists
check_module_exists() {
  local module_name="$1"
  local target_dir="modules/${module_name}"
  
  if [ -d "$target_dir" ]; then
    error "Module '$module_name' already exists in '$target_dir'"
    echo "   Use update-module.sh to update an existing module"
    exit 1
  fi
}

# Cleanup function to remove remote if it exists
cleanup_remote() {
  local remote_name="$1"
  if git remote | grep -q "^${remote_name}$"; then
    git remote remove "$remote_name" 2>/dev/null || true
  fi
}

# Main script
MODULE_NAME="${1:-}"
MODULE_REPO="${2:-}"
MODULE_BRANCH="${3:-main}"
TARGET_DIR="modules/${MODULE_NAME}"
REMOTE_NAME="${MODULE_NAME}-remote"

# Validate inputs
if [ -z "$MODULE_NAME" ] || [ -z "$MODULE_REPO" ]; then
  echo "Usage: ./scripts/add-module.sh <module-name> <repo-url> [branch]"
  echo "Example: ./scripts/add-module.sh lexorbital-module-auth https://github.com/lexorbital/lexorbital-module-auth.git main"
  exit 1
fi

# Validate module name format
if ! validate_module_name "$MODULE_NAME"; then
  exit 1
fi

# Validate repository URL
if ! validate_repo_url "$MODULE_REPO"; then
  exit 1
fi

# Verify environment
check_git_repo
check_git_subtree
check_module_exists "$MODULE_NAME"

info "Adding module ${MODULE_NAME}..."

# Cleanup any existing remote with the same name
cleanup_remote "$REMOTE_NAME"

# Add the temporary remote
if ! git remote add -f "$REMOTE_NAME" "$MODULE_REPO"; then
  error "Failed to add remote repository"
  exit 1
fi

# Add the subtree
if ! git subtree add --prefix="$TARGET_DIR" "${REMOTE_NAME}" "$MODULE_BRANCH" --squash; then
  error "Failed to add subtree"
  cleanup_remote "$REMOTE_NAME"
  exit 1
fi

# Cleanup the remote
cleanup_remote "$REMOTE_NAME"

success "Module ${MODULE_NAME} successfully added to ${TARGET_DIR}"
warning "Don't forget to update lexorbital.module.json if necessary"
