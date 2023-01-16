#Made by James Murray 27/08/2017 

$UserCredential = Get-Credential
Connect-MsolService -Credential $UserCredential
$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://outlook.office365.com/powershell-liveid/ -Credential $UserCredential -Authentication Basic -AllowRedirection
Import-PSSession $Session


# to close out of a powershell session
Exit-PSSession

#In order to run custom scripts you must lower the security settings for PowerShell. To do this open a PS console as Administrator. 
set-ExecutionPolicy remotesigned

#create shared mailbox
#The simplest way to create a shared mailbox is to create it on 365, if you wish to have the object synchronised with your Active Directory, create a duplicate account in Active Directory and allow DIRSYNC to soft match the objects. 
#Note: When doing it this way the account display name and details will be the simple Email address of the mailbox. If you then DIRSYNC with AD the details will come from the AD object and can be tailored to your requirements. 
New-Mailbox -Name NAME@DOMAIN.COM -Alias NAME -Shared
Set-Mailbox NAME -ProhibitSendReceiveQuota 5GB -ProhibitSendQuota 4.75GB -IssueWarningQuota 4.5GB 
Add-MailboxPermission TargetMailbox -User USER -AccessRights FullAccess -confirm:$false
Add-RecipientPermission TargetMailbox -Trustee USER -AccessRights SendAs -confirm:$false

##convert to a shared mailbox
Set-Mailbox -Identity <EMAIL ADRESS> -Type “Shared” -ProhibitSendReceiveQuota 5GB -ProhibitSendQuota 4.75GB -IssueWarningQuota 4.5GB


#set mailbox size
Set-Mailbox -Identity <EMAIL ADRESS> -ProhibitSendReceiveQuota 5GB -ProhibitSendQuota 4.75GB -IssueWarningQuota 4.5GB

#Set Email delegation as owner
Add-MailboxFolderPermission -Identity <EMAIL ADRESS OF OWNER> -user <EMAIL ADRESS OF DELEGATE> -AccessRights Owner

#upload user photo to 365
##Log in using different method
$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://outlook.office365.com/powershell-liveid/?proxyMethod=RPS -Credential (Get-Credential) -Authentication Basic -AllowRedirection   
Import-PSSession $Session -AllowClobber -WarningAction SilentlyContinue -ErrorAction SilentlyContinue

Set-UserPhoto "<EMAIL ADRESS>" -PictureData ([System.IO.File]::ReadAllBytes("\\<SERVER LOCATION>.jpg"))

#Ad sync (dir sync)
Start-ADSyncSyncCycle -PolicyType Delta

#Change name in 365
Set-MsolUserPrincipalName -newuserprincipalname newname@yourdomain.com -userprincipalname oldname@yourdomain.com

#Change shared mailbox back to regular
Set-Mailbox -Identity <EMAIL ADRESS> -Type “regular” -ProhibitSendReceiveQuota 5GB -ProhibitSendQuota 4.75GB -IssueWarningQuota 4.5GB

##Convert mailbox types: 
Set-Mailbox ALIAS -Type shared 
Set-Mailbox ALIAS -Type room 
Set-Mailbox ALIAS -Type regular 


#Add calendar permission
Add-MailboxFolderPermission -Identity <EMAIL ADRESS OF OWNER>:\calendar -user <EMAIL ADRESS OF DELEGATE> -AccessRights Owner
#Other access rights
#Owner
#PublishingEditor
#Editor
#PublishingAuthor
#Author
#NonEditingAuthor
#Reviewer
#Contributor
#AvailabilityOnly
#LimitedDetails


# View and remove mailbox permissions
get-MailboxFolderPermission -Identity <EMAIL ADRESS>:\calendar
get-MailboxFolderPermission -Identity <EMAIL ADRESS>
remove-MailboxFolderPermission -Identity <EMAIL ADRESS OF OWNER> -user <EMAIL ADRESS OF DELEGATE>

#Default calendar permission
Add-MailboxFolderPermission -Identity <EMAIL ADRESS>:\calendar -user default -AccessRights Reviewer

#Disable / enable email features
#the following can be used for a single account using their full email address##
Set-CASMailbox -Identity user@DOMAIN.com -OWAEnabled $false
Set-CASMailbox -Identity user@DOMAIN.com -ActiveSyncEnabled $false
Set-CASMailbox -Identity user@DOMAIN.com -imapenabled $false -popenabled $false 
##the following can be used for an account list##
Get-content %path to folder%\users.txt | Set-CASMailbox -OWAEnabled $false
Get-content %path to folder%\users.txt | Set-CASMailbox -ActiveSyncEnabled $false
Get-content %path to folder%\users.txt | Set-CASMailbox -imapenabled $false -popenabled $false
Get-content %path to folder%\users.txt | Set-CASMailbox -OWAforDevicesEnabled $false

#Create new room list
New-DistributionGroup -Name "<NAME OF GROUP>" –RoomList
#Add room to list
Add-DistributionGroupMember –Identity "<NAME OF GROUP>" -Member "<NAME OF ROOM>"

#Hide Distribution group from GAL (Global Address list)
Set-DistributionGroup "<Distribution Group Name>" -HiddenFromAddressListsEnabled $True

# Hide User or group from GAL	
Set-UnifiedGroup -Identity <EMAIL ADRESS> -HiddenFromAddressListsEnabled $true

# Hide Disabled users grom GAL
$mailboxes = get-user | where {$_.UserAccountControl -like '*AccountDisabled*' -and $_.RecipientType -eq 'UserMailbox' } | get-mailbox  | where {$_.HiddenFromAddressListsEnabled -eq $false}
foreach ($mailbox in $mailboxes) { Set-Mailbox -HiddenFromAddressListsEnabled $true -Identity $mailbox }


# Set Out of Office on Mailbox. https://docs.microsoft.com/en-us/powershell/module/exchange/mailboxes/set-mailboxautoreplyconfiguration?view=exchange-ps
Set-MailboxAutoReplyConfiguration -Identity Javier.rufat@epr.co.uk -AutoReplyState Enabled -ExternalMessage "Hi, I have now left the company. Please contact the relevant person regarding your query. Many Thanks"
Set-MailboxAutoReplyConfiguration -Identity Javier.rufat@epr.co.uk -AutoReplyState Enabled -InternalMessage "Hi, I have now left the company. Please contact the relevant person regarding your query. Many Thanks"

# Log into Skype for business 365 after installing modules
Import-Module "C:\Program Files\Common Files\Skype for Business Online\Modules\SkypeOnlineConnector\SkypeOnlineConnector.psd1"
$credential = Get-Credential
$Session = New-CsOnlineSession -Credential $credential -OverrideAdminDomain "company.onmicrosoft.com"
Import-PSSession $session

# Set Save Skype IM messages to on and greyed out. Change tenant Id from skype company portal.
Grant-CsClientPolicy -policyname tag:ClientPolicyNoIMURL -Tenant <TENANT ID>

# Add license to user
# Get license SKU for command
Get-MsolAccountSku
#Add license
Set-MsolUserLicense -UserPrincipalName "<EMAIL ADRESS>" -AddLicenses "Company:O365_BUSINESS_PREMIUM"

#Remove Events From calendar
# Cancels every meeting in the mailbox chris@contoso.com that occurs on or after today's date.
Remove-CalendarEvents -Identity <EMAIL ADRESS> -CancelOrganizedMeetings


# Cancels the meetings in Angela Gruber's calendar for the specified date range
Remove-CalendarEvents -Identity "Angela Gruber" -CancelOrganizedMeetings -QueryStartDate     11-1-2018 -QueryWindowInDays 120

# This example previews the meetings that would be cancelled in Jacob Berger's calendar for the specified date range. No changes are made to the mailbox.
Remove-CalendarEvents -Identity "Jacob Berger" -CancelOrganizedMeetings -QueryStartDate 9-1-2018 -QueryWindowInDays 90 -PreviewOnly -Verbose


#Find all licensed 365 Users and export to csv
{
<#

.Synopsis
   getLicenseGT is a small PowerShell Scipt which can be used in O365 to fetch the licenses assigned to users. Currently the script can be used to get details of
   E1, E3, K1 and EMS Licenses Assigned. Also, the script can handle cases in which users are assigned with multiple flavours of licenses like E1 clubbed with EMS, E3 clubbed with EMS etc.
   Note: If you have more flavours of licenses, please let me know the AccountSkuId or plan name so that the script can be updated.

   Developed by: Noble K Varghese

    THIS CODE IS MADE AVAILABLE AS IS, WITHOUT WARRANTY OF ANY KIND. THE ENTIRE 
    RISK OF THE USE OR THE RESULTS FROM THE USE OF THIS CODE REMAINS WITH THE USER.

    Version 1.1, 26 June 2015
		#Initial Release
	In Future
		#Workload based License Assignment Details (Lync, SharePoint, Yammmer, Intune, AzureRMS etc.)
.DESCRIPTION
   getLicenseGT.ps1 is a PowerShell Sciprt for Office365. It helps the Admin in collecting details of licenses assigned to users. On completion, the Script creates a CSV report 
   as the output in the current working directory. This scripts supports PowerShell 2.0 & 3.0. I am using 3.0 though. You needn't connect to Exchange Online to run this script.
   A connection to MsolService is enough.

.getLicenseGT.ps1
   To Run the Script go to PowerShell and Start It. Eg: PS E:\PowerShellWorkshop> .\getLicenseGT.ps1

.Output Logs
   The Script creates a CSV report as the output in the present working directory in the format LicesneStatus_%Y%m%d%H%M%S.csv

 #>

Connnect-MsolService

$Header = "UserPrincipalName, DisplayName, LicenseAssigned, Office"
$Data = @()
$OutputFile = "LicesneStatus_$((Get-Date -uformat %Y%m%d%H%M%S).ToString()).csv"
Out-File -FilePath $OutputFile -InputObject $Header -Encoding UTF8 -append

$users = Get-MSolUser -All

foreach($user in $users)
{
	$UPN = $User.UserPrincipalName
	$DisplayName = $User.DisplayName
	$Licenses = $User.Licenses.accountskuid
	
	$AccSkId = (Get-MsolAccountSku).accountskuid[0].split(":")[0]
	
	$E1Lic = $AccSkId+":STANDARDPACK"
	$E3Lic = $AccSkId+":ENTERPRISEPACK"
	$EMSLic = $AccSkId+":EMS"
	$K1Lic = $AccSkId+":EXCHANGEDESKLESS"
	
	if($Licenses.Count -eq "0")
	{
		$InLic = "User Not Licensed"
	}
	else
	{
		foreach($License in $Licenses)
		{
			if($Licenses.Count -gt 1)
			{
				if($Licenses -contains ($E1Lic) -and ($Licenses -contains ($EMSLic)))
				{
					$InLic = "E1 & EMS"
				}
				elseif($Licenses -contains ($E3Lic) -and ($Licenses -contains ($EMSLic)))
				{
					$InLic = "E3 & EMS"	
				}
				elseif($Licenses -contains ($K1Lic) -and ($Licenses -contains ($EMSLic)))
				{
					$InLic = "K1 & EMS"
				}
				else
				{
					$InLic = "Unknown License Combination"
				}
			}
			else
			{
				if($Licenses -contains ($E1Lic))
				{
					$InLic = "E1"
				}
				elseif($Licenses -contains ($E3Lic))
				{
					$InLic = "E3"
				}
				elseif($Licenses -contains ($EMSLic))
				{
					$InLic = "EMS"
				}
				elseif($Licenses -contains ($K1Lic))
				{
					$InLic = "K1"
				}
				else
				{
					$InLic = "Unknown License"
				}
			}
		}
	}
	$Office = $User.Office
	
	$Data = ($UPN + "," + $DisplayName + "," + $InLic + "," + $Office)
	
	Out-File -FilePath $OutputFile -InputObject $Data -Encoding UTF8 -append
}
}
