#Script to create Object Cache Users

# Configuration variables
$WebURL = "http://XXXXXXXXXX"
$SuperUserAccountName = "SpsSuperUser"
$SuperReaderAccountName = "SpsSuperReader"



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

# Adding Object Cache Super User Accounts
$wa = Get-SPWebApplication -Identity $WebURL
Write-Output "$($wa.DisplayName)"

$wa.Properties["portalsuperuseraccount"] = $SuperUserAccountName
$wa.Properties["portalsuperreaderaccount"] = $SuperReaderAccountName
Write-Output "Users added"
$wa.Update()
$wa.Dispose()

# IIS reset is required for caching
IISRESET