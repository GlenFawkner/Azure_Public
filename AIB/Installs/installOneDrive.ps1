#Version: 1.0
#Author: Glen.Fawkner
#Date: 21/02/2023
#Description: This script will install OneDrive machine wide

#Create local path
$appName = 'OneDrive'
$drive = 'C:\'
New-Item -Path $drive -Name $appName  -ItemType Directory -ErrorAction SilentlyContinue
$LocalPath = $drive + '\' + $appName 
set-Location $LocalPath

#Download OneDrive
$oneDriveURL = 'https://go.microsoft.com/fwlink/?linkid=844652'
$oneDriveExe = 'OneDriveSetup.exe'
$outputPath = $LocalPath + '\' + $oneDriveExe
Invoke-WebRequest -Uri $oneDriveURL -OutFile $outputPath
#Remove OneDrive if it exists
Start-Process -FilePath $outputPath -Args "/uninstall" -Wait
write-host 'AIB Customization: Uninstalling OneDrive'

#Set OneDrive RegKey
write-host 'AIB Customization: Set required OneDrive regKey'
New-Item -Path HKLM:\SOFTWARE\Microsoft -Name "OneDrive" -Force
New-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\OneDrive -Name "AllUsersInstall" -Type "Dword" -Value "1"
write-host 'AIB Customization: Finished Set required OneDrive regKey'

#Install OneDrive
write-host 'AIB Customization: Installing OneDrive'
Start-Process -FilePath $outputPath -Args "/allusers" -Wait

#Set OneDrive RegKey to start on boot
write-host 'AIB Customization: Set required OneDrive regKey'
New-ItemProperty -Path HKLM\Software\Microsoft\Windows\CurrentVersion\Run -Name "OneDrive" -Type "string" -Value "C:\Program Files (x86)\Microsoft OneDrive\OneDrive.exe /background" -Force
write-host 'AIB Customization: Finished Set required OneDrive regKey'