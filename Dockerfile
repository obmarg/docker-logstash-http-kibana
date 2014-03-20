FROM base
MAINTAINER Graeme Coupar "http://github.com/obmarg"

RUN apt-get update

# Install JDK & logstash
RUN apt-get install -y wget openjdk-6-jre
RUN wget http://logstash.objects.dreamhost.com/release/logstash-1.1.13-flatjar.jar -O /opt/logstash.jar --no-check-certificate
ADD logstash.conf /opt/logstash.conf

# Install nginx
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y wget nginx-full
# Remove the default nginx site
RUN rm -f /etc/nginx/sites-enabled/default
ADD nginx-site.conf /etc/nginx/sites-available/es-kibana
RUN ln -s /etc/nginx/sites-available/es-kibana /etc/nginx/sites-enabled/es-kibana
# TODO: Restart nginx?
# TODO: Create password files

# Install Kibana
# TODO: Update this to latest version
# TODO: Update the path to something else if needed
RUN (cd /tmp && wget --no-check-certificate https://github.com/elasticsearch/kibana/archive/v3.0.0milestone2.tar.gz -O pkg.tar.gz && tar zxf pkg.tar.gz && cd kibana-* && cp -rf ./* /usr/share/nginx/www/)
# TODO: Configure Kibana

# Install gunicorn
RUN apt-get install -y python-pip
RUN pip install --user gunicorn==18.0

# Setup logstash-gae-http
RUN apt-get install -y git python-dev
RUN git clone https://github.com/obmarg/gae-logstash-http.git
RUN pip install --user -r gae-logstash-http/requirements.txt
# TODO: May need to setup env variable for user python path

# Note: These next ones should probably be run on startup.
#
# TODO: Run a sed on /opt/logstash to get $ES_HOST into it.
# TODO: Run a sed on the nginx site file to set up shit in it
