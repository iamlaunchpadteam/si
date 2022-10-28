# si

## Setup 

1. Install and configure
GitBash
AWS CLI
Terraform
VSC
1. Start up aws workspaces (....@.../....)
1. If you aren't in aws login using the start url (..../...)
1. Add the config on the start page (console) to ~/.aws/credentials
1. Confirm you have access to aws
1  Ready to go!


# Connect to an ec2
1. Deploy the artifacts (contact us)
1. terraform output private_key | grep -v EOT | grep -v -e '^$' > ~/lp.priv.key.pem
1. ssh -l ec2-user -i ~/lp.priv.key.pem  &gt;PUBLIC_IP&lt; 

