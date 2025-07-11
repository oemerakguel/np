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

  env            = var.env
  restart        = "no"
  must_run       = true
  remove_volumes = true
  start          = true

  dynamic "mounts" {
    for_each = var.volume_name != null && var.mount_path != null ? [1] : []
    content {
      target    = var.mount_path
      source    = var.volume_name
      type      = "volume"
      read_only = false
    }
  }


  dynamic "mounts" {
    for_each = var.volume_name != null && var.mount_path != null ? [1] : []

    content {
      target = var.mount_path  # z.B. "/etc/nginx/nginx.conf"
      source = var.volume_name # Volume-Name
      type   = "volume"
      read_only = false
    }
  }

}
