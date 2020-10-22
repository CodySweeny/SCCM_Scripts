#Cody Sweeny
#10/15/2020

$VMName=Read-Host "Please enter a hostname for your new VM"
$HDD= 40GB #HDD Size
$MEM= 4096MB #RAM
$HVHost= "" #Hyper-V Host

Invoke-Command -ComputerName $HVHost -ArgumentList $VMName,$HDD,$MEM -ScriptBlock {
param($VMName,$HDD,$MEM)
New-VM -name $VMName -MemoryStartupBytes $MEM -Generation 2 -Path V:\$VMName\ -NewVHDPath V:\$VMName\VirtualHardDrive\HDD.vhdx -NewVHDSizeBytes $HDD -SwitchName "New Virtual Switch"
Start-VM -name $VMName
}
& "C:\windows\System32\vmconnect.exe" $HVHost $VMName
$a = new-object -comobject wscript.shell 
$intAnswer = $a.popup("Delete $VMName", ` 
0,"Delete VM?",4) 
If ($intAnswer -eq 6) { 
    Invoke-Command -ComputerName $HVHost -ArgumentList $VMName -ScriptBlock {
    param($VMName)
    Stop-VM -Name $VMName -TurnOff
    Remove-VM -Name $VMName -Force 
    Remove-Item -Path V:\$VMName\ -Recurse
}    
} else { 
    $a.popup("THE VM LIVES ON") 
} 
