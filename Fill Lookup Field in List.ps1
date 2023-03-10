# You can backup a site collection by specifying item's URL

# Configuration variables
$WebURL = "http://XXXXXXXXXXXXX"
$ParentListName = "Services" #Lookup Parent List
$ChildListName = "Peacetime Establishment" #List to add new lookup value
$ParentListLookupField = "Abbreviation"
$ChildListLookupField = "Serv"
$ChildListReferenceField = "Service"




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

$Web = Get-SPWeb $WebURL
If(!($Web)) { Write-Output "Website not found. Verify URL" -ForegroundColor Red; Break;}
Else { Write-Output "URL is valid: $($Web)"}

$ParentList = $Web.Lists.tryGetList($ParentListName);
If(!($ParentList)) { Write-Output "List not found. Verify URL" -ForegroundColor Red; Break;}
Else { Write-Output "List $ParentListName has $($ParentList.itemCount) items"}

$ChildList = $Web.Lists.tryGetList($ChildListName);
If(!($ChildList)) { Write-Output "List not found. Verify URL" -ForegroundColor Red; Break;}
Else { Write-Output "List $ChildListName has $($ChildList.itemCount) items"}

foreach($Item in $ChildList.Items)
{
    $LookupItem = $ParentList.Items | Where-Object { $_[$ParentListLookupField] -eq $Item[$ChildListReferenceField]}
    
    $Item[$ChildListLookupField] = $LookupItem.ID
    $Item.Update();
}

$StopTime = Get-Date -Format o
Write-Output "Process finished at: $StopTime"
$ElapsedTime = New-TimeSpan -Start $StartTime -End $StopTime
Write-Output "Elapsed time: $ElapsedTime"