<%@ Page Language="C#" AutoEventWireup="true" Codebehind="Login.aspx.cs" Inherits="Subtext.Web.Login" %>
<%@ Register TagPrefix="st" Namespace="Subtext.Web.Controls" Assembly="Subtext.Web.Controls" %>
<html>
	<head>
		<title>Subtext - Login</title>
		<st:StyleTag id="SystemStyle" href="~/Skins/_System/SystemStyle.css" runat="server" />
	</head>
	<body>
		<form method="post" runat="server" ID="frmLogin">
        <div id="Main">
            <div id="logo">
            </div>
            <div id="Heading">
                <div id="Div1">
                    Please Sign In Below</div>
            </div>
            <asp:Login ID="Login1" runat="server" TitleText="" RememberMeText="Remember me">
            </asp:Login>
        </div>
    </form>
</body>
</html>
