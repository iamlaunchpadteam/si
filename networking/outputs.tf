output "vpc_id" {
    value = module.vpc.vpc_id
}

output "vpc_security_group_ids" {
    value = [aws_security_group.allow.id]
}

output "public_subnets" {
    value = module.vpc.public_subnets
}

output "private_subnets" {
    value = module.vpc.private_subnets
}
