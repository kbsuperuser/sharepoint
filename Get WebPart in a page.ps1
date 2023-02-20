# Script that lists the web parts in a page

# Configuration variables
$URL = "http://XXXXXXXXXX/" # URL of the portal
$Page = "SitePages/homepage.aspx" # The page Webpart belongs to,


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

# Initialize
$Site = New-Object Microsoft.SharePoint.SPSite($URL)
$Web = $Site.OpenWeb()
$WebPartManager = $Web.GetLimitedWebPartManager($Page,[System.Web.UI.WebControls.WebParts.PersonalizationScope]::Shared)

# Enumerate Webparts
foreach($WebPart in $WebPartManager.WebParts)
{
    $WebPart.Title
}

# Finish
[void]$WebPartManager.Dispose
$Web.Close()
$Site.Close()