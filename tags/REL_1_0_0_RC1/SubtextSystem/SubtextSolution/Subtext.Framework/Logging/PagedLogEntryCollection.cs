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
using Subtext.Framework.Components;
using Subtext.Framework.Logging;

namespace Subtext.Framework.Logging
{
	/// <summary>
	/// Pageable collection of <see cref="LogEntry"/> instances.
	/// </summary>
	public class PagedLogEntryCollection : LogEntryCollection, IPagedResults
	{
		private int _maxItems;
		
		/// <summary>
		/// Gets or sets the max items this can contain.
		/// </summary>
		/// <value></value>
		public int MaxItems
		{
			get {return this._maxItems;}
			set {this._maxItems = value;}
		}
	}
}
