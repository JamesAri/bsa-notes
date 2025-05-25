To forbid Apache from following any filesystem symlinks, you need to remove the “FollowSymLinks” option (and, if present, “SymLinksIfOwnerMatch”) from the relevant `<Directory>` or `.htaccess` context. For example, in your main server config (e.g. `/etc/apache2/apache2.conf` or `httpd.conf`):

```apache
<Directory "/var/www/html">
    # Remove all symlink-following options…
    Options -FollowSymLinks -SymLinksIfOwnerMatch

    # (other directives…)
</Directory>
```

Or, if you only have `.htaccess` enabled for that directory, put this in its `.htaccess`:

```apache
# Disable following of all symlinks
Options -FollowSymLinks -SymLinksIfOwnerMatch
```

After changing the config, reload or restart Apache:

```bash
# Debian/Ubuntu
systemctl reload apache2

# RHEL/CentOS/AlmaLinux
systemctl reload httpd
```

---

### Alternative: Block via mod\_rewrite

If you want to explicitly block any request to a symlink (rather than relying purely on Options), you can also use `mod_rewrite`:

```apache
<Directory "/var/www/html">
    Options -FollowSymLinks

    RewriteEngine On
    # If the requested path is a symlink, forbid it
    RewriteCond %{REQUEST_FILENAME} -L
    RewriteRule ^ - [F]
</Directory>
```

Here:

* `-FollowSymLinks` ensures the core won’t follow symlinks.
* The `RewriteCond %{REQUEST_FILENAME} -L` checks if the target is a symlink.
* `RewriteRule ^ - [F]` returns a 403 Forbidden whenever a symlink is hit.

---

### Notes

* **Order matters:** Apache evaluates the last-seen `Options` for a directory, so if you have multiple `<Directory>` or `.htaccess` contexts, make sure none of them re-enable `FollowSymLinks`.
* **AllowOverride:** If you use `.htaccess`, ensure that in your main config you have `AllowOverride Options` (or `All`) for that directory; otherwise `.htaccess`’s `Options` line will be ignored.
* **Testing:** After reload, try creating a symlink in your docroot (`ln -s /etc/passwd /var/www/html/badlink`) and request `http://yourserver/badlink`. You should get a 403.
