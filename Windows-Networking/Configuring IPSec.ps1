###MYDESKTOP

#Require IPSec for inbound PowerShell connections to FILE1 and FILE2
$admincred = Get-Credential -UserName "COMPANY\administrator" -Message "Enter the domain admin password"
Enter-PSSession -ComputerName DC -Credential $admincred

$name = "Require IPSec for PowerShell"
$gpo = "company.pri\Firewall"
$mode = "Transport"
New-NetIPsecRule -DisplayName $name -Mode $mode -InboundSecurity Require -Protocol TCP -LocalPort 5985 -PolicyStore $gpo -Enabled True
$rule = Get-NetIPsecRule -PolicyStore $gpo
$rule | ft
Get-NetFirewallPortFilter -AssociatedNetIPsecRule $rule
Get-NetFirewallAddressFilter -AssociatedNetIPsecRule $rule
Restart-Computer FILE1,FILE2

#Test connectivity to FILE1
$testipsec = {Get-NetIPsecMainModeSA | ft}
Invoke-Command -ComputerName FILE1 -ScriptBlock $testipsec

#Create rule to request IPSec outbound
$name = "Request outbound IPSec for PowerShell"
New-NetIPsecRule -DisplayName $name -OutboundSecurity Request -InboundSecurity Request -RemotePort 5985 -Protocol TCP

#Now it should work
Invoke-Command -ComputerName FILE1 -ScriptBlock $testipsec
$testipsec
Invoke-Command -ComputerName FILE2 -ScriptBlock $testipsec
Remove-NetIPsecRule -DisplayName $name

#Remove "Require IPSec for PowerShell" rule from Firewall GPO
$name = "Require IPSec for PowerShell"
$gpo = "company.pri\Firewall"
Remove-NetIPsecRule -DisplayName $name -PolicyStore $gpo

#Create a GPO to enforce the PowerShell IPSec requirement across the domain
New-GPO -Name IPSec
New-GPLink -Name IPsec -Target "DC=Company,DC=Pri"
$name = "Require IPSec for PowerShell"
$gpo = "company.pri\IPSec"
New-NetIPsecRule -DisplayName $name -InboundSecurity Require -OutboundSecurity Require -RemotePort 5985 -Protocol TCP -PolicyStore $gpo
Exit-PSSession

#MYDESKTOP
gpupdate /force
Get-NetIPsecRule -PolicyStore ActiveStore | Select-Object DisplayName,Enabled,Mode,SecIn,SecOut,PolicyStoreSourceType

#Connect to DC and verify security associations
Enter-PSSession -ComputerName DC -Credential $admincred
Get-NetIPsecMainModeSA | ft
Get-NetIPsecQuickModeSA | ft
Exit-PSSession
