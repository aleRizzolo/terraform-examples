variable "app_name" {
  type    = string
  default = "docdb"
}

variable "admin_user_name" {
  type      = string
  default   = "user"
  sensitive = true
}

variable "admin_user_password" {
  type      = string
  default   = "user"
  sensitive = true
}

variable "auth_type" {
  type    = string
  default = "PLAIN_TEXT"
}

variable "retention_period" {
  type    = number
  default = 1
}

variable "subnet_ids" {
  type = list(number)
}

variable "docdb_security" {
  type = set(string)
}