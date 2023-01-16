#Show what disabled users still show up in GAL
Get-ADUser -Filter {(enabled -eq "false") -and (msExchHideFromAddressLists -notlike "*")} -SearchBase "OU=Disabled Users,OU=,DC=,DC=" -Properties enabled,msExchHideFromAddressLists

# Change disabled users to hide from GAL
 Get-ADUser `
 -Filter {(enabled -eq "false") -and (msExchHideFromAddressLists -notlike "*")} `
 -SearchBase "OU=Disabled Users,OU=,DC=,DC="`
 -Properties msExchHideFromAddressLists | `
 Set-ADUser -Add @{msExchHideFromAddressLists="TRUE"}
