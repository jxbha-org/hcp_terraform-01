variable "region" {
  description = "Region for deployment"
  type        = string
  default     = "us-south"
}

variable "ibm_ssh_key" {
  description = "ID for cloud account's user's public SSH key. Required for logging in."
  type        = string
}

variable "system-image" {
  description = "Desired system image. Defaults to Ubuntu 24.04 LTS."
  type        = string
  default     = "r006-cfac4d24-7da3-4003-84ac-9e82dac895f5"
}

variable "profile" {
  description = "Desired system specs. Defaults to 2 vCPU, 8GB RAM."
  type        = string
  default     = "bx2-2x8"
}

variable "resource_group_name" {
  description = "Name of resource group on cloud account."
  type        = string

}
