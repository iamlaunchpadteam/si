
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "${var.app_name}-${var.branch_name }-vpc"

  cidr = "${var.vpc_cidr}"
  azs = [
      "${var.aws_region}a", 
      "${var.aws_region}b"
    ]

  enable_nat_gateway = true
  enable_dns_support = true
  enable_dns_hostnames = true

  private_subnets = ["${var.private_cidr_start}", "${var.private_cidr_stop}"]
  public_subnets = ["${var.public_cidr_start}", "${var.public_cidr_stop}"]
  
}

resource "aws_security_group" "allow_ssh_rdc" {
  name        = "allow_ssh_rdc"
  description = "Allow SSH/RDC  traffic"
  vpc_id      = module.vpc.vpc_id

    ingress {
    description      = "SSH "
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

   ingress {
    description      = "HTTPS "
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }


  tags = {
    Name = "allow_ssh_rdc"
  }
}
