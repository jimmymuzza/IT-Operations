## Made by James Murray 29/06/2018
# Run in ISE as admin on 365 SERVER

#Run to be able to use script
Set-ExecutionPolicy RemoteSigned

# Import active directory module for running AD cmdlets
Import-Module activedirectory

#Set inputs for new User
$FirstName = Read-Host -Prompt 'Firstname'
$LastName = Read-Host -Prompt 'Lastname'
$telnumber = Read-Host -Prompt 'extension'
$username = "$FirstName.$lastname"
$new_displayname = "$lastname, $firstname"
$new_name = "$firstname $lastname"
$new_user_logon_name = $username
$Email = "$username@epr.co.uk"
$new_password = 'Password01'
$new_ou_DN = 'ou=Users,dc=,dc='
$enable_user_after_creation = $true
$password_never_expires = $false
$cannot_change_password = $false
#test if variables have been created
Write-Host "Your name is $firstname $lastname and you username is $username and email is $email"


#Use previous variables inside script -Argument list to list the variables wanted. Then use $($args[0]), $($args[1]), $($args[2]), $($args[3]) to recall individual params e.g.

#Invoke-Command -ComputerName server2 -ArgumentList $Username,$Email,$Firstname,$Lastname,$telnumber -ScriptBlock  {
#Write-Host "Your name is $($args[2]) $($args[3]) and you username is $($args[0]) and email is $($args[1])"}

Invoke-Command -ComputerName <DOMAIN CONTROLLER> -ArgumentList $Username, $Email, $Firstname, $Lastname, $telnumber -ScriptBlock  {

# Creates New user with attributes
$Instance = Get-ADUser Architect.Template
New-ADUser -SamAccountName $($args[0]) -UserPrincipalName $($args[1]) -Instance $Instance -Name "$($args[2]) $($args[3])" -DisplayName "$($args[3]), $($args[2])" -GivenName $($args[2]) -Surname $($args[3]) `
-OfficePhone:"$($args[4])" -OtherAttributes @{'mail'="$($args[1])";'proxyAddresses'="SMTP:$($args[1])"} -accountPassword (ConvertTo-SecureString -AsPlainText "Password01" -Force) -passThru `
-ChangePasswordAtLogon $true -enabled $true -Path “ou=Mailbox Users,dc=lan,dc=epr,dc=co,dc=uk"

#Copy Group Membership from Other User
Get-ADUser -Identity $Instance -Properties memberof | Select-Object -ExpandProperty memberof | Add-ADGroupMember -Members $($args[0])

#Add user to All EPR, ARchitects and revit network
Add-ADPrincipalGroupMembership -Identity $($args[0]) -MemberOf:"CN=<GROUP NAME>,OU=Distribution,DC=,DC=","CN=<GROUP NAME>,OU=Security Groups,DC=,DC="

#Create User Drive and set user modify permissions
New-Item -Path "\\<SERVER>\users" -Name "$($args[0])" -ItemType "directory"
$Acl = Get-Acl "\\<SERVER>\users\$($args[0])"
$Ar = New-Object  system.security.accesscontrol.filesystemaccessrule("$($args[0])",'Modify', 'ContainerInherit,ObjectInherit', 'None', 'Allow')
$Acl.SetAccessRule($Ar)
Set-Acl "\\<SERVER>\users\$($args[0])" $Acl

#Set user Location
Set-ADUser -Country:"GB" -Identity $($args[0])

#Set Home directory and U drive
Set-ADUser -HomeDirectory:"\\<SERVER>\users\$($args[0])" -HomeDrive:"U:" -Identity $($args[0])
}

############

# Set up new user in swyx using original variables
Invoke-Command <SWYXSERVER> -Credential admin -ArgumentList $Username, $Email, $Firstname, $Lastname, $telnumber -ScriptBlock  {

Import-Module IpPbx
Connect-IpPbx
New-IpPbxUser -UserName "$($args[3]), $($args[2])" -EmailAddress "$($args[1])" | Add-IpPbxUser -AddToEveryoneGroup
$myNumber = New-IpPbxInternalNumber -InternalNumber $($args[4])
Add-IpPbxInternalNumberToUser -InternalNumberEntry $myNumber -UserName "$($args[3]), $($args[2])"
New-IpPbxPublicNumber -PublicNumber "+44207932$($args[4])" | Add-IpPbxPublicNumber -InternalNumber "$($args[4])"
Add-IpPbxUserWindowsAccount -UserName "$($args[3]), $($args[2])" -NTAccount "EPRLAN\$($args[0])"

}
############

#Log into 365 online
$UserCredential = Get-Credential "@"
Import-Module MSOnline
Connect-MsolService -Credential $UserCredential
$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://outlook.office365.com/powershell-liveid/ -Credential $UserCredential -Authentication Basic -AllowRedirection
Import-PSSession $Session

#Wait 30 seconds
Start-Sleep -s 30

#Ad sync (dir sync)
Start-ADSyncSyncCycle -PolicyType Delta
#Wait 3 minutes
Start-Sleep -s 180

# Add 365 license to user
Set-MsolUser -UserPrincipalName $email –UsageLocation GB
Set-MsolUserLicense -UserPrincipalName $email -AddLicenses "O365_BUSINESS_PREMIUM"

#Wait 1 Hour
Start-Sleep -s 3600

#Set Mailbox Size
Set-Mailbox -Identity $email -ProhibitSendReceiveQuota 5GB -ProhibitSendQuota 4.75GB -IssueWarningQuota 4.5GB

Exit-PSSession
