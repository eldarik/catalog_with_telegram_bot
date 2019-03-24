resource "digitalocean_droplet" "web-1" {
  private_networking = true
  image  = "docker-18-04"
  name   = "web-1"
  region = "sgp1"
  size   = "s-1vcpu-1gb"
  ssh_keys = [
    "${digitalocean_ssh_key.eldar.fingerprint}"
  ]
}

resource "digitalocean_droplet" "web-2" {
  private_networking = true
  image  = "docker-18-04"
  name   = "web-2"
  region = "sgp1"
  size   = "s-1vcpu-1gb"
  ssh_keys = [
    "${digitalocean_ssh_key.eldar.fingerprint}"
  ]
}
