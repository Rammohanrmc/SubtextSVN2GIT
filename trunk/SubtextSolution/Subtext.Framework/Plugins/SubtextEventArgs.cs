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
using System.Text;
using System.Collections.Specialized;
using Subtext.Framework.Components;

namespace Subtext.Extensibility.Plugins
{
	/// <summary>
	/// Base class for SubText specific events
	/// </summary>
	public class SubtextEventArgs: EventArgs
	{
		private ObjectState _state;
		private Entry _entry;

		/// <summary>
		/// The current state of the Object being processed
		/// </summary>
		public ObjectState State
		{
			get{ return _state; }
		}

		/// <summary>
		/// The Entry being manipulated
		/// </summary>
		public Entry Entry
		{
			get { return _entry; }
		}

        //TODO: Not needed any more
        ///// <summary>
        ///// All the plugins settings for the current blog
        ///// </summary>
        //public NameValueCollection BlogSettings
        //{
        //    get { return Subtext.Framework.Configuration.Config.CurrentBlog.EnabledPlugins[_callingPluginGuid].Settings; }
        //}

		private Guid _callingPluginGuid;

		internal Guid CallingPluginGuid
		{
			get { return _callingPluginGuid; }
			set { _callingPluginGuid = value; }
		}



		public SubtextEventArgs(Entry entry, ObjectState state)
		{
			_entry = entry;
			_state = state;
		}

		public SubtextEventArgs(Entry entry) : this(entry, ObjectState.None) { }

	}

	/// <summary>
	/// All possible states for an object (entry, photo, comment)
	/// </summary>
	public enum ObjectState
	{
		/// <summary>
		/// When the Object is being created
		/// </summary>
		Create,
		/// <summary>
		/// When the Object is being update
		/// </summary>
		Update,
		/// <summary>
		/// When the Object is being deleted
		/// </summary>
		Delete,
		/// <summary>
		/// When we don't know :-)
		/// </summary>
		None,
		/// <summary>
		/// When the object is created just for a runtime processing, but never presisted
		/// </summary>
		Runtime
	}
}
