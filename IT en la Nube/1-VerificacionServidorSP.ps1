$ComputerSystem = @{Expression={"{0:N2}" -f ($_.Totalphysicalmemory/1GB)};Label="RAM (GB)"}, `@{Expression={$_.SystemType};Label="Processor Type"}, `@{Expression={$_.NumberOfLogicalProcessors};Label="# of Processors"}
cls
echo "***   Test Server Configuration before Install of SharePoint 2013   ***"
echo ""
echo "Processor Type = x64"
echo "Minimum Processors = 4"
echo "Minimum RAM = 8GB"
echo "Minimum System Drive Size = 80GB"
echo ""
GWMI Win32_ComputerSystem | FT $ComputerSystem -AutoSize
Get-PSDrive C 