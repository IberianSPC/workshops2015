#Clean screen
#-------------------------------------------------
cls

#import modules to connect azure instance
#-------------------------------------------------
import-module "C:\Program Files (x86)\Microsoft SDKs\Azure\PowerShell\ServiceManagement\Azure\Azure.psd1"
Import-AzurePublishSettingsFile "D:\MVPEvents\IberianSharePointConference2015\Workshop\Desarrollo-pruebas de MSDN - Pago por uso-Windows Azure MSDN - Visual Studio Ultimate-6-7-2015-credentials.publishsettings"
Set-AzureSubscription -SubscriptionName "Windows Azure MSDN - Visual Studio Ultimate" -CurrentStorageAccountName "storageiberianspconf"
Select-AzureSubscription -SubscriptionName "Windows Azure MSDN - Visual Studio Ultimate"

#Deploy the domain controller in a virtual network
#-------------------------------------------------

#specify the Domain Controller DNS IP to 127.0.0.1 and VM Name
$myDNS = new-azuredns -Name "IberianSPConfDNS01" -IPAddress "127.0.0.1"
$vmName = "IberianSPConfDC01"

#OS Image to use
$image = "a699494373c04fc0bc8f2bb1389d6106__Windows-Server-2012-Datacenter-201505.01-en.us-127GB.vhd"
$service = "IberianSPConfDC01Svc"
$ag = "IberianSPConfAF"
$vnet = "iberianspconfnet"
$localadmin = "iberianadmin"
$localadminpass = "iberianspconf123*."
$size = "A5"
$subnetback = "BACKEND"

$myDC = New-AzureVMConfig -Name $vmName -InstanceSize $size -ImageName $image | Add-AzureProvisioningConfig -Windows -AdminUsername $localadmin -Password $localadminpass | Set-AzureSubnet -SubnetNames $subnetback
New-AzureVM -ServiceName $service -VMs $myDC -AffinityGroup $ag -DnsSettings $myDNS -VNetName $vnet
