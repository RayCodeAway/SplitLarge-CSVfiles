$sw = new-object System.Diagnostics.Stopwatch
$sw.Start()

$FilePath = $HOME +'\Documents\Projects\ADOPT\Data8277.csv' 
$SplitDir = $HOME +'\Documents\Projects\ADOPT\Split\' 


CSV-FileSplitter -Path $FilePath -PartSizeBytes 35MB -SplitDir $SplitDir #-Verbose 


$sw.Stop()
Write-Host "Split complete in " $sw.Elapsed.TotalSeconds "seconds"
