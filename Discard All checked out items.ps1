# Script that reports checked out files in a site

# Configuration variables
$URL  =  "http://XXXXXXXXXXXXX" # URL of the site




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

$WebApp =  Get-SPWeb $URL
If(!($WebApp)) { Write-Output "Website not found. Verify URL" -ForegroundColor Red; Break;}
Else { Write-Output "URL is valid: $($WebApp)"}

function UndoCheckedOutItems($WebApp)
{
  Write-Output "Scanning Site: $($WebApp.Url)"
  # Checking files in all Document Library items
  foreach ($list in ($WebApp.Lists | ? {$_ -is [Microsoft.SharePoint.SPDocumentLibrary]})) {
    Write-Output "Scanning List: $($list.RootFolder.ServerRelativeUrl)"
    foreach ($item in $list.CheckedOutFiles) {
      if (!$item.Url.EndsWith(".aspx")) { continue }
      $writeTable  =  @{
        "URL" = $WebApp.Site.MakeFullUrl("$($WebApp.ServerRelativeUrl.TrimEnd('/'))/$($item.Url)");
        "Checked Out By" = $item.CheckedOutBy;
        "Author" = $item.File.CheckedOutByUser.Name;
        "Checked Out Since" = $item.CheckedOutDate.ToString();
        "File Size (KB)" = $item.File.Length/1000;
        "Email" = $item.File.CheckedOutByUser.Email;
      }
          $file = $item.File;
          $file.ReleaseLock($file.LockId);
          try
          {
              $file.UndoCheckOut();
          }
          catch
          {
              $file.CheckIn("Force check in for removal"); #If it's not possible to discard checkout
          }
          
          $file.Update();
      
      New-Object PSObject -Property $writeTable
    }
    # Checking files in all list items
    foreach ($item in $list.Items) {
      if ($item.File.CheckOutStatus -ne "None") {
        if (($list.CheckedOutFiles | where {$_.ListItemId -eq $item.ID}) -ne $null) { continue }
        $writeTable  =  @{
          "URL" = $WebApp.Site.MakeFullUrl("$($WebApp.ServerRelativeUrl.TrimEnd('/'))/$($item.Url)");
          "Checked Out By" = $item.File.CheckedOutByUser.LoginName;
          "Author" = $item.File.CheckedOutByUser.Name;
          "Checked Out Since" = $item.File.CheckedOutDate.ToString();
          "File Size (KB)" = $item.File.Length/1000;
          "Email" = $item.File.CheckedOutByUser.Email;
        }
        
          $file = $item.File;
          $file.ReleaseLock($file.LockId);
          try
          {
              $file.UndoCheckOut();
          }
          catch
          {
              $file.CheckIn("Force check in for removal"); #If it's not possible to discard checkout
          }
          
          $file.Update();
      
        New-Object PSObject -Property $writeTable
      }
    }
  }
  foreach($subWeb in $WebApp.Webs)
  {
    UndoCheckedOutItems($subWeb)
  }
  $WebApp.Dispose()
}

UndoCheckedOutItems($WebApp)