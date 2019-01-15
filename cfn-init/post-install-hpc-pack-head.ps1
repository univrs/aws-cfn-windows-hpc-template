# This PowerShell script configures Microsoft Cluster Pack on a Head Node
#
# It must be called with the name of the text file storing the user's information in the format (one value per line, no padding):
#   DOMAIN\CUser (Domain NetBIOS Name\User SAM Account Name)
#   Password
#
[CmdletBinding()]
param(
  [Parameter(Mandatory=$True,Position=1)]
  [string]$UserFile
)

if (-not (Test-Path $UserFile))
{
    Throw "File '$UserFile' does not exist, exiting script"
}

$content = Get-Content $UserFile
$UserPS = $content[0]
$PassPS = ConvertTo-SecureString $content[1] -AsPlainText -Force
$DomainCred = New-Object System.Management.Automation.PSCredential $UserPS, $PassPS

Add-PSSnapIn Microsoft.HPC

Set-HPCNetwork -Topology Enterprise -EnterpriseDnsRegistrationType FullDnsNameOnly -EnterpriseFirewall $null

Set-HpcJobCredential -Credential $DomainCred
Set-HpcClusterProperty -InstallCredential $DomainCred

Set-HpcClusterProperty -NodeNamingSeries "Compute%1000%"
New-HpcNodeTemplate -Name "ComputeNode Template" -Description "Custom compute node template" -Type ComputeNode -UpdateCategory None
Set-HpcNode -Name $env:COMPUTERNAME -Role BrokerNode
Set-HpcNodeState -Name $env:COMPUTERNAME -State online
