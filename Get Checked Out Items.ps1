# Script that reports checked out files in a portal
# There may be duplicates in the report since there may be more than one references to an item

# Configuration variables
$URL  =  "http://XXXXXXXXXXXXX" # URL of the portal




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

$spWeb  =  Get-SPWeb $URL -ErrorAction Continue

function GetCheckedItems($spWeb)
{
    if($spWeb -eq $null){
        Write-Error "No web found"
        return
    }
    
	Write-Output "Scanning Site: $($spWeb.Url)"
	foreach ($list in ($spWeb.Lists | ? {$_ -is [Microsoft.SharePoint.SPDocumentLibrary]})) {
		Write-Output "Scanning List: $($list.RootFolder.ServerRelativeUrl)"
		foreach ($item in $list.CheckedOutFiles) {
			if (!$item.Url.EndsWith(".aspx")) { continue }
			$writeTable  =  @{
				"URL" = $spWeb.Site.MakeFullUrl("$($spWeb.ServerRelativeUrl.TrimEnd('/'))/$($item.Url)");
				"Checked Out By" = $item.CheckedOutBy;
				"Author" = $item.File.CheckedOutByUser.Name;
				"Checked Out Since" = $item.CheckedOutDate.ToString();
				"File Size (KB)" = $item.File.Length/1000;
				"Email" = $item.File.CheckedOutByUser.Email;
			}
			New-Object PSObject -Property $writeTable
		}
		foreach ($item in $list.Items) {
			if ($item.File.CheckOutStatus -ne "None") {
				if (($list.CheckedOutFiles | where {$_.ListItemId -eq $item.ID}) -ne $null) { continue }
				$writeTable  =  @{
					"URL" = $spWeb.Site.MakeFullUrl("$($spWeb.ServerRelativeUrl.TrimEnd('/'))/$($item.Url)");
					"Checked Out By" = $item.File.CheckedOutByUser.LoginName;
					"Author" = $item.File.CheckedOutByUser.Name;
					"Checked Out Since" = $item.File.CheckedOutDate.ToString();
					"File Size (KB)" = $item.File.Length/1000;
					"Email" = $item.File.CheckedOutByUser.Email;
				}
				New-Object PSObject -Property $writeTable
			}
		}
	}
	foreach($subWeb in $spWeb.Webs)
	{
		GetCheckedItems($subWeb)
	}
	$spWeb.Dispose()
}

GetCheckedItems($spWeb) | Out-GridView