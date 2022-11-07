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

module "keys"{
  source = "./keys"

}

# resource "tls_private_key" "this" {
#   algorithm = "RSA"
# }

# module "key_pair" {
#   source = "terraform-aws-modules/key-pair/aws"
#   key_name = "kp"
#   public_key = trimspace(tls_private_key.this.public_key_openssh)
# }

# data "aws_s3_bucket" "storage" {
#   bucket = "iamlaunchpadteam0000201"
# }

# resource "aws_s3_object" "priv_key_s3" {
#   bucket = data.aws_s3_bucket.storage.id
#   key    = "keys/lp.priv.key.pem"
#   acl    = "private" 
#   content = tls_private_key.this.private_key_pem
# }


module "workstations"{
  source = "./workstations"
  //key_pair_name = module.key_pair.key_pair_name
  key_pair_name = module.keys.key_pair_name
  vpc_security_group_ids = module.networking.vpc_security_group_ids
  target_subnet = module.networking.public_subnets[0]
}