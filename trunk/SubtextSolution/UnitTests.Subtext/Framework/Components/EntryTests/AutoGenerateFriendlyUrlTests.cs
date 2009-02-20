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
using Subtext.Configuration;
using Subtext.Extensibility;
using Subtext.Framework;
using Subtext.Framework.Components;
using Subtext.Framework.Configuration;
using System.Threading;
using Subtext.Framework.Web.HttpModules;

namespace UnitTests.Subtext.Framework.Components.EntryTests
{
	/// <summary>
	/// Tests the feature to auto generate the EntryName property 
	/// of an entry. This serves as a friendly url.
	/// </summary>
	[TestFixture]
	public class AutoGenerateFriendlyUrlTests
	{
		string _hostName = string.Empty;

        /// <summary>
        /// Make sure that generated friendly urls are not changed when updating entry.
        /// </summary>
        [Test]
        [RollBack]
        public void FriendlyUrlIsUniqueInUpdates()
        {
            //arrange
            string hostName = UnitTestHelper.GenerateUniqueHostname();
            Config.CreateBlog("", "username", "password", hostName, string.Empty);
            UnitTestHelper.SetHttpContextWithBlogRequest(hostName, "");
            BlogRequest.Current.Blog = Config.GetBlog(hostName, string.Empty);
            Config.CurrentBlog.AutoFriendlyUrlEnabled = true;

            Entry entry1 = new Entry(PostType.BlogPost);
            entry1.DateCreated = DateTime.Now;
            entry1.Title = "Random Title";
            entry1.Body = "Some Body";
            int id1 = UnitTestHelper.Create(entry1);

            Entry savedEntry1 = Entries.GetEntry(id1, PostConfig.None, false);
            Assert.AreEqual("Random_Title", savedEntry1.EntryName, "The EntryName should have been auto-friendlied.");

            Entry entry2 = new Entry(PostType.BlogPost);
            entry2.DateCreated = DateTime.Now;
            entry2.Title = "Other Random Title";
            entry2.Body = "Some Body";
            int id2 = UnitTestHelper.Create(entry2);

            Entry savedEntry2 = Entries.GetEntry(id2, PostConfig.None, false);
            Assert.AreEqual("Other_Random_Title", savedEntry2.EntryName, "The EntryName should have been auto-friendlied.");

            // act
            savedEntry2.EntryName = "New_Changed_Random_Title";
            Entries.Update(savedEntry2);
            //When running *all* tests, this test fails. Not sure why. 
            //Going to throw in a sleep just to see if it's a timing issue.
            Assert.AreEqual("New_Changed_Random_Title", savedEntry2.EntryName);
            Thread.Sleep(100);

            // assert
            Entry updatedEntry = Entries.GetEntry(id2, PostConfig.None, false);
            Assert.AreEqual("New_Changed_Random_Title", updatedEntry.EntryName, "Able to change the entry and retrieve it.");
        }

		/// <summary>
		/// Make sure that generated friendly urls are not changed when updating entry.
		/// </summary>
		[Test]
		[RollBack]
		public void FriendlyUrlIsNotChangedInUpdates() 
		{
            string hostname = UnitTestHelper.GenerateUniqueHostname();
            Config.CreateBlog("", "username", "password", hostname, string.Empty);
            UnitTestHelper.SetHttpContextWithBlogRequest(hostname, "");
            BlogRequest.Current.Blog = Config.GetBlog(hostname, string.Empty);
			Config.CurrentBlog.AutoFriendlyUrlEnabled = true;

			Entry entry = new Entry(PostType.BlogPost);
			entry.DateCreated = DateTime.Now;
			entry.Title = "Some Title";
			entry.Body = "Some Body";
			int id = UnitTestHelper.Create(entry);

			Entry savedEntry = Entries.GetEntry(id, PostConfig.None, false);
			Assert.AreEqual("Some_Title", savedEntry.EntryName, "The EntryName should have been auto-friendlied.");

			Entries.Update(savedEntry);

			Entry updatedEntry = Entries.GetEntry(id, PostConfig.None, false);
			Assert.AreEqual("Some_Title", updatedEntry.EntryName, "The EntryName should not have been re-auto-friendlied.");
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
			_hostName = UnitTestHelper.GenerateUniqueHostname();
			UnitTestHelper.SetHttpContextWithBlogRequest(_hostName, "");
		}

		[TearDown]
		public void TearDown()
		{
			Config.ConfigurationProvider = null;
		}
	}
}