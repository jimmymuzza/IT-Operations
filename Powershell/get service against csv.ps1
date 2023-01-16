$a = Get-Content "C:\<CSV LOCATION>"
[array]$Details=$null
foreach ($computer in $a) {$details += Get-Service *mcafee* -computername $Computer} 
$details | select * | Export-CSV "C:\mcafeeservice1.csv" -nti
