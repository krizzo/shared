# Add custom provisioning steps here, like yum install -y somethingIWant
cp /vagrant/.vagrant/.home/.gitconfig /home/vagrant
cp -r /vagrant/.vagrant/.home/.ssh/ /home/vagrant
cp -R /vagrant/* /home/vagrant/
chown -R vagrant:vagrant /home/vagrant

yum update -y
yum -y install epel-release vim nfs-utils
yum -y install python-pip python
pip install --upgrade pip
yum -y upgrade python*

# Set SELinux to permissive so it will only warn rather than block.
sudo sed -i '/^SELINUX=/ s/enforcing/permissive/' /etc/selinux/config 
sudo setenforce 0

# Install and setup dockera
echo "--> Installing Docker and configuring it"
yum remove docker
yum -y install docker
systemctl enable docker
systemctl start docker
chown vagrant:vagrant /var/run/docker.sock

sudo groupadd docker
usermod -aG docker ${USER}
usermod -aG nfsnobody ${USER}
systemctl enable docker
systemctl start docker

# Setup NFS mounts
mkdir /NFS/MOUNT/PATH
mkdir /NFS/MOUNT/PATH
echo -e "192.168.1.34:/NFS/SHARE /NFS/MOUNT/PATH/ nfs defaults 0 0\n192.168.1.34:/NFS/SHARE /NFS/MOUNT/PATH/ nfs defaults 0 0" | sudo tee -a > /dev/null /etc/fstab
mount /NFS/MOUNT/PATH

## Open up plex ports
sudo firewall-cmd --add-port=32400/tcp
sudo firewall-cmd --add-port=32400/tcp --permanent
sudo firewall-cmd --add-port=32400/udp
sudo firewall-cmd --add-port=32400/udp --permanent
sudo firewall-cmd --add-port=32469/tcp
sudo firewall-cmd --add-port=32469/tcp --permanent
sudo firewall-cmd --add-port=32469/udp
sudo firewall-cmd --add-port=32469/udp --permanent
sudo firewall-cmd --add-port=1900/udp
sudo firewall-cmd --add-port=1900/udp --permanent
sudo firewall-cmd --add-port=5353/udp
sudo firewall-cmd --add-port=5353/udp --permanent

## Open up ports for deluge docker container
sudo firewall-cmd --add-port=8112/tcp
sudo firewall-cmd --add-port=8112/tcp --permanent

