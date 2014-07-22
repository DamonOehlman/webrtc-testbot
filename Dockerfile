FROM ubuntu:14.04
MAINTAINER Damon Oehlman <damon.oehlman@nicta.com.au>

# add resources
ADD ./resource/scripts/ /tmp/

# use aarnet mirror for quicker building while developing
RUN sed -i 's/archive.ubuntu.com/mirror.aarnet.edu.au\/pub\/ubuntu\/archive/g' /etc/apt/sources.list

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

# configure video loopback
RUN /tmp/setup-loopbackvideo.sh

# create the testbot user
RUN useradd -p testbot testbot
RUN mkdir -p /home/testbot
RUN chown testbot /home/testbot

# install chrome
ENV CHROME_VERSION stable
RUN /tmp/install-chrome.sh
