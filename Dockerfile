# To build the Docker image:
#
#   $ sudo systemctl start docker
#   $ sudo docker build -t printer .
#
# To run it:
#
#   $ sudo docker run -d -p 9393:9393 -t printer
#
# To push to repository:
#
#   $ sudo docker login
#   $ sudo docker tag printer docker.io/strzibnyj/invoice_printer_server:latest
#   $ sudo docker push strzibnyj/invoice_printer_server:$VERSION
#   $ sudo docker push strzibnyj/invoice_printer_server:latest
FROM alpine:3.13
MAINTAINER Josef Strzibny <strzibny@strzibny.name>

ENV GEM_HOME="/usr/local/bundle"
ENV PATH $GEM_HOME/bin:$GEM_HOME/gems/bin:$PATH

# Update system
RUN apk update && apk upgrade

# Install Ruby and build dependencies
RUN apk add build-base bash ruby ruby-etc ruby-dev

# Install builtin fonts
RUN gem install invoice_printer_fonts --version 2.3.0 --no-document

# Install the gem from RubyGems.org
RUN gem install invoice_printer_server --version 2.3.0 --no-document

# Clean APK cache
RUN rm -rf /var/cache/apk/*

# Run the server on port 80
ENTRYPOINT ["/usr/local/bundle/bin/invoice_printer_server", "-p9393"]
