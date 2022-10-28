output "ec2_all" {
    value = module.ec2_instance[*]
}
output "ec2_ips" {
    value = format("%s, %s", module.ec2_instance["one"].public_dns ,module.ec2_instance["two"].public_dns) 
}

output "private_key"{
    value = tls_private_key.this.private_key_pem
    sensitive = true
}

output "public_key"{
    value = tls_private_key.this.public_key_openssh
    sensitive = true
}
output "public_keys" {
    value = module.key_pair
    sensitive = true
}