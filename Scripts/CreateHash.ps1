<#
.SYNOPSIS
    Hashes and writes values to a file for all files in a directory.

.DESCRIPTION
    Script for generating a SHA256 hash value for all files ina  given directory.

.PARAMETER tbd

.EXAMPLE
     .\CreateHash.ps1 C:\somefile.ext someHashValue sha256

.INPUTS
    String

.OUTPUTS
    PSCustomObject

.NOTES
    Author: Mike Conway 
    Date:   1/18/22 (Original) 
    ToDo:   Create paramaters, pass directory as variable, pass file to be created as variable  
#>

Set-Location -Path "C:\Users\micha\Desktop\Recovered Files"
$fileList = Get-ChildItem -Path "C:\Users\micha\Desktop\Recovered Files"

if(Test-Path -Path "C:\Users\micha\Desktop\Hash.txt"){
     $hashFile = Get-Item -Path "C:\Users\micha\Desktop\Hash.txt"     
}
else{
    $hashFile = New-Item -Path "C:\Users\micha\Desktop\Hash.txt"
}

#foreach ($file in $fileList){
#    Get-FileHash $file -Algorithm SHA256 | Select-Object 
#    Get-Content -Path $hashFile
    #Get-FileHash -Path $file -Algorithm MD5 | Add-Content $hashFile
#}

Get-FileHash -Path $fileList | Select-Object -Property Hash | Out-File $hashFile