# Configuring Disk Volumes with Resilient File System (ReFS)

# Find Offline DIsks
Get-Disk | Where-Object OperationalStatus -EQ “Offline”

# Set Disk to online
Set-Disk -Number 3 -IsOffline $False

Set-Disk -Number 3 -IsReadOnly $false

Get-Disk -Number 3

# Create an ReFS volume by using up all available disk space on Disk number 3
New-Partition -DiskNumber 3 -UseMaximumSize -DriveLetter F | Format-Volume -NewFileSystemLabel “PLABS-Test” -FileSystem ReFS


# Creating a mirrored disk volume
# Disk Management
# Set Disk Online and convert to MBR. This is required to enable the mentioned disk as the mirrored replica of another disk that use the same type of disk.
# Right click on C and Add Mirror

# Create a Virtual Hard Disk
New-VHD -Path c:\engineering.vhd -Dynamic -SizeBytes 5Gb | Mount-VHD -Passthru | Initialize-Disk -Passthru | New-Partition -AssignDriveLetter  -UseMaximumSize | Format-Volume -FileSystem NTFS
# Managing Virtual Hard Disks
Get-VHD c:\engineering.vhd

# To change properties we have to dismount the vhd
Dismount-VHD c:\engineering.vhd

# Convert to VHDX
Convert-VHD -Path c:\engineering.vhd  -DestinationPath c:\engineering.vhdx
# Optimize vhdx
Optimize-VHD -Path c:\engineering.vhdx -Mode Full
# Mount new vhdx
Mount-VHD c:\engineering.vhdx
