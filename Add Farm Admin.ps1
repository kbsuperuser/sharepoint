Function New-FarmAdmin ([string]$Identity,[switch]$IncludeAllContentDatabases)
{
   $CentralAdminWebApp = Get-SPWebApplication –IncludeCentralAdministration | ? {$_.DisplayName –like "SharePoint Central Administration*"}
   New-SPUser –UserAlias $Identity –Web $CentralAdminWebApp.URL –Group "Farm Administrators"
   $CentralAdminContentDB = Get-SPContentDatabase –WebApplication $CentralAdminWebApp
   Add-SPShellAdmin -Database $CentralAdminContentDB -Username $Identity
   If ($IncludeAllContentDatabases)
   { 
      $ContentDatabases = Get-SPContentDatabase
      Foreach ($Database in $ContentDatabases) 
      {
         Add-SPShellAdmin -Database $Database -Username $Identity
      }
   }
}

New-FarmAdmin -Identity "domainname\BackupExecService" -IncludeAllContentDatabases