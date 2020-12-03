import click
import os
import requests
import sys
import pandas as pd

PROJECT = '/project'
PRTEMPL = '/root/readme_template.html'
PR_URL  = 'https://fileshare.icos-cp.eu/s/JWncSTWTFKyFZ3t/download'

@cli.command()
@click.option('-p', '--project', default='', help='project folder name')
@click.option('-f', '--force', is_flag=True, help='force replace existing README.html')
def project_readme(project, force):
    """Create a README.html page for projects.

    Based on a template (/root/readme_template.html) a customized project
    README.html is created and copied to /project/...../store/README.html

    The contact information, description, PI etc. is read from the cp fileshare
    'elaboroated products/jupyter/projectgroups/jupyterhub_projectgroup_info.xlsx'
    https://fileshare.icos-cp.eu/s/JWncSTWTFKyFZ3t/download'

    Running this command without an argument will create a new README.html
    for all projects listed in the excel file. Existing README.html files
    are NOT replaced.

    You can create a new README.html for a specific project by providing
    the project name.

    By default --force is set to false, hence existing files are NOT overwritten

    Examples:

    \b
      $ jusers project readme inverse
             creates a new README.html file IF the file does NOT exist
      $ jusers project readme inverse --force
             creates a new README.html overwrite existing file
      $ jusers project readme -f
             replace or create new README.html files for ALL projects

    """
    if project:
        project = project.split()
    else:
        try:
            re = requests.get(PR_URL)
            df = pd.read_excel(re.content)
        except:
            print('reading fileshare document failed')
            sys.exit(1)
        project = list(df.folder.values)

    template = open(PRTEMPL).read()

    for p in project:
        # check if the actual project folder exists..
        pfolder = os.path.join(PROJECT, p)
        if not os.path.exists(pfolder):
            print(pfolder, ' not found')
            continue

        # path to project readme
        fn = os.path.join(pfolder, '/store/README.html')

        if os.path.exists(fn) and not force:
            print(p, 'skip')
            continue

        with open(fn, "w") as f:
            info = df.loc[df.folder==p].values[0]
            f.write(template%(info[0], info[1], info[2], info[2], info[3]))
            print(p, 'create or replace readme.html')
