<#
    Esta función crea un Lista o una biblioteca de documentos dependiendo de la información contenida en el manifest.xml
#>
Function CreateListOrDocLib {
    param($Context, $RootFolder, $UrlSPOnline)

    Get-ChildItem -Path $RootFolder -Filter manifest.xml -Recurse | `
    Where-Object {$_.DirectoryName -like '*LIST-*' -OR $_.DirectoryName -like '*DOCLIB-*' -and $_.DirectoryName -notlike '*PAGE-*' -and $_.DirectoryName -notlike '*ITEM*'} | `
    ForEach-Object {
        Connect-SPOnline -Url $UrlSPOnline –Credentials premise -ErrorAction Stop
        $Context = Get-SPOContext

        [xml]$ListManifest = Get-Content -Path ('{0}/manifest.xml' -f $_.Directory)    
        $Lists = $ListManifest.SelectNodes('/List[not(@EnableRating)]')
        $DocLibs = $ListManifest.SelectNodes('/List[@EnableRating]')
        
        $Web = GetListWeb -Context $Context -RootFile $_                   

        foreach($List in $Lists) {
            CreateList -List $List -Web $Web
            UpdateListOrDocLibInfo -ListOrDocLib $List -Context $Context -Web $Web
            AddContentTypeToList -ListManifest $List -WebCT $Web            
        }

        foreach($DocLib in $DocLibs) {
            CreateDocLibs -Library $DocLib -Web $Web
            UpdateListOrDocLibInfo -ListOrDocLib $DocLib -Context $Context -Web $Web            
            AddContentTypeToList -ListManifest $DocLib -WebCT $Web
        }
    }
}

<#
    Obtiene la Web a la que está asociada la lista. Es necesario usar full CSOM ya que con el método de PnP no funciona bien
#>
Function GetListWeb {
    param($Context, $RootFile)    
       
    [xml]$WebManifest = Get-Content -Path ('{0}/manifest.xml' -f $RootFile.Directory.Parent.FullName)
    $SiteUrl = $WebManifest.SelectSingleNode('//RelativeUrl').'#text'

    if($SiteUrl -eq '/') {
        $Web = $Context.Site.RootWeb
    } else {
        $Web = $Context.Site.OpenWeb('/sites/sareb{0}' -f $SiteUrl)
    }
    $Context.Load($Web)            
    
    return $Web    
}

<#
    Crea la lista que se le suministra
#>
Function CreateList {
    param($List, $Web)
    
    $ListQuery = Get-SPOList -Identity $List.Name -ErrorAction SilentlyContinue -Web $Web
    Execute-SPOQuery
    
    if($ListQuery -eq $null) {
        New-SPOList -Title $List.Name -Url $List.Url -Template GenericList -Web $Web       
        Write-Verbose('La lista {0} se creó correctamente' -f $List.Name)
    } else {
        Write-Verbose('La lista {0} ya existe' -f $List.Name)
    }    
}

<#
    Crea la biblioteca que se le suminstra
#>
Function CreateDocLibs {
    param($Library, $Web)
    
    $LibraryQuery = Get-SPOList -Identity $Library.Name -ErrorAction SilentlyContinue -Web $Web
    Execute-SPOQuery
    
    if($LibraryQuery -eq $null) {
        New-SPOList -Title $Library.Name -Url $Library.Url -Template DocumentLibrary -Web $Web
        Write-Verbose('La biblioteca {0} se creó correctamente' -f $List.Name)
    } else {
        Write-Verbose('La biblioteca {0} ya existe' -f $List.Name)
    } 
}

<#
    Actualiza la información susceptible de actualizarse utilizando el fichero XML suminsitrado
#>
Function UpdateListOrDocLibInfo {
    param($ListOrDocLib, $Context, $Web)    

    Write-Verbose('Actualizando {0}' -f $ListOrDocLib.Name)

    #Obtenemos la lista
    $List = Get-SPOList -Identity $ListOrDocLib.Name -Web $Web
    Execute-SPOQuery
   
    # A veces no funciona y no se porque. Dice que la lista o biblioteca no tiene la propiedad Description
    $List.Description = $ListOrDocLib.Description

    <# 
       Si la lista es una biblioteca de documentos, actualizamos la propiedad EnableModeration.
       Esto a veces no funciona, dice que la lista o biblioteca no tiene esta propiedad y no se porque.
       También sería el lugar correcto para setear EnableRating, pero el CSOM no permite cambiarla.
    #>
    if(!($ListOrDocLib.EnableModeration -eq $null)) {
        $List.EnableModeration = [System.Convert]::ToBoolean($ListOrDocLib.EnableModeration)        
    }

    $List.Update()
    Execute-SPOQuery
}

<#
    Añade el contentipo especificado a la lista especificada
#>
Function AddContentTypeToList {
    param($ListManifest, $WebCT)

    $ContentTypes = $ListManifest.SelectNodes('//ContentType')
    Write-Verbose('Agregando tipos de contenido a {0}' -f $ListManifest.Name)
    foreach($ContentType in $ContentTypes) {        
        Add-SPOContentTypeToList -List $ListManifest.Name -ContentType $ContentType.Name -Web $WebCT
        Write-Verbose('Tipo de contenido {0} agragado con éxito' -f $ContentType.Name)
    }    
}