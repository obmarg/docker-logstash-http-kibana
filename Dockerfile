FROM dockerfile/java
MAINTAINER Graeme Coupar "http://github.com/obmarg"

RUN apt-get update

# Install logstash
RUN wget https://download.elasticsearch.org/logstash/logstash/logstash-1.3.3-flatjar.jar -O /opt/logstash.jar
ADD logstash.conf /opt/logstash.conf

# Install nginx
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y wget nginx-full
RUN echo "daemon off;" >> /etc/nginx/nginx.conf
# Remove the default nginx site and setup ours
RUN rm -f /etc/nginx/sites-enabled/default
ADD nginx-site.conf /etc/nginx/sites-available/es-kibana
RUN ln -s /etc/nginx/sites-available/es-kibana /etc/nginx/sites-enabled/es-kibana

# Install Kibana
RUN (cd /tmp && wget https://download.elasticsearch.org/kibana/kibana/kibana-latest.tar.gz -O pkg.tar.gz && tar zxf pkg.tar.gz && cd kibana-* && mkdir /usr/share/kibana3 && cp -rf ./* /usr/share/kibana3/)
RUN sed -i "s/elasticsearch:.*$/elasticsearch:\"\/\/\" + window.location.host,/" /usr/share/kibana3/config.js
RUN mv /usr/share/kibana3/app/dashboards/logstash.json /usr/share/kibana3/app/dashboards/default.json

# Install gunicorn
RUN apt-get install -y python-pip
RUN pip install --user gunicorn==18.0

# Install 0mq (needed for gae-logstash-http deps, and logstash)
RUN apt-get install -y libzmq-dev

# Setup logstash-gae-http
RUN apt-get install -y git python-dev
RUN git clone https://github.com/obmarg/gae-logstash-http.git
RUN pip install --user -r gae-logstash-http/requirements.txt

# Install SupervisorD
RUN apt-get install -y supervisor
RUN mkdir -p /var/log/supervisor
ADD supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Install our run script
ADD run.sh /usr/local/bin/run.sh
RUN chmod +x /usr/local/bin/run.sh

# Install our setpass script
ADD setpass.sh /usr/local/bin/setpass.sh
RUN chmod +x /usr/local/bin/setpass.sh

# Tidy up /tmp
RUN rm -Rf /tmp/*

CMD ["/usr/local/bin/run.sh"]
EXPOSE 80

