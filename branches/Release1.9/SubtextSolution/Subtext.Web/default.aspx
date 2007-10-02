<%@ Page CodeBehind="Default.aspx.cs" EnableViewState="false" Language="C#" EnableTheming="false"  AutoEventWireup="false" Inherits="Subtext.Web._default" %>
<%@ OutputCache Duration="120" VaryByParam="GroupID" VaryByHeader="Accept-Language" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="en" xml:lang="en">
	<head>
		<title><asp:Literal id="title" runat="server" Text="<%$ AppSettings:AggregateTitle %>" /></title>
		<asp:Literal id="Style" runat="Server" />
	</head>
	<body>
		<form id="Form1" method="post" runat="server">
			<div id="header">
				<h1><asp:HyperLink ID="TitleLink" Text="<%$ AppSettings:AggregateTitle %>" NavigateUrl="<%# AggregateUrl %>" Runat="server" /></h1>
			</div>
			<div id="authors">
				<h2>Welcome</h2>
				<p>
					This is the generic homepage (aka Aggregate Blog) for a Subtext community website. It aggregates 
					posts from every blog installed in this server. To modify this page, edit the default.aspx page 
					in your Subtext installation.
				</p>
				<p>
					To learn more about the application, check out <a href="http://subtextproject.com/" title="Subtext Project Website" rel="external">
					the Subtext Project Website</a>.
				</p>
				<p>
					Powered By:<br />
					<asp:HyperLink NavigateUrl="http://subtextproject.com/" ImageUrl="~/images/PoweredBySubtext85x33.png" ToolTip="Powered By Subtext"
						Runat="server" BorderWidth="0" id="HyperLink1" />
				</p>
				<h2>Syndication</h2>
				<ul>
					<li><asp:HyperLink ID="OpmlLink" Text="OPML (list of bloggers)" runat="server" NavigateUrl = "~/Opml.aspx" />
					<li><asp:HyperLink ID="RssLink" Text="RSS (list of recent posts)" runat="server" NavigateUrl = "~/MainFeed.aspx" />
					<asp:Repeater ID="blogGroupRepeater" runat="server">
						<ItemTemplate>
							<li><asp:HyperLink ID="groupRssLink" Text='<%# Eval("Title", "RSS ({0})") %>' runat="server" NavigateUrl='<%# Eval("Id", "~/MainFeed.aspx?GroupID={0}") %>' /></li>
						</ItemTemplate>
					</asp:Repeater>

				</ul>
				<h2>Blog Stats</h2>
				<ul>
					<li>
						Blogs -
						<asp:Literal ID="BlogCount" Runat="server" />
					<li>
						Posts -
						<asp:Literal ID="PostCount" Runat="server" />
					<li>
						Articles -
						<asp:Literal ID="StoryCount" Runat="server" />
					<li>
						Comments -
						<asp:Literal ID="CommentCount" Runat="server" />
					<li>
						Trackbacks -
						<asp:Literal ID="PingtrackCount" Runat="server" /></li>
				</ul>
				<h2>Bloggers (posts, last update)</h2>
				<asp:repeater id="Bloggers" runat="server">
					<HeaderTemplate>
						<ul>
					</HeaderTemplate>
					<ItemTemplate>
						<li>
							<asp:HyperLink Runat="server" 
								NavigateUrl='<%# Eval("RootUrl") %>' 
								Text='<%# Eval("Author") %>' 
								Title = '<%# Eval("Title") %>' ID="blogHyperLink" />
							<br />
							<small>(<asp:Literal runat="server" Text='<%# DataBinder.Eval(Container.DataItem, "PostCount") %>' ID="postCountLabel"/>, 
							<asp:Literal runat="server" Text='<%# Eval("LastUpdated", "{0:MM/dd/yyyy hh:mm tt}") %>' ID="lastUpdatedLabel"/>)</small></li>
					</ItemTemplate>
					<FooterTemplate>
						</ul>
					</FooterTemplate>
				</asp:repeater>
			</div>
			<div id="main">
				<h2>Latest Posts</h2>
				<asp:repeater id="RecentPosts" runat="server">
					<ItemTemplate>
						<div class="post">
							<h3>
								<asp:HyperLink Runat="server" NavigateUrl='<%# GetEntryUrl(Eval("host").ToString(), Eval("Application").ToString(), Eval("EntryName").ToString(), (DateTime)Eval("DateAdded")) %>' 
									Text='<%# Eval("Title") %>' ID="titleLink"/></h3>
								<asp:Literal runat="server" Text='<%# Eval("Description") %>' ID="description"/>
								<p class="postfoot">
									posted @
									<asp:Literal runat="server" Text = '<%# Eval("DateAdded", "{0:MM/dd/yyyy hh:mm tt}") %>' ID="dateAddedLiteral" />
									by
									<asp:HyperLink Runat="server" CssClass="clsSubtext" 
										NavigateUrl='<%# GetFullUrl(Eval("host").ToString(), Eval("Application").ToString())  %>' 
										Text='<%# Eval("Author") %>' ID="authorBlogLink"/>
								</p>
						</div>
					</ItemTemplate>
				</asp:repeater>
			</div>
		</form>
	</body>
</html>
