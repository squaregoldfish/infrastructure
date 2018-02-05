#!{{ bash_path }}

echo "Starting backup of {{ domain }}"

T="$(date +%s%N)"
backup_path="./{{ project_name }}Drupal"
backup_folder="$backup_path/{{ project_name }}DrupalBackup-$(date -I)"

mkdir -p "$backup_folder/files" "$backup_folder/db"

tar -czf $backup_folder/files/files_backup.tar.gz /disk/data/drupal/{{ project_name }}/drupal/files/
tar -czf $backup_folder/files/modules_backup.tar.gz /disk/data/drupal/{{ project_name }}/drupal/modules/
tar -czf $backup_folder/files/themes_backup.tar.gz /disk/data/drupal/{{ project_name }}/drupal/themes/

docker exec {{ project_name }}_mariadb_1 sh -c 'mysqldump -u root --password=$MYSQL_ROOT_PASSWORD {{ database_name | default("icos") }}' > $backup_folder/db/{{ project_name }}_db_dump.sql && echo "MySQL dump finished successfully"

# Keep only the last 30 backups
find $backup_path -maxdepth 1 -type d -name '{{ project_name }}DrupalBackup-*' | sort -r | tail -n +31 | xargs -r rm -r

# Time interval in nanoseconds
T="$(($(date +%s%N)-T))"
# Seconds
S="$((T/1000000000))"
# Milliseconds
M="$((T/1000000))"

printf "\nExecution time: %02d:%02d:%02d:%02d.%03d\n" "$((S/86400))" "$((S/3600%24))" "$((S/60%60))" "$((S%60))" "${M}"
