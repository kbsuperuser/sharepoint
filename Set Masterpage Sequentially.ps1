# Script to set master pages of sites by iterating
# Works on farm level

# Configuration variables
$MasterPageName = "MASTER-v2.master"



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

Function Get-AllWebs()
{
    Get-SPSite -Limit All | Get-SPWeb -Limit All
}

Function Set-MasterPage($site)
{
    Write-Host "processing $($site.Url)" -Foregroundcolor Blue
            $site.CustomMasterUrl = "/_catalogs/masterpage/$MasterPageName"
            $site.MasterUrl = "/_catalogs/masterpage/$MasterPageName"
            $site.Update()
}

Get-AllWebs | Foreach-Object { Set-MasterPage($_) }