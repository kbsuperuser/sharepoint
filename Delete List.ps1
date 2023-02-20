#Script that deletes a list in a site

# Configuration variables
$SiteURL = "http://XXXXXXXXXXXXX"
$ListName = "IMPEX Repository"




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


$StartTime = Get-Date -Format o
Write-Output "Backup started at: $StartTime"


$Web = Get-SPWeb $SiteURL;
If(!($Web)) { Write-Output "Website not found. Verify URL" -ForegroundColor Red; Break;}
Else { Write-Output "URL is valid: $($Web)"}

$List = $Web.Lists[$ListName]
If(!($List)) { Write-Output "List not found. Verify URL" -ForegroundColor Red; Break;}
Else { Write-Output "List has $($List.itemCount) items"}

try
{
    $List.AllowDeletion = $true;
    $List.Update();
    $List.Delete();

    Write-Output "List '$Listname' has been deleted succesfully"
}
catch
{
    Write-Output "An error occured. Details are below."
    $Error
}

$StopTime = Get-Date -Format o
Write-Output "Backup finished at: $StopTime"
$ElapsedTime = New-TimeSpan -Start $StartTime -End $StopTime
Write-Output "Elapsed time: $ElapsedTime"