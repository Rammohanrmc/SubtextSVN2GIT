using System;
using System.Configuration;
using System.Text.RegularExpressions;
using WatiN.Core;

namespace WatinTests
{
	public abstract class BrowserBase : IE
	{
		public static Uri HomeUrl
		{
			get
			{
				return new Uri(string.Format("http://{0}:{1}/", ConfigurationManager.AppSettings["webServer"],
									 ConfigurationManager.AppSettings["Port"]));
			}
		}
 
		public static Uri GetUrl(string relativeUrl)
		{
			return new Uri(HomeUrl, relativeUrl);
		}

		public void GoToUrl(string relativeUrl)
		{
			GoTo(GetUrl(relativeUrl));
		}

		public TextField ASPTextField(string id)
		{
			return TextField(new Regex(".*" + id));
		}

		public Button ButtonByValue(string value)
		{
			return Button(Find.ByValue(value));
		}
	}
}
