#!/bin/bash

# Notes:
# Ensure MariaDB is running before you start the backup, and the script will stop and restart it when backing up the data directory.
# Be cautious when backing up the data directory because the script stops MariaDB. Make sure no active users or processes are relying on the database during this time.

if [ "$#" -lt 3 ]; then
    echo "Usage: $0 <mysql_user> <mysql_password> <backup_directory>"
    exit 1
fi

BACKUP_DIR="$3"
MYSQL_USER="$1"
MYSQL_PASSWORD="$2"
DATE=$(date +\%F)
BACKUP_FILE="${BACKUP_DIR}/full_backup_${DATE}.sql"
MYSQL_BACKUP_FILE="${BACKUP_DIR}/mysql_backup_${DATE}.sql"
MY_CNF_BACKUP_FILE="${BACKUP_DIR}/my_cnf_${DATE}.cnf"
DATA_DIR_BACKUP="${BACKUP_DIR}/mysql_data_${DATE}"

# Create backup directory if it doesn't exist
mkdir -p "$BACKUP_DIR"

# Perform mysqldump to backup all databases, routines, triggers, and events
echo "Backing up all databases..."
mysqldump -u "$MYSQL_USER" -p"$MYSQL_PASSWORD" --all-databases --routines --triggers --events --single-transaction > "$BACKUP_FILE"

# Backup the mysql system database (user privileges, etc.)
echo "Backing up user privileges and mysql system database..."
mysqldump -u "$MYSQL_USER" -p"$MYSQL_PASSWORD" --no-tablespaces mysql > "$MYSQL_BACKUP_FILE"

# Backup the MySQL configuration file (my.cnf)
echo "Backing up MySQL configuration file..."
cp /etc/my.cnf "$MY_CNF_BACKUP_FILE"

# Optionally, backup the actual MySQL data directory (stop MariaDB first)
echo "Stopping MariaDB to backup data directory..."
systemctl stop mariadb

# Copy the data directory (ensure you have the correct path for your system)
echo "Backing up MariaDB data directory..."
cp -r /var/lib/mysql "$DATA_DIR_BACKUP"

# Start MariaDB service again
echo "Starting MariaDB..."
systemctl start mariadb

# Inform the user that the backup is complete
echo "Backup completed successfully!"
echo "Database backup: $BACKUP_FILE"
echo "MySQL system backup (users & privileges): $MYSQL_BACKUP_FILE"
echo "MySQL configuration backup: $MY_CNF_BACKUP_FILE"
echo "MySQL data directory backup: $DATA_DIR_BACKUP (MariaDB was stopped during this step)"

