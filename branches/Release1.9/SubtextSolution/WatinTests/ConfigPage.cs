using System;
using WatiN.Core;

namespace WatinTests
{
	public class ConfigPage : BrowserPageBase
	{
		internal ConfigPage(BrowserBase browser) : base(browser)
		{
			browser.GoToUrl("/Admin/Configure.aspx");
		}

		public TextField TitleField
		{
			get
			{
				return ASPTextField("txbTitle");
			}
		}

		public TextField SubtitleField
		{
			get
			{
				return ASPTextField("txbSubtitle");
			}
		}

		public TextField UsernameField
		{
			get
			{
				return ASPTextField("txbUser");
			}
		}

		public TextField OwnerName
		{
			get
			{
				return ASPTextField("txbAuthor");
			}
		}

		public TextField OwnerEmail
		{
			get
			{
				return ASPTextField("txbAuthorEmail");
			}
		}

		public void ClickSave()
		{
			ButtonByValue("Save").Click();
		}

		public void ClickNavLink(ConfigNavigationLink nav)
		{
			ClickLink(nav.ToString());
		}
	}

	public enum ConfigNavigationLink
	{
		Configure,
		Customize,
		Preferences,
		Syndication,
		Comments,
		Key_Words,
		Passwords,
	}
}
