# nginx with SSC

sudo apt install apache2 -y

vim /etc/apache2/sites-available/private.conf
vim /etc/apache2/sites-available/public-ssl.conf
vim /var/www/html/index.html

sudo a2enmod ssl
sudo a2ensite private.conf
sudo a2ensite public-ssl.conf
sudo systemctl reload apache2

# remove passphrase from key
sudo openssl rsa -in /etc/ca/pki/private/server.kuba.key -out /etc/ca/pki/private/server.kuba.key

iptables -A INPUT -p tcp --dport 443 -j ACCEPT
iptables -A INPUT -p tcp --dport 80 -j ACCEPT

# # checks
curl -kv https://public.slechta.bsa
curl -kv http://private.slechta.bsa
