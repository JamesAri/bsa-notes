# nginx with SSC

sudo apt install -y nginx

vim nginx/sites-available/secure-site

mv /var/www/html/index.nginx-debian.html /var/www/html/index.html

sudo ln -s /etc/nginx/sites-available/secure-site /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl restart nginx

# remove passphrase from key
sudo openssl rsa -in /etc/ca/pki/private/server.kuba.key -out /etc/ca/pki/private/server.kuba.key

iptables -A INPUT -p tcp --dport 443 -j ACCEPT
iptables -A INPUT -p tcp --dport 80 -j ACCEPT

# checks
curl -kv https://public.slechta.bsa
curl -kv http://private.slechta.bsa
