# ww4-demo
warewulf demo which uses a scripted setup

## Prerequisite

* User must be in the `libvirt` group in order to start virtual machines and network
* The file `~/.ssh/authorized_keys` must only contain one key/line
* following packages must be installed: `virt-viewer terraform python3-kiwi wget`
* For the first run a vpn connection is required to download the SLE qcow image
* include SCC userid and product registration keys in sle-keys.json, which is created the first time you run it
* the all files in the `local/` directory are copied to `ww4-host` and are available through the local repo with `zypper`
The demo can be started with the script `./demo-run.sh` which calls the scripts in 
following order
* install-ww4.sh: This will setup the virtual environemnt, installs warewulf4 and adds the default container
* run-simple.sh: boots a single node
* run-tw.sh: imports and boots a tumbleweed container
* run-slurm.sh: starts a slurm cluster
