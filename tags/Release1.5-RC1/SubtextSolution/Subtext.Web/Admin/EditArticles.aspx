<%@ Page language="c#" Codebehind="EditArticles.aspx.cs" AutoEventWireup="false" Inherits="Subtext.Web.Admin.Pages.EditArticles" %>
<%@ Register TagPrefix="EED" TagName="EntryEditor" Src="~/Admin/UserControls/EntryEditor.ascx" %>
<%@ Register TagPrefix="ANW" Namespace="Subtext.Web.Admin.WebUI" Assembly="Subtext.Web" %>
<ANW:Page id="PageContainer" CategoryType="StoryCollection" TabSectionID="Articles" runat="server">	
	<EED:EntryEditor id="Editor" CategoryType="StoryCollection" EntryType="Story" ResultsTitle="Articles" runat="server" />
</ANW:Page>
