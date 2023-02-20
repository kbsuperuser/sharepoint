#Requires -RunAsAdministrator

<#
.Synopsis
   Connect to a SharePoint Server remotely
.DESCRIPTION
   Uses PSRemoting & WSMan to connect to a SharePoint server, and enters into a PowerShell session
.EXAMPLE
   Connect-SPServer -Server "xxxxxxxx"
#>
function Connect-SPServer
{
    [CmdletBinding()]
    Param
    (
        # SharePoint Server
        [Parameter(Mandatory=$true,
                   ValueFromPipelineByPropertyName=$true,
                   Position=0)]
        $Server
    )
    Process
    {
        $wsman = Get-WSManCredSSP
        if($null -eq $wsman -or $wsman.Count -eq 0)
        {
            Enable-WSManCredSSP -Role Client -DelegateComputer *
        }

        $creds = Get-Credential

        try
        {
            $session = New-PSSession -Authentication Credssp -ComputerName $Server -Credential $creds

            Import-PSSession $session -ErrorAction Ignore -WarningAction Ignore | Out-Null
            Enter-PSSession $session

            Invoke-Command -Session $session -ScriptBlock {
                # Required if not run in SharePoint Management Shell
                if($ver.Version.Major -gt 1)
                {
	                $Host.Runspace.ThreadOptions = "ReuseThread"
                }
                if((Get-PSSnapin -Name Microsoft.Sharepoint.Powershell -ErrorAction SilentlyContinue) -eq $null)
                {
	                Add-PSSnapin Microsoft.Sharepoint.Powershell
                }
            }
        }
        catch
        {
            Write-Error $Error[0]
        }

    }
}



Connect-SPServer -Server "xxxxx"