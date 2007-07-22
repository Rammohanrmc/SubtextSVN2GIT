using System;
using System.Configuration;
using System.Data.SqlClient;
using MbUnit.Framework;
using Subtext.Framework.Configuration;
using Subtext.Installation;

namespace UnitTests.Subtext
{
	public static class AssemblySetUpAndCleanUp
	{
		[SetUp]
		public static void SetUp()
		{
			using (	SqlConnection connection = new SqlConnection(Config.ConnectionString))
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
