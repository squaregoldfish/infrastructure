## The Hub's database
https://jupyterhub.readthedocs.io/en/stable/reference/database.html


## Hub configuration

The official jupyterhub image sets its WorkingDirectory to /srv/jupyterhub and
the command to start jupyterhub is typically.

    jupyterhub -f /srv/jupyterhub/jupyterhub_config.py

Dump a default configuration by running:

    jupyterhub --generate-config -f /tmp/jupyterhub_default_config.py


[How to reload jupyterhub configuratio (you don't)](https://github.com/jupyterhub/jupyterhub/issues/2541)

[What happens when the Hub restarts?](https://discourse.jupyter.org/t/what-happens-when-the-hub-restarts/1701)



##  Configuration Examples
https://github.com/compmodels/jupyterhub/blob/master/jupyterhub_config.py
https://github.com/jupyterhub/jupyterhub-deploy-docker/blob/master/jupyterhub_config.py



## Separate proxy from hub
[Run the proxy separate from the hub](https://jupyterhub.readthedocs.io/en/stable/reference/separate-proxy.html)



## References
[Medium-size deployment of JupyterHub with docker](https://opendreamkit.org/2018/10/17/jupyterhub-docker/)

[Jupyter discourse](https://discourse.jupyter.org)
[Jupyterhub discourse](https://discourse.jupyter.org/c/jupyterhub/10)



## References for deploying Jupyterhub with docker
https://github.com/jupyterhub/jupyterhub-deploy-docker



## Notes on using the Dockerspawner
Note that Systemuserspawner is simply a subclass of Dockerspawner

[dockerspawner.py source](https://github.com/jupyterhub/dockerspawner/blob/master/dockerspawner/dockerspawner.py)
