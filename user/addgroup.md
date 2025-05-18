#### **1. `addgroup` Command**

**Purpose:**

* Creates a new user group.
* Manages group properties.
* Typically a Debian-based distribution command (like Ubuntu).

**Basic Syntax:**

```bash
addgroup [options] groupname
```

**Common Options:**

* **`--gid GID`** – Specify a numeric group ID.
* **`--system`** – Create a system group (GID < 1000).
* **`--force-badname`** – Allow group names that are normally restricted.
* **`--help`** – Display help information.

**Examples:**

* Create a basic group:

```bash
addgroup developers
```

* Create a group with a specific GID:

```bash
addgroup --gid 2000 testers
```

* Create a system group:

```bash
addgroup --system loggers
```

* Force a non-standard name:

```bash
addgroup --force-badname my@group
```


(delete from group)
```bash
deluser user group
```
