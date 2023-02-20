<#
.Synopsis
   Short description
.DESCRIPTION
   Long description
.EXAMPLE
   Example of how to use this cmdlet
.EXAMPLE
   Another example of how to use this cmdlet
#>
function Get-HostsWithIp
{
    [CmdletBinding()]
    [Alias()]
    [OutputType([int])]
    Param
    (
        # Search Base to look for the AD computers
        [Parameter(Mandatory=$true,
                   ValueFromPipelineByPropertyName=$true,
                   Position=0)]
        [string]
        $SearchBase,

        # Partial IP address for filtering, such as 192.168.8.*
        [Parameter(Mandatory=$false,
                   ValueFromPipelineByPropertyName=$false,
                   Position=1)]
        [string]
        $PartialAddress
    )

    Begin
    {
    }
    Process
    {
        $Dictionary = @{}

        Get-ADComputer -SearchBase $SearchBase -Filter * | ForEach-Object {
            [string]$Hostname = $_.DNSHostName
            if([System.String]::IsNullOrEmpty($Hostname)) { Write-Warning "Hostname exception: $_"; return;}

            try {
                if([string]::IsNullOrEmpty($PartialAddress)) {
                    $IpAddress = (([System.Net.Dns]::GetHostEntry($HostName)).AddressList | Where-Object -Property AddressFamily -EQ "InterNetwork").IPAddressToString
                }
                else {
                    $IpAddress = (([System.Net.Dns]::GetHostEntry($HostName)).AddressList | Where-Object -Property AddressFamily -EQ "InterNetwork"| Where-Object -Property IPAddressToString -Like $PartialAddress).IPAddressToString
                }

                $Dictionary.Add($Hostname, $IpAddress)
            }
            catch { 
                # Write-Warning "No such host is known: $HostName"
            }
        }

        return $Dictionary
    }
    End
    {
    }
}

Get-HostsWithIp -SearchBase "OU=XXXXX Intranet,DC=XXX,DC=XXX,DC=XXX" -PartialAddress '*.*.*'