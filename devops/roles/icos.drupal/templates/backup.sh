#!{{ bash_path }}

echo "Starting backup of {{ domain }}"

T="$(date +%s%N)"

tar -czf ./{{ project_name }}Drupal/files/files_backup.tar.gz /disk/data/drupal/{{ project_name }}/drupal/files/
tar -czf ./{{ project_name }}Drupal/files/modules_backup.tar.gz /disk/data/drupal/{{ project_name }}/drupal/modules/
tar -czf ./{{ project_name }}Drupal/files/themes_backup.tar.gz /disk/data/drupal/{{ project_name }}/drupal/themes/

docker exec {{ project_name }}_mariadb_1 sh -c 'mysqldump -u root --password=$MYSQL_ROOT_PASSWORD icos' > ./{{ project_name }}Drupal/db/{{ project_name }}_db_dump.sql && echo "MySQL dump finished successfully"

# Time interval in nanoseconds
T="$(($(date +%s%N)-T))"
# Seconds
S="$((T/1000000000))"
# Milliseconds
M="$((T/1000000))"

printf "\nExecution time: %02d:%02d:%02d:%02d.%03d\n" "$((S/86400))" "$((S/3600%24))" "$((S/60%60))" "$((S%60))" "${M}"
