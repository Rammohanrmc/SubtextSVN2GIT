<%@ Page Language="C#" MasterPageFile="~/Admin/WebUI/AdminPageTemplate.Master" AutoEventWireup="true"
    CodeBehind="Customize.aspx.cs" Inherits="Subtext.Web.Admin.Pages.Customize" %>

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
    <div id="metatag-add-form" style="display:none">
        <fieldset>
            <legend>Add a new Meta Tag</legend>
            <label for="metaTagName">Name:</label><input type="text" id="metaTagName" />
            <label for="metaTagContent">Content:</label><input type="text" id="metaTagContent" />
            <label for="metaTagHttpEquiv">HttpEquiv:</label><input type="text" id="metaTagHttpEquiv" />
        </fieldset>
    </div>
    <div id="metatag-content">
        <asp:Panel GroupingText="Meta Tags" CssClass="options fluid" runat="server">
            <div class="right">
                <span class="btn metatag-add">Add Meta Tag
                    <img src="<%# VirtualPathUtility.ToAbsolute("~/Images/tag_blue_add.png") %>" alt="Add a New Meta Tag" /></span>
            </div>
            <asp:Panel ID="NoMetatagsMessage" runat="server" CssClass="clear">
                There are no Meta Tags created for this blog. Add some now!</asp:Panel>
            <asp:Panel ID="MetatagListWrapper" runat="server" CssClass="clear">
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
                                <span class='btn metatag-edit' title='Edit Meta Tag'>Edit</span> <span class='btn metatag-delete'
                                    title='Delete Meta Tag'>Delete</span>
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
                                <span class="btn metatag-edit" title="Edit Meta Tag">Edit</span> <span class='btn metatag-delete'
                                    title='Delete Meta Tag'>Delete</span>
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
    
        /* ---- { some objects and enums } ---- */
        
        function MetaTag()
        {
            this.id = null;
            this.name = null;
            this.content = null;
            this.httpEquiv = null;
        }
        
        var MetaTagAction = {
            add: 0,
            remove: 1,
            edit: 2,
            undo: 3 };
        
        
        /* ---- { a few global variables } ---- */
        var msgPanel = $('#messagePanel');
        var msgPanelWrap = msgPanel.parent();
        var noTagsMsg = $('#<%= NoMetatagsMessage.ClientID %>');
        var tagListWrap = $('#<%= MetatagListWrapper.ClientID %>');
        var BTNS_METATAG_TEMPLATE = "<span class='btn metatag-edit' title='Edit Meta Tag'>Edit</span><span class='btn metatag-delete' title='Delete Meta Tag'>Delete</span>"
        
        // a global variable for un-doing an operation
        var undoMetaTag = null;
        
        
        /* ---- { page and event setup } ---- */
        
        // first let's hook up some events
        $(document).ready(function()
        {
            // wire up the Add Button handler
            $(".metatag-add").click(addNewMetaTag);
            
            // wire up the Delete Button handlers
            $("tr[id^='metatag-'] .metatag-delete").click(function()
            {
                // get the table row that holds this meta tag
                var tagRow = $(this).parents("tr[id^='metatag-']");
                
                deleteMetaTag(tagRow);
            });
        });
        
        
        /* ---- { Meta Tag methods } ---- */
        
        function addNewMetaTag()
        {
            createMetaTag(getMetaTagForAction(MetaTagAction.add));
        }
        
        function createMetaTag(metaTag)
        {
            // unbind the click event so a user can't click it until the current action is done.
            var addBtn = $(".metatag-add");
            addBtn.unbind("click").fadeTo("fast", .5);
            hideMessagePanel();
            
            metaTag = ajaxServices.addMetaTagForBlog(metaTag.content, metaTag.name, metaTag.httpEquiv, function(response)
                {
                    if (response.error)
                        handleError(response.error);
                    else
                        onTagCreated(response.result);
                });
            
            // wire the click event back up.
            $(".metatag-add").bind("click", addNewMetaTag).fadeTo("normal", 1);
        }
        
        function onTagCreated(metaTag)
        {
            noTagsMsg.hide();
            tagListWrap.fadeIn("normal");
            
            msgPanelWrap.addClass("success");
            showMessagePanel("Meta Tag successfully added. Tag id = " + metaTag.id + ".");
            
            // add the new metatag to the table
            var tableRow = "<tr class='new' style='display:none'><td>" + checkForNull(metaTag.name) + "</td>";
            tableRow += "<td>" + checkForNull(metaTag.content) + "</td>";
            tableRow += "<td>" + checkForNull(metaTag.httpEquiv) + "</td>";
            tableRow += "<td>" + BTNS_METATAG_TEMPLATE + "</td></tr>";
            
            $("#metatag-table tbody").append(tableRow);
            var newRow = $("#metatag-table tr:last");
            
            newRow.attr('id', 'metatag-' + metaTag.id);
            
            //debugger;
            $('.metatag-delete', newRow).click(function()
            {
                deleteMetaTag(newRow);
            });
            
            newRow.fadeIn("slow");
            newRow.animate( { backgroundColor: 'transparent' }, 2000);
        }
        
        function deleteMetaTag(metaTagRow)
        {
            // partially fade the row and then unbind the click event so the buttons can't be clicked again.
            metaTagRow.fadeTo("fast", .6);
            $("span.btn", metaTagRow).unbind("click").removeClass("btn");
            hideMessagePanel();
        
            var cells = metaTagRow.children('td');
            
            undoMetaTag = new MetaTag();
            undoMetaTag.id = metaTagRow.attr('id').split('metatag-').pop();
            undoMetaTag.name = returnNullForEmpty($(cells[0]).text().trim());
            undoMetaTag.content = $(cells[1]).text().trim();
            undoMetaTag.httpEquiv = returnNullForEmpty($(cells[2]).text().trim());
            
            ajaxServices.deleteMetaTag(undoMetaTag.id, function(response)
                {
                    if (response.error)
                        handleError(response.error);
                    else
                        onTagDeleted(response.result, metaTagRow);
                });
        }
        
        function onTagDeleted(isDeleted, metaTagRow)
        {
            if (!isDeleted)
            {
                msgPanelWrap.addClass("warn");
                showMessagePanel("Could not delete the meta tag... perhaps it's already gone!");
                return;
            }
        
            // fade the row all the way out and the remove it's contents from the DOM.
            metaTagRow.fadeOut(function()
            {
                metaTagRow.empty();
                
                var tagRows = $(metaTagRow.siblings("tr[id^='metatag-']:visible"));
                if (tagRows.length == 0)
                {
                    tagListWrap.hide();
                    noTagsMsg.fadeIn("normal");
                }
            });
            
            msgPanelWrap.addClass("success");
            showMessagePanel("The meta tag was successfully deleted. <span class='btn' title='Bring back your tag!'>Undo</span>");
            
            var undoBtn = msgPanel.find("span");
            undoBtn.click(function()
            {
                undoAction();
            });
        }
        
        function undoAction()
        {
            createMetaTag(getMetaTagForAction(MetaTagAction.undo));
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
        
        function getMetaTagForAction(actionType)
        {
            // if adding a new tag, collect the values from the form
            if (actionType == MetaTagAction.add)
            {
                var tag = new MetaTag();
                
                //TODO: Need to collect values from the form fields
                tag.content = "Just a Test Tag.";
                tag.name = "author";
                
                return tag;
            }
            else if (actionType == MetaTagAction.undo)
            {
                return undoMetaTag;
            }
            
            return null;
        }
        
        function showMessagePanel(message)
        {
            msgPanel.empty();
            msgPanel.append("<p>" + message + "</p>");
            msgPanel.fadeIn("slow");
        }
        
        function hideMessagePanel()
        {
            msgPanel.fadeOut();
            msgPanelWrap.removeClass("error").removeClass("warn").removeClass("info").removeClass("success");
        }
        
        function returnNullForEmpty(val)
        {
            if (val == null || val.length > 0)
                return val;
                
            return null;
        }
        
        function checkForNull(val)
        {
            return val == null ? "" : val;
        }
    </script>

</asp:Content>
