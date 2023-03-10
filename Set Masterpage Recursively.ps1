# Script to set master pages of sites by recursive calls
# Works of site level

# Configuration variables
$SiteURL = "http://XXXXXXXXXX"
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

Function GetAllWebs($URL)
{
    $w = get-spweb $url
    
    If($w.Webs.Count -gt 0)
    {
        Foreach($s in $w.Webs)
        {
            Write-Output "processing $($w.URL)" -Foregroundcolor Blue
            $s.CustomMasterUrl = "/_catalogs/masterpage/$MasterPageName"
            $s.MasterUrl = "/_catalogs/masterpage/$MasterPageName"
            $s.Update()
            GetAllWebs($s.URL)    
        }
    }
    $w.Dispose()
}

Function Set-MasterPage($URL)
{
    Write-Output "processing $($w.URL)" -Foregroundcolor Blue
            $s.CustomMasterUrl = "/_catalogs/masterpage/$MasterPageName"
            $s.MasterUrl = "/_catalogs/masterpage/$MasterPageName"
            $s.Update()
}

GetAllWebs($SiteURL)