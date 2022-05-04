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
    param (
        [object[]]
        $stokk
    )
    foreach ($kort in $stokk)
    {

        $trukket = $($kort.suit[0])+$($kort.value)
 
        $konkat_kort = $konkat_kort + $trukket + ","
    }

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

$(listKort -stokk $kortstokk)
Write-Output "kortstokk: " $konkat_kort.Substring(0,$konkat_kort.Length-1)

Write-Output "summen av kortene er:  $(summerKort -kortstokk $kortstokk)"

$meg = $kortstokk[0..1]
$kortstokk = $kortstokk[2..$kortstokk.Count]

$magnus = $kortstokk[0..1]
$kortstokk = $kortstokk[2..$kortstokk.Count]

Write-Output "meg: " $meg

Write-Output "Magnus: " $magnus

Write-Output "summen av kortene er:  $(summerKort -kortstokk $meg)"
Write-Output "summen av kortene er:  $(summerKort -kortstokk $magnus)"
