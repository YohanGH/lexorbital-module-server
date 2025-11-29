#!/usr/bin/env bash
set -euo pipefail

DATE=$(date +%F_%H-%M-%S)
BACKUP_DIR="/var/backups/lexorbital"
mkdir -p "$BACKUP_DIR"

echo "[backup] Dumping database..."
pg_dump "$PGDATABASE" | gzip > "$BACKUP_DIR/db-$DATE.sql.gz"

# Retention: 30 days
find "$BACKUP_DIR" -type f -mtime +30 -delete

echo "[backup] OK -> $BACKUP_DIR/db-$DATE.sql.gz"
