variable "do_token" {
  description = "DigitalOcean API Token"
  type        = string
  sensitive   = true
}

variable "surname" {
  description = "Your surname for resource naming"
  type        = string
  default     = "turovets"   # змінити на своє прізвище
}

variable "region" {
  description = "DigitalOcean region"
  type        = string
  default     = "fra1"        # Frankfurt
}