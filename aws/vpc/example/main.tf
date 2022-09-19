/*
 * # VPC Module Example
 */


# ----------------------------------------------------------------------------
# Provider
# ----------------------------------------------------------------------------

provider "aws" {
  region = var.region
}


# ----------------------------------------------------------------------------
# VPC
# ----------------------------------------------------------------------------

module "vpc" {
  source             = "./.."
  cidr               = var.vpc_cidr
  availability_zones = var.availability_zones
}