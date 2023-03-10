# You can export a web site or a list by specifying item's URL

# Configuration variables
$URL = "http://XXXXXXXXXX"
$BackupPath = "\\backupserver\Transfer\CalendarBackup.cmp"
$ItemURL = "/Lists/Calendar"




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
Write-Output "Backup for $ItemURL"
Write-Output "Backup started at $(Get-Date)"
$Web | Export-SPWeb -Path $BackupPath -ItemUrl $ItemURL -Verbose
Write-Output "Backup finished at $(Get-Date)"