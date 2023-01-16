###HYPERV1

#region Creating the SDN Infrastructure and Virtual Subnets
#Create the domain controller for the SDN
cd C:\windows-server-2016-core-networking\Configurations\DC-SDN
.\Setup-Lab.ps1
.\Run-Lab.ps1

cd C:\sdn\SDNExpress\scripts
.\SDNExpress.ps1 -ConfigurationDataFile .\POCFabricConfig.psd1 -Verbose
.\SDNExpressTenant.ps1 -ConfigurationDataFile .\POCTenantConfig.psd1 -Verbose

Get-VMNetworkAdapter * | Select-Object SwitchName,VMName | Sort-Object SwitchName,VMName
#endregion

#region Connecting a Server to a Virtual Subnet
ise C:\sdn\SDNExpress\scripts\AttachVMtoSDN.ps1

#Connect to DC-SDN
Enter-PSSession -VMName DC-SDN
Get-NetIPAddress -AddressFamily IPv4 | ft
ping 192.168.80.1
ping 192.168.90.3
Exit-PSSession

#Connect to FILE3
Enter-PSSession -VMName FILE3
Get-NetIPAddress -AddressFamily IPv4 | ft
ping 192.168.90.1
ping 192.168.90.4
ping 192.168.80.10
Add-Computer -DomainName company.pri
Restart-Computer

#Connect to FILE4
Enter-PSSession -VMName FILE4
Get-NetIPAddress -AddressFamily IPv4 | ft
ping 192.168.90.1
ping 192.168.90.3
ping 192.168.80.10
Add-Computer -DomainName company.pri
Restart-Computer

#Test PowerShell connectivity from FILE3 to DC-SDN
Enter-PSSession -VMName FILE3
Invoke-Command -ComputerName DC-SDN -ScriptBlock {Get-NetTCPConnection -LocalPort 5985 | ft}
Exit-PSSession

#Configure the Windows Firewall to allow PowerShell
Enter-PSSession -VMName DC-SDN
New-NetFirewallRule -DisplayName "Allow PowerShell Inbound" -Direction Inbound -LocalPort 5985 -Protocol TCP -Action Allow
Exit-PSSession

Enter-PSSession -VMName FILE3
Invoke-Command -ComputerName DC-SDN -ScriptBlock {Get-NetTCPConnection -LocalPort 5985 | ft}
Exit-PSSession

#Use the datacenter firewall to block PowerShell
ise C:\sdn\SDNExpress\scripts\AddNewACLRule.ps1

#Test PowerShell connectivity from FILE3 to DC-SDN
Enter-PSSession -VMName FILE3
Invoke-Command -ComputerName DC-SDN -ScriptBlock {Get-NetTCPConnection -LocalPort 5985 | ft}
ping DC-SDN
Exit-PSSession

#Test PowerShell from DC-SDN to FILE3
Enter-PSSession -VMName DC-SDN
Test-Connection FILE3
Invoke-Command -ComputerName FILE3 -ScriptBlock {Get-NetTCPConnection -LocalPort 5985 | ft}
Exit-PSSession

#IPSEC
#Create a GPO to enforce the PowerShell IPSec requirement across the domain
Enter-PSSession -VMName DC-SDN
New-GPO -Name IPSec
New-GPLink -Name IPsec -Target "DC=Company,DC=Pri"
$name = "Require IPSec for PowerShell"
$gpo = "company.pri\IPSec"
New-NetIPsecRule -DisplayName $name -InboundSecurity Require -OutboundSecurity Require -RemotePort 5985 -Protocol TCP -PolicyStore $gpo
Exit-PSSession

Restart-VM -VMName FILE3,FILE4 -Force

#Connect to FILE3 and verify security associations with FILE4
Enter-PSSession -VMName FILE3
Invoke-Command -ComputerName FILE4 -ScriptBlock {Get-NetIPsecQuickModeSA | ft}
Exit-PSSession
