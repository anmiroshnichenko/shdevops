### cloud vars
# variable "token" {
#   type        = string
#   description = "OAuth-token; https://cloud.yandex.ru/docs/iam/concepts/authorization/oauth-token"
# }

variable "cloud_id" {
  type        = string
  default     = "b1gkpecqu2tuq6ju977b"
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/cloud/get-id"
}

variable "folder_id" {
  type        = string
  default     = "b1g7m1f0du99jio1nr2o"
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/folder/get-id"
}

variable "default_zone" {
  type        = string
  default     = "ru-central1-a"
  description = "https://cloud.yandex.ru/docs/overview/concepts/geo-scope"
}

variable "zone" {
  type        = string
  default     = "ru-central1-b"
  description = "https://cloud.yandex.ru/docs/overview/concepts/geo-scope"
}

### Network vars
variable "default_cidr" {
  type        = list(string)
  default     = ["10.0.1.0/24"]
  description = "https://cloud.yandex.ru/docs/vpc/operations/subnet-create"
}

variable "cidr" {
  type        = list(string)
  default     = ["10.0.2.0/24"]
  description = "https://cloud.yandex.ru/docs/vpc/operations/subnet-create"
}

variable "vpc_name" {
  type        = string
  default     = "develop"
  description = "VPC network & subnet name"
}

variable "vpc_1_name" {
  type        = string
  default     = "develop_1"
  description = "Subnet name"
}
### ssh vars
# variable "vms_ssh_root_key" {
#   type        = string
#   default     = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCpEVTvLfMVp0ZydLogg5s1D8WzKQaY2n0MqDsBNX2YkoaHP1vHs0Aqg5ICFaKXwVnc1ns6ntMO8hYYm8ShO6fw47MFYm6JtnK7YItJT+MAj8gPYId1HiEaE47e1NSF6a5IVglw6eTo+KLHEhl+YS+zew/UcNcOYLcBP3hWdtGQmjRygy6o9BXkwUlDQ6PgwZ4A+8gd3wEkHNlabqB/43rJsDzJzMGRcduEdQAZh4A6KwXs3S9BpidSaAwwoV2DyK95PZl2w6/UfvdHeSjUkzoe+EiMbiDGXGkekDsuHKpm6Npdok3rd3wW8YgYHYimuT1VuUYw2aONffA45xIN3/udpT58JAfV1F7NrAq4g3nu5eFR97bPM9xUXYeW7Wy4x8VyzKLWKZH4LjyWiWp9bGsaJXiEsY/tIbYNpA7ZVHZszk8ObPLODZ1IVfAUNKHNMtZ9vrrWp0anRIeq2zfOCvM8bGfKm0gUJ9j6TWslEmE7uK6uSQLv7lqts7Aj2hq3rG0= miroshnichenko@pc5"
#   description = "ssh-keygen -t ed25519"
# }
### image vars
variable "vm_web_image_family" {
  type        = string
  default     = "ubuntu-2004-lts"
  description = "OS image for virtual machine"
}

variable "metadata" {
  type        = map(any)  
  description = "metadata block variables for all VMs"
}

variable "test" {
   type        = list(map(list(string)))
}