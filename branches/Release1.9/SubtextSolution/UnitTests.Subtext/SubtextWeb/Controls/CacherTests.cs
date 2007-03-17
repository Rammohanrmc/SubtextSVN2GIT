using System;
using MbUnit.Framework;
using Subtext.Framework;
using Subtext.Framework.Configuration;
using Subtext.Framework.Data;

namespace UnitTests.Subtext.SubtextWeb.Controls
{
	[TestFixture]
	public class CacherTests
	{
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
	}
}
