# You can import a web site or a list that you have exported from another site

# Configuration variables
$URL = "http://XXXXXXXXXX"
$BackupPath = "D:\Sharepoint Backup\test.bak"




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

$Web = Get-SPWeb $URL 
Write-Output "Restore for $ItemURL"
Write-Output "Restore started at $(Get-Date)"
$Web | Import-SPWeb -Path $BackupPath -UpdateVersions Overwrite -Force -Verbose
Write-Output "Restore finished at $(Get-Date)"