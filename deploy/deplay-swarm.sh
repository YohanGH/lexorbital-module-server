#!/usr/bin/env bash
set -euo pipefail

STACK_NAME="lexorbital-core"
COMPOSE_FILE="docker-compose.prod.yml"

docker stack deploy -c "$COMPOSE_FILE" "$STACK_NAME"

echo "[deploy] Stack $STACK_NAME déployée"
