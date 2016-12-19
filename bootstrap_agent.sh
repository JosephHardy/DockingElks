echo "Installing puppet .. "
sudo apt-get update -y
sudo apt-get install -y openssh-server openssh-client

echo "Disabling the firewall .. "
sudo ufw disable
sudo apt-get install -y puppet 

echo "Configuring the Agent's IP Address .. "
sed -i "1s/^/$agentIP $agentDN puppet/" /etc/hosts
sed -i "1s/^/127.0.0.1 $agentDN puppet/" /etc/hosts
sed -i "1s/^/$masterIP $masterDN puppetmaster/" /etc/hosts

echo "Configuring the the default server to master fqdn .. "
sed -i "2s/^/server=$masterDN/" /etc/puppet/puppet.conf

echo "Testing and enabling the service .. "
sudo puppet agent --test --server=jayde_master.qac.local
sudo puppet agent --enable
sudo puppet agent --test --server=jayde_master.qac.local