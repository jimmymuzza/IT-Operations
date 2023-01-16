##Configure Static IP and Preferred DNS
# The computers in a failover cluster called nodes typically have a secondary network adapter which will be used for failover cluster communications between the nodes. This interface must be configured with a static IP address and a preferred DNS server.

#Connect to 1st cluster server and set static on both adaptors
netsh interface ip set address name=Ethernet1 static 192.168.0.20 255.255.255.0
netsh interface ip set dns Ethernet1 static 192.168.0.1

netsh interface ip set address name=Ethernet2 static 192.168.1.20 255.255.255.0
netsh interface ip set dns Ethernet2 static 192.168.0.1

#On the next prompt, you will set Hosts vEthernet (Internal Network 1) to use a static IP address.
netsh interface ip set address name=”vEthernet (Internal Network 1)” static 192.168.0.21  255.255.255.0

#To disable Hyper-V internal network interface, type:
# Note: Although not necessarily a requirement, turning off a Hyper-V internal network switch suppress error messages when configuring Failover Clusters on a Hyper-V host.
netsh interface set interface name=”vEthernet (Internal Network 1)” admin=disabled


#Connect to 2nd cluster server and set static on both adaptors
netsh interface ip set address name=Ethernet1 static 192.168.0.40 255.255.255.0
netsh interface ip set dns Ethernet1 static 192.168.0.1

netsh interface ip set address name=Ethernet2 static 192.168.1.40 255.255.255.0
netsh interface ip set dns Ethernet2 static 192.168.0.1

#On the next prompt, you will set Hosts vEthernet (Internal Network 1) to use a static IP address.
netsh interface ip set address name=”vEthernet (Internal Network 1)” static 192.168.0.41  255.255.255.0

#To disable Hyper-V internal network interface, type:
# Note: Although not necessarily a requirement, turning off a Hyper-V internal network switch suppress error messages when configuring Failover Clusters on a Hyper-V host.
netsh interface set interface name=”vEthernet (Internal Network 1)” admin=disabled


## INSTALL iSCSI Server. Skip if connecting to different storage.

# Connect to iSCSI Host
Add-WindowsFeature FS-iSCSITarget-Server -IncludeManagementTools

# Important: If you get the error message indicating that the server is unable to install the feature because Windows is currently performing another servicing operation. You can run the following command in PowerShell to stop any scheduled task. 
Get-ScheduledTask | Where TaskPath -like “*TaskScheduler*” | Stop-ScheduledTask


## Configure iSCSI Server Shared Volumes
# On iSCSI host1 device, the Server Manager Dashboard is open.
# On the left navigation bar, click File and Storage Services > iSCSI
# Add new disk wizard
# Set up Quorum Disk (500mb)
# Create other drives needed

## Connect iSCSI initiator on Hosts to iSCSI Target Storage
# Quick Connect via hostname

## Prepare the Shared Disk Volumes on Cluster Host
# Open Disk management
# Set new disks to online and initialise as GPT
# Create new Quorum and data Volume

## Connect to shared disks on other host.
# Connect via iSCSI initiator
# Computer management
# Set both disks to online. They should already be formatted. Ignore the drive letters.

## Install Failover clustering
#Add role to both cluster nodes
Add-WindowsFeature -Name failover-clustering -IncludeManagementTools

# Validate the Servers for Failover Clustering
# Open Failover cluster manager. Right click top node and select Validate Configuration
# add both servers to the same validation. The result will tell you if you need to make configuration changes.

## Create Failover cluster.
# On one of the hosts use the Create Cluster Wizard
# Enter new ip Addresses to use for administering the cluster
# On the confirmation screen untick "Add all eligible storage to the cluster"

## Add Cluster Disks in Failover Manager
# Expand Storage then click Disks node.
# Right-click Disks node and select Add Disk.


## Configure the Quorum Disk Witness and Cluster Shared Volume
# Right-click CLuster and point to More Actions, then select Configure Cluster Quorum Settings.
# Select the Quorum Witness
# Click on the other Cluster Volume. Go to Add to Cluster Shared Volume

## Move old Virtual Machines to Shared Disk- If setting up new VMs then skip this.
# The virtual machines are currently hosted in the hyper-v host local disk. To ensure that the virtual machines are protected with failover clustering, you must move the virtual machines from the local storage to the Cluster Shared Volume (CSV) drive that you had configured earlier.
# On the Hyper-V Manager window, right-click VM and select Move
# To add Servers to high availability, Select new role> viryual machine and click on VM
# All of these VMs come under one service name. Rename to avoid confusion.

## Configure Failover and Failback Settings
# Right click on VMs and go to properties
