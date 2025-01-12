#!/bin/bash
echo "bootstrapping workers nodes"

# Setting and configuring the VM
apt-get update && apt-get upgrade -y && apt-get autoremove -y
apt install -y apt-transport-https curl 
sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config
systemctl restart sshd
PASS=$(echo "k8s" | openssl passwd -1 -stdin)
useradd -p  "$PASS" -s /bin/bash -d /home/student -m  student
echo "student  ALL=(ALL:ALL) NOPASSWD: ALL"  >> /etc/sudoers.d/student

# Add host mapping
cat <<EOF > /etc/hosts
192.168.2.200 cp.lab.local  cp 
192.168.2.201 worker1.lab.local  worker1
192.168.2.202 worker2.lab.local  worker2
EOF
