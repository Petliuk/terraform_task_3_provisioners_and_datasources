variable "prefix" {
  description = "Prefix used for naming existing Azure resources"
  type        = string
  default     = "tfvmex"
}

variable "resource_group_name" {
  description = "Name of the manually created Azure resource group"
  type        = string
  default     = "tfvmex-resources"
}

variable "admin_username" {
  description = "Admin username for the virtual machine"
  type        = string
  default     = "testadmin"
}

variable "admin_password" {
  description = "Admin password for the virtual machine"
  type        = string
  default     = "Password1234!"
  sensitive   = true
}
