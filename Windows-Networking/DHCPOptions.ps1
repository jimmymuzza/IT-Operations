#region Configure DHCP Scopes
get-command *DHCPServerv4Scope* -Module DHCPServer

Add-DhcpServerv4Scope -ComputerName DC1 `
    -Description 'This is a future scope' `
    -Name '192.168.4.0 future scope' `
    -StartRange 192.168.4.100 `
    -EndRange 192.168.4.254 `
    -SubnetMask 255.255.255.0 `
    -LeaseDuration 08:00:00 `
    -Type Dhcp `
    -State Active

Add-DhcpServerv4Scope -ComputerName DC1 `
    -Description 'This is a future scope' `
    -Name '192.168.5.0 future scope' `
    -StartRange 192.168.5.1 `
    -EndRange 192.168.5.254 `
    -SubnetMask 255.255.255.0 `
    -LeaseDuration 08:00:00 `
    -Type Dhcp `
    -State Active

Add-DhcpServerv4ExclusionRange -ComputerName DC1 `
    -ScopeId 192.168.5.0 `
    -StartRange 192.168.5.1 `
    -EndRange 192.168.5.100

#Verify DHCP Scopes
Get-DhcpServerv4Scope -ComputerName DC1

Get-DhcpServerv4Scope -ComputerName DC1 -ScopeId 192.168.5.0 | format-list

Get-DhcpServerv4ScopeStatistics -computerName DC1 -ScopeId 192.168.5.0 | fl
#endregion

#region DHCP Options
get-command *OptionValue* -Module DHCPServer

#Set Server Options
Set-DHCPServerv4OptionValue `
    -DnsServer 192.168.3.10 `
    -DnsDomain company.pri `
    -ComputerName S1.company.pri

#Set Time Server for Network at Server Option level
Set-DhcpServerv4OptionValue `
    -OptionId 042 `
    -Value 192.168.3.1 `
    -ComputerName s1.company.pri

Get-DhcpServerv4OptionValue -ComputerName s1

#Set Scope Options
Set-DhcpServerv4OptionValue `
    -ComputerName DC1 `
    -ScopeId 192.168.5.0 `
    -Router 192.168.5.1

Get-DhcpServerv4OptionValue -ComputerName DC1 -ScopeId 192.168.5.0 | FL
#endregion

#region SuperScope
Get-Command *SuperScope* -Module DHCPServer

Add-DhcpServerv4Superscope `
    -SuperscopeName 'New Building Super Scope' `
    -ComputerName DC1 `
    -ScopeId 192.168.4.0,192.168.5.0

Get-DhcpServerv4Superscope -ComputerName DC1
#endregion

#region DHCP Multicast Scope
Get-Command *MulticastScope* -Module DHCPServer

Add-DhcpServerv4MulticastScope `
    -ComputerName DC1 `
    -Name 'Video Streaming Scope' `
    -Description ' This is a scope for addresses for video streaming app' `
    -StartRange 225.0.0.1 `
    -EndRange 225.0.0.254 `
    -State InActive `
    -LeaseDuration 15:0:0:0

Get-DhcpServerv4MulticastScope -ComputerName dc1
#endregion

#region DHCP Client Leases and Reservations
Get-DhcpServerv4Lease `
    -ComputerName DC1 `
    -ScopeId 192.168.3.0

Get-DhcpServerv4Reservation `
    -ComputerName DC1 `
    -ScopeId 192.168.3.0

#endregion

