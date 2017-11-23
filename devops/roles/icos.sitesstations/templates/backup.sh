#!{{bash_path}}

echo "Starting backup of Sites Station Form"

T="$(date +%s%N)"

tar -czf ./sitesStationForm/files_backup.tar.gz /disk/data/station-form/app/files/
docker exec stationform_mysql_1 sh -c 'mysqldump -u root --password=$MYSQL_ROOT_PASSWORD application_sites' > ./sitesStationForm/application_sites_dump.sql && echo "MySQL dump finished successfully"

# Time interval in nanoseconds
T="$(($(date +%s%N)-T))"
# Seconds
S="$((T/1000000000))"
# Milliseconds
M="$((T/1000000))"

printf "\nExecution time: %02d:%02d:%02d:%02d.%03d\n" "$((S/86400))" "$((S/3600%24))" "$((S/60%60))" "$((S%60))" "${M}"
