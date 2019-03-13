# see https://github.com/maxking/docker-mailman/blob/master/web/mailman-web/settings.py for examples of how this file should look

ALLOWED_HOSTS = [
    "localhost",
    "mailman-web",
    "{{ mailman_web_ipv4 }}",
    {% for host in mailman_domains -%}
    "{{ host }}",
    {% endfor %}
]

MAILMAN_REST_API_USER = "{{ mailman_rest_user }}"
MAILMAN_REST_API_PASS = "{{ mailman_rest_pass }}"
