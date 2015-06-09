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

#specify the Domain Controller DNS IP to 10.1.1.4 and VM Name
$myVMDNS = new-azuredns -Name "IberianSPConfDNS01" -IPAddress "10.1.1.4"
$vmName = "IberianSPConfSQL01"

#OS Image to use
$image = "fb83b3509582419d99629ce476bcb5c8__SQL-Server-2012-SP2-11.0.5569.0-Ent-ENU-Win2012-cy15su04"
$service = "IberianSPConfSQL01Svc"
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
