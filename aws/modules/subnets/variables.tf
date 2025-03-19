variable "vpc_id" {
  type = string
}

variable "public_cidr" {
  type    = string
  default = "10.0.10.0/16"
}

variable "private_cidrs" {
  type = map(string)
}

variable "internetgw_id" {
  type = string
}

variable "eip_allocation_id" {
  type = string
}