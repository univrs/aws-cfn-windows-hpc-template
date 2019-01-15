# This PowerShell script joins the current computer to a domain, using the specified user
#
# It must be called with the name of the text file storing the user's information in the format (one value per line, no padding):
#   DOMAIN\CUser (Domain NetBIOS Name\User SAM Account Name)
#   Password
#   domain.local   (Domain DNS name)
#
[CmdletBinding()]
param(
  [Parameter(Mandatory=$True,Position=1)]
  [string]$DomainFile
)

if (-not (Test-Path $DomainFile))
{
    Throw "File '$DomainFile' does not exist, exiting script"
}

$content = Get-Content $DomainFile
$UserPS = $content[0]
$PassPS = ConvertTo-SecureString $content[1] -AsPlainText -Force
$DomainCred = New-Object System.Management.Automation.PSCredential $UserPS, $PassPS
Add-Computer -DomainName $content[2] -Credential $DomainCred -Restart
