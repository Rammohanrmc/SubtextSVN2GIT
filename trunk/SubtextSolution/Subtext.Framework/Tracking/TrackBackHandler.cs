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

#region Notes
 ///////////////////////////////////////////////////////////////////////////////////////////////////
 // The code in this file is freely distributable.
 // 
 // ASPNetWeblog is not responsible for, shall have no liability for 
 // and disclaims all warranties whatsoever, expressed or implied, related to this code,
 // including without limitation any warranties related to performance, security, stability,
 // or non-infringement of title of the control.
 // 
 // If you have any questions, comments or concerns, please contact
 // Scott Watermasysk, Scott@TripleASP.Net.
 // 
 // For more information on this control, updates, and other tools to integrate blogging 
 // into your existing applications, please visit, http://aspnetweblog.com
 // 
 // Based off of code by Simon Fell http://www.pocketsoap.com/weblog/ 
 // 
 ///////////////////////////////////////////////////////////////////////////////////////////////////
#endregion
using System;
using System.Globalization;
using System.Web;
using System.Xml;
using Subtext.Extensibility;
using Subtext.Framework.Components;
using Subtext.Framework.Configuration;
using Subtext.Framework.Exceptions;
using Subtext.Framework.Logging;
using Subtext.Framework.Text;
using Subtext.Framework.Util;

namespace Subtext.Framework.Tracking
{
	/// <summary>
	/// Service used to receive trackbacks from remote clients.
	/// </summary>
	public class TrackBackHandler : IHttpHandler
	{
		static Log Log = new Log();
		
		/// <summary>
		/// Initializes a new instance of the <see cref="TrackBackHandler"/> class.
		/// </summary>
		public TrackBackHandler() 
		{
		}
	
		/// <summary>
		/// Enables processing of HTTP Web requests by a custom
		/// <see langword="HttpHandler "/>
		/// that implements the <see cref="T:System.Web.IHttpHandler"/> interface.
		/// </summary>
		/// <param name="context">An <see cref="T:System.Web.HttpContext"/> object that provides references to the intrinsic server objects (for example, <see langword="Request"/>, <see langword="Response"/>, <see langword="Session"/>, and <see langword="Server"/>)<see langword=""/> used to service HTTP requests.</param>
		public void ProcessRequest(HttpContext context)
		{
			if(!Config.CurrentBlog.TrackbacksEnabled)
				return;
			try
			{
				HandleTrackback(context);
			}
			catch(BaseCommentException e)
			{
				Log.Info("Comment exception occurred.", e);
			}
		}

		private void HandleTrackback(HttpContext context)
		{
			context.Response.ContentType = "text/xml";

			int postId = 0 ;
            try
            {
                postId = WebPathStripper.GetEntryIDFromUrl(context.Request.Path);
            }
            catch (ArgumentException e)
            {
                Log.Info("Could not extract entry id from incoming URL." + e.Message, e);
                SendTrackbackResponse(context, TrackbackResponseCode.Error, "EntryID is invalid or missing");
            }
            catch (FormatException e)
            {
                Log.Info("Could not extract entry id from incoming URL." + e.Message, e);
                SendTrackbackResponse(context, TrackbackResponseCode.Error, "EntryID is invalid or missing");
            }

			Entry entry = Entries.GetEntry(postId, PostConfig.IsActive, false);
			if(entry == null)
			{
                SendTrackbackResponse(context, TrackbackResponseCode.Error, "EntryID is invalid or missing");
				return;
			}

			if(context.Request.HttpMethod == "POST")
			{
				CreateTrackbackAndSendResponse(context, entry, postId);
			}
			else
			{
				SendTrackbackRss(context, entry, postId);
			}
		}

		private static void SendTrackbackRss(HttpContext context, Entry entry, int postId)
		{	    
		    XmlTextWriter w = new XmlTextWriter(context.Response.Output) ;
			w.Formatting = Formatting.Indented;

			w.WriteStartDocument() ;
			w.WriteStartElement("response") ;
			w.WriteElementString("error", "0") ;
			w.WriteStartElement("rss") ;
			w.WriteAttributeString("version", "0.91") ;
			w.WriteStartElement("channel") ;
			w.WriteElementString("title", entry.Title ) ;
			w.WriteElementString("link", Config.CurrentBlog.UrlFormats.TrackBackUrl(postId));
			w.WriteElementString("description", "" ) ;
			w.WriteElementString("language", "en-us" ) ;

			w.WriteEndElement(); // channel
			w.WriteEndElement(); // rss 
			w.WriteEndElement(); // response
			w.WriteEndDocument();
		}

		private void CreateTrackbackAndSendResponse(HttpContext context, Entry entry, int entryId)
		{
			string title     = SafeParam(context, "title");
			string excerpt   = SafeParam(context, "excerpt");
			string urlText   = SafeParam(context, "url");
			string blog_name = SafeParam(context, "blog_name");
		
			Uri url = HtmlHelper.ParseUri(urlText);
			if(url == null)
			{
                SendTrackbackResponse(context, TrackbackResponseCode.Error, "no url parameter found, please try harder!");
				return;
			}

			if (entry == null || !IsSourceVerification(url, entry.FullyQualifiedUrl))
			{
                SendTrackbackResponse(context, TrackbackResponseCode.Error, "Sorry couldn't find a relevant link in " + url);
				return;
			}

			Trackback trackback = new Trackback(entryId, title, url, blog_name, excerpt);

			FeedbackItem.Create(trackback, new CommentFilter(HttpContext.Current.Cache));
		}
		
		/// <summary>
		/// Gets a value indicating whether another request can use
		/// the <see cref="T:System.Web.IHttpHandler"/>
		/// instance.
		/// </summary>
		/// <value></value>
		public bool IsReusable
		{
			get { return true; }
		}

        private static void SendTrackbackResponse(HttpContext context, TrackbackResponseCode errorNumber, string errorMessage)
		{
			XmlDocument d = new XmlDocument();
			XmlElement root = d.CreateElement("response");
			d.AppendChild(root) ;
			XmlElement er = d.CreateElement("error");
			root.AppendChild(er) ;
			er.AppendChild(d.CreateTextNode(errorNumber.ToString()));
			if (errorMessage.Length > 0)
			{
				XmlElement msg = d.CreateElement("message");
				root.AppendChild(msg) ;
				msg.AppendChild(d.CreateTextNode(errorMessage));
			}
			d.Save(context.Response.Output);
			context.Response.Output.Flush();
		}

		private static string SafeParam(HttpContext context, string pName)
		{
			if (context.Request.Form[pName] != null)
			{
				return HtmlHelper.SafeFormat(context.Request.Form[pName]);
			}
			return string.Empty;
		}
		
		public delegate void SourceVerificationEventHandler(object sender, SourceVerificationEventArgs e);
		
		public event SourceVerificationEventHandler SourceVerification;
		
		private bool IsSourceVerification(Uri sourceUrl, Uri entryUrl)
		{
			SourceVerificationEventHandler handler = SourceVerification;
			if(handler != null)
			{
				SourceVerificationEventArgs args = new SourceVerificationEventArgs(sourceUrl, entryUrl);
				handler(this, args);
				return args.Verified;
			}
			else
			{
				return Verifier.SourceContainsTarget(sourceUrl, entryUrl);
			}
		}
	}
	
	/// <summary>
	/// Event arguments for the SourceVerification event.
	/// </summary>
	public class SourceVerificationEventArgs : EventArgs
	{
		Uri sourceUrl;
		Uri entryUrl;
		bool verified;
		
		/// <summary>
		/// Initializes a new instance of the <see cref="SourceVerificationEventArgs"/> class.
		/// </summary>
		/// <param name="sourceUrl">The source URL.</param>
		/// <param name="entryUrl">The entry URL.</param>
		public SourceVerificationEventArgs(Uri sourceUrl, Uri entryUrl) : base()
		{
			this.sourceUrl = sourceUrl;
			this.entryUrl = entryUrl;
		}
		
		/// <summary>
		/// Gets the source URL.
		/// </summary>
		/// <value>The source URL.</value>
		public Uri SourceUrl
		{
			get
			{
				return this.sourceUrl;
			}
		}
		
		/// <summary>
		/// Gets the entry URL.
		/// </summary>
		/// <value>The entry URL.</value>
		public Uri EntryUrl
		{
			get
			{
				return this.entryUrl;
			}
		}
		
		/// <summary>
		/// Gets a value indicating whether this <see cref="SourceVerificationEventArgs"/> is verified.
		/// </summary>
		/// <value><c>true</c> if verified; otherwise, <c>false</c>.</value>
		public bool Verified
		{
			get
			{
				return this.verified;
			}
			set
			{
				verified = value;
			}
		}
		
	}
}