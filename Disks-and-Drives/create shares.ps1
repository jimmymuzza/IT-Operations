# Do through Server manager

# Create NFS share: Install role
Add-WindowsFeature FS-FileServer, FS-NFS-Service -IncludeManagementTools
# then create through server manager

#View share information
Get-NfsShare
Get-NfsShare LinuxFolder1 | fl *

Get-SmbShare
$smb=New-CimSession -ComputerName plabdc01
Get-SmbShare -CimSession $smb

# Check what computers are connected to share
Get-SmbSession -CimSession $smb
# Additional details
Get-SmbSession -CimSession $smb -ClientUserName practicelabs\administrator | fl *

## Turn off Legacy SMB1 Protocol

# To get the SMB Server configuration which are enabled, type:

Get-SmbServerConfiguration | fl enable*
Set-SmbServerConfiguration -EnableSMB1Protocol $false


## Configuring iSCSI Storage
# Set Static IP and Preferred DNS
## oN A SERVER
New-NetIPAddress -InterfaceAlias “Ethernet 2” -IPAddress 192.168.0.10 -PrefixLength 24
# On A different server
New-NetIPAddress -InterfaceAlias Ethernet1 -IPAddress 192.168.0.20 -PrefixLength 24
New-NetIPAddress -InterfaceAlias Ethernet2 -IPAddress 192.168.1.20 -PrefixLength 24
# Set DNS address
Set-DnsClientServerAddress -InterfaceAlias Ethernet1 -ServerAddresses 192.168.0.1
# Ethernet1 is now set up to use a preferred DNS server.
Set-DnsClientServerAddress -InterfaceAlias Ethernet2 -ServerAddresses 192.168.0.1

# Install ISCSI tools on Target server
Add-WindowsFeature FS-iSCSITarget-Server -IncludeManagementTools
## Important: If you get the error message indicating that the server is unable to install the feature because Windows is currently performing another servicing operation. You can run the following command in PowerShell to stop any scheduled task. Get-ScheduledTask | Where TaskPath -like “*TaskScheduler*” | Stop-ScheduledTask

# Role is now installed. Use server manager to set up iscsi drives

## Configure Multipath Input Output (MPIO)
# Multipath I/O is a Microsoft storage specification that enables vendors to create solutions that include hardware-specific information to optimize connectivity with their storage array products. MPIO is indepenent of any storage protocol as it can be used with technologies such as Internet SCSI (iSCSI), Fibre Channel and Serial Attached SCSI (SAS) interfaces with Windows Server 2008 and later versions.
# Installs on iscsi member server
Add-WindowsFeature Multipath-IO -IncludeManagementTools
# Link to Target server in ISCSI initiator
# Server manager MPIO > Discover multi-paths tab
# Tick add support for iSCSI devices

## Preparing the iSCSI Initiator for MPIO
# Change Properties of iSCSI Initiator
# Disconnect iscsi connection
# Reconnect and tick enable MPIO
# Advanced> Local adapter drop-down list and select Microsoft iSCSI Initiator
