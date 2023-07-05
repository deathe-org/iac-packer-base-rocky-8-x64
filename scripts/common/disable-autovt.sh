#!/bin/bash -e

/bin/echo '--> Disable automatic spawning of "autovt" services.'
/bin/sed -i -r \
  -e 's~^#(NAutoVTs=).*$~\10~' \
  /etc/systemd/logind.conf
