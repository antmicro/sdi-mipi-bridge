#!/bin/bash

set -e

FILE=$(basename "$0")
SUPPORTED_FORMATS=("720p25" "720p30" "720p50" "720p60" "1080p25" "1080p30" "1080p50" "1080p60")
IS_SUPPORTED=0

HELP_MSG="Usage: $FILE [VIDEO_FORMAT]\n\
Load a bistream for supported VIDEO_FORMAT to two SDI-MIPI bridges and display the video stream using the gstreamer tool.\n\n\
\
VIDEO_FORMAT must be one of following:
"

NOT_SUPPORTED_MSG="$FILE: Video format not supported.\n\
Try '$FILE --help' for more information."

if [[ "$1" == "--help" ]]; then
    echo -e $HELP_MSG
    for f in ${SUPPORTED_FORMATS[@]}; do
        echo -e "- $f"
    done
    echo ""
    echo "Example: $FILE 1080p60"
    exit 0
elif [[ -z $1 ]]; then
    echo "$FILE: Video format not provided."
    echo "Try '$FILE --help' for more information."
    exit 1
else
    for f in ${SUPPORTED_FORMATS[@]}; do
        if [[ "$1" == "$f" ]]; then
            if [[ "$1" =~ ^720p(25|30|50|60) ]]; then
                WIDTH=1280
                HEIGHT=720
                BITSTREAM=sdi_bridge_720p60.bit
            elif [[ "$1" =~ ^1080p(25|30) ]]; then
                WIDTH=1920
                HEIGHT=1080
                BITSTREAM=sdi_bridge_1080p30.bit
            elif [[ "$1" =~ ^1080p(50|60) ]]; then
                WIDTH=1920
                HEIGHT=1080
                BITSTREAM=sdi_bridge_1080p60.bit
            else
                echo -e $NOT_SUPPORTED_MSG
                exit 1
            fi
            IS_SUPPORTED=1
        fi
    done
fi

if [[ $IS_SUPPORTED == 0 ]]; then
    echo -e $NOT_SUPPORTED_MSG
    exit 1
fi

trap 'kill $VID0_PID $VID1_PID' SIGINT SIGTERM

echo "Loading FPGA bitstream..."
echo "sdi_bridge/$BITSTREAM" | sudo tee /sys/class/fpga_manager/fpga0/load
echo "sdi_bridge/$BITSTREAM" | sudo tee /sys/class/fpga_manager/fpga1/load

export DISPLAY=$(sudo strings /proc/$(pgrep -u $USER gnome-session-b)/environ | grep DISPLAY | cut -d'=' -f 2)

echo "Stream start"
gst-launch-1.0 v4l2src device=/dev/video0 ! video/x-raw,width=$WIDTH,height=$HEIGHT ! xvimagesink &
VID0_PID=$!
gst-launch-1.0 v4l2src device=/dev/video1 ! video/x-raw,width=$WIDTH,height=$HEIGHT ! xvimagesink &
VID1_PID=$!

wait
