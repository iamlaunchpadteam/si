

output "posix_info" {
    value = module.workstations.posix_info
        sensitive = true
}

output "windows_info" {
    value = module.workstations.windows_info
        sensitive = true

}

output "private_key"{
    value = module.keys.private_key_pem
        sensitive = true

}
