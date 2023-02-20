#Script that deletes a site (NOT A SITE COLLECTION)

# Configuration variables
$SiteURL = "http://XXXXXXXXXXXXX"




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
Write-Output "Process started at: $StartTime"


$Web = Get-SPWeb $SiteURL;
If(!($Web)) { Write-Output "Website not found. Verify URL" -ForegroundColor Red; Break;}
Else { Write-Output "URL is valid: $($Web)"}

try
{
    Remove-SPWeb -Identity $SiteURL -Confirm:$false

    Write-Output "Site '$Web' has been deleted succesfully"
}
catch
{
    Write-Output "An error occured. Details are below."
    $Error
}

$StopTime = Get-Date -Format o
Write-Output "Process finished at: $StopTime"
$ElapsedTime = New-TimeSpan -Start $StartTime -End $StopTime
Write-Output "Elapsed time: $ElapsedTime"