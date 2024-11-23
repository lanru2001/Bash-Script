#!/bin/bash

# Set the PostgreSQL source DB credentials
SOURCE_DB_NAME="dlplus"
SOURCE_HOST="dlplusaurora-pr1-cluster-clone-cluster.cluster-cn4wehkbyjg2.us-east-1.rds.amazonaws.com"
SOURCE_DB_USER="root"
SOURCE_PASSWORD="OpenSource2024!"

# Set the PostgreSQL Destination DB credentials
DEST_DB_NAME="dlplus"
DEST_HOST="cluster-cpdqhndy1xf2.us-east-1.rds.amazonaws.com"
DEST_DB_USER="dlplusaurora"
DEST_PASSWORD="OpenSource2024!"

# Set the file name and path for the backup
BACKUP_FILE="dump.sql"


# Performing DB dump on the selected tables
echo "Performing backup of tables in the dlplus db"
export MYSQL_PWD='OpenSource!'; mysqldump -h $SOURCE_HOST -u $SOURCE_DB_USER --all-databases --single-transaction  --set-gtid-purged=OFF  > $BACKUP_FILE 
echo "Database dump successfully"
 

# Performing restore to destination DB
echo "Performing restore to destination DB"
export MYSQL_PWD='OpenSource2024!'; mysql  -h $DEST_HOST -u $DEST_DB_USER  < $BACKUP_FILE
echo "Restore completed successfully."


# Remove the backup file
# rm $BACKUP_FILE
# echo "Backup file removed"
