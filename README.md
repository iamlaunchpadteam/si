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

This assumes you are running from a posix (git bash on windows) terminal  

1. Deploy the artifacts (contact us)
1. Get the private key and put it in lp.priv.key.pem in your home dir

    terraform output private_key | grep -v EOT | grep -v -e '^$' > ~/lp.priv.key.pem

1. ssh -l ec2-user -i &gt;HOME_DIR&lt;/lp.priv.key.pem  &gt;PUBLIC_IP&lt; 



# Rehydrate launchpad  

Every month the environment will reset.   You should have had the environment cleaned up.   To rebuild it you need to create an s3 bucket called iamlaunchpadteam0000201.... then just run the terraform