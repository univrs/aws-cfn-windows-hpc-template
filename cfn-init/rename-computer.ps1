# This PowerShell script renames the current computer 
#
# It must be called with the new name of the computer
#
[CmdletBinding()]
param(
  [Parameter(Mandatory=$True,Position=1)]
  [string]$ComputerName
)

Rename-Computer -NewName $ComputerName -Restart
