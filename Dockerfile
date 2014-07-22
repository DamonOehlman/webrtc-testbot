FROM ubuntu:14.04
MAINTAINER Damon Oehlman <damon.oehlman@nicta.com.au>

# install required deps
RUN apt-get -y update
RUN apt-get install -y git curl software-properties-common wget xvfb

# include the nodesource node install
RUN curl -sL https://deb.nodesource.com/setup | bash -

# include google chrome into sources
RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -
RUN echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list
RUN apt-get -y update

# install chrome and node
RUN apt-get install -y google-chrome-stable nodejs

# create the testbot user
RUN useradd -p testbot testbot
RUN mkdir -p /home/testbot
RUN chown testbot /home/testbot
