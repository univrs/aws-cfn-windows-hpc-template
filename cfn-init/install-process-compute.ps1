# This PowerShell script manages the installation process of Microsoft HPC Pack on a Compute Node 
#
# It must be called with the name of the text file storing the user's information, the current region, and the stack name. Text file in the format (one value per line, no padding):
#   DOMAIN\HPCUser (Domain NetBIOS Name\User SAM Account Name)
#   Password
#
[CmdletBinding()]
param(
  [Parameter(Mandatory=$True,Position=1)]
  [string]$UserFile,
  [Parameter(Mandatory=$True,Position=2)]
  [string]$Region,
  [Parameter(Mandatory=$True,Position=3)]
  [string]$Stack
)

if (-not (Test-Path $UserFile))
{
    Throw "File '$UserFile' does not exist, exiting script"
}

$content = Get-Content $UserFile
$UserPS = $content[0]
$PassPS = $content[1]

Write-Host "Registering Installation Scheduled Task"
schtasks.exe /Create /SC ONSTART /RU "$UserPS" /RP "$PassPS" /TN InstallHPCPack /TR "powershell.exe -ExecutionPolicy Unrestricted C:\cfn\install\install-hpc-pack.ps1 >> C:\cfn\log\hpc-install.log 2>&1"

Write-Host "Running Installation Scheduled Task"
schtasks.exe /Run /I /TN InstallHPCPack

Write-Host "Waiting for Installation"
$status = (Get-Service -Name HpcManagement -ErrorAction SilentlyContinue | Select -ExpandProperty Status)
while ($status -ne "Running")
{
  Start-Sleep 10
  $status = (Get-Service -Name HpcManagement -ErrorAction SilentlyContinue | Select -ExpandProperty Status)
}

& ${env:SystemRoot}\Microsoft.NET\Framework64\v4.0.30319\installutil.exe "C:\Program Files\Microsoft HPC Pack 2012\Bin\ccppsh.dll"

Write-Host "Deleting Installation Scheduled Task"
schtasks.exe /Delete /F /TN InstallHPCPack

Write-Host "Registering Post-Installation Scheduled Task"
schtasks.exe /Create /SC ONSTART /RU "$UserPS" /RP "$PassPS" /TN PostInstallHPCPack /TR "powershell.exe -ExecutionPolicy Unrestricted C:\cfn\install\post-install-hpc-pack.ps1 >> C:\cfn\log\hpc-install.log 2>&1"

Write-Host "Running Post-Installation Scheduled Task"
schtasks.exe /Run /I /TN PostInstallHPCPack

Write-Host "Waiting for Post-Installation"
Add-PSSnapIn Microsoft.HPC

$state = (Get-HpcNode -Name $env:COMPUTERNAME -ErrorAction SilentlyContinue | Select -ExpandProperty NodeState)
while ($state -ne "Online")
{
  Start-Sleep 10
  $state = (Get-HpcNode -Name $env:COMPUTERNAME -ErrorAction SilentlyContinue | Select -ExpandProperty NodeState)
}

Write-Host "Deleting Post-Installation Scheduled Task"
schtasks.exe /Delete /F /TN PostInstallHPCPack

Write-Host "Done"
