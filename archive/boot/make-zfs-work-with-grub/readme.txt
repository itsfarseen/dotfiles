Patch /etc/grub.d/10_linux as follows:

-rpool=`${grub_probe} --device ${GRUB_DEVICE} --target=fs_label 2>/dev/null || true`
+rpool=`zdb -l ${GRUB_DEVICE} | grep " name:" | cut -d\' -f2`   

-(forgot what this line was originally supposed to read)
+LINUX_ROOT_DEVICE="ZFS=${rpool}${bootfs%/}"

Note: 
LINUX_ROOT_DEVICE="zfs:${rpool}${bootfs%/}"
This doesn't work. Tested.

Then run:
sudo ZPOOL_VDEV_NAME_PATH=1 grub-mkconfig -o <path to /boot/../grub.cfg>
		 ^^^^^^^^^^^^^^^^^^^^^^
		 If this is not set, shows some error saying can't find canonical path of dev or smth.
		
