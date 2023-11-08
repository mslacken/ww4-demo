#!/usr/bin/bash
source config
run_on_hostq $IPADDR "sed -i 's/  syslog: false/  syslog: false\nfoo/' /etc/warewulf/warewulf.conf" "Set boot method to grub"
ssh -x root@$IPADDR "sed -i 's@foo@  grubboot: true@' /etc/warewulf/warewulf.conf"
run_on_host $IPADDR "wwctl configure -a" "Reconfigure services"
run_on_host $IPADDR "wwctl overlay build -H" "After such deep changes rebuild the host overlay"
 run_on_host $IPADDR "wwctl container exec leap15.5 /usr/bin/zypper -- -- in -y mokutil"
show "Boot efi01 and watch it booting via grub and secure boot"
virsh -c qemu:///system start efi01
virt-viewer -w -c qemu:///system efi01 &
wait 60
run_on_host $EFISTART "mokutil --sb-state" "Getting the Secure boot status"
show "Secure Boot is enabled. Noting more can be shown here."
wait 5
show "This means a locked down kernel, so no malicious modules can be loaded"
wait 30
show "Used keys are:"
run_on_host $EFISTART "mokutil --db"
wait 30
run_on_host $EFISTART "mokutil --pk"
wait 30
kill %1
virsh -c qemu:///system destroy efi01

