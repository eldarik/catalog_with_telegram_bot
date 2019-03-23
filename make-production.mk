U := deploy

production-setup:
	ansible-playbook ansible/site.yml -i ansible/production --ask-become-pass

production-env-update:
	ansible-playbook ansible/site.yml -i ansible/production -u $U --tag env --ask-become-pass

production-deploy:
	ansible-playbook ansible/deploy.yml -i ansible/production -u $U

production-deploy-app:
	ansible-playbook ansible/deploy.yml -i ansible/production -u $U --tag app
