#   Configure SharePoint Databases
$Key=(1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24)
$FarmPassword = ConvertTo-SecureString -String "123.abc*" -AsPlainText -Force
$SecureUser = "dominio\usuario"
$SecurePassword = Cat c:\Labfiles\Password.txt | ConvertTo-SecureString -Key $Key
$FarmCredentials = New-Object –TypeName System.Management.Automation.PSCredential –ArgumentList $SecureUser, $SecurePassword

echo "Please wait while the SharePoint Databases are configured ..."
Add-PSSnapin Microsoft.SharePoint.PowerShell
New-SPConfigurationDatabase -DatabaseServer sharecolsql01 -DatabaseName "Iberian_SharePoint_Config" -AdministrationContentDatabaseName “Iberian_SharePoint_Content” -Passphrase $FarmPassword -FarmCredentials $FarmCredentials -Verbose

#   Enable SharePoint Features, Services, Applications and Help resources.
Install-SPFeature -AllExistingFeatures -Force -Verbose
Initialize-SPResourceSecurity
Install-SPService 
Install-SPApplicationContent
Install-SPHelpCollection –All

#Configure Web Application
Stop-Service SPTimerV4 -Force -Verbose
Start-Sleep 5
Get-ChildItem C:\ProgramData\Microsoft\SharePoint\Config -Force -Recurse -Include *.ini | Remove-Item -Force
Start-Service SPTimerV4 -Verbose
Start-Sleep 5
New-SPCentralAdministration -Port 27000 -WindowsAuthProvider "NTLM" -Verbose
New-SPWebApplication -Name "Iberian Intranet" -ApplicationPool "Iberian Intranet" -ApplicationPoolAccount "dominio\usuario" -Port 28000 -DatabaseName "Iberian_Intranet_Content" -Verbose
New-SPSite http://sharecolws01:28000/ -OwnerAlias dominio\usuario -Name "Iberian Intranet Team Site" -Template "STS#0"
New-SPWeb http://sharecolws01:28000/Search -Template "STS#1"
New-NetFirewallRule -Name "SP Iberian Intranet" -DisplayName "SP Iberian Intranet:28000" -Action Allow -Direction Inbound -LocalPort 28000 -Protocol TCP -Group SharePoint -ErrorAction SilentlyContinue