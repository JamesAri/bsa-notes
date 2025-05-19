vim /etc/resolv.conf
vim /etc/hosts

# KNOT
apt install knot knot-dnsutils -y
knotc reload


# BIND
cd /etc/bind/
apt-get install bind9 dnsutils -y
# service bind9 start|stop|restart

cd /etc/bind/
vim named.conf.options

cd /var/cache/bind
vim db.jakub.bsa

named-checkzone jakub.bsa /var/cache/bind/db.jakub.bsa

chown bind:bind /var/cache/bind/db.jakub.bsa

mkdir /etc/bind/keys
cd /etc/bind/keys
dnssec-keygen -a ECDSAP256SHA256 -fK jakub.bsa
chmod g+r K*.private
systemctl restart bind9
rndc sign jakub.bsa
