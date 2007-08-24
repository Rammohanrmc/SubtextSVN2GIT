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
using System.Web;
using Subtext.Framework.Web;

namespace Subtext.Framework.UI.Skinning
{
    /// <summary>
    /// Provides rendering facilities for stylesheet elements in the head element of the page
    /// </summary>
    public class StyleSheetElementCollectionRenderer
    {
        SkinTemplates templates;
		
        public StyleSheetElementCollectionRenderer(SkinTemplates templates)
        {
            this.templates = templates;
        }
		
        private static string RenderStyleAttribute(string attributeName, string attributeValue)
        {
            return attributeValue != null ? " " + attributeName + "=\"" + attributeValue + "\"" : String.Empty;
        }

        private static string RenderStyleElement(string skinPath, Style style)
        {
            string element = string.Empty;
		    
            if (!String.IsNullOrEmpty(style.Conditional))
            {
                element = string.Format("<!--[{0}]>{1}", style.Conditional, Environment.NewLine);
            }
		    
            element += "<link";
            if (style.Media != null && style.Media.Length > 0)
                element += RenderStyleAttribute("media", style.Media);

            element +=
                RenderStyleAttribute("type", "text/css") + 
                RenderStyleAttribute("rel", "stylesheet") + 
                RenderStyleAttribute("title", style.Title) + 
                RenderStyleAttribute("href", GetStylesheetHrefPath(skinPath, style)) + //TODO: Look at this line again.
                " />" + Environment.NewLine;

            if (!String.IsNullOrEmpty(style.Conditional))
            {
                element += "<![endif]-->" + Environment.NewLine;
            }
		    
            return element;
        }

        /// <summary>
        /// Gets the stylesheet href path.
        /// </summary>
        /// <param name="skinPath">The skin path.</param>
        /// <param name="style">The style.</param>
        /// <returns></returns>
        public static string GetStylesheetHrefPath(string skinPath, Style style)
        {
            if(style.Href.StartsWith("~"))
            {
                return HttpHelper.ExpandTildePath(style.Href);
            }
            else if(style.Href.StartsWith("/") || style.Href.StartsWith("http://") || style.Href.StartsWith("https://"))
            {
                return style.Href;
            }
            else
            {
                return skinPath + style.Href;
            }
        }

        public static string CreateStylePath(string skinTemplateFolder)
        {
            string applicationPath = HttpContext.Current.Request.ApplicationPath;
            string path = (applicationPath == "/" ? String.Empty : applicationPath) + "/Skins/" + skinTemplateFolder + "/";
            return path;
        }

        public string RenderStyleElementCollection(string skinName)
        {
            return RenderStyleElementCollection(skinName, true);
        }

        public string RenderStyleElementCollection(string skinName, bool includeAll)
        {
            StringBuilder result = new StringBuilder();

            SkinTemplate skinTemplate = templates.GetTemplate(skinName);
			
            if (skinTemplate != null && skinTemplate.Styles != null)
            {
                string skinPath = CreateStylePath(skinTemplate.TemplateFolder);
                foreach(Style style in skinTemplate.Styles)
                {
                    if(includeAll || !CanStyleBeMerged(style))
                        result.Append(RenderStyleElement(skinPath, style));
                }
            }
            return Environment.NewLine + result;
        }

        public IList<string> GetStylesToBeMerged(string skinName)
        {
            List<string> styles = new List<string>();

            SkinTemplate skinTemplate = templates.GetTemplate(skinName);
            
            if (skinTemplate != null)
            {
                string skinPath = CreateStylePath(skinTemplate.TemplateFolder);

                if (skinTemplate.Styles != null)
                {
                    foreach (Style style in skinTemplate.Styles)
                    {
                        if (CanStyleBeMerged(style))
                        {
                            if (style.Href.StartsWith("~"))
                            {
                                styles.Add(HttpHelper.ExpandTildePath(style.Href));
                            }
                            else
                            {
                                styles.Add(skinPath + style.Href);
                            }
                        }
                    }  
                }

                //Main style
                styles.Add(skinPath + "style.css");

                //Secondary Style
                if (skinTemplate.HasSkinStylesheet)
                    styles.Add(skinPath + skinTemplate.StyleSheet);
            }
            return styles;
        }

        public static bool CanStyleBeMerged(Style style)
        {
            if(!String.IsNullOrEmpty(style.Conditional))
                return false;
            if(!string.IsNullOrEmpty(style.Title))
                return false;
            if(!string.IsNullOrEmpty(style.Media) && !style.Media.ToLower().Equals("all"))
                return false;
            if(style.Href.StartsWith("http://") || style.Href.StartsWith("https://"))
                return false;
            return true;
        }
    }
}
