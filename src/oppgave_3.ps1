
$shuffle = Invoke-RestMethod -Uri "http://nav-deckofcards.herokuapp.com/shuffle"

foreach ($kort in $shuffle)
{

    $trukket = $($kort.suit[0])+$($kort.value)
    Write-Host "$trukket"

    $konkat_kort = $konkat_kort + $trukket + ","
}

Write-Host $konkat_kort.Substring(0,$konkat_kort.Length-1)
