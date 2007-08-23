using System;
using System.Collections.Generic;
using System.IO;
using System.Web.Hosting;
using MbUnit.Framework;
using Rhino.Mocks;
using Subtext.Framework.UI.Skinning;

namespace UnitTests.Subtext.Framework.Skinning
{
	[TestFixture]
	public class SkinTests
	{
		/// <summary>
		/// Here we load an instance of SkinTemplates from an embedded Skins.config file.
		/// </summary>
		[Test]
		public void CanLoadSkinsFromFile()
		{
			MockRepository mocks = new MockRepository();

			VirtualPathProvider pathProvider = GetTemplatesPathProviderMock(mocks);
			mocks.ReplayAll();

			SkinTemplates templates = SkinTemplates.Instance(pathProvider);
			Assert.IsNotNull(templates, "Could not instantiate template.");
			Assert.AreEqual(17, templates.Templates.Count, "Expected 17 templates.");
		}

		/// <summary>
		/// Here we load an instance of SkinTemplates from an embedded Skins.config file and 
		/// Skins.User.config file.
		/// </summary>
		[Test]
		public void CanLoadAndMergeUserSkinsFromFile()
		{
			MockRepository mocks = new MockRepository();
			VirtualPathProvider pathProvider = (VirtualPathProvider)mocks.CreateMock(typeof(VirtualPathProvider));
			VirtualFile vfile = (VirtualFile)mocks.CreateMock(typeof(VirtualFile), "~/Admin/Skins.config");
			VirtualFile vUserFile = (VirtualFile)mocks.CreateMock(typeof(VirtualFile), "~/Admin/Skins.User.config");
			
			using (Stream stream = UnitTestHelper.UnpackEmbeddedResource("Skins.Skins.config"))
			using (Stream userStream = UnitTestHelper.UnpackEmbeddedResource("Skins.Skins.User.config"))
			{
				Expect.Call(vfile.Open()).Return(stream);
				Expect.Call(vUserFile.Open()).Return(userStream);
				Expect.Call(pathProvider.GetFile("~/Admin/Skins.config")).Return(vfile);
				Expect.Call(pathProvider.FileExists("~/Admin/Skins.User.config")).Return(true);
				Expect.Call(pathProvider.GetFile("~/Admin/Skins.User.config")).Return(vUserFile);

				mocks.ReplayAll();
				SkinTemplates templates = SkinTemplates.Instance(pathProvider);
				Assert.IsNotNull(templates, "Could not instantiate template.");
				Assert.AreEqual(18, templates.Templates.Count, "Expected 18 templates.");
			}
		}
		
		[Test]
		public void CanGetPropertiesOfSingleTemplate()
		{
			MockRepository mocks = new MockRepository();

			VirtualPathProvider pathProvider = GetTemplatesPathProviderMock(mocks);
			mocks.ReplayAll();

			SkinTemplates templates = SkinTemplates.Instance(pathProvider);
			SkinTemplate template = templates.GetTemplate("RedBook-Blue.css");
			Assert.IsNotNull(template, "Could not get the template for the skin key 'RedBook-Blue.css'");

			Assert.AreEqual("REDBOOK-BLUE.CSS", template.SkinKey, "SkinKey not correct.");
			Assert.AreEqual("BlueBook", template.Name, "Name not correct.");
			Assert.AreEqual("RedBook", template.TemplateFolder, "Folder not correct.");
			Assert.AreEqual(1, template.Scripts.Length, "Wrong number of scripts.");
			Assert.AreEqual(6, template.Styles.Length, "Wrong number of styles.");
		}
		
		[RowTest]
		[Row("", "", "/Skins/RedBook/print.css")]
		[Row("blog", "", "/Skins/RedBook/print.css")]
		[Row("blog", "Subtext.Web", "/Subtext.Web/Skins/RedBook/print.css")]
		public void StyleSheetElementCollectionRendererRendersCssLinkElements(string subFolder, string applicationPath, string expectedPrintCssPath)
		{
			UnitTestHelper.SetHttpContextWithBlogRequest("localhost", subFolder, applicationPath);
			MockRepository mocks = new MockRepository();

			VirtualPathProvider pathProvider = GetTemplatesPathProviderMock(mocks);
			mocks.ReplayAll();

			SkinTemplates templates = SkinTemplates.Instance(pathProvider);
			StyleSheetElementCollectionRenderer renderer = new StyleSheetElementCollectionRenderer(templates);
			string styleElements = renderer.RenderStyleElementCollection("RedBook-Blue.css");

			Console.WriteLine(styleElements);
			
			string printCss = string.Format(@"<link media=""print"" type=""text/css"" rel=""stylesheet"" href=""{0}"" />", expectedPrintCssPath);
			Assert.IsTrue(styleElements.IndexOf(printCss) > -1, "Expected the printcss to be there.");
		}

        [RowTest]
        [Row("", "print", "", "print.css", false)]
        [Row("", "", "", "~/skins/_System/csharp.css", true)]
        [Row("if gte IE 7", "", "", "IE7Patches.css", false)]
        [Row("", "screen", "", "~/scripts/lightbox.css", false)]
        [Row("", "all", "", "Styles/user-styles.css", true)]
        [Row("", "", "fixed", "print.css", false)]
        [Row("", "all", "fixed", "Styles/user-styles.css", false)]
        [Row("if gte IE 7", "all", "", "Styles/user-styles.css", false)]
        [Row("", "", "", "http://www.google.com/style.css", false)]
        public void StyleToBeMergedAreCorrectlyDetected(string conditional, string media, string title, string href, bool canBeMerged)
        {
            Style style = new Style();
            style.Conditional = conditional;
            style.Media = media;
            style.Href = href;
            style.Title = title;

            bool isMergeable=StyleSheetElementCollectionRenderer.CanStyleBeMerged(style);
            if(canBeMerged)
                Assert.IsTrue(isMergeable,"Expected to be mergeable");
            else
                Assert.IsFalse(isMergeable, "Expected not to be mergeable");
        }

        [RowTest]
        [Row("AnotherEon001", 3)]
        [Row("Colors-Blue.css", 6)]
        [Row("RedBook-Blue.css", 6)]
        [Row("Gradient", 5)]
        [Row("RedBook-Green.css", 6)]
        [Row("KeyWest", 4)]
        [Row("Nature-Leafy.css", 7)]
        [Row("Lightz", 4)]
        [Row("Naked", 1)]
        [Row("Colors", 5)]
        [Row("Origami", 5)]
        [Row("Piyo", 4)]
        [Row("Nature-rain.css", 7)]
        [Row("RedBook-Red.css", 6)]
        [Row("Semagogy", 4)]
        [Row("Submarine", 7)]
        [Row("WPSkin", 4)]
        [Row("Haacked", 0)]
        public void MergedCssIsCorrect(string skinKey, int expectedStyles)
        {
            UnitTestHelper.SetHttpContextWithBlogRequest("localhost", "blog", string.Empty);
            MockRepository mocks = new MockRepository();

            VirtualPathProvider pathProvider = GetTemplatesPathProviderMock(mocks);
            mocks.ReplayAll();

            SkinTemplates templates = SkinTemplates.Instance(pathProvider);
            StyleSheetElementCollectionRenderer renderer = new StyleSheetElementCollectionRenderer(templates);
            int mergedStyles = renderer.GetStylesToBeMerged(skinKey).Count;

            Assert.AreEqual(expectedStyles, mergedStyles, String.Format("Skin {0} should have {1} merged styles but found {2}", skinKey, expectedStyles, mergedStyles));
        }


	    [Test]
		public void ScriptElementCollectionRendererRendersScriptElements()
		{
			UnitTestHelper.SetHttpContextWithBlogRequest("localhost", "blog", string.Empty);
			MockRepository mocks = new MockRepository();

			VirtualPathProvider pathProvider = GetTemplatesPathProviderMock(mocks);
			mocks.ReplayAll();

			SkinTemplates templates = SkinTemplates.Instance(pathProvider);
			ScriptElementCollectionRenderer renderer = new ScriptElementCollectionRenderer(templates);
			string scriptElements = renderer.RenderScriptElementCollection("RedBook-Green.css");
			
			string script = @"<script type=""text/javascript"" src=""/Skins/RedBook/blah.js""></script>";
			Assert.IsTrue(scriptElements.IndexOf(script) > -1, "Rendered the script improperly.");

			scriptElements = renderer.RenderScriptElementCollection("Nature-Leafy.css");
			script = @"<script type=""text/javascript"" src=""/scripts/XFNHighlighter.js""></script>";
			Assert.IsTrue(scriptElements.IndexOf(script) > -1, "Rendered the script improperly. We got: " + scriptElements);
		}
		
		private VirtualPathProvider GetTemplatesPathProviderMock(MockRepository mocks)
		{
			VirtualPathProvider pathProvider = (VirtualPathProvider)mocks.CreateMock(typeof(VirtualPathProvider));
			VirtualFile vfile = (VirtualFile)mocks.CreateMock(typeof(VirtualFile), "~/Admin/Skins.config");
			Expect.Call(pathProvider.GetFile("~/Admin/Skins.config")).Return(vfile);
			Expect.Call(pathProvider.FileExists("~/Admin/Skins.User.config")).Return(false);
			Stream stream = UnitTestHelper.UnpackEmbeddedResource("Skins.Skins.config");
			Expect.Call(vfile.Open()).Return(stream);
			return pathProvider;
		}
	}
}
