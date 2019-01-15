# This PowerShell script computes metrics on the head node of an HPC Pack cluster and publishes them to Amazon CloudWatch
#
# It must be called with the current region and stack name
#
[CmdletBinding()]
param(
  [Parameter(Mandatory=$True,Position=1)]
  [string]$Region,
  [Parameter(Mandatory=$True,Position=2)]
  [string]$Stack
)

Add-PSSnapIn Microsoft.HPC
Import-Module AWSPowerShell

$jobs = (Get-HpcJob -State Queued, Running -ErrorAction SilentlyContinue)
$tasks = ($jobs | Get-HpcTask -State Running, Queued -ErrorAction SilentlyContinue)
$nodes = (Get-HpcNode -GroupName ComputeNodes -State Online)

$jobCount = $jobs.Count
$taskCount = $task.Count
$coreHours = ($tasks | % { $_.Runtime.TotalHours * $_.MinCores } | Measure-Object -Sum | Select-Object -ExpandProperty Sum)
$nodeCount = $nodes.Count
$coresPerMachine = ($nodes | Measure-Object -Property SubscribedCores -Average | Select-Object -ExpandProperty Average)
$machineHours = [System.Math]::Ceiling($coreHours / $coresPerMachine)
$globalHours = [System.Math]::Ceiling($machineHours / $nodeCount)

Function CreateMetric
{
    param([string]$Name, [string]$Unit="Count", [string]$Value="0", [string]$StackId, [System.DateTime]$When = (Get-Date).ToUniversalTime())
    $dim = New-Object Amazon.CloudWatch.Model.Dimension
    $dim.Name = "StackId"
    $dim.Value = $StackId

    $dat = New-Object Amazon.CloudWatch.Model.MetricDatum
    $dat.Timestamp = $When
    $dat.MetricName = $Name
    $dat.Unit = $Unit
    $dat.Value = $Value
    $dat.Dimensions = New-Object -TypeName System.Collections.Generic.List[Amazon.CloudWatch.Model.Dimension]
    $dat.Dimensions.Add($dim)
    $dat
}

$now = (Get-Date).ToUniversalTime()
$m1 = (CreateMetric -Name "Job Count" -Value "$jobCount" -StackId $Stack -When $now)
$m2 = (CreateMetric -Name "Task Count" -Value "$taskCount" -StackId $Stack -When $now)
$m3 = (CreateMetric -Name "Core Hours" -Value "$coreHours" -StackId $Stack -When $now)
$m4 = (CreateMetric -Name "Node Count" -Value "$nodeCount" -StackId $Stack -When $now)
$m5 = (CreateMetric -Name "Cores Per Machine" -Value "$coresPerMachine" -StackId $Stack -When $now)
$m6 = (CreateMetric -Name "Machine Hours" -Value "$machineHours" -StackId $Stack -When $now)
$m7 = (CreateMetric -Name "Global Hours" -Value "$globalHours" -StackId $Stack -When $now)

Write-CWMetricData -Namespace "Cluster Metrics" -MetricData $m1, $m2, $m3, $m4, $m5, $m6, $m7 -Region $Region
