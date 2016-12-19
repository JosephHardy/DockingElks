# -*- mode: ruby -*-
# vi: set ft=ruby :

#add environment variables to set up numerous agents ( domain name & IP Address)
masterDN = "jayde-master.qac.local"
agentDN = "jayde-agent.qac.local"
masterIP = "192.168.1.104"
agentIP = "192.168.1.105"
#add more agents using variables

Vagrant.configure("2") do |config|
 
  config.vm.boot_timeout = 400

  config.vm.define "master" do |master|
        master.vm.hostname = masterDN
        master.vm.box = "chad-thompson/ubuntu-trusty64-gui"
		master.vm.synced_folder "shared_master", "/tmp/shared"
        master.vm.network :public_network, ip: masterIP
        master.vm.provision :shell, path: "bootstrap_master.sh", env: {"masterIP" => masterIP, "masterDN" => masterDN, "agentDN" => agentDN, "agentIP" => agentIP}
        master.vm.provider :virtualbox do |masterVM|
            masterVM.gui = true
            masterVM.name = "master"
            masterVM.memory = 4096
            masterVM.cpus = 2
        end
    end
   
    config.vm.define "agent" do |agent|
        agent.vm.hostname = agentDN
        agent.vm.box = "chad-thompson/ubuntu-trusty64-gui"
		agent.vm.synced_folder "shared_agent", "/tmp/shared"
        agent.vm.network :public_network, ip: agentIP
        agent.vm.provision :shell, path: "bootstrap_agent.sh", env: {"masterIP" => masterIP, "masterDN" => masterDN, "agentDN" => agentDN, "agentIP" => agentIP}
        agent.vm.provider :virtualbox do |agentVM|
            agentVM.gui = true
            agentVM.name = "agent1"
            agentVM.memory = 4096
            agentVM.cpus = 2
        end
    end
  

 
end
