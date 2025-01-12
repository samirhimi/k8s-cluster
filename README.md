# Deploying Kubernetes Cluster Using Vagrant, master.sh, and worker.sh

This repository provides a streamlined way to deploy a Kubernetes cluster using Vagrant, along with provisioning scripts for master and worker nodes.

---

## Table of Contents

1. [Introduction](#introduction)
2. [Prerequisites](#prerequisites)
3. [Setup Instructions](#setup-instructions)
4. [Files Overview](#files-overview)
5. [How It Works](#how-it-works)
6. [Troubleshooting](#troubleshooting)
7. [Contributing](#contributing)
8. [License](#license)

---

## Introduction

This project simplifies the process of deploying a Kubernetes cluster on local machines using Vagrant. The setup includes:

- **master.sh**: Configures the Kubernetes control plane.
- **worker.sh**: Configures the Kubernetes worker nodes.

---

## Prerequisites

Before starting, ensure you have the following installed on your system:

- **Vagrant**: [Download Vagrant](https://www.vagrantup.com/)
- **VirtualBox**: [Download VirtualBox](https://www.virtualbox.org/)
- **kubectl** (optional, for interacting with the cluster): [Install kubectl](https://kubernetes.io/docs/tasks/tools/)

---

## Setup Instructions

1. **Clone the Repository**
   ```bash
   git clone https://github.com/your-username/your-repo.git
   cd your-repo
   ```

2. **Start the Vagrant Machines**
   ```bash
   vagrant up
   ```

3. **Access the Master Node**
   ```bash
   vagrant ssh master
   ```

4. **Check Kubernetes Status**
   ```bash
   kubectl get nodes
   ```
   You should see the master and worker nodes listed.

---

## Files Overview

- **Vagrantfile**: Defines the configuration for the virtual machines, including master and worker nodes.
- **master.sh**: Sets up Kubernetes components on the master node, including the control plane.
- **worker.sh**: Configures Kubernetes components on the worker nodes and joins them to the cluster.

---

## How It Works

1. **Vagrantfile** provisions the virtual machines:
   - Creates one master node.
   - Creates multiple worker nodes (configurable).

2. **Provisioning Scripts**:
   - `master.sh` installs Kubernetes, initializes the control plane, and sets up the cluster.
   - `worker.sh` installs Kubernetes on worker nodes and connects them to the master node using the join token.

3. Once the setup is complete, you can interact with the cluster using `kubectl` from the master node or your local machine (if configured).

---

## Troubleshooting

- **Issue**: VMs fail to start.
  - **Solution**: Check VirtualBox and Vagrant installation.

- **Issue**: Worker nodes fail to join the cluster.
  - **Solution**: Verify that the join token in `worker.sh` matches the token generated on the master node.

- **Issue**: Kubernetes components fail to start.
  - **Solution**: Check logs for errors using `journalctl -u kubelet` on the affected node.

---

## Contributing

Contributions are welcome! Please follow these steps:

1. Fork this repository.
2. Create a new branch.
3. Commit your changes.
4. Open a pull request.

---

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

