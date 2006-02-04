<%@ Page language="c#" Codebehind="ErrorLog.aspx.cs" AutoEventWireup="false" Inherits="Subtext.Web.Admin.Pages.ErrorLog" %>
<%@ Register TagPrefix="ANW" Namespace="Subtext.Web.Admin.WebUI" Assembly="Subtext.Web" %>
<%@ Register TagPrefix="sb" Namespace="Subtext.Web.Controls" Assembly="Subtext.Web.Controls" %>
<ANW:Page id="PageContainer" TabSectionID="Stats" runat="server">
	<ANW:AdvancedPanel id="Log" runat="server" Collapsible="False" HeaderText="Error Log" HeaderCssClass="CollapsibleHeader"
		DisplayHeader="true">
		<table id="Listing" class="Listing" cellSpacing="0" cellPadding="0" border="0">
		<sb:RepeaterWithEmptyDataTemplate id="LogPage" runat="server">
			<HeaderTemplate>
				<tr>
					<th>Date</th>
					<th>Thread</th>
					<th>Logger</th>
					<th>Level</th>
					<th>Message</th>
					<th>Exception</th>
				</tr>
			</HeaderTemplate>
			<ItemTemplate>
				<tr>
					<td>
						<%# DataBinder.Eval(Container.DataItem, "Date") %>
					</td>
					<td>
						<%# DataBinder.Eval(Container.DataItem, "Thread") %>
					</td>												
					<td>
						<%# DataBinder.Eval(Container.DataItem, "Logger") %>
					</td>
					<td>
						<%# DataBinder.Eval(Container.DataItem, "Level") %>
					</td>				
					<td>
						<%# DataBinder.Eval(Container.DataItem, "Message") %>
					</td>				
					<td>
						<%# DataBinder.Eval(Container.DataItem, "Exception") %>
					</td>				
				</tr>
			</ItemTemplate>
			<AlternatingItemTemplate>
				<tr class="Alt">
					<td>
						<%# DataBinder.Eval(Container.DataItem, "Date") %>
					</td>
					<td>
						<%# DataBinder.Eval(Container.DataItem, "Thread") %>
					</td>												
					<td>
						<%# DataBinder.Eval(Container.DataItem, "Logger") %>
					</td>
					<td>
						<%# DataBinder.Eval(Container.DataItem, "Level") %>
					</td>				
					<td>
						<%# DataBinder.Eval(Container.DataItem, "Message") %>
					</td>				
					<td>
						<%# DataBinder.Eval(Container.DataItem, "Exception") %>
					</td>				
				</tr>
			</AlternatingItemTemplate>
			<EmptyDataTemplate>
				<tr>
					<td colspan="6">No log entries to show.</td>
				</tr>
			</EmptyDataTemplate>
		</sb:RepeaterWithEmptyDataTemplate>
		</table>
		<ANW:Pager id="LogPager" runat="server" CssClass="Pager" UrlFormat="ErrorLog.aspx?pg={0}"
			LinkFormatActive='<a href="{0}" class="Current">{1}</a>' PrefixText="<div>Goto page</div>"
			UseSpacer="False"></ANW:Pager>
		<asp:Button id="btnClearLog" runat="server" CssClass="buttonSubmit" style="float:right;" Text="Clear" />
		<br class="clear" />
	</ANW:AdvancedPanel>
</ANW:Page>
