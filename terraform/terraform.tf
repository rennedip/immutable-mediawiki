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

resource "digitalocean_ssh_key" "test" {
    name = "Test"
    public_key = file("~/.ssh/test.pub")
}

resource "digitalocean_droplet" "control_plane" {
    count = 1
    name = "control-plane-${count.index}"
    region = "fra1"
    size = "s-2vcpu-2gb"
    image = data.digitalocean_image.debian.id
    vpc_uuid = digitalocean_vpc.main.id
    ssh_keys = [ digitalocean_ssh_key.test.fingerprint ]
    tags = [ "kube_control_plane", "etcd" ]
}

resource "digitalocean_droplet" "worker" {
    for_each = toset(["wiki", "db", "monitoring"])
    name = "worker-${each.key}"
    region = "fra1"
    size = "s-2vcpu-2gb"
    image = data.digitalocean_image.debian.id
    vpc_uuid = digitalocean_vpc.main.id
    ssh_keys = [ digitalocean_ssh_key.test.fingerprint ]
    tags = [ "kube_node" ]
}

resource "digitalocean_project" "immutable_mediawiki" {
    name = "immutable-mediawiki"
    description = "Immutable deployment of MediaWiki"
    purpose = "Web Application"
    environment = "Production"
    resources = concat(
        [for control_plane in digitalocean_droplet.control_plane: control_plane.urn],
        [for worker in values(digitalocean_droplet.worker): worker.urn]
    )
}