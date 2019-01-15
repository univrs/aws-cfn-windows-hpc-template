# This PowerShell script configures the network adapter for a domain controller
#
# It must be called with the domain DNS name, and with the name of the network adapter
#
[CmdletBinding()]
param(
  [Parameter(Mandatory=$True,Position=1)]
  [string]$DomainDNSName,
  [Parameter(Mandatory=$True,Position=2)]
  [string]$InterfaceNewName
)

Import-Module ServerManager

Write-Host "Renaming network adapter"
$adapterName = (Get-NetAdapter | Select -ExpandProperty Name -First 1)
Rename-NetAdapter -Name $adapterName -NewName $InterfaceNewName

Write-Host "Disabling IPv6"
Disable-NetAdapterBinding  -InterfaceAlias $InterfaceNewName -ComponentID ms_tcpip6 -Confirm:$false

$private    = (Get-NetIPAddress -InterfaceAlias $InterfaceNewName -AddressFamily IPv4)
$privateIp  = $private.IPAddress
$privatePl  = $private.PrefixLength
$privateGw  = (Get-NetIPConfiguration -InterfaceAlias $InterfaceNewName).IPv4DefaultGateway.NextHop
$privateDns = (Get-DnsClientServerAddress -InterfaceAlias $InterfaceNewName -AddressFamily IPv4).ServerAddresses

Write-Host "Changing DNS Client"
Set-DnsClient -InterfaceAlias $InterfaceNewName -ConnectionSpecificSuffix $DomainDNSName -UseSuffixWhenRegistering:$true -RegisterThisConnectionsAddress:$true -Confirm:$false
Set-DnsClientServerAddress -InterfaceAlias $InterfaceNewName -ServerAddresses $privateDns

Write-Host "Assigning Static IP Address"
Remove-NetIPAddress        -InterfaceAlias $InterfaceNewName -IPAddress $privateIp -Confirm:$false
New-NetIPAddress           -InterfaceAlias $InterfaceNewName -IPAddress $privateIp -PrefixLength $privatePl -DefaultGateway $privateGw -Confirm:$false

Write-Host "Done"
