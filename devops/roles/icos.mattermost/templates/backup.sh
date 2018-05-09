#!{{ bash_path }}

echo "Starting backup of mattermost"

T="$(date +%s%N)"
backup_folder="./mattermost"

tar -czf $backup_folder/files_backup.tar.gz -C /disk/data/mattermost/volumes/app/ mattermost/
docker exec mattermost_db_1 sh -c 'pg_dump -Fc -U mmuser mattermost' > $backup_folder/mattermost_dump.sql && echo "Database dump finished successfully"

# Time interval in nanoseconds
T="$(($(date +%s%N)-T))"
# Seconds
S="$((T/1000000000))"
# Milliseconds
M="$((T/1000000))"

printf "\nExecution time: %02d:%02d:%02d:%02d.%03d\n" "$((S/86400))" "$((S/3600%24))" "$((S/60%60))" "$((S%60))" "${M}"
