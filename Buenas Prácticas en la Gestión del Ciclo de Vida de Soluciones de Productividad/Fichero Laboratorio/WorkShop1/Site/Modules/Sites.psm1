<#
    Crea sitios y subsitios dependiendo del fichero manifest que encuentre en las carpetas de cada web
#>
Function CreateSitesAndSubSites {
    param ($SiteRoot, $UrlSPOnline, $ParentSiteUrl)  
    
    Get-ChildItem -Path $SiteRoot | Where-Object{$_.BaseName -like '*WEB-*'} | `
    ForEach-Object {
        Connect-SPOnline -Url $UrlSPOnline –Credentials premise -ErrorAction Stop
        $Context = Get-SPOContext
                    
        [xml]$SiteXml = Get-Content -Path ('{0}/manifest.xml' -f $_.FullName)
        $SiteProperties = $SiteXml.Site
        
        # Hacemos un substring de la url relativa para obtener el leafUrl
        $ForwardSlashIndex = $SiteProperties.RelativeUrl.LastIndexOf('/') + 1
        $SiteUrl = $SiteProperties.RelativeUrl.Substring($ForwardSlashIndex)
        
        # Distingue entre la creación de un sitio y la de un subsitio mediante el parametro ParentSiteUrl
        if($ParentSiteUrl -eq $null) {
            CreateSite -SiteProperties $SiteProperties -SiteUrl $SiteUrl
        } else {
            CreateSubSite -SiteUrl $SiteUrl -ParentSiteUrl $ParentSiteUrl -SiteProperties $SiteProperties 
        }      
                
        $Features = $SiteXml.SelectNodes('//Feature')        
       # Set-SPOMasterPage -MasterPageUrl '/sites/sareb/_catalogs/masterpage/oslo.master' -CustomMasterPageUrl '/sites/sareb/_catalogs/masterpage/oslo.master' -Web $SiteUrl
        
        # Llamada recursiva añadiendo el parametro ParentSiteUrl para diferenciar la creacion de subsitios
        CreateSitesAndSubSites -SiteRoot $_.FullName -Context $Context -ParentSiteUrl $SiteUrl
     }  
}

<#
    Crea un subsitio utilizando la url extraida del manifest y la url del padre que le pasemosS
#>
Function CreateSubSite {
    param($SiteUrl, $ParentSiteUrl, $SiteProperties)

    $ParentQuery = Get-SPOWeb -Identity $ParentSiteUrl
    $WebQuery = Get-SPOWeb -Identity $SiteUrl    
    if($WebQuery -eq $null) {
        New-SPOWeb -Title $SiteProperties.Name -Url $SiteUrl -Description $SiteProperties.Description -Locale $SiteProperties.Language -Template $SiteProperties.Template -Web $ParentQuery
    } else {
        Write-Warning('El sitio ya existe. Actualizando Master Pages, creando subsitio')
    }
}

<#
    Crea un subsitio utilizando la url extraida del manifest
#>
Function CreateSite {
    param ($SiteProperties, $SiteUrl)

    $WebQuery = Get-SPOWeb -Identity $SiteUrl
    if($WebQuery -eq $null) {
        New-SPOWeb -Title $SiteProperties.Name -Url $SiteUrl -Description $SiteProperties.Description -Locale $SiteProperties.Language -Template $SiteProperties.Template
    } else {
        Write-Warning('El sitio ya existe. Actualizando Master Pages, creando subsitio')
    }
}

Export-ModuleMember -Function CreateSitesAndSubSites