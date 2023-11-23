$Pattern = "^[\\w.-]+@mail\\.co\\.il$"
$FilePath = '.\myHUGEfile.txt'
$FileStream = [System.IO.FileStream]::new($FilePath, [System.IO.FileMode]::Open, [System.IO.FileAccess]::Read)
$StreamReader = [System.IO.StreamReader]::new($FileStream)
$AllMatches = @()
while (-not $StreamReader.EndOfStream) {
  $Line = $StreamReader.ReadLine()
  $AllMatches += $($Line | Select-String -Pattern $Pattern -AllMatches  | select -ExpandProperty Matches| select Value)
}
$StreamReader.Close()
$FileStream.Close()

$AllMatches.value | select -Unique
