data "aws_ami" "posix_ami" {
  most_recent      = true
  owners           = ["amazon"]

  # filter {
  #   name   = "name"
  #   values = ["amzn-ami-hvm-*-x86_64-gp2"]
  # }

  filter {
   name   = "name"
   values = ["amzn2-ami-hvm*"]
  }

    # filter {
    #     name   = "name"
    #     values = ["ubuntu/images/hvm-ssd/ubuntu-xenial-16.04-amd64-server-*"]
    # }

    # filter {
    #     name   = "virtualization-type"
    #     values = ["hvm"]
    # }

}

data "template_file" "startup" {
 template = file("workstations/ssm-agent-installer.sh")
}



resource "aws_instance" "posix" { 
  subnet_id            = var.target_subnet
  vpc_security_group_ids = var.vpc_security_group_ids
  ami           = data.aws_ami.posix_ami.id
  instance_type = "t3.micro"
  iam_instance_profile = aws_iam_instance_profile.dev-resources-iam-profile.name 
  for_each = toset(["one", "two"])
  key_name = var.key_pair_name

  root_block_device  {
      delete_on_termination = true
      volume_size = "30"
      volume_type = "gp2"
      
    }

  tags = {
    Name = "posix-instance-${each.key}"
  }

  user_data = data.template_file.startup.rendered

}

# module "ec2_instance" {
#   source  = "terraform-aws-modules/ec2-instance/aws"
#   version = "~> 3.0"

#   for_each = toset(["one", "two"])
  

#   name = "posix-instance-${each.key}"

#   ami                    = data.aws_ami.posix_ami.id
#   instance_type          = "t2.micro"
#   key_name               = var.key_pair_name
#   monitoring             = true
#   vpc_security_group_ids = var.vpc_security_group_ids
#   subnet_id              = var.target_subnet

#   tags = {
#     Terraform   = "true"
#     Environment = "dev"
#   }
# }



resource "aws_s3_object" "posix_info" {
  bucket = data.aws_s3_bucket.storage.id
  key    = "keys/posix.info"
  acl    = "private" 
  content = format(
                    "posix: \n\t%s\n\t%s\n", 
                    aws_instance.posix["one"].public_dns ,
                    aws_instance.posix["two"].public_dns, 
                   )   
}