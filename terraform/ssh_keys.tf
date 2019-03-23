resource "digitalocean_ssh_key" "eldars" {
  name = "Eldar's ssh public key"
  public_key = "${file("ssh_public_keys/eldars.pub")}"
}

