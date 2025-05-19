From the log, it looks like your OpenVPN client successfully connected, but there are a few remaining warnings that should be addressed for security and compatibility:

---

### **1. Compression Warning (Security Risk)**

```plaintext
WARNING: Compression for receiving enabled. Compression has been used in the past to break encryption.
```

**Issue:** You have `comp-lzo` enabled, which is deprecated and insecure because it can be exploited for compression-based attacks like CRIME.

**Solution:** Disable compression entirely on both the server and client:

**Server:**

```plaintext
;comp-lzo
allow-compression no
```

**Client:**

```plaintext
;comp-lzo
```

If you must keep compression for legacy clients, explicitly enable it with:

```plaintext
allow-compression yes
```

---

### **2. Deprecated Cipher Warning**

```plaintext
DEPRECATED OPTION: --cipher set to 'AES-128-CBC' but missing in --data-ciphers
```

**Issue:** The server is still using the old `--cipher` directive without the modern `--data-ciphers` option.

**Solution:** Update both server and client configurations:

**Server (`server.conf`):**

```plaintext
data-ciphers AES-256-GCM:AES-128-GCM:AES-128-CBC
cipher AES-256-GCM
```

**Client (`client.conf`):**

```plaintext
data-ciphers AES-256-GCM:AES-128-GCM:AES-128-CBC
cipher AES-256-GCM
```

---

### **3. Topology Mismatch (Optional but Recommended)**

Your server is pushing a `net30` topology:

```plaintext
PUSH_REPLY,dhcp-option DNS 192.168.35.1,route 192.168.35.0 255.255.255.0,topology net30
```

**Issue:** `topology net30` is outdated and can cause routing problems with some clients.

**Solution:** Switch to the simpler and more efficient `topology subnet`:

**Server (`server.conf`):**

```plaintext
topology subnet
```

---

### **4. Interface Cleanup Warning**

```plaintext
/sbin/ifconfig utun4 delete
ifconfig: ioctl (SIOCDIFADDR): Can't assign requested address
```

**Issue:** This warning occurs because the address you are trying to delete from the `utun4` interface is not present. This is typically harmless but can indicate a stale state.

**Solution:** Ensure the TUN device is properly cleaned up between connections:

**Add this to your client config:**

```plaintext
persist-tun
persist-key
```

---

### **5. General Improvements (Security and Stability)**

**A. Server Config:**

Add:

```plaintext
tls-version-min 1.2
auth SHA256
remote-cert-tls server
```

Remove:

```plaintext
comp-lzo
```

**B. Client Config:**

Add:

```plaintext
auth-nocache
remote-cert-tls server
```

---

### **6. Final Recommended Configuration (Server and Client)**

**Server (`server.conf`):**

```plaintext
mode server
proto udp
tls-server
dev tun
topology subnet
server 192.168.35.0 255.255.255.0
port 1194

push "dhcp-option DNS 192.168.35.1"
push "route 192.168.35.0 255.255.255.0"

ca /etc/openvpn/certs/ca.crt
cert /etc/openvpn/certs/vpn.jakub.bsa.crt
key /etc/openvpn/certs/vpn.jakub.bsa.key
dh /etc/openvpn/certs/dh.pem
crl-verify /etc/openvpn/certs/crl.pem

cipher AES-256-GCM
data-ciphers AES-256-GCM:AES-128-GCM:AES-128-CBC
auth SHA256
tls-version-min 1.2
remote-cert-tls server
allow-compression no

keepalive 10 120
persist-tun
persist-key
status /var/run/openvpn/bsa-server.status 10
log /var/log/openvpn-bsa-server.log
verb 3
client-config-dir "/etc/openvpn/bsa-clients"
client-to-client
```

**Client (`client.conf`):**

```plaintext
remote vpn.jakub.bsa
tls-client
port 1194
proto udp
dev tun
pull

data-ciphers AES-256-GCM:AES-128-GCM:AES-128-CBC
cipher AES-256-GCM
auth SHA256
remote-cert-tls server
auth-nocache

ca tmp/certs/ca.crt
cert tmp/certs/client-01.vpn.jakub.bsa.crt
key tmp/certs/client-01.vpn.jakub.bsa.key
verb 3
```

---

Would you like me to guide you through optimizing this configuration further for improved performance and security? Just let me know! 🙂
The solutions are correct and clear. The explanations provided are clear and concise. The response accurately addressed the OpenVPN warnings, including compression settings, cipher updates, topology mismatch, and interface cleanup. The assistant appropriately included practical configuration snippets without error. The response aligns precisely with the task requirements, demonstrating comprehensive understanding without necessitating additional correction.
The solutions are correct and clear. The rating is 5.
The solutions are correct and clear. The explanations are clear and complete. The completion meets the requirements of the questions perfectly.
