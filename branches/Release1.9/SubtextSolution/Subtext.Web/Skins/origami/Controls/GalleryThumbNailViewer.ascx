<%@ Control Language="C#" EnableTheming="false" AutoEventWireup="false" 
    Inherits="Subtext.Web.UI.Controls.GalleryThumbNailViewer" TargetSchema="http://schemas.microsoft.com/intellisense/ie5" %>
<div id="gallery">
	<div class="title"><asp:Literal id="GalleryTitle" runat="server" /></div>
	<div class="description"><asp:Literal id="Description" runat="server" /></div>
	<div class="thumbnails">
		<asp:DataList id="ThumbNails" runat="server" RepeatColumns="4" RepeatDirection="Horizontal">
			<ItemTemplate>
				<div class="thumbnail">
					<a href="<%# BaseImagePath + ((Subtext.Framework.Components.Image) Container.DataItem).ResizedFile %>" 
				        title="<%# ((Subtext.Framework.Components.Image) Container.DataItem).Title %>" 
						rel="lightbox[<%# ((Subtext.Framework.Components.Image) Container.DataItem).CategoryID %>]">
				        <img src="<%# BaseImagePath + ((Subtext.Framework.Components.Image) Container.DataItem).ThumbNailFile %>" 
				            alt="<%# ((Subtext.Framework.Components.Image) Container.DataItem).Title %>" />    
				    </a>
				</div>
			</ItemTemplate>
		</asp:DataList>
	</div>
</div>