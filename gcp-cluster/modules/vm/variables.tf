variable "region" {
  type        = string
  description = "you gcp region"
}

variable "zone" {
  type        = string
  description = "vm zone"
}

variable "image" {
  type        = string
  description = "image name"
}

variable "mode" {
  type        = string
  description = "vm mode"
}

variable "machine-type" {
  type        = string
  description = "vm type"
}

variable "email" {
  type        = string
  description = "service type email"
  sensitive   = true
}

variable "subnetwork" {
  type        = string
  description = "vm subnetwork"
}