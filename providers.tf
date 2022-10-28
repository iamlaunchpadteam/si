terraform{
    backend "s3" {
        bucket = "iamlaunchpadteam0000201"
        key    = "tfstates/si/main/terraform.tfstate"
        region = "us-east-1"
    }
    required_providers { 
        aws = {
            source = "hashicorp/aws"
            version = "~> 4.27.0"
        }


    }
}


provider "aws" {
    region = var.aws_region
}