###cloud vars
# variable "token" {
#   type        = string
#   description = "OAuth-token; https://cloud.yandex.ru/docs/iam/concepts/authorization/oauth-token"
# }

variable "cloud_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/cloud/get-id"
}

variable "folder_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/folder/get-id"
}

variable "default_zone" {
  type        = string
  default     = "ru-central1-a"
  description = "https://cloud.yandex.ru/docs/overview/concepts/geo-scope"
}
variable "default_cidr" {
  type        = list(string)
  default     = ["10.0.1.0/24"]
  description = "https://cloud.yandex.ru/docs/vpc/operations/subnet-create"
}

variable "vpc_name" {
  type        = string
  default     = "develop"
  description = "VPC network&subnet name"
}

variable "vm_scheduling_policy_preemptible" {
  type        = bool 
  default     = true
  description = "Indicates whether the instance is preemptible. The values are true and false."
}

variable "vm_network_interface_nat" {
  type        = bool 
  default     = true
  description = "Provide a public address, for instance"
}

variable "vm_platform_id" {
  type        = string
  default     = "standard-v1"
  description = "Yandex Compute Cloud provides platform "
}

variable "vm_web_image_family" {
  type        = string
  default     = "ubuntu-2004-lts"
  description = "OS image for virtual machine"
}

#single map variable for virtual machine resources
variable "vms_resources" {
  type        = map(map(number))
  description = "All resources for virtual machine"
}

variable "metadata" {
  type        = map(any)  
  description = "metadata block variables for all VMs"
}

variable "vm_count" {
  type = number
  default = 1
}