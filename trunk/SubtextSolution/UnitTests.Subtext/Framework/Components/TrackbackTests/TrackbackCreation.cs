using System;
using System.Collections.Generic;
using Subtext.Extensibility;
using Subtext.Framework;
using Subtext.Framework.Components;
using MbUnit.Framework;
using Subtext.Framework.Configuration;

namespace UnitTests.Subtext.Framework.Components.TrackbackTests
{
	/// <summary>
	/// Summary description for TrackbackCreation.
	/// </summary>
	[TestFixture]
	public class TrackbackCreation
	{
		/// <summary>
		/// We had a problem in which creating a trackback in the database did 
		/// not set the PostConfig bitmask column correctly.  Thus we could not 
		/// select out the trackbacks.
		/// </summary>
		[Test]
		[RollBack]
		public void CreateTrackbackSetsPostConfigCorrectly()
		{
			string hostname = UnitTestHelper.GenerateRandomHostname();
			Assert.IsTrue(Config.CreateBlog("", "username", "password", hostname, string.Empty));
			UnitTestHelper.SetHttpContextWithBlogRequest(hostname, string.Empty, string.Empty);
			
			Entry entry = UnitTestHelper.CreateEntryInstanceForSyndication("phil", "title", "body");
			int parentId = Entries.Create(entry);
			
			Trackback trackback = new Trackback(parentId, "title", "titleUrl", "phil", "body");
			int id = Entries.Create(trackback);
			
			Entry loadedTrackback = Entries.GetEntry(id, PostConfig.IsActive, false);
			Assert.IsNotNull(loadedTrackback, "Was not able to load trackback from storage.");
			Assert.IsTrue(loadedTrackback.IsActive, "This item is active");
			Assert.IsTrue(loadedTrackback.PostConfig > 0, "PostConfig was 0");

            Entry activeTrackback = Entries.GetEntry(id, PostConfig.IsActive, false);
			Assert.IsNotNull(activeTrackback, "The trackback was not active.");
		}
		
		/// <summary>
		/// Make sure that trackbacks show up when displaying feedback for an entry.
		/// </summary>
		[Test]
		[RollBack]
		public void TrackbackShowsUpInFeedbackList()
		{
			string hostname = UnitTestHelper.GenerateRandomHostname();
			Assert.IsTrue(Config.CreateBlog("", "username", "password", hostname, "blog"));
			UnitTestHelper.SetHttpContextWithBlogRequest(hostname, "blog", string.Empty);
			
			Entry parentEntry = UnitTestHelper.CreateEntryInstanceForSyndication("philsath aeuoa asoeuhtoensth", "sntoehu title aoeuao eu", "snaot hu aensaoehtu body");
			int parentId = Entries.Create(parentEntry);

            IList<Entry> entries = Entries.GetFeedBack(parentEntry);
			Assert.AreEqual(0, entries.Count, "Did not expect any feedback yet.");
			
			Trackback trackback = new Trackback(parentId, "title", "titleUrl", "phil", "body");
			Config.CurrentBlog.DuplicateCommentsEnabled = true;
			int trackbackId = Entries.Create(trackback);
			
			entries = Entries.GetFeedBack(parentEntry);
			Assert.AreEqual(1, entries.Count, "Expected a trackback.");
			Assert.AreEqual(trackbackId, entries[0].Id, "The feedback was not the same one we expected. The IDs do not match.");
		}
	}
}
