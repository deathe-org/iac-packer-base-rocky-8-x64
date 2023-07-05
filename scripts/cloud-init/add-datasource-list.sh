#!/bin/bash -e

/bin/echo '--> Adding cloud-init datasources_list.'
/bin/tee \
  /etc/cloud/cloud.cfg.d/10_datasource_list.cfg \
  1> /dev/null \
  <<-EOF
datasource_list: [
  ConfigDrive,
  NoCloud,
  OpenStack,
  Ec2,
  Oracle,
  GCE,
  Azure,
  DigitalOcean,
  Vultr,
  AliYun,
  None,
]
EOF
