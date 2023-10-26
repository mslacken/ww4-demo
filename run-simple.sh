#!/usr/bin/bash
source config
run_on_host $IPADDR "wwctl node set demo01 --discoverable=yes -y" "Preparing node demo01 for booting"
show "Start the node demo1 and conncet with virt-viewer to it"
virsh -c qemu:///system start demo01
virt-viewer -w -c qemu:///system demo01 &
wait 40
kill %1
virsh -c qemu:///system destroy demo01

