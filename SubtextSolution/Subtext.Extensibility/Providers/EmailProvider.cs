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
using System.Collections.Specialized;
using System.Configuration;
using System.Net.Configuration;

namespace Subtext.Extensibility.Providers
{
	/// <summary>
	/// Provides a class used to handle email.
	/// </summary>
    public abstract class EmailProvider : System.Configuration.Provider.ProviderBase
	{
        private static EmailProvider provider;
		private static GenericProviderCollection<EmailProvider> providers = ProviderConfigurationHelper.LoadProviderCollection<EmailProvider>("Email", out provider);
		const int DefaultSmtpPort = 25;

		string name;
		string smtpServer = "localhost";
		int port = DefaultSmtpPort;
		string password;
		string userName;
		string adminEmail;

		/// <summary>
		/// Initializes the specified provider.
		/// </summary>
		/// <param name="name">Friendly Name of the provider.</param>
		/// <param name="configValue">Config value.</param>
		public override void Initialize(string name, NameValueCollection configValue)
		{
			this.name = name;

			SmtpSection smtpSettings = (SmtpSection)ConfigurationManager.GetSection("system.net/mailSettings/smtp");
			
			this.adminEmail = configValue["adminEmail"] ?? smtpSettings.From;
			this.smtpServer = configValue["smtpServer"] ?? smtpSettings.Network.Host;
			this.password = configValue["password"] ?? smtpSettings.Network.Password;
			this.userName = configValue["username"] ?? smtpSettings.Network.UserName;

			if(!int.TryParse(configValue["port"] ?? "25", out this.port))
			{
				this.port = smtpSettings.Network.Port;
			}
		}

		/// <summary>
		/// Returns the currently configured Email Provider.
		/// </summary>
		/// <returns></returns>
        public static EmailProvider Instance()
        {
            return provider;
        }
		
		/// <summary>
		/// Returns all the configured Email Providers.
		/// </summary>
		public static GenericProviderCollection<EmailProvider> Providers
		{
			get
			{
				return providers;
			}
		}

		/// <summary>
		/// Gets or sets the admin email.  This is the email address that 
		/// emails sent to a blog owner appears to be from.  It represents 
		/// the system and might not be a real address.
		/// </summary>
		/// <value></value>
		public string AdminEmail
		{
			get
			{
				return this.adminEmail;
			}
			set
			{
				this.adminEmail = value;
			}
		}

		/// <summary>
		/// Gets or sets the SMTP server.  If not specified, 
		/// defaults to "localhost";
		/// </summary>
		/// <value></value>
		public string SmtpServer
		{
			get
			{
				if (this.smtpServer == null || this.smtpServer.Length == 0)
					this.smtpServer = "localhost";
				return this.smtpServer;
			}
			set
			{
				this.smtpServer = value;
			}
		}


		/// <summary>
		/// Gets and sets the port.
		/// </summary>
		/// <value>The port.</value>
		public int Port
		{
			get { return this.port; }
			set { this.port = value; }
		}


		/// <summary>
		/// Gets or sets the password used for SMTP servers that 
		/// require authentication.
		/// </summary>
		/// <value></value>
		public string Password
		{
			get
			{
				return this.password;
			}
			set
			{
				this.password = value;
			}
		}

		/// <summary>
		/// Gets or sets the name of the user for smpt servers that require authentication.
		/// </summary>
		/// <value></value>
		public string UserName
		{
			get
			{
				return this.userName;
			}
			set
			{
				this.userName = value;
			}
		}


		/// <summary>
		/// Returns the friendly name of the provider when the provider is initialized.
		/// </summary>
		/// <value></value>
		public override string Name
		{
			get
			{
				return this.name;
			}
		}
		
		#region EmailProvider Methods
		/// <summary>
		/// Sends an email.
		/// </summary>
		/// <param name="to"></param>
		/// <param name="from"></param>
		/// <param name="subject"></param>
		/// <param name="message"></param>
		/// <returns></returns>
		public abstract bool Send(string to, string from, string subject, string message);
		#endregion
	}
}
