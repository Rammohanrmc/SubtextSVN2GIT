<%@ Page language="c#" Title="Subtext Admin - Edit Links" MasterPageFile="~/Admin/WebUI/AdminPageTemplate.Master" Codebehind="EditLinks.aspx.cs" AutoEventWireup="True" Inherits="Subtext.Web.Admin.Pages.EditLinks" %>
<%@ Register TagPrefix="st" Namespace="Subtext.Web.Admin.WebUI" Assembly="Subtext.Web" %>
<%@ Register TagPrefix="st" Namespace="Subtext.Web.Controls" Assembly="Subtext.Web.Controls" %>
<%@ Register TagPrefix="st" TagName="CategoryLinks" Src="~/Admin/UserControls/CategoryLinkList.ascx" %>

<asp:Content ID="actions" ContentPlaceHolderID="actionsHeading" runat="server">
</asp:Content>

<asp:Content ID="categoryListTitle" ContentPlaceHolderID="categoryListHeading" runat="server">
    Categories
</asp:Content>

<asp:Content ID="categoriesLinkListing" ContentPlaceHolderID="categoryListLinks" runat="server">
    <st:CategoryLinks ID="categoryLinks" runat="server" CategoryType="LinkCollection" />
</asp:Content>

<asp:Content ID="linkContent" ContentPlaceHolderID="pageContent" runat="server">
	<st:MessagePanel id="Messages" runat="server"></st:MessagePanel>
	<st:AdvancedPanel id="Results" runat="server" LinkStyle="Image" LinkBeforeHeader="True" DisplayHeader="True"
		HeaderCssClass="CollapsibleHeader" HeaderText="Links" LinkText="[toggle]" Collapsible="True">
		<asp:Repeater id="rprSelectionList" runat="server">
			<HeaderTemplate>
				<table id="Listing" class="Listing highlightTable" cellSpacing="0" cellPadding="0" border="0">
					<tr>
						<th>Link Title</th>
						<th width="50">Url</th>
						<th width="50">&nbsp;</th>
						<th width="50">&nbsp;</th>
					</tr>
			</HeaderTemplate>
			<ItemTemplate>
				<tr>
					<td>
						<%# DataBinder.Eval(Container.DataItem, "Title") %>
					</td>
					<td>
						<%# DataBinder.Eval(Container.DataItem, "Url") %>
					</td>
					<td>
						<asp:linkbutton id="lnkEdit" CommandName="Edit" CommandArgument='<%# DataBinder.Eval(Container.DataItem, "Id") %>' Text="Edit" runat="server" /></td>
					<td>
						<asp:linkbutton id="lnkDelete" CommandName="Delete" CommandArgument='<%# DataBinder.Eval(Container.DataItem, "Id") %>' Text="Delete" runat="server" /></td>
				</tr>
			</ItemTemplate>
			<AlternatingItemTemplate>
				<tr class="Alt">
					<td>
						<%# DataBinder.Eval(Container.DataItem, "Title") %>
					</td>
					<td>
						<%# DataBinder.Eval(Container.DataItem, "Url") %>
					</td>
					<td>
						<asp:linkbutton id="lnkEdit" CommandName="Edit" CommandArgument='<%# DataBinder.Eval(Container.DataItem, "Id") %>' Text="Edit" runat="server" />
					</td>
					<td>
						<asp:linkbutton id="lnkDelete" CommandName="Delete" CommandArgument='<%# DataBinder.Eval(Container.DataItem, "Id") %>' Text="Delete" runat="server" />
					</td>
				</tr>
			</AlternatingItemTemplate>
			<FooterTemplate>
				</table>
			</FooterTemplate>
		</ASP:Repeater>			
		<st:PagingControl id="resultsPager" runat="server" 
			PrefixText="<div>Goto page</div>" 
			LinkFormatActive='<a href="{0}" class="Current">{1}</a>' 
			UrlFormat="EditLinks.aspx?pg={0}" 
			CssClass="Pager" />
		<br class="clear" />
	</st:AdvancedPanel>
	<st:AdvancedPanel id="ImportExport" runat="server" LinkStyle="Image" LinkBeforeHeader="True" DisplayHeader="True"
		HeaderCssClass="CollapsibleTitle" HeaderText="Import/Export" Collapsible="True" BodyCssClass="Edit"
		visible="false">
		<div style="HEIGHT: 0px"><!-- IE bug hides label in following div without this -->
			<div>
				<div>
					<p class="Block"><LABEL class="Block">Local File Location (*.opml)</LABEL></p>
					<input class="FileUpload" id="OpmlImportFile" type="file" size="62" name="ImageFile" runat="server" />
					<p>Categories</p>
					<p>
						<asp:DropDownList id="ddlImportExportCategories" runat="server"></ASP:DropDownList></p>
				</div>
				<div style="MARGIN-TOP: 8px">
					<asp:Button id="lkbImportOpml" runat="server" CssClass="Button" Text="Import" onclick="lkbImportOpml_Click"></asp:Button><A class="Button" href="Export.aspx?command=opml">Export</A>
					<BR class="clear">
					&nbsp;
				</div>
			</div>
		</div>
	</st:AdvancedPanel>
	
	<asp:PlaceHolder id="Edit" runat="server">
		<fieldset>
			
				<label><asp:Literal ID="lblLinkId" runat="server">Link ID </asp:Literal></label>
				<asp:Label id="lblEntryID" runat="server" />
			
				<label for="Edit_txbTitle" AccessKey="t">Link <u>T</u>itle 
					<asp:RequiredFieldValidator id="RequiredFieldValidator1" runat="server" ControlToValidate="txbTitle" CssClass="error"
						ErrorMessage="Your link must have a title" />
				</label>
				
				<asp:TextBox id="txbTitle" runat="server" CssClass="textbox" />
			
				<label for="Edit_txbUrl" AccessKey="w"><u>W</u>eb Url 
					<asp:RequiredFieldValidator id="Requiredfieldvalidator2" runat="server" ControlToValidate="txbUrl" CssClass="error"
						ErrorMessage="Your link must have a url" />
				</label>
				
				<asp:TextBox id="txbUrl" runat="server" CssClass="textbox" />
				<label for="Edit_txbRss" AccessKey="r"><u>R</u>ss Url</label>
			
				<asp:TextBox id="txbRss" runat="server" CssClass="textbox" />
				<label for="Edit_ddlCategories" AccessKey="c"><u>C</u>ategories</label>
			
				<asp:DropDownList id="ddlCategories" runat="server" />
			
				<div>
					<asp:CheckBox id="ckbIsActive" runat="server" textalign="Left" Text="Visible" CssClass="checkbox" /> 
					<asp:CheckBox id="chkNewWindow" runat="server" textalign="Left" Text="New Window" CssClass="checkbox" />
				</div>
				
				<div class="buttons">
					<asp:Button id="lkbPost" runat="server" CssClass="button" Text="Post" onclick="lkbPost_Click" />
					<asp:Button id="lkbCancel" runat="server" CssClass="button" Text="Cancel" onclick="lkbCancel_Click" />
					&nbsp;
				</div>
		</fieldset>
	</asp:PlaceHolder>
</asp:Content>