# MicroK8s on GCP - Infrastructure & Configuration

This project enables you to provision and configure a MicroK8s cluster on Google Cloud Platform using Terraform for infrastructure and Ansible for node configuration.

## Table of Contents

- [Overview](#overview)
- [Prerequisites](#prerequisites)
- [Project Structure](#project-structure)
- [Terraform Deployment](#terraform-deployment)
- [Ansible Configuration](#ansible-configuration)
- [Using the Makefile](#using-the-makefile)
- [Customization](#customization)
- [Cleanup](#cleanup)
- [Bonus](#bonus)

## Overview

This project combines:

- **Terraform**  
  Provisions 3 instances on GCP (1 master + 2 workers) using the Google provider.  
  Created resources include Compute instances and their persistent disks.

- **Ansible**  
  Configures and integrates the MicroK8s cluster nodes.  
  Specific playbooks and roles (e.g., `microk8s`) handle installation, addon configuration, and worker nodes joining the master.

## Prerequisites

- [Terraform](https://www.terraform.io/downloads) installed
- [Ansible](https://docs.ansible.com/) installed
- [Google Cloud SDK](https://cloud.google.com/sdk) (optional, for GCP project management)
- SSH public key configured in your Terraform variables (`var.ssh_public_key`)
- Google Cloud account and configured project

## Project Structure
```
.
├── README.md
├── Makefile                    # Automation for deployment and configuration
├── terraform/                  # Infrastructure as Code
│   ├── main.tf                # Main Terraform configuration
│   ├── variables.tf           # Variable definitions
│   └── outputs.tf             # Output definitions
└── ansible/                    # Configuration management
    ├── inventory/             # Dynamic inventory generation
    │   └── main.yml
    ├── playbooks/            
    │   ├── cluster.yml        # Main cluster deployment playbook
    │   └── hosts.yml         # Generated inventory file
    ├── roles/
    │   ├── common/           # Common configurations for all nodes
    │   └── microk8s/         # MicroK8s installation and configuration
    └── templates/
        └── hosts.j2          # Template for inventory generation
```

## Usage

### Using the Makefile

The project includes a Makefile for easy automation:

```bash
# Deploy infrastructure
make terraform-init      # Initialize Terraform
make terraform-plan     # Preview changes
make terraform-apply    # Deploy infrastructure

# Configure cluster
make terraform-output-export  # Export Terraform outputs
make ansible-inventory        # Generate Ansible inventory
make ansible-playbooks       # Run configuration playbooks

# Complete deployment
make run-all                 # Run all steps in sequence

# Cleanup
make terraform-destroy       # Destroy infrastructure
```

### Manual Deployment Steps

1. **Terraform Infrastructure Deployment**:
```bash
cd terraform
terraform init
terraform apply
```

2. **Export Terraform Outputs**:
```bash
terraform output -raw master_ip > ../ansible/terraform_output_master_ip.txt
terraform output -json worker_ips > ../ansible/terraform_output_worker_ips.txt
```

3. **Ansible Configuration**:
```bash
cd ../ansible
ansible-playbook inventory/main.yml    # Generate inventory
ansible-playbook playbooks/cluster.yml # Configure cluster
```

## Customization

### Terraform Variables
Edit `terraform/variables.tf` to modify:
- Instance types
- Disk sizes
- Region/Zone
- Project settings

### Ansible Configuration
- Modify roles in `ansible/roles/` for custom node setup
- Adjust playbooks in `ansible/playbooks/` for different deployment scenarios
- Update templates in `ansible/templates/` for inventory customization

## Cleanup

To destroy all resources:
```bash
make terraform-destroy
```

## Troubleshooting

1. **SSH Connection Issues**:
   - Verify your SSH key is correctly configured in Terraform variables
   - Check firewall rules in GCP
   - Use `make ansible-ping` to test connectivity

2. **MicroK8s Cluster Issues**:
   - Check node status: `microk8s status`
   - Verify worker join: `microk8s add-node` on master
   - Check logs: `journalctl -u snap.microk8s.daemon-cluster-agent`

## Security Considerations

- Update firewall rules as needed
- Use secure SSH key management
- Follow principle of least privilege for service accounts
- Regularly update MicroK8s and system packages

## TODO

- [ ] Manage firewall ports on VMs
  - Configure required ports for MicroK8s cluster communication
  - Implement proper firewall rules for node-to-node communication
  - Set up restricted access to control plane endpoints
