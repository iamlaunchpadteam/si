data "aws_ami" "posix_ami" {
  most_recent      = true
  owners           = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn-ami-hvm-*-x86_64-gp2"]
  }

}


module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 3.0"

  for_each = toset(["one", "two"])
  

  name = "posix-instance-${each.key}"

  ami                    = data.aws_ami.posix_ami.id
  instance_type          = "t2.micro"
  key_name               = var.key_pair_name
  monitoring             = true
  vpc_security_group_ids = var.vpc_security_group_ids
  subnet_id              = var.target_subnet

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}
