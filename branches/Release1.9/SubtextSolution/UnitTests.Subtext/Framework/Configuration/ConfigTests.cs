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
using MbUnit.Framework;
using Subtext.Framework;
using Subtext.Framework.Configuration;
using Subtext.Framework.Web.HttpModules;

namespace UnitTests.Subtext.Framework.Configuration
{
    /// <summary>
    /// These are unit tests specifically for the Config class.
    /// </summary>
    [TestFixture]
    public class ConfigTests
    {
        string hostName;

		/// <summary>
		/// This test makes sure we deal gracefully with a common deployment problem. 
		/// A user sets up the blog on his/her local machine (aka "localhost"), then 
		/// deploys the database to their production server. The hostname in the db 
		/// should be changed to the new domain.
		/// </summary>
		[Test]
		[RollBack2]
		public void GetBlogInfoChangesHostForOnlyLocalHostBlog()
		{
			string subfolder = UnitTestHelper.GenerateRandomString();
			Config.CreateBlog("title", "username", "password", "localhost", subfolder);
			Assert.AreEqual(1, BlogInfo.GetBlogs(0, 10, ConfigurationFlag.None).Count, "Need to make sure there's only one blog in the system.");

			BlogRequest.Current = new BlogRequest("example.com", subfolder, new Uri("http://example.com/"), false);
			BlogInfo info = UrlBasedBlogInfoProvider.Instance.GetBlogInfo();
			Assert.IsNotNull(info, "Expected to find a blog.");
			Assert.AreEqual(subfolder, info.Subfolder, "The subfolder has not changed.");
			Assert.AreEqual("example.com", info.Host, "The host should have changed.");
		}

		[Test]
		[RollBack2]
		public void GetBlogInfoFindsBlogIfItIsOnlyBlogInSystem()
		{
			string subfolder = UnitTestHelper.GenerateRandomString();
			Config.CreateBlog("title", "username", "password", hostName, subfolder);
			Assert.AreEqual(1, BlogInfo.GetBlogs(0, 10, ConfigurationFlag.None).Count, "Need to make sure there's only one blog in the system.");

			BlogInfo info = Config.GetBlogInfo("anything", string.Empty);
			Assert.IsNotNull(info, "Expected to find a blog.");
			Assert.AreEqual(subfolder, info.Subfolder, "The subfolder should not have changed.");
			Assert.AreEqual(hostName, info.Host, "The hostName should not have changed.");
		}

		/// <summary>
        /// If we have two or more blogs in the system we want to be sure that 
        /// we can find a blog if it has a unique HostName in the system, despite 
        /// what it's subfolder is.
        /// </summary>
        /// <remarks>
        /// Basically, we need to be able support the following setup:
        /// Blog1 has a HostName "mydomain.com" and any (or no) subfolder name.
        /// Blog2 has a HostName "example.com" and any (or no) subfolder name.
        /// 
        /// When a request comes in for "http://mydomain.com/" we want to make sure 
        /// that we find Blog1 because it is the ONLY blog in the system with the 
        /// hostName "mydomain.com".
        /// </remarks>
        [Test]
        [RollBack2]
        public void GetBlogInfoFindsBlogWithUniqueHostName()
        {
            string anotherHost = UnitTestHelper.GenerateRandomString();
            string subfolder = UnitTestHelper.GenerateRandomString();
            Config.CreateBlog("title", "username", "password", hostName, subfolder);
            Config.CreateBlog("title", "username", "password", anotherHost, string.Empty);

            BlogInfo info = Config.GetBlogInfo(hostName, string.Empty);
            Assert.IsNotNull(info, "Could not find the blog with the unique hostName.");
            Assert.AreEqual(info.Host, hostName, "Oops! Looks like we found the wrong Blog!");
            Assert.AreEqual(info.Subfolder, subfolder, "Oops! Looks like we found the wrong Blog!");
        }
        
        /// <summary>
        /// Make sure we can correctly find a blog based on it's HostName and
        /// subfolder when the system has multiple blogs with the same Host.
        /// </summary>
        [Test]
        [RollBack2]
        public void GetBlogInfoFindsBlogWithUniqueHostAndSubfolder()
        {
            string subfolder1 = UnitTestHelper.GenerateRandomString();
            string subfolder2 = UnitTestHelper.GenerateRandomString();
            Config.CreateBlog("title", "username", "password", hostName, subfolder1);
            Config.CreateBlog("title", "username", "password", hostName, subfolder2);

            BlogInfo info = Config.GetBlogInfo(hostName, subfolder1);
            Assert.IsNotNull(info, "Could not find the blog with the unique hostName & subfolder combination.");
            Assert.AreEqual(info.Subfolder, subfolder1, "Oops! Looks like we found the wrong Blog!");

            info = Config.GetBlogInfo(hostName, subfolder2);
            Assert.IsNotNull(info, "Could not find the blog with the unique hostName & subfolder combination.");
            Assert.AreEqual(info.Subfolder, subfolder2, "Oops! Looks like we found the wrong Blog!");
        }
        
		[Test]
        [RollBack2]
        public void GetBlogInfoDoesNotFindBlogWithWrongSubfolderInMultiBlogSystem()
        {
            string subfolder1 = UnitTestHelper.GenerateRandomString();
            string subfolder2 = UnitTestHelper.GenerateRandomString();
            Config.CreateBlog("title", "username", "password", hostName, subfolder1);
            Config.CreateBlog("title", "username", "password", hostName, subfolder2);

            BlogInfo info = Config.GetBlogInfo(hostName, string.Empty);
            Assert.IsNull(info, "Hmm... Looks like found a blog using too generic of search criteria.");
        }
        
        /// <summary>
        /// Sets the up test fixture.  This is called once for 
        /// this test fixture before all the tests run.
        /// </summary>
        [TestFixtureSetUp]
        public void SetUpTestFixture()
        {
            //Confirm app settings
            UnitTestHelper.AssertAppSettings();
        }

        [SetUp]
        public void SetUp()
        {
            hostName = UnitTestHelper.GenerateRandomString();
            UnitTestHelper.SetHttpContextWithBlogRequest(hostName, "MyBlog");
        }
    }
}
