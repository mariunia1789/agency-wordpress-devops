#!/bin/bash

# 1. Define where to save backups and what to name them
BACKUP_DIR="./backups"
TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")
BACKUP_FILE="$BACKUP_DIR/agency_db_backup_$TIMESTAMP.sql"

# 2. Automatically create the backups folder if it doesn't exist
mkdir -p "$BACKUP_DIR"

echo "⏳ Starting database export from Docker container (agency_mysql)..."

# 3. Use Docker to safely execute a mysql dump from inside the container
docker exec agency_mysql mysqldump --no-tablespaces -u agency_admin -pagency_password agency_db > "$BACKUP_FILE"
# 4. Check if the backup file was actually created successfully
if [ -s "$BACKUP_FILE" ]; then
    echo "✅ Success! Backup saved cleanly to: $BACKUP_FILE"
else
    echo "❌ Error: Backup file is empty or failed to generate."
    rm -f "$BACKUP_FILE"
fi