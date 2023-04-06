# Preparing the software

In order to be able to receive video from a SDI-MIPI Bridge, the receiver must include drivers for both the Semtech GS2971A deserializer and the FPGA manager for loading the bitstream.
Antmicro provides a preconfigured [Linux kernel](https://github.com/antmicro/sdi-mipi-bridge-linux) for the following devices:

* Jetson Xavier NX
* Jetson TX2
* Raspberry Pi CM4

## Building the BSP

To enable the SDI-MIPI Bridge support, you need to build the kernel with the required drivers and the device tree for the selected board.
Choose a tab that matches your board and follow the instructions below.

:::::{md-tab-set}

::::{md-tab-item} Jetson Xavier NX

The steps to fetch, build and apply it to a stock L4T 32.4.4 package are listed below.

1. Obtain and extract the cross-compilation toolchain:

```bash
wget http://releases.linaro.org/components/toolchain/binaries/7.3-2018.05/aarch64-linux-gnu/gcc-linaro-7.3.1-2018.05-x86_64_aarch64-linux-gnu.tar.xz
tar xf gcc-linaro-7.3.1-2018.05-x86_64_aarch64-linux-gnu.tar.xz
export PATH=$(pwd)/gcc-linaro-7.3.1-2018.05-x86_64_aarch64-linux-gnu/bin:$PATH
```

2. Obtain and set up the L4T-based host software:

```bash
wget https://developer.nvidia.com/embedded/L4T/r32_Release_v4.4/r32_Release_v4.4-GMC3/T186/Tegra186_Linux_R32.4.4_aarch64.tbz2
tar xf Tegra186_Linux_R32.4.4_aarch64.tbz2
wget https://developer.nvidia.com/embedded/L4T/r32_Release_v4.4/r32_Release_v4.4-GMC3/T186/Tegra_Linux_Sample-Root-Filesystem_R32.4.4_aarch64.tbz2
sudo tar xf Tegra_Linux_Sample-Root-Filesystem_R32.4.4_aarch64.tbz2 -C Linux_for_Tegra/rootfs/
pushd Linux_for_Tegra
sudo ./apply_binaries.sh
sudo chown -R $USER rootfs/lib/modules
sudo chown -R $USER rootfs/lib/firmware
popd
```

3. Obtain the kernel sources and choose the branch that matches your hardware:

```bash
git clone https://github.com/antmicro/sdi-mipi-bridge-linux
pushd sdi-mipi-bridge-linux
# git checkout master         # JNB rev. before 1.5+, data on 2 lanes
# git checkout jnb-4lanes     # JNB rev. before 1.5+, data on 4 lanes
# git checkout jnb_1.5-2lanes # JNB rev. 1.5+, data on 2 lanes
# git checkout jnb_1.5-4lanes # JNB rev. 1.5+, data on 4 lanes
```

4. Build the kernel:

```bash
export ARCH=arm64
export CROSS_COMPILE=aarch64-linux-gnu-
make tegra_defconfig
make -j$(nproc)
```

5. Install the kernel image, modules and device tree blob:

```bash
cp ./arch/arm64/boot/Image ../Linux_for_Tegra/kernel/
cp ./arch/arm64/boot/dts/tegra194-p3668-all-p3509-0000.dtb ../Linux_for_Tegra/kernel/dtb/
INSTALL_MOD_PATH=../Linux_for_Tegra/rootfs/ make modules_install
sudo chown -R root ../Linux_for_Tegra/rootfs/lib/modules
sudo chown -R root ../Linux_for_Tegra/rootfs/lib/firmware
popd
```

6. Copy the helper scripts from this repository to the root filesystem:

```bash
git clone https://github.com/antmicro/sdi-mipi-bridge
pushd sdi-mipi-bridge
cp -r scripts/* ../Linux_for_Tegra/rootfs/usr/local/bin/
popd
```

::::

::::{md-tab-item} Jetson TX2

The steps to fetch, build and apply it to a stock L4T 32.4.4 package are listed below.

1. Obtain and extract the cross-compilation toolchain:

```bash
wget http://releases.linaro.org/components/toolchain/binaries/7.3-2018.05/aarch64-linux-gnu/gcc-linaro-7.3.1-2018.05-x86_64_aarch64-linux-gnu.tar.xz
tar xf gcc-linaro-7.3.1-2018.05-x86_64_aarch64-linux-gnu.tar.xz
export PATH=$(pwd)/gcc-linaro-7.3.1-2018.05-x86_64_aarch64-linux-gnu/bin:$PATH
```

2. Obtain and set up the L4T-based host software:

```bash
wget https://developer.nvidia.com/embedded/L4T/r32_Release_v4.4/r32_Release_v4.4-GMC3/T186/Tegra186_Linux_R32.4.4_aarch64.tbz2
tar xf Tegra186_Linux_R32.4.4_aarch64.tbz2
wget https://developer.nvidia.com/embedded/L4T/r32_Release_v4.4/r32_Release_v4.4-GMC3/T186/Tegra_Linux_Sample-Root-Filesystem_R32.4.4_aarch64.tbz2
sudo tar xf Tegra_Linux_Sample-Root-Filesystem_R32.4.4_aarch64.tbz2 -C Linux_for_Tegra/rootfs/
pushd Linux_for_Tegra
sudo ./apply_binaries.sh
sudo chown -R $USER rootfs/lib/modules
sudo chown -R $USER rootfs/lib/firmware
popd
```

3. Obtain the kernel sources and choose the branch that matches your hardware:

```bash
git clone https://github.com/antmicro/sdi-mipi-bridge-linux
pushd sdi-mipi-bridge-linux
# git checkout master         # JNB rev. before 1.5+, data on 2 lanes
# git checkout jnb-4lanes     # JNB rev. before 1.5+, data on 4 lanes
# git checkout jnb_1.5-2lanes # JNB rev. 1.5+, data on 2 lanes
# git checkout jnb_1.5-4lanes # JNB rev. 1.5+, data on 4 lanes
```

4. Build the kernel:

```bash
pushd sdi-mipi-bridge-linux
export ARCH=arm64
export CROSS_COMPILE=aarch64-linux-gnu-
make tegra_defconfig
make -j$(nproc)
```

5. Install the kernel image, modules and device tree blob:

```bash
cp ./arch/arm64/boot/Image ../Linux_for_Tegra/kernel/
cp ./arch/arm64/boot/dts/tegra186-quill-p3310-1000-a00-00-base.dtb ../Linux_for_Tegra/kernel/dtb/
INSTALL_MOD_PATH=../Linux_for_Tegra/rootfs/ make modules_install
sudo chown -R root ../Linux_for_Tegra/rootfs/lib/modules
sudo chown -R root ../Linux_for_Tegra/rootfs/lib/firmware
popd
```

6. Copy the helper scripts from this repository to the root filesystem:
```bash
git clone https://github.com/antmicro/sdi-mipi-bridge
pushd sdi-mipi-bridge
cp -r scripts/* ../Linux_for_Tegra/rootfs/usr/local/bin/
popd
```
::::

::::{md-tab-item} Raspberry Pi CM4
The Raspberry BSP is based on the Raspberry Pi distro, which is available on [Raspberry Pi site](https://www.raspberrypi.com/software/operating-systems/#raspberry-pi-os-64-bit).
The kernel used on the device is based on the `rpi-5.15.y` branch of the [Raspberry Pi fork](https://github.com/raspberrypi/linux/commits/rpi-5.15.y) of the Linux kernel.

1. Download [Raspberry Pi OS (64-bit) with desktop](https://www.raspberrypi.com/software/operating-systems/#raspberry-pi-os-64-bit) from the [Raspberry Pi archives download site](https://downloads.raspberrypi.org/raspios_arm64/images/raspios_arm64-2022-04-07/2022-04-04-raspios-bullseye-arm64.img.xz):

2. Unpack the archive:

```bash
xz -d 2022-04-04-raspios-bullseye-arm64.img.xz
```

3. Write the SD card with the `.img` file:

```bash
dd if=2022-04-04-raspios-bullseye-arm64.img of=/dev/sdX bs=512 # where X is a letter of a block device representing SD-Card
```

4. Download the ARM64 toolchain from [Linaro release page](https://releases.linaro.org/components/toolchain/binaries/7.3-2018.05/aarch64-linux-gnu/gcc-linaro-7.3.1-2018.05-x86_64_aarch64-linux-gnu.tar.xz) and unpack it to your home directory.

5. Obtain Linux kernel sources:

```bash
git clone https://github.com/antmicro/sdi-mipi-bridge-linux-rpi
```

6. Build the Linux kernel:

```bash
cd sdi-mipi-bridge-linux-rpi
export PATH="${HOME}/gcc-linaro-7.3.1-2018.05-x86_64_aarch64-linux-gnu/bin":${PATH}
mkdir ../modules
export INSTALL_MOD_PATH=../modules/
export ARCH=arm64
export CROSS_COMPILE=aarch64-linux-gnu-
KERNEL=kernel8
make bcm2711_defconfig
make -j8
make -j8 modules_install
```
::::
:::::

## Uploading the BSP

:::::{md-tab-set}

::::{md-tab-item} Jetson Xavier NX

To flash the software on the device, put it in recovery mode, connect to the host PC with a USB cable and use the following command:

```bash
pushd Linux_for_Tegra
sudo ./flash.sh jetson-xavier-nx-devkit-emmc mmcblk0p1
popd
```
::::

::::{md-tab-item} Jetson TX2

To flash the software on the device, put it in recovery mode, connect to the host PC with a USB cable and use the following command:

```bash
pushd Linux_for_Tegra
sudo ./flash.sh jetson-tx2 mmcblk0p1
popd
```
::::

::::{md-tab-item} Raspberry Pi CM4

1. Copy the binaries to the SD card:

```bash
cd sdi-mipi-bridge-linux-rpi
sudo cp arch/arm64/boot/dts/broadcom/*.dtb <sd_card>/boot/
sudo cp arch/arm64/boot/dts/overlays/*.dtb* <sd_card>/boot/overlays/
sudo cp arch/arm64/boot/dts/overlays/README <sd_card>/boot/overlays/
sudo cp arch/arm64/boot/Image <sd_card>/boot/
sudo cp -r ../modules/lib/modules/* <sd_card>/lib/modules/
```

2. Additionally, the `<sd_card>/boot/config.txt` file on the SD Card needs to include the following lines:

```bash
kernel=Image
dtoverlay=dwc2,dr_mode=host
dtoverlay=disable-bt
dtoverlay=sdi-mipi-bridge-j5-cam1-4lane
```

3. Insert the SD card into your board and power it on.

::::
:::::
