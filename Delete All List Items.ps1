#Script that deletes items in a list, limited by threshold defined in Sharepoint

# Configuration variables
$SiteURL = "http://XXXXXXXXXXXXX"
$ListName= "Last Added Items"
$Threshold= 50000
$RecycleFlag = $false




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

# Get web site
$web = Get-SPWeb $SiteURL;
If(!($web)) { Write-Output "Website not found. Verify URL" -ForegroundColor Red; Break;}
Else { Write-Output "URL is valid: $($web)"}

# Get specified list
$list = $web.Lists[$listName]
If(!($list)) { Write-Output "List not found. Verify URL" -ForegroundColor Red; Break;}
Else { Write-Output "List has $($list.itemCount) items"}
$itemsToDelete = $list.itemCount

# Delete all items according to the threshold
While ($list.ItemCount -ne 0)
{
    Write-Output "Querying started - $(Get-Date -Format o)"
    $query = New-Object Microsoft.Sharepoint.SPQuery;
    $query.RowLimit = $threshold;
    $caml = '<Where>
                <Neq>
                    <FieldRef Name= "ID"/>
                    <Value Type = "Counter">0</Value>
                </Neq>
            </Where>'

    $query.Query = $caml
    $items = $list.GetItems($query)
    
    Write-Output "Querying completed - $(Get-Date -Format o)"
    
    If($items.Count -eq 0)
    {
        Write-Output "List is empty";
        Exit 1;
    }
    Else
    {
        $StartTime = Get-Date -Format o
        Write-Output "Deleting started at: $StartTime"
        Write-Output $itemsLeft
        
        Foreach($item in $items)
        {
            #Write-Output "Deleting item $($item.Id)..."
            If($RecycleFlag -eq $true)
	        {
            	$list.GetItemById($item.ID).Recycle();
	        }
	        Else
	        {
            	$list.GetItemById($item.ID).Delete();
	        }
        }
        
        $StopTime = Get-Date -Format o
        Write-Output "Deleting finished at: $StopTime"
        $ElapsedTime = New-TimeSpan -Start $StartTime -End $StopTime
        Write-Output "Elapsed time: $ElapsedTime"
        Write-Output "Deleted $itemsToDelete items"
    }   
}