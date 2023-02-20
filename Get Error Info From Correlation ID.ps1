# Script that displays error information of given Correlation Id

# Configuration variables
$CorrelationId = "XXXXXXXXXXXXXXX"
$TimeRangeByMinute = 30



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



$ScriptPath = Split-Path -Path $MyInvocation.MyCommand.Definition
$OutputPath = Join-Path -Path $ScriptPath -ChildPath "error-$($CorrelationId).txt"

$Start = (Get-Date).AddMinutes(-($TimeRangeByMinute))
$End = (Get-Date)
$Event = Get-SPLogEvent -StartTime $Start -EndTime $End | Where-Object { $_.Correlation -eq $CorrelationId }

if($null -eq $Event) {
        Write-Output "Event $CorrelationId not found"
}
else {
        $Event | Select-Object Area, Category, Level, EventID, Correlation, Message | Format-List > $OutputPath
	Write-Output "Error information is collected. Check file:"
	Write-Output $OutputPath
}
