#Cody Sweeny
#12/18/2020
#Used to traverse a directory to find and replace files


$Server=Read-Host "Please enter a hostname"

$Files = Get-ChildItem -Path "\\$Server\FILEPATH" -Recurse 
$Files1 = Get-ChildItem -Path "\\$Server\FILEPATH" -Recurse 

ForEach ($file In $files)
{
    Write-Host 'Replacing:'$file
    If ($file.PSChildName -eq 'Video Client.lnk')
    {
        Copy-Item -Path "FILEPATH" -Destination $file -Force
    }
}
ForEach ($file1 In $files1)
{
    Write-Host 'Replacing:'$file1
    If ($file1.PSChildName -eq 'Video Player.lnk')
    {
        Copy-Item -Path "FILEPATH" -Destination $file1 -Force
    }
}