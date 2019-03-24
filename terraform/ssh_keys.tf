resource "digitalocean_ssh_key" "eldar" {
  name = "Eldar's workstation ssh public key"
  public_key = "${file("../files/eldar.pub")}"
}

