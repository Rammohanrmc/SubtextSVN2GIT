using System;
using System.Collections.Generic;
using System.Text;
using Subtext.Framework.Components;
using System.Collections.Specialized;
using Subtext.Framework.Configuration;
using Subtext.Framework.Format;
using Subtext.Extensibility;
using System.IO;

namespace Subtext.Framework.Syndication.Admin
{
	public class ReferrerRssWriter : GenericRssWriter<Referrer>
	{
		public ReferrerRssWriter(TextWriter writer, ICollection<Referrer> referrers, DateTime dateLastViewedFeedItemPublished, bool useDeltaEncoding, ISubtextContext context)
            : base(writer, dateLastViewedFeedItemPublished, useDeltaEncoding, context)
		{
			this.Items = referrers;
		}

		protected override ICollection<string> GetCategoriesFromItem(Referrer item)
		{
			var strings = new List<string>();
			strings.Add(item.PostTitle);
			strings.Add(new Uri(item.ReferrerURL).Host);
			return strings;
		}
		protected override string GetGuid(Referrer item)
		{
			return item.BlogId.ToString() + item.EntryID.ToString() + item.ReferrerURL;
		}

		protected override string GetTitleFromItem(Referrer item)
		{
			return item.PostTitle + " - " + UrlFormats.ShortenUrl(item.ReferrerURL,20) ;
		}

		protected override string GetLinkFromItem(Referrer item)
		{
			return Blog.UrlFormats.AdminUrl("Referrers.aspx");
		}

		protected override string GetBodyFromItem(Referrer item)
		{
			return String.Format("{1} referrals from <a href=\"{0}\">{0}</a> ", item.ReferrerURL, item.Count);
		}

		protected override string GetAuthorFromItem(Referrer item)
		{
			return "";
		}

		protected override DateTime GetPublishedDateUtc(Referrer item)
		{
			return item.LastReferDate;
		}

		protected override bool ItemCouldContainComments(Referrer item)
		{
			return false;
		}

		protected override bool ItemAllowsComments(Referrer item)
		{
			return false;
		}

		protected override bool CommentsClosedOnItem(Referrer item)
		{
			return true;
		}

		protected override int GetFeedbackCount(Referrer item)
		{
			return item.Count;
		}

		protected override DateTime GetSyndicationDate(Referrer item)
		{
			return item.LastReferDate;
		}

		protected override string GetAggBugUrl(Referrer item)
		{
			return string.Empty;
		}

		protected override string GetCommentApiUrl(Referrer item)
		{
            return string.Empty;
		}

		protected override string GetCommentRssUrl(Referrer item)
		{
            return string.Empty;
		}

		protected override string GetTrackBackUrl(Referrer item)
		{
            return string.Empty;
		}
        protected override EnclosureItem GetEnclosureFromItem(Referrer item)
        {
            return null;
        }
	}
}
