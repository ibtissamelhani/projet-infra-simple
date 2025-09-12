#!/bin/bash

echo "=== Provisioning Web Server (Ubuntu) ==="

# Mise à jour du système
apt-get update -y

# Installation de Nginx
apt-get install -y nginx git

# Démarrage et activation de Nginx
systemctl start nginx
systemctl enable nginx

# Configuration du firewall
ufw allow 'Nginx Full'
ufw allow OpenSSH
ufw --force enable

# Clone d'un repository GitHub public
cd /tmp
git clone https://github.com/startbootstrap/startbootstrap-creative.git
cp -r startbootstrap-creative/* /var/www/html/
chown -R www-data:www-data /var/www/html/
chmod -R 755 /var/www/html/

# Configuration Nginx pour servir le site
cat > /etc/nginx/sites-available/default << 'EOF'
server {
    listen 80 default_server;
    listen [::]:80 default_server;
    
    root /var/www/html;
    index index.html index.htm;
    server_name _;
    
    location / {
        try_files $uri $uri/ =404;
    }
}
EOF

# Redémarrage de Nginx
systemctl restart nginx

echo "=== Web Server provisioning completed ==="