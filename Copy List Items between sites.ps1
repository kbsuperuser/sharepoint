# Script to copy list items iteratively between lists on different sites on the same server

# Configuration variables
$SourceURL = "http://XXXXXXXXXXXXX"
$TargetURL = "http://XXXXXXXXXXXXX"
$SourceListName = "Phone Directory"
$TargetListName = "Phone Directory"




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

# Get objects
$SourceWeb = Get-SPWeb $SourceURL
If(!($SourceWeb)) { Write-Output "Website not found. Verify URL" -ForegroundColor Red; Break;}
Else { Write-Output "URL is valid: $($SourceWeb)"}

$TargetWeb = Get-SPWeb $TargetURL
If(!($TargetWeb)) { Write-Output "Website not found. Verify URL" -ForegroundColor Red; Break;}
Else { Write-Output "URL is valid: $($TargetWeb)"}

$SourceList = $SourceWeb.Lists[$SourceListName]
If(!($SourceList)) { Write-Output "List not found. Verify URL" -ForegroundColor Red; Break;}
Else { Write-Output "List has $($SourceList.itemCount) items"}

$TargetList = $TargetWeb.Lists[$TargetListName]
If(!($TargetList)) { Write-Output "List not found. Verify URL" -ForegroundColor Red; Break;}
Else { Write-Output "List has $($TargetList.itemCount) items"}

# Get all source items
$SourceColumns = $SourceList.Fields
$SourceItems = $SourceList.GetItems();

# Iterate through each item and add to target target
Foreach($SourceItem in $SourceItems)
{
    $TargetItem = $TargetList.AddItem()
    Foreach($column in $SourceColumns)
    {
        If($column.ReadOnlyField -eq $false -and $column.InternalName -ne "Attachments")
        {
            $TargetItem[$($column.InternalName)] = $SourceItem[$($column.InternalName)]
        }
    }
    $TargetItem.Update();
    
    # Copy attachments
    If ($SourceItem.Attachments -eq $null) { continue;}
    Foreach($Attachment in $SourceItem.Attachments)
    {
        $SpFile = $SourceList.ParentWeb.GetFile($SourceItem.Attachments.UrlPrefix + $Attachment)
        $TargetItem.Attachments.Add($Attachment, $SpFile.OpenBinary())
    }
}