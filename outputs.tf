# output "ec2_all" {
#     value = module.ec2_instance[*]
# }
# output "ec2_dns" {
#     value = format("%s, %s", module.ec2_instance["one"].public_dns ,module.ec2_instance["two"].public_dns) 
# }

output "dns_names" {
    value = module.workstations.dns_names
        sensitive = true

}

output "private_key"{
    value = module.keys.private_key_pem
        sensitive = true

}
