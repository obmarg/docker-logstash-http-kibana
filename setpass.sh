#!/bin/bash

echo "$1:$(openssl passwd -1 $2)" >> /etc/nginx/conf.d/kibana.htpasswd
echo "$1:$(openssl passwd -1 $2)" >> /etc/nginx/conf.d/logstash-http.htpasswd
