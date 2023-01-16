###MYDESKTOP

#region Configure static IPv6 addresses

#Configure DC with the IPV6 address 2001:3::10/64
$admincred = Get-Credential -UserName "COMPANY\administrator" -Message "Enter the domain admin password"
Enter-PSSession -ComputerName DC -Credential $admincred
$ipv6addr = "2001:3::10"
New-NetIPAddress -AddressFamily IPv6 -IPAddress $ipv6addr -PrefixLength 64 -InterfaceAlias Ethernet | ft
Get-NetIPAddress -AddressFamily IPv6 -IPAddress $ipv6addr | ft
Exit-PSSession

#Configure MYDESKTOP with the IPv6 address 2001:3::100/64
$ipv6addr = "2001:3::100"
$gateway = "2001:3::1"
New-NetIPAddress -AddressFamily IPv6 -IPAddress $ipv6addr -PrefixLength 64 -InterfaceAlias Ethernet -DefaultGateway $gateway | ft
Get-NetIPAddress -AddressFamily IPv6 -IPAddress $ipv6addr | ft

Test-Connection DC
Test-Connection 2001:3::10

#Configure the DNS server address
Set-DnsClientServerAddress -ServerAddresses 2001:3::10 -InterfaceAlias Ethernet
Get-DnsClientServerAddress -InterfaceAlias Ethernet

#Establish PowerShell session to DC via IPv6
Enter-PSSession -ComputerName DC -Credential $admincred 
Get-NetTCPConnection -LocalPort 5985

#endregion

#region Configure stateful DHCPv6
$prefix = "2001:3::"
Add-DhcpServerv6Scope -Name "Traditional" -Prefix $prefix -State Active
Get-DhcpServerv6Scope

Set-DHCPServerv6OptionValue -DnsServer "2001:3::10" -Prefix $prefix
Get-DhcpServerv6OptionValue -Prefix $prefix

#Reboot FILE1 and FILE2
Restart-Computer -ComputerName FILE1,FILE2
Get-DhcpServerv6Lease -Prefix $prefix | Where-Object {$_.HostName -like "FILE*"} | Select-Object IPAddress,HostName
Exit-PSSession

#Verify DNS on FILE1
$admincred = Get-Credential -UserName "COMPANY\administrator" -Message "Enter the domain admin password"
Enter-PSSession -ComputerName FILE1 -Credential $admincred
Get-DnsClientServerAddress -AddressFamily IPv6 -InterfaceAlias Ethernet | ft
Exit-PSSession

#Verify DNS on FILE2
Invoke-Command -ComputerName FILE2 -Credential $admincred -ScriptBlock {Get-DnsClientServerAddress -AddressFamily IPv6 -InterfaceAlias Ethernet | ft}

#Deactivate the scope
Enter-PSSession -ComputerName DC -Credential $admincred
Set-DhcpServerv6Scope -Prefix 2001:3:: -State Inactive
Get-DhcpServerv6Scope
Restart-Computer -ComputerName FILE1,FILE2
Exit-PSSession
#endregion

#region Configure static IPv6 addresses on FILE1 and FILE2
$file1cmd = {New-NetIPAddress -AddressFamily IPv6 -IPAddress 2001:3::101 -PrefixLength 64 -InterfaceAlias Ethernet}
Invoke-Command -ComputerName FILE1 -Credential $admincred -ScriptBlock $file1cmd|ft

$file2cmd = {New-NetIPAddress -AddressFamily IPv6 -IPAddress 2001:3::102 -PrefixLength 64 -InterfaceAlias Ethernet}
Invoke-Command -ComputerName FILE2 -Credential $admincred -ScriptBlock $file2cmd|ft
Invoke-Command -ComputerName FILE2 -ScriptBlock {Get-NetIPAddress|ft}
#endregion
