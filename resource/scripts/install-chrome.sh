#!/usr/bin/env bash
set -x
set -e

DEB_CHROME=google-chrome-${CHROME_VERSION}_current_amd64.deb

wget https://dl.google.com/linux/direct/$DEB_CHROME
sudo dpkg --install --force-overwrite --force-confdef $DEB_CHROME || sudo apt-get -y -f install
