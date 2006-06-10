<%@ Control %>
<%@ Register TagPrefix="sub" Namespace="Subtext.Web.UI.WebControls" Assembly="Subtext.Web" %>
<%@ Register TagPrefix="uc1" TagName="Header" Src="Controls/Header.ascx" %>
<%@ Register TagPrefix="uc1" TagName="Footer" Src="Controls/Footer.ascx" %>
<%@ Register TagPrefix="uc1" TagName="BlogStats" Src="Controls/BlogStats.ascx" %>
<%@ Register TagPrefix="uc1" TagName="AboutMe" Src="Controls/News.ascx" %>
<%@ Register TagPrefix="uc1" TagName="SingleColumn" Src="Controls/SingleColumn.ascx" %>
<div id="main">
		<div id="top"></div>
		<div id="header">
			<uc1:Header id="Header1" runat="server"></uc1:Header>
		</div>
		
		<div id="mainbody">
			<div id="content">
				<div id="adwrap">
					<p id="ad">
						<!-- //TODO: Put a Google Ad Control here (to be built) -->
					</p>
				</div> <!-- end google ad -->
				
				<sub:contentregion id="MPMain" runat="server"></sub:contentregion>
				
			</div> <!-- end #content -->
			
			<div id="sidebar">
				<uc1:AboutMe id="aboutMe" runat="server" />
				
				<div class="box">
					<div class="innerBox">
						<h3 id="badges">Badges</h3>
						<ul>
							<li><sub:RssHyperLink ImageUrl="~/skins/Haackify/images/rss20icon.gif" Runat="server" title="RSS 2.0" ID="XMLLink">RSS 2.0 Feed</sub:RssHyperLink><sub:RssHyperLink Runat="server" ID="Syndication" title="RSS 2.0" /></li>
							<li><asp:HyperLink ImageUrl="~/images/PoweredBySubtext85x33.png" Runat="server" NavigateUrl="http://subtextproject.com/" ID="PoweredByLink" title="Powered By Subtext"></asp:HyperLink></li>
						</ul>
					</div>
				</div>
				<div>
	<!-- Start of Flickr Badge -->
					<!-- //TODO: Flickr Badge Control -->
	<!-- End of Flickr Badge -->
				</div>

				<uc1:SingleColumn id="SingleColumn1" runat="server"></uc1:SingleColumn>
			</div>
		</div>
	<uc1:Footer id="Footer1" runat="server"></uc1:Footer>
	<div id="bottom"></div>
</div> <!-- end #main -->