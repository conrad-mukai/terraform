/*
 * VPC Module Example Inputs
 */

variable "region" {
  type        = string
  description = "AWS region"
}

variable "name" {
  type        = string
  description = "name for tagging"
}

variable "vpc_cidr" {
  type        = string
  description = "VPC CIDR"
}

variable "availability_zones" {
  type        = list(string)
  description = "list of availability zones"
}
