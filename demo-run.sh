#!/usr/bin/bash
source config
show "Starting to run the demo, you always abort with ^C"
show "but remember to clean up with"
show "\`terraform destroy\`"
show "so that the next run of $0 will start with a fresh environment."
./install-ww4.sh || { echo install-ww4.sh failed; exit 1; }
./run-simple.sh || { echo run-simple.sh failed; exit 1; }
./run-tw.sh || { echo run-tw.sh failed; exit 1; }
./run-slurm.sh || { echo run-slurm.sh failed; exit 1; }
terraform destroy -auto-approve
