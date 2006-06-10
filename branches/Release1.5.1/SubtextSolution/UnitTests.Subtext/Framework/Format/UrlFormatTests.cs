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
using System.Globalization;
using System.Threading;
using System.Web;
using MbUnit.Framework;
using Subtext.Extensibility;
using Subtext.Framework;
using Subtext.Framework.Components;
using Subtext.Framework.Configuration;
using Subtext.Framework.Format;

namespace UnitTests.Subtext.Framework.Format
{
	/// <summary>
	/// Unit tests of the <see cref="UrlFormats"/> class which 
	/// is used to format Subtext specific urls.
	/// </summary>
	[TestFixture]
	public class UrlFormatTests
	{
		string _hostName;

		/// <summary>
		/// Makes sure that UrlFormats.GetBlogAppFromRequest does the right thing.
		/// </summary>
		[RowTest]
		[Row("/Subtext.Web/MyBlog/default.aspx", "/Subtext.Web", "MyBlog")]
		[Row("/subtext.web/MyBlog/default.aspx", "/Subtext.Web", "MyBlog")]
		[Row("/subtext.web/MyBlog/default.aspx", "Subtext.Web", "MyBlog")]
		[Row("/subtext.web/default.aspx", "/Subtext.Web", "")]
		[Row("/subtext.web", "/Subtext.Web", "")]
		[Row("/subtext.web/myBLOG/", "/Subtext.Web", "myBLOG")]
		public void GetBlogAppFromRequestDoesTheRightThing(string rawUrl, string subfolder, string expected)
		{
			Assert.AreEqual(expected, UrlFormats.GetBlogSubfolderFromRequest(rawUrl, subfolder));
		}

		/// <summary>
		/// Makes sure an entry url with no application is formatted correctly.
		/// </summary>
		[Test]
		public void EntryArchiveUrlWithNoApplication()
		{
			UnitTestHelper.SetHttpContextWithBlogRequest("localhost", string.Empty);
			BlogInfo blogInfo = new BlogInfo();
			blogInfo.Host = "localhost";
			blogInfo.Subfolder = string.Empty;

			HttpContext.Current.Items.Add("BlogInfo-", blogInfo);
			UrlFormats formats = new UrlFormats(Config.CurrentBlog.RootUrl);
			Entry entry = new Entry(PostType.BlogPost);
			entry.DateCreated = DateTime.Parse("January 23, 1975");
			entry.EntryID = 123;
			Assert.AreEqual("/archive/1975/01/23/123.aspx", formats.EntryUrl(entry));
		}

		/// <summary>
		/// Makes sure an entry url with no application is formatted correctly.
		/// </summary>
		[Test]
		public void EntryArchiveUrlWithApplication()
		{
			UnitTestHelper.SetHttpContextWithBlogRequest("localhost", "MyBlog");
			BlogInfo blogInfo = new BlogInfo();
			blogInfo.Host = "localhost";
			blogInfo.Subfolder = "MyBlog";

			HttpContext.Current.Items.Add("BlogInfo-", blogInfo);
			UrlFormats formats = new UrlFormats(Config.CurrentBlog.RootUrl);
			Entry entry = new Entry(PostType.BlogPost);
			entry.DateCreated = DateTime.Parse("January 23, 1975");
			entry.EntryID = 123;
			Assert.AreEqual("/MyBlog/archive/1975/01/23/123.aspx", formats.EntryUrl(entry));
		}

		/// <summary>
		/// Makes sure an entry url with no application is formatted correctly.
		/// </summary>
		[Test]
		public void EntryArchiveUrlWithApplicationAndVirtualDir()
		{
			UnitTestHelper.SetHttpContextWithBlogRequest("localhost", "MyBlog", "Subtext.Web");
			BlogInfo blogInfo = new BlogInfo();
			blogInfo.Host = "localhost";
			blogInfo.Subfolder = "MyBlog";

			HttpContext.Current.Items.Add("BlogInfo-", blogInfo);
			UrlFormats formats = new UrlFormats(Config.CurrentBlog.RootUrl);
			Entry entry = new Entry(PostType.BlogPost);
			entry.DateCreated = DateTime.Parse("January 23, 1975");
			entry.EntryID = 123;
			Assert.AreEqual("/Subtext.Web/MyBlog/archive/1975/01/23/123.aspx", formats.EntryUrl(entry));
		}
		/// <summary>
		/// Makes sure that url formatting is culture invariant.
		/// </summary>
		[Test]
		[RollBack]
		public void FormattingEntryUrlIsCultureInvariant()
		{
			Entry entry = new Entry(PostType.BlogPost);
			entry.EntryID = 123;
			entry.DateCreated = DateTime.Parse("2006/01/23");
			entry.EntryName = "test";

			UrlFormats formats = new UrlFormats("http://localhost/");
			string url = formats.EntryUrl(entry);
			Assert.AreEqual("/Subtext.Web/MyBlog/archive/2006/01/23/test.aspx", url, "Expected a normally formatted url.");

			Thread.CurrentThread.CurrentCulture = CultureInfo.CreateSpecificCulture("tr");
			url = formats.EntryUrl(entry);
			Assert.AreEqual("/Subtext.Web/MyBlog/archive/2006/01/23/test.aspx", url, "Expected a normally formatted url.");
			Assert.AreEqual("/Subtext.Web/MyBlog/archive/2006/01/23/test.aspx#123", formats.CommentUrl(entry), "Expected a normally formatted url.");
			Assert.AreEqual("/Subtext.Web/MyBlog/archive/2006/01.aspx", formats.MonthUrl(entry.DateCreated), "Expected a normally formatted url.");
		}

		/// <summary>
		/// Makes sure the method GetEditLink distringuishes between a post and article.
		/// </summary>
		[Test]
		[RollBack]
		public void GetEditLinkDistringuishesBetweenPostAndArticle()
		{
			UnitTestHelper.SetHttpContextWithBlogRequest(_hostName, "");
			Assert.IsTrue(Config.CreateBlog("", "username", "password", _hostName, string.Empty));

			Entry postEntry = new Entry(PostType.BlogPost);
			postEntry.EntryID = 123;

			string editPostUrl = UrlFormats.GetEditLink(postEntry);
			Assert.AreEqual("~/Admin/EditPosts.aspx?PostID=123", editPostUrl, "Expected blog post to go to EditPosts.aspx");

			Entry articleEntry = new Entry(PostType.Story);
			articleEntry.EntryID = 456;
			string editArticleUrl = UrlFormats.GetEditLink(articleEntry);
			Assert.AreEqual("~/Admin/EditArticles.aspx?PostID=456", editArticleUrl, "Expected blog post to go to EditPosts.aspx");
		}

		[Test]
		[RollBack]
		public void GetBlogNameReturnsBlogNameForEmptyVirtualDir()
		{
			UnitTestHelper.SetHttpContextWithBlogRequest(_hostName, "MyBlog", "");
			Console.WriteLine("HttpContext.Current.Request.ApplicationPath: " + HttpContext.Current.Request.ApplicationPath);
			string blogName = UrlFormats.GetBlogSubfolderFromRequest(HttpContext.Current.Request.RawUrl, HttpContext.Current.Request.ApplicationPath);
			Assert.AreEqual("MyBlog", blogName, "Wasn't able to parse request properly.");
		}

		[Test]
		[RollBack]
		public void GetBlogNameReturnsBlogNameForNonEmptyVirtualDir()
		{
			UnitTestHelper.SetHttpContextWithBlogRequest(_hostName, "MyBlog2", "Subtext.Web");
			Console.WriteLine("HttpContext.Current.Request.ApplicationPath: " + HttpContext.Current.Request.ApplicationPath);
			string blogName = UrlFormats.GetBlogSubfolderFromRequest(HttpContext.Current.Request.RawUrl, HttpContext.Current.Request.ApplicationPath);
			Assert.AreEqual("MyBlog2", blogName, "Wasn't able to parse request properly.");
		}

		[SetUp]
		public void SetUp()
		{
			_hostName = UnitTestHelper.GenerateRandomHostname();
			
		}

		[TearDown]
		public void TearDown()
		{
		}
	}
}
