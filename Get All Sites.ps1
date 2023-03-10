# Script to list all sites on a farm
# Lists deleted if specified.

# Configuration variables
$ListDeleted = $true



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
Write-Output "All existing sites"
Get-SPSite

If($ListDeleted -eq $true)
{
	Write-Output
	Write-Output "All deleted sites"
	Get-SPDeletedSite
}