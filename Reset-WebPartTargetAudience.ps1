# Script that resets the Target Audience value of a web part
# It's possible to reset Target Audience value of a list or library through GUI but for web parts it's not.
# It's easy to add through "Edit Properties" but hard to remove. This script is a forceful way.

# Configuration variables
$URL = "http://XXXXXXXXXX" # URL of the portal
$Page = "default.aspx" # The page Webpart belongs to
$WebPartName = "Calendar" # The name of the Webpart whose target audience value will be reset. It's possible to decide after enumerating




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

# Reset the Target Audience value
foreach($WebPart in $WebPartManager.WebParts){
    if($WebPart.Title -eq $WebPartName)
    {
        $WebPart.AuthorizationFilter = ";;;;";
        $WebPartManager.SaveChanges($WebPart)
    }
}



# Finish
[void]$WebPartManager.Dispose
$Web.Close()
$Site.Close()