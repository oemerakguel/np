variable "image" {
  type = string
}

variable "container_name" {
  type = string
}

#variable "internal_port" {
#  type = number
#}

#variable "external_port" {
#  type = number
#}

variable "environment_vars" {
  type    = list(string)
  default = []
}

variable "network_name" {
  type = string
}

variable "volume_name" {
  type    = string
  default = null
}

variable "mount_path" {
  type    = string
  default = null
}

variable "ports" {
  description = "Liste der Ports für Container"
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