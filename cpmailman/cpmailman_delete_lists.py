# -*- coding: utf-8 -*-
"""
    Dynamically create and update emailing lists in mailman "lists.icos-cp.eu".
    The SPARQL endpoint is queried to get a list of ICOS Stations and the
    corresponding Principal Investigator with email address.
    For each "theme" (ecosystem, ocean, atmosphere)
    an email list is created/updated.
    Each station will have an "own" list where the PI is moderator.
    Most of the variables are defined in cpmailman.ini
"""

# import necessary modules
import cphelpers as helpers
import logging
import configparser
from mailmanclient import Client
from mailmanclient import MailmanConnectionError
import random




# the configFile is the only variable you need
# to change. Everything else should be defined in .ini file

configFile = 'config/config.ini'

# -----------------------------------------------------------
# read the main configuration file
cp_config = configparser.ConfigParser()
cp_config.clear()
cp_config.read(configFile)

# -----------------------------------------------------------
# create a simple python logger
log = logging.getLogger(cp_config['cp_logger']['name'])
log.handlers.clear()

handler = logging.FileHandler(cp_config['cp_logger']['fileName'])
formatter = logging.Formatter(
        '%(asctime)s %(name)-12s %(levelname)-8s %(message)s')
handler.setFormatter(formatter)
log.addHandler(handler)
log.propagate = False

# -----------------------------------------------------------
# set log level CRITICAL | ERROR | WARNING | INFO | DEBUG )
# with numerical value: {50 | 40 | 30 | 20 | 10 }
log.setLevel(int(cp_config['cp_logger']['level']))
log.debug('logging started with level ' + cp_config['cp_logger']['level'])

###################
# start main prog #
###################

log.info('Start to delete lists')
# -----------------------------------------------------------
# make sure that you don't delte all the list by accident.
a = random.randint(1,20)
b = random.randint(1,20)

first = input ('do you know what you are doing? ')

second = input('what is %s + %s? ' %(a, b))
try:
    assert first == 'delete all'
    assert int(second) == a+b
except AssertionError:    
    log.info('lists not deleted, you dont know what you are doing')
    raise SystemExit(0)
            

# -----------------------------------------------------------
# read the list configuration
cp_lists = configparser.ConfigParser()
cp_lists.clear()
cp_lists.read(cp_config['cp_listconfig']['fileName'])
log.debug('read configuration  from file: ' + cp_config['cp_listconfig']['fileName'])
if not cp_lists.sections():
    log.warning('no lists to process')    
    
    raise SystemExit()
else:    
    log.info('umbrella lists to process: ' + str(cp_lists.sections()))
# -----------------------------------------------------------

# connect to the mailman list server
client = Client(cp_config['mm_settings']['url'],
                cp_config['mm_settings']['user'],
                cp_config['mm_settings']['pass'])
        
try: 
    log.debug(client.system)    
except (MailmanConnectionError):    
    log.critical(MailmanConnectionError)
    raise SystemExit(0)
    
mm_domain = client.get_domain(cp_config['mm_settings']['domain'])
mm_lists = mm_domain.get_lists()
log.info('domain: ' + str(mm_domain))
log.debug('all lists in domain: ')
for l in mm_lists: log.debug(l)
log.debug('connected to : ' + str(client))

# -----------------------------------------------------------
# query the sparql endpoint for a list of stations with PI's and email
cpresult = helpers.sparql(helpers.stationQString)

# the sparql query function returns a tuple
# with the first entry 'false' if something went wrong
if not cpresult[0]:
    log.warning(cpresult)
    log.warning('sparql query not succesful')
    raise SystemExit(0)
else:
    log.info('sparql list contains ' + str(len(cpresult[1])) + ' entries')
    

for icos_station in cpresult[1]:
    
    station = dict(zip(cpresult[0], icos_station))
    listname = station['stationId'].lower() + '@' + cp_config['mm_settings']['domain']
    listname = helpers.cleanStr(listname)    
    
    log.debug('processing station list: ' + listname)
    
    if listname in str(mm_lists):
        log.info('delete station list: ' + listname)
        # make sure there are not whitespace, maybe we need a good regex
        lst = client.get_list(listname)        
        lst.delete()            
        # reread the lists from the server
        mm_lists = mm_domain.get_lists()
    else: 
        log.debug(listname + ' not found')

for list in cp_lists.sections():
    listname = cp_lists[list]['name'] + '@' + cp_config['mm_settings']['domain']
    listname = helpers.cleanStr(listname)
    
    log.debug('processing umbrella list: ' + listname)
    
    if listname in str(mm_lists):            
        log.info('delete umbrella: ' + listname)
        lst = client.get_list(helpers.cleanStr(listname))
        lst.delete()
        # reread the lists from the server
        mm_lists = mm_domain.get_lists()

    else: 
        log.debug(listname + ' not found')
        

log.info("ICOS mailman sync finished")
log.info("-------------------------------------------")

# -- EOF --- ICOS mailman sync finished








