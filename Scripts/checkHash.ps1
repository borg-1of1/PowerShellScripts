###################################################################################
# Author:           MJC
# Date (Original):  7/21/20  
# Description:      Script for checking the hash of recieved files.  Prameters are the 
# recieved file name and path (Recomend running form same location as file), the 
# expected hash for the file, and the algorithm used to generate the hash. The 
# default algorithm is SHA256.
###################################################################################
<#
.SYNOPSIS
    Returns true if the hash supplied matches the calculated has value for a file.

.DESCRIPTION
    Script for checking the hash of recieved files.  Prameters are the 
    recieved file name and path (Recomend running form same location as file), the 
    expected hash for the file, and the algorithm used to generate the hash. The 
    default algorithm is SHA256.

.PARAMETER recievedFile
    The name and path to the recieved file to be checked.

.PARAMETER referenceHash
    This is the supplied hash for the file as determined by the person or organization
    supplying the file.

.PARAMETER alg
    This is the algorithm used to calculate the file hash.  This can be any supported value 
    of SHA1, SHA256, SHA384, SHA512, MD5.  The default is SHA256.

.EXAMPLE
     Get-MrAutoStoppedService -ComputerName 'Server1', 'Server2'

.EXAMPLE
     'Server1', 'Server2' | Get-MrAutoStoppedService

.EXAMPLE
     .\checkHash.ps1 C:\somefile.ext someHashValue sha256

.INPUTS
    String

.OUTPUTS
    PSCustomObject

.NOTES
    Author:  Mike Conway    
#>


[CmdletBinding()] 
param(
    [Paramater(Mandatory)] # This line makes the following parameter a required entry for the command to execute
    [string]$recievedFile, # restricts the input to a string value
    [Paramater(Mandatory)]
    [string]$ReferenceHash, 
    [string]$alg = "SHA256"
)

if(Test-Path -Path $recievedFile){
    $recievedFileHash = Get-FileHash -Path $recievedFile -Algorithm $alg 
}
else {
    Write-Host "File $recieved file does not exist.  Please check your file path and location."
}

if ($recievedFileHash.Hash -eq $ReferenceHash){
    Write-Host "You have a good download!"
}
else{
    Write-Host "There was a problem with the Download!"
    Write-Host ("Hash: " + $recievedFileHash.Hash)
}
