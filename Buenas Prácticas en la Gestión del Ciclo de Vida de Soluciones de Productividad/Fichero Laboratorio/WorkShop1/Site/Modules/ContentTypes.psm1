<# 
    Esta función creará los ContentTypes que indiquen los XML que existan en la carpeta especificada 
#>
Function CreateContentTypes {    
    param ($RootFolder, $UrlSPOnline)

    Connect-SPOnline -Url $UrlSPOnline –Credentials premise -ErrorAction Stop
    $Context = Get-SPOContext

    # Obtenemos todos los ficheros .xml que comiencen por ContentTypes
    Get-ChildItem ('{0}\' -f $RootFolder) -Filter ContentTypes*.xml | `
    ForEach-Object{        
        # Por cada uno de ellos, recorremos todos los nodos Add y añadimos o actualizamos los tipos de contenido especificados
        [xml]$XML = Get-Content $_
        $ContentTypeDefinition = $XML.SelectNodes("/Site/ContentTypes/Add")
        
        foreach( $ContentType in $ContentTypeDefinition) {
            $ContentTypeQuery = Get-SPOContentType -Identity $ContentType.Name
            Execute-SPOQuery
            if($ContentTypeQuery.Id -eq $null) {
                Add-SPOContentType -Name $ContentType.Name -ContentTypeId $ContentType.ID -Group $ContentType.Group -Description $ContentType.Description
                Write-Verbose("El tipo de contenido {0} se creó correctamente, añadiendo columnas" -f $ContentType.Name)                
            } else {
                Write-Verbose("El tipo de contenido {0} ya existe, actualizando" -f $ContentType.Name);
                UpdateContentTypes -Context $Context -ContentTypeXML $ContentType
            }
            
            # Exista o no, se le añaden las columnas de sitio
            Add-FieldsToContentType -ContentTypeXML $ContentType        
        }
    }
}

<#
    Actualiza las propiedades de los tipos de contenido susceptibles de ser actualizadas
#>
Function UpdateContentTypes {
    param ($Context, $ContentTypeXML)
    
    $ContentType = Get-SPOContentType -Identity $ContentTypeXML.Id
    Execute-SPOQuery
    
    # Obtenemos y actualizamos el Name para utilizar el DisplayName
    $DisplayName = $ContentTypeXML.SelectSingleNode('//DisplayName').Value

    $ContentType.Name = $DisplayName
    $ContentType.Description = $ContentTypeXML.Description
    $ContentType.Group = $ContentTypeXML.Group

    $ContentType.Update($true)
    Execute-SPOQuery
}

<#
    Añade los campos específicados en el XML al content type también especificado en el XML
#>
Function Add-FieldsToContentType {
    param ($ContentTypeXML)
    
    $CamposAAgregar = $ContentTypeXML.SelectNodes("//Fields/Add")
    foreach($Campo in $CamposAAgregar) {
        Add-SPOFieldToContentType -Field $Campo.InternalName -ContentType $ContentTypeXML.Name
        Write-Verbose("Columna {0} añadida con éxito" -f $Campo.InternalName)
    }
}

Export-ModuleMember -Function CreateContentTypes