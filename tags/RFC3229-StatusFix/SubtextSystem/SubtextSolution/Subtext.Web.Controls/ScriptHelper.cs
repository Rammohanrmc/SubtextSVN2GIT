using System;
using System.IO;
using System.Reflection;
using System.Text;

namespace Subtext.Web.Controls
{
	/// <summary>
	/// Contains helper methods for unpacking scripts 
	/// embedded as assembly resources.
	/// </summary>
	public sealed class ScriptHelper
	{
		private ScriptHelper()
		{
		}

		/// <summary>
		/// Returns a string representation of the specified embedded 
		/// script file.  The script is wrapped with script start and end tags 
		/// and assumes the script language is "vbscript" if the file extension 
		/// is ".vbs" and "javascript" otherwise.
		/// </summary>
		/// <remarks>
		/// Using a naming convention, all scripts are placed in the Resources\Scripts 
		/// folder. The scriptName should just be the filename of the script.  For example, 
		/// if you embed a file at the following location "Resources\Scripts\MyScript.js", 
		/// the scriptName to pass is "MyScript.js".
		/// </remarks>
		/// <param name="scriptName">FileName of the script.  Just the file name.</param>
		/// <returns>Contents of the script.</returns>
		public static string UnpackScript(string scriptName)
		{
			string language = "javascript";
			string extension = Path.GetExtension(scriptName);
		
			if(StringHelper.AreEqualIgnoringCase(extension, ".vbs"))
			{
				language = "vbscript";
			}
			
			return UnpackScript(scriptName, language);
		}

		/// <summary>
		/// Returns a string representation of the specified embedded 
		/// script file.  The script is wrapped with script start and end tags 
		/// and assumes the script language is "javascript".
		/// </summary>
		/// <remarks>
		/// Using a naming convention, all scripts are placed in the Resources\Scripts 
		/// folder. The scriptName should just be the filename of the script.  For example, 
		/// if you embed a file at the following location "Resources\Scripts\MyScript.js", 
		/// the scriptName to pass is "MyScript.js".
		/// </remarks>
		/// <param name="scriptName">FileName of the script.  Just the file name.</param>
		/// <param name="scriptLanguage">The script language.</param>
		/// <returns>Contents of the script.</returns>
		public static string UnpackScript(string scriptName, string scriptLanguage)
		{
			return "<script language=\"Javascript\">" 
				+ Environment.NewLine 
				+ UnpackEmbeddedResourceToString("Resources.Scripts." + scriptName) 
				+ Environment.NewLine 
				+ "</script>";
		}

		/// <summary>
		/// Unpacks the embedded resource to string.
		/// </summary>
		/// <param name="resourceName">Name of the resource.</param>
		/// <returns></returns>
		static string UnpackEmbeddedResourceToString(string resourceName)
		{
			Assembly executingAssembly = Assembly.GetExecutingAssembly();
			Stream resourceStream = executingAssembly.GetManifestResourceStream(typeof(ScriptHelper), resourceName);
			using(StreamReader reader = new StreamReader(resourceStream, Encoding.ASCII))
			{
				return reader.ReadToEnd();
			}
		}
	}
}
