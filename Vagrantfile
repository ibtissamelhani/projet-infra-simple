# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  
  # Configuration globale
  config.vm.box_check_update = false
  
  # Machine 1: Web Server
  config.vm.define "web-server" do |web|
    web.vm.box = "ubuntu/jammy64"  # Ubuntu 22.04
    web.vm.hostname = "web-server"
    
    # Configuration réseau
    web.vm.network "public_network"  # Accès internet
    web.vm.network "private_network", ip: "192.168.56.10"
    
    # Synchronisation des dossiers
    web.vm.synced_folder "./website/startbootstrap-sb-admin-2/", "/var/www/html/", create: true
    
    # Configuration des ressources
    web.vm.provider "virtualbox" do |vb|
      vb.memory = "1024"
      vb.cpus = 1
      vb.name = "web-server"
    end
    
    # Provisioning
    web.vm.provision "shell", path: "scripts/provision-web-ubuntu.sh"
  end
  
  # Machine 2: Database Server
  config.vm.define "db-server" do |db|
    db.vm.box = "centos/stream9" 
    db.vm.hostname = "db-server"
    
    # Configuration réseau
    db.vm.network "private_network", ip: "192.168.56.20"
    db.vm.network "forwarded_port", guest: 3306, host: 3307
    
    # Configuration des ressources
    db.vm.provider "virtualbox" do |vb|
      vb.memory = "1024"
      vb.cpus = 1
      vb.name = "db-server"
    end
    
    # Provisioning
    db.vm.provision "shell", path: "scripts/provision-db-centos.sh"
  end
  
end