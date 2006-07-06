<%@ Page language="c#" Title="Subtext Admin - Confirmation Dialog" MasterPageFile="~/Admin/WebUI/AdminPageTemplate.Master"  Codebehind="Confirm.aspx.cs" AutoEventWireup="True" Inherits="Subtext.Web.Admin.Pages.Confirm" %>
<%@ Register TagPrefix="st" Namespace="Subtext.Web.Admin.WebUI" Assembly="Subtext.Web" %>

<asp:Content ID="actions" ContentPlaceHolderID="actionsHeading" runat="server">
    Actions
</asp:Content>

<asp:Content ID="categoryListTitle" ContentPlaceHolderID="categoryListHeading" runat="server">
</asp:Content>

<asp:Content ID="categoriesLinkListing" ContentPlaceHolderID="categoryListLinks" runat="server">
</asp:Content>

<asp:Content ID="confirmContent" ContentPlaceHolderID="pageContent" runat="server">
	<st:MessagePanel id="Messages" runat="server" MessageCssClass="MessagePanel" MessageIconUrl="~/admin/resources/ico_info.gif" ErrorCssClass="ErrorPanel" ErrorIconUrl="~/admin/resources/ico_critical.gif"/>
	<st:AdvancedPanel id="HeaderSection" runat="server" DisplayHeader="true" CssClass="Dialog" HeaderCssClass="DialogTitle" BodyCssClass="DialogBody" HeaderText="Confirm Action" LinkText="[toggle list]"> 
		<ASP:Label id="lblOutput" runat="server" />
		<div style="margin-top: 12px;">
			<ASP:Button id="lkbContinue" runat="server" text="Continue" visible="false" CssClass="buttonSubmit" onclick="lkbContinue_Click" />
			<ASP:Button id="lkbYes" runat="server" Text="Yes" CssClass="buttonSubmit" onclick="Yes_Click" />
			<ASP:Button id="lkbNo" runat="server" Text="No" CssClass="buttonSubmit" onclick="No_Click" />
			<br/>&nbsp;
		</div>
	</st:AdvancedPanel>
</asp:Content>
