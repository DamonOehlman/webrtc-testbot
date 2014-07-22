FROM ubuntu:14.04
MAINTAINER Damon Oehlman <damon.oehlman@nicta.com.au>

# initialise a few environment variables
ENV CHROME_VERSION stable

# add resources
ADD ./resource/scripts/ /tmp/

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
RUN apt-get install -y nodejs git xvfb build-essential git

# install chrome
RUN /tmp/install-chrome.sh

# configure video loopback
RUN /tmp/setup-loopbackvideo.sh

# create the testbot user
RUN useradd -p testbot testbot
RUN mkdir -p /home/testbot
RUN chown testbot /home/testbot
