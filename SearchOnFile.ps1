Function BrowseForFiles($initialDirectory, [switch]$SaveAs,$DefFile)
{   
	[System.Reflection.Assembly]::LoadWithPartialName("System.windows.forms") | Out-Null
	if ($SaveAs) {
		$OpenFileDialog = New-Object System.Windows.Forms.SaveFileDialog
	} else {
		$OpenFileDialog = New-Object System.Windows.Forms.OpenFileDialog
	}
	
	$OpenFileDialog.initialDirectory = $initialDirectory
    if ($SaveAs) {
        $OpenFileDialog.title = "Save As Parsed File"
        $OpenFileDialog.filter = "All files (*.csv)| *.csv"
    } else {
        $OpenFileDialog.title = "Open File For Edit"
        $OpenFileDialog.filter = "All txt files (*.txt)| *.txt"
    }
	$OpenFileDialog.filename = $DefFile
	$OpenFileDialog.ShowDialog() | Out-Null
	$FileName = $OpenFileDialog.filename
	$FileName
}


$FilePath = (BrowseForFiles -initialDirectory .)
$Pattern = "^[\w-\.]+@domain.co.il$"

$FileStream = [System.IO.FileStream]::new($FilePath,[System.IO.FileMode]::Open,[System.IO.FileAccess]::Read)
$StreamFile = [System.IO.StreamReader]::new($FileStream)

$AllMatches = @()
$i=0
$ProgressBaRs = @('\','|','/')
while (-not $StreamFile.EndOfStream){
	$Line = $StreamFile.ReadLine()
	$sMatch = ($($Line | Select-String -Pattern $Pattern -AllMatches | select -ExpandProperty Matches | select Value))
	$AllMatches += $sMatch
	$sMatch = $null
	$ProgressBaR = $ProgressBaRs[$i]
	Write-Host -NoNewLine "`r$ProgressBaR"
	$i++
	if ($ProgressBaRs.count -eq $i) { $i=0 }
	Write-Host -NoNewLine "`r"
}

$StreamFile.Close()
$FileStream.Close()

($AllMatches | select Value).value | select -Unique
