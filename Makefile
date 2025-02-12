TF_WORKING_DIR ?= terraform
ASNIBLE_WORKING_DIR ?= ansible

.PHONY: terraform-init
terraform-init:
		terraform -chdir=${TF_WORKING_DIR} init

.PHONY: terraform-paln
terraform-plan:
		terraform -chdir=${TF_WORKING_DIR} plan

.PHONY: terraform-apply
terraform-apply:
		terraform -chdir=${TF_WORKING_DIR} apply --auto-approve

.PHONY: terraform-destroy
terraform-destroy:
		terraform -chdir=${TF_WORKING_DIR} destroy --auto-approve

.PHONY: terraform-refresh
terraform-refresh:
		terraform refresh 

.PHONY: terraform-output-export
terraform-output-export:
		terraform -chdir=${TF_WORKING_DIR} output -raw master_ip > ansible/terraform_output_master_ip.txt
		terraform -chdir=${TF_WORKING_DIR} output -json worker_ips > ansible/terraform_output_worker_ips.txt

.PHONY: ansible-inventory
ansible-inventory:
		ansible-playbook ${ASNIBLE_WORKING_DIR}/inventory/main.yml

.PHONY: ansible-playbooks-check
ansible-playbook-check:
		ansible-playbook -i ${ASNIBLE_WORKING_DIR}/playbooks/hosts.yml ansible/playbooks/cluster.yml --check -vvv

.PHONY: ansible-playbooks
ansible-playbooks:
		ansible-playbook -i ${ASNIBLE_WORKING_DIR}/playbooks/hosts.yml ansible/playbooks/cluster.yml -vvv

.PHONY: ansible-ping
ansible-ping:
		ansible all -m ping -i ${ASNIBLE_WORKING_DIR}/playbooks/hosts.yml

.PHONY: ansible-debug-hosts
ansible-debug-hosts: 
		ansible all -m ansible.builtin.setup > hosts.log

.PHONY: run-all
run-all: 
		make terraform-apply && \
		make terraform-output-export && \
		make ansible-inventory && \
		make ansible-ping && \
		make ansible-playbooks
