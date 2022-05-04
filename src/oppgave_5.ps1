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
#    Write-Output "$trukket"

    $konkat_kort = $konkat_kort + $trukket + ","
}

Write-Output $konkat_kort.Substring(0,$konkat_kort.Length-1)

function summerKort {
    param (
        [object[]]
        $kortstokk
    )
    $summen = 0
    foreach ($x in $kortstokk) {
        $summen += 
        switch ($x.value) {
            "J" { 10 } 
            "Q" { 10 }
            "K" { 10 }
            "A" { 11 }
            Default {$x.value}
        }
    }
    return $summen
}


Write-Output "summen av kortene er:  $(summerKort -kortstokk $kortstokk)"
