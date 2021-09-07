#!/usr/bin/python3.8
import subprocess
import re

# Output looks like:
# ...
#   Certificate Name: foo.se
#     Serial Number: 431d2b61Cb8184f3Ae1e595581bfB88d3d0
#     Key Type: RSA
#     Domains: foo.se www.foo.se
#     Expiry Date: 2021-01-01 21:00:18+00:00 (VALID: 81 days)
#     Certificate Path: /etc/letsencrypt/live/foo.se/fullchain.pem
#     Private Key Path: /etc/letsencrypt/live/foo.se/privkey.pem


NGINX_CONF_DIR = '/etc/nginx'

def list_certs():
    name, path = None, None
    for line in subprocess.check_output(
            ['certbot', 'certificates'],
            text=1, stderr=subprocess.STDOUT).splitlines():
        if m := re.search("Certificate Name: (.*)", line):
            name = m.group(1)
        if m := re.search("Certificate Path: (.*)", line):
            path = m.group(1)
        if name is not None and path is not None:
            yield (name, path)
            name, path = None, None


def cert_path_is_used_by_nginx_conf(path):
    r = subprocess.run(['grep', '-qrF', path, NGINX_CONF_DIR])
    return r.returncode == 0


for name, path in list_certs():
    if not cert_path_is_used_by_nginx_conf(path):
        print(f"{name} can be removed")
