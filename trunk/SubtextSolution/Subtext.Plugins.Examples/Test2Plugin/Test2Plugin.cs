using System;
using Subtext.Extensibility.Plugins;

namespace Subtext.Plugins.Examples.Test2Plugin
{
	public class Test2Plugin: IPlugin
	{
		#region IPlugin Members

		static readonly Guid guid = new Guid("{3223AC01-DEE1-4351-9198-9700295A6DA1}");
		
		public Guid Id
		{
			get { return guid; }
		}

		public IImplementationInfo Info
		{
			get { return new Test2PluginImplentationInfo(); }
		}

		public void Init(SubtextApplication application)
		{
			application.EntryUpdating += new EntryEventHandler(sta_EntryUpdating);
			application.EntryUpdated += new EntryEventHandler(sta_EntryUpdated);
			application.EntryRendering += new EntryEventHandler(sta_EntryRendering);
			application.SingleEntryRendering += new EntryEventHandler(sta_SingleEntryRendering);
		}

		void sta_SingleEntryRendering(Subtext.Framework.Components.Entry entry, SubtextEventArgs e)
		{
			entry.Body += "<br><hr> <b>Test2Plugin</b>: Rendered at date: " + DateTime.Now.ToShortDateString() + " " + DateTime.Now.ToShortTimeString();
		}

		void sta_EntryRendering(Subtext.Framework.Components.Entry entry, SubtextEventArgs e)
		{
			entry.Body += "<br><hr> <b>Test2Plugin</b>: Rendered at date: " + DateTime.Now.ToShortDateString() + " " + DateTime.Now.ToShortTimeString();
		}

		void sta_EntryUpdated(Subtext.Framework.Components.Entry entry, SubtextEventArgs e)
		{
			string url = entry.FullyQualifiedUrl.ToString();
			return;
		}

		void sta_EntryUpdating(Subtext.Framework.Components.Entry entry, SubtextEventArgs e)
		{
			switch (e.State)
			{
				case ObjectState.Create:
					entry.Body += "<br><hr> <b>Test2Plugin</b>: Created at date: " + DateTime.Now.ToShortDateString() + " " + DateTime.Now.ToShortTimeString();
					break;
				case ObjectState.Update:
					entry.Body += "<br><hr> <b>Test2Plugin</b>: Updated at date: " + DateTime.Now.ToShortDateString() + " " + DateTime.Now.ToShortTimeString();
					break;
				default:
					break;
			}
		}



		#endregion
	}
}
