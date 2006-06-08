using System;
using Subtext.Framework.Components;
using Subtext.Web.UI;

namespace Subtext.Web.UI.Controls
{
	/// <summary>
	///		Summary description for ArticleCategories.
	/// </summary>
	public class ArticleCategories : Subtext.Web.UI.Controls.BaseControl
	{
		protected Subtext.Web.UI.Controls.CategoryList Categories;

		private void Page_Load(object sender, System.EventArgs e)
		{
		}

		protected override void OnLoad(EventArgs e)
		{
			base.OnLoad (e);
			Categories.LinkCategories = GetArchiveCategories();
		}

		protected LinkCategoryCollection GetArchiveCategories()
		{
			LinkCategoryCollection lcc = new LinkCategoryCollection();

			lcc.Add(UIData.Links(CategoryType.StoryCollection,CurrentBlog.UrlFormats));			

			return lcc;
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
			this.Load += new System.EventHandler(this.Page_Load);

		}
		#endregion
	}
}
