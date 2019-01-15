# This PowerShell script changes the password of the local administrator 
#
# It must be called with the name of the text file storing the new password for the administrator
#
[CmdletBinding()]
param(
  [Parameter(Mandatory=$True,Position=1)]
  [string]$PasswordFile
)

if (-not (Test-Path $PasswordFile))
{
    Throw "File '$PasswordFile' does not exist, exiting script"
}

$adminPassword = Get-Content $PasswordFile
$Admin = [adsi]("WinNT://$env:ComputerName/Administrator, user")
$Admin.Invoke("SetPassword", $adminPassword)
