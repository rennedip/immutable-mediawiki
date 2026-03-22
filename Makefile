.PHONY: test init deploy ansible destroy

test:
	kind create cluster --name test
	kubectl create secret generic regcred --from-file=.dockerconfigjson=$HOME/.docker/config.json --type=kubernetes.io/dockerconfigjson
	cd ./kubernetes/apps/web && kubectl apply -f .

testprune:
	cd ./kubernetes/apps/web && kubectl apply --prune --all -f .

init:
	cd ./terraform && terraform init
	cd ./terraform/ansible && ansible-galaxy install -r requirements.yaml

deploy:
	cd ./terraform && terraform plan -out=${EPOCHSECONDS}.tfplan && terraform apply ${EPOCHSECONDS}.tfplan

ansible:
	cd ./terraform/ansible && ansible-playbook -i ./digitalocean.yml --become --become-user=root --private-key ~/.ssh/test ./deploy.yaml

destroy:
	cd ./terraform && terraform destroy