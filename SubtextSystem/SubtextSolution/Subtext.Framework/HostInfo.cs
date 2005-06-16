using System;
using System.Data.SqlClient;
using Subtext.Framework.Configuration;
using Subtext.Framework.Exceptions;
using Subtext.Framework.Providers;
using Subtext.Framework.Threading;

namespace Subtext.Framework
{
	/// <summary>
	/// Represents the system that hosts the blogs within this 
	/// Subtext installation.  This is a Singleton.
	/// </summary>
	public sealed class HostInfo
	{
		static object _synchBlock = new object();
		static HostInfo _instance = LoadHost(true);
		
		private HostInfo() {}

		/// <summary>
		/// Returns an instance of <see cref="HostInfo"/> used to 
		/// describe this installation of Subtext.
		/// </summary>
		/// <returns></returns>
		public static HostInfo Instance
		{
			get
			{
				if(_instance == null)
				{
					using(TimedLock.Lock(_synchBlock))
					{
						if(_instance == null)
							_instance = LoadHost(false);
					}
				}
				return _instance;
			}
		}

		/// <summary>
		/// Gets a value indicating whether the HostInfo table exists.
		/// </summary>
		/// <value>
		/// 	<c>true</c> if host info table exists; otherwise, <c>false</c>.
		/// </value>
		public static bool HostInfoTableExists
		{
			get
			{
				try
				{
					LoadHost(false);
					return true;
				}
				catch(HostDataDoesNotExistException)
				{
					return false;
				}
			}
		}

		/// <summary>
		/// Loads the host from the Object Provider.  This is provided 
		/// for those cases when we really need to hit the db.
		/// </summary>
		/// <param name="suppressException">If true, won't throw an exception.</param>
		/// <returns></returns>
		public static HostInfo LoadHost(bool suppressException)
		{
			try
			{
				return ObjectProvider.Instance().LoadHostInfo(new HostInfo());
			}
			catch(SqlException e)
			{
				if(e.Message.IndexOf("Invalid object name 'blog_Host'") >= 0)
				{
					if(suppressException)
						return null;
					else
						throw new HostDataDoesNotExistException();
				}
				else
					throw;
			}
		}

		/// <summary>
		/// Updates the host in the persistent store.
		/// </summary>
		/// <param name="host">Host.</param>
		/// <returns></returns>
		public static bool UpdateHost(HostInfo host)
		{
			if(ObjectProvider.Instance().UpdateHost(host))
			{
				_instance = host;
				return true;
			}
			return false;
		}

		/// <summary>
		/// Creates the host in the persistent store.
		/// </summary>
		/// <returns></returns>
		public static bool CreateHost(string hostUserName, string hostPassword)
		{
			if(HostInfo.Instance != null && HostInfo.LoadHost(true) == null)
				throw new InvalidOperationException("Cannot create a Host record.  One already exists.");

			HostInfo host = new HostInfo();
			host.HostUserName = hostUserName;
			host.Salt = Security.CreateRandomSalt();

			if(Config.Settings.UseHashedPasswords)
			{
				string hashedPassword = Security.HashPassword(hostPassword, host.Salt);
				host.Password = hashedPassword;
			}
			else
				host.Password = hostPassword;
				
			
			if(UpdateHost(host))
			{
				_instance = host;
				return true;
			}
			return false;
		}

		/// <summary>
		/// Gets or sets the name of the host user.
		/// </summary>
		/// <value></value>
		public string HostUserName
		{
			get { return _hostUserName; }
			set { _hostUserName = value; }
		}

		string _hostUserName;

		/// <summary>
		/// Gets or sets the host password.
		/// </summary>
		/// <value></value>
		public string Password
		{
			get { return _hostPassword; }
			set { _hostPassword = value; }
		}

		string _hostPassword;

		/// <summary>
		/// Gets or sets the salt.
		/// </summary>
		/// <value></value>
		public string Salt
		{
			get { return _salt; }
			set { _salt = value; }
		}

		string _salt;

		/// <summary>
		/// Gets or sets the date this record was created. 
		/// This is essentially the date that Subtext was 
		/// installed.
		/// </summary>
		/// <value></value>
		public DateTime DateCreated
		{
			get { return _dateCreated; }
			set { _dateCreated = value; }
		}

		DateTime _dateCreated;
	}
}
