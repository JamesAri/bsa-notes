### **/etc/crypttab vs /etc/fstab**

Both **/etc/crypttab** and **/etc/fstab** are critical Linux configuration files for managing storage devices, but they serve different purposes:

---

#### **/etc/crypttab (Encrypted Partitions)**

**Purpose:**

* **/etc/crypttab** is used to define encrypted partitions that should be automatically decrypted and mounted at boot time.

**Key Features:**

* Works with **dm-crypt** and **LUKS (Linux Unified Key Setup)**.
* Pairs with **/etc/fstab** for mounting the decrypted volumes.
* Requires the **cryptsetup** package.

**Typical Format:**

```bash
<name> <device> <keyfile> <options>
```

**Example Entry:**

```bash
cryptdisk1 /dev/sda5 /etc/keys/disk.key luks
cryptdisk2 /dev/sdb1 none luks
```

**Field Breakdown:**

* **name:** The name of the decrypted device (appears as **/dev/mapper/<name>**).
* **device:** The underlying encrypted partition (e.g., **/dev/sda5**).
* **keyfile:** Path to a key file or **none** for password prompt.
* **options:** LUKS, discard, or other **cryptsetup** options.

**Key Considerations:**

* **Key File Security:** Key files should have strict permissions (e.g., **chmod 600**).
* **Startup Order:** If you use **UUIDs** or **LABELs**, make sure they match the underlying block device.
* **Remote Unlocking:** Can integrate with **dropbear** for remote unlocking.

