#!/usr/bin/bash
source config
ssh-keygen -R $IPSTART -f ~/.ssh/known_hosts &> /dev/null
run_on_host $IPADDR "wwctl container exec $DEMOCONT /usr/bin/zypper -- -- in -y ignition gptfdisk" "Install ignition and gptfdisk (sgdisk) which will configure the disks"
run_on_host $IPADDR "wwctl node set demo01 \
  --diskname /dev/vda --diskwipe \
  --partname scratch --partcreate \
  --fsname scratch --fsformat btrfs --fspath /scratch --fswipe -y" \
  "Add storage in the configuration for the demo node"
show "Boot demo01 and watch for it to finish"
virsh -c qemu:///system start demo01
while true ; do 
  ssh -x root@$IPSTART uname -n 2> /dev/null && break || echo -n "."
  sleep 1
done
run_on_host $IPSTART "df -h" "Check that /scratch is mounted"
wait 10
run_on_host $IPSTART "cat /etc/fstab" "There is an entry in fstab"
run_on_host $IPSTART "cat /etc/systemd/system/scratch.mount" "mount is done with systemd unit"
wait 10
run_on_host $IPADDR "wwctl node set demo01 \
  --diskname /dev/vda --diskwipe --partsize=1024\
  --partname swap --partcreate --partnumber 1 \
  --fsname swap  --fsformat swap --fswipe -y" \
show "For adding a swap space , we will have to reset demo01"
virsh -c qemu:///system reset demo01
while true ; do 
  ssh -x root@$IPSTART uname -n 2> /dev/null && break || echo -n "."
  sleep 1
done
run_on_host $IPSTART "df -h" "Check that /scratch is mounted"
sleep 10
run_on_host $IPSTART "free" "Check that the swap space"
sleep 10
virsh -c qemu:///system destroy demo01


