using System;
using System.Configuration;
using System.Data.SqlClient;
using MbUnit.Framework;
using Subtext.Installation;

namespace UnitTests.Subtext
{
	public sealed class AssemblySetUpAndCleanUp
	{
		private AssemblySetUpAndCleanUp()
		{}
		
		[SetUp]
		public static void SetUp()
		{
			using (	SqlConnection connection = new SqlConnection(ConfigurationSettings.AppSettings["ConnectionString"]))
			{
				connection.Open();
				using (SqlTransaction transaction = connection.BeginTransaction())
				{
					ScriptHelper.ExecuteScript("StoredProcedures.sql", transaction);
					transaction.Commit();
				}
			}
		}
		
		[TearDown]
		public static void TearDown()
		{
			//Not sure we need anything here yet.
		}
	}
}
