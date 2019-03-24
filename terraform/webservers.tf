resource "digitalocean_droplet" "web-1" {
  private_networking = true
  image  = "ubuntu-18-04-x64"
  name   = "web-1"
  region = "sgp1"
  size   = "s-1vcpu-1gb"
  ssh_keys = [
    "${digitalocean_ssh_key.eldars_workstation.fingerprint}"
  ]
  provisioner "remote-exec" {
    inline = [
      "useradd -p $(openssl passwd -1 ${var.webservers_user_password}) ${var.webservers_user}",
      "usermod -aG sudo ${var.webservers_user}",
      "mkdir /home/${var.webservers_user}/.ssh/",
      "cp --no-preserve=mode,ownership /root/.ssh/authorized_keys /home/${var.webservers_user}/.ssh/"
    ]
  }
}

resource "digitalocean_droplet" "web-2" {
  private_networking = true
  image  = "ubuntu-18-04-x64"
  name   = "web-2"
  region = "sgp1"
  size   = "s-1vcpu-1gb"
  ssh_keys = [
    "${digitalocean_ssh_key.eldars_workstation.fingerprint}"
  ]
  provisioner "remote-exec" {
    inline = [
      "useradd -p $(openssl passwd -1 ${var.webservers_user_password}) ${var.webservers_user}",
      "usermod -aG sudo ${var.webservers_user}",
      "mkdir /home/${var.webservers_user}/.ssh/",
      "cp --no-preserve=mode,ownership /root/.ssh/authorized_keys /home/${var.webservers_user}/.ssh/"
    ]
  }
}
