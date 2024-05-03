@echo off
color 0B
:: Delete all temporary files
echo Deleting temporary files...
del /q /s %TEMP%\*.*

:: Deactivate Riot Vanguard
@echo off
echo Riot Vanguard will be deactivated.
sc stop vgk
timeout /nobreak /t 2 >nul

:: Disable Hyper-V
echo Disabling Hyper-V...
bcdedit /set hypervisorlaunchtype off
powershell.exe -ExecutionPolicy Bypass -Command "Disable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V-All"

:: Disable VulnerableDriverBlocklist for Windows 11 22h2
echo Disabling VulnerableDriverBlocklist...
reg add "HKLM\SOFTWARE\Microsoft\SQMClient\Windows\Vulnerability\Override" /v "Windows11_22H2_BlockList" /t REG_DWORD /d 0 /f

:: Add the specified regedits
echo Adding regedits...
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v FeatureSettingsOverride /t REG_DWORD /d 3 /f
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v FeatureSettingsOverrideMask /t REG_DWORD /d 3 /f

:: Disable Core Isolation
echo Disabling Core Isolation...
reg add "HKLM\SYSTEM\CurrentControlSet\Control\DeviceGuard" /v "EnableVirtualizationBasedSecurity" /t REG_DWORD /d 0 /f

:: Create a note text file
echo Please make sure Virtualization is enabled in your BIOS settings for your CPU! And For AMD: (Disable Smart Access Memory in BIOS) And For Intel (Disable Rezisebar in Bios) > "%TEMP%\VirtualizationNote.txt"

:: Display the note using notepad
start notepad "%TEMP%\VirtualizationNote.txt"

echo Done! The system will restart in 30 seconds.
timeout /nobreak /t 30 >nul
shutdown /r /f /t 0
pause
