# Flush Blob Cache of web application

# Configuration variables
$WebAppName = "XXXXXX"



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

$WebApp = Get-SPWebApplication -Identity $WebAppName
Write-Output "$($WebApp.DisplayName)"

[Microsoft.SharePoint.Publishing.PublishingCache]::FlushBlobCache($WebApp)
Write-Output "Flushed"