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
using System.IO;
using System.Web;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;

namespace Subtext.Web.Controls
{
	/// <summary>
	/// Static class containing helper methods for various controls 
	/// that can't be placed within the control hierarchy.
	/// </summary>
	public sealed class ControlHelper
	{
		private ControlHelper()
		{}

		/// <summary>
		/// If the URL is is the format ~/SomePath, this 
		/// method expands the tilde using the app path.
		/// </summary>
		/// <param name="path"></param>
		public static string ExpandTildePath(string path)
		{
			string reference = path;
			if(reference.Substring(0, 2) == "~/")
			{
				string appPath = HttpContext.Current.Request.ApplicationPath;
				if(appPath == null)
					appPath = string.Empty;
				if(appPath.EndsWith("/"))
				{
					appPath = StringHelper.Left(appPath, appPath.Length - 1);
				}
				return appPath + reference.Substring(1);
			}
			return path;
		}

		/// <summary>
		/// Returns true if the specified attribute is defined 
		/// on the control.
		/// </summary>
		/// <param name="control">Control.</param>
		/// <param name="name">Name.</param>
		/// <returns></returns>
		public static bool IsAttributeDefined(HtmlControl control, string name)
		{
			return control.Attributes[name] != null && control.Attributes[name].Length > 0;
		}

		/// <summary>
		/// Returns true if the specified attribute is defined 
		/// on the control.
		/// </summary>
		/// <param name="control">Control.</param>
		/// <param name="name">Name.</param>
		/// <returns></returns>
		public static bool IsAttributeDefined(WebControl control, string name)
		{
			return control.Attributes[name] != null && control.Attributes[name].Length > 0;
		}

		/// <summary>
		/// Applies the specified control action recursively.
		/// </summary>
		/// <param name="controlAction">The control action.</param>
		public static void ApplyRecursively(ControlAction controlAction, Control root)
		{
			foreach(Control control in root.Controls)
			{
				controlAction(control);
				ApplyRecursively(controlAction, control);
			}
		}

		/// <summary>
		/// Recursively searches for the server form.
		/// </summary>
		/// <param name="parent">The parent.</param>
		/// <returns></returns>
		public static HtmlForm FindServerForm(ControlCollection parent)
		{
			foreach (Control child in parent)
			{                        
				Type t = child.GetType();
				if (t == typeof(System.Web.UI.HtmlControls.HtmlForm))
					return (HtmlForm)child;
            
				if (child.HasControls())   
					return FindServerForm(child.Controls);
			}
         
			return new HtmlForm();
		}

		/// <summary>
		/// Exports the specified control to excel.
		/// </summary>
		/// <remarks>
		/// Calling this function will prompt the user with a dialog 
		/// to save the trade blotter grid as an Excel file named 
		/// TradeBlotter.xls.
		/// </remarks>
		public static void ExportToExcel(Control control, string filename)
		{
			// Set the content type to Excel
			HttpContext.Current.Response.AddHeader( "Content-Disposition", "filename=" + filename); 
			HttpContext.Current.Response.ContentType = "application/vnd.ms-excel";

			control.Page.EnableViewState = false;

			//Remove the charset from the Content-Type header
			HttpContext.Current.Response.Charset = String.Empty;

			StringWriter writer = new StringWriter();
			HtmlTextWriter htmlWriter = new HtmlTextWriter(writer);
		
			//Get the HTML for the control
			control.RenderControl(htmlWriter);

			HttpContext.Current.Response.Write(writer.ToString());
			HttpContext.Current.Response.End();
		}
	}

	public delegate void ControlAction(Control control);
}
