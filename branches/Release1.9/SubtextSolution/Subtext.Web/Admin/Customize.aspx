<%@ Page Language="C#" MasterPageFile="~/Admin/WebUI/AdminPageTemplate.Master" AutoEventWireup="true"
    Codebehind="Customize.aspx.cs" Inherits="Subtext.Web.Admin.Pages.Customize" %>

<asp:Content ID="Content1" ContentPlaceHolderID="actionsHeading" runat="server">
    Actions</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="categoryListHeading" runat="server">
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="categoryListLinks" runat="server">
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="pageContent" runat="server">
    <st:MessagePanel ID="Messages" runat="server">
    </st:MessagePanel>
    <div class="CollapsibleHeader">
        <span>Customize</span>
    </div>
    <div id="metatag-content">
        <asp:Panel GroupingText="Meta Tags" CssClass="options fluid" runat="server">
            <div class="right">
                <span class="btn metatag-add">Add Meta Tag
                    <img src="<%# VirtualPathUtility.ToAbsolute("~/Images/tag_blue_add.png") %>" alt="Add a New Meta Tag" /></span>
            </div>
            <asp:Panel ID="MetatagMessages" runat="server" CssClass="clear">
                There are no Meta Tags created for this blog. Add some now!</asp:Panel>
            <asp:Panel ID="MetatagWrapper" runat="server" CssClass="clear">
                <asp:Repeater ID="MetatagRepeater" runat="server">
                    <HeaderTemplate>
                        <table id="metatag-table" class="listing highlightTable">
                            <tbody>
                                <tr>
                                    <th>
                                        Name</th>
                                    <th>
                                        Content</th>
                                    <th>
                                        Http-Equiv</th>
                                    <th>
                                        Action</th>
                                </tr>
                    </HeaderTemplate>
                    <ItemTemplate>
                        <tr id="metatag-<%# EvalTag(Container.DataItem).Id %>">
                            <td>
                                <%# EvalName(Container.DataItem) %>
                            </td>
                            <td>
                                <%# EvalContent(Container.DataItem) %>
                            </td>
                            <td>
                                <%# EvalHttpEquiv(Container.DataItem) %>
                            </td>
                            <td>
                                <span class="btn metatag-edit">Edit
                                    <img src="<%# VirtualPathUtility.ToAbsolute("~/Images/tag_blue_edit.png") %>" alt="Edit Meta Tag" /></span>
                                <span class="btn metatag-delete">Delete
                                    <img src="<%# VirtualPathUtility.ToAbsolute("~/Images/tag_blue_delete.png") %>" alt="Delete Meta Tag" /></span>
                            </td>
                        </tr>
                    </ItemTemplate>
                    <AlternatingItemTemplate>
                        <tr class="alt" id="metatag-<%# EvalTag(Container.DataItem).Id %>">
                            <td>
                                <%# EvalName(Container.DataItem) %>
                            </td>
                            <td>
                                <%# EvalContent(Container.DataItem) %>
                            </td>
                            <td>
                                <%# EvalHttpEquiv(Container.DataItem) %>
                            </td>
                            <td>
                                <span class="btn metatag-edit">Edit
                                    <img src="<%# VirtualPathUtility.ToAbsolute("~/Images/tag_blue_edit.png") %>" alt="Edit Meta Tag" /></span>
                                <span class="btn metatag-delete">Delete
                                    <img src="<%# VirtualPathUtility.ToAbsolute("~/Images/tag_blue_delete.png") %>" alt="Delete Meta Tag" /></span>
                            </td>
                        </tr>
                    </AlternatingItemTemplate>
                    <FooterTemplate>
                        </tbody> </table>
                    </FooterTemplate>
                </asp:Repeater>
            </asp:Panel>
        </asp:Panel>
    </div>

    <script type="text/javascript">
    
        // a global variable for un-doing an operation
        var undoMetaTag = { 
            id: null,
            name: null,
            content: null,
            httpEquiv: null
            };
        
        // first let's hook up some events
        $(document).ready(function()
        {
            // wire up the Add Button handler
            $(".metatag-add").click(addMetaTag);
            
            // wire up the Delete Button handlers
            $("tr[id^='metatag-'] .metatag-delete").click(function()
            {
                //alert("delete " + $(this).parents("tr[id^='metatag-']").attr('id').split('metatag-').pop());
                
                // get the table row that holds this meta tag
                var tagRow = $(this).parents("tr[id^='metatag-']");
                
                deleteMetaTag(tagRow);
            });
        });
        
        
        function addMetaTag()
        {
            var newTag = ajaxServices.addMetaTagForBlog("Just a test", "author", null);
            
            alert("Added new tagid = " + newTag.id);
        }
        
        function deleteMetaTag(metaTagRow)
        {
            var rows = metaTagRow.children('td');
            
            undoMetaTag.id = metaTagRow.attr('id').split('metatag-').pop();
            undoMetaTag.name = returnNullForEmpty(rows[0].textContent.trim());
            undoMetaTag.content = rows[1].textContent.trim();
            undoMetaTag.httpEquiv = returnNullForEmpty(rows[2].textContent.trim());
            
            ajaxServices.deleteMetaTag(undoMetaTag.id, function(response)
                {
                    if (response.result)
                        onTagDeleted(response.result);
                    else
                        handleError(response.error);
                });
        }
        
        function onTagDeleted(isDeleted)
        {
            alert("successfully deleted = " + isDeleted);
        }
        
        function handleError(error)
        {
            alert(error);
        }
        
        function returnNullForEmpty(val)
        {
            if (val == null || val.length > 0)
                return val;
                
            return null;
        }
    </script>

</asp:Content>
