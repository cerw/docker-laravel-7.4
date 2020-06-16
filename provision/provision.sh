#!/bin/bash
# ------------------------------------------------------------------------------
# Provisioning script for the docker-laravel image
# ------------------------------------------------------------------------------
apt-get upgrade -y -o Dpkg::Options::="--force-confold"

# ------------------------------------------------------------------------------
# PHP7
# ------------------------------------------------------------------------------

# install PHP
apt-get -y install curl php-zip zip php7.2-gd unzip bzip2 php-cli php-imagick imagemagick git \
php-curl php-xml  php7.2-sqlite3 php-mbstring php-xml php-mysqlnd php-curl php-xdebug \
memcached php-memcached php7.2-soap build-essential libpng-dev openntpd php7.2-bcmath mysql-client-5.7 ghostscript

# Cypress

apt-get install -y  libgtk2.0-0  libnotify-dev  libgconf-2-4  libnss3 libxss1 libasound2 xvfb

# install latex
apt-get -yqq install texlive-latex-base texlive-fonts-recommended texlive-fonts-extra  texlive-latex-extra latexmk

/usr/bin/timedatectl set-timezone Australia/Perth

#phpdismod xdebug
#hpdismod -s cli xdebug

# ------------------------------------------------------------------------------
# Composer PHP dependency manager
# ------------------------------------------------------------------------------

curl -sS https://getcomposer.org/installer -o composer-setup.php
php composer-setup.php --install-dir=/usr/local/bin --filename=composer
rm ./composer-setup.php
chmod 755 /usr/local/bin/composer

# ------------------------------------------------------------------------------
# Node and npmu
# ------------------------------------------------------------------------------

curl -sL https://deb.nodesource.com/setup_10.x | bash -
apt-get -yqq install nodejs

# curl -sL https://deb.nodesource.com/setup_8.x | bash -
# apt-get -yqq install nodejs

useradd automation --shell /bin/bash --create-home
# Chrome Driver

apt-get -yqq install supervisor vim fonts-ipafont-gothic xfonts-cyrillic xfonts-100dpi xfonts-75dpi xfonts-base xfonts-scalable

CHROMEDRIVER_VERSION=`curl -sS chromedriver.storage.googleapis.com/LATEST_RELEASE`
mkdir -p /opt/chromedriver-$CHROMEDRIVER_VERSION && \
curl -sS -o /tmp/chromedriver_linux64.zip http://chromedriver.storage.googleapis.com/$CHROMEDRIVER_VERSION/chromedriver_linux64.zip && \
unzip -qq /tmp/chromedriver_linux64.zip -d /opt/chromedriver-$CHROMEDRIVER_VERSION && \
rm /tmp/chromedriver_linux64.zip && \
chmod +x /opt/chromedriver-$CHROMEDRIVER_VERSION/chromedriver && \
ln -fs /opt/chromedriver-$CHROMEDRIVER_VERSION/chromedriver /usr/local/bin/chromedriver

# Chrome Browser
curl -sS -o - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - && \
echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list && \
apt-get -yqq update && \
apt-get -yqq install google-chrome-stable ca-certificates xfonts-75dpi xfonts-base libjpeg62-turbo

#wkhtml
wget https://github.com/wkhtmltopdf/packaging/releases/download/0.12.6-1/wkhtmltox_0.12.6-1.buster_amd64.deb
dpkg -i wkhtmltox_0.12.6-1.buster_amd64.deb
rm -rf wkhtmltox_0.12.6-1.buster_amd64.deb

# ------------------------------------------------------------------------------
# Clean up
# ------------------------------------------------------------------------------
rm -rf /provision
