import logging
import os

# DEBUGGING

# Makes the hub really spammy.
# c.JupyterHub.log_level = logging.DEBUG
# c.DockerSpawner.debug = True


# CONFIGURATION OF THE HUB
# The ip address for the Hub process to *bind* to.
c.JupyterHub.hub_ip = '0.0.0.0'
c.JupyterHub.cleanup_servers = False
# c.JupyterHub.allow_named_servers = True
# c.JupyterHub.named_server_limit_per_user = 5


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
c.Authenticator.admin_users = set([{%- for u in jupyter_admins -%}
                                     '{{- u }}'
                                     {%- if not loop.last %},
                                   {%- endif %}{% endfor %}])



# CONFIGURATION OF THE NOTEBOOK CONTAINERS
c.DockerSpawner.network_name = os.environ.get("NETWORK_NAME", "jupyter")

# Remove containers when they're shut down. Since we're using bind-mounted home
# directories, we won't lose any data and without this option it's very hard to
# introduce new images (since the containers are just stopped and thus uses the
# old image).
c.DockerSpawner.remove = True

c.DockerSpawner.use_internal_hostname = True
c.DockerSpawner.image = os.environ.get("NOTEBOOK_IMAGE", "notebook")
c.DockerSpawner.notebook_dir = '/home/{username}'
c.DockerSpawner.read_only_volumes = {
    '/etc/shadow'    : '/etc/shadow',
    '/etc/group'     : '/etc/group',
    '/etc/gshadow'   : '/etc/gshadow',
    '/etc/passwd'    : '/etc/passwd',
    '/etc/localtime' : '/etc/localtime',
    '/data'          : '/data'
}

c.DockerSpawner.volumes = {'/project': '/project'}

c.DockerSpawner.allowed_images = ['notebook']

# The override configuration file doesn't have to exist.
load_subconfig(os.path.join(os.path.dirname(__file__),
                            'jupyterhub_config_override.py'))
