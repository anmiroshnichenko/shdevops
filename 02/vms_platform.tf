# VM_1_netology-develop-platform-web 
variable "vm_web_name" {
  type        = string
  default     = "netology-develop-platform-web"
  description = "Name of virtual machine"
}

variable "vm_web_platform_id" {
  type        = string
  default     = "standard-v1"
  description = "Yandex Compute Cloud provides platform "
}

variable "vm_web_cores" {
  type        = number 
  default     = 2
  description = "CPU cores for the instance"
}

variable "vm_web_memory" {
  type        = number 
  default     = 1
  description = "Memory size in GB"
}

variable "vm_web_core_fraction" {
  type        = number 
  default     = 5
  description = "Specifies baseline performance for a core as a percent"
}

variable "vm_web_scheduling_policy_preemptible" {
  type        = bool 
  default     = true
  description = "Indicates whether the instance is preemptible. The values are true and false."
}

variable "vm_web_network_interface_nat" {
  type        = bool 
  default     = true
  description = "Provide a public address, for instance"
}

# VM_2_netology-develop-platform-db
variable "vm_db_name" {
  type        = string
  default     = "netology-develop-platform-db"
  description = "Name of virtual machine"
}

variable "vm_db_platform_id" {
  type        = string
  default     = "standard-v1"
  description = "Yandex Compute Cloud provides platform "
}

variable "vm_db_cores" {
  type        = number 
  default     = 2
  description = "CPU cores for the instance"
}

variable "vm_db_memory" {
  type        = number 
  default     = 2
  description = "Memory size in GB"
}

variable "vm_db_core_fraction" {
  type        = number 
  default     = 20
  description = "Specifies baseline performance for a core as a percent"
}

variable "vm_db_scheduling_policy_preemptible" {
  type        = bool 
  default     = true
  description = "Indicates whether the instance is preemptible. The values are true and false."
}

variable "vm_db_network_interface_nat" {
  type        = bool 
  default     = true
  description = "Provide a public address, for instance"
}
