apt install -y easy-rsa
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


# Self signed certificate
openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout kuba.selfsigned.pem -out kuba.selfsigned.pem

# manual:
openssl genpkey -algorithm RSA -out mykey.pem -pkeyopt rsa_keygen_bits:2048
openssl req -new -key mykey.pem -out mycsr.csr
openssl x509 -req -in mycsr.csr -signkey mykey.pem -out mycert.pem -days 365

