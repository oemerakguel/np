variable "app_image" {
  description = "Docker image for the app container"
  type        = string
  default     = "node:18-alpine"
}

variable "app_container_name" {
  description = "Name for the app container"
  type        = string
  default     = "node-app-service"
}

variable "app_ports" {
  description = "Ports mapping for the app container"
  type        = list(object({
    internal = number
    external = number
  }))
  default = [
    {
      internal = 3000
      external = 3000
    }
  ]
}

variable "app_env" {
  description = "Environment variables for the app container"
  type        = list(string)
  default     = []
}
