import sys
import os

# CONFIGURATION OF THE HUB
# The ip address for the Hub process to *bind* to.
c.JupyterHub.hub_ip = '0.0.0.0'
# c.JupyterHub.log_level = logging.DEBUG

# The host name that notebooks will use to connect to the hub. In our case,
# this is assigned to the hub image by docker-compose.
c.JupyterHub.hub_connect_ip = 'hub'

# Shuts down all user servers on logout
c.JupyterHub.shutdown_on_logout = True

# https://github.com/jupyterhub/jupyterhub/blob/master/examples/cull-idle/cull_idle_servers.py
c.JupyterHub.services = [{'name': 'cull_idle','admin': True,
                          'command': [sys.executable,
                                      '/srv/jupyterhub/cull_idle_servers.py',
                                      '--timeout=3660', '--cull-users']}]




# AUTHENTICATION
c.JupyterHub.authenticator_class = 'jupyterhub.auth.DummyAuthenticator'
c.DummyAuthenticator.password = open('/srv/jupyterhub/password.txt').read().strip()
# c.DummyAuthenticator.whitelist = [
#     l.strip() for l in open('/srv/jupyterhub/users.txt') if l.strip()]

# print(c.DummyAuthenticator.password, c.DummyAuthenticator.whitelist, file=sys.stderr)



# CONFIGURATION OF THE NOTEBOOK CONTAINERS
# https://github.com/jupyterhub/dockerspawner/blob/master/dockerspawner/dockerspawner.py

c.JupyterHub.spawner_class = 'docker'
c.DockerSpawner.image = 'notebook'
c.DockerSpawner.network_name = 'climbeco'
c.DockerSpawner.notebook_dir = notebook_dir = '/home/jovyan'
c.DockerSpawner.remove_containers = True
# c.DockerSpawner.debug = True
c.DockerSpawner.volumes = {
    'user-{username}': os.path.join(notebook_dir, 'work')
    }

c.DockerSpawner.read_only_volumes ={
    '/etc/localtime'         : '/etc/localtime',
    '/data'                  : '/data',
    '/data/project/climbeco' : os.path.join(notebook_dir, 'climbeco')}



# RESTRICTIONS ON THE NOTEBOOKS
# Maximum number of concurrent named servers that can be created by a user at a
# time.
c.JupyterHub.named_server_limit_per_user = 1

# Maximum number of bytes a single-user notebook server is allowed to use.
c.Spawner.mem_limit = '5G'

# Maximum number of cpu-cores a single-user notebook server is allowed to use.
c.Spawner.cpu_limit = 1

# Maximum number of concurrent servers that can be active at a time.
c.JupyterHub.active_server_limit = 20

# Interval (in seconds) at which to update last-activity timestamps.
# This is set much more aggressively than in the default configuration so that
# we quickly can shut down idle servers.
c.JupyterHub.last_activity_interval = 300
