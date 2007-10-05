<%@ Page Language="C#" MasterPageFile="~/Admin/WebUI/AdminPageTemplate.Master" AutoEventWireup="true"
    Codebehind="Customize.aspx.cs" Inherits="Subtext.Web.Admin.Pages.Customize" %>

<asp:Content ID="Content1" ContentPlaceHolderID="actionsHeading" runat="server">
    Actions</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="categoryListHeading" runat="server">
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="categoryListLinks" runat="server">
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="pageContent" runat="server">
    <div id="messagePanelContainer">
        <div id="messagePanelWrapper">
            <div id="messagePanel" style="display: none;">
            </div>
        </div>
    </div>
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
    
        /* ---- { a few global variables } ---- */
    
        var msgPanel = $('#messagePanel');
        var msgPanelWrap = msgPanel.parent();
        
        // a global variable for un-doing an operation
        var undoMetaTag = { 
            id: null,
            name: null,
            content: null,
            httpEquiv: null
            };
        
        
        /* ---- { page and event setup } ---- */
        
        // first let's hook up some events
        $(document).ready(function()
        {
            // wire up the Add Button handler
            $(".metatag-add").click(addMetaTag);
            
            // wire up the Delete Button handlers
            $("tr[id^='metatag-'] .metatag-delete").click(function()
            {
                // get the table row that holds this meta tag
                var tagRow = $(this).parents("tr[id^='metatag-']");
                
                deleteMetaTag(tagRow);
            });
        });
        
        
        /* ---- { Meta Tag methods } ---- */
        
        function addMetaTag()
        {
            hideMessagePanel();
        
            var newTag = ajaxServices.addMetaTagForBlog("Just a test", "author", null, function(response)
                {
                    if (response.error)
                        handleError(response.error);
                    else
                        onTagAdded(response.result);
                });
        }
        
        function onTagAdded(metaTag)
        {
            msgPanelWrap.addClass("success");
            showMessagePanel("Added new tagid = " + metaTag.id);
        }
        
        function deleteMetaTag(metaTagRow)
        {
            hideMessagePanel();
        
            var rows = metaTagRow.children('td');
            
            undoMetaTag.id = metaTagRow.attr('id').split('metatag-').pop();
            undoMetaTag.name = returnNullForEmpty($(rows[0]).text().trim());
            undoMetaTag.content = $(rows[1]).text().trim();
            undoMetaTag.httpEquiv = returnNullForEmpty($(rows[2]).text().trim());
            
            ajaxServices.deleteMetaTag(undoMetaTag.id, function(response)
                {
                    if (response.error)
                        handleError(response.error);
                    else
                        onTagDeleted(response.result);
                });
        }
        
        function onTagDeleted(isDeleted)
        {
            if(isDeleted)
            {
                msgPanelWrap.addClass("success");
                showMessagePanel("The meta tag was successfully deleted.");
            }
            else
            {
                msgPanelWrap.addClass("warn");
                showMessagePanel("Could not delete the meta tag... perhaps it's already gone!");
            }
        }
        
        /* ---- { helper methods } ---- */
        
        function handleError(error)
        {
            msgPanelWrap.addClass("error");
            showMessagePanel(error.message);
        
            // available properties on error
            //error.errors -> [{error}, ...]
            //error.name
            //error.message
            //error.stackTrace
        }
        
        function showMessagePanel(message)
        {
            msgPanel.empty();
            msgPanel.append("<p>" + message + "</p>");
            msgPanel.fadeIn("slow");
        }
        
        function hideMessagePanel()
        {
            msgPanel.fadeOut(20);
            msgPanelWrap.removeClass("error").removeClass("warn").removeClass("info").removeClass("success");
        }
        
        function returnNullForEmpty(val)
        {
            if (val == null || val.length > 0)
                return val;
                
            return null;
        }
    </script>

</asp:Content>
