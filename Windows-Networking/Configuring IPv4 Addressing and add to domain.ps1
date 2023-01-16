###MYDESKTOP

$admincredential = Get-Credential -UserName "COMPANY\administrator" -Message "Enter the domain admin password"
Enter-PSSession -ComputerName HYPERV1 -Credential $admincredential
$localcredential = Get-Credential -UserName administrator -Message "Enter the local administrator password"

#region Configuring a static IP address on FILE1
Enter-PSSession -VMName FILE1 -Credential $localcredential
Get-NetAdapter

#Set IP address to 192.168.3.101/255.255.255.0
$intname = (Get-NetAdapter).Name
$ipaddress = "192.168.3.101"
$gateway = "192.168.3.1"
New-NetIPAddress -IPAddress $ipaddress -PrefixLength 24 -InterfaceAlias $intname -DefaultGateway $gateway |ft
Get-NetIPAddress -IPAddress $ipaddress -PolicyStore ActiveStore | ft

#Remove IP address
Remove-NetIPAddress -IPAddress $ipaddress -InterfaceAlias Ethernet -Confirm

#Try to add back IP address
New-NetIPAddress -IPAddress $ipaddress -PrefixLength 24 -InterfaceAlias Ethernet -DefaultGateway $gateway |ft

#Try to remove default gateway
Remove-NetIPAddress -IPAddress $ipaddress -DefaultGateway $gateway

Get-NetAdapter
Get-NetRoute -InterfaceIndex 2 -DestinationPrefix 0.0.0.0/0

#Add IP address without default gateway
New-NetIPAddress -IPAddress 192.168.3.101 -PrefixLength 24 -InterfaceAlias Ethernet | ft

#Set DNS server
Set-DnsClientServerAddress -Addresses 192.168.3.10 -InterfaceAlias Ethernet

#Test connectivity to the domain
Test-Connection COMPANY.PRI

exit

#Test PSRemoting to FILE1
Enter-PSSession -ComputerName 192.168.3.101 -Credential (Get-Credential)
$env:COMPUTERNAME
Exit-PSSession

#endregion

#region Configuring DHCP
Enter-PSSession -ComputerName DC -Credential $admincredential
Add-WindowsFeature -Name DHCP -Verbose

$ipstart = "192.168.3.20"
$ipend = "192.168.3.39"
$name = "Traditional"
Add-DHCPServerv4Scope -StartRange $ipstart -EndRange $ipend -Name $name -SubnetMask 255.255.255.0 -State Active
$scope = Get-DhcpServerv4Scope
$scope

$dns = "192.168.3.10"
$domain = "COMPANY.PRI"
Set-DHCPServerv4OptionValue -DnsServer $dns -DnsDomain $domain -Router 192.168.3.1 -ScopeId $scope.ScopeId
Get-DhcpServerv4OptionValue -ScopeId $scope.ScopeId

Add-DhcpServerInDC -DnsName DC.COMPANY.PRI -IPAddress 192.168.3.10 -Verbose
Get-DhcpServerInDC

#Restart FILE2
Invoke-Command -ComputerName HYPERV1 -ScriptBlock {Restart-VM -Name FILE2 -Force -Verbose}
Get-DhcpServerv4Lease -ScopeId $scope.ScopeId | Where-Object {$_.HostName -like "FILE2*"}

#Deactivate DHCP scope
Set-DhcpServerv4Scope -ScopeId $scope.ScopeId -State InActive -Verbose
Get-DhcpServerv4Scope
Get-DhcpServerv4Lease -ScopeId $scope.ScopeId | Where-Object {$_.HostName -like "FILE2*"}

Exit-PSSession
#endregion

#region Configuring a static IP address on FILE2
Enter-PSSession -ComputerName HYPERV1 -Credential $admincredential
Enter-PSSession -VMName FILE2 -Credential (Get-Credential)

#Set IP address to 192.168.3.102/255.255.255.0
$ipaddress = "192.168.3.102"
$gateway = "192.168.3.1"
New-NetIPAddress -IPAddress $ipaddress -PrefixLength 24 -InterfaceAlias Ethernet -DefaultGateway $gateway | ft
Set-DnsClientServerAddress -Addresses 192.168.3.10 -InterfaceAlias Ethernet
Test-Connection COMPANY.PRI
Exit-PSSession
Exit-PSSession

#Join FILE1 and FILE2 to domain
$servers = "FILE1","FILE2"
$domain = "COMPANY.PRI"
$localcred = Get-Credential -UserName administrator -Message "Enter the local administrator password"
$admincred = Get-Credential -UserName "COMPANY\administrator" -Message "Enter the domain admin password"
Add-Computer -ComputerName $servers -DomainName $domain -Credential $admincred -LocalCredential $localcred -Restart

Get-ADComputer -Server $domain -Credential $admincred -Filter 'Name -like "FILE*"' | ft
#endregion