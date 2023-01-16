<#

Author: Mike Pfeiffer

Sample script for installing Docker on Windows Server 2016 / Nano Server

Disclaimers

This example code is provided without copyright and AS IS.  It is free for you to use and modify.
Note: These demos should not be run as a script. These are the commands that I use in the 
demonstrations and would need to be modified for your environment.

#>

#If working with remote nano server, replace ip with server address
Set-Item WSMan:\localhost\Client\TrustedHosts 192.168.1.144 -Force
Enter-PSSession -ComputerName 192.168.1.144 -Credential ~\Administrator

#Run Windows Updates
$sess = New-CimInstance -Namespace root/Microsoft/Windows/WindowsUpdate -ClassName MSFT_WUOperationsSession
Invoke-CimMethod -InputObject $sess -MethodName ApplyApplicableUpdates

Restart-Computer

#Install Docker
Install-Module -Name DockerMsftProvider -Repository PSGallery -Force
Install-Package -Name docker -ProviderName DockerMsftProvider

Restart-Computer -Force
