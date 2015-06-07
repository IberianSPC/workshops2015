# Cambiar a 'SilentlyContinue' si no queremos información sobre el progreso del Script
$VerbosePreference = 'Continue'

# Cargamos los módulos necesarios
Import-Module ("{0}/Modules/SiteColumn.psm1" -f $PSScriptRoot) -Force
Import-Module ("{0}/Modules/ContentTypes.psm1" -f $PSScriptRoot) -Force
Import-Module ("{0}/Modules/Sites.psm1" -f $PSScriptRoot) -Force
Import-Module ("{0}/Modules/ListsDocLibs.psm1" -f $PSScriptRoot) -Force


# -- Obtencion de Conexion y Contexto, si no se conecta, por el motivo que sea, paramos el Script
$UrlSPOnline = "https://adriandiaz.sharepoint.com/sites/becario1/"
Connect-SPOnline -Url $UrlSPOnline –Credentials premise -ErrorAction Stop
$Context = Get-SPOContext

# -- Creación de las columnas de sitio a partir del XML especificado
[xml]$Xml = Get-Content -Path ('{0}/SiteColumns.xml' -f $PSScriptRoot)
$Campos = $Xml.SelectNodes("//Add")
foreach($Campo in $Campos) {        
    CreateOrUpdateFieldFromXML -FieldXML $Campo -Context $Context     
}
Execute-SPOQuery

# -- Creación de los ContentTypes
CreateContentTypes -RootFolder $PSScriptRoot -UrlSPOnline $UrlSPOnline

# -- Creacion de subsitios
CreateSitesAndSubSites -SiteRoot $PSScriptRoot -UrlSPOnline $UrlSPOnline

# -- Creación de listas y bibliotecas
CreateListOrDocLib -RootFolder $PSScriptRoot -UrlSPOnline $UrlSPOnline

