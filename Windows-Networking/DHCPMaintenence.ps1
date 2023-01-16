#Maintaining DHCP
#region Database
    #View Database files on DC1
    start iexplore.exe \\dc1\c$\windows\system32\dhcp

    #Change DHCP automatic backup timing
    #Browse to Network Registry via Registry Editor
    #HKLM:\SYSTEM\CurrentControlSet\Services\DHCPServer
    regedit
    
    #Reconcile through GUI  
    Reconcile-DhcpServerv4IPRecord `
        -ScopeId 192.168.3.0 `
        -ComputerName DC1 `
        -ReportOnly

#endregion
#region DHCPBackup
    #gui
        #Backup to c:\DHCPBackup
        #Delete Scopes
        #Restore and verify
        
    #Scenario: You need to backup up the DHCP database and perform a test restore.
    Invoke-Command -ComputerName DC1 {
        get-childitem c:\windows\system32\dhcp\backup
    }

    #backup one-time to defined location
    Backup-DhcpServer -ComputerName DC1 -Path \\dc1\c$\DHCPBackup2
    Invoke-Command -ComputerName DC1 {
        get-childitem c:\DHCPBackup2
    }

    #Remove Scope
    Remove-DhcpServerv4Scope -ScopeId 192.168.3.0 -ComputerName DC1 -Force
    Remove-DhcpServerv4Scope -ScopeId 192.168.4.0 -ComputerName DC1 -Force
    Remove-DhcpServerv4Scope -ScopeId 192.168.5.0 -ComputerName DC1 -Force
    Get-DhcpServerv4Scope -ComputerName DC1
    
    #Restore DHCPServer
    Restore-DhcpServer -ComputerName DC1 -Path \\dc1\c$\DHCPBackup2 -Force
    Invoke-Command -ComputerName DC1 -ScriptBlock {
        Restart-Service -Name DHCPServer -Force
        }
    Get-DhcpServerv4Scope -ComputerName DC1 
    Get-DhcpServerv4Lease -ScopeId 192.168.3.0 -ComputerName DC1
    
#endregion DHCPBackup
#region DHCPInfo
#View Icons for DHCP Console and Review
Start iexplore.exe "https://technet.microsoft.com/en-us/library/gg722802(v=ws.10).aspx"

#Review DHCP Server Info
Get-DhcpServerv4Statistics -ComputerName DC1
Get-DhcpServerv4FreeIPAddress -ComputerName DC1 -ScopeId 192.168.3.0
get-service -ComputerName DC1 -Name DHCPServer

#Gather Scope information
Get-DhcpServerv4Scope -ComputerName DC1 
Get-DhcpServerv4Scope -ComputerName DC1 -ScopeId 192.168.3.0 | format-list
Get-DhcpServerv4OptionValue -ComputerName DC1 -All |fl
Get-DhcpServerv4OptionValue -ComputerName DC1 -All -ScopeId 192.168.3.0|fl

#Review Event Logs
    #Configure DC1 for remote event reading using Event Viewer
    Invoke-Command -ComputerName DC1{
        Set-NetFirewallRule `
        -DisplayGroup 'Remote Event Log Management' `
        -Enabled True -PassThru |
        select DisplayName, Enabled
        }
    eventvwr.msc
#endregion DHCPInfo
#region troubleshooting
    #Stop DHCPServer to simulate Outage
    Invoke-Command -ComputerName dc1 { stop-service DHCPServer }
    
    #Check on Cli2
    ipconfig /all
    Get-NetIPAddress
    ipconfig /release
    ipconfig /renew
    get-netipadress
        #Note: 169.254...
    
    #Investigate
    Get-DhcpServerSetting -ComputerName dc1
    Invoke-Command -ComputerName dc1 { get-service DHCPServer }
    
    #Restart Service
    Invoke-Command -ComputerName dc1 { start-service DHCPServer }
    Get-DhcpServerSetting -ComputerName dc1
    
    #Command.exe legacy commands
    ipconfig /release 
    ipconfig /renew 
#endregion troubleshooting




