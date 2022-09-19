/*
 * VPC Module Inputs
 */

variable "name" {
  type        = string
  description = "name for tagging"
}

variable "cidr" {
  type        = string
  description = "VPC CIDR"
}

variable "availability_zones" {
  type        = list(string)
  description = "list of availability zones"
}
