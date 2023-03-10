# Script to copy list items iteratively between lists on a site

# Configuration variables
$WebURL = "http://XXXXXXXXXXXXX"
$SourceListName = "REQUEST FOR INFORMATION 2019"
$TargetListName = "REQUEST FOR INFORMATION"



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
$Web = Get-SPWeb $WebURL
$SourceList = $Web.Lists[$SourceListName]
$TargetList = $Web.Lists[$TargetListName]

# Get all source items
$SourceColumns = $SourceList.Fields
$SourceItems = $SourceList.GetItems();

$StartTime = Get-Date -Format o
Write-Output "Process started at: $StartTime"

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

$StopTime = Get-Date -Format o
Write-Output "Process finished at: $StopTime"
$ElapsedTime = New-TimeSpan -Start $StartTime -End $StopTime
Write-Output "Elapsed time: $ElapsedTime"