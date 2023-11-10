#!/usr/bin/bash
source config
run_on_hostq $IPADDR "yq e ' .warewulf.grubboot=true' -i /etc/warewulf/warewulf.conf" "Set boot method to grub"
run_on_host $IPADDR "wwctl configure -a" "Reconfigure services"
run_on_host $IPADDR "wwctl overlay build -H" "After such deep changes rebuild the host overlay"
run_on_host $IPADDR "wwctl container exec $DEMOCONT /usr/bin/zypper -- -- in -y mokutil" "Install mokutil in order to get the boot state"
show "Boot efi01 and watch it booting via grub and secure boot"
virsh -c qemu:///system start efi01
virt-viewer -w -c qemu:///system efi01 &
ssh -o 'ConnectionAttempts 5' -x root@$EFISTART "uname -n >/dev/null"
wait_key $WAIT_SHORT
ssh-keygen -R $EFISTART -f ~/.ssh/known_hosts &> /dev/null
run_on_host $EFISTART "mokutil --sb-state" "Getting the Secure boot status"
show "Secure Boot is enabled. Noting more can be shown here."
wait_key $WAIT_SHORT
show "This means a locked down kernel, so no malicious modules can be loaded"
wait_key $WAIT_LONG
show "Used keys are:"
run_on_host $EFISTART "mokutil --db"
wait_key $WAIT_LONG
run_on_host $EFISTART "mokutil --pk"
wait_key $WAIT_LONG
kill %1 &> /dev/null
virsh -c qemu:///system destroy efi01

