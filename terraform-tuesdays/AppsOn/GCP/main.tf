###########################
# CONFIGURATION
###########################

terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 3.0"

    }
  }

  backend "azurerm" {
    
  }
}

###########################
# VARIABLES
###########################

variable "project_id" {
  type = string
  description = "Project ID to create VPC in"
}

variable "region" {
  type        = string
  description = "Region in GCP"
  default     = "us-central1"
}

variable "prefix" {
  type        = string
  description = "prefix for naming"
  default     = "flan"
}

###########################
# PROVIDERS
###########################

provider "google" {
  project = var.project_id
  region = var.region
}

###########################
# DATA SOURCES
###########################

locals {
  name = "${var.prefix}-${random_id.seed.hex}"
}

###########################
# RESOURCES
###########################

resource "random_id" "seed" {
  byte_length = 4
}

resource "google_compute_network" "gcp" {
  name = local.name
  auto_create_subnetworks = false
  routing_mode = "GLOBAL"
}

resource "google_compute_subnetwork" "gcp" {
  count = 2
  name = "${local.name}-${count.index}"
  ip_cidr_range = cidrsubnet("10.0.0.0/16", 8, count.index)
  region = var.region
  network = google_compute_network.gcp.id
}

resource "google_compute_route" "egress" {
  name = "egress-internet"
  description = "route through IGW to access internet"
  dest_range = "0.0.0.0/0"
  tags = [ "egress-inet" ]
  network = google_compute_network.gcp.id
  next_hop_gateway = "default-internet-gateway"
}