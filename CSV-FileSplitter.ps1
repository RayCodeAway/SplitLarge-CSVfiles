function CSV-FileSplitter
{
    
    param
    (
        [Parameter(Mandatory)]
        [String]
        $Path,
        [Int32]
        $PartSizeBytes = 1MB,
        [Parameter(Mandatory)]
        [String]
        $SplitDir = $HOME +'\Documents\Projects\ADOPT\Split\'
    )

    try
    {
        # get the path parts to construct the individual part
        # file names:
        $fullBaseName = [IO.Path]::GetFileName($Path)
        $baseName = [IO.Path]::GetFileNameWithoutExtension($Path)
        $parentFolder = [IO.Path]::GetDirectoryName($Path)+'\Split'
        If(!(test-path $parentFolder))
            {
                  New-Item -ItemType Directory -Force -Path $parentFolder 
            }
            else {
            Get-ChildItem -Path $parentFolder  -File | Remove-Item #-Verbose
            }
        $extension = [IO.Path]::GetExtension($Path)

        # get the original file size and calculate the
        # number of required parts:
        $originalFile = New-Object System.IO.FileInfo($Path)
        $totalChunks = [int]($originalFile.Length / $PartSizeBytes) + 1
        $digitCount = [int][Math]::Log10($totalChunks) + 1
        

        # read the original file and split into chunks:
        $reader = [IO.File]::OpenRead($Path)
        $count = 0
        $buffer = New-Object Byte[] $PartSizeBytes
        $moreData = $true

        # read chunks until there is no more data
        while($moreData)
        {
            # read a chunk
            $bytesRead = $reader.Read($buffer, 0, $buffer.Length)

            # create the filename for the chunk file
            $chunkFileName = "$parentFolder\$baseName.{0:D$digitCount}.csv" -f $count
            Write-Verbose "saving to $chunkFileName..."
            $output = $buffer

            # did we read less than the expected bytes?
            if ($bytesRead -ne $buffer.Length)
            {
                # yes, so there is no more data
                $moreData = $false
                # shrink the output array to the number of bytes
                # actually read:
                $output = New-Object Byte[] $bytesRead
                [Array]::Copy($buffer, $output, $bytesRead)
            }
            # save the read bytes in a new part file
            [IO.File]::WriteAllBytes($chunkFileName, $output)
            # increment the part counter
            ++$count
        }
        # done, close reader
        $reader.Close()
   
       #
       #Time to stitch malformed lines 
       #
        $SplitFiles = Get-ChildItem  $SplitDir
        $FileCount = 0
        $Slither = ""
        $SplitFiles | Select -First 1000  | ForEach-Object {
            #write-host "Checking in " $_.FullName
            $SplitFile=$_.FullName
             if($Slither -ne "") ##skips the first file and any previous non slither
            {
                    Write-Verbose "$Slither added to ..... $SplitFile"
                    $currentContent = [io.file]::ReadAllText($SplitFile);
                    [io.file]::WriteAllText($SplitFile, $Slither + $currentContent);
            }
    
            $stream = [IO.File]::Open($SplitFile, [IO.FileMode]::Open)
            $strPosition =$stream.Length
            $cr = $false
            $stream.Position = $strPosition
            $compareBytes = 13,10 # CR,LF
            $bytes = (0,0)
            $Slither = ""
            $bytes[0] = 0..0 | %{ $stream.ReadByte() }
            While (!$cr) 
            {
                $bytes[1] = $bytes[0] 
                $bytes[0] = 0..0 | %{ $stream.ReadByte() } #0..0 change to 0..2 searches against 2 chars
        
                if ("$bytes" -eq "$compareBytes") {
                   $cr = $true 
                   $stream.SetLength($strPosition+2)
                }
                #$bytes[0] 
                if($bytes[0] -notin (-1, 10, 13))
                {
                    $Slither = [System.Text.Encoding]::ASCII.GetString($bytes[0]) + $Slither
                }
                $strPosition += -1 
                $stream.Position = $strPosition 
            }
            $stream.Close()
            $stream.Dispose()
      
        }

        }
    catch
    {
        throw "Unable to split file ${Path}: $_"
    }
}

