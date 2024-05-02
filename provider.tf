terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0.2"
    }
    proxmox = {
      source  = "bpg/proxmox"
      version = "0.38.1"
    }
    local = {
      source  = "hashicorp/local"
      version = "2.4.1"
    }

  }
}

provider "proxmox" {
  endpoint = var.PROXMOX_API_ENDPOINT
  username = "${var.PROXMOX_USERNAME}@pam"
  password = var.PROXMOX_PASSWORD
  insecure = true
}

resource "null_resource" "cleanup" {
  provisioner "local-exec" {
    command     = "rm -rf output && mkdir -p output && mkdir -p output/etcd"
    working_dir = path.root
  }
}
