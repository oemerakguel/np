variable "image" {
  type = string
}

variable "container_name" {
  type = string
}

variable "network_name" {
  type = string
}

variable "ports" {
  type = list(object({
    internal = number
    external = number
  }))
  default = []
}

variable "env" {
  type    = list(string)
  default = []
}

variable "volumes" {
  type = list(object({
    container_path = string
    volume_name    = string
    read_only      = optional(bool, false)
  }))
  default = []
}


resource "docker_container" "this" {
  image = var.image
  name  = var.container_name

  networks_advanced {
    name = var.network_name
  }

  dynamic "ports" {
    for_each = var.ports
    content {
      internal = ports.value.internal
      external = ports.value.external
      protocol = "tcp"
      ip       = "0.0.0.0"
    }
  }

  env           = var.env
  restart       = "no"
  must_run      = true
  remove_volumes = true
  start         = true

  dynamic "volumes" {
    for_each = var.volumes
    content {
      container_path = volumes.value.container_path
      volume_name    = volumes.value.volume_name
      read_only      = lookup(volumes.value, "read_only", false)
    }
  }
}

