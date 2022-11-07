output "dns_names" {
    //value  = format("%s, %s", module.ec2_instance["one"].public_dns ,module.ec2_instance["two"].public_dns) 
    // value = format("%s, %s", aws_instance.posix[0].public_dns ,aws_instance.posix[1].public_dns) 
    //value = aws_instance.posix
    value  = format(
                    "posix: \n\t%s\n\t%s\nwindows: \n\t%s\n\t%s", 
                    aws_instance.posix["one"].public_dns ,
                    aws_instance.posix["two"].public_dns, 
                    aws_instance.windows["one"].public_dns ,
                    aws_instance.windows["two"].public_dns
                    )   
}