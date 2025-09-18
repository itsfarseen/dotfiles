Regardless of which method you go for, for patching the DSDT table, you need to set the following flag:

Add the following to /etc/default/grub:

GRUB_CMDLINE_LINUX="mem_sleep_default=deep"

Run grub-mkconfig.
