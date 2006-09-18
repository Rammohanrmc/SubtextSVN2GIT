using System;

namespace Subtext.Framework.Components
{
	/// <summary>
	/// Represents a trackback within this system. This is essentially 
	/// a comment created via the Trackback/Pingback API.
	/// </summary>
	public class Trackback : FeedbackItem
	{
		/// <summary>
		/// Initializes a new instance of the <see cref="Trackback"/> class.
		/// </summary>
		/// <param name="entryId">The parent id.</param>
		/// <param name="title">The title.</param>
		/// <param name="titleUrl">The title URL.</param>
		/// <param name="author">The author.</param>
		/// <param name="body">The body.</param>
		public Trackback(int entryId, string title, Uri titleUrl, string author, string body) : this(entryId, title, titleUrl, author, body, DateTime.Now)
		{
		}
		
		/// <summary>
		/// Initializes a new instance of the <see cref="Trackback"/> class.
		/// </summary>
		/// <param name="entryId">The parent id.</param>
		/// <param name="title">The title.</param>
		/// <param name="sourceUrl">The title URL.</param>
		/// <param name="author">The author.</param>
		/// <param name="body">The body.</param>
		/// <param name="dateCreated">The date created.</param>
		public Trackback(int entryId, string title, Uri sourceUrl, string author, string body, DateTime dateCreated) : base(Subtext.Extensibility.FeedbackType.PingTrack)
		{
			EntryId = entryId;
			Title = title;
			SourceUrl = sourceUrl;
			Author = author;
			Body = body;
			
			Approved = true;
			DateCreated = DateModified = dateCreated;
		}
	}
}
