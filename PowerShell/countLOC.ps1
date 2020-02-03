#Quick and dirty PS script for counting lines of code in a directory. Output is dumped to a simple CSV file.
#Note that this script doesn't count blank lines.
#Parameters:
#  path - the path containing the code files (note that the script will recurse through subfolders
#  outputFile - fully qualified path of the file to dump the CSV output
#  include (Optional) - file mask(s) to include in the count (deafults to *.*)
#  exclude (Optional) - file mask(s) to exclude in the count (defaults to none)
#  Example (count lines in target path including *.cs but excluding *.designer.cs)
#  .\countLOC.ps1 -path "C:\code\MyProject" -outputFile "C:\code\loc.csv" -include "*.cs" -exclude "*.designer.cs"
param([string]$path, [string]$outputFile, [string]$include = "*.*", [string]$exclude = "")
Clear-Host
Get-ChildItem -re -in $include -ex $exclude $path |
Foreach-Object { Write-Host "Counting $_.FullName" 
    $fileStats = Get-Content $_.FullName | Measure-Object -line
    $linesInFile = $fileStats.Lines
    "$_,$linesInFile" } | Out-File $outputFile -encoding "UTF8"
Write-Host "Complete"