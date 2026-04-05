terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }
}

provider "digitalocean" {
  token             = var.do_token
  spaces_access_id  = var.spaces_access_key
  spaces_secret_key = var.spaces_secret_key
}

# ─── VPC ───────────────────────────────────────────────
resource "digitalocean_vpc" "main" {
  name     = "${var.surname}-vpc"
  region   = var.region
  ip_range = "10.10.10.0/24"
}

# ─── FIREWALL ──────────────────────────────────────────
resource "digitalocean_firewall" "main" {
  name = "${var.surname}-firewall"

  droplet_ids = [digitalocean_droplet.node.id]

  # Inbound rules
  inbound_rule {
    protocol         = "tcp"
    port_range       = "22"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }
  inbound_rule {
    protocol         = "tcp"
    port_range       = "80"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }
  inbound_rule {
    protocol         = "tcp"
    port_range       = "443"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }
  inbound_rule {
    protocol         = "tcp"
    port_range       = "8000"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }
  inbound_rule {
    protocol         = "tcp"
    port_range       = "8001"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }
  inbound_rule {
    protocol         = "tcp"
    port_range       = "8002"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }
  inbound_rule {
    protocol         = "tcp"
    port_range       = "8003"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

  # Outbound rules
  outbound_rule {
    protocol              = "tcp"
    port_range            = "1-65535"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }
  outbound_rule {
    protocol              = "udp"
    port_range            = "1-65535"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }
}

# ─── DROPLET (VM) ──────────────────────────────────────
resource "digitalocean_droplet" "node" {
  name   = "${var.surname}-node"
  region = var.region
  # 4 CPU, 8GB RAM — достатньо для Minikube
  size   = "s-4vcpu-8gb"
  # Ubuntu 24.04 LTS
  image  = "ubuntu-24-04-x64"
  vpc_uuid = digitalocean_vpc.main.id
}

# ─── SPACES BUCKET ─────────────────────────────────────
resource "digitalocean_spaces_bucket" "main" {
  name   = "${var.surname}-bucket"
  region = var.region
  acl    = "private"
}