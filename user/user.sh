INIT_PUBKEY="ecdsa-sha2-nistp521 AAAAE2VjZHNhLXNoYTItbmlzdHA1MjEAAAAIbmlzdHA1MjEAAACFBAEdH5wkVsXVv2Om5m8neWqhAd8Dm0PkQ6RPqW8QatQLswuw8bpY3UmuMzKmkNxu47MO0CldW7PIDkAQpV51DDxgbwHg+aiM3jiUfVTzRavGY0ghGLYI+8KuhNa4tfddCoqW3VmjJm4nF8QxDkb+Tvex+W9xzrHBYCx/UzIq6zg+vfn86g== root@960763f9e820"
USER_NM=pavlik
useradd -m -d /home/${USER_NM} -s /bin/bash ${USER_NM}
usermod -aG sudo ${USER_NM}
echo "${USER_NM}  ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/${USER_NM}
mkdir /home/${USER_NM}/.ssh
echo "${INIT_PUBKEY}" > /home/${USER_NM}/.ssh/authorized_keys
chown -R ${USER_NM}:${USER_NM} /home/${USER_NM}/.ssh
chmod 700 /home/${USER_NM}/.ssh
chmod 600 /home/${USER_NM}/.ssh/authorized_keys
sed -i 's/PermitRootLogin .*/PermitRootLogin no/g' /etc/ssh/sshd_config
sed -i 's/PasswordAuthentication .*/PasswordAuthentication no/g' /etc/ssh/sshd_config
systemctl restart sshd
chmod 755 /home/${USER_NM}
chown ${USER_NM}:${USER_NM} /home/${USER_NM}


# ======================================================
# -m to create home
# -s for shell
# -d specify home directory
# -g to specify group
# -r system acc
useradd -m -s /bin/bash karel

# set password for user
passwd karel

# checks
id karel
getent passwd karel

# create group
addgroup nginx_admins

# add user to group
# -a to append user to group
# -G to specify group
usermod -aG nginx_admins karel


# SUDO for user
usermod -aG sudo karel
echo "karel  ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/karel

# allow nginx_admins to reset nginx
echo "%nginx_admins ALL=(ALL) NOPASSWD: /bin/systemctl restart nginx" > /etc/sudoers.d/nginx_admins






