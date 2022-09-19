/*
 * VPC Module Example Outputs
 */

output "public_subnets" {
  value       = module.vpc.public_subnets
  description = "public subnets"
}

output "private_subnets" {
  value       = module.vpc.private_subnets
  description = "private subnets"
}
