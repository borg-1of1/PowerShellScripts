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

Set-Location -Path "C:\Users\micha\Downloads\DogPoopNaighbors"
$fileList = Get-ChildItem -Path "C:\Users\micha\Downloads\DogPoopNaighbors"

if(Test-Path -Path "C:\Users\micha\Downloads\DogPoopNaighborsHash.txt"){
     $hashFile = Get-Item -Path "C:\Users\micha\Downloads\DogPoopNaighborsHash.txt"     
}
else{
    $hashFile = New-Item -Path "C:\Users\micha\Downloads\DogPoopNaighborsHash.txt"
}

foreach ($file in $fileList){
    Get-FileHash -Path $file -Algorithm SHA256 | Add-Content $hashFile
}