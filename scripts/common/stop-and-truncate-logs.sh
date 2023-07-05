#!/bin/bash -e

/bin/echo '--> Stopping logging services.'
/sbin/service auditd stop
/bin/systemctl stop rsyslog.service

/bin/echo '--> Truncate log files.'
/bin/find /var/log -type f \
  -exec /bin/truncate -s 0 {} \;
