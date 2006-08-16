using System;

namespace Subtext.BlogMl.Interfaces
{
	/// <summary>
	/// Represents the context of the request for 
	/// BlogMl.
	/// </summary>
	public interface IBlogMlContext
	{
		/// <summary>
		/// The id of the blog for which to import/export the blogml.
		/// </summary>
		string BlogId { get;}

		/// <summary>
		/// Whether or not to embed attachments.
		/// </summary>
		bool EmbedAttachments { get; }
	}
}
