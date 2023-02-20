# Hide a field of a list in New and Edit Forms.

# Configuration variables
$Url = "http://XXXXXXXXXX";
$ListName = "Clearance";
$FieldName = "Display Name";




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

$Web = Get-SPWeb $Url;
$List = $web.Lists.TryGetList($ListName)
if($List)
{
    $Field = $List.Fields[$FieldName];
    $Field.ShowInNewForm = $false;
    $Field.ShowInEditForm = $false;
    $Field.Update();
}
$Web.Dispose();