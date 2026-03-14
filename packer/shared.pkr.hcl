packer {
    required_plugins {
        digitalocean = {
            version = ">= 1.0.4"
            source = "github.com/digitalocean/digitalocean"
        }
        ansible = {
            version = ">= 1.1.4"
            source = "github.com/hashicorp/ansible"
        }
    }
}

variable "do_api_token" {
    default = env("DIGITALOCEAN_API_TOKEN")
    sensitive = true
}