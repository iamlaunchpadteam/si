
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

resource "aws_security_group" "allow" {
  name        = "allow_all"
  description = "all"
  vpc_id      = module.vpc.vpc_id

#   ingress {
#     description      = "SSH "
#     from_port        = 22
#     to_port          = 22
#     protocol         = "tcp"
#     cidr_blocks      = ["0.0.0.0/0"]
#     ipv6_cidr_blocks = ["::/0"]
#   }

  # ingress {
  #   description      = "all "
  #   from_port        = 0
  #   to_port          = 0
  #   protocol         = "-1"
  #   cidr_blocks      = ["0.0.0.0/0"]
  #   ipv6_cidr_blocks = ["::/0"]
  # }

  ingress {
    description      = "all "
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["3.83.200.219/32"]
  }

#    ingress {
#     description      = "HTTPS "
#     from_port        = 443
#     to_port          = 443
#     protocol         = "tcp"
#     cidr_blocks      = ["0.0.0.0/0"]
#     ipv6_cidr_blocks = ["::/0"]
#   }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }


  tags = {
    Name = "allow"
  }

#   resource "aws_security_group_rule" "ingress_ssh" {
#     type              = "ingress"
#     from_port         = 22
#     to_port           = 22
#     protocol          = "tcp"
#     cidr_blocks       = [aws_vpc.example.cidr_block]
#     ipv6_cidr_blocks  = [aws_vpc.example.ipv6_cidr_block]
#     security_group_id = "sg-123456"
#     }

}
