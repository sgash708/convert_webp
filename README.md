# Statement
* CentOS7
* Apache ver2.4

# Install
```bash
chmod a+x install.sh convert_webp.sh
./install.sh
```

# Usage
Let’s run this script on the /var/www/html/webp directory in the background,
using &. Let’s also redirect standard output and standard error to an ~/output.log, to store output in an readily available location

```
./watch_webp.sh /var/www/html/webp > output.log 2>&1 &
```

# Serving WebP images
* example (.htaccess)

```:.htaccess
<ifModule mod_rewrite.c>
  RewriteEngine On
  RewriteCond %{HTTP_ACCEPT} image/webp
  RewriteCond %{REQUEST_URI}  (?i)(.*)(\.jpe?g|\.png)$
  RewriteCond %{DOCUMENT_ROOT}%1.webp -f
  RewriteRule (?i)(.*)(\.jpe?g|\.png)$ %1\.webp [L,T=image/webp,R]
</IfModule>

<IfModule mod_headers.c>
  Header append Vary Accept env=REDIRECT_accept
</IfModule>

AddType image/webp .webp
```