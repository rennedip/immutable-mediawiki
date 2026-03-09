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
        playbook_file = "./ansible/control_plane.yaml"
    }

    post-processor "digitalocean-import" {
        api_token         = "{{user `token`}}"
        spaces_key        = "{{user `key`}}"
        spaces_secret     = "{{user `secret`}}"
        spaces_region     = "nyc3"
        space_name        = "import-bucket"
        image_name        = "ubuntu-18.10-minimal-amd64"
        image_description = "Packer import {{timestamp}}"
        image_regions     = ["nyc3", "nyc2"]
        image_tags        = ["custom", "packer"]
    }
}