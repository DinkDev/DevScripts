# Define solution files to clean
$solutions = @("*.sln")

# Define solution files to exclude
$exclude = @()

$items = Get-ChildItem . -recurse -force -include $solutions -exclude $exclude

# Might want to toggle with Bin\msbuild.exe for x32/AnyCpu
$msBuildExe = 'C:\Program Files (x86)\Microsoft Visual Studio\2019\Enterprise\MSBuild\Current\Bin\amd64\msbuild.exe'

if (Test-Path -Path $msBuildExe) {
    if ($items) {
        foreach ($item in $items) {
            Write-Host "Cleaning $($item)" -foregroundcolor green
            & "$($msBuildExe)" "$($item)" /t:Clean /m
        }
    }

    # Write-Host "Press any key to continue . . ."
    # $x = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")

} else {
    Write-Host "Cannot find command $($msBuildExe)" 
}