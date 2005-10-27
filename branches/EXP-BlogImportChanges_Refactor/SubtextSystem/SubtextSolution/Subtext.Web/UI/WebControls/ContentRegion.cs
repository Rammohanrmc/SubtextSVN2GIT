using System;
using System.Drawing;
using System.Globalization;
using System.Web.UI;
using System.Web.UI.WebControls;

#region Code Notes
/*
	The MasterPage controls (MasterPage and ContentRegion) are almost entirely based off of Paul Wilson's excellect demo found
	here: http://authors.aspalliance.com/paulwilson/Articles/?id=14
	
	Very MINOR changes were made here. Thanks Paul.
*/
#endregion

namespace Subtext.Web.UI.WebControls
{
	[ToolboxData("<{0}:ContentRegion runat=server></{0}:ContentRegion>")]
	public class ContentRegion : System.Web.UI.WebControls.Panel
	{
		public ContentRegion() {
			base.BackColor = Color.WhiteSmoke;
			base.Width = new Unit("100%", CultureInfo.InvariantCulture);
		}

		public override void RenderBeginTag(System.Web.UI.HtmlTextWriter writer) {}
		public override void RenderEndTag(System.Web.UI.HtmlTextWriter writer) {}
	}
}
