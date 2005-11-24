using System.Collections;
using System.Drawing;
using System.Drawing.Imaging;
using System.IO;
using System.Web;
using BlogML;
using BlogML.Xml;
using Subtext.Framework.Components;
using Subtext.Framework.Configuration;
using Subtext.Framework.Text;
using Image = System.Drawing.Image;

namespace Subtext.Framework.Import
{
	/// <summary>
	/// Summary description for SubtextBlogMLReader.
	/// </summary>
	public sealed class SubtextBlogMLReader
	{
		public SubtextBlogMLReader()
		{
			//
			// TODO: Add constructor logic here
			//
		}

		/// <summary>
		/// Reads a BlogML file and imports the data into a subText blog. This method 
		/// can import the data into an existing subText blog, or create a new one.
		/// </summary>
		/// <param name="blogMLFile">the BlogML file to import</param>
		/// <param name="createNewBlog">if TRUE, a new blog will be created, FALSE indicates 
		/// this method is being called from an existing blog.</param>
		public void ReadBlog(string blogMLFile, bool createNewBlog)
		{
			BlogMLBlog bmlBlog = BlogMLSerializer.Deserialize(new StringReader(blogMLFile));
			Hashtable categoryMap = new Hashtable(); // will be used to map the blogML catID to real catID
			BlogInfo info = null;
			//int categoryID;

			/*	TODO - Map the data into the dataStore
			 *	1) Add a new blog (subtext_Config)
			 *	2) Add categories and setup categoryMap w/ {blogMLCatID = subtextCatID}
			 *	3) Add all content (post, story, comment, track/pingbacks, undeclared) as defined 
			 *		by PostType.cs
			 *	4) 
			 */ 
			
			// 1) This certainly needs to be beefed up to calculate the correct _host & app values
			if(createNewBlog)
			{
				Config.CreateBlog(bmlBlog.Title, bmlBlog.Author.Name, "password", bmlBlog.RootUrl, string.Empty);
				info = Config.GetBlogInfo(bmlBlog.RootUrl, string.Empty);

				info.SubTitle = StringHelper.ReturnCheckForNull(bmlBlog.SubTitle);
				info.Email = StringHelper.ReturnCheckForNull(bmlBlog.Author.Email);
				Config.UpdateConfigData(info);
			}
			else
			{
				info = Config.CurrentBlog;
			}
			
			// 2)
			foreach(BlogMLCategory bmlCat in bmlBlog.Categories)
			{
				LinkCategory category = new LinkCategory();
				category.BlogID = info.BlogID;
				category.CategoryType = CategoryType.LinkCollection;
				category.Title = bmlCat.Title;
				category.Description = bmlCat.Description;
				category.IsActive = bmlCat.Approved;

				// now add the category and map its ID
				categoryMap.Add(bmlCat.ID, Links.CreateLinkCategory(category));
			}

			string appRootUrl = "http://" + Config.CurrentBlog.Host.ToLower() 
				+ StringHelper.ReturnCheckForNull(HttpContext.Current.Request.ApplicationPath) + "/";
			// 3)
			foreach(BlogMLPost bmlPost in bmlBlog.Posts)
			{
				string postContent = bmlPost.Content.UncodedText;

				if(bmlPost.Attachments.Count > 0)
				{
					string dirPath = HttpContext.Current.Server.MapPath("~/Images");
					if(!Directory.Exists(dirPath))
					{
						Directory.CreateDirectory(dirPath);
					}

					foreach(BlogMLAttachment bmlAttachment in bmlPost.Attachments)
					{
						string fileName = Path.GetFileName(bmlAttachment.Url);
						string filePath = HttpContext.Current.Server.MapPath("~/Images/" + fileName);
						/* need to refactor Config.CurrentBlog.RootUrl to be .BlogRootUrl, and add a 
						 * .ApplicationRootUrl which would return http://host/pathToAppRoot/
						 * For now just do it ourselves.
						 */
						string httpPath = appRootUrl + "Images/" + fileName;

						postContent = BlogMLWriterBase.SgmlUtil.CleanAttachmentUrls(
										postContent, 
										bmlAttachment.Url,
										httpPath);

						if( bmlAttachment.Embedded == true ) 
						{
							MemoryStream memStream = new MemoryStream(bmlAttachment.Data);
							Bitmap image = (Bitmap)Image.FromStream(memStream);
							using( FileStream fStream = new FileStream(filePath, FileMode.CreateNew) ) 
							{
								image.Save(fStream, ImageFormat.Jpeg) ;
							}
						}
					}
				} // End Attachments for Post
                
				// TODO: write post to dataStore

				// TODO: add categories for post

				// TODO: add comments for post

				// TODO: add ping/Trackbacks for post



			} // End Posts
		}
	}
}
