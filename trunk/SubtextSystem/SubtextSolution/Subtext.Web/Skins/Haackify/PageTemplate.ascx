<%@ Control %>
<%@ Register TagPrefix="DT" Namespace="Subtext.Web.UI.WebControls" Assembly="Subtext.Web" %>	
<%@ Register TagPrefix="uc1" TagName="Header" Src="Controls/Header.ascx" %>
<%@ Register TagPrefix="uc1" TagName="Footer" Src="Controls/Footer.ascx" %>
<%@ Register TagPrefix="uc1" TagName="BlogStats" Src="Controls/BlogStats.ascx" %>
<%@ Register TagPrefix="uc1" TagName="News" Src="Controls/News.ascx" %>
<%@ Register TagPrefix="uc1" TagName="SingleColumn" Src="Controls/SingleColumn.ascx" %>
<div id="main">
	<div id="background">
		<uc1:Header id="Header1" runat="server"></uc1:Header>
		<div id="content">
			<div id="adwrap">
				<p id="ad">
					<!-- //TODO: Put a Google Ad Control here (to be built) -->
				</p>
			</div> <!-- end google ad -->

			
			<DT:contentregion id="MPMain" runat="server"></DT:contentregion>
			
		</div> <!-- end #content -->
		
		<div id="sidebar">
			<div>
				<asp:HyperLink ImageUrl="~/skins/Haackify/images/rss20icon.gif" Runat="server" NavigateUrl="~/Rss.aspx"  Title="RSS 2.0" ID="XMLLink">RSS 2.0 Feed</asp:HyperLink><asp:HyperLink Runat="server" NavigateUrl="~/Rss.aspx" ID="Syndication" Title="RSS 2.0" /><br />
				<asp:HyperLink ImageUrl="~/images/PoweredBySubtext85x33.png" Runat="server" NavigateUrl="http://subtextproject.com/" ID="PoweredByLink" Title="Powered By Subtext"></asp:HyperLink>
			</div>
			<div>
<!-- Start of Flickr Badge -->
				<!-- //TODO: Flickr Badge Control -->
<!-- End of Flickr Badge -->
			</div>

			<uc1:SingleColumn id="SingleColumn1" runat="server"></uc1:SingleColumn>
		</div>
				
		<div class="clear">&nbsp;</div>	
	</div> <!-- end #background -->
	<div id="bottom"></div>
	<uc1:Footer id="Footer1" runat="server"></uc1:Footer>
</div> <!-- end #main -->