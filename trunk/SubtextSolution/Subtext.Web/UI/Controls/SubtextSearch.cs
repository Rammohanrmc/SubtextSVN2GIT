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

namespace Subtext.Web.UI.Controls
{
	using System.Collections;
	using System.Configuration;
	using System.Data;
	using System.Data.SqlClient;
	using System.Web.UI.WebControls;
	using Subtext.Framework.Data;
	using Subtext.Framework.Providers;

	/// <summary>
	///		Summary description for DotTextSearch.
	/// </summary>
	public class SubtextSearch : BaseControl
	{
		protected TextBox txtSearch;
		protected Button btnSearch;

		protected Repeater SearchResults;

		private void Page_Load(object sender, EventArgs e)
		{
			txtSearch.Attributes.Add("onkeypress", "return clickButton(event,'" + btnSearch.ClientID + "')");
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
		///		Required method for Designer support - do not modify
		///		the contents of this method with the code editor.
		/// </summary>
		private void InitializeComponent()
		{
			this.Load += new EventHandler(this.Page_Load);
			this.btnSearch.Click += new EventHandler(this.btnSearch_Click);

		}

		#endregion

		public void btnSearch_Click(object sender, EventArgs e)
		{
			if(string.Empty != txtSearch.Text )
			{
				string sql = "subtext_SearchEntries";
				string conn = DbProvider.Instance().ConnectionString;

				string SearchStr = txtSearch.Text.ToString();

				ArrayList mySearchItems = new ArrayList();
				int BlogId;
				string applikasyon;

				//fix for the blogs where only one installed
				if (CurrentBlog.BlogId >= 1)
					BlogId = CurrentBlog.BlogId;
				else
					BlogId = 0;

				if (CurrentBlog.Subfolder != String.Empty)
                    applikasyon = CurrentBlog.Subfolder;
				else
					applikasyon = String.Empty;


				SqlParameter[] p =
				{
					SqlHelper.MakeInParam("@BlogId", SqlDbType.Int, 4, BlogId),
					SqlHelper.MakeInParam("@SearchStr", SearchStr)
				};

				DataTable dt = SqlHelper.ExecuteDataTable(conn, CommandType.StoredProcedure, sql, p);

				int count = dt.Rows.Count;

				for (int i = 0; i < count; i++)
				{
					DataRow dr = dt.Rows[i];

					string id = dr["id"].ToString();
					string title = (string) dr["Title"];
					DateTime dateAdded = (DateTime) dr["DateAdded"];

					string myURL = URLFormat(applikasyon, dateAdded, id);

					mySearchItems.Add(new PositionItems(title, myURL));
				}

				SearchResults.DataSource = mySearchItems;
				SearchResults.DataBind();
			}
		}

		public string URLFormat(string dbApplication, DateTime dbDateAdded, string dbEntryID)
		{
			string myYear = dbDateAdded.Year.ToString();
			string myMonth = dbDateAdded.Month.ToString();
			string myDay = dbDateAdded.Day.ToString();

			int Month = int.Parse(myMonth);
			int Day = int.Parse(myDay);

			if (Month < 10)
			{
				myMonth = String.Concat("0", myMonth);
			}
			if (Day < 10)
			{
				myDay = String.Concat("0", myDay);
			}

			return CurrentBlog.BlogHomeVirtualUrl + "archive" + "/" + myYear + "/" + myMonth + "/" + myDay + "/" + dbEntryID + ".aspx";
		}

		public class PositionItems
		{
			private string title;
			private string URL;

			public PositionItems(string title, string URL)
			{
				this.title = title;
				this.URL = URL;
			}

			public string Title
			{
				get { return title; }
			}

			public string url
			{
				get { return URL; }
			}
		}


	}
}
