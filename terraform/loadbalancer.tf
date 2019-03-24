resource "digitalocean_loadbalancer" "public" {
  name = "loadbalancer-1"
  region = "sgp1"

  forwarding_rule {
    entry_port = 8080
    entry_protocol = "http"

    target_port = 8080
    target_protocol = "http"
  }

  healthcheck {
    port = 22
    protocol = "tcp"
  }

  droplet_ids = [
    "${digitalocean_droplet.web-1.id}",
    "${digitalocean_droplet.web-2.id}"
  ]
}
