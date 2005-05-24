using System;
using Subtext.Framework.Configuration;

namespace Subtext.Framework.Exceptions
{
	/// <summary>
	/// Exception thrown when creating or updating a blog that would cause 
	/// another blog to be hidden.  This should be a rare occurrence, but 
	/// entirely possible with multiple blogs.
	/// </summary>
	/// <remarks>
	/// <p>This exception occurs when adding a blog with the same hostname as another blog, 
	/// but the original blog does not have an application name defined.</p>  
	/// <p>For example, if there exists a blog with the host "www.example.com" with no 
	/// application defined, and the admin adds another blog with the host "www.example.com" 
	/// and application as "MyBlog", this creates a multiple blog situation in the example.com 
	/// domain.  In that situation, each example.com blog MUST have an application name defined. 
	/// The URL to the example.com with no application becomes the aggregate blog.
	/// </p>
	/// </remarks>
	public class BlogHiddenException : BaseBlogConfigurationException
	{
		/// <summary>
		/// Creates a new <see cref="BlogHiddenException"/> instance.
		/// </summary>
		/// <param name="hidden">Hidden.</param>
		/// <param name="blogId"></param>
		public BlogHiddenException(BlogInfo hidden, int blogId) : base()
		{
			_hiddenBlog = hidden;
			_blogId = blogId;
		}

		/// <summary>
		/// Creates a new <see cref="BlogHiddenException"/> instance.
		/// </summary>
		/// <param name="hidden">Hidden.</param>
		public BlogHiddenException(BlogInfo hidden) : this(hidden, int.MinValue)
		{
			
		}

		/// <summary>
		/// Gets the hidden blog.
		/// </summary>
		/// <value></value>
		public BlogInfo HiddenBlog
		{
			get
			{
				return _hiddenBlog;
			}
		}

		BlogInfo _hiddenBlog;

		/// <summary>
		/// Gets the blog id.
		/// </summary>
		/// <value></value>
		public int BlogId
		{
			get { return _blogId; }
		}

		int _blogId;

		/// <summary>
		/// Gets the message.
		/// </summary>
		/// <value></value>
		public override string Message
		{
			get
			{
				string message = string.Empty;
				if(_blogId == int.MinValue)
				{
					message = "The blog you are trying to create ";
				}
				else
				{
					message = "Sorry, but by changing this blog to use that host combination ";
				}

				message += "would cause the blog entitled &#8220;" + _hiddenBlog.Title + "&#8221; to be hidden. "
					+ "This change would cause more than one blog to have the host &#8220;" + _hiddenBlog.Host + "&#8221;. "
					+ "When two or more blogs have the same host, they both need to have an application defined. " 
					+ "The previously mentioned blog does not have an application defined.  Please update it before ";

				if(_blogId == int.MinValue)
				{
					message += "creating this blog.";
				}
				else
				{
					message += "making this change.";
				}
				return message;
			}
		}


		/// <summary>
		/// Gets the message resource key.
		/// </summary>
		/// <value></value>
		public override string MessageResourceKey
		{
			get
			{
				throw new NotImplementedException("I8N not implemented.");
			}
		}


	}
}
