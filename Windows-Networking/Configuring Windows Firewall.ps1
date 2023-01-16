###MYDESKTOP

#region Creating and Linking Organizational Units and GPOs
$admincred = Get-Credential -UserName "COMPANY\administrator" -Message "Enter the domain admin password"
Enter-PSSession -ComputerName DC -Credential $admincred

$winrm = Get-NetFirewallRule -name "WINRM-HTTP-In-TCP"
$winrm | Select-Object Name,DisplayName,Enabled,Direction,Action
Get-NetFirewallPortFilter -AssociatedNetFirewallRule $winrm
Get-NetFirewallAddressFilter -AssociatedNetFirewallRule $winrm

#Create FileServers OU for FILE1 and FILE2
New-ADOrganizationalUnit FileServers
$ou = Get-ADOrganizationalUnit -Filter 'Name -like "FileServers"'

#Create empty GPO and link to OU
New-GPO -Name Firewall
New-GPLink -Name Firewall -Target $ou.DistinguishedName
#endregion

#region Deploying Firewall Rules Using Group Policy and PowerShell 
#Add firewall rule to GPO
$name = "Block PowerShell"
$gpo = "company.pri\Firewall"
$dir = "Inbound"
$port = 5985
$prot = "TCP"
$action = "Block"
New-NetFirewallRule -DisplayName $name -Direction $dir -LocalPort $port -Protocol $prot -Action $action -PolicyStore $gpo

$rule = Get-NetFirewallRule -DisplayName $name -PolicyStore $gpo
$rule | ft
Get-NetFirewallPortFilter -AssociatedNetFirewallRule $rule

#Move FILE1 into FileServers OU
$file1 = Get-ADComputer FILE1
Move-ADObject $file1 -TargetPath $ou
$file1 = Get-ADComputer FILE1
$file1.DistinguishedName
Restart-Computer FILE1

$testps = {Get-NetTCPConnection -LocalPort 5985}
Invoke-Command -ComputerName FILE1 -ScriptBlock $testps
Invoke-Command -ComputerName FILE2 -ScriptBlock $testps

#Move FILE2 into FileServers OU
$file2 = Get-ADComputer FILE2
Move-ADObject $file2 -TargetPath $ou
$file2 = Get-ADComputer FILE2
$file2.DistinguishedName
Restart-Computer FILE2
Invoke-Command -ComputerName FILE2 -ScriptBlock $testps
#endregion

#region Removing Firewall Rules from Group Policy Objects
#Remove the "Block PowerShell" firewall rule from the GPO
Remove-NetFirewallRule -DisplayName $name -PolicyStore $gpo
Restart-Computer FILE1,FILE2

Invoke-Command -ComputerName FILE1 -ScriptBlock $testps
Invoke-Command -ComputerName FILE2 -ScriptBlock $testps

#Add GPO firewall rule to allow PowerShell connections only from the 192.168.3.0/24 subnet
$name = "Restrict PowerShell"
$gpo = "company.pri\Firewall"
$dir = "Inbound"
$port = 5985
$proto = "TCP"
$action = "Block"
#Block all addresses except for 192.168.3.1-192.168.3.255
$ra = "1.1.1.1-192.168.2.255","192.168.4.1-255.255.255.255"
New-NetFirewallRule -DisplayName $name -Direction $dir -LocalPort $port -Protocol $proto -Action $action -RemoteAddress $ra -PolicyStore $gpo

$rule = Get-NetFirewallRule -DisplayName $name -PolicyStore $gpo
$rule | ft
Get-NetFirewallPortFilter -AssociatedNetFirewallRule $rule
Get-NetFirewallAddressFilter -AssociatedNetFirewallRule $rule
Restart-Computer FILE1,FILE2

Invoke-Command -ComputerName FILE1 -ScriptBlock $testps
#endregion
