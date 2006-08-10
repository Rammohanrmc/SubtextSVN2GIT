using System;
using System.Globalization;
using MbUnit.Framework;
using Subtext.Extensibility;
using Subtext.Framework;
using Subtext.Framework.Components;
using Subtext.Framework.Configuration;
using Subtext.Framework.XmlRpc;

namespace UnitTests.Subtext.Framework.XmlRpc
{
    [TestFixture]
    public class MetaBlogApiTests
    {
		[Test]
		[RollBack]
		public void NewPostWithCategoryCreatesEntryWithCategory()
		{
			string hostname = UnitTestHelper.GenerateRandomString();
			Assert.IsTrue(Config.CreateBlog("", "username", "password", hostname, ""));
			UnitTestHelper.SetHttpContextWithBlogRequest(hostname, "");
			Config.CurrentBlog.AllowServiceAccess = true;

			LinkCategory category = new LinkCategory();
			category.IsActive = true;
			category.Description = "Test category";
			category.Title = "CategoryA";
			Links.CreateLinkCategory(category);
			
			MetaWeblog api = new MetaWeblog();
			Post post = new Post();
			post.categories = new string[] {"CategoryA"};
			post.description = "A unit test";
			post.title = "A unit testing title";
			post.dateCreated = DateTime.Now;

			string result = api.newPost(Config.CurrentBlog.Id.ToString(CultureInfo.InvariantCulture), "username", "password", post, true);
			int entryId = int.Parse(result);

			Entry entry = Entries.GetEntry(entryId, PostConfig.None, true);
			Assert.IsNotNull(entry, "Guess the entry did not get created properly.");
			Assert.AreEqual(1, entry.Categories.Count, "We expected one category. We didn't get what we expected.");
			Assert.AreEqual("CategoryA", entry.Categories[0], "The wrong category was created.");
		}
    	
    	[Test]
    	[RollBack]
    	public void NewPostAcceptsNullCategories()
    	{
			string hostname = UnitTestHelper.GenerateRandomString();
			Assert.IsTrue(Config.CreateBlog("", "username", "password", hostname, ""));
			UnitTestHelper.SetHttpContextWithBlogRequest(hostname, "");
			Config.CurrentBlog.AllowServiceAccess = true;

			MetaWeblog api = new MetaWeblog();
			Post post = new Post();
    		post.categories = null;
			post.description = "A unit test";
			post.title = "A unit testing title";
    		post.dateCreated = DateTime.Now;
    		
    		string result = api.newPost(Config.CurrentBlog.Id.ToString(CultureInfo.InvariantCulture), "username", "password", post, true);
			int.Parse(result);
    	}
    	
        [Test]
        [RollBack]
        public void GetRecentPostsReturnsRecentPosts()
        {
            string hostname = UnitTestHelper.GenerateRandomString();
			Assert.IsTrue(Config.CreateBlog("", "username", "password", hostname, ""));
            UnitTestHelper.SetHttpContextWithBlogRequest(hostname, "");
            Config.CurrentBlog.AllowServiceAccess = true;

            MetaWeblog api = new MetaWeblog();
            Post[] posts = api.getRecentPosts(Config.CurrentBlog.Id.ToString(), "username", "password", 10);
            Assert.AreEqual(0, posts.Length);

            string category1Name = UnitTestHelper.GenerateRandomString();
            string category2Name = UnitTestHelper.GenerateRandomString();
            int categoryId = UnitTestHelper.CreateCategory(Config.CurrentBlog.Id, category1Name);
            int categoryId2 = UnitTestHelper.CreateCategory(Config.CurrentBlog.Id, category2Name);
            
            Entry entry = new Entry(PostType.BlogPost);
            entry.Title = "Title 1";
            entry.Body = "Blah";
            entry.IsActive = true;
            entry.DateCreated = entry.DateSyndicated = entry.DateUpdated = DateTime.ParseExact("1975/01/23", "yyyy/MM/dd", CultureInfo.InvariantCulture);
            Entries.Create(entry, categoryId);

            entry = new Entry(PostType.BlogPost);
            entry.Title = "Title 2";
            entry.Body = "Blah1";
            entry.IsActive = true;
            entry.DateCreated = entry.DateSyndicated = entry.DateUpdated = DateTime.ParseExact("1976/05/25", "yyyy/MM/dd", CultureInfo.InvariantCulture);
            Entries.Create(entry, categoryId, categoryId2);

            entry = new Entry(PostType.BlogPost);
            entry.Title = "Title 3";
            entry.Body = "Blah2";
            entry.IsActive = true;
            entry.DateCreated = entry.DateSyndicated = entry.DateUpdated = DateTime.ParseExact("1979/09/16", "yyyy/MM/dd", CultureInfo.InvariantCulture);
            Entries.Create(entry);

            entry = new Entry(PostType.BlogPost);
            entry.Title = "Title 4";
            entry.Body = "Blah3";
            entry.IsActive = true;
            entry.DateCreated = entry.DateSyndicated = entry.DateUpdated = DateTime.ParseExact("2006/01/01", "yyyy/MM/dd", CultureInfo.InvariantCulture);
            Entries.Create(entry, categoryId2);

            posts = api.getRecentPosts(Config.CurrentBlog.Id.ToString(), "username", "password", 10);
            Assert.AreEqual(4, posts.Length, "Expected 4 posts");
            Assert.AreEqual(1, posts[3].categories.Length, "Expected our categories to be there.");
            Assert.AreEqual(2, posts[2].categories.Length, "Expected our categories to be there.");
            Assert.IsNull(posts[1].categories, "Expected our categories to be there.");
            Assert.AreEqual(1, posts[0].categories.Length, "Expected our categories to be there.");
            Assert.AreEqual(category1Name, posts[3].categories[0], "The category returned by the MetaBlogApi is wrong.");
            Assert.AreEqual(category2Name, posts[0].categories[0], "The category returned by the MetaBlogApi is wrong.");
        }
    }
}
