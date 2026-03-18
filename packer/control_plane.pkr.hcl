source "digitalocean" "control_plane" {
  api_token = var.do_api_token
  image = "debian-13-x64"
  region = "fra1"
  size = "s-1vcpu-512mb-10gb"
  ssh_username = "root"
}

build {
    sources = ["source.digitalocean.control_plane"]

    provisioner "ansible" {
        playbook_file = "./ansible/control_plane.yaml"
    }
}