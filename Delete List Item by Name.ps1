# Script that deletes list items by name

# Configuration variables
$SiteURL = "http://XXXXXXXXXXXXX" # Name of the web site
$ListName= "ExDocLib" # Name of the list
$ItemToDelete = "Delete"




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
Else { Write-Output "URL is valid: $($web)";}

$list = $web.Lists[$listName]
If(!($list)) { Write-Output "List not found. Verify URL" -ForegroundColor Red; Break;}
Else { 
    Write-Output "Title      : $($list.Title)" -ForegroundColor Green;
    Write-Output "Description: $($list.Description)" -ForegroundColor Green;
    Write-Output "Item Count : $($list.itemCount)" -ForegroundColor Green;
    }

Foreach($item in $list.Items)
{
    Write-Output $Item.Name;
    If( $Item.Name -like $ItemToDelete) { $Item.Recycle() };
}