# ------------------------------------------------------------------------------
# Start with a base image
# ------------------------------------------------------------------------------

FROM ubuntu:20.04
LABEL maintainer "Petr Cervenka <petr@cervenka.space>"
LABEL version="0.7"
ENV DEBIAN_FRONTEND noninteractive
ENV DEBCONF_NONINTERACTIVE_SEEN true
# ------------------------------------------------------------------------------
# Provision the server
# ------------------------------------------------------------------------------

ENV DISPLAY :20.0
ENV SCREEN_GEOMETRY "2304x1440x24+32"
ENV CHROMEDRIVER_PORT 9515
ENV CHROMEDRIVER_WHITELISTED_IPS ""
ENV CHROMEDRIVER_URL_BASE ""

# "fake" dbus address to prevent errors
# https://github.com/SeleniumHQ/docker-selenium/issues/87
ENV DBUS_SESSION_BUS_ADDRESS=/dev/null

RUN mkdir /provision
ADD provision /provision

RUN /provision/provision.sh
ENV DBUS_SESSION_BUS_ADDRESS=/dev/null

# a few environment variables to make NPM installs easier
# good colors for most applications
ENV TERM xterm
# avoid million NPM install messages
ENV npm_config_loglevel warn
# allow installing when the main user is root
ENV npm_config_unsafe_perm true

ENV LANG en_US.utf8

ADD ./etc/supervisord.conf /etc/
ADD ./etc/supervisor /etc/supervisor
ADD ./etc/ImageMagick-6/policy.xml /etc/ImageMagick-6/policy.xml
VOLUME [ "/var/log/supervisor" ]
# CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]

# EXPOSE 5900
# EXPOSE 8081
