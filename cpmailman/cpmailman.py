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

log.info('starting ICOS mailman sync')


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
log.debug('all lists in domain: ' + str(mm_lists))
log.debug('connected to : ' + str(client))


# -----------------------------------------------------------
# loop through the umbrella lists defined in the .ini file
# create the list if it does not exist
# update the lists with the information from the .ini file

for list in cp_lists.sections():    
    
    listname = helpers.cleanStr(cp_lists[list]['name'])
    
    log.info('processing ' + listname)
    # create the list if it does not exist
    if not listname in str(mm_lists):
        l = mm_domain.create_list(listname)
        log.info('new list created: ' + listname)
        
    # read the list
    fqdn = helpers.cleanStr(listname+'@'+cp_config['mm_settings']['domain'])
    lst = client.get_list(fqdn)

    # get the settings from ini file and update the list configuration
    settings = lst.settings
    settings['display_name'] = cp_lists[list]['display_name']
    settings['subject_prefix'] = cp_lists[list]['subject_prefix']
    settings['description'] = cp_lists[list]['description']
    settings['info'] = cp_lists[list]['info']
    settings['advertised'] = cp_lists[list]['advertised']
    settings['archive_policy'] = cp_lists[list]['archive_policy']
    settings['default_member_action'] = cp_lists[list]['default_member_action']
    
    # make sure the list is open, to accept members without sending an email
    settings['subscription_policy']     = 'open'
    # don't send a welcome message
    settings['send_welcome_message']    = 'false'
    settings['max_message_size']        = '2000'
    settings['reply_goes_to_list']      = 'point_to_list'
    settings.save()
    
    log.debug('settings updated for ' + settings['fqdn_listname'] )     

    # add the carbon portal admin from config.ini
    if not lst.is_owner(cp_config['cp_admin']['owner']):
        lst.add_owner(cp_config['cp_admin']['owner'])

    # add owner and moderator from list.ini
    if not lst.is_owner(cp_lists[list]['owner']):
        lst.add_owner(cp_lists[list]['owner'],
                      display_name=cp_lists[list]['ownerDisplay'])    
        
    if not lst.is_moderator(cp_lists[list]['moderator']):
        lst.add_moderator(cp_lists[list]['moderator'],
                          display_name=cp_lists[list]['moderatorDisplay'])
    
    # add owner and moderator as membmer, otherwise you will not get any emails
    if not lst.is_member(cp_lists[list]['owner']):        
        lst.subscribe(cp_lists[list]['owner'],
                      display_name=cp_lists[list]['ownerDisplay'],
                      pre_verified=True,
                      pre_confirmed=True)
        
    if not lst.is_member(cp_lists[list]['moderator']):        
        lst.subscribe(cp_lists[list]['moderator'],
                      display_name=cp_lists[list]['moderatorDisplay'],
                      pre_verified=True,
                      pre_confirmed=True)
    log.debug(lst)
    log.debug('owners: ' + str(lst.owners))
    log.debug('moderators: ' + str(lst.moderators))
    log.debug('members: ' + str(lst.members))

    # now we can set the subscription policy as defined in the ini file    
    settings['subscription_policy'] = cp_lists[list]['subscription_policy'] 
    settings.save()
    
    log.info('finished umbrella list: ' + listname)     
    
    
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
    
# -----------------------------------------------------------
# Loop through all the stations and create a list 

# re-read all the lists from the mailman server
mm_lists = mm_domain.get_lists()

for icos_station in cpresult[1]:
    station = dict(zip(cpresult[0], icos_station))
    listname = station['stationId']+ '@' + cp_config['mm_settings']['domain']        
    listname = helpers.cleanStr(listname)        
    
    name  = station['firstName'] + ' ' + station['lastName']
    email = station['email']
    
    log.info('processing ' + listname)
    
# -------------------------------------------------------------------    
    ################ ONLY TO TEST    
    if cp_config['cp_test']['test']:        
        name  = cp_config['cp_test']['name']
        email = cp_config['cp_test']['email']
        log.debug('overwrite name and email with ' + name +' - '+ email )
    
    
    ###############  TEST FINISHED
# -------------------------------------------------------------------    
    
    
    # create a new station list, if it does not exist
    if not listname in str(mm_lists):
        try:            
            mm_domain.create_list(helpers.cleanStr(station['stationId']))
            log.info('new list created: ' + listname)
        except:
            log.warning("problem to create: " + listname)

    # read the list 
    lst = client.get_list(listname)
  
    settings = lst.settings
    settings['display_name'] = station['stationName']
    settings['subject_prefix'] = "[ICOS_station_" + station['stationId'] + "]"
    settings['description'] = 'Automatic created ICOS station list'    
    settings['advertised'] = False
    settings['archive_policy'] = 'never'
    # make sure the list is open, to auto accept new member
    settings['subscription_policy'] = 'open'
    settings['send_welcome_message'] = False
    settings['default_member_action'] = 'accept'
    settings['max_message_size'] = '2000'
    settings['reply_goes_to_list'] = 'point_to_list'
    settings.save()
    
    log.debug('list settings updated for station ' + settings['fqdn_listname'] )     
    
    # now add owner and moderator and subscribe as member
    
    if not lst.is_owner(email):
        lst.add_owner(email, display_name=name)        
        
    if not lst.is_owner(cp_config['cp_admin']['owner']):
        lst.add_owner(cp_config['cp_admin']['owner'])
        
    if not lst.is_moderator(email):
        lst.add_moderator(email, display_name=name)
    
    if not lst.is_member(email):        
        lst.subscribe(email, display_name=name,
                      pre_verified=True,
                      pre_confirmed=True)
        # retrieve the member and preferences and make sure you get
        # a copy of your own postings
        #member = lst.get_member(email)
        #pref = member.preferences
        #pref['receive_own_postings'] = True
        #pref.save()
    

    # find the appropriate umbrella list and settings
    
    ulist = ''
    usetting = ''
    try:
        umbrella = cp_lists[station['stationTheme']]['name'] \
                   + '@' + cp_config['mm_settings']['domain']
                   
        ulist = client.get_list(helpers.cleanStr(umbrella))
        usetting= ulist.settings   
        usetting['subscription_policy'] = 'open'
        usetting.save()

        try:    
            # add the station list as member to the umbrella
            # 2019-03-28 -> looks likea bug: display name for
            # lists as member is not working
            
            if not ulist.is_member(settings['fqdn_listname']):            
                ulist.subscribe(settings['fqdn_listname'],
                                pre_verified=True,
                                pre_confirmed=True)
                
                log.debug('stationlist ' + listname + ' added to umbrella')
                
        except:
            log.error('adding ' + settings['fqdn_listname'] 
            + ' to ' + usetting['fqdn_listname'])
            
        try:
            # add the PI from the station as member to the umbrella
            if not ulist.is_member(email):                        
                ulist.subscribe(email,
                                display_name=name,
                                pre_verified=True,
                                pre_confirmed=True)
                
                log.debug('PI '+ email + ' added to stationlist ' + listname)
                
        except:
            log.error('adding PI to ' + listname + 'failed')
            
        try: 
            # add the umbrealla list as member to the station list
            if not lst.is_member(umbrella):
                lst.subscribe(umbrella,
                              display_name='MSA list',
                              pre_verified=True,
                              pre_confirmed=True)
                log.debug('umbrella list ' + umbrella + ' added to '+ listname)
        except:
            log.error('add umbrella list to ' + listname + ' failed' )
    
    except:
        log.error('umbrella not found for: ' 
                  + station['stationTheme'] + ' - '
                  + listname)
            
    settings['subscription_policy'] = 'moderate'
    settings['send_welcome_message'] = True
    settings.save()   
    log.info('finished station list: ' + listname)     
    
    log.debug(lst)
    log.debug('owner: ' + str(lst.owners))
    log.debug('moderators: ' + str(lst.moderators))
    log.debug('members: ' + str(lst.members))
    

        
# -----------------------------------------------------------
log.info("ICOS mailman sync finished")
log.info("-------------------------------------------")

# -- EOF --- ICOS mailman sync finished








