<#

.SYNOPSIS
    Enables firewall rules on Windows Server 2016 which will allow 
    a Windows 10 client to manage the storage configuration remotely.

.NOTES
    This example code is provided without copyright and AS IS.  It is free for you to use and modify.

#>

Enable-NetFirewallRule -DisplayName 'COM+ Network Access (DCOM-In)'

Enable-NetFirewallRule -DisplayName 'Remote Event Log Management (RPC)'      
Enable-NetFirewallRule -DisplayName 'Remote Event Log Management (NP-In)'    
Enable-NetFirewallRule -DisplayName 'Remote Event Log Management (RPC-EPMAP)'

Enable-NetFirewallRule -DisplayName 'Remote Volume Management - Virtual Disk Service (RPC)'      
Enable-NetFirewallRule -DisplayName 'Remote Volume Management - Virtual Disk Service Loader (RPC)'
Enable-NetFirewallRule -DisplayName 'Remote Volume Management (RPC-EPMAP)'