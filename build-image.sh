#!/bin/bash
source config
DATESTR=$(date  +%Y%m%d)
VERS=15.5
# prepare the configuration
cat > kiwi-description/root/etc/sysconfig/network/ifcfg-lan0 <<EOF
# created by $0
BOOTPROTO='static'
IPADDR=$IPADDR
NETMASK=$NETMASK
GATEWAY=$GATEWAY
EOF
cat > kiwi-description/root/etc/sysconfig/network/route <<EOF
# created by $0
default $GATEWAY - - 
EOF
cat > kiwi-description/root/etc/sysconfig/network/config <<EOF
# created by $0
NETCONFIG_DNS_STATIC_SERVERS=$DNS
EOF
if [ -e ~/.ssh/authorized_keys ] ; then
  mkdir -p kiwi-description/root/root/.ssh/
  chmod 700 kiwi-description/root/root/.ssh/
  cp ~/.ssh/authorized_keys  kiwi-description/root/root/.ssh/
fi
# delete two times as kiwi hates it otherwise
sudo rm -rf /var/tmp/demo_build || exit 1
sudo /usr/bin/kiwi \
  --profile Disk system build \
  --description ./kiwi-description/ \
  --target-dir /var/tmp/demo_build || exit 1

cp /var/tmp/demo_build/Leap-15.5_appliance.x86_64-0.0.1.qcow2 .
sudo rm -rf /var/tmp/demo_build || exit 1

