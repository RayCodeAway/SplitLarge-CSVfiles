# ![logo][] PowerShell

Use this app to split csv files. After testing various methods to read lines of files i found the FileSytem reader the best solution for HUGE Files.  
The process uses the data stream namespace 
https://docs.microsoft.com/en-us/dotnet/api/system.io.file.openread?view=net-5.0

I have extended Tobias file splitting script to also be able to stitch malformed lines to complete each line


[logo]: https://raw.githubusercontent.com/PowerShell/PowerShell/master/assets/ps_black_64.svg?sanitize=true

## The Problem
We have huge CSV files that cant be ingested by an integration engine due to their size limits. we must find a way to split the file so that the data can be 
processes in batches. a lot of script struggled with 100GB CSV Files

## The Solution
Tobias script did a great job to split. but the problem was that the last line would often be cut prematurely eg below

xxxx	,	xxxx	,	xxxx	,	xxxx	,	xxxx	,	xxxx
xxxx	,	xxxx	,	xxxx	,	xxxx	,	xxxx	,	xxxx
xxxx	,	xxxx	,	xxxx	,	xxxx	,	xxxx	,	xxxx                <------ File1
xxxx	,	xxxx	,	xxxx	,	xxxx	,	xxxx	,	xxxx
xxxx	,	xxxx	,	xxxx	,	xxxx	,	xxxx	,	xxxx
xxxx	,	xxxx	,	xx

xx	,	xxxx	,	xxxx	,	xxxx
xxxx	,	xxxx	,	xxxx	,	xxxx	,	xxxx	,	xxxx
xxxx	,	xxxx	,	xxxx	,	xxxx	,	xxxx	,	xxxx                <------File2
xxxx	,	xxxx	,	xxxx	,	xxxx	,	xxxx	,	xxxx

i created a second step to add last line of proceding file to the first line of the subsequent file






## Windows PowerShell

The script is tested on:
                                                                                                                          
----                           -----                                                                                                                             
PSVersion                      5.1.18362.1171                                                                                                                    
PSEdition                      Desktop                                                                                                                           
PSCompatibleVersions           {1.0, 2.0, 3.0, 4.0...}                                                                                                           
BuildVersion                   10.0.18362.1171                                                                                                                   
CLRVersion                     4.0.30319.42000                                                                                                                   
WSManStackVersion              3.0                                                                                                                               
PSRemotingProtocolVersion      2.3                                                                                                                               
SerializationVersion           1.1.0.1 


## New to PowerShell?

If you are new to PowerShell and would like to learn more, we recommend reviewing the [getting started][] documentation.

[getting started]: https://github.com/PowerShell/PowerShell/tree/master/docs/learning-powershell

## Instructions

You can download and install a PowerShell package for any of the following platforms.


## Get PowerShell
Add the function CSV-FileSplitter to your library
Run the test script modifying the three paramaeters accordingly

## Acknowledgments
Huge thanks to Tobias who's developed the initial file splitter 
https://www.powershellgallery.com/packages/FileSplitter/1.3/Content/Split-File.ps1




