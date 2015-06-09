<%-- SPG:

Este archivo HTML se ha asociado a un diseño de página de SharePoint (archivo .aspx) del mismo nombre. Mientras los archivos estén asociados, no podrá editar el archivo .aspx y las operaciones de cambio de nombre, movimiento o eliminación serán recíprocas.

Para elaborar el diseño de página directamente desde este archivo HTML, solo tiene que rellenar el contenido de los marcadores de posición de contenido. Utilice el Generador de fragmentos de código, en https://sporras.sharepoint.com/_layouts/15/ComponentHome.aspx?Url=https%3A%2F%2Fsporras%2Esharepoint%2Ecom%2F%5Fcatalogs%2Fmasterpage%2FHomeLayout%2Easpx, para crear y personalizar marcadores de posición de contenido adicionales además de otras entidades útiles de SharePoint. A continuación, copie y péguelos como fragmentos de código HTML en el código HTML. Los cambios realizados en los marcadores de posición de contenido de este archivo se sincronizarán automáticamente con el diseño de página asociado.

 --%>
<%@Page language="C#" Inherits="Microsoft.SharePoint.Publishing.PublishingLayoutPage, Microsoft.SharePoint.Publishing, Version=16.0.0.0, Culture=neutral, PublicKeyToken=71e9bce111e9429c" %>
<%@Register TagPrefix="SharePoint" Namespace="Microsoft.SharePoint.WebControls" Assembly="Microsoft.SharePoint, Version=16.0.0.0, Culture=neutral, PublicKeyToken=71e9bce111e9429c"%>
<%@Register TagPrefix="PageFieldFieldValue" Namespace="Microsoft.SharePoint.WebControls" Assembly="Microsoft.SharePoint, Version=16.0.0.0, Culture=neutral, PublicKeyToken=71e9bce111e9429c"%>
<%@Register TagPrefix="Publishing" Namespace="Microsoft.SharePoint.Publishing.WebControls" Assembly="Microsoft.SharePoint.Publishing, Version=16.0.0.0, Culture=neutral, PublicKeyToken=71e9bce111e9429c"%>
<%@Register TagPrefix="WebPartPages" Namespace="Microsoft.SharePoint.WebPartPages" Assembly="Microsoft.SharePoint, Version=16.0.0.0, Culture=neutral, PublicKeyToken=71e9bce111e9429c"%>
<asp:Content runat="server" ContentPlaceHolderID="PlaceHolderPageTitle">
            <SharePoint:ProjectProperty Property="Title" runat="server">
            </SharePoint:ProjectProperty>
            
            
            <PageFieldFieldValue:FieldValue FieldName="fa564e0f-0c70-4ab9-b863-0177e6ddd247" runat="server">
            </PageFieldFieldValue:FieldValue>
            
        </asp:Content><asp:Content runat="server" ContentPlaceHolderID="PlaceHolderAdditionalPageHead">
            
            
            
            <Publishing:EditModePanel runat="server" id="editmodestyles">
                <SharePoint:CssRegistration name="&lt;% $SPUrl:~sitecollection/Style Library/~language/Themable/Core Styles/editmode15.css %&gt;" After="&lt;% $SPUrl:~sitecollection/Style Library/~language/Themable/Core Styles/pagelayouts15.css %&gt;" runat="server">
                </SharePoint:CssRegistration>
            </Publishing:EditModePanel>
            
        </asp:Content><asp:Content runat="server" ContentPlaceHolderID="PlaceHolderPageTitleInTitleArea">
            
            
            <PageFieldFieldValue:FieldValue FieldName="fa564e0f-0c70-4ab9-b863-0177e6ddd247" runat="server">
            </PageFieldFieldValue:FieldValue>
            
        </asp:Content><asp:Content runat="server" ContentPlaceHolderID="PlaceHolderMain">

        <section id="section-container">
            <div class="content">
                <div class="content-top">
                    <div data-name="WebPartZone">
                        
                        
                        <div>
                            <WebPartPages:WebPartZone runat="server" ID="TopContentZone" AllowPersonalization="False" FrameType="TitleBarOnly" Orientation="Vertical">
                            <ZoneTemplate>
                            
                            </ZoneTemplate>
                            </WebPartPages:WebPartZone>
                        </div>
                        
                    </div>
                </div>
                <div class="content-bottom">
                    <div data-name="WebPartZone">
                        
                        
                        <div>
                            <WebPartPages:WebPartZone runat="server" ID="BottomContentZone" AllowPersonalization="False" FrameType="TitleBarOnly" Orientation="Vertical">
                            <ZoneTemplate>
                            
                            </ZoneTemplate>
                            </WebPartPages:WebPartZone>
                        </div>
                        
                    </div>
                </div>
            </div>
            <aside class="home-aside">
                <div data-name="WebPartZone">
                    
                    
                    <div>
                        <WebPartPages:WebPartZone runat="server" ID="AsideZone" AllowPersonalization="False" FrameType="TitleBarOnly" Orientation="Vertical">
                        <ZoneTemplate>
                        
                        </ZoneTemplate>
                        </WebPartPages:WebPartZone>
                    </div>
                    
                </div>
            </aside>
        </section>

        </asp:Content>