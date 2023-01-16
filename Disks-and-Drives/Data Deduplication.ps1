Add-WindowsFeature FS-Data-Deduplication -IncludeManagementTools

# Verify the Status of Data Deduplication
Get-DedupVolume
Get-DedupStatus

# Set up deduplication.
# Servermanager> Disks> Right click on disk.

#to test how mucj space would be saved: ddpeval cmdline eval tool.
dpeval e: /v

#To start the data deduplication job on Drive D and allocating 50 percent of the system memory, type the following command:
Start-Dedupjob D: -Type Optimization -Memory 50
# Check on status
Get-DedupJob
# Get Drive Dedup status
Get-DedupStatus -Volume D: | format-list

# Find out how much space is saved
Get-DedupVolume -Volume D: | Format-List
