module "networking"{
  source = "./networking"

  aws_region = var.aws_region
  app_name = local.app_name
  branch_name = local.branch_name
  vpc_cidr = local.cidr
  private_cidr_start = local.private_cidr_start
  private_cidr_stop = local.private_cidr_stop
  public_cidr_start = local.public_cidr_start
  public_cidr_stop = local.public_cidr_stop
  
}



# data "aws_ami" "posix_ami" {
#   most_recent      = true
#   owners           = ["amazon"]

#   filter {
#     name   = "name"
#     values = ["amzn-ami-hvm-*-x86_64-gp2"]
#   }

# }

resource "tls_private_key" "this" {
  algorithm = "RSA"
}
module "key_pair" {
  source = "terraform-aws-modules/key-pair/aws"
  key_name = "kp"
  //create_private_key = true

  public_key = trimspace(tls_private_key.this.public_key_openssh)

  
}

data "aws_s3_bucket" "storage" {
  bucket = "iamlaunchpadteam0000201"
}

resource "aws_s3_object" "priv_key_s3" {

  bucket = data.aws_s3_bucket.storage.id

  key    = "keys/lp.priv.key.pem"

  acl    = "private"  # or can be "public-read"

  content = tls_private_key.this.private_key_pem


}

# module "ec2_instance" {
#   source  = "terraform-aws-modules/ec2-instance/aws"
#   version = "~> 3.0"

#   for_each = toset(["one", "two"])
  

#   name = "posix-instance-${each.key}"

#   ami                    = data.aws_ami.posix_ami.id
#   instance_type          = "t2.micro"
#   key_name               = module.key_pair.key_pair_name
#   monitoring             = true
#   vpc_security_group_ids = [aws_security_group.allow_ssh_rdc.id]
#   subnet_id              = module.vpc.public_subnets[0]

#   tags = {
#     Terraform   = "true"
#     Environment = "dev"
#   }
# }

module "workstations"{
  source = "./workstations"

  key_pair_name = module.key_pair.key_pair_name
  vpc_security_group_ids = module.networking.vpc_security_group_ids
  target_subnet = module.networking.public_subnets[0]
}