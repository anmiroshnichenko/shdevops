variable "container_name" {
 description = "Value of the name for the Docker container"
 type        = string
 default     = "web-server"
}

variable "mysql_user" {
 description = "Value user for mysql database"
 type        = string
 default     = "app"
}

variable "mysql_database" {
 description = "Value name for mysql database"
 type        = string
 default     = "virtd"
}