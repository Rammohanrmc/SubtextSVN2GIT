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
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Subtext.Extensibility;
using Subtext.Framework;
using Subtext.Framework.Components;
using Subtext.Framework.Configuration;
using Subtext.Framework.Data;
using Subtext.Framework.Exceptions;
using Subtext.Framework.Text;
using Subtext.Framework.Web;

namespace Subtext.Web.UI.Controls
{
	/// <summary>
	///		Summary description for Comments.
	/// </summary>
	public partial class PostComment : BaseControl
	{
		/// <summary>
		/// Handles the OnLoad event.  Attempts to prepopulate comment 
		/// fields based on the user's cookie.
		/// </summary>
		/// <param name="e">E.</param>
		protected override void OnLoad(EventArgs e)
		{
			base.OnLoad (e);

			//TODO: Make this configurable.
			tbComment.MaxLength = 4000;
			SetValidationGroup();
		
			if(!IsPostBack)
			{
				Entry entry = Cacher.GetEntryFromRequest(CacheDuration.Short);
				if(entry == null)
				{
					//Somebody probably is messing with the url.
					Response.StatusCode = 404;
					Response.Redirect("~/SystemMessages/FileNotFound.aspx", true);
					return;
				}
				
				ResetCommentFields(entry);

				if(Config.CurrentBlog.CoCommentsEnabled)
				{
					if(coComment == null)
					{
						coComment = new SubtextCoComment();
						PlaceHolder coCommentPlaceHolder = Page.FindControl("coCommentPlaceholder") as PlaceHolder;
						if(coCommentPlaceHolder != null)
						{
							coCommentPlaceHolder.Controls.Add(coComment);
						}
					}
					coComment.PostTitle = entry.Title;
					coComment.PostUrl = entry.Url;
					if(entry.Url.StartsWith("/"))
					{
						coComment.PostUrl = "http://" + Config.CurrentBlog.Host + coComment.PostUrl;
					}
				}
			}
		}
		
		void SetValidationGroup()
		{
			foreach(Control control in this.Controls)
			{
				BaseValidator validator = control as BaseValidator;
				if(validator != null)
				{
					validator.ValidationGroup = "SubtextComment";
					continue;
				}

				Button btn = control as Button;
				if (btn != null)
				{
					btn.ValidationGroup = "SubtextComment";
					continue;
				}

				TextBox textbox = control as TextBox;
				if (textbox != null)
				{
					textbox.ValidationGroup = "SubtextComment";
					continue;
				}
			}
		}

		/// <summary>
		/// Called when an approved comment is added.
		/// </summary>
		protected virtual void OnCommentAdded()
		{
			for (int i = this.Controls.Count - 1; i >= 0; i--)
			{
				this.Controls.RemoveAt(i);
			}
			Message = new Label();
			Message.Text = "Thanks for your comment!";
			Message.CssClass = "success";
			this.Controls.Add(Message);
			
			//TODO: Provide some means to add a new comment. For now they can click the title to refresh the page.
			
			EventHandler<EventArgs> theEvent = CommentPosted;
			if (theEvent != null)
				theEvent(this, EventArgs.Empty);
		}
		
		public event EventHandler<EventArgs> CommentPosted;

		#region Web Form Designer generated code
		override protected void OnInit(EventArgs e)
		{
			//
			// CODEGEN: This call is required by the ASP.NET Web Form Designer.
			//
			InitializeComponent();
			base.OnInit(e);
		}
		
		///		Required method for Designer support - do not modify
		///		the contents of this method with the code editor.
		/// </summary>
		private void InitializeComponent()
		{
			if(this.btnSubmit != null)
			{
				this.btnSubmit.Click += new System.EventHandler(this.btnSubmit_Click);
			}

			if(this.btnCompliantSubmit != null)
			{
				this.btnCompliantSubmit.Click += new EventHandler(this.btnSubmit_Click);
			}
		}
		#endregion

		private void btnSubmit_Click(object sender, EventArgs e)
		{
			if(Page.IsValid)
			{
				try
				{
					Entry currentEntry =  Cacher.GetEntryFromRequest(CacheDuration.Short);	
					if(IsCommentAllowed(currentEntry))
					{
						FeedbackItem feedbackItem = new FeedbackItem(FeedbackType.Comment);
						feedbackItem.Author = tbName.Text;
						if(this.tbEmail != null)
							feedbackItem.Email = tbEmail.Text;
						feedbackItem.SourceUrl =  HtmlHelper.CheckForUrl(tbUrl.Text);
						feedbackItem.Body = tbComment.Text;
						feedbackItem.Title = tbTitle.Text;
						feedbackItem.EntryId = currentEntry.Id;
						feedbackItem.IpAddress = HttpHelper.GetUserIpAddress(Context);

						FeedbackItem.Create(feedbackItem);
						CommentFilter filter = new CommentFilter(HttpContext.Current.Cache);
						filter.DetermineFeedbackApproval(feedbackItem);

						if (feedbackItem.Approved)
							OnCommentAdded();

						if(chkRemember == null || chkRemember.Checked)
						{
							HttpCookie user = new HttpCookie("CommentUser");
							user.Values["Name"] = tbName.Text;
							user.Values["Url"] = tbUrl.Text;
							if(tbEmail!=null)
								user.Values["Email"] = tbEmail.Text;
							user.Expires = DateTime.Now.AddDays(30);
							Response.Cookies.Add(user);
						}

						ResetCommentFields(currentEntry);

						if(Config.CurrentBlog.ModerationEnabled)
						{
							Message.Text = "Thank you for your comment.  It will be displayed soon.";
						}
					}
				}
				catch(BaseCommentException exception)
				{
					Message.Text = exception.Message;
				}
			}
		}

		private void ResetCommentFields(Entry entry)
		{
			if (this.tbComment != null)
				this.tbComment.Text = string.Empty;
			
			if (this.tbEmail != null)
				this.tbEmail.Text = string.Empty;
			
			if (this.tbName != null)
				this.tbName.Text = string.Empty;
			
			if(entry == null)
				entry = Cacher.GetEntryFromRequest(CacheDuration.Short);
			
			if (this.tbTitle != null)
				this.tbTitle.Text = "re: " + HttpUtility.HtmlDecode(entry.Title);
			
			if (this.tbUrl != null)
				this.tbUrl.Text = string.Empty;

			HttpCookie user = Request.Cookies["CommentUser"];
			if (user != null)
			{
				tbName.Text = user.Values["Name"];
				tbUrl.Text = user.Values["Url"];

				// Remember by default if no-checkbox.
				if (this.chkRemember != null && this.chkRemember.Checked)
				{
					this.chkRemember.Checked = true;
				}

				//Check to see if email textbox is present
				if (this.tbEmail != null && user.Values["Email"] != null)
				{
					this.tbEmail.Text = user.Values["Email"];
				}
			}

			if (IsCommentsRendered(entry))
			{
				if (entry.CommentingClosed)
				{
					this.Controls.Clear();
					this.Controls.Add(new LiteralControl("<div class=\"commentsClosedMessage\"><span style=\"font-style: italic;\">Comments have been closed on this topic.</span></div>"));
				}
				else
				{
					tbTitle.Text = "re: " + HttpUtility.HtmlDecode(entry.Title);
				}
			}
			else
			{
				this.Controls.Clear();
			}
		}

		bool IsCommentsRendered(Entry entry)
		{
			return CurrentBlog.CommentsEnabled && entry != null && entry.AllowComments;
		}
		
		bool IsCommentAllowed(Entry entry)
		{
			return CurrentBlog.CommentsEnabled && entry != null && entry.AllowComments && !entry.CommentingClosed;
		}
	}
}

