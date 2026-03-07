packer {
    required_plugins {
        digitalocean = {
            version = ">= 1.0.4"
            source  = "github.com/digitalocean/digitalocean"
        }
        ansible = {
            version = "~> 1"
            source = "github.com/hashicorp/ansible"
        }
        docker = {
            source  = "github.com/hashicorp/docker"
            version = "~> 1"
        }
    }
}

source "digitalocean" "example" {
  api_token    = "YOUR API KEY"
  image        = "ubuntu-22-04-x64"
  region       = "nyc3"
  size         = "s-1vcpu-1gb"
  ssh_username = "root"
}

build {
    sources = ["source.digitalocean.example"]

    provisioner "ansible" {
        playbook_file = "./playbook.yml"
    }

    post-processor "docker-import" {
        repository = "ghcr.io/username/db"
        tag = "0.1"
    }

    post-processor "docker-push" {
        login = true
        login_server = "ghcr.io"
        login_username = "username"
        login_password = "password"
    }
}