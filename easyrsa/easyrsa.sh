sudo apt install -y easy-rsa
cp -r /usr/share/easy-rsa/ /etc/ca
cd /etc/ca
mv vars.example vars
vim vars

./easyrsa init-pki
./easyrsa build-ca
./easyrsa gen-req server.kuba nopass
./easyrsa sign server server.kuba

# CHECKS
openssl x509 -in /etc/ca/pki/ca.crt -text
openssl req -in /etc/ca/pki/reqs/server.kuba.req -text
