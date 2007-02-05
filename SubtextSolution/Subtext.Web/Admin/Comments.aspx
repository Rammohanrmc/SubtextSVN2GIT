<%@ Page language="c#" Title="Subtext Admin - Comment Options" MasterPageFile="~/Admin/WebUI/AdminPageTemplate.Master" Codebehind="Comments.aspx.cs" AutoEventWireup="True" Inherits="Subtext.Web.Admin.Pages.Comments" %>
<%@ Register TagPrefix="st" Namespace="Subtext.Web.Admin.WebUI" Assembly="Subtext.Web" %>
<%@ Register TagPrefix="st" Namespace="Subtext.Web.Controls" Assembly="Subtext.Web.Controls" %>

<asp:Content ID="actions" ContentPlaceHolderID="actionsHeading" runat="server">
    Actions
</asp:Content>

<asp:Content ID="categoryListTitle" ContentPlaceHolderID="categoryListHeading" runat="server">
</asp:Content>

<asp:Content ID="categoriesLinkListing" ContentPlaceHolderID="categoryListLinks" runat="server">
</asp:Content>

<asp:Content ID="entryEditor" ContentPlaceHolderID="pageContent" runat="server">
    <st:MessagePanel id="Messages" runat="server"></st:MessagePanel>
    <st:AdvancedPanel id="Edit" runat="server" DisplayHeader="true" BodyCssClass="Edit" HeaderCssClass="CollapsibleHeader"
	    HeaderText="Comments and Trackbacks" Collapsible="False">

		<fieldset title="feedback experience">
			<legend>Feedback Options</legend>
			
			<div>
				<asp:CheckBox id="chkEnableComments" runat="server" CssClass="checkbox" Text="Enable Comments" />
				<st:HelpToolTip id="HelpToolTip1" runat="server" HelpText="If checked, enables comments." ImageUrl="~/images/icons/help-small.png" ImageWidth="16" ImageHeight="16" />		
			</div>
			
			<div>
				<asp:CheckBox id="chkEnableTrackbacks" runat="server" CssClass="checkbox" Text="Enable Trackbacks" />
				<st:HelpToolTip id="Helptooltip5" runat="server" HelpText="If checked, enables trackbacks and pingbacks." ImageUrl="~/images/icons/help-small.png" ImageWidth="16" ImageHeight="16" />
			</div>
			
			<div>
				<asp:CheckBox id="chkCoCommentEnabled" runat="server" CssClass="checkbox" Text="Enable CoComment" />
				<st:HelpToolTip id="Helptooltip6" runat="server" HelpText="If checked, enables CoComment support." ImageUrl="~/images/icons/help-small.png" ImageWidth="16" ImageHeight="16" />
			</div>
		</fieldset>
		
		<fieldset title="Notifications">
		    <legend>Notification Options</legend>
		    <div>
				<asp:CheckBox id="chkEnableCommentEmail" runat="server" CssClass="checkbox" Text="Notify On New Comment" />
				<st:HelpToolTip id="toolTipEnableCommentEmail" runat="server" HelpText="If checked, sends an email when a new comment is posted." ImageUrl="~/images/icons/help-small.png" ImageWidth="16" ImageHeight="16" />		
			</div>
			
			<div>
				<asp:CheckBox id="chkEnableTrackbackEmails" runat="server" CssClass="checkbox" Text="Notify On New Trackback" />
				<st:HelpToolTip id="toolTipEnableTrackbackEmails" runat="server" HelpText="If checked, sends an email when a new trackbacks or pingbacks is posted" ImageUrl="~/images/icons/help-small.png" ImageWidth="16" ImageHeight="16" />
			</div>
		</fieldset>
	    
	    <fieldset title="spamcontrols">
			<legend>Spam Controls</legend>

		
			<label for="chkEnableCommentModeration">
				Akismet API Key
				<st:HelpToolTip id="hlpAkismet" runat="server" HelpText="Specify your Akismet API Key to use <a href='http://akismet.com/' title='Akismet Comment Spam Filter Service'>Akismet</a> for spam filtering. Leave blank otherwise." ImageUrl="~/images/icons/help-small.png" ImageWidth="16" ImageHeight="16" />
			</label>
			<asp:TextBox id="txtAkismetAPIKey" runat="server" Columns="2" CssClass="textbox" /> <em>(if you use <a href="http://akismet.com/" title="Akismet">Akismet</a>, consider disabling ReverseDOS)</em>

			<div>
				<asp:CheckBox id="chkEnableCommentModeration" runat="server" Text="Moderate Comments" CssClass="checkbox" />
				<st:HelpToolTip id="helpCommentModeration" runat="server" HelpText="If checked, enables comment moderation.  Does nothing if comments are not enabled." ImageUrl="~/images/icons/help-small.png" ImageWidth="16" ImageHeight="16" />
			</div>
			
			<div>
				<asp:CheckBox id="chkEnableCaptcha" runat="server" CssClass="checkbox" Text="Enable Captcha" />
				<st:HelpToolTip id="helpCaptcha" runat="server" HelpText="If checked, displays a CAPTCHA control in the comment form." ImageUrl="~/images/icons/help-small.png" ImageWidth="16" ImageHeight="16" />
			</div>
			
			<div>
				<asp:CheckBox id="chkAllowDuplicates" runat="server" CssClass="checkbox" Text="Allow Duplicate Comments" />
				<st:HelpToolTip id="Helptooltip4" runat="server" HelpText="If checked, duplicate comments are allowed.  If unchecked, duplicate comments are not allowed.  Not checking this can help prevent some comment spam, but at the cost that short �me too� style comments may be blocked." ImageUrl="~/images/icons/help-small.png" ImageWidth="16" ImageHeight="16" />
			</div>


			<label for="txtCommentDelayIntervalMinutes">
				Comment Delay In Minutes
				<st:HelpToolTip id="HelpToolTip2" runat="server" HelpText="Enter the number of minutes the delay between comments originating from the same source should be.  This helps prevent spam bombing attacks via automated scripts." ImageUrl="~/images/icons/help-small.png" ImageWidth="16" ImageHeight="16" />
			</label>
			<asp:TextBox id="txtCommentDelayIntervalMinutes" runat="server" CssClass="textbox number" />
			
			
			<label>
				Days Till Comments Close
				<st:HelpToolTip id="Helptooltip3" runat="server" HelpText="If Comments are enabled, this setting allows you to specify whether comments will be disallowed on a post after a certain number of days.  For example, you may wish to have comments close on an item after 30 days." ImageUrl="~/images/icons/help-small.png" ImageWidth="16" ImageHeight="16" />
				(leave blank if comments never close) 
			</label>
			<asp:TextBox id="txtDaysTillCommentsClosed" runat="server" CssClass="textbox number" />

		</fieldset>
		
	    <fieldset title="Recent Comments Display" class="clear">
			<legend>Recent Comments Display</legend>
			
				<label class="txtNumberOfRecentComments Block">
					Number of Recent Comments to Display
					<st:HelpToolTip id="Helptooltip7" runat="server" HelpText="This sets how many recent comments are displayed in the sidebar. This is an integer from 1-99." ImageUrl="~/images/icons/help-small.png" ImageWidth="16" ImageHeight="16" />
				</label>
				<asp:TextBox id="txtNumberOfRecentComments" runat="server" CssClass="textbox number" />
			
				<label class="txtRecentCommentsLength Block">
					Length of Recent Comments to Display (Number of characters)
				<st:HelpToolTip id="Helptooltip8" runat="server" HelpText="This controls how many characters of recent comments are displayed in the sidebar. This is an integer from 1-99." ImageUrl="~/images/icons/help-small.png" ImageWidth="16" ImageHeight="16" />
				</label>
				<asp:TextBox id="txtRecentCommentsLength" runat="server" CssClass="textbox number" />
			
	    </fieldset>
	    <div>
			<asp:Button id="lkbPost" runat="server" Text="Save" CssClass="buttonSubmit" />
		</div>
    </st:AdvancedPanel>
</asp:Content>