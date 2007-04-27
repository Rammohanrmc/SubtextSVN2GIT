using System;
using System.Collections.Generic;
using System.Text;
using System.Web.UI.WebControls;
using MbUnit.Framework;
using Subtext.Web.Controls;

namespace UnitTests.Subtext.SubtextWeb.Controls
{
	[TestFixture]
	public class ControlHelperTests
	{
		[RowTest]
		[Row("a tooltip", "trying this title", "a tooltip")]
		[Row("", "", "")]
		public void OnlyAddTitleWhenNotAlreadyThere(string toolTip, string title, string expectedTitle)
		{
			HyperLink link = new HyperLink();
			link.ToolTip = toolTip;

			ControlHelper.SetTitleIfNone(link, title);

			Assert.AreEqual(expectedTitle, link.ToolTip, "Didn't set the tooltip correctly.");
			Assert.IsNull(link.Attributes["title"], "Oops, looks like we set the title attribute too!");
		}
	}
}
