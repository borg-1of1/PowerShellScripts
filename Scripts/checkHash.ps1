###################################################################################
# Author:      MJC
# Date:        7/21/20  
# Version:     1.0
# Description: Script for checking the hash of recieved files.  Prameters are the 
# recieved file name and path (Recomend running form same location as file), the 
# expected hash for the file, and the algorithm used to generate the hash. The 
# default algorithm is SHA256.
###################################################################################

param($recievedFile, $ReferenceHash, $alg = "SHA256")

$recievedFileHash = Get-FileHash -Path $recievedFile -Algorithm $alg 

if ($recievedFileHash.Hash -eq $ReferenceHash){
    Write-Host "You have a good download!"
}
else{
    Write-Host "There was a problem with the Download!"
    Write-Host ("Hash: " + $recievedFileHash.Hash)
}
