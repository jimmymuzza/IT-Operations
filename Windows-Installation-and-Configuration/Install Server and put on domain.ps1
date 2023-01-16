## On Server Core

hostname

powershell

Rename-Computer -NewName PLABDMCORE02

ipconfig /all

# Change IP Address
New-NetIPAddress 192.168.0.7 -InterfaceAlias “Ethernet” -PrefixLength 24

## Set DNS Server
Set-DNSClientServerAddress -InterfaceAlias “Ethernet” -ServerAddresses 192.168.0.1

ipconfig /all

# Test Ping
ping plabdc01.practicelabs.com

Restart-Computer

## Add computer to AD
Powershell
Add-Computer -DomainCredential practicelabs\administrator -DomainName practicelabs.com

Restart-Computer

# Enable Windows Remote Management
winrm quickconfig

# If The system returns an error, saying HTTP status code of 502... This error can be attributed to the proxy settings of the server.
netsh winhttp show proxy
netsh winhttp reset proxy

#Test RM Tools from remote machine
Enter-PSSession -ComputerName plabdmcore02

##Install DNS Server
Add-WindowsFeature -Name dns,rsat-dns-server -IncludeManagementTools

## Disable windows firewall
Get-NetFirewallProfile
Set-NetFirewallProfile -Profile Domain,Public,Private -Enabled false

##Sysprep
Cd C:\Windows\System32\Sysprep\
.\sysprep.exe

##Remove windows defender
Remove-WindowsFeature Windows-Defender, Windows-Defender-GUI

## Import certificates
$PlainTextPass = "certs"

$pfxpass = $PlainTextPass |ConvertTo-SecureString -AsPlainText -Force  

Import-PfxCertificate -filepath c:\servercerts.pfx cert:\CurrentUser\my -Password  $pfxpass