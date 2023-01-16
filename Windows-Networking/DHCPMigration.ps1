##DHCP Migration

#region - Legacy migration with Netsh
    #Document Settings
    Invoke-Command -ComputerName DC1 {
        Get-DhcpServerSetting | fl
        Get-DhcpServerv4Scope | FL
        Get-DhcpServerv4Policy | fl
        Get-DhcpServerv4Superscope | fl
        Get-DhcpServerv6Scope | Fl
       } | out-file c:\scripts\docdhcp.txt
    notepad c:\scripts\docdhcp.txt
        
    #Verify DHCP Server Service is installed on Remote System
    Get-DhcpServerSetting -ComputerName S1
        
    #export configuration on DC1
    Enter-PSSession -ComputerName DC1
        netsh dhcp server export C:\dhcp-cfg.txt
        get-item C:\dhcp-cfg.txt
        Copy-Item `
            -Path \\dc1\c$\dhcp-cfg.txt `
            -Destination \\s1\c$\dhcp-cfg.txt
        Exit
    
    #Import Configuration on S1
    Enter-PSSession -ComputerName s1
        get-item C:\dhcp-cfg.txt
        Stop-service DHCPserver
        Del c:\windows\system32\DHCP\DHCP.mdb
        Start-service DHCPserver
        Netsh DHCP Server Import c:\dhcp-cfg.txt
        restart-service DHCPserver
        Exit
    
    #Verify
    Get-DhcpServerSetting -ComputerName s1 | fl
    Get-DhcpServerv4Scope -ComputerName S1 | ft
    Get-DhcpServerv4Policy -ComputerName S1 | ft
    Get-DhcpServerv4Superscope -ComputerName s1 | ft
    Get-DhcpServerv4Lease -ComputerName S1 -ScopeId 192.168.3.0 | ft
    Get-DhcpServerv6Scope -ComputerName S1 | ft
    
#endregion
#region -Migrating an Existing Configuration from One Server to Another 
    #Verify DHCP Server Service is installed on Remote System
    Get-DhcpServerSetting -ComputerName S1
    Get-DhcpServerv4Scope -computername s1
    
    #Document Settings
    Invoke-Command -ComputerName DC1 {
        Get-DhcpServerSetting | fl
        Get-DhcpServerv4Scope | FL
        Get-DhcpServerv6Scope | Fl
        Get-DhcpServerv4Policy | fl
        Get-DhcpServerv4Superscope | fl
        } | out-file c:\docdhcp.txt
    notepad c:\docdhcp.txt
    
    #Create Backup Folder on Admin Workstation
    New-Item -ItemType directory -Path c:\DHCPMigration

    #Review Help file for examples
    Help Export-DHCPServer -Full
    
    #Single Scope with Leases
    Export-DHCPServer -ComputerName DC1 `
        -ScopeId 192.168.3.0 `
        -Leases `
        -File "c:\DHCPMigration\DHCPScopeExport.xml" `
        -Verbose `
        -Force
    
    C:\DHCPMigration\DHCPScopeExport.xml
    
    #Export Entire DHCP Server configuration with Leases
    Export-DhcpServer -ComputerName DC1 `
        -Leases `
        -File "c:\DHCPMigration\fulldhcpexport.xml" `
        -Verbose `
        -Force

    #Import Entire Server Configuration to S1
    Import-DhcpServer -ComputerName S1 `
        -File c:\DHCPMigration\fulldhcpexport.xml `
        -BackupPath c:\DHCPBackup `
        -Leases `
        -Verbose
    
    #Verify Scopes, Policies, and Leases are moved to S1
    Get-DhcpServerSetting -ComputerName s1 | fl
    Get-DhcpServerv4Scope -ComputerName S1 | ft
    Get-DhcpServerv4Policy -ComputerName S1 | ft
    Get-DhcpServerv4Superscope -ComputerName s1 | ft
    Get-DhcpServerv4Lease -ComputerName S1 -ScopeId 192.168.3.0 | ft
    Get-DhcpServerv6Scope -ComputerName S1 | ft

    #Verify CL2 gets ip from new dhcpServer
    Invoke-Command -ComputerName DC1 {stop-service DHCPServer}

    #Decommission DC1
    Remove-DhcpServerInDC -DnsName DC1.company.pri
    Get-DhcpServerInDC
    Invoke-Command -ComputerName DC1 {Stop-Service DHCPServer}
    Remove-WindowsFeature -Name DHCP -ComputerName DC1 -Restart
    invoke-command -ComputerName DC1 { 
        Remove-Item -Path c:\windows\system32\dhcp -Recurse -Verbose 
        }
#endregion

