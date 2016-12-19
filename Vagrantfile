# -*- mode: ruby -*-
# vi: set ft=ruby :

#add environment variables to set up numerous agents ( domain name & IP Address)
#add more agents using variables

Vagrant.configure("2") do |config|
 
  config.vm.boot_timeout = 400
  
  echo "Configuring the Master Virtual Machine .. " 
  config.vm.define "master" do |master|
        master.vm.hostname = "jayde-master.qac.local"
        master.vm.box = "chad-thompson/ubuntu-trusty64-gui"
		master.vm.synced_folder "shared_master", "/tmp/shared"
        master.vm.network :public_network, :public_network => "wlan0", ip: "192.168.1.104"
        master.vm.provision :shell, path: "bootstrap_master.sh"
        master.vm.provider :virtualbox do |masterVM|
            masterVM.gui = true
            masterVM.name = "master"
            masterVM.memory = 4096
            masterVM.cpus = 2
        end
    end
   
	echo "Configuring the Agent Virtual Machine .. "
    config.vm.define "agent" do |agent|
        agent.vm.hostname = "jayde-agent.qac.local"
        agent.vm.box = "chad-thompson/ubuntu-trusty64-gui"
		agent.vm.synced_folder "shared_agent", "/tmp/shared"
        agent.vm.network :public_network, :public_network => "wlan0", ip: "192.168.1.105"
        agent.vm.provision :shell, path: "bootstrap_agent.sh"
        agent.vm.provider :virtualbox do |agentVM|
            agentVM.gui = true
            agentVM.name = "agent1"
            agentVM.memory = 4096
            agentVM.cpus = 2
        end
    end
  

 
end
