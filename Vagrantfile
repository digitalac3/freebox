# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  # Base box
  config.vm.box = "ubuntu/trusty64"
  
  # Setup port forwarding
  config.vm.network :forwarded_port, guest: 80, host: 8080, auto_correct: true
  config.vm.network :forwarded_port, guest: 3000, host: 3000, auto_correct: true
  # Custom forwards
  config.vm.network :forwarded_port, guest: 3001, host: 3001, auto_correct: true
  config.vm.network :forwarded_port, guest: 9000, host: 9000, auto_correct: true
  config.vm.network :forwarded_port, guest: 9001, host: 9001, auto_correct: true
  config.vm.network :forwarded_port, guest: 19000, host: 19000, auto_correct: true
  config.vm.network :forwarded_port, guest: 19001, host: 19001, auto_correct: true
  
  # Secondary network
  # Private host-only access
  config.vm.network "private_network", ip: "192.168.33.10"
  
  # Public bridged network to make the guest visible on the physical network
  # config.vm.network "public_network"

  # Host name
  config.vm.hostname = "freebox"
  
  # Shared folders
  # config.vm.synced_folder "../data", "/vagrant_data"
  config.vm.synced_folder "E:\\VM\\backups\\freebox", "/home/vagrant/backups"

  # VM configurations
  config.vm.provider "virtualbox" do |v|
    # v.memory = "1024"
    v.memory = "2048"
    v.cpus = "2"
    v.customize ["modifyvm", :id, "--cpuexecutioncap", "99"]
  end

  # Provision shell script
  config.vm.provision "shell", privileged: false do |s|
    s.path = "provision/setup.sh"
  end
end