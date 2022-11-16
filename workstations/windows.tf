data "aws_ami" "windows_ami" {
  most_recent = true
  owners      = ["amazon"]
  
  filter {
    name   = "name"
    values = ["Windows_Server-2022-English-Full-Base*"]
  }
}

data "aws_ami" "windows_w_sql_server_ami" {
  most_recent = true
  owners      = ["amazon"]
  
  filter {
    name   = "name"
    values = ["Windows_Server-2022-English-Full-SQL_2019_Web-*"]
  }
}

# data "template_file" "startup_windows" {
#  template = file("workstations/windows.start.ps1")

 
# }

# resource "local_file" "user_data" {
#   content = "${data.template_file.startup_windows.rendered}"
#   filename = "user_data-${sha1(data.template_file.startup_windows.rendered)}.ps"
# }

# resource "aws_instance" "windows" { 
#   subnet_id            = var.target_subnet
#   vpc_security_group_ids = var.vpc_security_group_ids
#   ami           = data.aws_ami.windows_ami.id
#   instance_type = "t3.micro"
#   get_password_data = true
#   iam_instance_profile = aws_iam_instance_profile.dev-resources-iam-profile.name 
#   //user_data = data.template_file.startup_windows.rendered


#   user_data = <<EOF
#     <powershell>
#     $dir = $env:TEMP + "\ssm"
#     New-Item -ItemType directory -Path $dir -Force
#     cd $dir
#     (New-Object System.Net.WebClient).DownloadFile("https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/windows_amd64/AmazonSSMAgentSetup.exe", $dir + "\AmazonSSMAgentSetup.exe")
#     Start-Process .\AmazonSSMAgentSetup.exe -ArgumentList @("/q", "/log", "install.log") -Wait


#     # Rename Machine
#     Rename-Computer -NewName windows-instance-"${each.key}" -Force;

#     # Restart machine
#     shutdown -r -t 10;
#     </powershell>
#     EOF
  
#   for_each = toset(["one", "two"])
#   key_name = var.key_pair_name

#   root_block_device  {
#       delete_on_termination = true
#       volume_size = "30"
#       volume_type = "gp2"
      
#     }

#   tags = {
#     Name = "windows-instance-${each.key}"
#   }
# }

resource "aws_instance" "windows" { 
  subnet_id            = var.target_subnet
  vpc_security_group_ids = var.vpc_security_group_ids
  ami           = data.aws_ami.windows_ami.id
  instance_type = "t3.micro"
  get_password_data = true
  iam_instance_profile = aws_iam_instance_profile.dev-resources-iam-profile.name 
  //user_data = data.template_file.startup_windows.rendered


  user_data = <<EOF
    <powershell>
    $dir = $env:TEMP + "\ssm"
    New-Item -ItemType directory -Path $dir -Force
    cd $dir
    (New-Object System.Net.WebClient).DownloadFile("https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/windows_amd64/AmazonSSMAgentSetup.exe", $dir + "\AmazonSSMAgentSetup.exe")
    Start-Process .\AmazonSSMAgentSetup.exe -ArgumentList @("/q", "/log", "install.log") -Wait


    # Rename Machine
    Rename-Computer -NewName windows-instance -Force;

    # Restart machine
    shutdown -r -t 10;
    </powershell>
    EOF
  
  key_name = var.key_pair_name

  root_block_device  {
      delete_on_termination = true
      volume_size = "30"
      volume_type = "gp2"
      
    }

  tags = {
    Name = "windows-instance"
  }
}


resource "aws_instance" "windows_lg" { 
  subnet_id            = var.target_subnet
  vpc_security_group_ids = var.vpc_security_group_ids
  ami           = data.aws_ami.windows_w_sql_server_ami.id
  instance_type = "t3a.large"
  get_password_data = true
  iam_instance_profile = aws_iam_instance_profile.dev-resources-iam-profile.name 
  //user_data = data.template_file.startup_windows.rendered


  user_data = <<EOF
    <powershell>
    $dir = $env:TEMP + "\ssm"
    New-Item -ItemType directory -Path $dir -Force
    cd $dir
    (New-Object System.Net.WebClient).DownloadFile("https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/windows_amd64/AmazonSSMAgentSetup.exe", $dir + "\AmazonSSMAgentSetup.exe")
    Start-Process .\AmazonSSMAgentSetup.exe -ArgumentList @("/q", "/log", "install.log") -Wait


    # Rename Machine
    Rename-Computer -NewName windows-instance-lg -Force;

    # Restart machine
    shutdown -r -t 10;
    </powershell>
    EOF
  
  key_name = var.key_pair_name

  root_block_device  {
      delete_on_termination = true
      volume_size = "65"
      volume_type = "gp2"
      
    }

  tags = {
    Name = "windows-instance-lg"
  }
}


resource "aws_s3_object" "windows_info" {
  bucket = data.aws_s3_bucket.storage.id
  key    = "keys/windows.pwds"
  acl    = "private" 
  content = format(
              "windows: \n\t%s pass: %s\n\t%s pass: %s", 
              aws_instance.windows.public_dns , 
              rsadecrypt(aws_instance.windows.password_data, var.private_key_pem),//rsadecrypt(aws_instance.windows["one"].password_data, file("./lp.priv.key.pem")),//var.private_key_pem),

              aws_instance.windows_lg.public_dns,  
              rsadecrypt(aws_instance.windows_lg.password_data, var.private_key_pem)//rsadecrypt(aws_instance.windows["two"].password_data, file("./lp.priv.key.pem"))//var.private_key_pem)
              )   
}
