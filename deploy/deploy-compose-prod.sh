#!/usr/bin/env bash
set -euo pipefail

export GATEWAY_PORT_PROD=8000

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

./fetch-tag-dockerhub.sh

set -o allexport
source .env
set +o allexport

if [ -z "${VERSION:-}" ]; then
  echo "[deploy] ERREUR: VERSION non définie dans .env"
  exit 1
fi

COMPOSE_FILE="docker-compose.prod.yml"
PROJECT_NAME="lexorbital-core-prod"

echo "[deploy] Déploiement version $VERSION avec $COMPOSE_FILE"

docker compose -f "$COMPOSE_FILE" --project-name "$PROJECT_NAME" down
docker compose -f "$COMPOSE_FILE" --project-name "$PROJECT_NAME" pull
docker compose -f "$COMPOSE_FILE" --project-name "$PROJECT_NAME" up -d

echo "[deploy] OK"
