#region Disclaimer/Info
///////////////////////////////////////////////////////////////////////////////////////////////////
// Subtext WebLog
// 
// Subtext is an open source weblog system that is a fork of the .TEXT
// weblog system.
//
// For updated news and information please visit http://subtextproject.com/
// Subtext is hosted at SourceForge at http://sourceforge.net/projects/subtext
// The development mailing list is at subtext-devs@lists.sourceforge.net 
//
// This project is licensed under the BSD license.  See the License.txt file for more information.
///////////////////////////////////////////////////////////////////////////////////////////////////
#endregion

using System;
using System.Web.UI.WebControls;
using Subtext.Framework;
using Subtext.Framework.Components;
using Subtext.Framework.Configuration;
using Subtext.Framework.Format;
using Subtext.Web.Controls;

namespace Subtext.Web.UI.Controls
{
	/// <summary>
	/// Control used to display a list of entries.
	/// </summary>
	public class EntryList : BaseControl
	{
		protected System.Web.UI.WebControls.Repeater Entries;
		protected System.Web.UI.WebControls.Literal EntryCollectionTitle;
		protected System.Web.UI.WebControls.Literal EntryCollectionDescription;
		protected System.Web.UI.WebControls.HyperLink EntryCollectionReadMoreLink;

		const string linkToComments = "<a href=\"{0}#feedback\" title=\"View and Add Comments\">{1}{2}</a>";
		const string postdescWithComments = "posted @ <a href=\"{0}\" title = \"Permanent link to this post\">{1}</a> | <a href=\"{2}#feedback\" title = \"comments, pingbacks, trackbacks\">Feedback ({3})</a>";
		const string postdescWithNoComments = "posted @ <a href=\"{0}\" title = \"Permanent link to this post\">{1}</a>";
		
		protected virtual void PostCreated(object sender,  RepeaterItemEventArgs e)
		{
			if(e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
			{
				Entry entry = (Entry)e.Item.DataItem;
				if(entry != null)
				{
					// Each of these methods make sure to check that the 
					// control to bind actually exists on the skin.
					BindTitle(e, entry);
					BindEditLink(entry, e);
					BindPostText(e, entry);
					BindPostDescription(e, entry);
					BindPermalink(e, entry);
					BindPostDate(e, entry);
					BindCommentCount(e, entry);
					BindAuthor(e, entry);
					BindCurrentEntryControls(entry, e.Item);
				}
			}
		}

		private static void BindAuthor(RepeaterItemEventArgs e, Entry entry)
		{
			Label author = e.Item.FindControl("author") as Label;
			if(author != null)
			{
				if(entry.Author != null && entry.Author.Length > 0)
				{
					author.Text = entry.Author;
				}
			}
		}

		private static void BindCommentCount(RepeaterItemEventArgs e, Entry entry)
		{
			Label commentCount = e.Item.FindControl("commentCount") as Label;
			if(commentCount != null)
			{
				if(Config.CurrentBlog.CommentsEnabled && entry.AllowComments)
				{
					if(entry.FeedBackCount == 0)
					{
						commentCount.Text = string.Format(linkToComments, entry.Link, "Add Comment", "");
					}
					else if(entry.FeedBackCount == 1)
					{
						commentCount.Text = string.Format(linkToComments, entry.Link, "One Comment", "");
					}
					else if(entry.FeedBackCount > 1)
					{
						commentCount.Text = string.Format(linkToComments, entry.Link, entry.FeedBackCount, " Comments");
					}
				}
			}
		}

		private static void BindPostDate(RepeaterItemEventArgs e, Entry entry)
		{
			Label postDate = e.Item.FindControl("postDate") as Label;
			if(postDate != null)
			{
				if(postDate.Attributes["Format"] != null)
				{
					postDate.Text = entry.DateCreated.ToString(postDate.Attributes["Format"]);
					postDate.Attributes.Remove("Format");
				}
				else
				{
					postDate.Text = entry.DateCreated.ToString("f");
				}
			}
		}

		private static void BindPermalink(RepeaterItemEventArgs e, Entry entry)
		{
			Label permalink = e.Item.FindControl("permalink") as Label;
			if(permalink != null)
			{
				if(permalink.Attributes["Format"] != null)
				{
					permalink.Text = string.Format("<a href=\"{0}\" title=\"Permanent link to this post\">{1}</a>", entry.Link, entry.DateCreated.ToString(permalink.Attributes["Format"]));
					permalink.Attributes.Remove("Format");
				}
				else
				{
					permalink.Text = string.Format("<a href=\"{0}\" title=\"Permanent link to this post\">{1}</a>", entry.Link, entry.DateCreated.ToString("f"));
				}
			}
		}

		private static void BindPostDescription(RepeaterItemEventArgs e, Entry entry)
		{
			Literal PostDesc = (Literal)e.Item.FindControl("PostDesc");
			if(PostDesc != null)
			{
						
				if(entry.AllowComments)
				{
					PostDesc.Text = string.Format(postdescWithComments, entry.Link, entry.DateCreated.ToString("f"), entry.Link, entry.FeedBackCount);
				}
				else
				{
					PostDesc.Text = string.Format(postdescWithNoComments, entry.Link, entry.DateCreated.ToString("f"));
				}
			}
		}

		private void BindPostText(RepeaterItemEventArgs e, Entry entry)
		{
			Literal PostText = (Literal)e.Item.FindControl("PostText");
	
			if(DescriptionOnly)
			{
				if(entry.HasDescription)
				{
						
					PostText.Text = string.Format(System.Globalization.CultureInfo.InvariantCulture, "<p>{0}</p>",entry.Description);
				}
			}
			else
			{
				if(entry.HasDescription)
				{
					PostText.Text = entry.Description;
				}
				else
				{
					PostText.Text = entry.Body;
				}
			}
		}

		private static void BindTitle(RepeaterItemEventArgs e, Entry entry)
		{
			HyperLink title = e.Item.FindControl("TitleUrl") as HyperLink;
			if(title != null)
			{
				title.Text = entry.Title;
				ControlHelper.SetTitleIfNone(title, "Click To View Entry.");
				title.NavigateUrl = entry.Link;
			}
		}

		// If the user is an admin AND the the skin 
		// contains an edit Hyperlink control, this 
		// will display the edit control.
		protected virtual void BindEditLink(Entry entry, RepeaterItemEventArgs e)
		{
			HyperLink editLink = e.Item.FindControl("editLink") as HyperLink;
			if(editLink != null)
			{
				if(Security.IsAdmin)
				{
					editLink.Visible = true;
					if(editLink.Text.Length == 0 && editLink.ImageUrl.Length == 0)
					{
						//We'll slap on our little pencil icon.
						editLink.ImageUrl = "~/Images/edit.gif";
						ControlHelper.SetTitleIfNone(editLink, "Click to edit this entry.");
						editLink.NavigateUrl = UrlFormats.GetEditLink(entry);
					}
				}
				else
				{
					editLink.Visible = false;
				}
			}
		}

		private EntryCollection entries;
		public EntryCollection EntryListItems
		{
			get{return entries;}
			set{entries = value;}
		}

		private bool descriptionOnly = true;
		public bool DescriptionOnly
		{
			get{return descriptionOnly;}
			set{descriptionOnly = value;}
		}

		private string entryListTitle;
		public string EntryListTitle
		{
			get{return entryListTitle;}
			set{entryListTitle = value;}
		}

		private string _entryListDescription;
		public string EntryListDescription
		{
			get {return this._entryListDescription;}
			set {this._entryListDescription = value;}
		}

		private string _entryListReadMoreText;
		public string EntryListReadMoreText
		{
			get {return this._entryListReadMoreText;}
			set {this._entryListReadMoreText = value;}
		}

		private string _entryListReadMoreUrl;
		public string EntryListReadMoreUrl
		{
			get {return this._entryListReadMoreUrl;}
			set {this._entryListReadMoreUrl = value;}
		}
		
		protected override void OnLoad(EventArgs e)
		{
			base.OnLoad (e);

			if(EntryListItems != null)
			{
				EntryCollectionTitle.Text = EntryListTitle;

				if(EntryListDescription != null)
				{
					this.EntryCollectionDescription.Text = EntryListDescription;
				}
				else
				{
					EntryCollectionDescription.Visible = false;
				}

				if(EntryListReadMoreUrl != null && EntryListReadMoreText != null)
				{
					this.EntryCollectionReadMoreLink.Text = EntryListReadMoreText;
					this.EntryCollectionReadMoreLink.NavigateUrl = EntryListReadMoreUrl;
				}
				else
				{
					EntryCollectionReadMoreLink.Visible = false;
				}

				Entries.DataSource = EntryListItems;
				Entries.DataBind();
			}
		}
	}
}

