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

function skrivUt {
    param (
        [object[]]
        $megListe,
        [object[]]
        $magnusListe,
        [string]
        $vant
        
    ) 
        $trukket = $megListe + $magnusListe
        Write-Output "Kort trukket:  $(listKort -stokk $trukket)"
        Write-Output "summen av kort trukket er:  $(summerKort -kortstokk $trukket)"

        Write-Output "meg:  $(listKort -stokk $megListe)"
        Write-Output "Magnus:  $(listKort -stokk $magnusListe)"

        Write-Output "summen av mine kort er:  $(summerKort -kortstokk $megListe)"
        Write-Output "summen av Magnus sine kort er er:  $(summerKort -kortstokk $magnusListe)"

        Write-Output "$vant"

        Write-output "meg | $(summerKort -kortstokk $megListe) | $(listKort -stokk $megListe)"
        Write-output "Magnus | $(summerKort -kortstokk $magnusListe) | $(listKort -stokk $magnusListe)"
        
}
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


Write-Output "Hele kortstokken: " $(listKort -stokk $kortstokk)

Write-Output "summen av alle kortene er:  $(summerKort -kortstokk $kortstokk)"

# trekker 2 kort for meg
$meg = $kortstokk[0..1]
$kortstokk = $kortstokk[2..$kortstokk.Count]

# trekker 2 kort for magnus
$magnus = $kortstokk[0..1]
$kortstokk = $kortstokk[2..$kortstokk.Count]

if ($(summerkort -kortstokk $meg) -eq 21 -and $(summerkort -kortstokk $magnus) -eq 21)
    {
    skrivUt -megListe $meg -magnusListe $magnus -vant "Draw"
    exit
    }
elseif ($(summerkort -kortstokk $meg) -eq 21) {
    skrivUt -megListe $meg -magnusListe $magnus -vant "Vinner: Jeg"
    exit
}
elseif ($(summerkort -kortstokk $meg) -eq 21) {
    skrivUt -megListe $meg -magnusListe $magnus -vant "Vinner: Magnus"
    exit
}

if ($(summerkort -kortstokk $meg) -lt 17)
{
while ($(summerkort -kortstokk $meg) -lt 21)
    {
        $meg = $meg + $kortstokk[0]
        $kortstokk = $kortstokk[1..$kortstokk.Count]
    }
}

if ($(summerkort -kortstokk $meg) -gt 21)
{
    skrivUt -megListe $meg -magnusListe $magnus -vant "Vinner: Magnus"
    exit
}

if ($(summerkort -kortstokk $magnus) -lt 17 -and $(summerKort -kortstokk $meg) -le 21 )
{
while ($(summerkort -kortstokk $magnus) -lt 21)
    {
        $magnus = $magnus + $kortstokk[0]
        $kortstokk = $kortstokk[1..$kortstokk.Count]
    }
}

if ($(summerkort -kortstokk $magnus) -gt 21)
{
    skrivUt -megListe $meg -magnusListe $magnus -vant "Vinner: Jeg"
    exit
}

if ($(summerKort -kortstokk $meg) -gt $(summerKort -kortstokk $magnus)) 
    {$vinner = "Vinner: meg"}
elseif ($(summerKort -kortstokk $meg) -lt $(summerKort -kortstokk $magnus)) 
    {$vinner = "Vinner: Magnus"}
else 
    {$vinner = "Draw"}

skrivUt -megListe $meg -magnusListe $magnus -vant $vinner
