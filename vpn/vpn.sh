apt install openvpn -y
apt install easy-rsa -y
apt install -y easy-rsa
cp -r /usr/share/easy-rsa/ /etc/ca
cd /etc/ca
mv vars.example vars
vim vars
./easyrsa init-pki

#  SERVER

cd /etc/ca
./easyrsa gen-req vpn.jakub.bsa nopass
./easyrsa sign server vpn.jakub.bsa

./easyrsa gen-crl
./easyrsa gen-dh

mkdir /etc/openvpn/certs

cp pki/ca.crt pki/dh.pem pki/crl.pem pki/issued/vpn.jakub.bsa.crt pki/private/vpn.jakub.bsa.key /etc/openvpn/certs

scp vpn/bsa-server.conf testy:/tmp/bsa-server.conf
cp /tmp/bsa-server.conf /etc/openvpn/bsa-server.conf

mkdir bsa-clients

# push "route 192.168.3.0 255.255.255.0 192.168.35.15"
# ifconfig-push 192.168.35.15 255.255.255.0
touch bsa-clients/client-01
echo 'push "route 192.168.3.0 255.255.255.0 192.168.35.15"' >> bsa-clients/client-01
echo "ifconfig-push 192.168.35.15 255.255.255.0" >> bsa-clients/client-01

systemctl enable openvpn@bsa-server
systemctl start openvpn@bsa-server

iptables -I INPUT -p udp --dport 1194 -j ACCEPT


# CLIENT
cd /etc/ca
./easyrsa gen-req client-01.vpn.jakub.bsa nopass
./easyrsa sign client client-01.vpn.jakub.bsa

mkdir -p vpn/tmp/certs
ssh testy "sudo cat /etc/ca/pki/ca.crt" > vpn/tmp/certs/ca.crt
ssh testy "sudo cat /etc/ca/pki/issued/client-01.vpn.jakub.bsa.crt" > vpn/tmp/certs/client-01.vpn.jakub.bsa.crt
ssh testy "sudo cat /etc/ca/pki/private/client-01.vpn.jakub.bsa.key" > vpn/tmp/certs/client-01.vpn.jakub.bsa.key

vim /etc/hosts
# <ip>	vpn.jakub.bsa

cd /etc/openvpn
sudo openvpn --config bsa-client-01.conf
