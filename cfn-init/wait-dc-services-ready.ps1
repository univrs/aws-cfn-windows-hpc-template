# This PowerShell script waits for the NTDS (NT Domain Services) and DNS services to be Running on a Domain Controller
#

Import-Module ServerManager

$status = (Get-Service -Name NTDS -ErrorAction SilentlyContinue | Select -ExpandProperty Status)
while ($status -ne "Running")
{
  Start-Sleep 10
  $status = (Get-Service -Name NTDS -ErrorAction SilentlyContinue | Select -ExpandProperty Status)
}

$status = (Get-Service -Name dns -ErrorAction SilentlyContinue | Select -ExpandProperty Status)
while ($status -ne "Running")
{
  Start-Sleep 10
  $status = (Get-Service -Name dns -ErrorAction SilentlyContinue | Select -ExpandProperty Status)
}
