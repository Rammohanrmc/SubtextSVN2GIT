using System;
using MbUnit.Framework;
using Subtext.Framework;
using Subtext.Framework.Configuration;

namespace UnitTests.Subtext.Framework
{
	/// <summary>
	/// Tests of the <see cref="BlogInfo"/> class.
	/// </summary>
	[TestFixture]
	public class BlogInfoTests
	{
		[RowTest]
		[Row("", "", "/")]
		[Row("", "/", "/")]
		[Row("Blog", "", "/Blog/")]
		[Row("Blog", "Subtext.Web", "/Subtext.Web/Blog/")]
		[Row("Blog", "Subtext.Web/AnotherFolder", "/Subtext.Web/AnotherFolder/Blog/")]
		[Row("Blog", "/Subtext.Web/AnotherFolder/", "/Subtext.Web/AnotherFolder/Blog/")]
		[Row("", "Subtext.Web/", "/Subtext.Web/")]
		[Row("", "/Subtext.Web/", "/Subtext.Web/")]
		[Row("", "Subtext.Web", "/Subtext.Web/")]
		[RollBack]
		public void TestVirtualUrlPropertySetCorrectly(string subfolder, string virtualDir, string expected)
		{
			string host = UnitTestHelper.GenerateRandomHostname();
			UnitTestHelper.SetHttpContextWithBlogRequest(host, subfolder, virtualDir);
			Assert.IsTrue(Config.CreateBlog("TestVirtualUrlPropertySetCorrectly", "username", "password", host, subfolder));
			Console.WriteLine("TEST: Subfolder: " + subfolder);
			Console.WriteLine("TEST: VirtualDir: " + virtualDir);
			Console.WriteLine("TEST: expected: " + expected);
			Assert.AreEqual(expected, Config.CurrentBlog.VirtualUrl, "Did not set the Virtual Dir correctly.");
		}

		[RowTest]
		[Row("", "", "/Admin/")]
		[Row("", "/", "/Admin/")]
		[Row("Blog", "", "/Blog/Admin/")]
		[Row("Blog", "Subtext.Web", "/Subtext.Web/Blog/Admin/")]
		[Row("Blog", "Subtext.Web/AnotherFolder", "/Subtext.Web/AnotherFolder/Blog/Admin/")]
		[Row("Blog", "/Subtext.Web/AnotherFolder/", "/Subtext.Web/AnotherFolder/Blog/Admin/")]
		[Row("", "Subtext.Web/", "/Subtext.Web/Admin/")]
		[Row("", "/Subtext.Web/", "/Subtext.Web/Admin/")]
		[Row("", "Subtext.Web", "/Subtext.Web/Admin/")]
		[RollBack]
		public void TestAdminDirectoryVirtualUrlPropertySetCorrectly(string subfolder, string virtualDir, string expected)
		{
			string host = UnitTestHelper.GenerateRandomHostname();
			UnitTestHelper.SetHttpContextWithBlogRequest(host, subfolder, virtualDir);
			Assert.IsTrue(Config.CreateBlog("TestVirtualUrlPropertySetCorrectly", "username", "password", host, subfolder));
			Assert.AreEqual(expected, Config.CurrentBlog.AdminDirectoryVirtualUrl, "Did not set the Admin Virtual Dir correctly.");
		}
		
		[RowTest]
		[Row("", "", "/Admin/Default.aspx")]
		[Row("", "/", "/Admin/Default.aspx")]
		[Row("Blog", "", "/Blog/Admin/Default.aspx")]
		[Row("Blog", "Subtext.Web", "/Subtext.Web/Blog/Admin/Default.aspx")]
		[Row("Blog", "Subtext.Web/AnotherFolder", "/Subtext.Web/AnotherFolder/Blog/Admin/Default.aspx")]
		[Row("Blog", "/Subtext.Web/AnotherFolder/", "/Subtext.Web/AnotherFolder/Blog/Admin/Default.aspx")]
		[Row("", "Subtext.Web/", "/Subtext.Web/Admin/Default.aspx")]
		[Row("", "/Subtext.Web/", "/Subtext.Web/Admin/Default.aspx")]
		[Row("", "Subtext.Web", "/Subtext.Web/Admin/Default.aspx")]
		[RollBack]
		public void TestAdminVirtualUrlPropertySetCorrectly(string subfolder, string virtualDir, string expected)
		{
			string host = UnitTestHelper.GenerateRandomHostname();
			UnitTestHelper.SetHttpContextWithBlogRequest(host, subfolder, virtualDir);
			Assert.IsTrue(Config.CreateBlog("TestVirtualUrlPropertySetCorrectly", "username", "password", host, subfolder));
			Assert.AreEqual(expected, Config.CurrentBlog.AdminHomeVirtualUrl, "Did not set the Admin Virtual Dir correctly.");
		}

		[RowTest]
		[Row("", "Subtext.Web", "Subtext.Web/")]
		[Row("", "", "")]
		[Row("Blog", "", "Blog/")]
		[Row("Blog", "Subtext.Web", "Subtext.Web/Blog/")]
		[RollBack]
		public void TestRootUrlPropertySetCorrectly(string subfolder, string virtualDir, string expected)
		{
			string host = UnitTestHelper.GenerateRandomHostname();
			string expectedUrl = string.Format("http://{0}/{1}", host, expected);
			
			UnitTestHelper.SetHttpContextWithBlogRequest(host, subfolder, virtualDir);
			Assert.IsTrue(Config.CreateBlog("TestRootUrlPropertySetCorrectly", "username", "password", host, subfolder));

			Assert.AreEqual(expectedUrl, Config.CurrentBlog.RootUrl, "Did not set the Virtual Dir correctly.");
		}

		[RowTest]
		[Row("", "", "Default.aspx")]
		[Row("Blog", "", "Blog/Default.aspx")]
		[Row("Blog", "Subtext.Web", "Subtext.Web/Blog/Default.aspx")]
		[Row("", "Subtext.Web", "Subtext.Web/Default.aspx")]
		[RollBack]
		public void TestBlogHomeFullyQualifiedUrlPropertySetCorrectly(string subfolder, string virtualDir, string expected)
		{
			string host = UnitTestHelper.GenerateRandomHostname();
			string expectedUrl = string.Format("http://{0}/{1}", host, expected);
			
			Assert.IsTrue(Config.CreateBlog("TestBlogHomeUrlPropertySetCorrectly", "username", "password", host, subfolder));
			UnitTestHelper.SetHttpContextWithBlogRequest(host, subfolder, virtualDir);

			Assert.AreEqual(expectedUrl, Config.CurrentBlog.HomeFullyQualifiedUrl, "Did not set the BlogHomeUrl correctly.");
		}

		[RowTest]
		[Row("", "", "/Default.aspx")]
		[Row("Blog", "", "/Blog/Default.aspx")]
		[Row("Blog", "Subtext.Web", "/Subtext.Web/Blog/Default.aspx")]
		[Row("", "Subtext.Web", "/Subtext.Web/Default.aspx")]
		[RollBack]
		public void TestBlogHomeVirtualUrlPropertySetCorrectly(string subfolder, string virtualDir, string expected)
		{
			string host = UnitTestHelper.GenerateRandomHostname();
			Assert.IsTrue(Config.CreateBlog("TestBlogHomeVirtualUrlPropertySetCorrectly", "username", "password", host, subfolder));
			UnitTestHelper.SetHttpContextWithBlogRequest(host, subfolder, virtualDir);

			Assert.AreEqual(expected, Config.CurrentBlog.HomeVirtualUrl, "Did not set the BlogHomeVirtualUrl correctly.");
		}

		/// <summary>
		/// Tests the virtual directory root property set correctly.
		/// </summary>
		/// <param name="subfolder">The subfolder.</param>
		/// <param name="virtualDir">The virtual dir.</param>
		/// <param name="expected">The expected.</param>
		[RowTest]
		[Row("", "", "/")]
		[Row("Blog", "", "/")]
		[Row("Blog", "Subtext.Web", "/Subtext.Web/")]
		[Row("", "Subtext.Web", "/Subtext.Web/")]
		[RollBack]
		public void TestVirtualDirectoryRootPropertySetCorrectly(string subfolder, string virtualDir, string expected)
		{
			string host = UnitTestHelper.GenerateRandomHostname();
			UnitTestHelper.SetHttpContextWithBlogRequest(host, subfolder, virtualDir);
			Assert.IsTrue(Config.CreateBlog("TestVirtualDirectoryRootPropertySetCorrectly", "username", "password", host, subfolder));

			Assert.AreEqual(expected, Config.CurrentBlog.VirtualDirectoryRoot, "Did not set the VirtualDirectoryRoot correctly.");
		}
	}
}
