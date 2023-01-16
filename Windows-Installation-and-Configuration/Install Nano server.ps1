#To prepare the Windows PowerShell scripts from installation media, perform the following steps
Powershell
cd\
#Create nano server folder
md nanoserver

#copy nano server scripts from installation media
copy z:\NanoServer\NanoServerImageGenerator\*.ps* c:\nanoserver

# Import Windows PowerShell Modules
Import-Module c:\nanoserver\NanoServerImageGenerator.psm1

##Creating Nano Server Virtual Hard Disk Image
New-NanoServerImage -Edition Standard -MediaPath z:\ -Basepath c:\nanoserver -Targetpath c:\nanoserver\PLABNANOSRV01.vhdx -DeploymentType Guest -ComputerName PLABNANOSRV01 -Storage -Package Microsoft-NanoServer-DNS-Package

# Add newly created Nano Server vhdx to VM
# Modify Boot order of Nano server- Settings> Firmware > Move Hard drive to the top
# Modify Network and Inbound firewall rules

# Disable WinHTTP Proxy Setting on host
Powershell
netsh winhttp show proxy
netsh winhttp reset proxy

# Add Nano Server to Domain- Djoin
djoin  /provision /domain practicelabs /machine PLABNANOSRV01 /savefile .\odjblob

# Configure Nano server to be a trusted host in Windows Server Management (WS-Man) service (on Host)
Set-Item WSMan:\localhost\Client\TrustedHosts “192.168.0.35”
y

# Set up remote administration
#To set a variable called $ipv4 for PLABNANOSRV01’s IP address, type the following command:
$ipv4=”192.168.0.35”
# After defining the $ipv4 variable, you will establish a PowerShell session with the PLABNANOSRV01 device.
Enter-PSSession -ComputerName $ipv4 -Credential $ipv4\administrator

# To enable or open the various File and Printer Sharing ports on PLABNANOSRV01, type:
netsh advfirewall firewall set rule group=”File and Printer Sharing” new enable=yes
exit

# Copy Djoin file
# Map network path to X drive:
net use x: \\192.168.0.35\c$
cd x:

# Rmote powershell to Nano server
Enter-PSSession -ComputerName $ipv4 -Credential $ipv4\administrator

# Add Host Record for Nano Server: To enable DNS name resolution in the lab network, you must add a static host (A) record for PLABNANOSRV01
# Can then use server manager to add or remove roles


