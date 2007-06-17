<%@ Control Language="C#" EnableTheming="false"  Inherits="Subtext.Web.UI.Controls.Day" %>
<%@ Import Namespace = "Subtext.Framework" %>
<h4 class="daytitle">
	<asp:HyperLink Runat="server" height="15" Width="250" BorderWidth="0" ID="ImageLink"> <asp:Literal ID = "DateTitle" Runat = "server" /></asp:HyperLink>		  
</h4>

<asp:Repeater runat="Server" ID="DayList" OnItemCreated="PostCreated">
	<HeaderTemplate>
		<div class="journal_eintrag">
	</HeaderTemplate>
	<ItemTemplate>
			<h2>
				<asp:HyperLink Runat="server" ID="editLink" /> <asp:HyperLink  CssClass="posttitle" Runat="server" ID="TitleUrl" />
			</h2>
			<asp:Literal  runat="server" ID="PostText" />
			
			<p class="postfooter">
				Author: <asp:Literal ID="Literal1" runat="server" Text="<%# Entry(Container.DataItem).Author.UserName  %>" /> 
				<asp:Literal id="PostDesc"  runat="server" />
			</p>
	</ItemTemplate>
	<FooterTemplate>
		</div>
	</FooterTemplate>
</asp:Repeater>