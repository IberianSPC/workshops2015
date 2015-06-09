<%-- SPG:

Este archivo HTML se ha asociado a un diseño de página de SharePoint (archivo .aspx) del mismo nombre. Mientras los archivos estén asociados, no podrá editar el archivo .aspx y las operaciones de cambio de nombre, movimiento o eliminación serán recíprocas.

Para elaborar el diseño de página directamente desde este archivo HTML, solo tiene que rellenar el contenido de los marcadores de posición de contenido. Utilice el Generador de fragmentos de código, en https://sporras.sharepoint.com/_layouts/15/ComponentHome.aspx?Url=https%3A%2F%2Fsporras%2Esharepoint%2Ecom%2F%5Fcatalogs%2Fmasterpage%2FNewsLayout%2Easpx, para crear y personalizar marcadores de posición de contenido adicionales además de otras entidades útiles de SharePoint. A continuación, copie y péguelos como fragmentos de código HTML en el código HTML. Los cambios realizados en los marcadores de posición de contenido de este archivo se sincronizarán automáticamente con el diseño de página asociado.

 --%>
<%@Page language="C#" Inherits="Microsoft.SharePoint.Publishing.PublishingLayoutPage, Microsoft.SharePoint.Publishing, Version=16.0.0.0, Culture=neutral, PublicKeyToken=71e9bce111e9429c" %>
<%@Register TagPrefix="SharePoint" Namespace="Microsoft.SharePoint.WebControls" Assembly="Microsoft.SharePoint, Version=16.0.0.0, Culture=neutral, PublicKeyToken=71e9bce111e9429c"%>
<%@Register TagPrefix="PageFieldFieldValue" Namespace="Microsoft.SharePoint.WebControls" Assembly="Microsoft.SharePoint, Version=16.0.0.0, Culture=neutral, PublicKeyToken=71e9bce111e9429c"%>
<%@Register TagPrefix="Publishing" Namespace="Microsoft.SharePoint.Publishing.WebControls" Assembly="Microsoft.SharePoint.Publishing, Version=16.0.0.0, Culture=neutral, PublicKeyToken=71e9bce111e9429c"%>
<%@Register TagPrefix="PageFieldTextField" Namespace="Microsoft.SharePoint.WebControls" Assembly="Microsoft.SharePoint, Version=16.0.0.0, Culture=neutral, PublicKeyToken=71e9bce111e9429c"%>
<%@Register TagPrefix="PageFieldDateTimeField" Namespace="Microsoft.SharePoint.WebControls" Assembly="Microsoft.SharePoint, Version=16.0.0.0, Culture=neutral, PublicKeyToken=71e9bce111e9429c"%>
<%@Register TagPrefix="PageFieldRichImageField" Namespace="Microsoft.SharePoint.Publishing.WebControls" Assembly="Microsoft.SharePoint.Publishing, Version=16.0.0.0, Culture=neutral, PublicKeyToken=71e9bce111e9429c"%>
<%@Register TagPrefix="PageFieldRichHtmlField" Namespace="Microsoft.SharePoint.Publishing.WebControls" Assembly="Microsoft.SharePoint.Publishing, Version=16.0.0.0, Culture=neutral, PublicKeyToken=71e9bce111e9429c"%>
<asp:Content runat="server" ContentPlaceHolderID="PlaceHolderAdditionalPageHead">
            
            
            
            <Publishing:EditModePanel runat="server" id="editmodestyles">
                <SharePoint:CssRegistration name="&lt;% $SPUrl:~sitecollection/Style Library/~language/Themable/Core Styles/editmode15.css %&gt;" After="&lt;% $SPUrl:~sitecollection/Style Library/~language/Themable/Core Styles/pagelayouts15.css %&gt;" runat="server">
                </SharePoint:CssRegistration>
            </Publishing:EditModePanel>
            
            <link rel="stylesheet" href="/_catalogs/masterpage/branding-demo/styles/custom/news.css" />
        </asp:Content><asp:Content runat="server" ContentPlaceHolderID="PlaceHolderPageTitleInTitleArea">
            
            
            <PageFieldFieldValue:FieldValue FieldName="fa564e0f-0c70-4ab9-b863-0177e6ddd247" runat="server">
            </PageFieldFieldValue:FieldValue>
            
        </asp:Content><asp:Content runat="server" ContentPlaceHolderID="PlaceHolderMain">
            <section id="section-container" class="new-details">
                <div class="new-title">
                	<h1>
						<PageFieldTextField:TextField FieldName="fa564e0f-0c70-4ab9-b863-0177e6ddd247" runat="server" />
                   </h1>
                </div>
                <div>
                    <span class="new-author" data-name="Campo de página: Documento creado por">
                        <PageFieldTextField:TextField FieldName="4dd7e525-8d6b-4cb4-9d3e-44ee25f973eb" runat="server" />
                    </span>
                    <span class="new-date">
                        
                        
                        <PageFieldDateTimeField:DateTimeField FieldName="71316cea-40a0-49f3-8659-f0cefdbdbd4f" runat="server">
                        
                        </PageFieldDateTimeField:DateTimeField>
                        
                    </span>
                </div>
                <div class="new-subtitle">
                	<h3>
                    
                    
                    <PageFieldTextField:TextField FieldName="d3429cc9-adc4-439b-84a8-5679070f84cb" runat="server">
                    
                    </PageFieldTextField:TextField>
                    
                    </h3>
                </div>
                <div class="new-picture">
                    
                    
                    <PageFieldRichImageField:RichImageField FieldName="3de94b06-4120-41a5-b907-88773e493458" runat="server">
                    
                    </PageFieldRichImageField:RichImageField>
                    
                </div>
                <div class="new-content">
                    
                    
                    <PageFieldRichHtmlField:RichHtmlField FieldName="f55c4d88-1f2e-4ad9-aaa8-819af4ee7ee8" runat="server">
                    
                    </PageFieldRichHtmlField:RichHtmlField>
                    
                </div>

            </section>
            </asp:Content><asp:Content runat="server" ContentPlaceHolderID="PlaceHolderPageTitle">
            <SharePoint:ProjectProperty Property="Title" runat="server">
            </SharePoint:ProjectProperty>
            
            
            <PageFieldFieldValue:FieldValue FieldName="fa564e0f-0c70-4ab9-b863-0177e6ddd247" runat="server">
            </PageFieldFieldValue:FieldValue>
            
        </asp:Content>