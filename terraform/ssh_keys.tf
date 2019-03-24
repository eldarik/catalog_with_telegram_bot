resource "digitalocean_ssh_key" "eldars_workstation" {
  name = "Eldar's workstation ssh public key"
  public_key = "${file("ssh_public_keys/eldars_workstation.pub")}"
}

