<powershell>
    $dir = $env:TEMP + "\ssm"
    New-Item -ItemType directory -Path $dir -Force
    cd $dir
    (New-Object System.Net.WebClient).DownloadFile("https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/windows_amd64/AmazonSSMAgentSetup.exe", $dir + "\AmazonSSMAgentSetup.exe")
    Start-Process .\AmazonSSMAgentSetup.exe -ArgumentList @("/q", "/log", "install.log") -Wait


    # Rename Machine
    Rename-Computer -NewName windows-instance-"${each.key}" -Force;

    # Restart machine
    shutdown -r -t 10;
</powershell>