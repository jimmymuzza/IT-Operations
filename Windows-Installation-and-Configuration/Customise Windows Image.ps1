### -- Remove Unneeded Install Options
get-windowsimage -imagepath c:\hyperv\install.wim
remove-windowsimage -imagepath c:\hyperv\install.wim -index 1

### -- Apply Updates
mkdir c:\offline
mount-windowsimage -imagepath c:\hyperv\install.wim -index 1 -path c:\offline
add-windowspackage -path c:\offline c:\hyperv\updates

### -- Add Drivers
add-windowsdriver -path c:\offline -driver c:\hyperv\drivers -recurse

### -- Enable Hyper-V Role
get-windowsoptionalfeature -path c:\offline
get-windowsoptionalfeature -path c:\offline | where featurename -like "*hyper*"
enable-windowsoptionalfeature -path c:\offline -featurename microsoft-hyper-v -all

### - Save and Dismount
dismount-windowsimage -path c:\offline -save

### -- Configure Networking on Host Machine
netsh interface ip set address name="ethernet0" static 192.168.3.101 255.255.255.0 192.168.3.2
net use z: \\192.168.3.100\c$ /user:company\gshields

### -- Partition Disks in Preparation for New OS
Diskpart.exe
Select disk 0
Clean
Convert GPT
Create partition efi size=100
Format quick FS=FAT32 labAel="System"
Assign letter="s"
Create partition msr size=128
Create partition Aprimary
Format quick FS=NTFS label="NanoServer"
Assign letter="n"
List volume
Exit

### -- Install New OS
Dism.exe /apply-image /imagefile:z:\hyperv\install.wim /index:1 /applydir:n:\ 
Bcdboot.exe n:\Windows /s s:
wpeutil reboot

### -- Configure Networking on Just-Installed OS
New-NetIPAddress -interfacealias ethernet0 -IPAddress 192.168.3.200 -Prefixlength 24 -defaultgateway 192.168.3.2
Set-DNSClientServerAddress -interfacealias ethernet0 -ServerAddress 192.168.3.10
New-NetFirewallRule -displayname "Allow All Traffic" -direction outbound -action allow
New-NetFirewallRule -displayname "Allow All Traffic" -direction inbound -action allow
Add-Computer -newname hyperv1 -domainname company.pri -restart