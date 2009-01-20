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
using System.Collections;
using System.Collections.Generic;
using System.Configuration.Provider;
using Subtext.Extensibility;
using Subtext.Extensibility.Interfaces;
using Subtext.Extensibility.Providers;
using Subtext.Framework.Components;
using Subtext.Framework.Configuration;

namespace Subtext.Framework.Providers
{
	/// <summary>
	/// Provides a Data Object Source for interacting with Subtext Data.  One example 
	/// is a DataObjectProvider, which stores Subtext data in a database (which itself is 
	/// provided via the <see cref="DbProvider"/> class).
	/// </summary>
    public abstract class ObjectProvider : ProviderBase
	{
		private static ObjectProvider provider = null;
		private static GenericProviderCollection<ObjectProvider> providers = ProviderConfigurationHelper.LoadProviderCollection("ObjectProvider", out provider);

		/// <summary>
		/// Returns the currently configured ObjectProvider.
		/// </summary>
		/// <returns></returns>
		public static ObjectProvider Instance()
		{
			return provider;
		}

        public abstract void ClearBlogContent(int blogId);

		/// <summary>
		/// Returns all the configured ObjectProvider.
		/// </summary>
		public static GenericProviderCollection<ObjectProvider> Providers
		{
			get
			{
				return providers;
			}
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

        /// <summary>
        /// Inserts the blog group.
        /// </summary>
        /// <param name="blogGroup">The group to insert.</param>
        /// <returns>The blog group id</returns>
        public abstract int InsertBlogGroup(BlogGroup blogGroup);

        /// <summary>
        /// Update the blog group.
        /// </summary>
        /// <param name="blogGroup">The group to insert.</param>
        /// <returns>The blog group id</returns>
        public abstract bool UpdateBlogGroup(BlogGroup blogGroup);

        public abstract bool DeleteBlogGroup(int blogGroupId);
		#endregion Host

		#region Blogs
		/// <summary>
		/// Gets a pageable <see cref="ICollection"/> of <see cref="Blog"/> instances.
		/// </summary>
		/// <param name="host">The host to filter by.</param>
		/// <param name="pageIndex">Page index.</param>
		/// <param name="pageSize">Size of the page.</param>
		/// <returns></returns>
		/// <param name="flags"></param>
		public abstract IPagedCollection<Blog> GetPagedBlogs(string host, int pageIndex, int pageSize, ConfigurationFlags flags);
		
		/// <summary>
		/// Gets the blog by id.
		/// </summary>
		/// <param name="blogId">Blog id.</param>
		/// <returns></returns>
		public abstract Blog GetBlogById(int blogId);

		public abstract Blog GetBlogByDomainAlias(string host, string subfolder, bool strict);

		public abstract IPagedCollection<BlogAlias> GetPagedBlogDomainAlias(Blog blog, int pageIndex, int pageSize);

		#endregion Blogs

		#region Blog Groups
		/// <summary>
		/// Gets the blog group by id.
		/// </summary>
		/// <param name="id">The id.</param>
		/// <param name="activeOnly">if set to <c>true</c> [active only].</param>
		/// <returns></returns>
		public abstract BlogGroup GetBlogGroup(int id, bool activeOnly);

		/// <summary>
		/// Lists the blog groups.
		/// </summary>
		/// <param name="activeOnly">if set to <c>true</c> [active only].</param>
		/// <returns></returns>
		public abstract ICollection<BlogGroup> ListBlogGroups(bool activeOnly);
		#endregion

		#region BlogAlias

		public abstract bool CreateBlogAlias(BlogAlias alias);

		public abstract bool UpdateBlogAlias(BlogAlias alias);

		public abstract bool DeleteBlogAlias(BlogAlias alias);

		#endregion

		#region Entries

		#region Paged Posts

		/// <summary>
		/// Returns a pageable collection of entries ordered by the id descending.
		/// This is used in the admin section.
		/// </summary>
		/// <param name="postType">Type of the post.</param>
		/// <param name="categoryID">The category ID.</param>
		/// <param name="pageIndex">Index of the page.</param>
		/// <param name="pageSize">Size of the page.</param>
		/// <returns></returns>
        public abstract IPagedCollection<Entry> GetPagedEntries(PostType postType, int categoryID, int pageIndex, int pageSize);

		/// <summary>
		/// Gets the paged feedback.
		/// </summary>
		/// <param name="pageIndex">Index of the page.</param>
		/// <param name="pageSize">Size of the page.</param>
		/// <param name="status">A flag for the status types to return.</param>
		/// <param name="excludeStatusMask">A flag for the statuses to exclude.</param>
		/// <param name="type">The type of feedback to return.</param>
		/// <returns></returns>
		public abstract IPagedCollection<FeedbackItem> GetPagedFeedback(int pageIndex, int pageSize, FeedbackStatusFlag status, FeedbackStatusFlag excludeStatusMask, FeedbackType type);
		
		#endregion

		#region EntryDays

		public abstract EntryDay GetEntryDay(DateTime dt);
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
		/// Returns the previous and next entry to the specified entry.
		/// </summary>
		/// <param name="entryId"></param>
		/// <param name="postType"></param>
		/// <returns></returns>
		public abstract ICollection<Entry> GetPreviousAndNextEntries(int entryId, PostType postType);
		
		/// <summary>
		/// Gets the entries that meet the <see cref="PostType"/> and 
		/// <see cref="PostConfig"/> flags.
		/// </summary>
		/// <param name="itemCount">Item count.</param>
		/// <param name="postType">The type of entry to return.</param>
		/// <param name="postConfig">Post Configuration options.</param>
        /// <param name="includeCategories">Whether or not to include categories</param>
		/// <returns></returns>
		public abstract ICollection<Entry> GetEntries(int itemCount, PostType postType, PostConfig postConfig, bool includeCategories);
		
		/// <summary>
		/// Gets the <see cref="FeedbackItem" /> items for the specified entry.
		/// </summary>
		/// <param name="parentEntry">The parent entry.</param>
		/// <returns></returns>
		public abstract ICollection<FeedbackItem> GetFeedbackForEntry(Entry parentEntry);

		/// <summary>
		/// Gets the feedback by the specified id.
		/// </summary>
		/// <param name="id">The id.</param>
		/// <returns></returns>
		public abstract FeedbackItem GetFeedback(int id);

		/// <summary>
		/// Gets the feedback counts for the various top level statuses.
		/// </summary>
		/// <param name="approved">The approved.</param>
		/// <param name="needsModeration">The needs moderation.</param>
		/// <param name="flaggedAsSpam">The flagged as spam.</param>
		/// <param name="deleted">The deleted.</param>
		public abstract void GetFeedbackCounts(out int approved, out int needsModeration, out int flaggedAsSpam, out int deleted);
		
		public abstract ICollection<Entry> GetPostsByMonth(int month, int year);
		public abstract ICollection<Entry> GetPostsByDayRange(DateTime start, DateTime stop, PostType postType, bool activeOnly);
		public abstract ICollection<Entry> GetEntriesByCategory(int ItemCount,int catID,bool ActiveOnly);
        public abstract ICollection<Entry> GetEntriesByTag(int itemCount, string tagName);

		#endregion

		#region Single Entry

		/// <summary>
		/// Searches the data store for the first comment with a 
		/// matching checksum hash.
		/// </summary>
		/// <param name="checksumHash">Checksum hash.</param>
		/// <returns></returns>
		public abstract FeedbackItem GetFeedbackByChecksumHash(string checksumHash);
        
	    /// <summary>
	    /// Returns an <see cref="Entry" /> with the specified id as long as it is 
	    /// within the current blog (Config.CurrentBlog).
	    /// </summary>
	    /// <param name="id">Id of the entry</param>
        /// <param name="activeOnly">Whether or not to only return the entry if it is active.</param>
        /// <param name="includeCategories">Whether the entry should have its Categories property populated</param>
	    /// <returns></returns>
	    public abstract Entry GetEntry(int id, bool activeOnly, bool includeCategories);

		/// <summary>
		/// Returns an active <see cref="Entry" /> by the id regardless of which blog it is 
		/// located in.
		/// </summary>
		/// <param name="id">Id of the entry</param>
		/// <param name="includeCategories">Whether the entry should have its Categories property populated</param>
		/// <returns></returns>
		public abstract Entry GetEntry(int id, bool includeCategories);

        /// <summary>
		/// Returns an <see cref="Entry" /> with the specified entry name as long as it is 
		/// within the current blog (Config.CurrentBlog).
        /// </summary>
        /// <param name="entryName">Url friendly entry name.</param>
        /// <param name="activeOnly">Whether or not to only return the entry if it is active.</param>
        /// <param name="includeCategories">Whether the entry should have its Categories property populated</param>
        /// <returns></returns>
        public abstract Entry GetEntry(string entryName, bool activeOnly, bool includeCategories);

		#endregion

		#region Delete

		/// <summary>
		/// Deletes the specified entry.
		/// </summary>
		/// <param name="entryId">The entry id.</param>
		/// <returns></returns>
		public abstract bool DeleteEntry(int entryId);

		/// <summary>
		/// Completely deletes the specified feedback as 
		/// opposed to moving it to the trash.
		/// </summary>
		/// <param name="id">The id.</param>
		public abstract void DestroyFeedback(int id);

		/// <summary>
		/// Destroys the feedback with the given status.
		/// </summary>
		/// <param name="status">The status.</param>
		public abstract void DestroyFeedback(FeedbackStatusFlag status);
		#endregion

		/// <summary>
		/// Creates a feedback record and returs the id of the newly created item.
		/// </summary>
		/// <param name="feedbackItem"></param>
		/// <returns></returns>
		public abstract int Create(FeedbackItem feedbackItem);
		
		/// <summary>
		/// Creates the specified entry attaching the specified categories.
		/// </summary>
		/// <param name="entry">Entry.</param>
		/// <param name="categoryIds">Category Ids.</param>
		/// <returns></returns>
		public abstract int Create(Entry entry, int[] categoryIds);

        /// <summary>
        /// Saves changes to the specified entry attaching the specified categories.
        /// </summary>
        /// <param name="entry">Entry.</param>
        /// <param name="categoryIds">Category Ids.</param>
        /// <returns></returns>
		public abstract bool Update(Entry entry, int[] categoryIds);

		/// <summary>
		/// Saves changes to the specified feedback.
		/// </summary>
		/// <param name="feedbackItem">The feedback item.</param>
		/// <returns></returns>
		public abstract bool Update(FeedbackItem feedbackItem);

		#region Entry Category List

		public abstract bool SetEntryCategoryList(int entryId, IEnumerable<int> categoryIds);

		#endregion

        #region Entry Tag List

		/// <summary>
		/// Sets the tags for the entry.
		/// </summary>
		/// <param name="entryId"></param>
		/// <param name="tags"></param>
		/// <returns></returns>
		public abstract bool SetEntryTagList(int entryId, IEnumerable<string> tags);

        #endregion

        #endregion

        #region Links/Categories

        #region Paged Links

        public abstract IPagedCollection<Link> GetPagedLinks(int categoryTypeID, int pageIndex, int pageSize, bool sortDescending);

		#endregion

		#region LinkCollection

        public abstract ICollection<Link> GetLinkCollectionByPostID(int PostID);

		#endregion

		#region Single Link

		public abstract Link GetLink(int linkID);
		
		#endregion

		#region LinkCategoryCollection

        public abstract ICollection<LinkCategory> GetCategories(CategoryType catType, bool activeOnly);
        public abstract ICollection<LinkCategory> GetActiveCategories();

		#endregion

		#region LinkCategory
		/// <summary>
		/// Gets the link category for the specified category id.
		/// </summary>
		/// <param name="categoryId">The category id.</param>
		/// <param name="activeOnly">if set to <c>true</c> [active only].</param>
		/// <returns></returns>
		public abstract LinkCategory GetLinkCategory(int categoryId, bool activeOnly);

		/// <summary>
		/// Gets the link category for the specified category name.
		/// </summary>
		/// <param name="categoryName">The category name.</param>
		/// <param name="activeOnly">if set to <c>true</c> [active only].</param>
		/// <returns></returns>
		public abstract LinkCategory GetLinkCategory(string categoryName, bool activeOnly);
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
        public abstract int CreateBlog(string title, string userName, string password, string host, string subfolder);

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
        /// <param name="blogGroupId"></param>
		/// <returns>The id of the created blog.</returns>
        public abstract int CreateBlog(string title, string userName, string password, string host, string subfolder, int blogGroupId);

		/// <summary>
		/// Updates the specified blog configuration.
		/// </summary>
		/// <param name="info">Config.</param>
		/// <returns></returns>
		public abstract bool UpdateBlog(Blog info);
		
		/// <summary>
		/// Returns a <see cref="Blog"/> instance containing 
		/// the configuration settings for the blog specified by the 
		/// Hostname and Application.
		/// </summary>
		/// <param name="hostname">Hostname.</param>
		/// <param name="subfolder">Subfolder Name.</param>
		/// <returns></returns>
		/// <param name="hostname">Hostname.</param>
		/// <param name="subfolder">Subfolder.</param>
		/// <returns></returns>
		public Blog GetBlog(string hostname, string subfolder)
		{
			return GetBlog(hostname, subfolder, true);
		}

		/// <summary>
		/// Returns a <see cref="Blog"/> instance containing 
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
		public abstract Blog GetBlog(string hostname, string subfolder, bool strict);
		#endregion

        #region Tags

        /// <summary>
        /// Gets the top tags from the database sorted by tag name.
        /// </summary>
        /// <param name="ItemCount">The number of tags to return.</param>
        /// <returns>
        /// A sorted dictionary with the tag name as key and entry count
        /// as value.
        /// </returns>
        public abstract IDictionary<string, int> GetTopTags(int ItemCount);

        #endregion

		#region MetaTags

        /// <summary>
        /// Adds the given MetaTag to the data store.
        /// </summary>
        /// <param name="metaTag"></param>
        /// <returns></returns>
	    public abstract int Create(MetaTag metaTag);

        /// <summary>
        /// Updates the given MetaTag in the data store.
        /// </summary>
        /// <param name="metaTag"></param>
        /// <returns></returns>
	    public abstract bool Update(MetaTag metaTag);

        /// <summary>
		/// Gets a collection of MetaTags for the given Blog.
		/// </summary>
		/// <returns></returns>
        public abstract IPagedCollection<MetaTag> GetMetaTagsForBlog(Blog blog, int pageIndex, int pageSize);

        /// <summary>
        /// Gets a collection of MetaTags for the given Entry
        /// </summary>
        /// <param name="entry"></param>
        /// <returns></returns>
	    public abstract IPagedCollection<MetaTag> GetMetaTagsForEntry(Entry entry, int pageIndex, int pageSize);

        /// <summary>
        /// Deletes the MetaTag with the given metaTagId.
        /// </summary>
        /// <param name="metaTagId"></param>
        /// <returns></returns>
        public abstract bool DeleteMetaTag(int metaTagId);

		#endregion

        #region Enclosures

        /// <summary>
        /// Adds the given enclosure to the data store
        /// </summary>
        /// <param name="enclosure"></param>
        /// <returns>Id of the enclosure created</returns>
	    public abstract int Create(Enclosure enclosure);

        public abstract bool Update(Enclosure metaTag);

        public abstract bool DeleteEnclosure(int enclosureId);

        #endregion

        #region KeyWords

        public abstract KeyWord GetKeyWord(int KeyWordID);
        public abstract ICollection<KeyWord> GetKeyWords();
        public abstract IPagedCollection<KeyWord> GetPagedKeyWords(int pageIndex, int pageSize);
		public abstract bool UpdateKeyWord(KeyWord keyWord);
		public abstract int InsertKeyWord(KeyWord keyWord);
		public abstract bool DeleteKeyWord(int id);

		#endregion

		#region Images

        public abstract ImageCollection GetImagesByCategoryID(int catID, bool activeOnly);
		public abstract Image GetImage(int imageID, bool activeOnly);
		public abstract int InsertImage(Image image);
		public abstract bool UpdateImage(Image image);
		public abstract bool DeleteImage(int ImageID);

		#endregion

		#region Archives
        public abstract ICollection<ArchiveCount> GetPostCountsByYear();
        public abstract ICollection<ArchiveCount> GetPostCountsByMonth();
        public abstract ICollection<ArchiveCount> GetPostCountsByCategory();
		#endregion
		#endregion

		public abstract BlogAlias GetBlogAliasById(int aliasId);
        public abstract ICollection<Blog> GetBlogsByGroup(string host, int? groupId);
        public abstract ICollection<BlogGroup> GroupBlogs(IEnumerable<Blog> blogs);
        public abstract HostStats GetTotalBlogStats(string host, int groupId);
        public abstract ICollection<Entry> GetRecentEntries(string host, int? groupId, int rowCount);
        public abstract ICollection<Image> GetImages(string host, int? groupId, int rowCount);
        public abstract ICollection<EntrySummary> GetTopEntrySummaries(int blogId, int rowCount);
        public abstract ICollection<EntrySummary> GetRelatedEntries(int blogId, int entryId, int rowCount);
	}
}
