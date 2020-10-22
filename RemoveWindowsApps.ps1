#Cody Sweeny
#https://deploymentparts.wordpress.com/2015/09/10/remove-builtin-apps-from-windows-10-reference-image/
#6/12/2020

$ProvisionedAppPackageNames = @( 
            "Microsoft.BingWeather",
            "Microsoft.GetHelp",
            "Microsoft.Getstarted"
            "Microsoft.Messaging",
            "Microsoft.Microsoft3DViewer" ,
            "Microsoft.MicrosoftOfficeHub" ,
            "Microsoft.MicrosoftSolitaireCollection" ,
            "Microsoft.MicrosoftStickyNotes" ,
            "Microsoft.MixedReality.Portal" ,
            "Microsoft.Office.OneNote" ,
            "Microsoft.OneConnect" ,
            "Microsoft.People" ,
            "Microsoft.Print3D" ,
            "Microsoft.ScreenSketch" ,
            "Microsoft.SkypeApp" ,
            "Microsoft.WindowsAlarms" ,
            "Microsoft.WindowsCamera" ,
            "microsoft.windowscommunicationsapps" ,
            "Microsoft.WindowsFeedbackHub" ,
            "Microsoft.WindowsMaps" ,
            "Microsoft.XboxApp" ,
            "Microsoft.XboxGameOverlay" ,
            "Microsoft.XboxGamingOverlay" ,
            "Microsoft.XboxIdentityProvider" ,
            "Microsoft.XboxSpeechToTextOverlay" ,
            "Microsoft.YourPhone" ,
            "Microsoft.ZuneMusic" ,
            "Microsoft.ZuneVideo"
    )
 
foreach ($ProvisionedAppName in $ProvisionedAppPackageNames) {
    Get-AppxPackage -Name $ProvisionedAppName -AllUsers | Remove-AppxPackage
    Get-AppXProvisionedPackage -Online | where DisplayName -EQ $ProvisionedAppName | Remove-AppxProvisionedPackage -Online
}
 
 
 
$RootPath = "SOFTWARE\Microsoft\Windows\CurrentVersion\Component Based Servicing\Packages\"
 
$SystemAppNames = @( "Windows-ContactSupport" )
 
foreach ($SystemAppName in $SystemAppNames) {
    $RegistryKeyApps = (ls "HKLM:\$RootPath" | where Name -Like "*$SystemAppName*")
         
    foreach($RegistryKeyApp in $RegistryKeyApps)
    {
        $RegistryKey = $RegistryKeyApp.Name.Substring(19) #Remove HKEY_LOCAL_MACHINE from string
        Write-Host $RegistryKey
         
        $key = [Microsoft.Win32.Registry]::LocalMachine.OpenSubKey($RegistryKey,[Microsoft.Win32.RegistryKeyPermissionCheck]::ReadWriteSubTree,[System.Security.AccessControl.RegistryRights]::ChangePermissions)
        $acl = $key.GetAccessControl()
        $rule = New-Object System.Security.AccessControl.RegistryAccessRule ("${[system.environment]::MachineName}\Administrator","FullControl","Allow")
        $acl.SetAccessRule($rule)
        $key.SetAccessControl($acl)
 
        $subkey = [Microsoft.Win32.Registry]::LocalMachine.OpenSubKey("$RegistryKey\Owners",[Microsoft.Win32.RegistryKeyPermissionCheck]::ReadWriteSubTree,[System.Security.AccessControl.RegistryRights]::ChangePermissions)
        $subacl = $subkey.GetAccessControl()
        $subacl.SetAccessRule($rule)
        $subkey.SetAccessControl($subacl)
         
        Set-ItemProperty -Path "HKLM:\$RegistryKey" -Name Visibility -Value 1
        New-ItemProperty -Path "HKLM:\$RegistryKey" -Name DefVis -PropertyType DWord -Value 2
            Remove-Item -Path "HKLM:\$RegistryKey\Owners"
             
            $AppName = $RegistryKey.Split('\')[-1]
            DISM /Online /Remove-Package /PackageName:$AppName
    }
     
    #Remember to remove it from the currently logged in user (and rename "Windows-ContactSupport" to "Windows.ContactSupport")
        Get-AppxPackage -Name $SystemAppName.Replace("-",".") -AllUsers | Remove-AppxPackage
}