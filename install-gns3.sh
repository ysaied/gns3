#! /bin/bash

sudo rm /lib/systemd/system/gns3.service
sudo -r rm $HOME/GNS3
sudo userdel gns3
sudo apt remove -y gns3-gui > /dev/null
sudo apt remove -y gns3-iou > /dev/null

sudo add-apt-repository -y ppa:gns3/ppa
sudo apt -y update > /dev/null
sudo apt -y upgrade > /dev/null
sudo apt install -y apt-transport-https > /dev/null
sudo apt install -y ca-certificates > /dev/null
sudo apt install -y curl > /dev/null
sudo apt install -y software-properties-common > /dev/null
sudo apt install -y qemu qemu-kvm qemu-utils > /dev/null

sudo apt-get remove docker docker-engine docker.io
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository -y "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" > /dev/null
sudo apt install -y docker-ce > /dev/null

sudo apt install -y gns3-gui > /dev/null
sudo dpkg --add-architecture i386 > /dev/null
sudo apt install -y gns3-iou > /dev/null

sudo useradd -G kvm,ubridge,wireshark,docker,libvirtd,libvirt-qemu -m gns3
sudo passwd gns3

(sudo touch /lib/systemd/system/gns3.service)

echo "[Unit]
Description=GNS3 server
Wants=network-online.target
After=network.target network-online.target

[Service]
Type=forking
User=gns3
Group=gns3
PermissionsStartOnly=true
ExecStartPre=/bin/mkdir -p /var/log/gns3 /var/run/gns3
ExecStartPre=/bin/chown -R gns3:gns3 /var/log/gns3 /var/run/gns3
ExecStart=/usr/share/gns3/gns3-server/bin/gns3server --log /var/log/gns3/gns3.log --pid /var/run/gns3/gns3.pid --daemon
Restart=on-abort
PIDFile=/var/run/gns3/gns3.pid

[Install]
WantedBy=multi-user.target " | sudo tee /lib/systemd/system/gns3.service > /dev/null

sudo chmod 755 /lib/systemd/system/gns3.service
sudo systemctl daemon-reload
sudo systemctl enable gns3.service

echo "Please Reboot"

