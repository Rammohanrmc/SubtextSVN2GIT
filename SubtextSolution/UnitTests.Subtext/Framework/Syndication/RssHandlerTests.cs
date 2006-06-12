using System;
using System.IO;
using System.Reflection;
using System.Text;
using System.Threading;
using System.Web;
using System.Xml;
using MbUnit.Framework;
using Subtext.Common.Syndication;
using Subtext.Framework;
using Subtext.Framework.Components;
using Subtext.Framework.Configuration;

namespace UnitTests.Subtext.Framework.Syndication
{
	/// <summary>
	/// Tests of the RssHandler http handler class.
	/// </summary>
	[TestFixture]
	public class RssHandlerTests
	{
		/// <summary>
		/// Tests writing a simple RSS feed from some database entries.
		/// </summary>
		[Test]
		[RollBack]
		public void RssWriterProducesValidFeedFromDatabase()
		{
			string hostName = System.Guid.NewGuid().ToString().Replace("-", "") + ".com";
			Assert.IsTrue(Config.CreateBlog("Test", "username", "password", hostName, string.Empty));

			StringBuilder sb = new StringBuilder();
			TextWriter output = new StringWriter(sb);
			UnitTestHelper.SetHttpContextWithBlogRequest(hostName, "", "", "", output);

			Config.CurrentBlog.Email = "Subtext@example.com";
			Config.CurrentBlog.RFC3229DeltaEncodingEnabled = false;

			DateTime dateCreated = DateTime.Now;
			Entry entry = UnitTestHelper.CreateEntryInstanceForSyndication("Author", "testtitle", "testbody", null, dateCreated);
			int id = Entries.Create(entry); //persist to db.

			XmlNodeList itemNodes = GetRssHandlerItemNodes(sb);
			Assert.AreEqual(1, itemNodes.Count, "expected one item nodes.");

			string urlFormat = "http://{0}/archive/{1:yyyy/MM/dd}/{2}.aspx";
			string expectedUrl = string.Format(urlFormat, hostName, dateCreated, id);

			Assert.AreEqual("testtitle", itemNodes[0].SelectSingleNode("title").InnerText, "Not what we expected for the title.");
			Assert.AreEqual(expectedUrl, itemNodes[0].SelectSingleNode("link").InnerText, "Not what we expected for the link.");
			Assert.AreEqual(expectedUrl, itemNodes[0].SelectSingleNode("guid").InnerText, "Not what we expected for the link.");
			Assert.AreEqual(expectedUrl + "#feedback", itemNodes[0].SelectSingleNode("comments").InnerText, "Not what we expected for the link.");
		}

		/// <summary>
		/// Tests that a simple regular RSS feed works.
		/// </summary>
		[Test]
		[RollBack]
		public void RssHandlerProducesValidRssFeed()
		{
			string hostName = System.Guid.NewGuid().ToString().Replace("-", "") + ".com";
			StringBuilder sb = new StringBuilder();
			TextWriter output = new StringWriter(sb);
			UnitTestHelper.SetHttpContextWithBlogRequest(hostName, "", "", "", output);
			Assert.IsTrue(Config.CreateBlog("", "username", "password", hostName, string.Empty));

			Entries.Create(UnitTestHelper.CreateEntryInstanceForSyndication("Haacked", "Title Test", "Body Rocking"));
			Thread.Sleep(50);
			Entries.Create(UnitTestHelper.CreateEntryInstanceForSyndication("Haacked", "Title Test 2", "Body Rocking Pt 2"));

			XmlNodeList itemNodes = GetRssHandlerItemNodes(sb);
			Assert.AreEqual(2, itemNodes.Count, "expected two item nodes.");

			Assert.AreEqual("Title Test 2", itemNodes[0].SelectSingleNode("title").InnerText, "Not what we expected for the second title.");
			Assert.AreEqual("Title Test", itemNodes[1].SelectSingleNode("title").InnerText, "Not what we expected for the first title.");
			
			Assert.AreEqual("Body Rocking Pt 2", itemNodes[0].SelectSingleNode("description").InnerText.Substring(0, "Body Rocking pt 2".Length), "Not what we expected for the second body.");
			Assert.AreEqual("Body Rocking", itemNodes[1].SelectSingleNode("description").InnerText.Substring(0, "Body Rocking".Length), "Not what we expected for the first body.");
		}
		
		/// <summary>
		/// Tests that items without a date syndicated are not syndicated.
		/// </summary>
		[Test]
		[RollBack]
		public void RssHandlerHandlesDateSyndicatedProperly()
		{
			// Setup
			string hostName = System.Guid.NewGuid().ToString().Replace("-", "") + ".com";
			StringBuilder sb = new StringBuilder();
			TextWriter output = new StringWriter(sb);
			UnitTestHelper.SetHttpContextWithBlogRequest(hostName, "", "", "", output);
			Assert.IsTrue(Config.CreateBlog("", "username", "password", hostName, string.Empty));

			//Create two entries, but only include one in main syndication.
			Entries.Create(UnitTestHelper.CreateEntryInstanceForSyndication("Haacked", "Title Test", "Body Rocking"));
			int id = Entries.Create(UnitTestHelper.CreateEntryInstanceForSyndication("Haacked", "Title Test 2", "Body Rocking Pt 2"));
			Entry entry = Entries.GetEntry(id, EntryGetOption.All);
			entry.IncludeInMainSyndication = false;
			Entries.Update(entry);
			Assert.AreEqual(NullValue.NullDateTime, entry.DateSyndicated);

			XmlNodeList itemNodes = GetRssHandlerItemNodes(sb);
			Assert.AreEqual(1, itemNodes.Count, "expected one item node.");

			Assert.AreEqual("Title Test", itemNodes[0].SelectSingleNode("title").InnerText, "Not what we expected for the first title.");			
			Assert.AreEqual("Body Rocking", itemNodes[0].SelectSingleNode("description").InnerText.Substring(0, "Body Rocking".Length), "Not what we expected for the first body.");
			
			//Include the second entry back in the syndication.
			entry.IncludeInMainSyndication = true;
			Entries.Update(entry);
			
			sb = new StringBuilder();
			output = new StringWriter(sb);
			UnitTestHelper.SetHttpContextWithBlogRequest(hostName, "", "", "", output);
			itemNodes = GetRssHandlerItemNodes(sb);
			Assert.AreEqual(2, itemNodes.Count, "Expected two items in the feed now.");
		}
		
		/// <summary>
		/// Tests that the RssHandler orders items by DateSyndicated.
		/// </summary>
		[Test]
		[RollBack]
		public void RssHandlerSortsByDateSyndicated()
		{
			// Setup
			string hostName = System.Guid.NewGuid().ToString().Replace("-", "") + ".com";
			StringBuilder sb = new StringBuilder();
			TextWriter output = new StringWriter(sb);
			UnitTestHelper.SetHttpContextWithBlogRequest(hostName, "", "", "", output);
			Assert.IsTrue(Config.CreateBlog("", "username", "password", hostName, string.Empty));

			//Create two entries.
			int firstId = Entries.Create(UnitTestHelper.CreateEntryInstanceForSyndication("Haacked", "Title Test", "Body Rocking"));
			Thread.Sleep(1000);
			Entries.Create(UnitTestHelper.CreateEntryInstanceForSyndication("Haacked", "Title Test 2", "Body Rocking Pt 2"));
			
			XmlNodeList itemNodes = GetRssHandlerItemNodes(sb);
			
			//Expect the first item to be the second entry.
			Assert.AreEqual("Title Test 2", itemNodes[0].SelectSingleNode("title").InnerText, "Not what we expected for the first title.");			
			Assert.AreEqual("Title Test", itemNodes[1].SelectSingleNode("title").InnerText, "Not what we expected for the second title.");			
			
			//Remove first entry from syndication.
			Entry firstEntry = Entries.GetEntry(firstId, EntryGetOption.All);
			firstEntry.IncludeInMainSyndication = false;
			Entries.Update(firstEntry);
			
		    Thread.Sleep(10);
			//Now add it back in.
			firstEntry.IncludeInMainSyndication = true;
			Entries.Update(firstEntry);
			
			sb = new StringBuilder();
			output = new StringWriter(sb);
			UnitTestHelper.SetHttpContextWithBlogRequest(hostName, "", "", "", output);
			itemNodes = GetRssHandlerItemNodes(sb);
			
			//Expect the second item to be the second entry.
			Assert.AreEqual("Title Test", itemNodes[0].SelectSingleNode("title").InnerText, "Not what we expected for the first title.");
			Assert.AreEqual("Title Test 2", itemNodes[1].SelectSingleNode("title").InnerText, "Not what we expected for the second title.");
		}

		private static XmlNodeList GetRssHandlerItemNodes(StringBuilder sb)
		{
			RssHandler handler = new RssHandler();
			handler.ProcessRequest(HttpContext.Current);
			HttpContext.Current.Response.Flush();	
			string rssOutput = sb.ToString();
			XmlDocument doc = new XmlDocument();
			doc.LoadXml(rssOutput);
			return doc.SelectNodes("/rss/channel/item");
		}

		/// <summary>
		/// Tests that sending a Gzip compressed RSS Feed sends the feed 
		/// properly compressed.  USed the RSS Bandit decompress code 
		/// to decompress the feed and test it.
		/// </summary>
		[Test]
		[RollBack]
		public void TestCompressedFeedWorks()
		{
			string hostName = System.Guid.NewGuid().ToString().Replace("-", "") + ".com";
			StringBuilder sb = new StringBuilder();
			TextWriter output = new StringWriter(sb);

			SimulatedHttpRequest workerRequest = UnitTestHelper.SetHttpContextWithBlogRequest(hostName, "", "", "", output);
			workerRequest.Headers.Add("Accept-Encoding", "gzip");
			Assert.IsTrue(Config.CreateBlog("", "username", "password", hostName, string.Empty));
			Config.CurrentBlog.UseSyndicationCompression = true;

			Entries.Create(UnitTestHelper.CreateEntryInstanceForSyndication("Haacked", "Title Test", "Body Rocking"));
			Thread.Sleep(50);
			Entries.Create(UnitTestHelper.CreateEntryInstanceForSyndication("Haacked", "Title Test 2", "Body Rocking Pt 2"));

			RssHandler handler = new RssHandler();
			Assert.IsNotNull(HttpContext.Current.Request.Headers, "Headers collection is null! Not Good.");
			handler.ProcessRequest(HttpContext.Current);
			
			//I'm cheating here!
			MethodInfo method = typeof(HttpResponse).GetMethod("FilterOutput", BindingFlags.NonPublic | BindingFlags.Instance);
			method.Invoke(HttpContext.Current.Response, new object[] {});
			HttpContext.Current.Response.Flush();
			
			MemoryStream stream = new MemoryStream(Encoding.Default.GetBytes(sb.ToString()));
			Stream deflated = UnitTestHelper.GetDeflatedResponse("gzip", stream);
			string rssOutput;
			using(StreamReader reader = new StreamReader(deflated))
			{
				rssOutput = reader.ReadToEnd();
			}
			
			XmlDocument doc = new XmlDocument();
			doc.LoadXml(rssOutput);

			XmlNodeList itemNodes = doc.SelectNodes("/rss/channel/item");
			Assert.AreEqual(2, itemNodes.Count, "expected two item nodes.");

			Assert.AreEqual("Title Test 2", itemNodes[0].SelectSingleNode("title").InnerText, "Not what we expected for the second title.");
			Assert.AreEqual("Title Test", itemNodes[1].SelectSingleNode("title").InnerText, "Not what we expected for the first title.");
			
			Assert.AreEqual("Body Rocking Pt 2", itemNodes[0].SelectSingleNode("description").InnerText.Substring(0, "Body Rocking pt 2".Length), "Not what we expected for the second body.");
			Assert.AreEqual("Body Rocking", itemNodes[1].SelectSingleNode("description").InnerText.Substring(0, "Body Rocking".Length), "Not what we expected for the first body.");
		}
	}
}
