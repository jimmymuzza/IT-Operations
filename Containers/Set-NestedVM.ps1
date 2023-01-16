<#

Author: Mike Pfeiffer

Sample script for setting up nested virtualization on a Hyper-V VM

Disclaimers

This example code is provided without copyright and AS IS.  It is free for you to use and modify.
Note: These demos should not be run as a script. These are the commands that I use in the 
demonstrations and would need to be modified for your environment.

#>

#Replace with the virtual machine name
$vm = "<virtual-machine>"

#Configure virtual processor
Set-VMProcessor -VMName $vm -ExposeVirtualizationExtensions $true -Count 2

#Disable dynamic memory
Set-VMMemory $vm -DynamicMemoryEnabled $false

#Enable mac spoofing
Get-VMNetworkAdapter -VMName $vm | Set-VMNetworkAdapter -MacAddressSpoofing On

Start-VM $vm 
