/*
 * # VPC Module
 *
 * This module creates the following:
 * 1. a VPC;
 * 2. public and private subnets;
 * 3. an internet gateway;
 * 4. NAT gateways; and
 * 5. route tables.
 *
 * The module automatically determines subnet CIDRs based upon the VPC CIDR
 * and the number of availability zones. For example for these inputs:
 * ```
 * cidr               = "10.0.0.0/16"
 * availability_zones = ["us-west-2a", "us-west-2b", "us-west-2c"]
 * ```
 * the following would be produced:
 * | availability zone | public CIDR | private CIDR |
 * | ----------------- | ----------- | ------------ |
 * | us-west-2a | 10.0.0.0/20 | 10.0.64.0/18 |
 * | us-west-2b | 10.0.16.0/20 | 10.0.128.0/18 |
 * | us-west-2c | 10.0.32.0/20 | 10.0.192.0/18 |
 * For a 6 subnet VPC the inputs could be:
 * ```
 * cidr               = "172.17.0.0/16"
 * availability_zones = [
 *   "us-east-1a", "us-east-1b", "us-east-1c",
 *   "us-east-1d", "us-east-1e", "us-east-1f"
 * ]
 * ```
 * and the results would be:
 * | availability zone | public CIDR | private CIDR |
 * | ----------------- | ----------- | ------------ |
 * | us-east-1a | 172.17.0.0/22 | 172.17.32.0/19 |
 * | us-east-1b | 172.17.4.0/22 | 172.17.64.0/19 |
 * | us-east-1c | 172.17.8.0/22 | 172.17.96.0/19 |
 * | us-east-1d | 172.17.12.0/22 | 172.17.128.0/19 |
 * | us-east-1e | 172.17.16.0/22 | 172.17.160.0/19 |
 * | us-east-1f | 172.17.20.0/22 | 172.17.192.0/19 |
 */


# ----------------------------------------------------------------------------
# VPC
# ----------------------------------------------------------------------------

resource "aws_vpc" "this" {
  cidr_block = var.cidr
}


# ----------------------------------------------------------------------------
# Subnets
# ----------------------------------------------------------------------------

locals {
  num_azs          = length(var.availability_zones)
  private_new_bits = floor(log(local.num_azs, 2)) + 1
  public_new_bits  = 2 * local.private_new_bits
  public_cidrs     = [for i in range(local.num_azs) : cidrsubnet(var.cidr, local.public_new_bits, i)]
  private_cidrs    = [for i in range(1, local.num_azs + 1) : cidrsubnet(var.cidr, local.private_new_bits, i)]
}

resource "aws_subnet" "public" {
  count             = local.num_azs
  vpc_id            = aws_vpc.this.id
  availability_zone = var.availability_zones[count.index]
  cidr_block        = local.public_cidrs[count.index]
}

resource "aws_subnet" "private" {
  count             = local.num_azs
  vpc_id            = aws_vpc.this.id
  availability_zone = var.availability_zones[count.index]
  cidr_block        = local.private_cidrs[count.index]
}


# ----------------------------------------------------------------------------
# Gateways
# ----------------------------------------------------------------------------

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.this.id
}

resource "aws_eip" "eni" {
  count = local.num_azs
  vpc   = true
  depends_on = [
    aws_internet_gateway.igw
  ]
}

resource "aws_nat_gateway" "ngw" {
  count         = local.num_azs
  allocation_id = aws_eip.eni[count.index].id
  subnet_id     = aws_subnet.public[count.index].id
}


# ----------------------------------------------------------------------------
# Route Tables
# ----------------------------------------------------------------------------

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id
}

resource "aws_route" "public" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

resource "aws_route_table_association" "public" {
  count          = local.num_azs
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table" "private" {
  count  = local.num_azs
  vpc_id = aws_vpc.this.id
}

resource "aws_route" "private" {
  count                  = local.num_azs
  route_table_id         = aws_route_table.private[count.index].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.ngw[count.index].id
}

resource "aws_route_table_association" "private" {
  count          = local.num_azs
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private[count.index].id
}
