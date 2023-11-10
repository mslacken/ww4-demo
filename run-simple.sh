#!/usr/bin/bash
source config
run_on_host $IPADDR "wwctl node set demo01 --discoverable=yes -y" "Preparing node demo01 for booting"
show "Start the node demo1 and connect with virt-viewer to it"
virsh -c qemu:///system start demo01 &> /dev/null
virt-viewer -w -c qemu:///system demo01 &>/dev/null &
wait_key 40
kill %1
wait %1 2> /dev/null
virsh -c qemu:///system destroy demo01 &> /dev/null

