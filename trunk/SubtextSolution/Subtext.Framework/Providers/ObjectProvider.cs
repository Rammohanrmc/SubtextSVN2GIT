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
using Subtext.Extensibility;
using Subtext.Extensibility.Providers;
using Subtext.Framework.Components;

namespace Subtext.Framework.Providers
{
	/// <summary>
	/// Provides a Data Object Source for interacting with Subtext Data.  One example 
	/// is a DataObjectProvider, which stores Subtext data in a database (which itself is 
	/// provided via the <see cref="DbProvider"/> class).
	/// </summary>
	public abstract class ObjectProvider : ProviderBase
	{
		/// <summary>
		/// Returns the configured concrete instance of a <see cref="ObjectProvider"/>.
		/// </summary>
		/// <returns></returns>
		public static ObjectProvider Instance()
		{
			return (ObjectProvider)ProviderBase.Instance("ObjectProvider");
		}

		#region ObjectProvider Specific methods
		#region Host

		/// <summary>
		/// Returns the <see cref="HostInfo"/> for the Subtext installation.
		/// </summary>
		/// <returns>A <see cref="HostInfo"/> instance.</returns>
		public abstract HostInfo LoadHostInfo(HostInfo info);

		/// <summary>
		/// Updates the <see cref="HostInfo"/> instance.  If the host record is not in the 
		/// database, one is created. There should only be one host record.
		/// </summary>
		/// <param name="hostInfo">The host information.</param>
		public abstract bool UpdateHost(HostInfo hostInfo);
		
		#endregion Host

		#region Blogs
		/// <summary>
		/// Gets a pageable <see cref="IList"/> of <see cref="BlogInfo"/> instances.
		/// </summary>
		/// <param name="pageIndex">Page index.</param>
		/// <param name="pageSize">Size of the page.</param>
		/// <param name="sortDescending">Sort descending.</param>
		/// <returns></returns>
		public abstract PagedCollection<BlogInfo> GetPagedBlogs(int pageIndex, int pageSize, bool sortDescending);
		
		/// <summary>
		/// Gets the blog by id.
		/// </summary>
		/// <param name="blogId">Blog id.</param>
		/// <returns></returns>
		public abstract BlogInfo GetBlogById(int blogId);
		
		/// <summary>
		/// Returns <see cref="List"/> with the blogs that 
		/// have the specified host.
		/// </summary>
		/// <param name="host">Host.</param>
		/// <returns></returns>
        public abstract IPagedCollection<BlogInfo> GetBlogsByHost(string host);
		#endregion Blogs
		
		#region Entries

		#region Paged Posts

        public abstract IPagedCollection<Entry> GetPagedEntries(PostType postType, int categoryID, int pageIndex, int pageSize, bool sortDescending);
        public abstract IPagedCollection<Entry> GetPagedFeedback(int pageIndex, int pageSize, bool sortDescending);
		
		#endregion

		#region EntryDays

		public abstract EntryDay GetSingleDay(DateTime dt);
        public abstract ICollection<EntryDay> GetRecentDayPosts(int itemCount, bool activeOnly);
        public abstract ICollection<EntryDay> GetPostsByMonth(int month, int year);
        public abstract ICollection<EntryDay> GetPostsByCategoryID(int itemCount, int catID);

		/// <summary>
		/// Gets entries within the system that meet the 
		/// <see cref="PostConfig"/> flags.
		/// </summary>
		/// <param name="itemCount">Item count.</param>
		/// <param name="pc">Pc.</param>
		/// <returns></returns>
        public abstract ICollection<EntryDay> GetBlogPosts(int itemCount, PostConfig pc);

		#endregion

		#region EntryCollections

		/// <summary>
		/// Gets the entries that meet the <see cref="PostType"/> and 
		/// <see cref="PostConfig"/> flags.
		/// </summary>
		/// <param name="itemCount">Item count.</param>
		/// <param name="postType">The type of entry to return.</param>
		/// <param name="postConfig">Post Configuration options.</param>
		/// <returns></returns>
		public abstract IList<Entry> GetConditionalEntries(int itemCount, PostType postType, PostConfig postConfig);

		public abstract IList<Entry> GetFeedBack(Entry ParentEntry);
		public abstract ICollection<Entry> GetRecentPostsWithCategories(int itemCount, bool activeOnly);
		/// <summary>
		/// Gets recent posts used to support the MetaBlogAPI. 
		/// Could be used for a Recent Posts control as well.
		/// </summary>
		/// <param name="itemCount">Item count.</param>
		/// <param name="postType">Post type.</param>
		/// <param name="activeOnly">Active only.</param>
		/// <returns></returns>
		public abstract IList<Entry> GetRecentPosts(int itemCount, PostType postType, bool activeOnly);
		public abstract IList<Entry> GetPostCollectionByMonth(int month, int year);
		public abstract IList<Entry> GetPostsByDayRange(DateTime start, DateTime stop, PostType postType, bool activeOnly);
		public abstract IList<Entry> GetEntriesByCategory(int ItemCount,int catID,bool ActiveOnly);

		#endregion

		#region Single Entry

		/// <summary>
		/// Searches the data store for the first comment with a 
		/// matching checksum hash.
		/// </summary>
		/// <param name="checksumHash">Checksum hash.</param>
		/// <returns></returns>
		public abstract Entry GetCommentByChecksumHash(string checksumHash);
		public abstract Entry GetEntry(int postID, bool activeOnly);
		public abstract Entry GetEntry(string EntryName, bool activeOnly);
		public abstract Entry GetCategoryEntry(int postid, bool activeOnly);

		#endregion

		#region Delete
	
		public abstract bool Delete(int PostID);

		#endregion

		#region Create

		/// <summary>
		/// Creates the specified entry attaching the specified categories.
		/// </summary>
		/// <param name="entry">Entry.</param>
		/// <param name="categoryIds">Category Ids.</param>
		/// <returns></returns>
		public abstract int Create(Entry entry, int[] categoryIds);

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

        public abstract IPagedCollection<Link> GetPagedLinks(int categoryTypeID, int pageIndex, int pageSize, bool sortDescending);

		#endregion

		#region LinkCollection

        public abstract ICollection<Link> GetLinkCollectionByPostID(int PostID);
        public abstract ICollection<Link> GetLinksByCategoryID(int catID, bool activeOnly);

		#endregion

		#region Single Link

		public abstract Link GetSingleLink(int linkID);
		
		#endregion

		#region LinkCategoryCollection

        public abstract ICollection<LinkCategory> GetCategories(CategoryType catType, bool activeOnly);
        public abstract ICollection<LinkCategory> GetActiveCategories();

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

        public abstract IPagedCollection<ViewStat> GetPagedViewStats(int pageIndex, int pageSize, DateTime beginDate, DateTime endDate);
        public abstract IPagedCollection<Referrer> GetPagedReferrers(int pageIndex, int pageSize);
        public abstract IPagedCollection<Referrer> GetPagedReferrers(int pageIndex, int pageSize, int entryId);

		public abstract bool TrackEntry(EntryView ev);
		public abstract bool TrackEntry(IEnumerable<EntryView> evc);

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
		/// <param name="subfolder"></param>
		/// <returns></returns>
		public abstract bool CreateBlog(string title, string userName, string password, string host, string subfolder);

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
		/// <param name="subfolder">Subfolder Name.</param>
		/// <returns></returns>
		/// <param name="hostname">Hostname.</param>
		/// <param name="subfolder">Subfolder.</param>
		/// <returns></returns>
		public BlogInfo GetBlogInfo(string hostname, string subfolder)
		{
			return GetBlogInfo(hostname, subfolder, true);
		}

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
		/// <param name="subfolder">Subfolder Name.</param>
		/// <param name="strict">If false, then this will return a blog record if 
		/// there is only one blog record, regardless if the subfolder and hostname match.</param>
		/// <returns></returns>
		public abstract BlogInfo GetBlogInfo(string hostname, string subfolder, bool strict);
		#endregion

		#region KeyWords

		public abstract KeyWord GetKeyWord(int KeyWordID);
        public abstract ICollection<KeyWord> GetKeyWords();
        public abstract IPagedCollection<KeyWord> GetPagedKeyWords(int pageIndex, int pageSize, bool sortDescending);
		public abstract bool UpdateKeyWord(KeyWord kw);
		public abstract int InsertKeyWord(KeyWord kw);
		public abstract bool DeleteKeyWord(int KeyWordID);

		#endregion

		#region Images

        public abstract ImageCollection GetImagesByCategoryID(int catID, bool activeOnly);
		public abstract Image GetSingleImage(int imageID, bool activeOnly);
		public abstract int InsertImage(Subtext.Framework.Components.Image _image);
		public abstract bool UpdateImage(Subtext.Framework.Components.Image _image);
		public abstract bool DeleteImage(int ImageID);

		#endregion

		#region Archives
        public abstract ICollection<ArchiveCount> GetPostsByYearArchive();
        public abstract ICollection<ArchiveCount> GetPostsByMonthArchive();
		#endregion
		#endregion
	}
}