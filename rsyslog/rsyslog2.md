To set up a backup `rsyslog` server that receives logs via `*.*    @192.168.1.100:514`, follow these steps on the backup server (IP: `192.168.1.100`):

---

## **Step 1: Install rsyslog**

If not already installed:

```bash
sudo apt update && sudo apt install rsyslog  # Debian/Ubuntu
# or
sudo yum install rsyslog                     # RHEL/CentOS
```

---

## **Step 2: Enable Rsyslog to Receive Remote Logs**

Edit the main config:

```bash
sudo nano /etc/rsyslog.conf
```

Uncomment or add these lines to enable **UDP** reception on port 514:

```conf
module(load="imudp")
input(type="imudp" port="514")
```

**For TCP** reception, also add:

```conf
module(load="imtcp")
input(type="imtcp" port="514")
```

Save and close the file.

---

## **Step 3: Open Firewall Port**

**For UDP**:

```bash
sudo ufw allow 514/udp  # or
sudo firewall-cmd --add-port=514/udp --permanent && sudo firewall-cmd --reload
```

**For TCP (optional):**

```bash
sudo ufw allow 514/tcp  # or
sudo firewall-cmd --add-port=514/tcp --permanent && sudo firewall-cmd --reload
```

---

## **Step 4: Organize Incoming Logs (Optional but Recommended)**

Create a config to store remote logs by host:

```bash
sudo nano /etc/rsyslog.d/10-remote.conf
```

Add:

```conf
$template RemoteLogs,"/var/log/remote/%HOSTNAME%/%PROGRAMNAME%.log"
*.* ?RemoteLogs
```

Create the directory and set permissions:

```bash
sudo mkdir -p /var/log/remote
sudo chown syslog:adm /var/log/remote
```

---

## **Step 5: Restart rsyslog**

```bash
sudo systemctl restart rsyslog
```

---

## **Step 6: Configure the Client(s)**

On each client, add to `/etc/rsyslog.conf` or `/etc/rsyslog.d/remote.conf`:

```conf
*.* @192.168.1.100:514   # Use @@ for TCP
```

Restart rsyslog on the client:

```bash
sudo systemctl restart rsyslog
```

---

## **Step 7: Test It**

On the client, run:

```bash
logger "Test message from client"
```

On the server, check:

```bash
sudo find /var/log/remote -type f
sudo tail -f /var/log/remote/*/*.log
```

---

Let me know if you want TLS encryption, log rotation, or high availability setup as well.
