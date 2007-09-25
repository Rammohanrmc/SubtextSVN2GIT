using System;
using System.Configuration;
using System.Data.SqlClient;
using System.IO;
using System.Security.Principal;
using MbUnit.Framework;
using Microsoft.SqlServer.Management.Smo;
using Subtext.Framework;
using Subtext.Framework.Configuration;
using Subtext.Installation;
using Subtext.Scripting;
using UnitTests.Subtext;

[assembly: AssemblyCleanup(typeof(AssemblySetUpAndCleanUp))]
namespace UnitTests.Subtext
{
	public static class AssemblySetUpAndCleanUp
	{
		[SetUp]
		public static void SetUp()
		{
			if (ConfigurationManager.AppSettings["connectionStringName"] == "subtextExpress")
			{
				//For use with SQL Express. If you use "subtextData", we assume you already have the database created.
				CreateAndInstallDatabase();
			}
			else
			{
				using (SqlConnection connection = new SqlConnection(Config.ConnectionString))
				{
					connection.Open();
					using (SqlTransaction transaction = connection.BeginTransaction())
					{
						ScriptHelper.ExecuteScript("StoredProcedures.sql", transaction);
						transaction.Commit();
					}
				}
			}
		}

		[TearDown]
		public static void TearDown()
		{
			if (ConfigurationManager.AppSettings["connectionStringName"] == "subtextExpress")
			{
				try
				{
					DeleteDatabase(Config.ConnectionString.Server, "Subtext_Tests");
				}
				catch(Exception e)
				{
					Console.WriteLine("Exception occurred while deleting the database. We'll get it the next time around.");
					Console.WriteLine(e);

				}
			}
		}

		private static void CreateAndInstallDatabase()
		{
			ConnectionString connectionString = Config.ConnectionString;

			DeleteDatabase(connectionString.Server, "Subtext_Tests");
			CreateDatabase(connectionString.Server, "Subtext_Tests");

			using (SqlConnection connection = new SqlConnection(connectionString))
			{
				connection.Open();
				connection.Close();
			}

			SqlInstaller installer = new SqlInstaller(connectionString);
			installer.Install(VersionInfo.FrameworkVersion);
		}

		private static void DeleteDatabase(string serverName, string databaseName)
		{
			DetachDatabase(serverName, databaseName);
			
			DeleteFile(Path.Combine(Path.GetFullPath(@"App_Data"), databaseName + ".mdf"));
			DeleteFile(Path.Combine(Path.GetFullPath(@"App_Data"), databaseName + ".ldf"));
		}

		private static void DeleteFile(string path)
		{
			if(File.Exists(path))
				File.Delete(path);
		}

		private static void CreateDatabase(string serverName, string databaseName)
		{
			Server server = null;
			try
			{
				server = new Server(serverName);
				Database db = new Database(server, databaseName);
				
				db.DatabaseOptions.AutoClose = true;
				db.DatabaseOptions.AutoShrink = true;
				db.DatabaseOptions.UserAccess = DatabaseUserAccess.Multiple;

				FileGroup fileGroup = new FileGroup(db, "PRIMARY");
				db.FileGroups.Add(fileGroup);
				DataFile dataFile = new DataFile(fileGroup, databaseName + "_Data");
				fileGroup.Files.Add(dataFile);
				dataFile.FileName = Path.Combine(Path.GetFullPath(@"App_Data"), databaseName + ".mdf");
				dataFile.Size = 5.0*1024.0;
				dataFile.Growth = 10.0;
				dataFile.GrowthType = FileGrowthType.Percent;

				LogFile logFile = new LogFile(db, databaseName + "_Log");
				db.LogFiles.Add(logFile);
				logFile.FileName = Path.Combine(Path.GetFullPath(@"App_Data"), databaseName + ".ldf");
				logFile.Size = 2.5*1024.0;
				logFile.GrowthType = FileGrowthType.Percent;
				logFile.Growth = 10.0;

				db.Create(false);

				if (!server.Logins.Contains(@"BUILTIN\Users"))
				{
					CreateLogin(server, db, @"BUILTIN\Users");
				}

				if(!db.Users.Contains("Users"))
				{
					CreateUser(db, @"BUILTIN\Users", "Users");
				}
				db.Roles["db_owner"].AddMember("Users");

				WindowsIdentity currentIdentity = WindowsIdentity.GetCurrent();
				if(!server.Logins.Contains(currentIdentity.Name))
				{
					CreateLogin(server, db, currentIdentity.Name);
				}

				User user = FindUserByLogin(db, currentIdentity.Name);
				if(user == null)
				{
					Console.WriteLine("CREATING USER");
					CreateUser(db, currentIdentity.Name, currentIdentity.Name);
				}

				server.Logins[currentIdentity.Name].AddToRole("sysadmin");
			}
			finally
			{
				if(server != null)
					server.ConnectionContext.SqlConnectionObject.Close();
			}
		}

		private static User FindUserByLogin(Database db, string login)
		{
			foreach (User user in db.Users)
			{
				if (user.Login == login)
				{
					return user;
				}
			}
			return null;
		}

		private static void CreateLogin(Server server, Database db, string loginName)
		{
			Login login = new Login(server, loginName);
			login.DefaultDatabase = db.Name;
			login.LoginType = LoginType.WindowsUser;
			login.AddToRole("sysadmin");
			login.Create();
		}

		private static void CreateUser(Database db, string login, string userName)
		{
			User user = new User(db, userName);
			user.Login = login;
			user.Create();
		}

		private static void DetachDatabase(string serverName, string databaseName)
		{
			// Initialise server object.
			Server server = new Server(serverName);

			// Check if database is current attached to sqlexpress.
			if (!server.Databases.Contains(databaseName))
				return;

			Database db = server.Databases[databaseName];
			db.DatabaseOptions.UserAccess = DatabaseUserAccess.Single;

			Console.WriteLine("DETACHING '{0}'", db.Name);
			server.KillAllProcesses(db.Name);
			
			db.Alter(TerminationClause.FailOnOpenTransactions);

			Console.WriteLine("Detaching existing database before restore ...");
			server.DetachDatabase(db.Name, false);
		}
	}
}
