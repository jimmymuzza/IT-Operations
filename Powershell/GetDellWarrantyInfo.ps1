##.\Get-DellWarranty1.2.ps1 -ServiceTag '7lncw4j' -ApiKey "sdfj7122394057sdfiouwer" -Dev $true

Function Get-DellWarranty
{ 
 
<# 
    .SYNOPSIS 
 
    Submits service tags to Dell's online database as sinlge queries or in groups. Returns a table of warranty entitlements for the specified tags. 
 
    .DESCRIPTION 
 
    Using Dell's online server supporting the REST API, this function can submit service tags and collect warranty entitlement information which will then be returned as a table. 
 
    .PARAMETER ServiceTag 
 
    Accepts a single Service Tag, comma separated list of tags, an array of tags from the pipeline, or pipeline input by property name. 
 
    .PARAMETER ApiKey 
 
    Accepts a string value for the API key. Defaults to the API key specified in the quotes. Add your here. 
 
    .PARAMETER Dev 
 
    Switched parameter that specifies whether the function should use Dell sandbox server. Recommended for testing with other functions. Defaults to Production server. 
 
    .PARAMETER TagLimit 
 
    Specifies the maximum number of tags that should be submitted per query. Defaults to 25. 
     
    .EXAMPLE 
 
    Get-DellWarranty "AABBCC1" 
     
    Lists all entitlement types for the Service Tag "AABBCC1". 
 
    .EXAMPLE  
     
    Get-SCCMComputer -ComputerModel "Latitude 7250" | Get-DellWarranty 
 
    Sends output of Get-SCCMComputer down the pipeline to Get-DellWarranty and returns entitlements that match the specified Service Tags. Get-SCCMComputer can be found in the gallery, but any cmdlet, function, table that contains a list of serial numbers can be used to pipe input. 
 
    .INPUTS 
         
    .OUTPUTS 
         
    .NOTES 
 
    ===========================================================================================   
     Created On:    09/09/2016 
     Updated On:    06/09/2017 
     Created By:    Natascia Heil,Aaron Bauer 
     Organization:  SJM/Abbott 
     FileName:      Get-DellWarranty.ps1 
     Revision No:   1.4  
     Modifications: 1.0: Downloaded from https://gallery.technet.microsoft.com/scriptcenter/PowerShell-Script-Get-Dell-d7fd6367 
                    1.1: Changed some of the paramater options.  
                         Created a array internally to store all the returned properties and organize them in a table for return as an object. 
                         Included logic to handle NIL returns 
                         Included column in the table for including the date the script was run (extract date) 
                    1.2: Updated parameter options to cast as an array to accept data from the pipeline. 
                         Doing a join internally for submitting multiple tags to Dell as a comma separated list 
                         Included variable to set max number of tags accepted and logic to respect that 
                    1.3: Modified pipeline support; added aliases for the ServiceTag property, and Verbose messaging. Changed input casting to a string instead of an array. 
                         Rearranged some of the logic to support Begin,Process,End. Added TagLimit paramter 
                         which defaults to 25. 
                    1.4: Added comment based help. 
 
    ===========================================================================================   
#> 
 
    [CmdletBinding()] 
    Param(   
        [Parameter(ValueFromPipelineByPropertyName=$true,ValueFromPipeline=$true, Mandatory=$true)]      
        [Alias("Serial","SerialNumber")] 
        [String]$ServiceTag 
        , 
          
        [Parameter(Mandatory=$false)]   
        [String]$ApiKey = 'YOUR-KEY-HERE' 
        , 
          
        [Parameter(Mandatory=$false)]   
        [Switch]$Dev 
        , 
 
        [Parameter(Mandatory=$False)] 
        [INT]$TagLimit = 25 
 
    )#Param 
 
    Begin #Setup variables and define functions 
    {    
        $Script:Table = New-Object System.Collections.ArrayList #Create new array for organizing the data in the script scope so that it can be modified in the function 
        $ServiceTags = New-Object System.Collections.ArrayList 
 
        If (($Dev))  
        {  
            $Server = "https://sandbox.api.dell.com/support/assetinfo/v4/getassetwarranty/"       
        }  
        else  
        {  
            $Server = "https://api.dell.com/support/assetinfo/v4/getassetwarranty/"  
        } 
 
        Function Submit-Tags 
        { 
           Param( 
           [String]$Tags 
           , 
           [URI]$URL 
           ) 
 
            #Write-Verbose $url          
  
            # Get Data  
            Try  
            { 
                $Warranty = Invoke-RestMethod -URI $URL -Method GET -ContentType 'Application/xml' 
            } 
            Catch 
            { 
                Write-Error $Error[0] 
                Break 
            } 
     
            $Global:Get_DellWarrantyXML = $Warranty  
     
            foreach ($Asset in $Warranty.AssetWarrantyDTO.AssetWarrantyResponse.AssetWarrantyResponse) 
            { 
                Foreach ($Entitlement in $Asset.assetentitlementdata.assetentitlement | Where-Object ServiceLevelDescription -NE 'Dell Digitial Delivery') 
                { 
                    $row = New-Object PSObject 
                    $row | Add-Member -Name "Serial" -MemberType NoteProperty -Value $Asset.assetheaderdata.ServiceTag 
                    $row | Add-Member -Name "Model" -MemberType NoteProperty -Value $Asset.productheaderdata.SystemDescription 
                    $row | Add-Member -Name "ItemNumber" -MemberType NoteProperty -Value $entitlement.ItemNumber 
                    $row | Add-Member -Name "EntitlementType" -MemberType NoteProperty -Value $entitlement.EntitlementType 
 
                    if ($entitlement.ServiceLevelCode.nil)#Look for Nulls in the XML 
                        {$row | Add-Member -Name "ServiceLevelCode" -MemberType NoteProperty -Value $NULL} 
                        else 
                        {$row | Add-Member -Name "ServiceLevelCode" -MemberType NoteProperty -Value $entitlement.ServiceLevelCode} 
 
                    if ($entitlement.ServiceLevelDescription.nil)#Look for Nulls in the XML 
                        {$row | Add-Member -Name "ServiceLevelDescription" -MemberType NoteProperty -Value $NULL} 
                        else 
                        {$row | Add-Member -Name "ServiceLevelDescription" -MemberType NoteProperty -Value $entitlement.ServiceLevelDescription} 
 
                    $row | Add-Member -Name "ServiceLevelGroup" -MemberType NoteProperty -Value $entitlement.ServiceLevelGroup 
 
                    if ($entitlement.ServiceProvider.nil)#Look for Nulls in the XML 
                        {$row | Add-Member -Name "ServiceProvider" -MemberType NoteProperty -Value $NULL} 
                        else 
                        {$row | Add-Member -Name "ServiceProvider" -MemberType NoteProperty -Value ($entitlement.ServiceProvider)} 
 
                    $row | Add-Member -Name "StartDate" -MemberType NoteProperty -Value $entitlement.StartDate 
                    $row | Add-Member -Name "EndDate" -MemberType NoteProperty -Value $entitlement.EndDate 
                    $row | Add-Member -Name "ExtractDate" -MemberType NoteProperty -Value (Get-Date -format yyyy-MM-ddTHH:mm:ss)     
 
                    $null = $Table.Add($row) #Add the row 
                } 
            } 
        }#Submit-Tags 
 
    } 
 
    Process #Process each object in the pipeline; uses a foreach style approach 
    { 
        $Null = $ServiceTags.Add($ServiceTag) #Take pipeline input and create a table to process 
    } 
     
    End #Final steps. Take the table that was created in the Process block, break it up into $TagLimit chunks, join with a comma, then submit to Dell. Repeat till finished. 
    { 
        Write-Verbose "$($ServiceTags.Count) tags to process." 
 
        If ($ServiceTags.Count -gt $TagLimit) 
        { 
            Write-Verbose "Service tag list exceeded maximum of $TagLimit and will be broken up into $([math]::Ceiling($ServiceTags.Count / $TagLimit)) groups for submission to Dell." 
        } 
 
        $Count = 0 
        $GroupCount = 0 
 
        While ($Count -lt $ServiceTags.Count) 
        { 
            $GroupCount ++ 
 
            If ($ServiceTags.Count -gt $TagLimit) 
            { 
                 Write-Verbose "Submitting group $GroupCount of $([math]::Ceiling($ServiceTags.Count / $TagLimit))." 
            } 
 
            $SubmitTags = $ServiceTags[$Count..($Count + $TagLimit)] -join "," 
 
            #Write-Verbose "Submitting tags $($ServiceTags.Count - ($ServiceTags.Count - $Count)) through $Count."             
 
            $URI = $Server + $SubmitTags + "?apikey=" + $Apikey 
            Submit-Tags -Tags $ServiceTags -URL $URI 
            $Count += $TagLimit              
        } 
 
        Return $Table 
    } 
}#Function
