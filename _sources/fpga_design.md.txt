# Building the FPGA design

The CrossLink FPGA is responsible for converting data deserialized from SDI by the Semtech chip to MIPI CSI-2.
The FPGA design consists of 2 main parts:

* [Top module](src/top.py) - module written in Python with [Migen](https://m-labs.hk/gateware/migen/) to instantiate and connect required FPGA components such as Oscillator and CMOS2DPHY converter.
* [Lattice CMOS to D-PHY IP](https://www.latticesemi.com/en/Products/DesignSoftwareAndIP/IntellectualProperty/IPCore/IPCores04/CMOStoMIPICSI2InterfaceBridge) - converts standard parallel video data into CSI-2 byte packets.

## CMOS to MIPI D-PHY

The Lattice CMOS to D-PHY IP core provides a bridging solution for converting parallelized pixel data from the deserializer into a MIPI CSI-2 video stream.
The configuration of the IP core depends on the selected resolution and framerate.
Therefore a different bistream needs to be used for some of the supported video formats.

#### Multiple variant support

Since the [Lattice CMOS to D-PHY IP Core](https://www.latticesemi.com/en/Products/DesignSoftwareAndIP/IntellectualProperty/IPCore/IPCores04/CMOStoMIPICSI2InterfaceBridge) can not be dynamically reconfigured for different resolutions, the video parameters need to be specified at build time.
The table below summarizes the parameters used for the supported resolutions:

```{csv-table}
:file: cmos2dphy_params.csv
:header-rows: 1
```

## Setting up the environment

The design in [the FPGA design repository](https://github.com/antmicro/sdi-mipi-bridge-fpga-design) requires the Lattice Diamond tool for generating the bitstream.
For instructions on installing and using Diamond, please refer to the [Lattice Diamond 3.12 Installation Guide for Linux](https://www.latticesemi.com/view_document?document_id=53082).

Additionally, make sure that you have the sources of the CMOS to D-PHY 1.3 IP-Core installed using Diamond Clarity Designer.
For more information, check the _Accomplishing Tasks with Clarity Designer_ section from [Clarity Designer User Manual](https://www.latticesemi.com/view_document?document_id=52649) (p. 16).

Once you have Diamond set up, install the Python prerequisites:

```bash
pip3 install -r requirements.txt
```

## Building the bitstream

After you've prepared your environment, you can build the project with a `make`-based build flow by running:

```bash
make <video-format>-<lanes>
```

The output files will be generated in the `build/<video-format>-<lanes>` directory.
For example, to produce a bitstream for the 1280x720 resolution with a 2-lane data bus, execute:

```bash
make 720p_hd-2lanes
```

The build files will be located in the `build/720p_hd-2lanes` directory.

There are 3 bitstream variants for different video formats, each of them can be built for either two or four MIPI CSI-2 lanes:

* `720p_hd` supports `720p25`, `720p30`, `720p50` and `720p60`,
* `1080p_hd` supports `1080p25` and `1080p30`,
* `1080p_3g` supports `1080p50` and `1080p60`.

