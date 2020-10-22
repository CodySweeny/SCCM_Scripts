#Cody Sweeny
#https://www.thomasmaurer.ch/2010/12/powershell-delete-files-older-than/
#9/15/2020
$Path = "C:\*.hprof"
$Path1 = "C:\*.mdmp"
$old = 90
$now = Get-Date

Get-ChildItem -path $Path |  Where { ((Get-Date)-$_.LastWriteTime).days -gt $Old | Remove-Item
Get-ChildItem -path $Path1 | Where { ((Get-Date)-$_.LastWriteTime).days -gt $Old | Remove-Item