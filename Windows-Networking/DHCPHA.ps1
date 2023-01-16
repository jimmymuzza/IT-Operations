##Hi-Availability

#region - Create Failover
#View Commands
    gcm -Name *v4failover*

#Get current failover on S1 and remove
    Get-DhcpServerv4Failover -ComputerName s1 |
         Remove-DhcpServerv4Failover -Force -ComputerName s1
    Get-DhcpServerv4Failover -ComputerName s1 

#Get all existing scopes
    $ipv4scopes = Get-DhcpServerv4Scope -ComputerName s1.company.pri

#Create Failover Relationship
    Add-DhcpServerv4Failover `
        -ComputerName S1.company.pri `
        -Name S1-DC1-Failover `
        -PartnerServer DC1.company.pri `
        -ScopeId $ipv4scopes.ScopeID `
        -LoadBalancePercent 70 `
        -MaxClientLeadTime 2:00:00 `
        -AutoStateTransition $true `
        -StateSwitchInterval 2:00:00

    Get-DhcpServerv4Failover -ComputerName s1
    Get-DhcpServerv4Failover -ComputerName DC1
#endregion
#region Add Failover Scopes
#New Scope
    Add-DhcpServerv4Scope -ComputerName s1 `
        -Description 'This is a future scope' `
        -Name '192.168.6.0 future scope' `
        -StartRange 192.168.6.100 `
        -EndRange 192.168.6.254 `
        -SubnetMask 255.255.255.0 `
        -LeaseDuration 08:00:00 `
        -Type Dhcp `
        -State Active

    Add-DhcpServerv4FailoverScope `
        -ComputerName s1 `
        -ScopeId 192.168.6.0 `
        -Name S1-DC1-Failover

    Get-DhcpServerv4Failover -ComputerName s1
    Get-DhcpServerv4Failover -ComputerName dc1
#endregion
#region - Maintaining Failover
#Change LoadBalancePercent and add message authentication with shared secret
    Set-DhcpServerv4Failover `
        -ComputerName S1 `
        -Name S1-DC1-Failover `
        -SharedSecret “P@ssw0rd” `
        -LoadBalancePercent 50
    
    Get-DhcpServerv4Failover -ComputerName s1
    Get-DhcpServerv4Failover -ComputerName DC1

#Force Replication of settings
    Invoke-DhcpServerv4FailoverReplication `
        -ComputerName S1 `
        -Name S1-DC1-Failover

#View DHCP Statistics
    Get-DhcpServerv4ScopeStatistics `
        -ComputerName s1 `
        -ScopeId 192.168.3.0 `
        –Failover|fl

#Modify Failover for Maintenance
    Set-DhcpServerv4Failover `
        -ComputerName S1 `
        -Name S1-DC1-Failover `
        -LoadBalancePercent 100

    Get-DhcpServerv4ScopeStatistics `
        -ComputerName s1 `
        -ScopeId 192.168.3.0 `
        –Failover|fl
#endregion