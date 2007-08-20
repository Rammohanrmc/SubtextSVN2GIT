using System;
using System.Collections.Generic;
using MbUnit.Framework;
using Subtext.Framework;
using Subtext.Framework.Components;

namespace UnitTests.Subtext.Framework.Components.MetaTagTests
{
    [TestFixture]
    class MetaTagInsertTests
    {
        private BlogInfo blog; 

        [RowTest]
        [Row("Steve loves Testing.", "description", null, false, "Did not create blog specific MetaTag.")]
        [Row("Still testing.", "description", null, true, "Did not create Entry specific MetaTag.")]
        [RollBack2]
        public void CanInsertNewMetaTag(string content, string name, string httpEquiv, bool withEntry, string errMsg)
        {
            int? entryId = null;
            if (withEntry)
            {
                Entry e = UnitTestHelper.CreateEntryInstanceForSyndication("Steven Harman", "My Post", "Foo Bar Zaa!");
                entryId = Entries.Create(e);
            }

            MetaTag mt = BuildMetaTag(content, name, httpEquiv, blog.Id, entryId, DateTime.Now);

            // make sure there are no meta-tags for this blog in the data store
            IList<MetaTag> tags = MetaTags.GetMetaTagsForBlog(blog);
            Assert.AreEqual(0, tags.Count, "Should be zero MetaTags.");

            // add the meta-tag to the data store
            int tagId = MetaTags.Create(mt);

            tags = MetaTags.GetMetaTagsForBlog(blog);

            Assert.AreEqual(1, tags.Count);

            MetaTag newTag = tags[0];

            // make sure all attributes of the meta-tag were written to the data store correctly.
            Assert.AreEqual(tagId, newTag.Id);
            Assert.AreEqual(mt.Content, newTag.Content);
            Assert.AreEqual(mt.Name, newTag.Name);
            Assert.AreEqual(mt.HttpEquiv, newTag.HttpEquiv);
            Assert.AreEqual(mt.BlogId, newTag.BlogId);
            Assert.AreEqual(mt.EntryId, newTag.EntryId);
            Assert.AreEqual(mt.DateCreated.Date, newTag.DateCreated.Date);
        }

        [SetUp]
        public void Setup()
        {
            this.blog = UnitTestHelper.CreateBlogAndSetupContext();
        }

        private static MetaTag BuildMetaTag(string content, string name, string httpEquiv, int blogId, int? entryId, DateTime created)
        {
            MetaTag mt = new MetaTag();
            mt.Name = name;
            mt.HttpEquiv = httpEquiv;
            mt.Content = content;
            mt.BlogId = blogId;

            if (entryId.HasValue)
                mt.EntryId = entryId.Value;

            mt.DateCreated = created;

            return mt;
        }
    }
}
