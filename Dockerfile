# ------------------------------------------------------------------------------
# Start with a base image
# ------------------------------------------------------------------------------

FROM ubuntu:18.04
LABEL maintainer "Petr Cervenka <petr@cervenka.space>"
LABEL version="0.6"
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

RUN mkdir /provision
ADD provision /provision
RUN /provision/provision.sh

RUN apt-get update && apt-get install -y locales && rm -rf /var/lib/apt/lists/* \
    && localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8
ENV LANG en_US.utf8

ADD ./etc/supervisord.conf /etc/
ADD ./etc/supervisor /etc/supervisor
ADD ./etc/ImageMagick-6/policy.xml /etc/ImageMagick-6/policy.xml
VOLUME [ "/var/log/supervisor" ]
# CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]

EXPOSE 5900
EXPOSE 8081
