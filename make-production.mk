U := root

production-setup:
	ansible-playbook ansible/site.yml -i ansible/production -u $U

production-env-update:
	ansible-playbook ansible/site.yml -i ansible/production -u $U --tag env

production-deploy:
	ansible-playbook ansible/deploy.yml -i ansible/production -u $U

production-deploy-app:
	ansible-playbook ansible/deploy.yml -i ansible/production -u $U --tag app
