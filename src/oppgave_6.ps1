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

function listKort  {
    [OutputType([string])]
    param (
        [object[]]
        $stokk
    )
    foreach ($kort in $stokk)
    {

        $streng = $streng + $($kort.suit[0])+$($kort.value) + ","
 
    }
    return $streng.Substring(0,$streng.Length-1)
}

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


Write-Output "kortstokk: " $(listKort -stokk $kortstokk)

Write-Output "summen av kortene er:  $(summerKort -kortstokk $kortstokk)"

$meg = $kortstokk[0..1]
$kortstokk = $kortstokk[2..$kortstokk.Count]

$magnus = $kortstokk[0..1]
$kortstokk = $kortstokk[2..$kortstokk.Count]

Write-Output "meg: " $(listKort -stokk $meg)

Write-Output "Magnus: " $(listKort -stokk $magnus)

Write-Output "summen av kortene er:  $(summerKort -kortstokk $meg)"
Write-Output "summen av kortene er:  $(summerKort -kortstokk $magnus)"
