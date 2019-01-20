# This PowerShell script installs Microsoft HPC Pack on a Head Node
#

Import-Module ServerManager
Install-WindowsFeature DHCP, FS-Resource-Manager, DirectAccess-VPN, Routing, Web-Default-Doc, Web-Dir-Browsing, Web-Http-Errors, Web-Static-Content, Web-Http-Logging, Web-Stat-Compression, Web-Filtering, Web-IP-Security, Web-Scripting-Tools, WDS-Transport, MSMQ-Server, Windows-Internal-Database

Write-Host "Starting Installation"
Write-Host ""
Write-Host "- Install SQL"
D:\SQLInstall\setup.exe /CONFIGURATIONFILE=C:\cfn\install\sql-config.conf

Write-Host ""
Write-Host "- Install HPC Pack"
D:\HPC2012R2-Full\setup.exe -unattend -headNode -installdir:"D:\HPCPack2012" -datadir:"D:\HPCPack2012\Data" -MgmtDbDir:"D:\HPCPack2012\Database\Data\ManagementDB" -MgmtDbLogDir:"D:\HPCPack2012\Database\Log\ManagementDB" -SchdDbDir:"D:\HPCPack2012\Database\Data\SchedulerDB" -SchdDbLogDir:"D:\HPCPack2012\Database\Log\SchedulerDB" -ReportingDbDir:"D:\HPCPack2012\Database\Data\ReportingDB" -ReportingDbLogDir:"D:\HPCPack2012\Database\Log\ReportingDB" -DiagDbDir:"D:\HPCPack2012\Database\Data\DiagnosticsDB" -DiagDbLogDir:"D:\HPCPack2012\Database\Log\DiagnosticsDB" -MonDbDir:"D:\HPCPack2012\Database\Data\MonitoringDB" -MonDbLogDir:"D:\HPCPack2012\Database\Log\MonitoringDB" -runtimeShareDirectory:"D:\HPCRuntimeDirectory"
