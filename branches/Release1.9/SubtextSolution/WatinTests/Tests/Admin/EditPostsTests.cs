using System;
using System.Threading;
using MbUnit.Framework;
using WatiN.Core;

namespace WatinTests.Tests.Admin
{
	[TestFixture(ApartmentState = ApartmentState.STA)]
	public class EditPostsTests
	{
		[Test]
		public void CanCreateNewPost()
		{
			using(Browser browser = new Browser())
			{
				EditPostsPage page = browser.GoTo<EditPostsPage>();
				page.ClickNavLink(PostsNavigationLink.New_Post);
				page.TitleField.Value = "Title of the post";
				page.RichTextEditorField.Value = "Body of the post";
				page.PostButton.Click();

				HomePage home = browser.GoTo<HomePage>();
				Link link = home.GetTitleLinkByText("Title of the post");
				Assert.IsTrue(link.Exists);
				link.Click();
			}
		}

		[Test]
		public void CreateNewPostRequiresPostBody()
		{
			using (Browser browser = new Browser())
			{
				EditPostsPage page = browser.GoTo<EditPostsPage>();
				page.ClickNavLink(PostsNavigationLink.New_Post);
				page.TitleField.Value = "Title of the post";
				page.PostButton.Click();

				Assert.IsTrue(browser.ContainsText("Your post must have a body"));
			}
		}
	}
}
