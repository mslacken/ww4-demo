#!/usr/bin/bash
source config
show "Starting to run the demo, you always abort with ^C"
show "but remember to clean up with"
show "terraform destroy"
show "so that the next run of $0 will start with a fresh environment."

if [ -z $IMAGE ] ; then
  wget $IMAGESRC
fi
# create host ssh key
if [ ! -e kiwi-description/root/etc/ssh ] ; then
  mkdir -p kiwi-description/root/etc/ssh 
  ssh-keygen -A -f kiwi-description/root
fi
terraform init
./install-ww4.sh
./run-simple.sh
./run-tw.sh
./run-slurm.sh
terraform destroy -auto-approve 
