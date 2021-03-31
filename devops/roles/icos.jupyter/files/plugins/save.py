import click
import pandas as pd
from ruamel.yaml import YAML

INPUT = '/root/jusers.yml' 
OUTPUT = '/root/jusers'     # appendix is added with fmt

@click.group()
def cli():
    pass

@cli.command()
def csv():    
    """ jusers.yml to a .csv file """
    __write('csv')
    
@cli.command()
def json():    
    """ jusers.yml to a .json file """
    __write('json')

@cli.command()
def html():    
    """ jusers.yml to a .html file """
    __write('html')
    
    
def __write(fmt):
    jusers = __read()
    users = pd.DataFrame.from_dict(jusers['users'], orient='columns', dtype=None, columns=None)
    outfile = OUTPUT+ '.' + fmt
    click.echo('writing %s' % outfile)
    if fmt== 'csv':
        users.to_csv(outfile)
    if fmt== 'json':
        users.to_json(outfile)
    if fmt== 'html':
        users.to_html(outfile)

    
def __read():
    yaml=YAML(typ='safe')   # default, if not specfied, is 'rt' (round-trip)
    with open(INPUT, encoding='utf-8') as file:
        click.echo('reading %s' % INPUT)
        jusers = yaml.load(file)
    return jusers

