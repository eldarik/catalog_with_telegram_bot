U := deploy

production-setup:
	ansible-playbook ansible/site.yml -i ansible/production --ask-become-pass
