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

				int BlogID = CurrentBlog.BlogID;
				string applikasyon = CurrentBlog.Application;

				SqlParameter[] p =
				{
					SqlHelper.MakeInParam("@BlogID", SqlDbType.Int, 4, BlogID),
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


		public DataSet Search(string sParam)
		{
			DataSet ds = new DataSet();

			if(string.Empty != txtSearch.Text )
			{
				string sql = "subtext_SearchEntries"; //sp to run
				string conn = DbProvider.Instance().ConnectionString; //from web.config

				string SearchStr = sParam; //passed search string

				int BlogID = CurrentBlog.BlogID; //id of current blog
				string applikasyon = CurrentBlog.Application; //application of current blog

				/*prepare sp parameters*/
				SqlParameter[] p =
				{
					SqlHelper.MakeInParam("@BlogID", SqlDbType.Int, 4, BlogID),
					SqlHelper.MakeInParam("@SearchStr", SearchStr)
				};
				
				//execute sp, get back dt
				DataTable dt = SqlHelper.ExecuteDataTable(conn, CommandType.StoredProcedure, sql, p);

				int count = dt.Rows.Count;

				/*Create a dataset to return back only Title and URL */
				DataTable dt2 = ds.Tables.Add();
				dt2.Columns.Add("Title", typeof(string));
				dt2.Columns.Add("Url", typeof(string));
				DataRow row;
				/*End of new dataset*/
				
				//go through data table and prepare dataset
				for (int i = 0; i < count; i++)
				{
					DataRow dr = dt.Rows[i];

					string id = dr["id"].ToString();
					string title = (string) dr["Title"];
					DateTime dateAdded = (DateTime) dr["DateAdded"];

					string myURL = URLFormat(applikasyon, dateAdded, id);
					
					/*Add to new dataset*/
					row = dt2.NewRow();
					row["Title"] = title;
					row["Url"] = myURL;
					dt2.Rows.Add(row);
					/*End of new DataRow*/

				}

			}
			return ds;
		}

		public string URLFormat(string dbApplication, DateTime dbDateAdded, string dbEntryID)
		{
			string myURL = ConfigurationSettings.AppSettings["AggregateURL"];

			myURL = myURL + "/" + dbApplication + "/";

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

			myURL = myURL + "archive" + "/" + myYear + "/" + myMonth + "/" + myDay + "/" + dbEntryID + ".aspx";

			return myURL;
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
