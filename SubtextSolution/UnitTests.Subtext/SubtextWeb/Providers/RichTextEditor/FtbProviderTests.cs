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
using MbUnit.Framework;
using System.Web.UI.WebControls;
using FreeTextBoxControls;
using Subtext.Framework;
using Subtext.Framework.Components;
using Subtext.Framework.Configuration;
using Subtext.Web.Providers.RichTextEditor.FTB;

namespace UnitTests.Subtext.SubtextWeb.Providers.RichTextEditor
{
	/// <summary>
	/// Summary description for FtbProviderTests.
	/// </summary>
	[TestFixture]
	[Author("Simone Chiaretta", "simone@piyosailing.com", "http://blogs.ugidotnet.org/piyo/")]
	public class FtbProviderTests
	{
		string _hostName = System.Guid.NewGuid().ToString().Replace("-", string.Empty) + ".com";
		string _testToolbarLayout="Bold,Italic,Underline,Strikethrough;Superscript,Subscript,RemoveFormat|FontFacesMenu,FontSizesMenu,FontForeColorsMenu|InsertTable|JustifyLeft,JustifyRight,JustifyCenter,JustifyFull;BulletedList,NumberedList,Indent,Outdent;CreateLink,Unlink,Insert,InsertRule|Cut,Copy,Paste;Undo,Redo|ieSpellCheck,WordClean|InsertImage,InsertImageFromGallery";
		FtbRichTextEditorProvider frtep;

		[SetUp]
		public void SetUp()
		{
			frtep = new FtbRichTextEditorProvider();
			UnitTestHelper.SetHttpContextWithBlogRequest(_hostName, "MyBlog", "Subtext.Web");
		}

		[Test]
		public void SetControlID() 
		{
			string test="MyTestControlID";
			frtep.ControlID=test;
			Assert.AreEqual(test,frtep.ControlID);
		}

		[Test]
		[Ignore("Have to setup dummy blog config first")]
		[RollBack]
		public void SetText() 
		{
			Assert.IsTrue(Config.CreateBlog("", "username", "password", _hostName, "MyBlog"));
			string test="Lorem Ipsum";
			frtep.InitializeControl();
			frtep.Text=test;
			Assert.AreEqual(test,frtep.Text);
			Assert.AreEqual(test,frtep.Xhtml);
		}

		[Test]
		[Ignore("Have to setup dummy blog config first")]
		public void SetWidth() 
		{
			Unit test=200;
			frtep.InitializeControl();
			frtep.Width=test;
			Assert.AreEqual(test,frtep.Width);
		}

		[Test]
		[Ignore("Have to setup dummy blog config first")]
		public void SetHeight() 
		{
			Unit test=100;
			frtep.InitializeControl();
			frtep.Height=test;
			Assert.AreEqual(test,frtep.Height);
		}

		[Test]
		[ExpectedException(typeof(ArgumentNullException))]
		public void TestInitializationWithNullName() 
		{
			frtep.Initialize(null,null);
		}

		[Test]
		[ExpectedException(typeof(ArgumentNullException))]
		public void TestInitializationWithNullConfigValue() 
		{
			frtep.Initialize("FTBProvider",null);
		}

		[Test]
		[ExpectedException(typeof(InvalidOperationException))]
		public void TestInitializationWithEmptyWebFolder() 
		{
			frtep.Initialize("FTBProvider",new System.Collections.Specialized.NameValueCollection());
		}

		[Test]
		[Ignore("Have to setup dummy blog config first")]
		public void TestInitialization() 
		{
			System.Collections.Specialized.NameValueCollection coll=GetNameValueCollection();
			frtep.Initialize("FTBProvider", coll);
			frtep.InitializeControl();
			Assert.IsTrue(frtep.RichTextEditorControl.GetType()==typeof(FreeTextBox));
			FreeTextBox txt = frtep.RichTextEditorControl as FreeTextBox;
			Assert.AreEqual(frtep.Name,"FTBProvider");
			Assert.AreEqual(txt.ToolbarLayout,_testToolbarLayout);
			Assert.AreEqual(txt.FormatHtmlTagsToXhtml,true);
			Assert.AreEqual(txt.RemoveServerNameFromUrls,false);
		}

		private System.Collections.Specialized.NameValueCollection GetNameValueCollection() 
		{
			System.Collections.Specialized.NameValueCollection ret=new System.Collections.Specialized.NameValueCollection(3);
			ret.Add("WebFormFolder","~/Providers/RichTextEditor/FTB/");
			ret.Add("toolbarlayout",_testToolbarLayout);
			ret.Add("FormatHtmlTagsToXhtml","true");
			ret.Add("RemoveServerNamefromUrls","false");
			return ret;
		}
	}
}
