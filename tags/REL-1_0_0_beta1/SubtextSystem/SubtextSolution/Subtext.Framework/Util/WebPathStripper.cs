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
using System.Globalization;
using System.IO;
using System.Text.RegularExpressions;

//This might need to somehow be provider based. Or even Globalized. Not all dates will be US :)

namespace Subtext.Framework.Util
{
	/// <summary>
	/// Summary description for WebPathStripper.
	/// </summary>
	public class WebPathStripper
	{
		private WebPathStripper()
		{

		}

		public static int YearFromRequest(string uri)
		{
			return GetEntryIDFromUrl(uri);
		}

		public static DateTime GetDateFromRequest(string uri, string archiveText)
		{
			uri = uri.ToLower(System.Globalization.CultureInfo.InvariantCulture);
			uri = CleanStartDateString(uri,archiveText);
			uri = CleanEndDateString(uri);
			return DateTime.ParseExact(uri,dateFormats,new CultureInfo("en-US"),DateTimeStyles.None);
		}

		private static string CleanStartDateString(string uri, string archiveText)
		{
			return uri.Remove(0,uri.LastIndexOf(archiveText) + archiveText.Length+1);
		}

		private static string CleanEndDateString(string uri)
		{
			return Regex.Replace(uri,@"(/|\.aspx)$",string.Empty,RegexOptions.IgnoreCase);
		}

		private static readonly string[] dateFormats = {"yyyy/MM/d","yyyy/MM/dd","yyyy/M/dd","yyyy/M/d","yyyy/MM","yyyy/M"};
		


		public static bool IsNumeric(string text)
		{
			return Regex.IsMatch(text,"^\\d+$");
		}

		/// <summary>
		/// Return the value of a url between /category/ and /rss
		/// </summary>
		/// <param name="url"></param>
		/// <returns></returns>
		public static string GetCategryFromRss(string url)
		{
			url = url.ToLower(System.Globalization.CultureInfo.InvariantCulture);
			int start = url.IndexOf("/category/");
			int stop = url.IndexOf("/rss");
			return url.Substring(start+10,stop-(start+10)).Replace(".aspx",string.Empty);			
		}

		/// <summary>
		/// Removes the trailing RSS slash if there.
		/// </summary>
		/// <param name="url">URL.</param>
		/// <returns></returns>
		public static string RemoveRssSlash(string url)
		{
			if (url.EndsWith("/"))
				url = url.Substring(0,url.Length - 1);
			return Regex.Replace(url, "/rss$", string.Empty);
		}

		/// <summary>
		/// Gets the name of the requested file.
		/// </summary>
		/// <param name="uri">The URI.</param>
		/// <returns></returns>
		public static string GetRequestedFileName(string uri)
		{
			return Path.GetFileNameWithoutExtension(uri);
		}

		public static int GetEntryIDFromUrl(string uri)
		{
			try
			{
				return Int32.Parse(GetRequestedFileName(uri));
			}
			catch
			{
				throw new ArgumentException("Invalid Uri. Integer can not be found");
			}			
		}

		public static string GetBlogAppFromRequest(string path, string app)
		{
			if(!app.StartsWith("/"))
			{
				app = "/" + app;
			}
			if(!app.EndsWith("/"))
			{
				app += "/";
			}
			if(path.StartsWith(app))
			{
				path = path.Remove(0,app.Length);
			}
			int lastSlash = path.IndexOf("/");
			if(lastSlash > -1)
			{
				path = path.Remove(lastSlash,path.Length -lastSlash);
			}
			return path;
		}
	}
}
