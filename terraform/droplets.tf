resource "digitalocean_droplet" "web" {
  private_networking = true
  image  = "ubuntu-18-04-x64"
  name   = "web-1"
  region = "sgp1"
  size   = "s-1vcpu-1gb"
  ssh_keys = [
    "${digitalocean_ssh_key.eldars.fingerprint}"
  ]
  count = 2
}
