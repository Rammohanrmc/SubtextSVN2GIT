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
using System.Collections.Generic;
using System.Data;
using Subtext.Data;
using Subtext.Extensibility.Providers;
using Subtext.Framework.Components;
using Subtext.Framework.Data;

namespace Subtext.Framework.Providers
{
	public class EntrySearchProvider : SearchProvider
	{
		/// <summary>
		/// Searches the specified blog for items that match the search term.
		/// </summary>
		/// <param name="blogId"></param>
		/// <param name="searchTerm"></param>
		/// <returns></returns>
		public override IList<SearchResult> Search(int blogId, string searchTerm)
		{
			IList<SearchResult> results = new List<SearchResult>();
			using (IDataReader reader = StoredProcedures.SearchEntries(blogId, searchTerm).GetReader())
			{
				while (reader.Read())
				{
					Entry foundEntry = DataHelper.LoadEntry(reader, true);
					results.Add(new SearchResult(foundEntry.Title, foundEntry.FullyQualifiedUrl));
				}
			}
			return results;
		}
	}
}
