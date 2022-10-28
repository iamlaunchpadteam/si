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

resource "aws_security_group" "allow_ssh_rdc" {
  name        = "allow_ssh_rdc"
  description = "Allow SSH/RDC inbound traffic"
  vpc_id      = module.vpc.vpc_id

  # ingress {
  #   description      = "TLS from VPC"
  #   from_port        = 22
  #   to_port          = 22
  #   protocol         = "tcp"
  #   cidr_blocks      = [
  #       //module.vpc.vpc_cidr_block, 
  #       "0.0.0.0/0"
  #   ]
  #  // ipv6_cidr_blocks = [aws_vpc.main.ipv6_cidr_block]
  # }

  # egress {
  #   from_port        = 0
  #   to_port          = 0
  #   protocol         = "-1"
  #   cidr_blocks      = ["0.0.0.0/0"]
  #   ipv6_cidr_blocks = ["::/0"]
  # }

  tags = {
    Name = "allow_ssh_rdc"
  }
}

resource "aws_security_group_rule" "in_ssh"{
  type="ingress"
  description = "ssh_in"
  from_port = 22
  to_port = 22
  protocol = "tcp"
  cidr_blocks      = ["0.0.0.0/0"]
  security_group_id = aws_security_group.allow_ssh_rdc.id
}

resource "aws_security_group_rule" "out"{
  type="egress"
  description = "out"
  from_port = 0
  to_port = 0
  protocol = "-1"
  cidr_blocks      = ["0.0.0.0/0"]
  security_group_id = aws_security_group.allow_ssh_rdc.id
}

data "aws_ami" "posix_ami" {
  most_recent      = true
  owners           = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn-ami-hvm-*-x86_64-gp2"]
  }

}

resource "tls_private_key" "this" {
  algorithm = "RSA"
}
module "key_pair" {
  source = "terraform-aws-modules/key-pair/aws"
  key_name = "kp"
  //create_private_key = true

  public_key = trimspace(tls_private_key.this.public_key_openssh)

  
}

module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 3.0"

  for_each = toset(["one", "two"])

  name = "posix-instance-${each.key}"

  ami                    = data.aws_ami.posix_ami.id
  instance_type          = "t2.micro"
  key_name               = module.key_pair.key_pair_name
  monitoring             = true
  vpc_security_group_ids = [aws_security_group.allow_ssh_rdc.id]
  subnet_id              = module.vpc.public_subnets[0]

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}
