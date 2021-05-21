#!/usr/bin/python3
# This wrapper makes it more convenient to call amtool in the docker container.

import click
import os
import subprocess


PROM_HOME = os.getenv('PROMETHEUS_HOME', '{{ prometheus_home }}')
ALRT_PORT = os.getenv('ALRT_PORT', '{{ prometheus_alrt_port }}')

EXEC = ['docker-compose' ,'exec', 'alertmanager', 'amtool']
HTTP = [f'--alertmanager.url=http://localhost:{ALRT_PORT}']

# We'll be running lots of docker-compose commands, which works best when run
# from the same directory as the docker-compose.yml file.
os.chdir(PROM_HOME)


# CLI
@click.group()
def cli():
    pass


@cli.command('check-config', help='Check config')
def cli_check_config():
     subprocess.check_call([*EXEC, 'check-config', '/etc/alertmanager/config.yml'])


@cli.command('config-show', help='Show config')
def cli_config_show():
     subprocess.check_call([*EXEC, *HTTP, 'config', 'show'])


@cli.command('call', help="Run amtool commands.",
             context_settings={"ignore_unknown_options": True})
@click.argument('args', nargs=-1)
def cli_call(args):
    subprocess.run([*EXEC, *HTTP, *args])



if __name__ == '__main__':
    cli()
