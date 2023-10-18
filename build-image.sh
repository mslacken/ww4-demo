#!/bin/bash
source config
DATESTR=$(date  +%Y%m%d)
VERS=15.5
# prepare the configuration
cat > kiwi-description/root/etc/sysconfig/network/ifcfg-lan0 <<EOF
# created by $0
BOOTPROTO='static'
IPADDR='$IPADDR'
NETMASK='$NETMASK'
GATEWAY='$GATEWAY'
STARTMODE='onboot'
EOF
cat > kiwi-description/root/etc/sysconfig/network/routes <<EOF
# created by $0
default $GATEWAY - - 
EOF
cat > kiwi-description/root/etc/sysconfig/network/config <<EOF
# created by $0
CHECK_DUPLICATE_IP="yes"
SEND_GRATUITOUS_ARP="auto"
DEBUG="no"
WAIT_FOR_INTERFACES="30"
FIREWALL="yes"
NM_ONLINE_TIMEOUT="30"
NETCONFIG_MODULES_ORDER="dns-resolver dns-bind dns-dnsmasq nis ntp-runtime"
NETCONFIG_VERBOSE="no"
NETCONFIG_FORCE_REPLACE="no"
NETCONFIG_DNS_POLICY="auto"
NETCONFIG_DNS_FORWARDER="resolver"
NETCONFIG_DNS_FORWARDER_FALLBACK="yes"
NETCONFIG_DNS_STATIC_SEARCHLIST=""
NETCONFIG_DNS_STATIC_SERVERS=$DNS
NETCONFIG_DNS_RANKING="auto"
NETCONFIG_NTP_POLICY="auto"
NETCONFIG_NTP_STATIC_SERVERS=""
NETCONFIG_NIS_POLICY="auto"
NETCONFIG_NIS_SETDOMAINNAME="yes"
LINK_REQUIRED="auto"
EOF
# copy authorized_keys 
if [ -e ~/.ssh/authorized_keys ] ; then
  mkdir -p kiwi-description/root/root/.ssh/
  chmod 700 kiwi-description/root/root/.ssh/
  cp ~/.ssh/authorized_keys  kiwi-description/root/root/.ssh/
fi
# create host ssh key
if [ ! -e kiwi-description/root/etc/ssh ] ; then
  mkdir -p kiwi-description/root/etc/ssh 
  ssh-keygen -A -f kiwi-description/root
fi
# delete two times as kiwi hates it otherwise
sudo rm -rf /var/tmp/demo_build || exit 1
sudo /usr/bin/kiwi \
  --profile Disk system build \
  --description ./kiwi-description/ \
  --target-dir /var/tmp/demo_build || exit 1

cp /var/tmp/demo_build/Leap-15.5_appliance.x86_64-0.0.1.qcow2 .
sudo rm -rf /var/tmp/demo_build || exit 1

