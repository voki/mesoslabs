# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!

$install_salt_master = <<SCRIPT
	curl -L https://bootstrap.saltstack.com | sudo sh -s -- -M
SCRIPT

$install_salt_slave = <<SCRIPT
	curl -L https://bootstrap.saltstack.com | sudo sh
SCRIPT

$sleep = <<SCRIPT
	sleep 10
SCRIPT


VAGRANTFILE_API_VERSION = "2"




Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
   config.vm.provider :virtualbox do |vb|
      vb.memory = 4096
      vb.cpus = 1
   end

  config.vm.define "slave1" do |slave|
    slave.vm.box = "bento/centos-7.1"
    slave.vm.host_name = "slave-1"
    slave.vm.network "private_network", ip: "192.168.33.23"
    slave.vm.synced_folder "salt/roots/", "/srv/salt"
    slave.vm.provision "shell", inline: $install_salt_slave
    slave.vm.provision :salt do |salt|
              salt.minion_config = "slave1.yml"
    end
  end  

###################################################################

 config.vm.define "slave2" do |slave|
    slave.vm.box = "bento/centos-7.1"
    slave.vm.host_name = "slave-2"
    slave.vm.network "private_network", ip: "192.168.33.24"
    slave.vm.synced_folder "salt/roots/", "/srv/salt"
    slave.vm.provision "shell", inline: $install_salt_slave
    slave.vm.provision :salt do |salt|
              salt.minion_config = "slave2.yml"
    end
  end  

###################################################################

 config.vm.define "slave3" do |slave|
    slave.vm.box = "bento/centos-7.1"
    slave.vm.host_name = "slave-3"
    slave.vm.network "private_network", ip: "192.168.33.25"
    slave.vm.synced_folder "salt/roots/", "/srv/salt"
    slave.vm.provision "shell", inline: $install_salt_slave
    slave.vm.provision :salt do |salt|
              salt.minion_config = "slave3.yml"
    end
  end  

###################################################################

  config.vm.define "master3" do |master|
    master.vm.box = "bento/centos-7.1"
    master.vm.host_name = "master-3"
    master.vm.network "private_network", ip: "192.168.33.22"
    master.vm.synced_folder "salt/roots/", "/srv/salt"
    master.vm.provision "shell", inline: $install_salt_slave
    master.vm.provision :salt do |salt|
 
       #salt.run_highstate = true
       salt.minion_config = "master3.yml"
    end
  end

###################################################################
  config.vm.define "master2" do |master|
    master.vm.box = "bento/centos-7.1"
    master.vm.host_name = "master-2"
    master.vm.network "private_network", ip: "192.168.33.21"
    master.vm.synced_folder "salt/roots/", "/srv/salt"
    master.vm.provision "shell", inline: $install_salt_slave
    master.vm.provision :salt do |salt|
 
       #salt.run_highstate = true
       salt.minion_config = "master2.yml"
    end
  end

###################################################################
  config.vm.define "master1" do |master|
    master.vm.box = "bento/centos-7.1"
    master.vm.host_name = "master-1"
    master.vm.network "private_network", ip: "192.168.33.20"
    master.vm.synced_folder "salt/roots/", "/srv/salt"
    master.vm.provision "shell", inline: $install_salt_master
    master.vm.provision :salt do |salt|
 
       #salt.run_highstate = true
       salt.minion_config = "master1.yml"
    end
    master.vm.provision "shell", inline: $sleep
    master.vm.provision "shell", inline: "salt-key -A -y"
    master.vm.provision "shell", inline: $sleep
    master.vm.provision "shell", inline: "salt '*' state.highstate"
  end

end