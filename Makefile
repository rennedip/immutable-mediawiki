.PHONY: init deploy ansible destroy

init:
	cd ./terraform && terraform init
	cd ./terraform/ansible && ansible-galaxy install -r requirements.yaml

deploy:
	cd ./terraform && terraform plan -out=${EPOCHSECONDS}.tfplan && terraform apply ${EPOCHSECONDS}.tfplan

ansible:
	cd ./terraform/ansible && ansible-playbook -i ./digitalocean.yml --become --become-user=root --private-key ~/.ssh/test ./deploy.yaml

destroy:
	cd ./terraform && terraform destroy