#!/bin/bash

LOGSTASH_CONF=/opt/logstash.conf
SITE_CONF=/etc/nginx/sites-available/es-kibana 

ES_HOST=$ES_PORT_9200_TCP_ADDR
ES_PORT=$ES_PORT_9200_TCP_PORT
ES_TRANSPORT_HOST=$ES_PORT_9300_TCP_ADDR
ES_TRANSPORT_PORT=$ES_PORT_9300_TCP_PORT

# TODO: At the moment these will only work on first run.  Fix that.
# Configure logstash
sed "s/{{ES_HOST}}/$ES_TRANSPORT_HOST/" -ibac $LOGSTASH_CONF
sed "s/{{ES_TRANSPORT_PORT}}/$ES_TRANSPORT_PORT/" -ibac2 $LOGSTASH_CONF

# Configure nginx
sed "s/{{ES_HOST}}/$ES_HOST/" -ibac $SITE_CONF
sed "s/{{ES_PORT}}/$ES_PORT/" -ibac2 $SITE_CONF
sed "s/{{MY_HOST}}/$MY_HOST/" -ibac3 $SITE_CONF

supervisord
