create role {{ nextcloud_db_name }} login password '{{ nextcloud_db_pass | mandatory }}';
create database {{ nextcloud_db_name }} owner {{ nextcloud_db_user }};
