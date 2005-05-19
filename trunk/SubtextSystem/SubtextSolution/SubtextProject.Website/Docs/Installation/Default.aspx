<%@ Page %>
<%@ Register TagPrefix="MP" Namespace="SubtextProject.Website" Assembly="SubtextProject.Website" %>
<%@ Register TagPrefix="MP" TagName="DocLinks" Src="~/Docs/DocLinks.ascx" %>
<MP:SubtextMasterPage id="MPContainer" runat="server">
	<MP:ContentRegion id="MPTitle" runat="server">Subtext - Docs - Installation</MP:ContentRegion>
	<MP:ContentRegion id="MPSideBar" runat="server">
		<MP:DocLinks id="AboutLinks" runat="server" />
	</MP:ContentRegion>
	
	<h2>Installation</h2>
	
	<p>
	When the installer is ready, we&#8217;ll put more in depth instructions here.
	</p>
</MP:SubtextMasterPage>
