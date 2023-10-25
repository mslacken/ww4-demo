#!/usr/bin/bash
source config
run_on_hostq $IPADDR "sed -i 's/  syslog: false/  syslog: false\nfoo/' /etc/warewulf/warewulf.conf" "Set boot method to grub"
ssh -x root@$IPADDR "sed -i 's@foo@  grubboot: true@' /etc/warewulf/warewulf.conf"
run_on_host $IPADDR "wwctl configure -a" "Reconfigure services"
run_on_host $IPADDR "wwctl overlay build -H" "After such deep changes rebuild the host overlay"

