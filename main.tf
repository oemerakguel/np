terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0.2"
    }
  }
}

provider "docker" {}

resource "docker_network" "app_network" {
  name = "app-network"
}

resource "docker_volume" "app_data" {
  name = "app-data"
}

resource "docker_volume" "nginx_config" {
  name = "nginx-config"
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

module "nginx" {
  source          = "./modules/containerized_service"
  image           = "nginx:alpine"
  container_name  = "nginx-service"
  internal_port   = 80
  external_port   = 80
  environment_vars = []
  network_name    = docker_network.app_network.name

  volumes = [
    {
      container_path = "/etc/nginx"
      volume_name    = "C:/Users/moi/workspace/24-08-on/terraform/np/nginx_conf"
      read_only      = true
    }
  ]
}


module "app" {
  source          = "./modules/containerized_service"
  image           = "simple-node-app"
  container_name  = "app-service"
  internal_port   = 80
  external_port   = 5000
  environment_vars = [
    "ENV=production",
    "DEBUG=false"
  ]
  network_name    = docker_network.app_network.name
  volume_name     = docker_volume.app_data.name
  mount_path      = "/usr/src/app/data"
}
