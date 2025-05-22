# POKUD NEBUDE DOSTATENCE VELKY DISK
dd if=/dev/zero of=/tmp/lvm_test.img bs=1M count=1024
losetup /dev/loop0 /tmp/lvm_test.img

# LVM
apt install lvm2
MY_DISK=/dev/vdb
VG_NAME=data
LV_NAME=encrypted
LV_PATH=/dev/$VG_NAME/$LV_NAME
pvcreate $MY_DISK
vgcreate $VG_NAME $MY_DISK
lvcreate -L 1G -n $LV_NAME $VG_NAME

# -----
lvcreate -L +6G -n encrypted /dev/sdb/data # rozsireni

# CRYPT
echo "1234" > /root/keyfile
chmod 600 /root/keyfile
cryptsetup -y -v luksFormat --key-file /root/keyfile $LV_PATH
cryptsetup luksOpen $LV_PATH decrypted --key-file /root/keyfile
mkfs.ext4 /dev/mapper/decrypted
mount /dev/mapper/decrypted /mnt

# -----
cryptsetup luksClose decrypted # zavreni
cryptsetup luksAddKey $LV_PATH /root/keyfile # pridani klice
cryptsetup luksAddKey $LV_PATH /tmp/key1 --key-file /root/keyfile # pridani klice pres klic

# BOOT UNLOCK AND MOUNT
# UUID:
cryptsetup luksDump /dev/loop0
echo "decrypted UUID=98c0fb54-cef2-4627-962f-f3688973d3aa /boot/keyfile luks" >> /etc/crypttab
# mount při startu
sudo mkdir -p /mnt/decrypted
echo  "/dev/mapper/decrypted /mnt/decrypted ext4 defaults 0 2" >> /etc/fstab
# If this is the root partition or required early in the boot process, you need to update your initramfs:
update-initramfs -u


# CHECKS
blkid

pvs
vgs
lvs
cryptsetup luksDump $LV_PATH
lsblk -f

# CLENUP
lvremove $LV_PATH
vgremove $VG_NAME
pvremove $MY_DISK

umount /mnt

