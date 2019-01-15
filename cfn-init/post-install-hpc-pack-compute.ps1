# This PowerShell script configures Microsoft HPC Pack on a Compute Node 
#
Add-PSSnapIn Microsoft.HPC

# This node will be a compute node
Assign-HpcNodeTemplate -NodeName $env:COMPUTERNAME -Name "ComputeNode Template" -Confirm:$false

# Only use physical cores, and leave the OS assign the processes on the machine
$cores = (Get-WmiObject Win32_Processor | Measure-Object -Property NumberOfCores -Sum | Select-Object -ExpandProperty Sum)
Set-HpcNode -Name $env:COMPUTERNAME -SubscribedCores $cores -Affinity:$false

# Bring the node online
Set-HpcNodeState -Name $env:COMPUTERNAME -State online

# Set processor affinity to only use the physical cores for MPI processes
[long]$affinity = 0
for($i = 0; $i -lt $cores; $i++)
{
   $affinity = $affinity + (([long] 1) -shl ($i * 2))
}
(Get-Process msmpisvc).ProcessorAffinity = $affinity
