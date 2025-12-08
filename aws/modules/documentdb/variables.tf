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

variable "docdb_security" {
  type = set(string)
}

variable "azs" {
  type = list(string)
}

variable "subnet_ids" {
  type = list(string)
}

variable "preferred_backup_window" {
  type = string
}

variable "preferred_maintenance_window" {
  type = string
}

variable "instance_class" {
  type = string
}

variable "skip_final_snapshot" {
  type = bool
}

variable "serveless_max_capacity" {
  type = number
}

variable "serveless_min_capacity" {
  type = number
}

variable "key_alias" {
  type = string
}