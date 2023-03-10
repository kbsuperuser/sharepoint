#Script that deletes items in a list, limited by threshold defined in Sharepoint

# Configuration variables
$WebURL = "http://XXXXXXXXXXXXX"
$ListName = "Last Added Items"
$Threshold = 5000
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

$DeleteBeforeDate = [Microsoft.SharePoint.Utilities.SPUtility]::CreateISO8601DateTimeFromSystemDateTime([DateTime]::Now.AddDays(-60))

$web = Get-SPWeb $WebURL;
If(!($web)) { Write-Output "Website not found. Verify URL" -ForegroundColor Red; Break;}
Else { Write-Output "URL is valid: $($web)"}

$list = $web.Lists[$ListName]
If(!($list)) { Write-Output "List not found. Verify URL" -ForegroundColor Red; Break;}
Else { Write-Output "List has $($list.itemCount) items"}

While ($list.ItemCount -ne 0)
{
    Write-Output "Querying started - $(Get-Date -Format o)"
    $query = New-Object Microsoft.Sharepoint.SPQuery;
    $query.RowLimit = $Threshold;
    $caml = '<Where>
                <Lt>
                    <FieldRef Name="Created" />
                    <Value Type="DateTime">{0}</Value>
                </Lt>
            </Where>' -f $DeleteBeforeDate

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
        Write-Output "Deleting started - $(Get-Date -Format o)"
        Foreach($item in $items)
        {
            Write-Output "Deleting item $($item.Id)..."
            If($RecycleFlag -eq $true)
	        {
            	$list.GetItemById($item.ID).Recycle();
	        }
	        Else
	        {
            	$list.GetItemById($item.ID).Delete();
	        }
        }
        Write-Output "Deleting completed - $(Get-Date -Format o)"
        Write-Output "Deleted $Threshold items"
    }   
}

$web.Dispose();