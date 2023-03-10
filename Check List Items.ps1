# Script that displays title, description and count of items of the list specified

# Configuration variables
$SiteURL = "http://XXXXXXXXXXXXX" # Name of the web site
$ListName = "Statistics" # Name of the list



### DO NOT TOUCH THE CODE BELOW ###



# Required if not run in SharePoint Management Shell
if($ver.Version.Major -gt 1)
{
	$Host.Runspace.ThreadOptions = "ReuseThread"
}
If((Get-PSSnapin -Name Microsoft.Sharepoint.Powershell -ErrorAction SilentlyContinue) -eq $null)
{
	Add-PSSnapin Microsoft.Sharepoint.Powershell
}

$web = Get-SPWeb $SiteURL;
If(!($web)) { Write-Output "Website not found. Verify URL" -ForegroundColor Red; Break;}
Else { Write-Output "URL is valid: $($web)"}

$list = $web.Lists[$ListName]
If(!($list)) { Write-Output "List not found. Verify URL" -ForegroundColor Red; Break;}
Else { 
    Write-Output "Title      : $($list.Title)" -ForegroundColor Green
    Write-Output "Description: $($list.Description)" -ForegroundColor Green
    Write-Output "Item Count : $($list.itemCount)" -ForegroundColor Green
    }
