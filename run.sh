#!/bin/bash

LOGSTASH_CONF=/opt/logstash.conf
SITE_CONF=/etc/nginx/sites-available/es-kibana 

ES_HOST=$ES_PORT_9200_TCP_ADDR
ES_PORT=$ES_PORT_9200_TCP_PORT
ES_TRANSPORT_HOST=$ES_PORT_9300_TCP_ADDR
ES_TRANSPORT_PORT=$ES_PORT_9300_TCP_PORT

# Configure logstash
sed "s/{{ES_HOST}}/$ES_TRANSPORT_HOST/" $LOGSTASH_CONF > $LOGSTASH_CONF
sed "s/{{ES_TRANSPORT_PORT}}/$ES_TRANSPORT_PORT/" $LOGSTASH_CONF > $LOGSTASH_CONF

# Configure nginx
sed "s/{{ES_HOST}}/$ES_HOST/" $SITE_CONF > $SITE_CONF
sed "s/{{ES_PORT}}/$ES_PORT/" $SITE_CONF > $SITE_CONF
sed "s/{{MY_HOST}}/$MY_HOST/" $SITE_CONF > $SITE_CONF

java -jar /opt/logstash.jar agent -f /opt/logstash.conf &
nginx -c /etc/nginx/nginx.conf &

cd gae-logstash-http
../.local/bin/gunicorn -w 2 app:app
