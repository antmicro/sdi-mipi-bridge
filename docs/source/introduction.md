# Introduction

This documentation describes Antmicro's open source [SDI to MIPI CSI-2 Bridge](https://github.com/antmicro/sdi-mipi-bridge) which is a Lattice Crosslink FPGA-based converter board between SDI, a popular standard used in integrated video cameras for e.g. broadcasting, and MIPI CSI-2, a mobile/embedded camera standard supported directly by a variery of embedded SoCs.

The SDI bridge is a completely open source device (including KiCad PCB design files, software and FPGA designs), part of Antmicro's [broad open source hardware portfolio](https://openhardware.antmicro.com/boards/).

## Structure

The documentation includes all the information necessary to use the SDI bridge in a practical scenario, with the following chapters:

* {doc}`hardware` - description of the hardware, physical connections and configurations,
* {doc}`fpga_design` - how to generate FPGA bitstreams for all available SDI signal configurations,
* {doc}`software` - how to build and use a Linux BSP supporting the SDI bridge for several example embedded boards,
* {doc}`usage` - how to upload a bitstream and display the resulting video stream,
* {doc}`timing_gen` - more detailed description of the timing generator block features.

(services)=
## Custom engineering services

The SDI bridge is a development board and prototyping platform for building customized devices - Antmicro offers custom hardware, software and FPGA engineering services for this and other FPGA-based video processing use cases, including:

* integrating the SDI bridge with other embedded plaforms
* custom, integrated embedded boards with SDI input directly on the same PCB
* BSPs and drivers for embedded video systems
* advanced FPGA-based processing platforms
* FPGA video processing pipelines
* AI processing and pipelines

If you are interested in learning more, please reach out at [contact@antmicro.com](mailto:contact@antmicro.com) and let us know about your requirements.
