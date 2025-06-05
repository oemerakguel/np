resource "docker_container" "this" {
  name  = var.container_name
  image = var.image

  env = var.environment_vars

  ports {
    internal = var.internal_port
    external = var.external_port
  }

  networks_advanced {
    name = var.network_name
  }

  dynamic "volumes" {
    for_each = var.volume_name != null && var.mount_path != null ? [1] : []

    content {
      volume_name    = var.volume_name
      container_path = var.mount_path
      read_only      = false
    }
  }

  restart = "no"
  must_run = true
  start = true
}
