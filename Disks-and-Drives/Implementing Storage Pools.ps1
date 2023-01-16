## Examine the disk configuration and create a storage Pool
# Server Manager automatically opens.
# Click Tools and select Computer Management.
# In Computer Management, click on Storage and then click on Disk Management node.
# The available disks are displayed.


## Create a Storage Pool
# Go back on the Server Manager console.
# On left navigation pane, click File and Storage Services.
# On the STORAGE POOLS section, locate Windows Storage (1), right-click Primordial, and select New Storage Pool…
# On the Select physical disks for the storage pool page, select the Slot check box. Notice that all the disks listed are selected automatically.
# Then on each of the disks, change Alllocation type as indicated below:
# Msft Virtual disk (PLABDM01): Allocation - Automatic
# Msft Virtual disk (PLABDM01): Allocation - Automatic
# Msft Virtual disk (PLABDM01): Allocation - Automatic
# Virtual HD (PLABDM01): Allocation - Hot Spare


## Create Parity VHD
# On the Select the storage pool window, select your storage pool and click OK.
# On the Specify enclosure resiliency page, keep the default settings. Click next and go through create parity VHD Wizard.


## Create Mirror VHD
# On the Windows PowerShell window, to create a virtual hard disk with a Mirror layout:
New-Volume -StoragePoolFriendlyName “PLABDM01-SP1” -FriendlyName “Mirror1” -Size 6GB -ResiliencySettingName “Mirror” -FileSystem NTFS -AccessPath “M:” -ProvisioningType Thin

## Create Simple VHD
New-Volume -StoragePoolFriendlyName “PLABDM01-SP1” -FriendlyName “Simple1” -Size 2GB -ResiliencySettingName “Simple” -FileSystem NTFS -AccessPath “S:” -ProvisioningType Thin
