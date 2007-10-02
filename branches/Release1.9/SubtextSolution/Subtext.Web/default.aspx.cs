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
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Globalization;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Subtext.Framework.Components;
using Subtext.Framework.Configuration;
using Subtext.Framework.Providers;

namespace Subtext.Web
{
	/// <summary>
	/// Summary description for _default.
	/// </summary>
	public partial class _default : Page
	{
		protected HyperLink Hyperlink6;
		protected HyperLink Hyperlink7;

		protected void Page_Load(object sender, EventArgs e)
		{
            //No postbacks on this page. It is output cached.
			BindData();
			SetStyle();
		}

		private string aggregateUrl = null;
		/// <summary>
		/// Url to the aggregate page.
		/// </summary>
		protected string AggregateUrl
		{
			get
			{
				if (this.aggregateUrl == null)
				{
					this.aggregateUrl = ConfigurationManager.AppSettings["AggregateUrl"];
					if (Request.Url.Port != 80)
					{
						UriBuilder url = new UriBuilder(aggregateUrl);
						url.Port = Request.Url.Port;
						this.aggregateUrl = url.ToString();
					}
				}
				return aggregateUrl;
			}
		}

		protected string GetEntryUrl(string host, string app, string entryName, DateTime dt)
		{			
			return string.Format(CultureInfo.InvariantCulture, "{0}archive/{1:yyyy/MM/dd}/{2}.aspx", GetFullUrl(host, app), dt, entryName);
		}

		private void SetStyle()
		{
			const string style = "<link href=\"{0}{1}\" type=\"text/css\" rel=\"stylesheet\">";
			string apppath = HttpContext.Current.Request.ApplicationPath.EndsWith("/") ? HttpContext.Current.Request.ApplicationPath : HttpContext.Current.Request.ApplicationPath + "/";
			Style.Text = string.Format(style,apppath,"Style.css") + "\n" + string.Format(style,apppath,"blue.css");
		}

		private string appPath;
		readonly string fullUrl = HttpContext.Current.Request.Url.Scheme + "://{0}{1}{2}/";
		
		protected string GetFullUrl(string host, string app)
		{
			if(appPath == null)
			{
				appPath = HttpContext.Current.Request.ApplicationPath;
				if(!appPath.ToLower(CultureInfo.InvariantCulture).EndsWith("/"))
				{
					appPath += "/";
				}
			}

			if(Request.Url.Port != 80)
			{
				host += ":" + Request.Url.Port;
			}

			return string.Format(fullUrl, host, appPath, app);

		}

		private void BindData()
		{
			int groupId = 1;

			if(Request.QueryString["GroupID"] !=null)
			{
				Int32.TryParse(Request.QueryString["GroupID"], out groupId);
			}

			IList<BlogGroup> groups = Config.ListBlogGroups(true);
			this.blogGroupRepeater.DataSource = groups;

			BlogGroup currentGroup = Config.GetBlogGroup(groupId, true);
			this.Bloggers.DataSource = currentGroup.Blogs;

			DataSet ds = DbProvider.Instance().GetAggregateHomePageData(groupId);
			RecentPosts.DataSource = ds.Tables[1];

			DataTable dtCounts = ds.Tables[2];
			if(dtCounts != null)
			{
				DataRow dr = dtCounts.Rows[0];
				BlogCount.Text = dr["BlogCount"].ToString();
				PostCount.Text = dr["PostCount"].ToString();
				StoryCount.Text = dr["StoryCount"].ToString();
				CommentCount.Text = dr["CommentCount"].ToString();
				PingtrackCount.Text = dr["PingtrackCount"].ToString();

			}

			DataBind();

			ds.Clear();
			ds.Dispose();

		}

		protected static string FormatDate(string date)
		{
			DateTime dt = DateTime.Parse(date);
			return dt.ToString("MMddyyyy", CultureInfo.InvariantCulture);
		}


		#region Web Form Designer generated code
		override protected void OnInit(EventArgs e)
		{
			//
			// CODEGEN: This call is required by the ASP.NET Web Form Designer.
			//
			InitializeComponent();
			base.OnInit(e);
		}
		
		/// <summary>
		/// Required method for Designer support - do not modify
		/// the contents of this method with the code editor.
		/// </summary>
		private void InitializeComponent()
		{    
			this.Load += new EventHandler(this.Page_Load);

		}
		#endregion
	}
}

