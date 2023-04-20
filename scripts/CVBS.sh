#!/bin/bash

set -e

trap 'kill $VID0_PID $VID1_PID' SIGINT SIGTERM

export DISPLAY=$(sudo strings /proc/$(pgrep -u $USER gnome-session-b)/environ | grep DISPLAY | cut -d'=' -f 2)

echo "Set video format"
v4l2-ctl -d0 --set-fmt-video=pixelformat=UYVY
v4l2-ctl -d1 --set-fmt-video=pixelformat=UYVY

echo "Stream start"
gst-launch-1.0 v4l2src device=/dev/video0 ! 'video/x-raw,width=720,height=576' ! xvimagesink &
VID0_PID=$!
gst-launch-1.0 v4l2src device=/dev/video1 ! 'video/x-raw,width=720,height=576' ! xvimagesink &
VID1_PID=$!

wait
