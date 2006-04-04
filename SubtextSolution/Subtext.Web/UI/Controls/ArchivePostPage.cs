using System;
using System.Web.UI.WebControls;

using Subtext.Framework;
using Subtext.Framework.Components;
using Subtext.Web.UI;

namespace Subtext.Web.UI.Controls
{
	/// <summary>
	///		Summary description for ArchivePostPage.
	/// </summary>
	public class ArchivePostPage : Subtext.Web.UI.Controls.BaseControl
	{
		protected System.Web.UI.WebControls.Repeater DateItemList;
		protected System.Web.UI.WebControls.Repeater CatList;

		private void Page_Load(object sender, System.EventArgs e)
		{
		}
		
		protected override void OnLoad(EventArgs e)
		{
			base.OnLoad (e);
			LinkCategoryCollection lcc = new LinkCategoryCollection();
			lcc.AddRange(Links.GetCategories(CategoryType.PostCollection, true));
			lcc.Add(UIData.Links(CategoryType.PostCollection, CurrentBlog.UrlFormats));
			CatList.DataSource = lcc;
			CatList.DataBind();

			LinkCategory monthCat = UIData.ArchiveMonth(CurrentBlog.UrlFormats);
			DateItemList.DataSource = monthCat.Links;
			DateItemList.DataBind();
		}

		protected void CategoryCreated(object sender,  RepeaterItemEventArgs e)
		{
			if(e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
			{
				LinkCategory linkcat = (LinkCategory)e.Item.DataItem;				
				if(linkcat != null)
				{
					if (linkcat.CategoryID != 0)
					{
						Label description = (Label) e.Item.FindControl("Description");
						if (description != null)
						{
							description.Text = linkcat.Description;
						}

						HyperLink catlink = (HyperLink) e.Item.FindControl("CatLink");
						if (catlink != null)
						{
							catlink.NavigateUrl = CurrentBlog.VirtualUrl + "/category/" + linkcat.CategoryID.ToString() + ".aspx";
							catlink.Text = linkcat.Title;
						}
					}
				}
			}
		}

		protected void DateItemCreated(object sender,  RepeaterItemEventArgs e)
		{
			if(e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
			{
				Link link = (Link)e.Item.DataItem;				
				if(link != null)
				{
					HyperLink datelink = (HyperLink) e.Item.FindControl("DateLink");
					if (datelink != null)
					{
						datelink.NavigateUrl = link.Url;
						datelink.Text = link.Title;
					}
				}
			}
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
