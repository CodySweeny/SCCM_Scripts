#Cody Sweeny
#10/15/2020

[System.Reflection.Assembly]::LoadWithPartialName("System.Drawing") | Out-Null
$families = (New-Object System.Drawing.Text.InstalledFontCollection).Families

if($families -contains "From Where You Are"){
Write-Host "Installed"
}else {
   write-host("Not Installed")
}