
# - Complete a series of post-install configurations on a Server Core instance.

Set-DisplayResolution 1280 720
tzutil /l
Set-Timezone "mountain standard time"
Set-Date -date "1/3/2018 11:30 AM"
Get-NetIPAddress -interfacealias ethernet0
New-NetIPAddress -interfacealias ethernet0 -IPAddress 192.168.3.101 -Prefixlength 24 -defaultgateway 192.168.3.2

### Use this cmdlet to enable/disable DHCP
### Set-NetIPInterface -interfaceindex 2 -DHCP enable

Get-NetIPConfiguration -interfaceindex 2
Set-DNSClientServerAddress -interfaceindex 2 -ServerAddress ("192.168.3.10")
hostname
Get-Content ENV:computername
Rename-Computer -newname servercore1 -restart
slmgr.vbs -ipk XXXXX-XXXXX-XXXXX-XXXXX-XXXXX
slmgr.vbs -ato
Get-NetFirewallRule | ft
Set-NetFirewallRule -Name FPS-ICMP4-ERQ-In -Enabled True
Set-NetFirewallRule -Name FPS-ICMP4-ERQ-out -Enabled True
Get-NetFirewallRule | ft displayname,displaygroup
Enable-NetFirewallRule -displaygroup "File and Printer Sharing"
New-NetFirewallRule -displayname "Allow All Traffic" -direction outbound -action allow
New-NetFirewallRule -displayname "Allow All Traffic" -direction inbound -action allow

Add-Computer -domainname "company.pri" -restart

get-windowsfeature -computername server1
install-windowsfeature -name "web-server" -computername servercore1
install-windowsfeature -name "telnet-client" -computername servercore1
enter-pssession server1
get-windowsfeature

### Use this command to set PowerShell as your Server Core instance's 
### default shell (replacing the legacy command prompt).

Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon' -Name Shell -Value 'PowerShell.exe -NoExit'