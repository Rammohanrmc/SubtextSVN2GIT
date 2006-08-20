<%@ Register TagPrefix="MP" Namespace="Subtext.Web.Controls" Assembly="Subtext.Web.Controls" %>
<%@ Page language="c#" Codebehind="InstallationComplete.aspx.cs" AutoEventWireup="false" Inherits="Subtext.Web.Install.InstallationComplete" %>
<MP:MasterPage id="MPContainer" TemplateFile="~/Install/PageTemplate.ascx" runat="server">
	<MP:ContentRegion id="MPTitle" runat="server">Subtext Installation: Installation Complete</MP:ContentRegion>
	<MP:ContentRegion id="MPSubTitle" runat="server">Installation Is Complete</MP:ContentRegion>
	<p>Congratulations. This Subtext Installation is complete.</p>
	<p id="paraBlogLink" runat="server">
		<a id="lnkBlog" href="" runat="server" title="Blog">Visit</a> your blog.
	</p>
	<p id="paraBlogAdminLink" runat="server">
		<a id="lnkBlogAdmin" href="" runat="server" title="Blog Admin">Visit</a> your blog&#8217;s admin.
	</p>
	<p>
		<a id="lnkHostAdmin" href="~/HostAdmin/" runat="server" title="Host Admin Tool">Visit</a> the Host Admin tool.
	</p>
	<p>
		If you need to import data from a .TEXT database, try 
		the <a href="~/HostAdmin/Import/ImportStart.aspx" runat="server" id="importWizardAnchor" title=".TEXT Bulk Import">Bulk Import Wizard</a>.
	</p>
	<p id="paraBlogmlImport" runat="server">
		If you need to import data from another blogging engine (using <a id="lnkBlogMl" href="" title="BlogML Import Tool" runat="server">BlogML</a>), try 
		Import Wizard in your admin section.
	</p>
</MP:MasterPage>
