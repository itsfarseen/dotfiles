Copy ./ryzen5900hx_s3_dsdt_patch.img to /boot.

Edit /etc/default/grub and add:
GRUB_EARLY_INITRD_LINUX_CUSTOM="ryzen5900hx_s3_dsdt_patch.img"

Run grub-mkconfig.
