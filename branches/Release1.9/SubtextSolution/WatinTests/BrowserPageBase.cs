using System;
using System.Text.RegularExpressions;
using WatiN.Core;

namespace WatinTests
{
	public abstract class BrowserPageBase
	{
		private readonly BrowserBase browser;
		
		public BrowserPageBase(BrowserBase browser)
		{
			this.browser = browser;
		}

		public BrowserBase Browser
		{
			get { return this.browser; }
		}

		public TextField ASPTextField(string id)
		{
			return browser.TextField(new Regex(".*" + id));
		}

		public Button ButtonByValue(string value)
		{
			return browser.Button(Find.ByValue(value));
		}

		public void GoToUrl(string relativeUrl)
		{
			browser.GoToUrl(relativeUrl);
		}

		public void ClickLink(string text)
		{
			browser.Link(Find.ByText(text)).Click();
		}
	}
}
