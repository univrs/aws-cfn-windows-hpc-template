# This PowerShell script adds the specified domain user as an administrator to this computer
#
# It must be called with the name of the user in the format DOMAIN/HPCUser (note the forward slash '/')
#
[CmdletBinding()]
param(
  [Parameter(Mandatory=$True,Position=1)]
  [string]$LogonName
)

$de = [ADSI]"WinNT://$env:ComputerName/Administrators,group"
$de.psbase.Invoke("Add",([ADSI]"WinNT://$LogonName").path)
