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
using System.Configuration;
using System.Web;
using System.Web.Configuration;
using System.Web.Security;
using Subtext.Extensibility.Interfaces;
using Subtext.Framework.Exceptions;
using Subtext.Framework.Format;
using Subtext.Framework.Properties;
using Subtext.Framework.Providers;
using Subtext.Framework.Security;

namespace Subtext.Framework.Configuration
{
	/// <summary>
	/// Static helper class used to access various configuration 
	/// settings.
	/// </summary>
	public static class Config
	{
		private static readonly 
			string[] InvalidSubfolders = { "Tags", "Admin", "aggbug", "Archive", "Archives", "Articles", "bin", 
				"Category", "Comments", "ExternalDependencies", "Gallery", "HostAdmin", "Images", "Install", 
				"Modules", "Posts", "Properties", "Providers", "Scripts", "Services", "Sitemap", "Skins", 
				"Stories", "Story", "SystemMessages", "UI"
		};

		private const string InvalidChars = @"{}[]/\ @!#$%:^&*()?+|""='<>;,";

		private static UrlBasedBlogInfoProvider _configProvider;

		/// <summary>
		/// Returns an instance of <see cref="BlogConfigurationSettings"/> which 
		/// are configured within web.config as a custom config section.
		/// </summary>
		/// <value></value>
		public static BlogConfigurationSettings Settings
		{
			get
			{
				return ((BlogConfigurationSettings)ConfigurationManager.GetSection("BlogConfigurationSettings"));
			}
		}

		/// <summary>
		/// Gets the file not found page from web.config.
		/// </summary>
		/// <returns></returns>
		public static string GetFileNotFoundPage()
		{
			CustomErrorsSection errorsSection = WebConfigurationManager.GetWebApplicationSection("system.web/customErrors") as CustomErrorsSection;
			if (errorsSection != null)
			{
				CustomError fileNotFoundError = errorsSection.Errors["404"];
				if (fileNotFoundError != null)
				{
					return fileNotFoundError.Redirect;
				}
			}
			return null;
		}

		/// <summary>
		/// Returns a <see cref="BlogInfo"/> instance containing 
		/// the configuration settings for the current blog.
		/// </summary>
		/// <remarks>
		///	<para>This property may throw an exception in a couple of cases. The reason for 
		/// this is that there are a couple different reasons why the Current Blog might 
		/// not exist and we handle those situations differently in the UI. Returning 
		/// NULL does not give us enough information.
		/// </para>
		/// </remarks>
		/// <exception type="BlogDoesNotExistException">Thrown if the blog does not exist</exception>
		/// <exception type="BlogInactiveException">Thrown if the blog is no longer active</exception>
		/// <returns>The current blog</returns>
		public static BlogInfo CurrentBlog
		{
			get
			{
				if (HttpContext.Current == null)
					return null;

				if (InstallationManager.IsInHostAdminDirectory)
					return null;
				
				BlogInfo currentBlog = ConfigurationProvider.GetBlogInfo();
				return currentBlog;
			}
		}

		/// <summary>
		/// Gets the count of active blogs.
		/// </summary>
		/// <value></value>
		public static int ActiveBlogCount
		{
			get
			{
				IPagedCollection<BlogInfo> blogs = BlogInfo.GetBlogs(1, 1, ConfigurationFlags.IsActive);
				return blogs.MaxItems;
			}
		}

		/// <summary>
		/// Gets the total blog count in the system, active or not.
		/// </summary>
		/// <value></value>
		public static int BlogCount
		{
			get
			{
				IPagedCollection blogs = BlogInfo.GetBlogs(1, 1, ConfigurationFlags.None);
				return blogs.MaxItems;
			}
		}

		/// <summary>
		/// Gets or sets the configuration provider.
		/// </summary>
		/// <value></value>
		public static UrlBasedBlogInfoProvider ConfigurationProvider
		{
			get
			{
				if (_configProvider == null)
				{
					_configProvider = UrlBasedBlogInfoProvider.Instance;
				}
				return _configProvider;
			}
			set
			{
				_configProvider = value;
			}
		}

		/// <summary>
		/// Returns a <see cref="BlogInfo"/> instance containing 
		/// the configuration settings for the blog specified by the 
		/// Hostname and Application.
		/// </summary>
		/// <param name="hostName">Hostname.</param>
		/// <param name="subfolder">Subfolder Name.</param>
		/// <returns></returns>
		public static BlogInfo GetBlogInfo(string hostName, string subfolder)
		{
			return GetBlogInfo(hostName, subfolder, false);
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
		/// <param name="hostName">Hostname.</param>
		/// <param name="subfolder">Subfolder Name.</param>
		/// <param name="strict">If false, then this will return a blog record if 
		/// there is only one blog record, regardless if the subfolder and hostname match.</param>
		/// <returns></returns>
		public static BlogInfo GetBlogInfo(string hostName, string subfolder, bool strict)
		{
			hostName = BlogInfo.StripPortFromHost(hostName);
			return ObjectProvider.Instance().GetBlogInfo(hostName, subfolder, strict);
		}

		/// <summary>
		/// Creates the blog with the specified user as the owner.
		/// </summary>
		/// <param name="title">The title of the blog.</param>
		/// <param name="host">The host.</param>
		/// <param name="subfolder">The subfolder.</param>
		/// <param name="owner">The owner.</param>
		/// <returns></returns>
		public static BlogInfo CreateBlog(string title, string host, string subfolder, MembershipUser owner)
		{
			if (String.IsNullOrEmpty(title))
				throw new ArgumentNullException("title", "Cannot create a blog with a null or empty title");

			if (String.IsNullOrEmpty(host))
				throw new ArgumentNullException("host", "Cannot create a blog with a null or empty host");

			if (owner == null)
				throw new ArgumentNullException("owner", "Every blog must have an owner.");

			if (subfolder != null && subfolder.EndsWith("."))
				throw new InvalidSubfolderNameException(subfolder);

			host = BlogInfo.StripPortFromHost(host);
			subfolder = UrlFormats.StripSurroundingSlashes(subfolder ?? string.Empty);

			CheckForDuplicateBlog(host, subfolder);
			ValidateSubfolderName(host, subfolder);
			
			//Add blog user to Administrators.
			BlogInfo blog = ObjectProvider.Instance().CreateBlog(title, host, subfolder, owner);
			using (MembershipApplicationScope.SetApplicationName(blog.ApplicationName))
			{
				CreateBlogRoles();
			}
			return blog;
		}

		private static void ValidateSubfolderRequired(string host)
		{
			//Check to see if this blog requires a Subfolder value
			//This would occur if another blog has the same host already.
			int activeBlogWithHostCount = BlogInfo.GetBlogsByHost(host, 0, 1, ConfigurationFlags.IsActive).Count;
			if (activeBlogWithHostCount > 0)
			{
				throw new BlogRequiresSubfolderException(host, activeBlogWithHostCount);
			}
		}

		private static void ValidateSubfolderName(string host, string subfolder)
		{
			if (!String.IsNullOrEmpty(subfolder))
			{
				//Check to see if we're going to end up hiding another blog.
				BlogInfo potentialHidden = GetBlogInfo(host, string.Empty, true);
				if (potentialHidden != null)
				{
					//We found a blog that would be hidden by this one.
					throw new BlogHiddenException(potentialHidden);
				}

				if (!IsValidSubfolderName(subfolder))
				{
					throw new InvalidSubfolderNameException(subfolder);
				}
			}
			else
			{
				ValidateSubfolderRequired(host);
			}
		}

		private static void CheckForDuplicateBlog(string host, string subfolder)
		{
			BlogInfo potentialDuplicate = GetBlogInfo(host, subfolder, true);
			if (potentialDuplicate != null)
			{
				//we found a duplicate!
				throw new BlogDuplicationException(potentialDuplicate);
			}
		}

		private static void CreateBlogRoles()
		{
			string[] defaultRoles =
				{ RoleNames.Administrators, RoleNames.PowerUsers, RoleNames.Authors, RoleNames.Commenters, RoleNames.Anonymous };

			foreach (string role in defaultRoles)
			{
				if (!Roles.RoleExists(role))
					Roles.CreateRole(role);
			}
		}

		/// <summary>
		/// Updates the database with the configuration data within 
		/// the specified <see cref="BlogInfo"/> instance.
		/// </summary>
		/// <param name="info">Config.</param>
		/// <returns></returns>
		public static void UpdateConfigData(BlogInfo info)
		{
			//Check for duplicate
			BlogInfo potentialDuplicate = GetBlogInfo(info.Host, info.Subfolder, true);
			if (potentialDuplicate != null && !potentialDuplicate.Equals(info))
			{
				//we found a duplicate!
				throw new BlogDuplicationException(potentialDuplicate);
			}

			//Check to see if we're going to end up hiding another blog.
			BlogInfo potentialHidden = GetBlogInfo(info.Host, string.Empty, true);
			if (potentialHidden != null && !potentialHidden.Equals(info) && potentialHidden.IsActive)
			{
				//We found a blog that would be hidden by this one.
				throw new BlogHiddenException(potentialHidden);
			}

			string subfolderName = info.Subfolder == null ? string.Empty : UrlFormats.StripSurroundingSlashes(info.Subfolder);

			if (subfolderName.Length == 0)
			{
				//Check to see if this blog requires a Subfolder value
				//This would occur if another blog has the same host already.
				IPagedCollection<BlogInfo> blogsWithHost = BlogInfo.GetBlogsByHost(info.Host, 0, 1, ConfigurationFlags.IsActive);
				if (blogsWithHost.Count > 0)
				{
					if (blogsWithHost.Count > 1 || !blogsWithHost[0].Equals(info))
					{
						throw new BlogRequiresSubfolderException(info.Host, blogsWithHost.Count);
					}
				}
			}
			else
			{
				if (!IsValidSubfolderName(subfolderName))
				{
					throw new InvalidSubfolderNameException(subfolderName);
				}
			}
			info.AllowServiceAccess = Settings.AllowServiceAccess;

			ObjectProvider.Instance().UpdateBlog(info);
		}

		/// <summary>
		/// Returns true if the specified subfolder name has a 
		/// valid format. It may not start, nor end with ".".  It 
		/// may not contain any of the following invalid characters 
		/// {}[]/\ @!#$%:^&*()?+|"='<>;,
		/// </summary>
		/// <param name="subfolder">subfolder.</param>
		/// <returns></returns>
		public static bool IsValidSubfolderName(string subfolder)
		{
			if (subfolder == null)
			{
				throw new ArgumentNullException("subfolder", Resources.ArgumentNull_String);
			}

			if (subfolder.EndsWith("."))
				return false;

			foreach (char c in InvalidChars)
			{
				if (subfolder.IndexOf(c) > -1)
					return false;
			}

			foreach (string invalidSubFolder in InvalidSubfolders)
			{
				if (String.Equals(invalidSubFolder, subfolder, StringComparison.InvariantCultureIgnoreCase))
					return false;
			}
			return true;
		}
	}
}
