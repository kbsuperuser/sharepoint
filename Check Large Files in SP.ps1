# Script to check files with sizes above a threshold on defined website

# Configuration variables
$SiteURL = "http://XXXXXXXXXXXXX/"
$Threshold = 50 # Size in MB




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


Start-SPAssignment -Global

$Site = Get-SPSite $SiteURL
$WebApp = $Site.WebApplication
If(!($WebApp)) { Write-Output "Website not found. Verify URL" -ForegroundColor Red; Break;}
Else { Write-Output "URL is valid: $($WebApp)"}

Write-Output "------Checking the SP web app for large files------"

# Enumerate though all site collections, sites, sub sites and document libraries in a SP web app
if($WebApp -ne $null)
{
  foreach ($siteColl in $WebApp.Sites)
  {
    foreach($subWeb in $siteColl.AllWebs)
    {
     foreach($List in $subWeb.Lists)
     {
      if($List.BaseType -eq "DocumentLibrary")
      { 
      $ItemsColl = $List.Items
        foreach ($item in $ItemsColl) 
        {    
         $itemSize = (($item.File.Length)/1024)/1024
         if($itemSize -Ge $Threshold)
         {
           $itemUrl = $item.Web.Url + "/" + $item.Url;
           Write-Output $itemUrl ", File size:: " $('{0:N2}' -f $itemSize) MB -ForegroundColor Green
          }
        }                    
      }
    }     
  }
 }
}
Write-Output "---------DONE---------"
Stop-SPAssignment -Global