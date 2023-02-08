variable "machine_type" {
    type = string
}

variable "service_account" {
  default = null
  type = object({
    email  = string
    scopes = set(string)
  })
}

variable "project_id" {
  type = string
}

variable "network_name" {
  type = string
}

variable "public_subnet" {
  type = string
}

variable "private_subnet" {
  type = string
}

variable "region" {
  type = string
}

variable "zone" {
  type = string
}

variable "image" {
  type = string
}

variable "image_family" {
  type = string
}

variable "image_project" {
  type = string
}


