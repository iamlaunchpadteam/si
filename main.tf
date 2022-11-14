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

module "ext"{
  source = "./ext"
}

module "keys"{
  source = "./keys"

  s3_bucket = var.s3_bucket
}



module "workstations"{
  source = "./workstations"
  key_pair_name = module.keys.key_pair_name
  private_key_pem = module.keys.private_key_pem
  vpc_security_group_ids = module.networking.vpc_security_group_ids
  target_subnet = module.networking.public_subnets[0]
  s3_bucket = var.s3_bucket
}

