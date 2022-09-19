/*
 * VPC Module Inputs
 */

variable "cidr" {
  type        = string
  description = "VPC CIDR"
}

variable "availability_zones" {
  type        = list(string)
  description = "list of availability zones"
}
