# Script to turn Developer Dashboard on and off in a farm.
# Web application, site collection or site based switch does not exist.




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

$service = [Microsoft.SharePoint.Administration.SPWebService]::ContentService
$ddSettings = $service.DeveloperDashboardSettings

#You can change settingsby uncommenting the line you wat to use and comment the others

#$ddSettings.DisplayLevel = [Microsoft.Sharepoint.Administration.SPDeveloperDashboardLevel]::On # Always on
#$ddSettings.DisplayLevel = [Microsoft.Sharepoint.Administration.SPDeveloperDashboardLevel]::Off
$ddSettings.DisplayLevel = [Microsoft.Sharepoint.Administration.SPDeveloperDashboardLevel]::OnDemand # Open on demand with button on top right

$ddSettings.Update()

Write-Output "Developer Dashboard Display Setting is updated to '$($ddSettings.DisplayLevel)'"