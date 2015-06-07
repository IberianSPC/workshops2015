<#
    Crea la columna especificada en el XML. Si ya existe la actualiza con la nueva información
#>
Function CreateOrUpdateFieldFromXML {
    param ($FieldXML, $Context)

    $FieldQuery = Get-SPOField -Identity $FieldXML.Name -ErrorAction SilentlyContinue
    Execute-SPOQuery
    
    if($FieldQuery.Id -eq $null) {
      CreateField -FieldXML $FieldXML -Context $Context
      SetFieldProperties -FieldXML $FieldXML -Context $Context        
      Write-Verbose('La columna {0} se creó correctamente' -f $FieldXML.DisplayName)
    } else {     
      Write-Warning('La columna {0} ya existe, actualizando' -f $FieldQuery.Title)
      UpdateFieldInfo -Field $FieldQuery -Context $Context -UpdateInfo $FieldXML
      Write-Verbose('La columna {0} se actualizó correctamente' -f $FieldQuery.Title)
    }
}

<#
    Crea el campo especificado en el XML
#>
Function CreateField {
    param ($FieldXML, $Context)

    # Si es de taxonomía o de Media, llama a las funciónes específicas
    if($FieldXML.FieldType -eq "TaxonomyFieldType") {
        CreateTaxonomyField -FieldXML $FieldXML
    } elseif($FieldXML.FieldType -eq "MediaFieldType"){
        CreateMediaField -FieldXML $FieldXML -Context $Context
    } else {
        Add-SPOField -DisplayName $FieldXML.DisplayName -InternalName $FieldXML.Name -Type $FieldXML.FieldType -Id $FieldXML.Id -Group $FieldXML.Group
    }
}

<#
    Crea el campo de taxonomía cuya información se recibe desde el XML
#>
Function CreateTaxonomyField {
    param ($FieldXML)

    # Sacamos el TermSetPath en el formato que espera el método Add-SPOTaxonomyField 'NombreAlmacen|NombreGrupo'
    $TaxonomyInfo = $FieldXML.SelectSingleNode("TaxonomyFieldType")
    $TermSetName = $TaxonomyInfo.TermSetName
    $TermStoreName = $TaxonomyInfo.TermStoreGroupName
    $TermSetPath = "{0}|{1}" -f $TermStoreName, $TermSetName   

    Add-SPOTaxonomyField -DisplayName $FieldXML.DisplayName -InternalName $FieldXML.Name -Group $FieldXML.Group -Id $FieldXML.Id -TermSetPath $TermSetPath
}

<# 
    Crea el campo de Media. Es necesario utilizar el CSOM puro ya que el PnP no soporta el MediaFieldType 
#>
Function CreateMediaField {
    param ($FieldXML, $Context)
    $Fields = $Context.Site.RootWeb.Fields
    Execute-SPOQuery

    # Añadimos los Assemblies
    [System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SharePoint.Client") | Out-Null
    [System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SharePoint.Client.Runtime") | Out-Null

    # Creamos el XML
    $ReadyXML = "<Field DisplayName='{0}' Name='{1}' ID='{2}' Group='{3}' Type='MediaFieldType' StaticName='{4}'/>" -f $FieldXML.DisplayName, $FieldXML.Name, $FieldXML.Id, $FieldXML.Group, $FieldXML.StaticName
    $Field = $Fields.AddFieldAsXml($ReadyXML, $false, [Microsoft.SharePoint.Client.AddFieldOptions]::AddFieldToDefaultView)
    $Field.Update();
    Execute-SPOQuery
}

<# 
    Añande las propiedades de la columna especificada para aquellas que no permite setear al crearlas
#>
Function UpdateFieldInfo {
    param ($Field, $Context, $UpdateInfo)
        
    $Field.Title = $UpdateInfo.DisplayName
    $Field.Group = $UpdateInfo.Group
    $Field.StaticName = $UpdateInfo.StaticName
    $Field.Hidden = [System.Convert]::ToBoolean($UpdateInfo.Hidden)
    $Field.Required = [System.Convert]::ToBoolean($UpdateInfo.Required)
    $Field.SetShowInDisplayForm([System.Convert]::ToBoolean($UpdateInfo.ShowInDisplayForm))
    $Field.SetShowInEditForm([System.Convert]::ToBoolean($UpdateInfo.ShowInEditForm))
    $Field.SetShowInNewForm([System.Convert]::ToBoolean($UpdateInfo.ShowInNewForm))
    $Field.Update()

    Execute-SPOQuery
}

<#
    Setea las propiedades del campo recién creado
#>
Function SetFieldProperties {
    param ($FieldXML, $Context)

    $Field = Get-SPOField -Identity $FieldXML.Name -ErrorAction SilentlyContinue
    Execute-SPOQuery

    UpdateFieldInfo -Field $Field -Context $Context -UpdateInfo $FieldXML
}

Export-ModuleMember -Function CreateOrUpdateFieldFromXML