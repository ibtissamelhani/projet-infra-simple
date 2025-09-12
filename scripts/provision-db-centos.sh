#!/bin/bash

echo "=== Provisioning Database Server (CentOS) ==="

# Mise à jour du système
yum update -y

# Installation de MySQL
yum install -y mysql-server

# Démarrage et activation de MySQL
systemctl start mysqld
systemctl enable mysqld

# Configuration du firewall
firewall-cmd --permanent --add-port=3306/tcp
firewall-cmd --reload

# Sécurisation de MySQL et création de la base
mysql -e "CREATE DATABASE demo_db;"
mysql -e "CREATE USER 'demo_user'@'%' IDENTIFIED BY 'demo_password';"
mysql -e "GRANT ALL PRIVILEGES ON demo_db.* TO 'demo_user'@'%';"
mysql -e "FLUSH PRIVILEGES;"

# Création de la table users
mysql demo_db << 'EOF'
CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nom VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL,
    date_creation TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO users (nom, email) VALUES 
('Alice Martin', 'alice@example.com'),
('Bob Dupont', 'bob@example.com'),
('Charlie Bernard', 'charlie@example.com'),
('Diana Laurent', 'diana@example.com'),
('Etienne Moreau', 'etienne@example.com'),
('Fatima Benali', 'fatima@example.com'),
('Gabriel Simon', 'gabriel@example.com'),
('Hélène Dubois', 'helene@example.com');
EOF

# Configuration MySQL pour accepter les connexions externes
sed -i 's/bind-address.*/bind-address = 0.0.0.0/' /etc/mysql/mysql.conf.d/mysqld.cnf 2>/dev/null || true

# Pour CentOS, le fichier est différent
echo "bind-address = 0.0.0.0" >> /etc/my.cnf

systemctl restart mysqld

echo "=== Database Server provisioning completed ==="