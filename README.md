docker-logstash-http-kibana
======

This repository contains a Dockerfile for creating the
obmarg/logstash-http-kibana image.  

This docker contains a logstash, & kibana setup, with
[gae-logstash-http](https://github.com/obmarg/gae-logstash-http) setup for
pulling in Google App Engine logs from HTTP.

This docker image does not contain an elasticsearch server - an external docker
image is required for that.  The nginx contained in this image will act as a
forwarding proxy to elasticsearch though.

Manual Setup
----

First, setup a docker with elasticsearch.  To use the recommended image:

    docker run -name es -d dockerfile/elasticsearch

Then, to create a password for your http kibana setup:

    docker run -t -i obmarg/logstash-http-kibana setpass.sh <uname> <pword>

The changes to password will need saved as part of a docker image.  To get the
container ID of the image you just ran.

    docker ps -a
    
The first container in the list should show the container ID that setpass.sh
was run within.  To commit that, pick a name and run:

    docker commit <container_id> <name>

Finally, to run the docker image:

    docker run -d -p 3000:80 -e MY_HOST=<localhost> -link es:es <name> run.sh

Where <localhost> is the hostname of your server, and <name> is the name you
selected above.

Building
--------

To build the docker image from scratch:

    docker build .

Take note of the generated ID, and pass it in to the Manual Setup steps above.


Building a Dockerfile for deployment
----

This docker image contains everything required, but does not have any
credentials setup by default.  An example Dockerfile that sets up a username &
password is below:

```
FROM obmarg/logstash-http-kibana
RUN setpass.sh <uname> <pword>
EXEC run.sh
```

After building, this docker should be ready to run, by running:

    docker run -d -p 3000:80 -e MY_HOST=<localhost> -link es:es <image_name>
