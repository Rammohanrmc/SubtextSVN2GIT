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
using System.Web.Caching;
using Subtext.Framework.Components;
using Subtext.Framework.Configuration;
using Subtext.Framework.Exceptions;

namespace Subtext.Framework
{
	/// <summary>
	/// Class used to filter incoming comments.  This will get replaced 
	/// with a plugin once the plugin architecture is complete, but the 
	/// logic will probably get ported.
	/// </summary>
	public class CommentFilter
	{
		private const string FILTER_CACHE_KEY = "COMMENT FILTER:";

		Cache cache;

		/// <summary>
		/// Initializes a new instance of the <see cref="CommentFilter"/> class.
		/// </summary>
		public CommentFilter(Cache cache)
		{
			this.cache = cache;
		}

		/// <summary>
		/// Filters the comment. Throws an exception should the comment not be allowed. 
		/// Otherwise returns true.  This interface may be changed.
		/// </summary>
		/// <remarks>
		/// <p>
		/// The first filter examines whether comments are coming in too quickly 
		/// from the same SourceUrl.  Looks at the <see cref="BlogInfo.CommentDelayInMinutes"/>.
		/// </p>
		/// <p>
		/// The second filter checks for duplicate comments. It only looks at the body 
		/// of the comment.
		/// </p>
		/// </remarks>
		/// <param name="feedbackItem">Entry.</param>
		public void DetermineFeedbackApproval(FeedbackItem feedbackItem)
		{
			if (!Security.IsAdmin)
			{
				if (!SourceFrequencyIsValid(feedbackItem))
					throw new CommentFrequencyException();

				if (!Config.CurrentBlog.DuplicateCommentsEnabled && IsDuplicateComment(feedbackItem))
					throw new CommentDuplicateException();

				if (!Config.CurrentBlog.ModerationEnabled)
				{
					//Akismet Check...
					if (Config.CurrentBlog.FeedbackSpamServiceEnabled)
					{
						if (Config.CurrentBlog.FeedbackSpamService.IsSpam(feedbackItem))
						{
							//TODO: Could put this in a method "FlagSpam".
							feedbackItem.FlaggedAsSpam = true;
							feedbackItem.Approved = false;
							FeedbackItem.Update(feedbackItem);
							return;
						}
					}
					feedbackItem.Approved = true;
				}
				else //Moderated!
				{
					feedbackItem.NeedsModeratorApproval = true;
					feedbackItem.Approved = false;
				}
			}
			else
			{
				feedbackItem.Approved = true;
			}
			FeedbackItem.Update(feedbackItem);
		}

		// Returns true if the source of the entry is not 
		// posting too many.
		bool SourceFrequencyIsValid(FeedbackItem feedbackItem)
		{
			if(Config.CurrentBlog.CommentDelayInMinutes <= 0)
				return true;

			object lastComment = cache.Get(FILTER_CACHE_KEY + feedbackItem.IpAddress);
			
			if(lastComment != null)
			{
				//Comment was made too frequently.
				return false;
			}

			//Add to cache.
            this.cache.Insert(FILTER_CACHE_KEY + feedbackItem.IpAddress, string.Empty, null, DateTime.Now.AddMinutes(Config.CurrentBlog.CommentDelayInMinutes), TimeSpan.Zero);
			return true;
		}

		// Returns true if this entry is a duplicate.
		bool IsDuplicateComment(FeedbackItem feedbackItem)
		{
			const int RECENT_ENTRY_CAPACITY = 10;

			if(cache == null)
				return false;
			
			// Check the cache for the last 10 comments
			// Chances are, if a spam attack is occurring, then 
			// this entry will be a duplicate of a recent entry.
			// This checks in memory before going to the database (or other persistent store).
			Queue<string> recentComments = this.cache.Get(FILTER_CACHE_KEY + ".RECENT_COMMENTS") as Queue<string>;
			if(recentComments != null)
			{
				if (recentComments.Contains(feedbackItem.ChecksumHash))
					return true;
			}
			else
			{
				recentComments = new Queue<string>(RECENT_ENTRY_CAPACITY);	
				this.cache[FILTER_CACHE_KEY + ".RECENT_COMMENTS"] = recentComments;
			}

			// Check the database
			Entry duplicate = Entries.GetCommentByChecksumHash(feedbackItem.ChecksumHash);
			if(duplicate != null)
				return true;

			//Ok, this is not a duplicate... Update recent comments.
            if(recentComments.Count == RECENT_ENTRY_CAPACITY)
				recentComments.Dequeue();

			recentComments.Enqueue(feedbackItem.ChecksumHash);
			return false;
		}

		/// <summary>
		/// Clears the comment cache.
		/// </summary>
		public void ClearCommentCache()
		{
			this.cache.Remove(FILTER_CACHE_KEY + ".RECENT_COMMENTS");
		}
	}
}
