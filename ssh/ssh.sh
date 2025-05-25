# lab:
mkdir -p ~/.ssh
cd ~/.ssh
ssh-keygen -t rsa -b 4096
cat id_rsa.pub

chmod 600 ~/.ssh/id_rsa

PUB_KEYX="ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC55ltQKroKqaHBVw/WmyBnbIE8TNj8ph95jMesZIWFuwCR7+YQ9J4wkyU4/obuS3R1iBabF0ROHELT/zvoLGJntOXe+83CbcDO24wMTkVzL0SC4x8HtqmknS8Nia/Zon8BbIFEdPm5u1YpaU0jK1lvYDiYN4t72j+xoepZ0afvZr6cm3bpWCUh1TwdWeVckDqw3PFWqQVuBjuvwBjCfLF26oeN27kAksJ0k8b/GTxlPWrGfTdrhtAe93vNCZuMrhr0cCTTLv+j8Gpg9DBwr6zvOECFnhvvqYD/UVp70AJR6id8+jZOHlnYoQgQlAWiau/e4CvD98K3i+dZQF1p2tzrQ8n/cWht6dySsZtBdjYcCuX2gSu5HuIDEEszUnafzWYj6WuQAF3Mw4SGr5Z3EeWKrvONOcpbuMbx0/lV5VAY1Z3FmgBh8O09ST/oImtKEAk6hljg5RmIzSvy6Zewm1xc9MFr0QZTbmMnnahs7aztF7tCp7Ka7da7c2tU3fJMPE0tzUwkE5BrsyYkhFsyNRpuvCfw+Sar7XsAk0VtWxdWZtRCktQQfg3la/KlQ+gLmfVV1Hi1DYyjisRJ2FDm41Qxpv8kdZXN+KSK8a8FHcZsfAdb6znkem6iRlftHinO2r2AWOmNSTgDWhEaiZH/Ov0Wsvor9V6b9hO/vPmEpeyOiQ== root@sulis174"

# remote:
mkdir -p ~/.ssh
cd ~/.ssh
echo "${PUB_KEYX}" >> authorized_keys
chmod 700 ~/.ssh
chmod 600 ~/.ssh/authorized_keys

vim /etc/ssh/sshd_config
# //
sed -i 's/PermitRootLogin .*/PermitRootLogin without-password/g' /etc/ssh/sshd_config


systemctl restart sshd
