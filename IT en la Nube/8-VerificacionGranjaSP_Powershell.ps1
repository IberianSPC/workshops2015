Add-PSSnapin Microsoft.SharePoint.PowerShell
cls
echo "*****     Get Information About The Version of SharePoint Installed     *****"
pause
Get-SPProduct | FL *
echo ...
echo "*****     Get SharePoint Farm Name     *****"
pause
Get-SPFarm | FT -Auto
echo ...
echo "*****     Get Information about SharePoint Web Applications     *****"
pause
Get-SPWebApplication -IncludeCentralAdministration | FT -Auto
echo ...
echo "*****     Get Information about SharePoint Databases     *****"
pause
Get-SPDatabase | FT -Auto
echo ...
echo "*****     Get Information about Installed SharePoint Features     *****"
pause
Get-SPFeature | FT -Auto
