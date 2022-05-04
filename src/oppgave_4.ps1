[CmdletBinding()]
param (
    [Parameter(HelpMessage = "URL til kortstokk",Mandatory)]
    [Uri]
    $shuffleUri
)

$ErrorActionPreference = 'Stop'

$shuffle = Invoke-Webrequest -Uri $shuffleUri

$shuffleJson = $shuffle.Content

$kortstokk = ConvertFrom-Json -InputObject $shuffleJson

foreach ($kort in $kortstokk)
{

    $trukket = $($kort.suit[0])+$($kort.value)
    Write-Output "$trukket"

    $konkat_kort = $konkat_kort + $trukket + ","
}

Write-Output $konkat_kort.Substring(0,$konkat_kort.Length-1)
