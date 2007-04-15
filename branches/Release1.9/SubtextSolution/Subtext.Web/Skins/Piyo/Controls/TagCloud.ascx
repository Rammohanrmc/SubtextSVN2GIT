<%@ Control Language="c#" Inherits="Subtext.Web.UI.Controls.TagCloud" %>
<%@ Import Namespace = "Subtext.Framework" %>

<asp:Repeater Runat="server" ID="Tags" OnItemDataBound="Tags_ItemDataBound">
	<HeaderTemplate>
	<div>
		<h5>Tag Cloud</h5>
			<ul id="tag-cloud">
	</HeaderTemplate>
	<ItemTemplate>
		<li>
			<asp:HyperLink  Runat="server" ID="TagUrl" CssClass='<%# Eval("Weight", "tag-style-{0} tag-item") %>' 
				Text='<%# UrlDecode(Eval("TagName")) %>' ToolTip='<%# Eval("Count") %>'/>
		</li>
	</ItemTemplate>
	<FooterTemplate>
		</ul>
	</div>
	</FooterTemplate>
</asp:Repeater>
