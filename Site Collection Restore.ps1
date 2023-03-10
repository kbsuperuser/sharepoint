# You can restore a site collection by specifying item's URL

# Configuration variables
$SiteURL = "http://XXXXXXXXXX"
$BackupPath = "xxxxx.bak"




### DO NOT TOUCH THE CODE BELOW ###


$ErrorActionPreference = 'SilentlyContinue'

# Required if not run in SharePoint Management Shell
if($ver.Version.Major -gt 1)
{
	$Host.Runspace.ThreadOptions = "ReuseThread"
}
If((Get-PSSnapin -Name Microsoft.Sharepoint.Powershell) -eq $null)
{
	Add-PSSnapin Microsoft.Sharepoint.Powershell -ErrorAction Stop
}

# Validate parameters
$Site = Get-SPSite $SiteURL -ErrorAction Stop
if($null -eq $Site ) { Write-Error "No SharePoint site found at url: $SiteURL"; exit; }

$BackupFile = Get-Item $BackupPath -ErrorAction Stop
if($null -eq $BackupFile) { Write-Error "Cannot fine backup file at $BackupPath."; exit; }

# Check size
$File = Get-Item -LiteralPath $BackupFile.FullName
$SizeAsKB = $File.Length /1KB
$SizeAsMB = $File.Length /1MB
$SizeAsGB = $File.Length /1GB
$Size = ""
If($SizeAsGB -ge 1){ $Size = "$SizeAsGB GB" }
ElseIf($SizeAsMB -ge 1){ $Size = "$SizeAsMB MB" }
Else{ $Size = "$SizeAsKB KB" }
Write-Output "Backup File Size: $Size"

# Start restore
$StartTime = Get-Date -Format o
Write-Output "Restore started at: $StartTime"
Restore-SPSite -Identity $Site.URL -Path $BackupFile.FullName -Force -Verbose -Confirm:$false
$StopTime = Get-Date -Format o
Write-Output "Restore finished at: $StopTime"
$ElapsedTime = New-TimeSpan -Start $StartTime -End $StopTime
Write-Output "Elapsed time: $ElapsedTime"