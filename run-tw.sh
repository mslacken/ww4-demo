#!/usr/bin/bash
source config

run_on_host $IPADDR "wwctl node list -l" "Show how our nodes are configure"
wait_key $WAIT_SHORT
run_on_host $IPADDR "wwctl container import docker://registry.opensuse.org/science/warewulf/tumbleweed/containerfile/kernel:latest tumbleweed" "Importing tumblweed rolling release container"
#echo "---------------------------------------------------------------------------"
show "Now install a more fancy output for getting the os version in the container"
show "The command here is way to complicated day to day use, for this the command"
show "'wwctl container shell tumblweed' can be used"
run_on_host $IPADDR "wwctl container exec tumbleweed /usr/bin/zypper -- -- in -y neofetch"
wait_key $WAIT_SHORT
run_on_host $IPADDR "wwctl node set demo01 -y --container tumbleweed" "Set the container/base OS to tumblweed for single node"
wait_key $WAIT_SHORT
run_on_host $IPADDR "wwctl node list -l" "Check if all was set right"
wait_key $WAIT_SHORT
show "Boot demo01 and watch it booting"
virsh -c qemu:///system start demo01
virt-viewer -w -c qemu:///system demo01 &
show "Waiting for the host ($IPSTART) to become online"
while true ; do
  ssh -xo "StrictHostKeyChecking=no" root@$IPSTART uname -n 2> /dev/null && break || echo -n "."
  sleep 1
done
run_on_host $IPSTART "neofetch" "Getting our pretty graph on tumbleweed"
wait_key $WAIT_LONG
kill %1

virsh -c qemu:///system destroy demo01
run_on_host $IPADDR "wwctl node set demo01 -y --container UNDEF" "Clean up"
wait_key $WAIT_SHORT
run_on_host $IPADDR "wwctl container delete -y tumbleweed"

