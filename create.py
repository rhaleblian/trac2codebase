"""
Writes Trac DB as XML in Codebase schema, on stdout.
"""

import logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger('t2x')

import base64
import datetime
import httplib
import urllib2
from trac.env import Environment
from trac.db import with_transaction
from xml.etree import ElementTree
from xml.dom.minidom import Document
from xml.sax.saxutils import escape

import config

# Trac
projenv = config.projenv
users = config.users
dbversion = config.dbversion

# Codebase
project = config.project
username = config.username
apikey = config.apikey

logger.debug('key: %s' % apikey)


def transact(url, user, apikey, xml=None):
    request = urllib2.Request(url)
    base64string = base64.encodestring('%s:%s' % ('account/rhaleblian', apikey)).replace('\n', '')
    request.add_header("Authorization", "Basic %s" % base64string)
    request.add_header('Content-type', 'application/xml')
    request.add_header('Accept', 'application/xml')
    result = urllib2.urlopen(request, xml)
    for line in result.readlines(): print line,

 
def tractime2codebasetime(value):
    """ Infer whether time is in seconds (pre-0.12)
    or microseconds (0.12+) since the epoch. """
    if value > 9999999999:
        dt = datetime.date.fromtimestamp(value * .000001)
    else:
        dt = datetime.date.fromtimestamp(value)
    return '%s-%s-%s' % (dt.year, dt.month, dt.day)


env = Environment(projenv)
@with_transaction(env)
def main(db):
    """ Output XML in the Codebase schema. """

    priorities = set()
    statuses = set()

    xml = """<?xml version="1.0" encoding="utf-8"?>
<!--
  -- Dump of Trac database as XML tree.
  -- Elements conform to Codebase API schema.
  -->
<project>
"""

    # First, gather status and priority labels.

    q = """select type,name,value from enum"""
    cursor = db.cursor()
    cursor.execute(q)
    idd = 100
    for typee,name,value in cursor:
        if typee == 'status':
            xml += """
<ticketing-status>
  <name>%s</name>
  <background-colour>9ac130</background-colour>
  <order type="integer">%d</order>
  <treat-as-closed type="boolean">false</treat-as-closed>
</ticketing-status>
""" % (name,int(value))
            statuses.add(name)

        elif typee == 'priority':
            xml += """
<ticketing-priority>
  <name>%s</name>
  <colour>666666</colour>
  <default type="boolean">false</default>
  <position type="integer">%d</position>
</ticketing-priority>
""" % (name,int(value))
            priorities.add(name)

        idd += 1

    # Milestones.

    q = """select name,due,completed,description from milestone"""
    cursor = db.cursor()
    cursor.execute(q)

    for(name,
        due,
        completed,
        description) in cursor:
        
        due = tractime2codebasetime(due) 
       
        xml += '<ticketing-milestone><name>%s</name><description>%s</description><start-at type="date">%s</start-at><deadline type="date">%s</deadline><parent-id type="integer" nil="true"/><status>%s</status></ticketing-milestone>' % (name, description, due, due, 'active')
        
    # Tickets.

    q = 'select id,type,time,changetime,component,severity,priority,owner,reporter,cc,version,milestone,status,resolution,summary,description,keywords from ticket'
    cursor = db.cursor()
    cursor.execute(q)
    idd = 2
    for (idd,typee,time,changetime,component,severity,priority,
         owner,reporter,cc,version,milestone,status,resolution,
         summary,description,keywords) in cursor:
        
        xml += """
<ticket>
  <summary>%s</summary>
  <ticket-type>%s</ticket-type>
  <reporter-id type="integer">%s</reporter-id>
  <assignee-id type="integer">%s</assignee-id>
  <assignee>%s</assignee>
  <reporter>%s</reporter>
  <category-id type="integer">%s</category-id>
  <priority-id type="integer">%s</priority-id>
  <status-id type="integer">%s</status-id>
  <milestone-id type="integer" nil="true"/>
</ticket>
""" % (summary, typee, reporter,
       owner, reporter, owner, component, priority, status)

    idd = idd+1

    # Ticket change history.

    q = 'select ticket,time,author,field,oldvalue,newvalue from ticket_change'
    cursor = db.cursor()
    cursor.execute(q)
    idd = 1
    for ticket,time,author,field,oldvalue,newvalue in cursor:
        logging.info(field)
        if field == 'status':
            xml += """
<ticket-note>
    <content>Status Updated</content>
    <changes>
        <status-id>%s</status-id>
        <assignee-id></assignee-id>
        <milestone-id></milestone-id>
        <summary>The previous status was %s.</summary>
    </changes>
</ticket-note>
""" % (newvalue, oldvalue)

        if field is 'priority':
            xml += """
<ticket-note>
    <content>Priority Updated</content>
    <changes>
        <priority-id>%s</priority-id>
        <assignee-id></assignee-id>
        <milestone-id></milestone-id>
        <summary>The previous priority was %s.</summary>
    </changes>
</ticket-note>
""" % (newvalue, oldvalue)
    
        if field is 'category':
            xml += """
<ticket-note>
    <content>Category Updated</content>
    <changes>
        <category-id>%s</category-id>
        <assignee-id></assignee-id>
        <milestone-id></milestone-id>
        <summary>The previous category was %s.</summary>
    </changes>
</ticket-note>
""" % (newvalue, oldvalue)


    xml += '</project>'
    print xml
