<%@ Register TagPrefix="ANW" Namespace="Subtext.Web.Admin.WebUI" Assembly="Subtext.Web" %>
<%@ Page language="c#" Codebehind="EditCategories.aspx.cs" AutoEventWireup="false" Inherits="Subtext.Web.Admin.Pages.EditCategories" %>
<ANW:Page id="PageContainer" runat="server" TabSectionID="Posts">
	<ANW:MessagePanel id="Messages" runat="server" />

	<ANW:AdvancedPanel id="Edit" runat="server" Collapsible="False" HeaderText="Edit Categories" HeaderCssClass="CollapsibleHeader" DisplayHeader="true">
		<asp:DataGrid id="dgrItems" AutoGenerateColumns="False" GridLines="None" CssClass="Listing" runat="server">
			<AlternatingItemStyle CssClass="Alt"></AlternatingItemStyle>
			<HeaderStyle CssClass="Header"></HeaderStyle>

			<Columns>
				<asp:TemplateColumn HeaderText="Category">
					<ItemTemplate>
						<asp:Label runat="server" Text='<%# DataBinder.Eval(Container, "DataItem.Title") %>'></asp:Label>
						<br />
						<asp:Label runat="server" Text='<%# DataBinder.Eval(Container, "DataItem.Description") %>' ID="Label2" NAME="Label1"></asp:Label>
					</ItemTemplate>

					<EditItemTemplate>
						Title<br />
						<asp:TextBox CssClass="textinput" id="txbTitle" runat="server" Text='<%# DataBinder.Eval(Container, "DataItem.Title") %>'></asp:TextBox>
						<br />Description<br />
						<asp:TextBox CssClass="textarea" rows="5" textmode="MultiLine" id="txbDescription" runat="server" Text='<%# DataBinder.Eval(Container, "DataItem.Description") %>'></asp:TextBox>
					</EditItemTemplate>
				</asp:TemplateColumn>
				
	

				<asp:TemplateColumn HeaderText="Visible">
					<ItemTemplate>
						<asp:Label runat="server" Text='<%# DataBinder.Eval(Container, "DataItem.IsActive") %>'></asp:Label>
					</ItemTemplate>

					<EditItemTemplate>
						<asp:CheckBox id="ckbIsActive" runat="server" Checked='<%# DataBinder.Eval(Container, "DataItem.IsActive") %>'/>
					</EditItemTemplate>
				</asp:TemplateColumn>
				
				<asp:EditCommandColumn ButtonType="LinkButton" UpdateText="Update" CancelText="Cancel" EditText="Edit"></asp:EditCommandColumn>
				
				<asp:ButtonColumn Text="Delete" CommandName="Delete"></asp:ButtonColumn>
			</Columns>
		</asp:DataGrid>
	</ANW:AdvancedPanel>

	<ANW:AdvancedPanel id="Add" runat="server" Collapsible="False" HeaderText="Add New Category" HeaderCssClass="CollapsibleTitle" DisplayHeader="true" BodyCssClass="Edit">
		<label class="Block">Title&nbsp;<asp:RequiredFieldValidator id="valtxbNewTitleRequired" runat="server" ControlToValidate="txbNewTitle" ForeColor="#990066" ErrorMessage="Your category must have a description" /></label>
		<asp:TextBox id="txbNewTitle" runat="server" CssClass="textinput"></asp:TextBox>
		&nbsp; 
		Visible <asp:CheckBox id="ckbNewIsActive" runat="server" Checked="true"></asp:CheckBox>
		<br />
		<label class="Block">Description (1000 characters including HTML)</lable><br />
		<asp:TextBox id="txbNewDescription" max="1000"  runat="server" rows="5" CssClass="textarea" textmode="MultiLine"></asp:TextBox>
		<div style="margin-top: 8px">
			<asp:Button id="lkbPost" runat="server" CssClass="buttonSubmit" Text="Add"/>
			<br />&nbsp; 
		</div>
	</ANW:AdvancedPanel>

</ANW:Page>
