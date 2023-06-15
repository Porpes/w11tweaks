Function DisableStartups {
    $32bit = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run"
    $32bitRunOnce = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce"
    $64bit = "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Run"
    $64bitRunOnce = "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\RunOnce"
    $currentLOU = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run"
    $currentLOURunOnce = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce"
    
    $disableList = @(
        "msedge",
        "SecurityHealthSystray",
        "CCleaner Smart Cleaning",
        "CiscoMeetingDaemon",
        "Google Update",
        "GoogleDriveFS",
        "GoogleDriveSync",
        "Steam",
        "Discord"
    )
    New-PSDrive -PSProvider Registry -Name HKU -Root HKEY_USERS | Out-Null
    $startups = Get-CimInstance Win32_StartupCommand | Select-Object Name,Location
    $regStartList = Get-Item -path $32bit,$32bitRunOnce,$64bit,$64bitRunOnce,$currentLOU,$currentLOURunOnce | Where-Object {$_.ValueCount -ne 0} | Select-Object  property,name

    foreach ($regName in $regStartList.name) {
        $regNumber = ($regName).IndexOf("\")
        $regLocation = ($regName).Insert("$regNumber",":")
        if ($regLocation -like "*HKEY_LOCAL_MACHINE*"){
            $regLocation = $regLocation.Replace("HKEY_LOCAL_MACHINE","HKLM")
            write-host $regLocation
        }
        if ($regLocation -like "*HKEY_CURRENT_USER*"){
            $regLocation = $regLocation.Replace("HKEY_CURRENT_USER","HKCU")
            write-host $regLocation
        }
        foreach($disable in $disableList) {
            if (Get-ItemProperty -Path "$reglocation" -name "$Disable" -ErrorAction SilentlyContinue) {
                Write-host "yeah i exist"
                #Remove-ItemProperty -Path "$location" -Name "$($startUp.name)" -whatif
            } else {
                Write-host "no exist"
            }
        }   

    }
}

DisableStartups;