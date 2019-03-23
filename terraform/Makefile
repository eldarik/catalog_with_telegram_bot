terraform-init:
	terraform init

terraform-plan:
	terraform plan -var "do_token=${DO_TOKEN}"

terraform-upload-ssh-keys:
	terraform apply -target=digitalocean_ssh_key.eldars -var "do_token=${DO_TOKEN}"

terraform-create-droplets:
	terraform apply -target=digitalocean_droplet.web-1 -var "do_token=${DO_TOKEN}" && \
		terraform apply -target=digitalocean_droplet.web-2 -var "do_token=${DO_TOKEN}"

terraform-destroy-droplets:
	terraform destroy -target=digitalocean_droplet.web-1 -var "do_token=${DO_TOKEN}" && \
		terraform destroy -target=digitalocean_droplet.web-2 -var "do_token=${DO_TOKEN}"
