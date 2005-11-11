#region Disclaimer/Info
///////////////////////////////////////////////////////////////////////////////////////////////////
// .Text WebLog
// 
// .Text is an open source weblog system started by Scott Watermasysk. 
// Blog: http://ScottWater.com/blog 
// RSS: http://scottwater.com/blog/rss.aspx
// Email: Dottext@ScottWater.com
//
// For updated news and information please visit http://scottwater.com/dottext and subscribe to 
// the Rss feed @ http://scottwater.com/dottext/rss.aspx
//
// On its release (on or about August 1, 2003) this application is licensed under the BSD. However, I reserve the 
// right to change or modify this at any time. The most recent and up to date license can always be fount at:
// http://ScottWater.com/License.txt
// 
// Please direct all code related questions to:
// GotDotNet Workspace: http://www.gotdotnet.com/Community/Workspaces/workspace.aspx?id=e99fccb3-1a8c-42b5-90ee-348f6b77c407
// Yahoo Group http://groups.yahoo.com/group/DotText/
// 
///////////////////////////////////////////////////////////////////////////////////////////////////
#endregion

using System;
using System.IO;
using System.Web;
using System.Web.UI.WebControls;
using System.Xml;
using Subtext.Framework.Configuration;
using Subtext.Framework.Import;
using Subtext.Web.Admin.WebUI;

namespace Subtext.Web.Admin.Pages
{
	public class ImportExportPage : AdminPage
	{
		protected CheckBox chkDisplayOnScreen;
		protected Page PageContainer;
		protected HyperLink hypBlogMLFile;
		protected CheckBox chkEmbedAttach;
		protected Button btnSave;
		protected AdvancedPanel Action;
		protected MessagePanel Messages;

		private string _dirPath = HttpContext.Current.Server.MapPath("~/Admin/BlogML") ;
		private string _filePath = HttpContext.Current.Server.MapPath("~/Admin/BlogML/Data.xml") ;
	
		private void Page_Load(object sender, EventArgs e)
		{
		}
		
		protected override void OnPreRender(EventArgs e) 
		{
			base.OnPreRender (e);

			//	TODO: need to figure out a cleaver way to dynamically & randomly generate the file  
			//	name for output and then remove them after they've been clicked or after they expire.
			hypBlogMLFile.NavigateUrl = "~/Admin/BlogML/Data.xml";
			hypBlogMLFile.Visible = File.Exists(_filePath);
		}

		private void WriteBlogML()
		{
			string connStr = Config.Settings.ConnectionString;
			SubtextBlogMLWriter blogWriter = new SubtextBlogMLWriter(connStr, Config.CurrentBlog.BlogID, false);
			blogWriter.EmbedAttachments = this.chkEmbedAttach.Checked;

			hypBlogMLFile.Visible = false;

			if(!Directory.Exists(_dirPath))
			{
				Directory.CreateDirectory(_dirPath);
			}
			if(File.Exists(_filePath))
			{
				File.Delete(_filePath);
			}

			using(StreamWriter strWriter = File.CreateText(_filePath))
			{
				XmlTextWriter xWriter = null;
				try
				{
					xWriter = new XmlTextWriter(strWriter);
					xWriter.Formatting = Formatting.Indented;
					blogWriter.Write(xWriter);
				}
				finally
				{
					xWriter.Close();
				}
			}
		}

		private void btnSave_Click(object sender, EventArgs e)
		{
			WriteBlogML();
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
			this.btnSave.Click += new EventHandler(this.btnSave_Click);
			this.Load += new EventHandler(this.Page_Load);

		}
		#endregion
	}
}

