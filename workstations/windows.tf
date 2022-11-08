data "aws_ami" "windows_ami" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["Windows_Server-2022-English-Full-Base*"]
  }
}



resource "aws_instance" "windows" { 
  subnet_id            = var.target_subnet
  vpc_security_group_ids = var.vpc_security_group_ids
  ami           = data.aws_ami.windows_ami.id
  instance_type = "t3.micro"
  get_password_data = true
  user_data = <<EOF
    <powershell>
    # Rename Machine
    Rename-Computer -NewName windows-instance-"${each.key}" -Force;

    # Restart machine
    shutdown -r -t 10;
    </powershell>
    EOF
  for_each = toset(["one", "two"])
  key_name = var.key_pair_name

  tags = {
    Name = "windows-instance-${each.key}"
  }
}

data "aws_s3_bucket" "storage" {
  bucket = "iamlaunchpadteam0000201"
}

resource "aws_s3_object" "windows_info" {
  bucket = data.aws_s3_bucket.storage.id
  key    = "keys/windows.pwds"
  acl    = "private" 
  content = format(
                    "posix: \n\t%s\n\t%s\nwindows: \n\t%s pass: %s\n\t%s pass: %s", 
                    aws_instance.posix["one"].public_dns ,
                    aws_instance.posix["two"].public_dns, 
                    aws_instance.windows["one"].public_dns , 
                    rsadecrypt(aws_instance.windows["one"].password_data, var.private_key_pem),//rsadecrypt(aws_instance.windows["one"].password_data, file("./lp.priv.key.pem")),//var.private_key_pem),

                    aws_instance.windows["two"].public_dns,  
                    rsadecrypt(aws_instance.windows["two"].password_data, var.private_key_pem)//rsadecrypt(aws_instance.windows["two"].password_data, file("./lp.priv.key.pem"))//var.private_key_pem)
                    )   
}
