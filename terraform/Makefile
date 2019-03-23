terraform-init:
	terraform init

terraform-plan:
	terraform plan -var "do_token=${DO_TOKEN}"

terraform-upload-ssh-keys:
	terraform apply -target=digitalocean_ssh_key.eldars -var "do_token=${DO_TOKEN}"

terraform-create-droplets:
	terraform apply -target=digitalocean_droplet.web -var "do_token=${DO_TOKEN}"

terraform-destroy-droplets:
	terraform destroy -target=digitalocean_droplet.web -var "do_token=${DO_TOKEN}"
