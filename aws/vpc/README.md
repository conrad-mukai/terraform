<!-- BEGIN_TF_DOCS -->
# VPC Module

This module creates the following:
1. a VPC;
2. public and private subnets;
3. an internet gateway;
4. NAT gateways; and
5. route tables.

The module automatically determines subnet CIDRs based upon the VPC CIDR
and the number of availability zones. For example for these inputs:
```
cidr               = "10.0.0.0/16"
availability_zones = ["us-west-2a", "us-west-2b", "us-west-2c"]
```
the following would be produced:
| availability zone | public CIDR | private CIDR |
| ----------------- | ----------- | ------------ |
| us-west-2a | 10.0.0.0/20 | 10.0.64.0/18 |
| us-west-2b | 10.0.16.0/20 | 10.0.128.0/18 |
| us-west-2c | 10.0.32.0/20 | 10.0.192.0/18 |
For a 6 subnet VPC the inputs could be:
```
cidr               = "172.16.0.0/16"
availability_zones = [
  "us-east-1a", "us-east-1b", "us-east-1c",
  "us-east-1d", "us-east-1e", "us-east-1f"
]
```
and the results would be:
| availability zone | public CIDR | private CIDR |
| ----------------- | ----------- | ------------ |
| us-east-1a | 172.16.0.0/22 | 172.16.32.0/19 |
| us-east-1b | 172.16.4.0/22 | 172.16.64.0/19 |
| us-east-1c | 172.16.8.0/22 | 172.16.96.0/19 |
| us-east-1d | 172.16.12.0/22 | 172.16.128.0/19 |
| us-east-1e | 172.16.16.0/22 | 172.16.160.0/19 |
| us-east-1f | 172.16.20.0/22 | 172.16.192.0/19 |

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.2.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.31.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 4.31.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_eip.eni](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip) | resource |
| [aws_internet_gateway.igw](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway) | resource |
| [aws_nat_gateway.ngw](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/nat_gateway) | resource |
| [aws_route.private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_route.public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_route_table.private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table.public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table_association.private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_route_table_association.public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_subnet.private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_subnet.public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_vpc.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_availability_zones"></a> [availability\_zones](#input\_availability\_zones) | list of availability zones | `list(string)` | n/a | yes |
| <a name="input_cidr"></a> [cidr](#input\_cidr) | VPC CIDR | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | name for tagging | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_private_subnets"></a> [private\_subnets](#output\_private\_subnets) | list of private subnets |
| <a name="output_public_subnets"></a> [public\_subnets](#output\_public\_subnets) | list of public subnets |
| <a name="output_vpc_id"></a> [vpc\_id](#output\_vpc\_id) | VPC ID |
<!-- END_TF_DOCS -->