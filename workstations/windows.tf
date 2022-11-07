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

  for_each = toset(["one", "two"])
  key_name = var.key_pair_name

  tags = {
    Name = "windows-instance-${each.key}"
  }
}
