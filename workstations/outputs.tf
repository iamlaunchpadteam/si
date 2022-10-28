output "dns_names" {
    value  = format("%s, %s", module.ec2_instance["one"].public_dns ,module.ec2_instance["two"].public_dns) 
}