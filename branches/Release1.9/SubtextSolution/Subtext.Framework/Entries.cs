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
using System.Collections.ObjectModel;
using System.Collections.Specialized;
using System.Configuration;
using System.Diagnostics;
using System.Text.RegularExpressions;
using System.Web;
using log4net;
using Subtext.Extensibility;
using Subtext.Extensibility.Interfaces;
using Subtext.Framework.Components;
using Subtext.Framework.Configuration;
using Subtext.Framework.Logging;
using Subtext.Framework.Providers;
using Subtext.Framework.Text;
using Subtext.Framework.Tracking;

namespace Subtext.Framework
{
	/// <summary>
	/// Static class used to get entries (blog posts, comments, etc...) 
	/// from the data store.
	/// </summary>
	public static class Entries
	{
		private readonly static ILog log = new Log();		
	
		#region Paged Posts

		/// <summary>
		/// Returns a collection of Posts for a give page and index size.
		/// </summary>
		/// <param name="postType"></param>
		/// <param name="categoryID">-1 means not to filter by a categoryID</param>
		/// <param name="pageIndex"></param>
		/// <param name="pageSize"></param>
		/// <returns></returns>
        public static IPagedCollection<Entry> GetPagedEntries(PostType postType, int categoryID, int pageIndex, int pageSize)
		{
			return ObjectProvider.Instance().GetPagedEntries(postType, categoryID, pageIndex, pageSize);
		}
		#endregion

		public static EntryDay GetSingleDay(DateTime dt)
		{
			return ObjectProvider.Instance().GetEntryDay(dt);
		}

		/// <summary>
		/// Gets the entries to display on the home page.
		/// </summary>
		/// <param name="itemCount">Item count.</param>
		/// <returns></returns>
        public static ICollection<EntryDay> GetHomePageEntries(int itemCount)
		{
			return GetBlogPosts(itemCount, PostConfig.DisplayOnHomePage | PostConfig.IsActive);
		}

		/// <summary>
		/// Gets the specified number of entries using the <see cref="PostConfig"/> flags 
		/// specified.
		/// </summary>
		/// <remarks>
		/// This is used to get the posts displayed on the home page.
		/// </remarks>
		/// <param name="itemCount">Item count.</param>
		/// <param name="pc">Pc.</param>
		/// <returns></returns>
        public static ICollection<EntryDay> GetBlogPosts(int itemCount, PostConfig pc)
		{
			return ObjectProvider.Instance().GetBlogPosts(itemCount, pc);
		}

		public static ICollection<EntryDay> GetPostsByMonth(int month, int year)
		{
			return ObjectProvider.Instance().GetPostsByMonth(month,year);
		}

        public static ICollection<EntryDay> GetPostsByCategoryID(int itemCount, int catID)
		{
			return ObjectProvider.Instance().GetPostsByCategoryID(itemCount,catID);
		}


		#region EntryCollections

		/// <summary>
		/// Gets the main syndicated entries.
		/// </summary>
		/// <param name="itemCount">Item count.</param>
		/// <returns></returns>
		public static IList<Entry> GetMainSyndicationEntries(int itemCount)
		{
            return GetRecentPosts(itemCount, PostType.BlogPost, PostConfig.IncludeInMainSyndication | PostConfig.IsActive, true);
		}

		/// <summary>
		/// Gets the comments (including trackback, etc...) for the specified entry.
		/// </summary>
		/// <param name="parentEntry">Parent entry.</param>
		/// <returns></returns>
        public static IList<FeedbackItem> GetFeedBack(Entry parentEntry)
		{
			return ObjectProvider.Instance().GetFeedbackForEntry(parentEntry);
		}

		/// <summary>
		/// Returns the itemCount most recent posts.  
		/// This is used to support MetaBlogAPI...
		/// </summary>
		/// <param name="itemCount"></param>
		/// <param name="postType"></param>
		/// <param name="postConfig"></param>
		/// <param name="includeCategories"></param>
		/// <returns></returns>
		public static IList<Entry> GetRecentPosts(int itemCount, PostType postType, PostConfig postConfig, bool includeCategories)
		{
			return ObjectProvider.Instance().GetConditionalEntries(itemCount, postType, postConfig, includeCategories);
		}

	    public static IList<Entry> GetPostCollectionByMonth(int month, int year)
		{
			return ObjectProvider.Instance().GetPostCollectionByMonth(month,year);
		}

        public static IList<Entry> GetPostsByDayRange(DateTime start, DateTime stop, PostType postType, bool activeOnly)
		{
			return  ObjectProvider.Instance().GetPostsByDayRange(start,stop,postType, activeOnly);
		}

        public static IList<Entry> GetEntriesByCategory(int itemCount, int catID, bool activeOnly)
		{
			return ObjectProvider.Instance().GetEntriesByCategory(itemCount,catID, activeOnly);
		}
		#endregion

		#region Single Entry

		/// <summary>
		/// Searches the data store for the first comment with a 
		/// matching checksum hash.
		/// </summary>
		/// <param name="checksumHash">Checksum hash.</param>
		/// <returns></returns>
		public static Entry GetCommentByChecksumHash(string checksumHash)
		{
			return ObjectProvider.Instance().GetCommentByChecksumHash(checksumHash);
		}
		
		/// <summary>
		/// Gets the entry from the data store by id.
		/// </summary>
		/// <param name="entryId">The ID of the entry.</param>
		/// <param name="postConfig">The entry option used to constrain the search.</param>
		/// <param name="includeCategories">Whether the returned entry should have its categories collection populated.</param>
		/// <returns></returns>
		public static Entry GetEntry(int entryId, PostConfig postConfig, bool includeCategories)
		{
            bool isActive = ((postConfig & PostConfig.IsActive) == PostConfig.IsActive);
            return ObjectProvider.Instance().GetEntry(entryId, isActive, includeCategories);
		}

		/// <summary>
		/// Gets the entry from the data store by entry name.
		/// </summary>
		/// <param name="EntryName">Name of the entry.</param>
		/// <param name="postConfig">The entry option used to constrain the search.</param>
        /// <param name="includeCategories">Whether the returned entry should have its categories collection populated.</param>
		/// <returns></returns>
        public static Entry GetEntry(string EntryName, PostConfig postConfig, bool includeCategories)
		{
            bool isActive = ((postConfig & PostConfig.IsActive) == PostConfig.IsActive);
            return ObjectProvider.Instance().GetEntry(EntryName, isActive, includeCategories);
		}
		#endregion

		#region Delete
	
		/// <summary>
		/// Deletes the entry with the specified entryId.
		/// </summary>
		/// <param name="entryId"></param>
		/// <returns></returns>
		public static bool Delete(int entryId)
		{
			return ObjectProvider.Instance().Delete(entryId);
		}
		#endregion

		#region Create
		/// <summary>
		/// Creates the specified entry and returns its ID.
		/// </summary>
		/// <param name="entry">Entry.</param>
		/// <returns></returns>
		public static int Create(Entry entry)
		{
			Debug.Assert(entry.PostType != PostType.None, "Posttype should never be null.");
			
			if(Config.CurrentBlog.AutoFriendlyUrlEnabled
				&& String.IsNullOrEmpty(entry.EntryName)
				&& !String.IsNullOrEmpty(entry.Title))
			{
				entry.EntryName = AutoGenerateFriendlyUrl(entry.Title);
			}
            else if (!String.IsNullOrEmpty(entry.EntryName))
            {
                entry.EntryName = AutoGenerateFriendlyUrl(entry.EntryName);
            }
			
			if(NullValue.IsNull(entry.DateCreated))
			{
				entry.DateCreated = Config.CurrentBlog.TimeZone.Now;
			}

			if(entry.IsActive && entry.IncludeInMainSyndication)
				entry.DateSyndicated = Config.CurrentBlog.TimeZone.Now;
			else
				entry.DateSyndicated = NullValue.NullDateTime;

			int[] categoryIds = {};
			if(entry.Categories.Count > 0)
			{
				categoryIds = GetCategoryIdsFromCategoryTitles(entry);
			}
			
			entry.Id = ObjectProvider.Instance().Create(entry, categoryIds);
			log.Debug("Created entry, running notification services.");
			NotificationServices.Run(entry);
			return entry.Id;
		}

		private static int[] GetCategoryIdsFromCategoryTitles(Entry entry)
		{
			int[] categoryIds;
			Collection<int> catIds = new Collection<int>();
			//Ok, we have categories specified in the entry, but not the IDs.
			//We need to do something.
			foreach(string category in entry.Categories)
			{
				LinkCategory cat = Links.GetLinkCategory(category, true);
				if(cat != null)
				{
					catIds.Add(cat.Id);
				}
			}
			categoryIds = new int[catIds.Count];
			catIds.CopyTo(categoryIds, 0);
			return categoryIds;
        }

        #endregion

        /// <summary>
		/// Converts a title of a blog post into a friendly, but URL safe string.
		/// </summary>
		/// <param name="title">The original title of the blog post.</param>
		/// <returns></returns>
		public static string AutoGenerateFriendlyUrl(string title)
		{
			if(title == null)
				throw new ArgumentNullException("title", "Cannot generate friendly url from null title.");

            NameValueCollection friendlyUrlSettings = (NameValueCollection)ConfigurationManager.GetSection("FriendlyUrlSettings");
			if(friendlyUrlSettings == null)
			{
				//Default to old behavior.
				return AutoGenerateFriendlyUrl(title, char.MinValue);
			}

			string wordSeparator = friendlyUrlSettings["separatingCharacter"];
			int wordCount;

			if (friendlyUrlSettings["limitWordCount"] == null)
			{
				wordCount = 0;
			}
			else
			{
				wordCount = int.Parse(friendlyUrlSettings["limitWordCount"]);
			}
			
			// break down to number of words. If 0 (or less) don't mess with the title
			if (wordCount > 0)
			{
				//only do this is there are more words than allowed.
				string[] words;
				words = title.Split(" ".ToCharArray());

				if (words.Length > wordCount)
				{
					//now strip the title down to the number of allowed words
					int wordCharCounter = 0;
					for (int i = 0; i < wordCount; i++)
					{
						wordCharCounter = wordCharCounter + words[i].Length + 1;
					}

					title = title.Substring(0, wordCharCounter-1);
				}
			}

			// separating characters are limited due to the problems certain chars
			// can cause. Only - _ and . are allowed
			if ((wordSeparator == "_") || (wordSeparator == ".") || (wordSeparator =="-"))
			{
				return AutoGenerateFriendlyUrl(title, wordSeparator[0]);
			}
			else
			{
				//invalid separator or none defined.
				return AutoGenerateFriendlyUrl(title, char.MinValue);
			}

		}

		/// <summary>
		/// Converts a title of a blog post into a friendly, but URL safe string.
		/// </summary>
		/// <param name="title">The original title of the blog post.</param>
		/// <param name="wordSeparator">The string used to separate words in the title.</param>
		/// <returns></returns>
		public static string AutoGenerateFriendlyUrl(string title, char wordSeparator)
		{
			if(title == null)
				throw new ArgumentNullException("title", "Cannot generate friendly url from null title.");
			
			string entryName = RemoveNonWordCharacters(title);
			entryName = ReplaceSpacesWithSeparator(entryName, wordSeparator);
			entryName = HttpUtility.UrlEncode(entryName);
			entryName = RemoveTrailingPeriods(entryName);
			entryName = entryName.Trim(new char[] {wordSeparator});
			entryName = RemoveDoublePeriods(entryName);
		    
		    if (StringHelper.IsNumeric(entryName))
		    {
                entryName = "n" + wordSeparator + entryName;
		    }

			string newEntryName = entryName;
			int tryCount = 0;
			while(ObjectProvider.Instance().GetEntry(newEntryName, false, false) != null)
			{
				if(tryCount == 1)
					newEntryName = entryName + "Again";
				if(tryCount == 2)
					newEntryName = entryName + "YetAgain";
				if(tryCount == 3)
					newEntryName = entryName + "AndAgain";
				if(tryCount == 4)
					newEntryName = entryName + "OnceMore";
				if(tryCount == 5)
					newEntryName = entryName + "ToBeatADeadHorse";

				if(tryCount++ > 5)
					break; //Allow an exception to get thrown later.
			}

			return newEntryName;
		}

		static string ReplaceSpacesWithSeparator(string text, char wordSeparator)
		{
			if(wordSeparator == char.MinValue)
			{
				//Special case if we are just removing spaces.
				return StringHelper.PascalCase(text);
			}
			else
			{
				return text.Replace(' ', wordSeparator);
			}
		}

		static string RemoveNonWordCharacters(string text)
		{
			Regex regex = new Regex(@"[\w\d\. ]+", RegexOptions.Compiled);
			MatchCollection matches = regex.Matches(text);
			string cleansedText = string.Empty;

			foreach(Match match in matches)
			{
				if(match.Value.Length > 0)
				{
					cleansedText += match.Value;
				}
			}			
			return cleansedText;
		}
		
		static string RemoveDoublePeriods(string text)
		{
			while(text.IndexOf("..") > -1)
			{
				text = text.Replace("..", ".");
			}
			return text;
		}

		static string RemoveTrailingPeriods(string text)
		{
			Regex regex = new Regex(@"\.+$", RegexOptions.Compiled);
			return regex.Replace(text, string.Empty);
		}

		#region Update

		/// <summary>
		/// Updates the specified entry in the data provider.
		/// </summary>
		/// <param name="entry">Entry.</param>
		/// <returns></returns>
		public static bool Update(Entry entry)
		{
			if(NullValue.IsNull(entry.DateSyndicated) && entry.IsActive && entry.IncludeInMainSyndication)
			{
				entry.DateSyndicated = Config.CurrentBlog.TimeZone.Now;
			}
			
			if(!entry.IncludeInMainSyndication)
			{
				entry.DateSyndicated = NullValue.NullDateTime;
			}

			return Update(entry, null);
		}

		/// <summary>
		/// Updates the specified entry in the data provider 
		/// and attaches the specified categories.
		/// </summary>
		/// <param name="entry">Entry.</param>
		/// <param name="categoryIDs">Category Ids this entry belongs to.</param>
		/// <returns></returns>
		public static bool Update(Entry entry, params int[] categoryIDs)
		{
			entry.DateModified = Config.CurrentBlog.TimeZone.Now;

            if (!string.IsNullOrEmpty(entry.EntryName))
                entry.EntryName = AutoGenerateFriendlyUrl(entry.EntryName);

			return ObjectProvider.Instance().Update(entry, categoryIDs);
		}

		#endregion

		#region Entry Category List

		public static bool SetEntryCategoryList(int EntryID, int[] Categories)
		{
			return ObjectProvider.Instance().SetEntryCategoryList(EntryID,Categories);
		}

		#endregion
	}
}

