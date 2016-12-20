echo "Installing puppet master .. "
sudo apt-get update -y
sudo apt-get install -y openssh-server openssh-client

echo "Disabling the firewall .. "
sudo ufw disable
sudo apt-get install -y puppet puppetmaster

echo "Configuring the Master IP Address .. "
sed -i "1s/^/$masterIP $masterDN puppetmaster\n/" /etc/hosts
sed -i "1s/^/127.0.0.1 $masterDN puppetmaster\n/" /etc/hosts

echo "Creating and configuring the site.pp file .. "
sudo touch /etc/puppet/manifests/site.pp
# add the modules to be installed
# over binary files

echo "Signing all certificates .. "
sed -i "16s/^/autosign=true/" /etc/puppet/puppet.conf

sudo cp -r /tmp/shared/modules/elk /etc/puppet/modules
sudo cp -r /tmp/shared/modules/haproxy /etc/puppet/modules
sudo cp -r /tmp/shared/modules/java /etc/puppet/modules
sudo cp -r /tmp/shared/modules/jenkins /etc/puppet/modules
sudo cp -r /tmp/shared/modules/jira /etc/puppet/modules
sudo cp -r /tmp/shared/modules/maven /etc/puppet/modules
sudo cp -r /tmp/shared/modules/nexus /etc/puppet/modules
sudo cp -r /tmp/shared/modules/packer /etc/puppet/modules
sudo cp -r /tmp/shared/modules/snort /etc/puppet/modules
sudo cp -r /tmp/shared/modules/tomcat /etc/puppet/modules

sudo mkdir /opt/packer
sudo mkdir /opt/binaries

sudo cp -r /tmp/shared/binaries/elk-binary /opt/binaries
sudo cp -r /tmp/shared/binaries/haproxy-binary /opt/binaries
sudo cp -r /tmp/shared/binaries/java-binary /opt/binaries
sudo cp -r /tmp/shared/binaries/jenkins-binary /opt/binaries
sudo cp -r /tmp/shared/binaries/jira-binary /opt/binaries
sudo cp -r /tmp/shared/binaries/maven-binary /opt/binaries
sudo cp -r /tmp/shared/binaries/nexus-binary /opt/binaries
sudo cp -r /tmp/shared/binaries/packer-binary /opt/binaries
sudo cp -r /tmp/shared/binaries/snort-binary /opt/binaries
sudo cp -r /tmp/shared/binaries/tomcat-binary /opt/binaries

