<%@ Page language="c#" EnableViewState="False" Codebehind="login.aspx.cs" AutoEventWireup="True" Inherits="Subtext.Web.Pages.login" %>
<%@ Register TagPrefix="st" Namespace="Subtext.Web.Controls" Assembly="Subtext.Web.Controls" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
	<head>
		<title>Subtext - Login</title>
		<st:StyleTag id="SystemStyle" href="~/Skins/_System/SystemStyle.css" runat="server" />
	</head>
	<body>
		<form method="post" runat="server" ID="frmLogin">
			<div id="Main">
				<img src="~/images/SubtextLogo.png" runat="server" id="headerLogoImg" vspace="4" />
				<div id="Heading">Please Sign In Below</div>
				<label for="tbUserName">
					Username <asp:RequiredFieldValidator ForeColor="#990044" ControlToValidate="tbUserName" Text="Please enter username"
						Runat="server" id="RequiredFieldValidator1" />
				</label>
					<asp:TextBox id="tbUserName" runat="server" CssClass="Textbox" />
				<label for="tbPassword">
					Password
				</label>
				<asp:TextBox id="tbPassword" TextMode="Password" runat="server" CssClass="Textbox" />
				<asp:Button id="btnLogin" runat="server" Text="Login" CssClass="Button LoginButton" onclick="btnLogin_Click" />
				<p class="remember">
					<asp:CheckBox id="chkRemember" runat="server" CssClass="LoginFloat" Text="Remember me?" />
				</p>
				<br class="clear" />
				<asp:Label id="Message" runat="server" CssClass="ErrorMessage"></asp:Label>
				<p class="Small">
					Forget your password?
					<asp:LinkButton id="lbSendPassword" runat="server" visible="true" CssClass="emailPassword" onclick="lbSendPassword_Click">Email me my password.</asp:LinkButton>
				</p>
			</div>
		</form>
	</body>
</html>
