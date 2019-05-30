#!/bin/bash
# format disk /dev/sdb
/sbin/mkfs.ext4 -m 0 -F -E lazy_itable_init=0,lazy_journal_init=0,discard /dev/sdb
# create folder for mounting
/bin/mkdir -p /mnt/disk1
# mount disk to floder
/bin/mount -o discard,defaults /dev/sdb /mnt/disk1
# grand access
/bin/chmod a+w /mnt/disk1
# need to add /etc/fstab
# ??????
