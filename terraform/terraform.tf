terraform {
    required_providers {
        digitalocean = {
            source = "digitalocean/digitalocean"
            version = "2.79.0"
        }
    }
}


variable "do_token" {
    type = string
    description = "DigitalOcean API Token"
    sensitive = true
}

provider "digitalocean" {
    token = var.do_token
}

resource "digitalocean_vpc" "main" {
    name     = "main"
    region   = "fra1"
    ip_range = "10.10.10.0/24"
}

data "digitalocean_image" "debian" {
    slug = "debian-13-x64"
}

resource "digitalocean_droplet" "control_plane" {
    count = 1
    name = "control-plane-${count.index}"
    region = "fra1"
    size = "s-1vcpu-512mb-10gb"
    image = data.digitalocean_image.debian.id
    vpc_uuid = digitalocean_vpc.main.id
    ssh_keys = [ 54650135 ]
    tags = [ "kube_control_plane", "etcd" ]
}

resource "digitalocean_droplet" "worker" {
    for_each = toset(["wiki", "db", "monitoring"])
    name = "worker-${each.key}"
    region = "fra1"
    size = "s-1vcpu-512mb-10gb"
    image = data.digitalocean_image.debian.id
    vpc_uuid = digitalocean_vpc.main.id
    ssh_keys = [ 54650135 ]
    tags = [ "kube_node" ]
}
