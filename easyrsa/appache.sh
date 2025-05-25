# nginx with SSC

apt install apache2 -y

vim /etc/apache2/sites-available/private.conf
vim /etc/apache2/sites-available/public-ssl.conf
vim /var/www/html/index.html

a2enmod ssl
a2ensite private.conf
a2ensite public-ssl.conf
systemctl reload apache2

# remove passphrase from key
openssl rsa -in /etc/ca/pki/private/server.kuba.key -out /etc/ca/pki/private/server.kuba.key

iptables -I INPUT -p tcp --dport 443 -j ACCEPT
iptables -I INPUT -p tcp --dport 80 -j ACCEPT

# # checks
curl -kv https://public.slechta.bsa
curl -kv http://private.slechta.bsa
