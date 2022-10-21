/*
data "aws_vpc" "app_vpc" {
  tags = {
    "Name" = "common-vpc"
  }
}
*/
/*
resource "aws_vpc" "app_vpc" {
  cidr_block = "172.16.0.0/16"

  tags = {
    Name = "${local.app_name}-${local.branch_name }-vpc"
  }
}
*/

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "${local.app_name}-${local.branch_name }-vpc"

  cidr = "${local.cidr}"
  azs = ["${var.aws_region}a", "${var.aws_region}b"]

  enable_nat_gateway = true
  enable_dns_support = true
  enable_dns_hostnames = true

  private_subnets = ["${local.private_cidr_start}", "${local.private_cidr_stop}"]
  public_subnets = ["${local.public_cidr_start}", "${local.public_cidr_stop}"]
  
}