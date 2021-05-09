geo $nextcloud_maintenance {
{% if nextcloud_maintenance_ips %}
  default 1;
  {% for ip in nextcloud_maintenance_ips %}
  {{ ip }} 0;
  {% endfor %}
{% else %}
  default 0;
{% endif %}
}
