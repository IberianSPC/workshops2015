echo off
cls
echo "*****     Installed PreRequisite Applications for SharePoint 2013 on $Env:ComputerName     *****"
Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* `
| Where {$_.DisplayName -like "*AppFabric*" -or $_.DisplayName -like "*Microsoft Identity*" `
-or $_.DisplayName -like "*SQL Server 2008 R2*" -or $_.DisplayName -like "*Microsoft Sync*" `
-or $_.DisplayName -like "*Rights Management Services*"} `
| Sort DisplayName | FT DisplayName, DisplayVersion;
Get-ItemProperty HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\* `
| Where {$_.DisplayName -like "WCF Data Services 5.0 (OData*"} `
| sort displayname | FT DisplayName, DisplayVersion;

echo "*****     Installed Updates for SharePoint 2013 on $Env:ComputerName     *****"
Get-HotFix;
