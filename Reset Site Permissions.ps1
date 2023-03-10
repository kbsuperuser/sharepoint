#Script to check and bereak inheritance of subsites of given site

# Configuration variables
$SiteURL = "http://XXXXXXXXXX"
$AuthorizedUserAccountName = "DomainName\0000-ADMINS" # User or Security Group




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

function Break-Inheritance($url)
{
    $web = Get-SPWeb $url;
    Write-Output "Processing $($web.Title)";
    $web.BreakRoleInheritance($true);
    $account = $web.EnsureUser($AuthorizedUserAccountName);
    $assignment = New-Object Microsoft.SharePoint.SPRoleAssignment($account);
    $role = $web.RoleDefinitions["Full Control"];
    $assignment.RoleDefinitionBindings.Add($role);
    $web.RoleAssignments.Add($assignment);
    $web.Dispose();
}

function Set-Inheritance($url)
{
    $web = Get-SPWeb $url;
    Write-Output "Processing $($web.Title)";
    $web.ResetRoleInheritance();
    $web.Dispose();
}

function Reset-Inheritance($url)
{
    Break-Inheritance($url);
    Set-Inheritance($url);
}

Function Check-Inheritance($url)
{
    $web = Get-SPWeb $url;
    Write-Output "Processing $($web.Title)";
    $result = $web.HasUniqueRoleAssignments;
    $web.Dispose();
    return $result;
}


Function Get-AllWebs($url)
{
    Get-SPSite $url -Limit All | Get-SPWeb -Limit All | Select Url;
}

Get-AllWebs $SiteURL | Foreach-Object { Check-Inheritance($_.url) } 

#Get-AllWebs "http://xxxxxxxxxxxxxx" | Foreach-Object {
 #    If ( Check-Inheritance($_.url) -eq $true)
  #   {
   #     
    #    Reset-Inheritance($_.url)
    # }
#}