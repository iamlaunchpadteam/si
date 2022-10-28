output "vpc_security_group_ids" {
    value = [aws_security_group.allow_ssh_rdc.id]
}

output "public_subnets" {
    value = module.vpc.public_subnets
}
