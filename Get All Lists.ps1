param
(
	[string] $URL = "http://XXXXXXXXXXXXX",
	[boolean] $WriteToFile = $true
)
 
#Get all lists in farm
Add-PSSnapin Microsoft.SharePoint.PowerShell -ErrorAction SilentlyContinue
 
#Counter variables
$webcount = 0
$listcount = 0
 
if($WriteToFile -eq $true)
{
	$outputPath = Read-Host "Outputpath (e.g. C:directoryfilename.txt)"
}
	if(!$URL)
{
	#Grab all webs
	$webs = (Get-SPSite -limit all | Get-SPWeb -Limit all -ErrorAction SilentlyContinue)
}
else
{
	$webs = Get-SPWeb $URL
}
if($webs.count -ge 1 -OR $webs.count -eq $null)
{
	foreach($web in $webs)
	{
		#Grab all lists in the current web
		$lists = $web.Lists
		Write-Host "Website"$web.url -ForegroundColor Green
		if($WriteToFile -eq $true){Add-Content -Path $outputPath -Value "Website $($web.url)"}
        	$result = $lists | Sort-Object -Property BaseType | Select-Object -Property Title, BaseType, ItemCount, LastItemModifiedDate

        	$result  | Format-Table
		
		if($WriteToFile -eq $true){
			$result  | Export-Csv -Path $outputPath -Force -NoTypeInformation -ErrorAction SilentlyContinue
		}

		$webcount +=1
		$web.Dispose()
	}
	Show total counter for checked webs & lists
	Write-Host "Amount of webs checked:"$webcount
	Write-Host "Amount of lists:"$result.Count
}
else
{
	Write-Host "No webs retrieved, please check your permissions" -ForegroundColor Red -BackgroundColor Black
}