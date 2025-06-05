terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0.2"
    }
  }
}

provider "docker" {}

# Netzwerk
resource "docker_network" "app_network" {
  name = "app-network"
}

# Volume (z. B. für Redis oder App-Daten)
resource "docker_volume" "app_data" {
  name = "app-data"
}

module "redis" {
  source          = "./modules/containerized_service"
  image           = "redis:7-alpine"
  container_name  = "redis-service"
  internal_port   = 6379
  external_port   = 6379
  environment_vars = []
  network_name    = docker_network.app_network.name
  volume_name     = docker_volume.app_data.name
  mount_path      = "/data"
}

module "app" {
  source          = "./modules/containerized_service"
  image           = "nginxdemos/hello"   # kleines Demo-Webapp-Image
  container_name  = "app-service"
  internal_port   = 80
  external_port   = 5000
  environment_vars = [
    "ENV=production",
    "DEBUG=false"
  ]
  network_name    = docker_network.app_network.name
  volume_name     = null
  mount_path      = null
}
