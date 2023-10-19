# ww4-demo
warewulf demo which uses a scripted setup

## Prerequisite

* User must be in the `libvirt` group in order to start virtual machines and network
* following packages must be installed: `virt-viewer terraform python3-kiwi`

Before the main script `install-ww4.sh` can be run, the image has to be created
with `build-image.sh` which requires sudo to build. This image has only to be built
once.
