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
using System.Collections;
using System.Globalization;
using CookComputing.XmlRpc;
using Subtext.Extensibility;
using Subtext.Framework.Components;
using Subtext.Framework.Configuration;
using Subtext.Framework.Util;

//Need to find a method that has access to context, so we can terminate the request if AllowServiceAccess == false.
//Users will be able to access the metablogapi page, but will not be able to make a request, but the page should not be visible

namespace Subtext.Framework.XmlRpc
{
	/// <summary>
	/// Summary description for MetaWeblog.
	/// </summary>
	public class MetaWeblog : XmlRpcService, Subtext.Framework.XmlRpc.IMetaWeblog
	{
		private void ValidateUser(string username, string password, bool allowServiceAccess)
		{
			if(!Config.Settings.AllowServiceAccess || !allowServiceAccess)
				throw new XmlRpcFaultException(0, "Web Service Access is not enabled.");

			bool isValid = Security.IsValidUser(username, password);
			if(!isValid)
				throw new XmlRpcFaultException(0, "Username and password denied.");
		}

		#region BlogApi Members
		public BlogInfo[] getUsersBlogs(string appKey, string username, string password)
		{
			Framework.BlogInfo info = Config.CurrentBlog;
			ValidateUser(username, password, info.AllowServiceAccess);
			
			BlogInfo[] bi = new BlogInfo[1];
			BlogInfo b = new BlogInfo();
			b.blogid = info.BlogID.ToString(CultureInfo.InvariantCulture);
			b.blogName = info.Title;
			b.url = info.BlogHomeUrl;
			bi[0] = b;
			return bi;

		}

		public bool deletePost(string appKey,string postid,string username,string password,[XmlRpcParameter(Description="Where applicable, this specifies whether the blog should be republished after the post has been deleted.")] bool publish)
		{
			ValidateUser(username,password,Config.CurrentBlog.AllowServiceAccess);
			
			try
			{
				Entries.Delete(Int32.Parse(postid));
				return true;
			}
			catch
			{
				throw new XmlRpcFaultException(1, "Could not delete post: " + postid);
			}			
		}

		#endregion

		public bool editPost(string postid,	string username,string password,Post post,bool publish)
		{
			Framework.BlogInfo info = Config.CurrentBlog;
			ValidateUser(username,password,info.AllowServiceAccess);
			
			CategoryEntry entry = Entries.GetCategoryEntry(Int32.Parse(postid), EntryGetOption.All);
			if(entry != null)
			{
				entry.Author = info.Author;
				entry.Email = info.Email;
				entry.Body = post.description;
				entry.Title = post.title;
				entry.TitleUrl = post.link;
				entry.SourceName = string.Empty;
				entry.SourceUrl = string.Empty;
				entry.Description = string.Empty;

				entry.Categories = post.categories;
				entry.PostType = PostType.BlogPost;
				entry.IsXHMTL = false;
				entry.IsActive = publish;
		
				entry.DateUpdated = BlogTime.CurrentBloggerTime;
				return Entries.Update(entry);
			}
			return false;
		}

		public Post getPost(string postid,string username,string password)
		{
			Framework.BlogInfo info = Config.CurrentBlog;
			ValidateUser(username,password,info.AllowServiceAccess);
			
			CategoryEntry entry = Entries.GetCategoryEntry(Int32.Parse(postid), EntryGetOption.All);
			Post post = new Post();
			post.link = entry.TitleUrl;
			post.description = entry.Body;
			post.dateCreated = entry.DateCreated;
			post.postid = entry.EntryID;
			post.title = entry.Title;
			post.permalink = entry.Link;
			post.categories = entry.Categories;

			return post;
		}

		public Post[] getRecentPosts(string blogid, string username, string password, int numberOfPosts)
		{
			ValidateUser(username, password, Config.CurrentBlog.AllowServiceAccess);
			
			EntryCollection ec = Entries.GetRecentPostsWithCategories(numberOfPosts,false);
			//int i = 0;
			int count = ec.Count;
			Post[] posts = new Post[count];
			for(int i=0;i<count;i++)
			{
				CategoryEntry entry = (CategoryEntry)ec[i];
				Post post = new Post();
				post.dateCreated = entry.DateCreated;
				post.description = entry.Body;
				post.link = entry.TitleUrl;
				post.permalink = entry.Link;
				post.title = entry.Title;
				post.postid = entry.EntryID.ToString(CultureInfo.InvariantCulture);
				post.userid = entry.Body.GetHashCode().ToString(CultureInfo.InvariantCulture);
				if(entry.Categories != null && entry.Categories.Length > 0)
				{
					post.categories = entry.Categories;
				}
				posts[i] = post;
			}
			return posts;
		}

		public CategoryInfo[] getCategories(string blogid,string username,string password)
		{
			Framework.BlogInfo info = Config.CurrentBlog;
			ValidateUser(username,password,info.AllowServiceAccess);
			
			LinkCategoryCollection lcc = Links.GetCategories(CategoryType.PostCollection,false);
			if(lcc == null)
			{
				throw new XmlRpcFaultException(0,"No categories exist");
			}
			CategoryInfo[] categories = new CategoryInfo[lcc.Count];
			CategoryInfo _category;
			for(int i=0; i<lcc.Count; i++)
			{
				_category = new CategoryInfo();
				_category.categoryid = lcc[i].CategoryID.ToString(CultureInfo.InvariantCulture);
				_category.title = lcc[i].Title;
				_category.htmlUrl = info.RootUrl + "Category/" + lcc[i].CategoryID.ToString(CultureInfo.InvariantCulture) + ".aspx";
				_category.rssUrl = info.RootUrl + "rss.aspx?catid=" + lcc[i].CategoryID.ToString(CultureInfo.InvariantCulture);
				_category.description = lcc[i].Title;
				
				categories[i] = _category;
			}
			return categories;
		}

		public string newPost(string blogid, string username, string password, Post post, bool publish)
		{
			Framework.BlogInfo info = Config.CurrentBlog;
			ValidateUser(username,password,info.AllowServiceAccess);
			
			CategoryEntry entry = new CategoryEntry();
			entry.Author = info.Author;
			entry.Email = info.Email;
			entry.Body = post.description;
			entry.Title = post.title;
			entry.TitleUrl = post.link;
			entry.SourceName = string.Empty;
			entry.SourceUrl = string.Empty;
			entry.Description = string.Empty;
			if(post.dateCreated.Year >= 2003)
			{
				entry.DateCreated = post.dateCreated;
				entry.DateUpdated = post.dateCreated;
			}
			else
			{
				entry.DateCreated = BlogTime.CurrentBloggerTime;
				entry.DateUpdated = entry.DateCreated;
			}
			entry.Categories = post.categories;
			entry.PostType = PostType.BlogPost;
			
			entry.IsActive = publish;
			entry.AllowComments = true;
			entry.DisplayOnHomePage = true;
			entry.IncludeInMainSyndication = true;
			entry.IsAggregated = true;
			entry.SyndicateDescriptionOnly = false;

			int postID = NullValue.NullInt32;
			try
			{
				postID = Entries.Create(entry);
			}
			catch(Exception e)
			{
				throw new XmlRpcFaultException(0, e.Message + " " + e.StackTrace);
			}
			if(postID < 0)
			{
				throw new XmlRpcFaultException(0,"The post could not be added");
			}
			return postID.ToString(CultureInfo.InvariantCulture);
		}

		#region w.bloggar workarounds/nominal MT support - HACKS
		
		// w.bloggar is not correctly implementing metaWeblogAPI on its getRecentPost call, it wants 
		// an instance of blogger.getRecentPosts at various time. 
		// 
		// What works better with w.bloggar is to tell it to use MT settings. For w.bloggar users 
		// with metaWeblog configured, we'll throw a more explanatory exception than method not found.

		public struct BloggerPost
		{
			public string content;
			public DateTime dateCreated;
			public string postid;
			public string userid;
		} 

		[XmlRpcMethod("blogger.getRecentPosts",
			 Description="Workaround for w.bloggar errors. Exists just to throw an exception explaining issue.")]
		public BloggerPost[] GetRecentPosts(string appKey, string blogid, string username, 
			string password, int numberOfPosts)
		{
			throw new XmlRpcFaultException(0, "You are most likely getting this message because you are using w.bloggar or trying to access Blogger API support in .Text--only metaWeblog API is currently supported. If your issue is w.bloggar, read on.\n\nw.bloggar does not correctly implement the metaWeblog API.\n\nIt is trying to call blogger.getRecentPosts, which does not exist in the metaWeblog API. Contact w.bloggar and encourage them to fix this bug.\n\nIn the meantime, to workaround this, go to the Account Properties dialog and hit 'Reload Blogs List'. This should clear the issue temporarily on w.bloggars side.");
		}		

		// we'll also add a couple structs and methods to give us nominal MT API-level support.
		// by doing this we'll allow w.bloggar to run against .Text using w.b's MT configuration.
		public struct MtCategory
		{
			public string categoryId;
			[XmlRpcMissingMapping(MappingAction.Ignore)]
			public string categoryName;
			[XmlRpcMissingMapping(MappingAction.Ignore)]
			public bool isPrimary;

			/// <summary>
			/// Initializes a new instance of the <see cref="MtCategory"/> class.
			/// </summary>
			/// <param name="category">The category.</param>
			public MtCategory(string category)
			{
				categoryId = category;
				categoryName = category;
				isPrimary = false;
			}

			/// <summary>
			/// Initializes a new instance of the <see cref="MtCategory"/> class.
			/// </summary>
			/// <param name="id">The id.</param>
			/// <param name="category">The category.</param>
			public MtCategory(string id, string category)
			{
				categoryId = id;
				categoryName = category;
				isPrimary = false;
			}
		}

		/// <summary>
		/// Represents a text filter returned by mt.supportedTextFilters.
		/// </summary>
		[XmlRpcMissingMapping(MappingAction.Ignore)]
		public struct MtTextFilter
		{
			/// <summary>
			/// Initializes a new instance of the <see cref="MtTextFilter"/> class.
			/// </summary>
			/// <param name="key">The key.</param>
			/// <param name="label">The label.</param>
			public MtTextFilter(string key, string label)
			{
				this.key = key; 
				this.label = label;
			}
			public string key;
			public string label;
		}

		[XmlRpcMethod("mt.getCategoryList", 
			 Description="Gets a list of active categories for a given blog as an array of MT category struct.")]
		public MtCategory[] GetCategoryList(string blogid, string username, string password)
		{
			ValidateUser(username,password,Config.CurrentBlog.AllowServiceAccess);
			
			LinkCategoryCollection lcc = Links.GetCategories(CategoryType.PostCollection,false);
			if(lcc == null)
			{
				throw new XmlRpcFaultException(0, "No categories exist");
			}

			MtCategory[] categories = new MtCategory[lcc.Count];
			MtCategory _category;
			for(int i=0; i<lcc.Count; i++)
			{
				_category = new MtCategory(lcc[i].CategoryID.ToString(CultureInfo.InvariantCulture), lcc[i].Title);				
				categories[i] = _category;
			}
			return categories;
		}

		[XmlRpcMethod("mt.setPostCategories",
			Description="Sets the categories for a given post.")]
		public bool SetPostCategories(string postid, string username, string password,
			MtCategory[] categories)
		{
			ValidateUser(username,password,Config.CurrentBlog.AllowServiceAccess);
						
			if (categories != null && categories.Length > 0)
			{
				int postID = Int32.Parse(postid);

				ArrayList al = new ArrayList();

														
				for (int i = 0; i < categories.Length; i++)
				{
						al.Add(Int32.Parse(categories[i].categoryId));
				}

				if(al.Count > 0)
				{
					Entries.SetEntryCategoryList(postID,(int[])al.ToArray(typeof(int)));
				}
			}				
			
			return true;
		}		

		[XmlRpcMethod("mt.getPostCategories",
			 Description="Sets the categories for a given post.")]
		public MtCategory[] GetPostCategories(string postid, string username, string password)
		{
			ValidateUser(username, password, Config.CurrentBlog.AllowServiceAccess);

			int postID = Int32.Parse(postid);
			LinkCollection postCategories = Links.GetLinkCollectionByPostID(postID);
			MtCategory[] categories = new MtCategory[postCategories.Count];
			if (postCategories.Count > 0)
			{
				// REFACTOR: Might prefer seeing a dictionary come back straight from the provider.
				// for now we'll build our own catid->catTitle lookup--we need it below bc collection
				// from post is going to be null for title.
				LinkCategoryCollection cats = Links.GetCategories(CategoryType.PostCollection, false);
				Hashtable catLookup = new Hashtable(cats.Count);
				foreach (LinkCategory currentCat in cats)
					catLookup.Add(currentCat.CategoryID, currentCat.Title);

				MtCategory _category;
				for (int i = 0; i < postCategories.Count; i++)
				{						
					_category = new MtCategory(postCategories[i].CategoryID.ToString(CultureInfo.InvariantCulture), 
						(string)catLookup[postCategories[i].CategoryID]);				

					categories[i] = _category;
				}
			}				
			
			return categories;
		}

		/// <summary>
		/// Retrieve information about the text formatting plugins supported by the server.
		/// </summary>
		/// <returns>
		/// an array of structs containing String key and String label. 
		/// key is the unique string identifying a text formatting plugin, 
		/// and label is the readable description to be displayed to a user. 
		/// key is the value that should be passed in the mt_convert_breaks 
		/// parameter to newPost and editPost.
		/// </returns>
		[XmlRpcMethod("mt.supportedTextFilters",
			 Description="Retrieve information about the text formatting plugins supported by the server.")]
		public MtTextFilter[] GetSupportedTextFilters()
		{
			return new MtTextFilter[] {new MtTextFilter("test", "test"), };
		}
		#endregion

	}
}

