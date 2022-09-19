/*
 * VPC Module Outputs
 */

output "vpc_id" {
  value       = aws_vpc.this.id
  description = "VPC ID"
}

output "public_subnets" {
  value = [for s in aws_subnet.public[*] : {
    availability_zone = s.availability_zone
    id                = s.id
  }]
  description = "list of public subnets"
}

output "private_subnets" {
  value = [for s in aws_subnet.private[*] : {
    availability_zone = s.availability_zone
    id                = s.id
  }]
  description = "list of private subnets"
}
