#!/usr/bin/bash
source config
show "Install a slurm cluster"
run_on_host $IPADDR "zypper in -y munge warewulf4-slurm" "Installing warewulf4-slurm meta package on the ww4-host"
show "slurm daemon is now installed at ww4-host, we need to install on the node image now"
show "get the uid/gid from munge daemon and add to the node image, if not uid/gid can mismatch"
munge_uid=$(ssh -x root@$IPADDR id -u munge)
munge_gid=$(ssh -x root@$IPADDR id -g  munge)
run_on_host $IPADDR "wwctl container exec $DEMOCONT /usr/sbin/groupadd -- -- munge -g $munge_gid"
run_on_host $IPADDR "wwctl container exec $DEMOCONT /usr/sbin/useradd -- -- munge -u $munge_uid -g $munge_gid -M -s /usr/sbin/nologin -c 'MUNGE authentication service' -d /run/munge"
run_on_host $IPADDR "wwctl container exec $DEMOCONT /usr/bin/echo -- -- $munge_group >> /etc/group"
run_on_host $IPADDR "wwctl container exec $DEMOCONT /usr/bin/zypper -- -- install -y slurm-node slurm-munge" "Install slurm in the container"
run_on_host $IPADDR "wwctl container exec $DEMOCONT /usr/bin/systemctl -- -- enable slurmd" "Start slurmd on boot for the container"
run_on_host $IPADDR "wwctl container exec $DEMOCONT /usr/bin/systemctl -- -- enable munge" "Start munge on boot for the container"
wait_key $WAIT_SHORT
run_on_host $IPADDR "wwctl overlay show host /etc/slurm/slurm.conf.ww" "Check our slurm.conf installed by the package warewulf4-slurm"
wait_key $WAIT_LONG
show "How does it look like rendered?"
run_on_host $IPADDR "wwctl overlay show host /etc/slurm/slurm.conf.ww -r demo01 | tail" 
show "Start slurmctld and munge on the ww4-host"
run_on_host $IPADDR "wwctl overlay build -H" "Recreate the host overlay as the template slurm.conf.ww was added"
run_on_host $IPADDR "systemctl enable --now munge"
run_on_host $IPADDR "systemctl enable --now slurmctld"
show "Boot the nodes"
for host in $(jq "keys[]" macs.json | tr -d '"' | grep demo) ; do
  virsh -c qemu:///system start $host
done
show "Wait for 1 minute so that the hosts come up"
#sleep 60
run_on_host $IPADDR "sinfo" "Get the queue state of slurm"
wait_key $WAIT_SHORT
run_on_host $IPADDR "srun -N4 uname -n" "Run a most simple slurm job"
wait_key 20
show "shut down the nodes"
for host in $(jq "keys[]" macs.json | tr -d '"' | grep demo) ; do
  virsh -c qemu:///system destroy $host
done
