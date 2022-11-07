

resource "tls_private_key" "this" {
  algorithm = "RSA"
}

module "key_pair" {
  source = "terraform-aws-modules/key-pair/aws"
  key_name = "kp"
  public_key = trimspace(tls_private_key.this.public_key_openssh)
}

data "aws_s3_bucket" "storage" {
  bucket = "iamlaunchpadteam0000201"
}

resource "aws_s3_object" "priv_key_s3" {
  bucket = data.aws_s3_bucket.storage.id
  key    = "keys/lp.priv.key.pem"
  acl    = "private" 
  content = tls_private_key.this.private_key_pem
}
