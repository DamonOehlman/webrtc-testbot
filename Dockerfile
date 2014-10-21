FROM ubuntu:14.04
MAINTAINER Damon Oehlman <damon.oehlman@nicta.com.au>

# configure environment
ENV CHROME_DEB google-chrome-stable_current_amd64.deb
ENV CHROME_SANDBOX /opt/google/chrome/chrome-sandbox
ENV HOME /home/testbot

# use aarnet mirror for quicker building while developing
# RUN sed -i 's/archive.ubuntu.com/mirror.aarnet.edu.au\/pub\/ubuntu\/archive/g' /etc/apt/sources.list

# create the testbot user
RUN mkdir -p /home/testbot
RUN useradd --password testbot --home /home/testbot testbot
RUN chown testbot:testbot /home/testbot
WORKDIR /home/testbot

# install wget and curl
RUN apt-get -y update
RUN apt-get install -y curl wget software-properties-common

# include the nodesource node install
RUN curl -sL https://deb.nodesource.com/setup | bash -

# include gstreamer
RUN add-apt-repository -y ppa:gstreamer-developers/ppa

# update sources
RUN apt-get -y update --fix-missing

# install packages
RUN apt-get install -y nodejs git xvfb build-essential git xfonts-100dpi xfonts-75dpi xfonts-scalable xfonts-cyrillic

# TODO: configure video loopback
# RUN /tmp/setup-loopbackvideo.sh

# install chrome
RUN wget https://dl.google.com/linux/direct/$CHROME_DEB
RUN dpkg --install --force-overwrite --force-confdef $CHROME_DEB || sudo apt-get -y -f install
RUN apt-get install -y -q

# workaround chrome sandbox limitations in containers
RUN rm -f $CHROME_SANDBOX
RUN wget https://googledrive.com/host/0B5VlNZ_Rvdw6NTJoZDBSVy1ZdkE -O $CHROME_SANDBOX
RUN chmod 4755 $CHROME_SANDBOX

# set the app SHA
ENV APP_SHA e646165e97b60f74d67bbf4e3491b82b2900c615

# run up testbot
RUN mkdir -p /srv/testbot
RUN chown testbot:testbot /srv/testbot
WORKDIR /srv/testbot

# run as testbot
RUN sudo -u testbot wget https://github.com/rtc-io/testbot/archive/$APP_SHA.tar.gz -O app.tar.gz
RUN sudo -u testbot tar xf app.tar.gz --strip-components=1
RUN rm app.tar.gz

# run the app
EXPOSE 6633
CMD ["make", "server"]
