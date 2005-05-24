using System;
using Subtext.Extensibility;
using Subtext.Framework.Components;

namespace Subtext.Framework.Data
{
	/// <summary>
	/// Provides the base interface any Data Provider must 
	/// implement.
	/// </summary>
	public interface IDTOProvider
	{
		#region Blogs
		/// <summary>
		/// Gets a pageable <see cref="BlogInfoCollection"/> of <see cref="BlogInfo"/> instances.
		/// </summary>
		/// <param name="pageIndex">Page index.</param>
		/// <param name="pageSize">Size of the page.</param>
		/// <param name="sortDescending">Sort descending.</param>
		/// <returns></returns>
		BlogInfoCollection GetPagedBlogs(int pageIndex, int pageSize, bool sortDescending);
		
		/// <summary>
		/// Gets the blog by id.
		/// </summary>
		/// <param name="blogId">Blog id.</param>
		/// <returns></returns>
		BlogInfo GetBlogById(int blogId);
		
		/// <summary>
		/// Returns <see cref="BlogInfoCollection"/> with the blogs that 
		/// have the specified host.
		/// </summary>
		/// <param name="host">Host.</param>
		/// <returns></returns>
		BlogInfoCollection GetBlogsByHost(string host);
		#endregion
		
		#region Entries

		#region Paged Posts

		PagedEntryCollection GetPagedEntries(PostType postType, int categoryID, int pageIndex, int pageSize, bool sortDescending);
		PagedEntryCollection GetPagedFeedback(int pageIndex, int pageSize, bool sortDescending);
		
		#endregion

		#region EntryDays

		EntryDay GetSingleDay(DateTime dt);
		EntryDayCollection GetRecentDayPosts(int ItemCount, bool ActiveOnly);
		EntryDayCollection GetPostsByMonth(int month, int year);
		EntryDayCollection GetPostsByCategoryID(int ItemCount, int catID);

		EntryDayCollection GetConditionalEntries(int ItemCount,PostConfig pc);

		#endregion

		#region EntryCollections

		EntryCollection GetConditionalEntries(int ItemCount, PostType pt, PostConfig pc);
		EntryCollection GetConditionalEntries(int ItemCount, PostType pt, PostConfig pc, DateTime DateUpdated);

		EntryCollection GetFeedBack(int ParrentID);
		EntryCollection GetFeedBack(Entry ParentEntry);
		EntryCollection GetRecentPostsWithCategories(int ItemCount, bool ActiveOnly);
		EntryCollection GetRecentPosts(int ItemCount, PostType postType, bool ActiveOnly);
		EntryCollection GetRecentPosts(int ItemCount, PostType postType, bool ActiveOnly, DateTime DateUpdated);
		EntryCollection GetPostCollectionByMonth(int month, int year);
		EntryCollection GetPostsByDayRange(DateTime start, DateTime stop, PostType postType, bool ActiveOnly);
		EntryCollection GetEntriesByCategory(int ItemCount,int catID,bool ActiveOnly);
		EntryCollection GetEntriesByCategory(int ItemCount,int catID, DateTime DateUpdated,bool ActiveOnly);

		EntryCollection GetEntriesByCategory(int ItemCount,string categoryName ,bool ActiveOnly);
		EntryCollection GetEntriesByCategory(int ItemCount,string categoryName, DateTime DateUpdated,bool ActiveOnly);

		#endregion

		#region Single Entry

		Entry GetEntry(int postID, bool ActiveOnly);
		Entry GetEntry(string EntryName, bool ActiveOnly);
		CategoryEntry GetCategoryEntry(int postid, bool ActiveOnly);
		CategoryEntry GetCategoryEntry(string EntryName, bool ActiveOnly);

		#endregion

		#region Delete
	
		bool Delete(int PostID);

		#endregion

		#region Create

		int Create(Entry entry);
		int Create(Entry entry, int[] CategoryIDs);

		#endregion

		#region Update

		bool Update(Entry entry);
		bool Update(Entry entry, int[] CategoryIDs);

		#endregion

		#region Entry Category List

		bool SetEntryCategoryList(int EntryID, int[] Categories);

		#endregion

		#endregion

		#region Links/Categories

		#region Paged Links

		PagedLinkCollection GetPagedLinks(int categoryTypeID, int pageIndex, int pageSize, bool sortDescending);

		#endregion

		#region LinkCollection

		LinkCollection GetLinkCollectionByPostID(int PostID);
		LinkCollection GetLinksByCategoryID(int catID, bool ActiveOnly);

		#endregion

		#region Single Link

		Link GetSingleLink(int linkID);
		
		#endregion

		#region LinkCategoryCollection

		LinkCategoryCollection GetCategories(CategoryType catType, bool ActiveOnly);
		LinkCategoryCollection GetActiveCategories();

		#endregion

		#region LinkCategory

		LinkCategory GetLinkCategory(int CategoryID, bool IsActive);
		LinkCategory GetLinkCategory(string categoryName, bool IsActive);

		#endregion

		#region Edit Links/Categories

		bool UpdateLink(Link link);
		int CreateLink(Link link);
		bool UpdateLinkCategory(LinkCategory lc);
		int CreateLinkCategory(LinkCategory lc);
		bool DeleteLinkCategory(int CategoryID);
		bool DeleteLink(int LinkID);

		#endregion

		#endregion

		#region Stats

		PagedViewStatCollection GetPagedViewStats(int pageIndex, int pageSize, DateTime beginDate, DateTime endDate);
		PagedReferrerCollection GetPagedReferrers(int pageIndex, int pageSize);
		PagedReferrerCollection GetPagedReferrers(int pageIndex, int pageSize, int EntryID);

		bool TrackEntry(EntryView ev);
		bool TrackEntry(EntryViewCollection evc);

		#endregion

		#region  Configuration

		/// <summary>
		/// Adds the initial blog configuration.  This is a convenience method for 
		/// allowing a user with a freshly installed blog to immediately gain access 
		/// to the admin section to edit the blog.
		/// </summary>
		/// <param name="title"></param>
		/// <param name="userName">Name of the user.</param>
		/// <param name="password">Password.</param>
		/// <param name="host"></param>
		/// <param name="application"></param>
		/// <returns></returns>
		bool CreateBlog(string title, string userName, string password, string host, string application);

		/// <summary>
		/// Updates the specified blog configuration.
		/// </summary>
		/// <param name="info">Config.</param>
		/// <returns></returns>
		bool UpdateBlog(BlogInfo info);
		
		/// <summary>
		/// Returns a <see cref="BlogInfo"/> instance containing 
		/// the configuration settings for the blog specified by the 
		/// Hostname and Application.
		/// </summary>
		/// <param name="hostname">Hostname.</param>
		/// <param name="application">Application.</param>
		/// <returns></returns>
		BlogInfo GetBlogInfo(string hostname, string application);

		/// <summary>
		/// Returns a <see cref="BlogInfo"/> instance containing 
		/// the configuration settings for the blog specified by the 
		/// Hostname and Application.
		/// </summary>
		/// <remarks>
		/// Until Subtext supports multiple blogs again (if ever), 
		/// this will always return the same instance.
		/// </remarks>
		/// <param name="hostname">Hostname.</param>
		/// <param name="application">Application.</param>
		/// <param name="strict">If false, then this will return a blog record if 
		/// there is only one blog record, regardless if the application and hostname match.</param>
		/// <returns></returns>
		BlogInfo GetBlogInfo(string hostname, string application, bool strict);
		
		/// <summary>
		/// Gets the config. This has been depracated
		/// </summary>
		/// <param name="BlogID">Blog ID.</param>
		/// <returns></returns>
		BlogInfo GetBlogInfo(int BlogID);


		#endregion

		#region KeyWords

		KeyWord GetKeyWord(int KeyWordID);
		KeyWordCollection GetKeyWords();
		PagedKeyWordCollection GetPagedKeyWords(int pageIndex, int pageSize,bool sortDescending);
		bool UpdateKeyWord(KeyWord kw);
		int InsertKeyWord(KeyWord kw);
		bool DeleteKeyWord(int KeyWordID);

		#endregion

		#region Images

		ImageCollection GetImagesByCategoryID(int catID, bool ActiveOnly);
		Image GetSingleImage(int imageID, bool ActiveOnly);
		int InsertImage(Subtext.Framework.Components.Image _image);
		bool UpdateImage(Subtext.Framework.Components.Image _image);
		bool DeleteImage(int ImageID);

		#endregion

		#region Archives
		ArchiveCountCollection GetPostsByYearArchive();
		ArchiveCountCollection GetPostsByMonthArchive();
		#endregion
	}
}
