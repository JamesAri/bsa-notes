sudo apt install -y easy-rsa
cp -r /usr/share/easy-rsa/ /etc/CA3
cd /etc/CA3
mv vars.example vars
vim vars
./easyrsa init-pki
./easyrsa build-ca
openssl x509 -in /etc/CA3/pki/ca.crt -text
./easyrsa gen-req server.kuba

openssl req -in /etc/CA3/pki/reqs/server.kuba.req -text
./easyrsa sign server server.kuba



# nginx with SSC

sudo apt install -y nginx
sudo vim /etc/nginx/sites-available/secure-site

# server {
#     listen 443 ssl;
#     server_name your_domain_or_ip;

#     ssl_certificate /etc/CA3/pki/issued/server.kuba.crt;
#     ssl_certificate_key /etc/CA3/pki/private/server.kuba.key;

#     ssl_protocols TLSv1.2 TLSv1.3;
#     ssl_ciphers HIGH:!aNULL:!MD5;

#     root /var/www/html;
#     index index.html;

#     location / {
#         try_files $uri $uri/ =404;
#     }
# }

mv /var/www/html/index.nginx-debian.html /var/www/html/index.html

sudo ln -s /etc/nginx/sites-available/secure-site /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl restart nginx

# remove passphrase from key
sudo openssl rsa -in /etc/CA3/pki/private/server.kuba.key -out /etc/CA3/pki/private/server.kuba.key

iptables -A INPUT -p tcp --dport 443 -j ACCEPT
