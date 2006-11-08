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
using System.Configuration;
using System.Globalization;
using System.Web.Security;
using System.Web.UI.WebControls;
using log4net;
using Subtext.Extensibility;
using Subtext.Framework;
using Subtext.Framework.Components;
using Subtext.Framework.Data;
using Subtext.Framework.Logging;
using Subtext.Framework.Text;
using Subtext.Web.Controls;
using Image = System.Web.UI.WebControls.Image;
using Subtext.Framework.Security;

namespace Subtext.Web.UI.Controls
{
	/// <summary>
	///	Codebehind for the control that displays comments/trackbacks/pingbacks.
	/// </summary>
	public class Comments : BaseControl
	{
		static ILog log = new Log();
		
		protected Repeater CommentList;
		protected Literal NoCommentMessage;

		private bool gravatarEnabled;
		private string gravatarUrlFormatString;
		private string gravatarEmailFormat;

		protected override void OnLoad(EventArgs e)
		{
			base.OnLoad (e);

			try
			{
                gravatarEnabled = Convert.ToBoolean(ConfigurationManager.AppSettings["GravatarEnabled"]);
			}
			catch(Exception) 
			{
				gravatarEnabled = false;
			}
			
			if(gravatarEnabled) 
			{
                gravatarUrlFormatString = ConfigurationManager.AppSettings["GravatarUrlFormatString"];
                gravatarEmailFormat = ConfigurationManager.AppSettings["GravatarEmailFormat"];
			}

			if(CurrentBlog.CommentsEnabled)
			{
				BindFeedback(true);
			}
			else
			{
				Visible = false;
			}
			
		}

		internal void BindFeedback(bool fromCache)
		{
			Entry entry = Cacher.GetEntryFromRequest(CacheDuration.Short);	

			if(entry != null && entry.AllowComments)
			{
				BindFeedback(entry, fromCache);
			}
			else
			{
				Visible = false;
			}
		}
		
		protected void RemoveComment_ItemCommand(Object Sender, RepeaterCommandEventArgs e) 
		{
			int feedbackId = Int32.Parse(e.CommandName);
			FeedbackItem feedback = FeedbackItem.Get(feedbackId);
			if (feedback != null)
			{
				FeedbackItem.Delete(feedback);
				Cacher.ClearCommentCache(feedback.EntryId);
				BindFeedback(false);
			}
			//Response.Redirect(string.Format(CultureInfo.InvariantCulture, "{0}?Pending=true", Request.Path));
		}

		// Customizes the display row for each comment.
		protected void CommentsCreated(object sender,  RepeaterItemEventArgs e)
		{
			if(e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
			{
				FeedbackItem feedbackItem = (FeedbackItem)e.Item.DataItem;
				if(feedbackItem != null)
				{
					Literal title = (Literal)(e.Item.FindControl("Title"));
					if(title != null)
					{
						// we should probably change skin format to dynamically wire up to 
						// skin located title and permalinks at some point
						title.Text = string.Format(CultureInfo.InvariantCulture, "{2}&nbsp;{0}{1}", Anchor(feedbackItem.Id), 
							feedbackItem.Title, Link(feedbackItem.Title, feedbackItem.SourceUrl));
					}

					//Shows the name of the commenter with a link if provided.
					HyperLink namelink = (HyperLink)e.Item.FindControl("NameLink");
					if(namelink != null)
					{
						if(feedbackItem.SourceUrl != null)
						{
							namelink.NavigateUrl = feedbackItem.SourceUrl.ToString();
							ControlHelper.SetTitleIfNone(namelink, feedbackItem.SourceUrl.ToString());
						}				
						
						if (feedbackItem.FeedbackType == FeedbackType.Comment)
						{
							namelink.Text = feedbackItem.Author;
							ControlHelper.SetTitleIfNone(namelink, feedbackItem.Author);
						}
						else if (feedbackItem.FeedbackType == FeedbackType.PingTrack)
						{
							namelink.Text =  feedbackItem.Author != null ? feedbackItem.Author : "Pingback/TrackBack";
							namelink.Attributes.Add("title", "PingBack/TrackBack");
						}
					
						if(feedbackItem.IsBlogAuthor)
							HtmlHelper.AppendCssClass(namelink, "author");
					}

					Literal PostDate = (Literal)(e.Item.FindControl("PostDate"));
					if(PostDate != null)
					{
						PostDate.Text = feedbackItem.DateCreated.ToShortDateString() + " " + feedbackItem.DateCreated.ToShortTimeString();
					}

					Literal Post = e.Item.FindControl("PostText") as Literal;
					if(Post != null)
					{
						if(feedbackItem.Body.Length > 0)
						{
							Post.Text = feedbackItem.Body;
							if (feedbackItem.Body.Length == 0 && feedbackItem.FeedbackType == FeedbackType.PingTrack)
							{
								Post.Text = "Pingback / Trackback";
							}
						}
					}
					
					if(gravatarEnabled)
					{
						Image gravatarImage = e.Item.FindControl("GravatarImg") as Image;
						if(gravatarImage != null) 
						{
							//This allows per-skin configuration of the default gravatar image.
							string defaultGravatarImage = gravatarImage.Attributes["PlaceHolderImage"];
							if (String.IsNullOrEmpty(defaultGravatarImage))
								defaultGravatarImage = ConfigurationManager.AppSettings["GravatarDefaultImage"];

							//This allows a host-wide setting of the default gravatar image.
							string gravatarUrl = null;
							if (!String.IsNullOrEmpty(feedbackItem.Email))
								gravatarUrl = BuildGravatarUrl(feedbackItem.Email, defaultGravatarImage);
							
							if(!String.IsNullOrEmpty(gravatarUrl))
							{
								gravatarImage.Attributes.Remove("PlaceHolderImage");
								if(gravatarUrl.Length != 0)
								{
									gravatarImage.ImageUrl = gravatarUrl;
									gravatarImage.Visible = true;
								}
							}
						}
					}

					if(Request.IsAuthenticated && SecurityHelper.IsAdmin)
					{
						LinkButton editlink = (LinkButton)(e.Item.FindControl("EditLink"));
						if(editlink != null)
						{
							//editlink.CommandName = "Remove";
							editlink.Text = "Remove Comment " + feedbackItem.Id.ToString(CultureInfo.InvariantCulture);
							editlink.CommandName = feedbackItem.Id.ToString(CultureInfo.InvariantCulture);
							editlink.Attributes.Add("onclick","return confirm(\"Are you sure you want to delete comment " + feedbackItem.Id.ToString(CultureInfo.InvariantCulture) + "?\");");
							editlink.Visible = true;
							editlink.CommandArgument = feedbackItem.Id.ToString(CultureInfo.InvariantCulture);

							ControlHelper.SetTitleIfNone(editlink, "Click to remove this entry.");
						}
						else
						{
							editlink.Visible = false;
						}
					}
				}
			}
		}

		const string linktag = "<a title=\"permalink: {0}\" href=\"{1}\">#</a>";
		private string Link(string title, Uri link)
		{
			if (link == null)
				return string.Empty;
			
			return string.Format(linktag, title, link.ToString());
		}

		// GC: xhmtl format wreaking havoc in non-xhtml pages in non-IE, changed to non nullable format
		const string anchortag = "<a name=\"{0}\"></a>";
		private string Anchor(int id)
		{
			return string.Format(anchortag, id);
		}

		private string BuildGravatarUrl(string email, string defaultGravatar) 
		{
			string processedEmail = string.Empty;

			if (Request.Url.Port != 80)
				defaultGravatar = string.Format("{0}://{1}:{2}{3}", Request.Url.Scheme, Request.Url.Host, Request.Url.Port, ControlHelper.ExpandTildePath(defaultGravatar));
			else
				defaultGravatar = string.Format("{0}://{1}{2}", Request.Url.Scheme, Request.Url.Host, ControlHelper.ExpandTildePath(defaultGravatar));

			if(gravatarEmailFormat.Equals("plain"))
			{
				processedEmail = email;
			}
			else if(gravatarEmailFormat.Equals("MD5")) 
			{
				processedEmail=FormsAuthentication.HashPasswordForStoringInConfigFile(email, "md5");
			}
			if(processedEmail.Length != 0)
                return String.Format(gravatarUrlFormatString, processedEmail, defaultGravatar);
			else
				return string.Empty;
		}

		internal void BindFeedback(Entry entry, bool fromCache)
		{
			try
			{
				CommentList.DataSource = Cacher.GetFeedback(entry, CacheDuration.Short, fromCache);
				CommentList.DataBind();

				if(CommentList.Items.Count == 0)
				{
					if (entry.CommentingClosed)
					{
						Controls.Clear();
					}
					else
					{
						CommentList.Visible = false;
						NoCommentMessage.Text = "No comments posted yet.";
					}
				}
			}
			catch(Exception e)
			{
				log.Error(e.Message, e);
				Visible = false;
			}
		}
	}
}

