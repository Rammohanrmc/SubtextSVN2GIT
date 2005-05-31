using System;
using Subtext.Extensibility;
using Subtext.Extensibility.Providers;
using Subtext.Framework.Components;

namespace Subtext.Framework.Providers
{
	/// <summary>
	/// Provides a Data Object Source for interacting with Subtext Data.  One example 
	/// is a DataDTOProvider, which stores Subtext data in a database (which itself is 
	/// provided via the <see cref="DbProvider"/> class).
	/// </summary>
	public abstract class DTOProvider : ProviderBase
	{	
		/// <summary>
		/// Returns the configured concrete instance of a <see cref="DTOProvider"/>.
		/// </summary>
		/// <returns></returns>
		public static DTOProvider Instance()
		{
			return (DTOProvider)ProviderBase.Instance("DTO");
		}

		#region DTO Specific methods
		#region Blogs
		/// <summary>
		/// Gets a pageable <see cref="BlogInfoCollection"/> of <see cref="BlogInfo"/> instances.
		/// </summary>
		/// <param name="pageIndex">Page index.</param>
		/// <param name="pageSize">Size of the page.</param>
		/// <param name="sortDescending">Sort descending.</param>
		/// <returns></returns>
		public abstract BlogInfoCollection GetPagedBlogs(int pageIndex, int pageSize, bool sortDescending);
		
		/// <summary>
		/// Gets the blog by id.
		/// </summary>
		/// <param name="blogId">Blog id.</param>
		/// <returns></returns>
		public abstract BlogInfo GetBlogById(int blogId);
		
		/// <summary>
		/// Returns <see cref="BlogInfoCollection"/> with the blogs that 
		/// have the specified host.
		/// </summary>
		/// <param name="host">Host.</param>
		/// <returns></returns>
		public abstract BlogInfoCollection GetBlogsByHost(string host);
		#endregion
		
		#region Entries

		#region Paged Posts

		public abstract PagedEntryCollection GetPagedEntries(PostType postType, int categoryID, int pageIndex, int pageSize, bool sortDescending);
		public abstract PagedEntryCollection GetPagedFeedback(int pageIndex, int pageSize, bool sortDescending);
		
		#endregion

		#region EntryDays

		public abstract EntryDay GetSingleDay(DateTime dt);
		public abstract EntryDayCollection GetRecentDayPosts(int ItemCount, bool ActiveOnly);
		public abstract EntryDayCollection GetPostsByMonth(int month, int year);
		public abstract EntryDayCollection GetPostsByCategoryID(int ItemCount, int catID);

		public abstract EntryDayCollection GetConditionalEntries(int ItemCount,PostConfig pc);

		#endregion

		#region EntryCollections

		public abstract EntryCollection GetConditionalEntries(int ItemCount, PostType pt, PostConfig pc);
		public abstract EntryCollection GetConditionalEntries(int ItemCount, PostType pt, PostConfig pc, DateTime DateUpdated);

		public abstract EntryCollection GetFeedBack(int ParrentID);
		public abstract EntryCollection GetFeedBack(Entry ParentEntry);
		public abstract EntryCollection GetRecentPostsWithCategories(int ItemCount, bool ActiveOnly);
		public abstract EntryCollection GetRecentPosts(int ItemCount, PostType postType, bool ActiveOnly);
		public abstract EntryCollection GetRecentPosts(int ItemCount, PostType postType, bool ActiveOnly, DateTime DateUpdated);
		public abstract EntryCollection GetPostCollectionByMonth(int month, int year);
		public abstract EntryCollection GetPostsByDayRange(DateTime start, DateTime stop, PostType postType, bool ActiveOnly);
		public abstract EntryCollection GetEntriesByCategory(int ItemCount,int catID,bool ActiveOnly);
		public abstract EntryCollection GetEntriesByCategory(int ItemCount,int catID, DateTime DateUpdated,bool ActiveOnly);

		public abstract EntryCollection GetEntriesByCategory(int ItemCount,string categoryName ,bool ActiveOnly);
		public abstract EntryCollection GetEntriesByCategory(int ItemCount,string categoryName, DateTime DateUpdated,bool ActiveOnly);

		#endregion

		#region Single Entry

		/// <summary>
		/// Searches the data store for the first comment with a 
		/// matching checksum hash.
		/// </summary>
		/// <param name="checksumHash">Checksum hash.</param>
		/// <returns></returns>
		public abstract Entry GetCommentByChecksumHash(string checksumHash);
		public abstract Entry GetEntry(int postID, bool ActiveOnly);
		public abstract Entry GetEntry(string EntryName, bool ActiveOnly);
		public abstract CategoryEntry GetCategoryEntry(int postid, bool ActiveOnly);
		public abstract CategoryEntry GetCategoryEntry(string EntryName, bool ActiveOnly);

		#endregion

		#region Delete
	
		public abstract bool Delete(int PostID);

		#endregion

		#region Create

		public abstract int Create(Entry entry);
		public abstract int Create(Entry entry, int[] CategoryIDs);

		#endregion

		#region Update

		public abstract bool Update(Entry entry);
		public abstract bool Update(Entry entry, int[] CategoryIDs);

		#endregion

		#region Entry Category List

		public abstract bool SetEntryCategoryList(int EntryID, int[] Categories);

		#endregion

		#endregion

		#region Links/Categories

		#region Paged Links

		public abstract PagedLinkCollection GetPagedLinks(int categoryTypeID, int pageIndex, int pageSize, bool sortDescending);

		#endregion

		#region LinkCollection

		public abstract LinkCollection GetLinkCollectionByPostID(int PostID);
		public abstract LinkCollection GetLinksByCategoryID(int catID, bool ActiveOnly);

		#endregion

		#region Single Link

		public abstract Link GetSingleLink(int linkID);
		
		#endregion

		#region LinkCategoryCollection

		public abstract LinkCategoryCollection GetCategories(CategoryType catType, bool ActiveOnly);
		public abstract LinkCategoryCollection GetActiveCategories();

		#endregion

		#region LinkCategory

		public abstract LinkCategory GetLinkCategory(int CategoryID, bool IsActive);
		public abstract LinkCategory GetLinkCategory(string categoryName, bool IsActive);

		#endregion

		#region Edit Links/Categories

		public abstract bool UpdateLink(Link link);
		public abstract int CreateLink(Link link);
		public abstract bool UpdateLinkCategory(LinkCategory lc);
		public abstract int CreateLinkCategory(LinkCategory lc);
		public abstract bool DeleteLinkCategory(int CategoryID);
		public abstract bool DeleteLink(int LinkID);

		#endregion

		#endregion

		#region Stats

		public abstract PagedViewStatCollection GetPagedViewStats(int pageIndex, int pageSize, DateTime beginDate, DateTime endDate);
		public abstract PagedReferrerCollection GetPagedReferrers(int pageIndex, int pageSize);
		public abstract PagedReferrerCollection GetPagedReferrers(int pageIndex, int pageSize, int EntryID);

		public abstract bool TrackEntry(EntryView ev);
		public abstract bool TrackEntry(EntryViewCollection evc);

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
		public abstract bool CreateBlog(string title, string userName, string password, string host, string application);

		/// <summary>
		/// Updates the specified blog configuration.
		/// </summary>
		/// <param name="info">Config.</param>
		/// <returns></returns>
		public abstract bool UpdateBlog(BlogInfo info);
		
		/// <summary>
		/// Returns a <see cref="BlogInfo"/> instance containing 
		/// the configuration settings for the blog specified by the 
		/// Hostname and Application.
		/// </summary>
		/// <param name="hostname">Hostname.</param>
		/// <param name="application">Application.</param>
		/// <returns></returns>
		public abstract BlogInfo GetBlogInfo(string hostname, string application);

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
		public abstract BlogInfo GetBlogInfo(string hostname, string application, bool strict);
		
		/// <summary>
		/// Gets the config. This has been depracated
		/// </summary>
		/// <param name="BlogID">Blog ID.</param>
		/// <returns></returns>
		public abstract BlogInfo GetBlogInfo(int BlogID);


		#endregion

		#region KeyWords

		public abstract KeyWord GetKeyWord(int KeyWordID);
		public abstract KeyWordCollection GetKeyWords();
		public abstract PagedKeyWordCollection GetPagedKeyWords(int pageIndex, int pageSize,bool sortDescending);
		public abstract bool UpdateKeyWord(KeyWord kw);
		public abstract int InsertKeyWord(KeyWord kw);
		public abstract bool DeleteKeyWord(int KeyWordID);

		#endregion

		#region Images

		public abstract ImageCollection GetImagesByCategoryID(int catID, bool ActiveOnly);
		public abstract Image GetSingleImage(int imageID, bool ActiveOnly);
		public abstract int InsertImage(Subtext.Framework.Components.Image _image);
		public abstract bool UpdateImage(Subtext.Framework.Components.Image _image);
		public abstract bool DeleteImage(int ImageID);

		#endregion

		#region Archives
		public abstract ArchiveCountCollection GetPostsByYearArchive();
		public abstract ArchiveCountCollection GetPostsByMonthArchive();
		#endregion
		#endregion
	}
}