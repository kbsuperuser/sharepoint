# You can import a web site by specifying item's URL

# Configuration variables
$SiteURL = "http://XXXXXXXXXX"
$BackupPath = "D:\Sharepoint Backup\xxxxx.bak"




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

$StartTime = Get-Date -Format o
Write-Output "Restore started at: $StartTime"
Import-SPWeb -Identity $SiteURL -Path $BackupPath -UpdateVersions Overwrite
$StopTime = Get-Date -Format o
Write-Output "Restore finished at: $StopTime"
$ElapsedTime = New-TimeSpan -Start $StartTime -End $StopTime
Write-Output "Elapsed time: $ElapsedTime"

# Backup Size
$File = Get-Item -LiteralPath $BackupPath
$SizeAsKB = $File.Length /1KB
$SizeAsMB = $File.Length /1MB
$SizeAsGB = $File.Length /1GB
$Size = ""
If($SizeAsGB -ge 1){ $Size = "$SizeAsGB GB" }
ElseIf($SizeAsMB -ge 1){ $Size = "$SizeAsMB MB"}
Else{ $Size = "$SizeAsKB KB"}
Write-Output "Backup File Size: $Size"