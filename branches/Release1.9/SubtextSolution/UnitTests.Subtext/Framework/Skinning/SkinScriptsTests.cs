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
using System.IO;
using System.Web.Hosting;
using MbUnit.Framework;
using Rhino.Mocks;
using Subtext.Framework.UI.Skinning;

namespace UnitTests.Subtext.Framework.Skinning
{
    [TestFixture]
    public class SkinScriptsTests
    {
        [Test]
        public void CanGetMergeScriptsAttribute()
        {
            MockRepository mocks = new MockRepository();

            VirtualPathProvider pathProvider = GetTemplatesPathProviderMock(mocks);
            mocks.ReplayAll();

            SkinTemplates templates = SkinTemplates.Instance(pathProvider);

            SkinTemplate templateWithTrueMergeScripts = templates.GetTemplate("Piyo");
            Assert.IsTrue(templateWithTrueMergeScripts.MergeScripts, "MergeScripts should be true.");

            SkinTemplate templateWithFalseMergeScripts = templates.GetTemplate("Semagogy");
            Assert.IsFalse(templateWithFalseMergeScripts.MergeScripts, "MergeScripts should be false.");

            SkinTemplate templateWithoutMergeScripts = templates.GetTemplate("RedBook-Green.css");
            Assert.IsFalse(templateWithoutMergeScripts.MergeScripts, "MergeScripts should be false.");
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


        [Test]
        public void ScriptsWithRemoteSrcAreNotMerged()
        {
            MockRepository mocks = new MockRepository();

            VirtualPathProvider pathProvider = GetTemplatesPathProviderMock(mocks);
            mocks.ReplayAll();

            SkinTemplates templates = SkinTemplates.Instance(pathProvider);
            SkinTemplate template = templates.GetTemplate("RedBook-Red.css");
            bool canBeMerged = ScriptElementCollectionRenderer.CanScriptsBeMerged(template);

            Assert.IsFalse(canBeMerged,"Skins with remote scripts should not be mergeable.");
        }

        [Test]
        public void ScriptsWithFalseMergeScriptsAreNotMerged()
        {
            MockRepository mocks = new MockRepository();

            VirtualPathProvider pathProvider = GetTemplatesPathProviderMock(mocks);
            mocks.ReplayAll();

            SkinTemplates templates = SkinTemplates.Instance(pathProvider);
            SkinTemplate template = templates.GetTemplate("Semagogy");
            bool canBeMerged = ScriptElementCollectionRenderer.CanScriptsBeMerged(template);

            Assert.IsFalse(canBeMerged, "Skins with MergeScripts=\"false\" should not be mergeable.");
        }

        [Test]
        public void ScriptsWithParametricSrcAreNotMerged()
        {
            MockRepository mocks = new MockRepository();

            VirtualPathProvider pathProvider = GetTemplatesPathProviderMock(mocks);
            mocks.ReplayAll();

            SkinTemplates templates = SkinTemplates.Instance(pathProvider);
            SkinTemplate template = templates.GetTemplate("Piyo");
            bool canBeMerged = ScriptElementCollectionRenderer.CanScriptsBeMerged(template);

            Assert.IsFalse(canBeMerged, "Skins with scripts that have query string parameters should not be mergeable.");
        }

        private static VirtualPathProvider GetTemplatesPathProviderMock(MockRepository mocks)
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
