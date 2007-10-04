using System;
using System.Text.RegularExpressions;
using MbUnit.Framework;
using WatiN.Core;

namespace WatinTests
{
	/// <summary>
	/// Use this instead of IE. It encapsulates Subtext specific logic.
	/// </summary>
	public class Browser : BrowserBase
	{
		/// <summary>
		/// Runs through the entire installation process. Assumes that the 
		/// site is not installed with a clean database.
		/// </summary>
		/// <param name="username"></param>
		/// <param name="password"></param>
		public void StepThroughInstallation(string username, string password)
		{
			GoToUrl("/");
			Assert.IsTrue(ContainsText("Welcome to the Subtext Installation Wizard"), "We don't appear to be on the installation wizard.");
			Button(Find.ByValue("On to Step 2")).Click();
			Button(Find.ByValue("Install Now!")).Click();

			Assert.IsTrue(ContainsText("Host Configuration"), "Should be on the host configuration step.");

			TextField(new Regex(".*txtUserName")).Value = username;
			TextField(new Regex(".*txtPassword")).Value = password;
			TextField(new Regex(".*txtConfirmPassword")).Value = password;

			Button(Find.ByValue("Save")).Click();
			Button(Find.ByValue("Quick Create")).Click();
		}

		public void Login(string username, string password)
		{
			ASPTextField("tbUserName").Value = username;
			ASPTextField("tbPassword").Value = password;
			ButtonByValue("Login").Click();
		}

		/// <summary>
		/// Navigates to the configure page and presents methods and 
		/// properties specific to that page.
		/// </summary>
		/// <value>The configure page.</value>
		public ConfigPage ConfigurePage
		{
			get
			{
				if(config == null)
					config = new ConfigPage(this);
				return config;
			}
		}

		private ConfigPage config = null;
	}
}
