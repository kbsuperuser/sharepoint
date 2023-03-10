# Script that approves an item (Draft to pending etc.)

# Configuration variables
$URL = "http://XXXXXXXXXXXXX" # URL of the web site
$ItemPath = "_catalogs/masterpage/vxxx.master" # Path of item



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

$web = Get-SPWeb $URL
$file = $web.GetFile($ItemPath)

$file.Checkin("")
$file.Publish("")
$file.Approve("")
$file.Update()