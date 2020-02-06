import logging
import os

# DEBUGGING

# Makes the hub really spammy.
# c.JupyterHub.log_level = logging.DEBUG
c.DockerSpawner.remove_containers = False


# CONFIGURATION OF THE HUB
# The ip address for the Hub process to *bind* to.
c.JupyterHub.hub_ip = '0.0.0.0'
c.JupyterHub.cleanup_servers = False
c.JupyterHub.allow_named_servers = True
c.JupyterHub.named_server_limit_per_user = 5


# CONFIGURATION OF THE PROXY
# We're not starting the proxy, it's a separate docker-compose service.
c.ConfigurableHTTPProxy.should_start = False 
c.ConfigurableHTTPProxy.api_url = 'http://proxy:8001'

# The host name that notebooks will use to connect to the hub. In our case,
# this is assigned to the hub image by docker-compose.
c.JupyterHub.hub_connect_ip = 'hub'

# USER MANAGEMENT
c.JupyterHub.spawner_class = 'dockerspawner.SystemUserSpawner'
c.JupyterHub.admin_access = True
c.Authenticator.admin_users = admin = set(['ute', 'karolina'])


# CONFIGURATION OF THE NOTEBOOK CONTAINERS
#c.DockerSpawner.use_internal_ip = True
# network_name = os.environ.get("NETWORK_NAME", "jupyter")
# c.DockerSpawner.network_name = network_name
# c.DockerSpawner.extra_host_config = { 'network_name': network_name }
c.DockerSpawner.network_name = os.environ.get("NETWORK_NAME", "jupyter")

c.DockerSpawner.use_internal_hostname = True
c.DockerSpawner.image = os.environ.get("NOTEBOOK_IMAGE", "notebook_tng")
c.DockerSpawner.notebook_dir = '/home/{username}'
c.DockerSpawner.debug = True
c.DockerSpawner.read_only_volumes = {
    '/etc/localtime': '/etc/localtime',
    '/opt/stiltdata': '/opt/stiltdata',
    '/opt/eurocom': '/opt/eurocom',
    '/data' : '/data'
}

c.DockerSpawner.volumes = {'/home_jupyter/{username}': '/home_jupyter/{username}',
                           '/home_jupyter3/{username}': '/home_jupyter3/{username}'}


c.DockerSpawner.image_whitelist = {
#    'exploredata but with both python2 and python3': 'notebook',
    'all the bestest stuff is in here!': 'notebook_tng',
 #   'base jupyter notebook': 'notebook-base',
 #   'jupyter.icos-cp.eu': 'classic-jupyter-2-fix',
 #   'jupyter3.icos-cp.eu': 'classic-jupyter-3'
}
