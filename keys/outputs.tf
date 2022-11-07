
output "key_pair_name" {
    value = module.key_pair.key_pair_name

}

output "private_key_pem"{
    value = tls_private_key.this.private_key_pem
    sensitive = true
}
