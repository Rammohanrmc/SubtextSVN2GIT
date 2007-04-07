using System;

namespace Subtext.Data
{
	/// <summary>
	/// Provides constants for the common SQL messages as 
	/// listed in master.dbo.sysmessages.
	/// </summary>
	public enum SqlErrorMessage
	{
		/// <summary>
		/// Specified SQL 2005 server not found:
		/// </summary>
		ErrorConnectingToDatabase = 2,

		/// <summary>
		/// Specified SQL server not found:
		/// </summary>
		SpecifiedSqlServerNotFound = 6,

		/// <summary>
		/// Sql Server does not exist or access denied.
		/// </summary>
		/// <remarks>
		/// Did not find this error in sysmessages, but did get it via 
		/// exception logging.
		/// </remarks>
		SqlServerDoesNotExistOrAccessDenied = 17,

		/// <summary>
		/// Permission is denied on an object.
		/// </summary>
		PermissionDeniedInOnObject = 229,

		/// <summary>
		/// Permission is denied on column.
		/// </summary>
		PermissionDeniedInOnColumn = 230,

		/// <summary>
		/// Permission is denied in the database.
		/// </summary>
		PermissionDeniedInDatabase = 262,

		/// <summary>
		/// Could not find the stored procedure.
		/// </summary>
		CouldNotFindStoredProcedure = 2812,

		/// <summary>
		/// User does not have permission to perform this operation on procedure.
		/// </summary>
		PermissionDeniedOnProcedure = 3704,

		/// <summary>
		/// Cannot open database requested in login '%.*ls'. Login fails.
		/// </summary>
		LoginFailsCannotOpenDatabase = 4060,

		/// <summary>
		/// Login failed for user '%ls'. Reason: Not defined as a valid user 
		/// of a trusted SQL Server connection.
		/// </summary>
		LoginFailedInvalidUserOfTrustedConnection = 18450,

		/// <summary>
		/// Login failed for user '%ls'. Reason: Not associated with a 
		/// trusted SQL Server connection.
		/// </summary>
		LoginFailedNotAssociatedWithTrustedConnection = 18452,

		/// <summary>
		/// Login failed for user '%ls'.
		/// </summary>
		LoginFailed = 18456,

		/// <summary>
		/// Login failed for user '%ls'. Reason: User name contains a 
		/// mapping character or is longer than 30 characters.
		/// </summary>
		LoginFailedUserNameInvalid = 18457,
	}
}
