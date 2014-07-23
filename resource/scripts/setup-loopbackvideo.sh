#!/usr/bin/env bash
set -x
set -e

sudo apt-get install -y linux-headers-$(uname -r) gstreamer1.0-tools gstreamer1.0-libav gstreamer1.0-plugins-good libvpx1 libopus0

# compile the v4l loopback driver
git clone git://github.com/umlaeute/v4l2loopback.git
cd v4l2loopback
make && sudo make install

# ensure the loopback video device is loaded
sudo modprobe v4l2loopback

# note new video device to use below
ls -ld /dev/video*

# create a fake video source
gst-launch-1.0 videotestsrc pattern=smpte100 ! v4l2sink device=/dev/video0 &
