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

variable "network_tier" {
  description = "Network network_tier"
  default     = "PREMIUM"
}

# variable "backends" {
#   description = "Map backend indices to list of backend maps."
#   type = map(object({
#     port                    = number
#     protocol                = string
#     port_name               = string
#     description             = string
#     enable_cdn              = bool
#     security_policy         = string
#     custom_request_headers  = list(string)
#     custom_response_headers = list(string)

#     timeout_sec                     = number
#     connection_draining_timeout_sec = number
#     session_affinity                = string
#     affinity_cookie_ttl_sec         = number

#     health_check = object({
#       check_interval_sec  = number
#       timeout_sec         = number
#       healthy_threshold   = number
#       unhealthy_threshold = number
#       request_path        = string
#       port                = number
#       host                = string
#       logging             = bool
#     })

#     log_config = object({
#       enable      = bool
#       sample_rate = number
#     })

#     groups = list(object({
#       group = string

#       balancing_mode               = string
#       capacity_scaler              = number
#       description                  = string
#       max_connections              = number
#       max_connections_per_instance = number
#       max_connections_per_endpoint = number
#       max_rate                     = number
#       max_rate_per_instance        = number
#       max_rate_per_endpoint        = number
#       max_utilization              = number
#     }))
#     iap_config = object({
#       enable               = bool
#       oauth2_client_id     = string
#       oauth2_client_secret = string
#     })
#   }))
# }