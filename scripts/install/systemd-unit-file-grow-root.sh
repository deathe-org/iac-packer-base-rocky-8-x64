#!/bin/bash -e

LV_ROOT_FS_TYPE="${LV_ROOT_FS_TYPE:-xfs}"
PV_ROOT_FSTYPE="${PV_ROOT_FSTYPE:-lvmpv}"

if [[ ${PV_ROOT_FSTYPE} == lvmpv ]] \
  && [[ ${LV_ROOT_FS_TYPE} == ext4 ]]
then
  /bin/echo '--> Apply ext4 file system resizer.'
  /bin/sed -i -r \
    -e 's~^(Environment="BIN_FS_RESIZER=/sbin)xfs_growfs(")$~\1resize2fs\2~' \
    /etc/systemd/system/grow-root.service
fi

if [[ ${PV_ROOT_FSTYPE} == lvmpv ]]
then
  /bin/echo '--> Install grow-root.service.'
  /bin/systemctl daemon-reload
  /bin/systemctl enable \
    -f \
    grow-root.service
else
  /bin/echo '--> Remove grow-root.service (no lvm).'
  /bin/rm -f /etc/systemd/system/grow-root.service
fi
