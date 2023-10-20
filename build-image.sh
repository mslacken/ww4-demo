#!/bin/bash
source config
IMAGE=${1:-leap-15.5.kiwi}
# prepare the configuration
mkdir -p kiwi-description/root/etc/sysconfig/network/ 
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
# check if can hvae the boxed build without root
if rpm -q python3-kiwi_boxed_plugin &> /dev/null  ; then
  rm -rf /var/tmp/demo_build || exit 1
  /usr/bin/kiwi \
    --profile Disk system boxbuild  --box leap \
    --description ./kiwi-description/ \
    --target-dir /var/tmp/demo_build || exit 1
else 
  sudo rm -rf /var/tmp/demo_build || exit 1
  sudo /usr/bin/kiwi \
    --profile Disk system build \
    --description ./kiwi-description/ \
    --target-dir /var/tmp/demo_build || exit 1
fi

cp /var/tmp/demo_build/*.qcow2 .
if rpm -q python3-kiwi_boxed_plugin &> /dev/null  ; then
  rm -rf /var/tmp/demo_build || exit 1
else
  sudo rm -rf /var/tmp/demo_build || exit 1
fi

