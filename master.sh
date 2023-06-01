#!/bin/sh

echo "bootstrapping master node"

# Setting and configuring the VM
apt-get update && apt-get upgrade -y && apt-get autoremove -y
apt-get install -y apt-transport-https curl 
sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config
systemctl restart sshd
PASS=$(echo "k8s" | openssl passwd -1 -stdin)
useradd -p  "$PASS" -s /bin/bash -d /home/student -m  student
echo "student  ALL=(ALL:ALL) NOPASSWD: ALL"  >> /etc/sudoers.d/student

# Add host mapping
cat <<EOF > /etc/hosts
192.168.2.200 master.lab.local
192.168.2.201 worker1.lab.local
192.168.2.202 worker2.lab.local
EOF

# sysctl params required by setup, params persist across reboots, load br_netfilter module
cat << EOF | tee /etc/sysctl.d/kubernetes.conf<<EOF
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1
EOF

# Disable swap
swapoff -a
sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab

#  Configure containerd modules
cat <<EOF | tee /etc/modules-load.d/containerd.conf
overlay
br_netfilter
EOF

modprobe overlay
modprobe br_netfilter

# Setup required sysctl params, these persist across reboots.
cat <<EOF | tee /etc/sysctl.d/99-kubernetes-cri.conf
net.bridge.bridge-nf-call-iptables  = 1
net.ipv4.ip_forward                 = 1
net.bridge.bridge-nf-call-ip6tables = 1
EOF

sysctl --system

# Add containerd repository
apt-get install -y curl gnupg2 software-properties-common apt-transport-https ca-certificates
wget -O - https://download.docker.com/linux/ubuntu/gpg > ./docker.key
gpg --no-default-keyring --keyring ./docker.gpg --import ./docker.key
gpg --no-default-keyring --keyring ./docker.gpg --export > ./docker-archive-keyring.gpg
mv ./docker-archive-keyring.gpg /etc/apt/trusted.gpg.d/
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

# Install container packages

apt-get update -y
apt-get install -y containerd.io
mkdir -p /etc/containerd
containerd config default | tee /etc/containerd/config.toml
sed -i 's/SystemdCgroup \= false/SystemdCgroup \= true/g' /etc/containerd/config.toml
systemctl restart containerd
systemctl enable containerd

# Installing kubeadm, kubelet and kubectl 
curl -fsSL  https://packages.cloud.google.com/apt/doc/apt-key.gpg|gpg --dearmor -o /etc/apt/trusted.gpg.d/k8s.gpg
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg |apt-key add -
apt-add-repository "deb http://apt.kubernetes.io/ kubernetes-xenial main"
apt-get update -y
apt-get install -y vim git wget kubelet kubeadm kubectl
apt-mark hold kubelet kubeadm kubectl

# Create kubeadm config for initiate cluster

kubeadm init --apiserver-advertise-address=192.168.2.200 --pod-network-cidr=172.17.0.0/16 >> $HOME/kubeinit.log

# Copy kube admin config

mkdir /home/student/.kube
cp /etc/kubernetes/admin.conf   /home/student/.kube/config
chmod 775 /home/student/.kube/config
# Deploy calico network

kubectl create -f https://raw.githubusercontent.com/projectcalico/calico/v3.26.0/manifests/tigera-operator.yaml
curl https://raw.githubusercontent.com/projectcalico/calico/v3.26.0/manifests/custom-resources.yaml -O
kubectl create -f custom-resources.yaml
