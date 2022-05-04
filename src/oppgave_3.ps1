Write-Host 'XXX'

$shuffle = Invoke-RestMethod -Uri "http://nav-deckofcards.herokuapp.com/shuffle"
$deck = $shuffle.Content | Out-String | ConvertFrom-Json
foreach ($x in $deck)
{
    Write-Host "$x.suit $x.value"
}