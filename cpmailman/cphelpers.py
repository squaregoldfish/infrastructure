# -*- coding: utf-8 -*-

"""This file contains common functions, tools and utilities"""
__version__= "0.1.0"


# load necessary modules
import requests

# create helper functions

#---------------------------------------------------------------------
def stationQString(*args):
    """
        Define SPARQL query to get a list of ICOS stations with PI and email
    """
    query = """
            prefix st: <http://meta.icos-cp.eu/ontologies/stationentry/>
            select distinct ?stationTheme ?stationId ?stationName ?firstName ?lastName ?email
            from <http://meta.icos-cp.eu/resources/stationentry/>
            where{
                ?s st:hasShortName ?stationId .
                ?s st:hasLongName ?stationName .
                ?s st:hasPi ?pi .
                ?pi st:hasFirstName ?firstName .
                ?pi st:hasLastName ?lastName .
                ?pi st:hasEmail ?email .
                ?s a ?stationClass .
                BIND (replace(str(?stationClass), "http://meta.icos-cp.eu/ontologies/stationentry/", "") AS ?stationTheme )
            }            
            limit 5
        """ 

    return query
#------------------------------------------------------------------------------
def sparql(queryString):
    """
        This functions queries the ICOS sparql endpoint
        with param1, queryString. By default the returned object
        is a python tuble with two arrays.
        The first array contains the column names and the second array
        contains the "result" (binding) in each row.        
    """
        
    # Query the ICOS SPARQL endpoint for a station list
    # output is an object "data" containing the results in JSON    
    #------------------------------------------------------------------------
    
    
    url = 'https://meta.icos-cp.eu/sparql'
    r = requests.get(url, params={
        'format': 'json',
        'query': queryString()})
            
    if not r.ok:
        return r.ok, r.reason
    
    data = r.json()    
    #------------------------------------------------------------------------
    
    # convert the the result into two arrays
    # cols = column names
    # datatable = results
    
    cols = data['head']['vars']
    datatable = []
    
    for row in data['results']['bindings']:
        item = []
        for c in cols:
            item.append(row.get(c, {}).get('value'))
    
        datatable.append(item)
    
    return cols, datatable
#------------------------------------------------------------------------------
def cleanStr(txt):
    
    #remove whitespace
    txt = txt.replace(' ','')
        # make sure everythig is lowercase    
    txt = txt.lower()
    
    return txt

    
#-----------------------------------------------------------------

def is_number(num):
    """
    check if param can be converted to a float
    param: 
    return: bool [True|False]
    """
    try:
        float(num)
        return True
    except ValueError:
        return False

#-----------------------------------------------------------------
 
def debugPrint(dbg, msg):
    """    
    prints debug information to the console if param1 is "True"
    param1: bool (True|False)
    param2: String or object which is printablemessage
    """
    if(dbg):
        print(msg)
        
#-----------------------------------------------------------------

def checklib(module):
    """ load a list of modoules if available, otherwise throw exception """
    import imp
    for mod in module:
        try:
            imp.find_module(mod)
            ret = 1
        except ImportError as imperror:
            print(imperror)
            ret = 0
    return ret






























    