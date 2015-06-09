#Clean screen
#-------------------------------------------------
cls

#import modules to connect azure instance
#-------------------------------------------------
import-module "C:\Program Files (x86)\Microsoft SDKs\Azure\PowerShell\ServiceManagement\Azure\Azure.psd1"
Import-AzurePublishSettingsFile "D:\MVPEvents\IberianSharePointConference2015\Workshop\Desarrollo-pruebas de MSDN - Pago por uso-Windows Azure MSDN - Visual Studio Ultimate-6-7-2015-credentials.publishsettings"
Set-AzureSubscription -SubscriptionName "Windows Azure MSDN - Visual Studio Ultimate" -CurrentStorageAccountName "storageiberianspconf"
Select-AzureSubscription -SubscriptionName "Windows Azure MSDN - Visual Studio Ultimate"

#specify the Domain Controller DNS IP to 10.1.1.4 and VM Name
$myVMDNS = new-azuredns -Name "IberianSPConfDNS01" -IPAddress "10.1.1.4"
$vmName = "IberianSPConfSP01"

#OS Image to use
$image = "a699494373c04fc0bc8f2bb1389d6106__Windows-Server-2012-Datacenter-201505.01-en.us-127GB.vhd"
$service = "IberianSPConfWS01Svc"
$ag = "IberianSPConfAF"
$vnet = "iberianspconfnet"
$adminlocal = "iberianadmin"
$domainuser = "iberianadmin"
$password = "iberianspconf123*."
$size = "A5"
$netbiosname = "iberianspconf"
$domainname = "iberianspconf.local"
$subnetback = "BACKEND"

$myVM = (New-AzureVMConfig -Name $vmName -InstanceSize $size -ImageName $image | 
Add-AzureProvisioningConfig -WindowsDomain -AdminUsername $adminlocal -Password $password -Domain $netbiosname -DomainUserName $domainuser -DomainPassword $password -JoinDomain $domainname | 
Set-AzureSubnet -SubnetNames $subnetback);

New-AzureVM -ServiceName $service -VMs $myVM -AffinityGroup $ag -DnsSettings $myVMDNS -VNetName $vnet;