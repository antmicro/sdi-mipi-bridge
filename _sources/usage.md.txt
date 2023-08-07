# Running the video stream

Streaming from the SDI-MIPI bridge to the chosen board is done through the MIPI CSI interface in a 2 or 4 lane configuration.
The SDI to MIPI bridge supports only the YUV422 format in 1080p (30 or 60 FPS) or 720p (60 FPS) resolution.

## Loading the bitstream

Different resolutions and framerates require different bitstreams.
Therefore the FPGA manager subsystem in the Linux kernel is used to reprogram the FPGA as needed.
In order to load the bitstream, first place it in the `/lib/firmware/sdi_bridge` directory as this is the path where the FPGA Manager looks for files to load.
Once that is done, pass the bitstream's filename to the `load` node and wait until the process is finished.

```bash
echo "sdi_bridge/<bitstream_name.bit>" | sudo tee /sys/class/fpga_manager/fpga0/load
```

When the bitstream is loaded, the `CDONE` LED should be blinking and the `USER_LED` should be turned on. The `USER_LED` is wired to the `tInit` output of the CMOS to D-PHY IP core which activates when the core has been initialized.

:::{note}
The `DAT_ERROR` LED is turned on if there are no errors and turns off if data errors occur.
:::

By default there are bitstreams for each supported video format located in the `/lib/firmware/sdi_bridge` directory.
Default bitstreams are named with the following pattern:

```bash
<video_format>-<lanes>.bit
```

For example, to load the 1080p60 2-lanes variant:

```bash
echo "sdi_bridge/1080p60-2lanes.bit" | sudo tee /sys/class/fpga_manager/fpga0/load
```

:::{important}
The lane count of the uploaded bitstream variant must match the device tree used in your Linux kernel.
:::

## Setting up the stream

If valid SDI signal is present on the SDI-MIPI bridge input, the `LOCKED` LED turns on.
It indicates that the deserializer was able to acquire lock to the input signal.
To be able to get the proper video data on the device, the video source has to stream in YUV422 format.

## Testing the video stream

:::{note}
If you see incorrect colors or there is no picture, try pressing the reset button on the SDI Bridge. If that doesn't help, reload the bitstream.
:::

:::::{md-tab-set}

::::{md-tab-item} Jetson Xavier NX & TX2

To test the video stream, you can launch e.g. `gstreamer` as follows:

```bash
gst-launch-1.0 v4l2src device=/dev/video0 ! 'video/x-raw,width=<width>,height=<height>' ! xvimagesink
```

The `<width>` and `<height>` parameters should match the currently used bitstream and SDI video resolution, either `1920x1080` or `1280x720`.
::::

::::{md-tab-item} Raspberry Pi CM4

To test the video stream, you can use e.g. `qv4l2` app.
There, you should set the expected pixel format and resolution according to the video source and loaded bitstream.

```{note}
Raspberry Pi currently supports only 4-lanes variants.
```

Also, the `v4l2-ctl` tool can be used to grab frames:

```bash
v4l2-ctl --stream-mmap --set-fmt-video=width=<width>,height=<height>,pixelformat=VYUY --stream-count=0 --stream-to=/dev/null
```

The `<width>` and `<height>` parameters should match the currently used bitstream and SDI video format, either `1920x1080` or `1280x720`.
To write captured frames to a file, set your target destination with `--stream-to=`.
To get the exact number of frames grabbed, set `--stream-count=`.

::::
:::::
