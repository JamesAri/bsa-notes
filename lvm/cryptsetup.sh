dd if=/dev/zero of=/tmp/lvm_test.img bs=1M count=1024
losetup /dev/loop0 /tmp/lvm_test.img

cryptsetup -y -v luksFormat /dev/loop0

cryptsetup luksOpen /dev/loop0 decrypted
mkfs.ext4 /dev/mapper/decrypted


cryptsetup luksDump /dev/loop0
cryptsetup luksAddKey /dev/loop0 /root/keyfile
cryptsetup luksAddKey /dev/loop0 /tmp/key1 --key-file /root/keyfile

chmod 600 /root/keyfile

# automatically unlock an encrypted partition at boot
# UUID: cryptsetup luksDump /dev/loop0
echo "decrypted UUID=98c0fb54-cef2-4627-962f-f3688973d3aa /boot/keyfile luks" >> /etc/crypttab
# mount při startu
sudo mkdir -p /mnt/decrypted
echo  "/dev/mapper/decrypted /mnt/decrypted ext4 defaults 0 2" >> /etc/fstab

# If this is the root partition or required early in the boot process, you need to update your initramfs:
update-initramfs -u

# check
blkid
