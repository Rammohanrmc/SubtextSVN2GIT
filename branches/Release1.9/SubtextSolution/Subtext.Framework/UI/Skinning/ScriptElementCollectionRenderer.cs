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
using System.Text;
using System.Web;
using Subtext.Framework.Web;

namespace Subtext.Framework.UI.Skinning
{
    /// <summary>
    /// Provides rendering facilities for script elements in the head element of the page
    /// </summary>
    public class ScriptElementCollectionRenderer
    {
        SkinTemplates templates;
			
        public ScriptElementCollectionRenderer(SkinTemplates templates)
        {
            this.templates = templates;
        }
			
        private static string RenderScriptAttribute(string attributeName, string attributeValue)
        {
            return attributeValue != null ? " " + attributeName + "=\"" + attributeValue + "\"" : String.Empty;
        }

        public static string RenderScriptElement(string skinPath, Script script)
        {
            return "<script" +
                   RenderScriptAttribute("type", script.Type) +
                   RenderScriptAttribute("src", GetScriptSourcePath(skinPath, script)) +
                   RenderScriptAttribute("defer", script.Defer ? "defer" : null) +
                   "></script>" + Environment.NewLine;
        }

        private static string GetScriptSourcePath(string skinPath, Script script)
        {
            if(script.Src.StartsWith("~"))
            {
                return HttpHelper.ExpandTildePath(script.Src);
            }
            else if(script.Src.StartsWith("/"))
            {
                return script.Src;
            }
            else
            {
                return skinPath + script.Src;
            }
        }

        /// <summary>
        /// Gets the skin path.
        /// </summary>
        /// <param name="skinTemplateFolder">Name of the skin.</param>
        /// <returns></returns>
        private static string GetSkinPath(string skinTemplateFolder)
        {
            string applicationPath = HttpContext.Current.Request.ApplicationPath;
            return (applicationPath == "/" ? String.Empty : applicationPath) + "/Skins/" + skinTemplateFolder + "/";
        }

        /// <summary>
        /// Renders the script element collection for thes kin key.
        /// </summary>
        /// <param name="skinKey">The skin key.</param>
        /// <returns></returns>
        public string RenderScriptElementCollection(string skinKey)
        {
            StringBuilder result = new StringBuilder();

            SkinTemplate skinTemplate = templates.GetTemplate(skinKey);
            if (skinTemplate != null && skinTemplate.Scripts != null)
            {
                string skinPath = GetSkinPath(skinTemplate.TemplateFolder);
                foreach(Script script in skinTemplate.Scripts)
                {
                    result.Append(RenderScriptElement(skinPath, script));
                }
            }
            return result.ToString();
        }
    }
}