Copy ryzen5900hx_s3_dsdt_override.aml to /boot.

Add the following line to /etc/grub.d/10_linux:

After Loading Linux section, before Loading initial ramdisk section.

echo "acpi /ryzen5900hx_s3_dsdt_override.aml"


PS: Not fully tested by me.
