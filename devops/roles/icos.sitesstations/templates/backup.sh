#!{{bash_path}}

echo "Starting backup of Sites Station Form"

T="$(date +%s%N)"
backup_path="./sitesStationForm"
backup_folder="$backup_path/sitesStationFormBackup-$(date -I)"

mkdir "$backup_folder"

tar -czf $backup_folder/files_backup.tar.gz -C /disk/data/station-form/app/ files/
docker exec stationform_mysql_1 sh -c 'mysqldump -u root --password=$MYSQL_ROOT_PASSWORD application_sites' > $backup_folder/application_sites_dump.sql && echo "MySQL dump finished successfully"

# Keep only the last 30 backups
find $backup_path -maxdepth 1 -type d -name 'sitesStationFormBackup-*' | sort -r | tail -n +31 | xargs -r rm -r

# Time interval in nanoseconds
T="$(($(date +%s%N)-T))"
# Seconds
S="$((T/1000000000))"
# Milliseconds
M="$((T/1000000))"

printf "\nExecution time: %02d:%02d:%02d:%02d.%03d\n" "$((S/86400))" "$((S/3600%24))" "$((S/60%60))" "$((S%60))" "${M}"
