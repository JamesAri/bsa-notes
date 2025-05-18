# net
ss -tapn

# sec
id

# disk
df -h
lsblk -f
blkid

# links
readlink -f /dev/loop0
journalctl -xb
dmesg | grep -i luks
