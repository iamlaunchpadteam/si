# si (users)

## Setup 

1. Install and configure  GitBash and AWS CLI
1. Start up aws workspaces 
1. If you aren't in aws login using the start url 
1. Add the config on the start page (console) to ~/.aws/credentials
1. Confirm you have access to aws
1  Ready to go!


# Get the private key
1. Deploy the artifacts (contact us)
1. Get the private key and put it in lp.priv.key.pem in your home dir

    aws s3 cp s3://iamlaunchpadteam0000201/keys/lp.priv.key.pem  ~/lp.priv.key.pem  

# Connect to an ec2  (posix)

This assumes you are running from a posix (git bash on windows) terminal  

1. Get the uri and password by running this.. 

    aws s3 cp s3://iamlaunchpadteam0000201/keys/posix.info -

1. ssh -l ec2-user -i &gt;HOME_DIR&lt;/lp.priv.key.pem  &gt;PUBLIC_IP&lt; 

# Connect to an ec2 (windows)


1. Get the uri and password by running this.. 

    aws s3 cp s3://iamlaunchpadteam0000201/keys/windows.pwds -

1. Open RDP
1. Put in the ip
1. Click more choices 
1. Enter Administrator as the username.  Use the pwd from the doc
1. Click download the remote desktop file, run it, then input the password 

