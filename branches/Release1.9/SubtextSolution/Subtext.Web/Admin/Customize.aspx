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
    <div id="metatag-content">
        <asp:Panel GroupingText="Meta Tags" CssClass="options fluid" runat="server">
            <div class="right">
                <span class="btn metatag-add" title="Add a New Meta Tag">Add Meta Tag</span>
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
                        <tr id="metatag-add-row" style="display: none;">
                            <td>
                                <input type="text" />
                            </td>
                            <td>
                                <input type="text" />
                            </td>
                            <td>
                                <input type="text" />
                            </td>
                            <td>
                                <span class="btn metatag-save" title="Save the Meta Tag">Save</span> <span class="btn metatag-cancel"
                                    title="Cancel Changes">Cancel</span>
                            </td>
                        </tr>
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
            //$(".metatag-add").click(showAddMetaTagUI);
            $(".metatag-add").click(function() 
            {
                var theRow = $("#metatag-add-row");
                theRow.fadeIn("slow", function() { $(":input", theRow)[0].focus(); });
            });
            
            // wire up the Delete Button handlers
            $("tr[id^='metatag-'] .metatag-delete").click(function()
            {
                // get the table row that holds this meta tag
                var tagRow = $(this).parents("tr[id^='metatag-']");
                
                deleteMetaTag(tagRow);
            });
            
            $(".metatag-save").click(saveMetaTag);
            $(".metatag-cancel").click(clearAndHideAddMetaTagUI);
            
            // setup some hotkeys
            $.hotkeys.add("return", { target:jQuery("#metatag-add-row")[0] }, function()
                { $(".metatag-save").click(); });
        });
        
        
        /* ---- { Meta Tag methods } ---- */
        
        function clearAndHideAddMetaTagUI()
        {
            var theRow = $("#metatag-add-row");
            
            theRow.fadeOut("fast");
            $(":input", theRow).each(function() 
                {
                    $(this).val("");
                });
        }
        
        function saveMetaTag()
        {
            hideMessagePanel();
            createMetaTag(getMetaTagForAction(MetaTagAction.add));
        }
        
        function createMetaTag(metaTag)
        {
            // unbind the click event so a user can't click it until the current action is done.
            var addBtn = $(".metatag-save");
            addBtn.unbind("click").fadeTo("fast", .5);
            
            metaTag = ajaxServices.addMetaTagForBlog(metaTag.content, metaTag.name, metaTag.httpEquiv, function(response)
                {
                    // wire the click events back up.
                    $(".metatag-save").bind("click", saveMetaTag).fadeTo("normal", 1);
                    
                    if (response.error)
                        handleError(response.error);
                    else
                    {
                        clearAndHideAddMetaTagUI();
                        onTagCreated(response.result);
                    }
                });
        }
        
        function onTagCreated(metaTag)
        {
            hideMessagePanel();
            noTagsMsg.hide();
            tagListWrap.fadeIn("normal");
            
            msgPanelWrap.addClass("success");
            showMessagePanel("Meta Tag successfully added. Tag id = " + metaTag.id + ".");
            
            // add the new metatag to the table
            var tableRow = "<tr class='new' style='display:none'><td>" + checkForNull(metaTag.name) + "</td>";
            tableRow += "<td>" + checkForNull(metaTag.content) + "</td>";
            tableRow += "<td>" + checkForNull(metaTag.httpEquiv) + "</td>";
            tableRow += "<td>" + BTNS_METATAG_TEMPLATE + "</td></tr>";
            
            $("#metatag-add-row").before(tableRow);
            //$("#metatag-table tbody").append(tableRow);
            var newRow = $("#metatag-table tr.new:last");
            
            newRow.attr('id', 'metatag-' + metaTag.id);
            
            //debugger;
            $('.metatag-delete', newRow).click(function()
            {
                deleteMetaTag(newRow);
            });
            
            newRow.show();
            newRow.animate( { backgroundColor: 'transparent' }, 5000);
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
            hideMessagePanel();
            
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
            hideMessagePanel();
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
                var inputBoxes = $("#metatag-add-row :input");
                tag.name = $(inputBoxes[0]).val();
                tag.content = $(inputBoxes[1]).val();
                tag.httpEquiv = $(inputBoxes[2]).val();
                
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
