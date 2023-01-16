#Demo
#Module: Installing and Configuring DHCP

#View Available commands for DHCP
    Get-Command *DHCP*

#Install DHCP on remote server
    Get-WindowsFeature -Name *DHCP*

    Install-WindowsFeature -Name DHCP -ComputerName S1

#Authorize DHCP server in Domain
    Add-DhcpServerInDC -DnsName S1 -IPAddress 192.168.3.50

    Get-DhcpServerInDC
