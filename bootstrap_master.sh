echo "Installing puppet master .. "
sudo apt-get update -y
sudo apt-get install -y openssh-server openssh-client

echo "Disabling the firewall .. "
sudo ufw disable
sudo apt-get install -y puppet puppetmaster

echo "Configuring the Master IP Address .. "
sed -i "1s/^/$masterIP $masterDN puppetmaster/" /etc/hosts
sed -i "1s/^/127.0.0.1 $masterDN puppetmaster/" /etc/hosts

echo "Creating and configuring the site.pp file .. "
sudo touch /etc/puppet/manifests/site.pp
# add the modules to be installed
# over binary files

echo "Signing all certificates .. "
sudo puppet cert list
sudo puppet cert sign -all

