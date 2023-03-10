#Script that gets information of a list in a site

# Configuration variables
$SiteURL = "http://XXXXXXXXXX"
$ListName = "IMPEX FORM"




### DO NOT TOUCH THE CODE BELOW ###




# Required if not run in SharePoint Management Shell
function Load-Snapin()
{
    if($ver.Version.Major -gt 1)
    {
	    $Host.Runspace.ThreadOptions = "ReuseThread"
    }
    if($null -eq (Get-PSSnapin -Name Microsoft.Sharepoint.Powershell -ErrorAction Stop))
    {
	    Add-PSSnapin Microsoft.Sharepoint.Powershell
    }
}


function Measure-ScriptBlock([ScriptBlock] $ScriptBlock)
{
    $StartTime = Get-Date -Format o
    Write-Output "Process started at: $StartTime"

    Invoke-Command -ScriptBlock $ScriptBlock -ErrorAction Continue

    $StopTime = Get-Date -Format o
    Write-Output "Process finished at: $StopTime"
    $ElapsedTime = New-TimeSpan -Start $StartTime -End $StopTime
    Write-Output "Elapsed time: $ElapsedTime"
}


function Get-ListInfo([string] $Url, [string] $Name) {
    $Web = Get-SPWeb $Url;
    If(!($Web)) { Write-Error "Website not found. Verify URL"; Break;}
    Else { Write-Output "URL is valid: $($Web)"}

    $List = $Web.Lists[$Name]
    if(!($List)) {
        Write-Error "List not found. Verify URL";
        Break;
    }
    else {
        Write-Output "List has $($List.itemCount) items"
        Write-Output "Enumerating $ListName information"
    }

    try
    {
        $List
    }
    catch
    {
        Write-Output "An error occured. Details are below."
        $Error
    }
}

Load-Snapin
Measure-ScriptBlock {
    Get-ListInfo -Url $SiteURL -Name $ListName
}