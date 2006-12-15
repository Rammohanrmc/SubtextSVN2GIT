<%@ Page language="c#" Title="Subtext - Your Blog Has Not Been Configured Yet" MasterPageFile="~/Install/InstallTemplate.Master" Codebehind="BlogNotConfiguredError.aspx.cs" AutoEventWireup="True" Inherits="Subtext.Web.BlogNotConfiguredError" EnableViewState="false" %>
<%@ Register TagPrefix="MP" Namespace="Subtext.Web.Controls" Assembly="Subtext.Web.Controls" %>

<asp:Content id="subTitleContent" ContentPlaceHolderID="MPSubTitle" runat="server">Your Blog Has Not Been Configured, But I Can Help You</asp:Content>
<asp:Content ID="mainContent" ContentPlaceHolderID="Content" runat="server">
	<asp:Literal id="ltlMessage" Runat="server"></asp:Literal>
</asp:Content>