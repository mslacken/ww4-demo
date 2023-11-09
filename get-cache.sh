#!/usr/bin/bash
source config
if [ ! -e cache/oci/ ] ; then 
  mkdir -p cache/oci 
fi
rsync -avu root@$IPADDR:/var/lib/warewulf/oci/ cache/oci/
if [ ! -e cache/zypp ] ; then
  mkdir -p cache/zypp
fi
rsync -avu root@$IPADDR:/var/cache/zypp/ cache/zypp/
