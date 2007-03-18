using System;
using MbUnit.Framework;
using Subtext.Framework;
using Subtext.Framework.Components;
using Subtext.Framework.Configuration;
using Subtext.Framework.Data;

namespace UnitTests.Subtext.SubtextWeb.Controls
{
	[TestFixture]
	public class CacherTests
	{
		/// <summary>
		/// This test is to make sure a bug I introduced never happens again.
		/// </summary>
		[Test]
		[RollBack]
		public void GetEntryFromRequestDoesNotThrowNullReferenceException()
		{
			string host = UnitTestHelper.GenerateRandomString();
			Config.CreateBlog("test", UnitTestHelper.GenerateRandomString(), UnitTestHelper.GenerateRandomString(), host, "");
			UnitTestHelper.SetHttpContextWithBlogRequest(host, "", "", "/archive/999999.aspx");
			Assert.IsNull(Cacher.GetEntryFromRequest(CacheDuration.Short));
		}

		[Test]
		[ExpectedException(typeof(InvalidOperationException))]
		public void SingleCategoryThrowsExceptionIfContextNull()
		{
			Cacher.SingleCategory(CacheDuration.Short);
		}

		[Test]
		[RollBack]
		public void SingleCategoryReturnsNullForNonExistentCategory()
		{
			string host = UnitTestHelper.GenerateRandomString();
			Config.CreateBlog("test", UnitTestHelper.GenerateRandomString(), UnitTestHelper.GenerateRandomString(), host, "");
			UnitTestHelper.SetHttpContextWithBlogRequest(host, "", "", "/category/99.aspx");
			Assert.IsNull(Cacher.SingleCategory(CacheDuration.Short));
		}

		[Test]
		[RollBack]
		public void CanGetCategoryByIdRequest()
		{
			string host = UnitTestHelper.GenerateRandomString();		
			Config.CreateBlog("test", UnitTestHelper.GenerateRandomString(), UnitTestHelper.GenerateRandomString(), host, "");
			UnitTestHelper.SetHttpContextWithBlogRequest(host, "", "", "/category/");
			int categoryId = UnitTestHelper.CreateCategory(Config.CurrentBlog.Id, "This Is a Test");
			UnitTestHelper.SetHttpContextWithBlogRequest(host, "", "", "/category/" + categoryId + ".aspx");

			LinkCategory category = Cacher.SingleCategory(CacheDuration.Short);
			Assert.AreEqual("This Is a Test", category.Title);
		}

		[Test]
		[RollBack]
		public void CanGetCategoryByNameRequest()
		{
			string host = UnitTestHelper.GenerateRandomString();
			Config.CreateBlog("test", UnitTestHelper.GenerateRandomString(), UnitTestHelper.GenerateRandomString(), host, "");
			UnitTestHelper.SetHttpContextWithBlogRequest(host, "", "", "/category/This Is a Test.aspx");
			UnitTestHelper.CreateCategory(Config.CurrentBlog.Id, "This Is a Test");

			LinkCategory category = Cacher.SingleCategory(CacheDuration.Short);
			Assert.AreEqual("This Is a Test", category.Title);
		}

		[Test]
		[RollBack]
		public void CanGetCategoryByNameWithWordDelimitersRequest()
		{
			string host = UnitTestHelper.GenerateRandomString();
			Config.CreateBlog("test", UnitTestHelper.GenerateRandomString(), UnitTestHelper.GenerateRandomString(), host, "");
			UnitTestHelper.SetHttpContextWithBlogRequest(host, "", "", "/category/This_Is_a_Test.aspx");
			UnitTestHelper.CreateCategory(Config.CurrentBlog.Id, "This Is a Test");

			LinkCategory category = Cacher.SingleCategory(CacheDuration.Short);
			Assert.AreEqual("This Is a Test", category.Title);
		}
	}
}
