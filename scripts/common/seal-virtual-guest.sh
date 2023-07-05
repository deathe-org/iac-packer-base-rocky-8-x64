#!/bin/bash -e

/bin/echo '--> Sealing virtual-guest.'

# Oracle Linux recommendation
/bin/touch /.unconfigured

/bin/echo '---> Remove systemd random-seed.'
/bin/rm -f /var/lib/systemd/random-seed

/bin/echo '---> Clear DNF history.'
/bin/rm -rf /var/lib/dnf/history*

/bin/echo '---> Removing SSH host keys.'
/bin/rm -f /etc/ssh/ssh_host_*

/bin/echo '---> Generalising hostname.'
/bin/sed -i \
  -e 's~^HOSTNAME=.*$~HOSTNAME=localhost.localdomain~g' \
  /etc/sysconfig/network
/bin/hostnamectl \
  set-hostname localhost.localdomain

/bin/echo '---> Removing udev rules.'
/bin/rm -f /etc/udev/rules.d/70-persistent-net.rules
/bin/rm -f /etc/udev/rules.d/80-net-name-slot.rules

/bin/echo '---> Remove legacy network-scripts.'
/bin/rm -rf /etc/sysconfig/network-scripts/*

/bin/echo '---> Removing machine-id.'
  /bin/truncate --size 0 /etc/machine-id
