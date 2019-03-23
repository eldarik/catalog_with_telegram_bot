ansible-development-update-env:
	docker run  -v $(CURDIR):/usr/src/app -w /app williamyeh/ansible:ubuntu18.04 ansible-playbook ansible/development.yml -i ansible/development -vv --tag env


ansible-development-setup-env:
	ansible-playbook ansible/development.yml -i ansible/development -vv

ansible-development-vaults-encrypt:
	ansible-vault encrypt ansible/development/group_vars/all/vault.yml

ansible-development-vaults-decrypt:
	ansible-vault decrypt ansible/development/group_vars/all/vault.yml
