# -*- mode: ruby -*-
# vi:set ft=ruby sw=2 ts=2 sts=2:

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility).

NUM_WORKER_NODE = 2
IP_NW = "192.168.2."
MANAGED_IP_START = 200

Vagrant.configure("2") do |config|
  
  config.vm.box = "ubuntu/focal64"
  config.vm.box_check_update = false
  config.ssh.insert_key = false

# Provision k8s Master Node
    
    config.vm.define "master" do |k8s|
      k8s.vm.hostname = "master.lab.local"
      k8s.vm.provision "shell", path: "master.sh"
      k8s.vm.network "private_network", ip: "192.168.2.200"
      k8s.vm.provider "virtualbox" do |vb|
        vb.memory = "2048"
        vb.cpus = "2"
        vb.name = "master"
      end
    end

# Provision k8s Workers Nodes
  
  (1..NUM_WORKER_NODE).each do |i|  
	  config.vm.define "worker#{i}" do |node|
	    node.vm.hostname = "worker#{i}.lab.local"
      node.vm.network :private_network, ip: IP_NW + "#{MANAGED_IP_START + i}"
	    node.vm.provision "shell", path: "worker.sh"
      node.vm.provider "virtualbox" do |vb|
        vb.cpus = "1"
        vb.memory = "2048"
        vb.name = "worker#{i}"
      end                
    end
  end
end
