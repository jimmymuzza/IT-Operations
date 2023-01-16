#DHCPv6
#region - Set Remote IPv6 Address on DC1
    #Remote session to DC1
    $Cimsession = New-CimSession -ComputerName DC1
    Get-NetIPConfiguration -CimSession $cimsession
    
    #Set IP Address remotely on DC1
    New-NetIPAddress `
        -Interfaceindex 2 `
        -CimSession $cimsession `
        -IPAddress 2001:2001:2001:2001:2001:2001:2001:10 `
        -PrefixLength 64 `
        -DefaultGateway 2001:2001:2001:2001:2001:2001:2001:1

    #Bind DHCPv6 Server to use Ethernet adapter on DC1
    Set-DhcpServerv6Binding `
        -ComputerName DC1 `
        -BindingState $true `
        -InterfaceAlias Ethernet
    
    Get-DhcpServerv6Binding -ComputerName DC1 
#endregion    
#region - Demo 1 Create Scope in Gui
##DHCP Scope GUI Information
#Name - 2001:2001:2001:2001::/64 IPv6 Scope
#Prefix - 2001:2001:2001:2001::
#Start exclusion - :10
#end exclusion - :ffff
#Preference = 2
#DNS Recursive Server - 2001:2001:2001:2001:2001:2001:2001:10
#endregion
#region demo 2 - Create Scope in PowerShell
    #Create Scope
    Add-DhcpServerv6Scope `
        -ComputerName DC1 `
        -Prefix 2001:2002:2001:: `
        -Name 'Company.pri IPv6 Scope' `
        -Preference 2 `
        -State Active

    #Add Exclusionary Range
    Add-DhcpServerv6ExclusionRange `
        -ComputerName DC1 `
        -Prefix 2001:2002:2001:: `
        -StartRange 2001:2002:2001::10 `
        -EndRange 2001:2002:2001::256

    #Set DNS Server at Server Option level
    Set-DhcpServerv6OptionValue `
        -ComputerName DC1 `
        -DnsServer 2001:2001:2001:2001:2001:2001:2001:10 `
        -Force 
    
    Get-DhcpServerv6Scope -ComputerName DC1
    #Restart Cli1/Cli2 to see IPv6 Addresses
    Restart-Computer

    #Verify IPv6 Address Information
    Get-DhcpServerv6Scope -ComputerName DC1 | fl
    Get-DhcpServerv6Lease -ComputerName DC1 -Prefix 2001:2001:2001:2001:: | FT -Wrap
    Get-DhcpServerv6ScopeStatistics -ComputerName DC1 | fl
    Get-DhcpServerv6ScopeStatistics -ComputerName DC1 -Prefix 2001:2001:2001:2001::

    #Create a Reservation in the GUI


#endregion


