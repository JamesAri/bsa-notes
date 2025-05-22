#!/bin/bash

apt install gpg -y

# gpg --full-generate-key
gpg --gen-key
# checks
gpg --list-sig
gpg --list-keys
gpg --list-secret-keys

# gpg --default-key "$SIGNING_KEY" --output "$SIGNATURE" --detach-sign "$ARCHIV"

cat > archive_script.sh <<'EOF'
ARCHIV="/tmp/etc-2025.tar.gz"
SIGNATURE="$ARCHIV.sig"

# Create, gZip, File
tar -czf "$ARCHIV" /etc || { echo "Archive failed"; exit 1; }

gpg --output "$SIGNATURE" --detach-sign "$ARCHIV" || { echo "Couldn't sign archive"; exit 1; }

gpg --verify "$SIGNATURE" "$ARCHIV"
if [ $? -eq 0 ]; then
  echo "Signature matches."
else
  echo "Signature check failed."
  exit 1
fi
EOF

# allow only root
chmod 700 archive_script.sh
chown root:root archive_script.sh

# ALTERNATIVE - WITH OPENSSL

openssl genrsa -out key.pem 4096
openssl rsa -in key.pem -pubout > key.pub
openssl dgst -sign key.pem -keyform PEM -sha256 -out data.zip.sign -binary data.zip
openssl dgst -verify key.pub -keyform PEM -sha256 -signature data.zip.sign data.zip
