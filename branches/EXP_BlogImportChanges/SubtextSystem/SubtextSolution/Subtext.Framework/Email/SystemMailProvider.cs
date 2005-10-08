#region Disclaimer/Info
///////////////////////////////////////////////////////////////////////////////////////////////////
// .Text WebLog
// 
// .Text is an open source weblog system started by Scott Watermasysk. 
// Blog: http://ScottWater.com/blog 
// RSS: http://scottwater.com/blog/rss.aspx
// Email: Dottext@ScottWater.com
//
// For updated news and information please visit http://scottwater.com/dottext and subscribe to 
// the Rss feed @ http://scottwater.com/dottext/rss.aspx
//
// On its release (on or about August 1, 2003) this application is licensed under the BSD. However, I reserve the 
// right to change or modify this at any time. The most recent and up to date license can always be fount at:
// http://ScottWater.com/License.txt
// 
// Please direct all code related questions to:
// GotDotNet Workspace: http://www.gotdotnet.com/Community/Workspaces/workspace.aspx?id=e99fccb3-1a8c-42b5-90ee-348f6b77c407
// Yahoo Group http://groups.yahoo.com/group/DotText/
// 
///////////////////////////////////////////////////////////////////////////////////////////////////
#endregion

using System;
using System.Web.Mail;
using Subtext.Extensibility.Providers;

namespace Subtext.Framework.Email
{
	/// <summary>
	/// Default implementation of the <see cref="EmailProvider"/>.  This uses 
	/// classes in the System.Web.Mail namespace which have dependencies on 
	/// CDONTS.
	/// </summary>
	public class SystemMailProvider : EmailProviderBase
	{
		public override bool Send(string to, string from, string subject, string message)
		{
			try
			{
				MailMessage em = new MailMessage();
				em.To = to;
				em.From = from;
				em.Subject = subject;
				em.Body = message;

				// Found out how to send authenticated email via System.Web.Mail 
				// at http://SystemWebMail.com (fact 3.8)
				if(this.UserName != null && this.Password != null)
				{
					em.Fields.Add("http://schemas.microsoft.com/cdo/configuration/smtpauthenticate", "1");	//basic authentication
					em.Fields.Add("http://schemas.microsoft.com/cdo/configuration/sendusername", this.UserName); //set your username here
					em.Fields.Add("http://schemas.microsoft.com/cdo/configuration/sendpassword", this.Password);	//set your password here
				}

				SmtpMail.SmtpServer = this.SmtpServer;
				SmtpMail.Send(em);
				return true;
			}
			catch
			{
				return false;
			}
		}
	}
}

