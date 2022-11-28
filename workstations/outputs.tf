# output "dns_names" {
#     //value  = format("%s, %s", module.ec2_instance["one"].public_dns ,module.ec2_instance["two"].public_dns) 
#     // value = format("%s, %s", aws_instance.posix[0].public_dns ,aws_instance.posix[1].public_dns) 
#     //value = aws_instance.posix
#     value  = format(
#                     "posix: \n\t%s\n\t%s\nwindows: \n\t%s pass: %s\n\t%s pass: %s", 
#                     aws_instance.posix["one"].public_dns ,
#                     aws_instance.posix["two"].public_dns, 
#                     aws_instance.windows["one"].public_dns , 
#                     rsadecrypt(aws_instance.windows["one"].password_data, var.private_key_pem),//rsadecrypt(aws_instance.windows["one"].password_data, file("./lp.priv.key.pem")),//var.private_key_pem),

#                     aws_instance.windows["two"].public_dns,  
#                     rsadecrypt(aws_instance.windows["two"].password_data, var.private_key_pem)//rsadecrypt(aws_instance.windows["two"].password_data, file("./lp.priv.key.pem"))//var.private_key_pem)
#                     )   
#     sensitive = true
# }

output "posix_info" {
    value  = format(
                    "posix: \n\t%s\n\t%s\n", 
                    aws_instance.posix["one"].public_dns ,
                    aws_instance.posix["two"].public_dns, 
                    )   
    sensitive = true
}

output "windows_info" {
    value  = format(
                    "windows: \n\tip: %s  uri: %s  pass: %s\n\tip: %s  uri: %s  pass: %s",
                    aws_instance.windows.public_ip,
                    aws_instance.windows.public_dns , 
                    rsadecrypt(aws_instance.windows.password_data, var.private_key_pem),//rsadecrypt(aws_instance.windows["one"].password_data, file("./lp.priv.key.pem")),//var.private_key_pem),

                    aws_instance.windows_lg.public_ip,
                    aws_instance.windows_lg.public_dns,  
                    rsadecrypt(aws_instance.windows.password_data, var.private_key_pem)//rsadecrypt(aws_instance.windows["two"].password_data, file("./lp.priv.key.pem"))//var.private_key_pem)
                    )   
    sensitive = true
}