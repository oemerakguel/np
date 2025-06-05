output "network_name" {
  value = docker_network.app_network.name
}

output "redis_container_id" {
  value = module.redis.container_id
}

output "redis_container_name" {
  value = module.redis.container_name
}
