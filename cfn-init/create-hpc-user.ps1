# This PowerShell script creates a user in an Active Directory Domain, and delegates the "add computers to the domain" rights to him
#
# It must be called with the name of the text file storing the user's information in the format (one value per line, no padding):
#   DOMAIN\HPCUser (Domain NetBIOS Name\User SAM Account Name)
#   Password
#   domain.local   (Domain DNS name)
#   DOMAIN         (Domain NetBIOS Name)
#   CUser        (User SAM Account Name)
#
[CmdletBinding()]
param(
  [Parameter(Mandatory=$True,Position=1)]
  [string]$UserFile,
  [int]$MaxComputersPerUser=100
)

if (-not (Test-Path $UserFile))
{
    Throw "File '$UserFile' does not exist, exiting script"
}

$domain = Get-ADDomain
$domain | Set-ADDomain -Replace @{"ms-ds-MachineAccountQuota"="$MaxComputersPerUser"}

Import-Module ServerManager
Install-WindowsFeature RSAT-ADDS
$content = Get-Content $UserFile
$UserPS = $content[0]
$PassPS = ConvertTo-SecureString $content[1] -AsPlainText -Force
$logonName = $content[4]
New-ADUser -Name $logonName -AccountPassword $PassPS -PasswordNeverExpires:$false -ChangePasswordAtLogon:$false -Enabled:$true

$domainName = $domain.ComputersContainer
dsacls $domainName /I:S /G "$($UserPS):CC;;computer"
dsacls $domainName /I:S /G "$($UserPS):DC;;computer"
dsacls $domainName /I:S /G "$($UserPS):CA;Reset Password;computer"
dsacls $domainName /I:S /G "$($UserPS):WP;Account Restrictions;computer"
dsacls $domainName /I:S /G "$($UserPS):WS;Validated write to service principal name;computer"
dsacls $domainName /I:S /G "$($UserPS):WS;Validated write to DNS host name;computer"
