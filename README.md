# ww4-demo
warewulf demo which uses a scripted setup

## Prerequisite

* User must be in the `libvirt` group in order to start virtual machines and network
* The file `~/.ssh/authorized_keys` must only contain one key (ie. line)
* following packages must be installed: `virt-viewer terraform python3-kiwi wget`
* For virt-viewer, make sure you have the DISPLAY variable set.
* For the first time run a vpn connection is required to download the SLE qcow image
* include SCC userid and product registration keys in sle-keys.json, which is created the first time you run it
* the all files in the `local/` directory are copied to `ww4-host` and are available through the local repo with `zypper`. 

The demo can be started with the script `./demo-run.sh` which calls the scripts in
following order
  - install-ww4.sh: This will setup the virtual environemnt, installs warewulf4 and adds the default container
  - run-simple.sh: boots a single node
  - run-tw.sh: imports and boots a tumbleweed container
  - run-slurm.sh: starts a slurm cluster
* Wait times can be adjusted in config.json: there is WAIT_SHORT, WAIT_LONG
  and WAIT_FACTOR. The latter can be used to scale wait times.

### Grub and storage demos

The demos for grub/secure boot and storage configuration need a 4.5.x release package.
This is available under 
https://build.opensuse.org/package/show/home:mslacken:pr/warewulf4
and the rpms have to be copied to the `local` directory so that they can be installed on `ww4-host`.

For the demos following scripts need to be run

* run-grub.sh: which will boot an EFI node with secure boot enabled
* run-storage: which will configure `demo01` to have `/scratch` space and `swap` space
