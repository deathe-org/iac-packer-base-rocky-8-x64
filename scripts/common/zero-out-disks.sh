#!/bin/bash -e

PART_BOOT_SIZE="${PART_BOOT_SIZE:-1024}"

SWAP_DEVICE=$(
  /bin/readlink -f /dev/disk/by-uuid/$(
    /sbin/blkid -l -o value -s UUID -t TYPE=swap
  )
)

/bin/echo '--> Zero out and reset swap.'
if [[ ${SWAP_DEVICE} == /dev/disk/by-uuid ]]
then
  /bin/echo '---> Skipping (No swap device).'
else
  /sbin/swapoff -a
  /bin/dd if=/dev/zero of=${SWAP_DEVICE} bs=1M &> /dev/null
  /sbin/mkswap --label swap -f ${SWAP_DEVICE}
fi

/bin/echo '--> Zero out any remaining free disk space.'

if ! [[ ${PART_BOOT_SIZE} -eq 0 ]]
then
  /bin/dd if=/dev/zero of=/boot/boot.zero bs=1M &> /dev/null
fi

# Old QEMU versions fail if dd writes out too much data in one file.
OF_ID=1
OF_SIZE=4096
while dd if=/dev/zero of=/${OF_ID}.zero bs=1M count=${OF_SIZE} &> /dev/null
do 
  (( OF_ID++ ));
done

/bin/find / \
  -depth \
  -name "*.zero" \
  -not -path "/proc/*" \
  -delete \
&> /dev/null

# # Fix /dev/null permissions
# rm -f /dev/null
# mknod -m 666 /dev/null c 1 3

exit 0
