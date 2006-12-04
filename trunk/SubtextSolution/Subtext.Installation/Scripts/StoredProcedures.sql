/*
WARNING: This SCRIPT USES SQL TEMPLATE PARAMETERS.
Be sure to hit CTRL+SHIFT+M in Query Analyzer if running manually.

When generating drop and create from SQL Query Analyzer, you can 
use the following search and replace expressions to convert the 
script to use information_schema.

SEARCH:  IF:b* EXISTS \(SELECT \* FROM dbo\.sysobjects WHERE id = OBJECT_ID\(N'\[[^\]]+\]\.\[{[^\]]+}\]'\) AND OBJECTPROPERTY\(id,:b*N'IsProcedure'\) = 1\)
REPLACE: IF EXISTS (SELECT * FROM [information_schema].[routines] WHERE routine_name = '\1' AND routine_schema = '<dbUser,varchar,dbo>')

*/

/* DROPPED STORED PROCS.  
	These are stored procs that used to be in the system but are no longer needed.
	The statements will only drop the procs if they exist as a form of cleanup.
*/
IF EXISTS (SELECT * FROM [information_schema].[routines] WHERE routine_name = 'subtext_UpdateHost' AND routine_schema = '<dbUser,varchar,dbo>')
DROP PROCEDURE [<dbUser,varchar,dbo>].[subtext_UpdateHost]
GO

IF EXISTS (SELECT * FROM [information_schema].[routines] WHERE routine_name = 'subtext_GetConfig' AND routine_schema = '<dbUser,varchar,dbo>')
DROP PROCEDURE [<dbUser,varchar,dbo>].[subtext_GetConfig] -- RENAMED subtext_GetConfig to subtext_GetBlog. So we're making sure to drop the old one.
GO

IF EXISTS (SELECT * FROM [information_schema].[routines] WHERE routine_name = 'subtext_GetHost' AND routine_schema = '<dbUser,varchar,dbo>')
DROP PROCEDURE [<dbUser,varchar,dbo>].[subtext_GetHost]
GO

IF EXISTS (SELECT * FROM [information_schema].[routines] WHERE routine_name = 'subtext_Utility_GetUnHashedPasswords' AND routine_schema = '<dbUser,varchar,dbo>')
DROP PROCEDURE [<dbUser,varchar,dbo>].[subtext_Utility_GetUnHashedPasswords]
GO

IF EXISTS (SELECT * FROM [information_schema].[routines] WHERE routine_name = 'subtext_Utility_UpdateToHashedPassword' AND routine_schema = '<dbUser,varchar,dbo>')
DROP PROCEDURE [<dbUser,varchar,dbo>].[subtext_Utility_UpdateToHashedPassword]
GO

IF EXISTS (SELECT * FROM [information_schema].[routines] WHERE routine_name = 'subtext_GetPageableReferrersByEntryID' AND routine_schema = '<dbUser,varchar,dbo>')
DROP PROCEDURE [<dbUser,varchar,dbo>].[subtext_GetPageableReferrersByEntryID]
GO

IF EXISTS (SELECT * FROM [information_schema].[routines] WHERE routine_name = 'subtext_GetBlogsByHost' AND routine_schema = '<dbUser,varchar,dbo>')
DROP PROCEDURE [<dbUser,varchar,dbo>].[subtext_GetBlogsByHost]
GO

IF EXISTS (SELECT * FROM [information_schema].[routines] WHERE routine_name = 'subtext_GetConditionalEntriesByDateUpdated' AND routine_schema = '<dbUser,varchar,dbo>')
DROP PROCEDURE [<dbUser,varchar,dbo>].[subtext_GetConditionalEntriesByDateUpdated]
GO

IF EXISTS (SELECT * FROM [information_schema].[routines] WHERE routine_name = 'subtext_GetEntryCollectionByDateUpdated' AND routine_schema = '<dbUser,varchar,dbo>')
DROP PROCEDURE [<dbUser,varchar,dbo>].[subtext_GetEntryCollectionByDateUpdated]
GO

IF EXISTS (SELECT * FROM [information_schema].[routines] WHERE routine_name = 'subtext_GetPostsByCategoryNameByDateUpdated' AND routine_schema = '<dbUser,varchar,dbo>')
DROP PROCEDURE [<dbUser,varchar,dbo>].[subtext_GetPostsByCategoryNameByDateUpdated]
GO

IF EXISTS (SELECT * FROM [information_schema].[routines] WHERE routine_name = 'subtext_GetPostsByCategoryIDByDateUpdated' AND routine_schema = '<dbUser,varchar,dbo>')
DROP PROCEDURE [<dbUser,varchar,dbo>].[subtext_GetPostsByCategoryIDByDateUpdated]
GO

IF EXISTS (SELECT * FROM [information_schema].[routines] WHERE routine_name = 'subtext_GetEntryWithCategoryTitlesByEntryName' AND routine_schema = '<dbUser,varchar,dbo>')
DROP PROCEDURE [<dbUser,varchar,dbo>].[subtext_GetEntryWithCategoryTitlesByEntryName]
GO

IF EXISTS (SELECT * FROM [information_schema].[routines] WHERE routine_name = 'subtext_GetPostsByCategoryName' AND routine_schema = '<dbUser,varchar,dbo>')
DROP PROCEDURE [<dbUser,varchar,dbo>].[subtext_GetPostsByCategoryName]
GO

IF EXISTS (SELECT * FROM [information_schema].[routines] WHERE routine_name = 'subtext_GetRecentEntriesByDateUpdated' AND routine_schema = '<dbUser,varchar,dbo>')
DROP PROCEDURE [<dbUser,varchar,dbo>].[subtext_GetRecentEntriesByDateUpdated]
GO

IF EXISTS (SELECT * FROM [information_schema].[routines] WHERE routine_name = 'subtext_GetRecentEntriesWithCategoryTitles' AND routine_schema = '<dbUser,varchar,dbo>')
DROP PROCEDURE [<dbUser,varchar,dbo>].[subtext_GetRecentEntriesWithCategoryTitles]
GO

IF EXISTS (SELECT * FROM [information_schema].[routines] WHERE routine_name = 'subtext_GetRecentEntries' AND routine_schema = '<dbUser,varchar,dbo>')
DROP PROCEDURE [<dbUser,varchar,dbo>].[subtext_GetRecentEntries]
GO

IF EXISTS (SELECT * FROM [information_schema].[routines] WHERE routine_name = 'subtext_GetSingleEntryByName' AND routine_schema = '<dbUser,varchar,dbo>')
DROP PROCEDURE [<dbUser,varchar,dbo>].[subtext_GetSingleEntryByName]
GO

IF EXISTS (SELECT * FROM [information_schema].[routines] WHERE routine_name = 'subtext_GetEntryWithCategoryTitles' AND routine_schema = '<dbUser,varchar,dbo>')
DROP PROCEDURE [<dbUser,varchar,dbo>].[subtext_GetEntryWithCategoryTitles]
GO

IF EXISTS (SELECT * FROM [information_schema].[routines] WHERE routine_name = 'subtext_InsertPostCategoryByName' AND routine_schema = '<dbUser,varchar,dbo>')
DROP PROCEDURE [<dbUser,varchar,dbo>].[subtext_InsertPostCategoryByName]
GO

IF EXISTS (SELECT * FROM [information_schema].[routines] WHERE routine_name = 'subtext_GetPageableLinksByCategoryID' AND routine_schema = '<dbUser,varchar,dbo>')
DROP PROCEDURE [<dbUser,varchar,dbo>].[subtext_GetPageableLinksByCategoryID]
GO

/* The Rest of the script */

-- Views
IF EXISTS (SELECT * FROM [information_schema].[views] WHERE table_name = 'vw_subtext_MembershipUsers' AND table_schema = '<dbUser,varchar,dbo>')
DROP VIEW [<dbUser,varchar,dbo>].[vw_subtext_MembershipUsers]
GO

IF EXISTS (SELECT * FROM [information_schema].[views] WHERE table_name = 'vw_subtext_Profiles' AND table_schema = '<dbUser,varchar,dbo>')
DROP VIEW [<dbUser,varchar,dbo>].[vw_subtext_Profiles]
GO

IF EXISTS (SELECT * FROM [information_schema].[views] WHERE table_name = 'vw_subtext_Roles' AND table_schema = '<dbUser,varchar,dbo>')
DROP VIEW [<dbUser,varchar,dbo>].[vw_subtext_Roles]
GO

IF EXISTS (SELECT * FROM [information_schema].[views] WHERE table_name = 'vw_subtext_UsersInRoles' AND table_schema = '<dbUser,varchar,dbo>')
DROP VIEW [<dbUser,varchar,dbo>].[vw_subtext_UsersInRoles]
GO

IF EXISTS (SELECT * FROM [information_schema].[views] WHERE table_name = 'vw_subtext_WebPartState_Paths' AND table_schema = '<dbUser,varchar,dbo>')
DROP VIEW [<dbUser,varchar,dbo>].[vw_subtext_WebPartState_Paths]
GO

IF EXISTS (SELECT * FROM [information_schema].[views] WHERE table_name = 'vw_subtext_WebPartState_Shared' AND table_schema = '<dbUser,varchar,dbo>')
DROP VIEW [<dbUser,varchar,dbo>].[vw_subtext_WebPartState_Shared]
GO

IF EXISTS (SELECT * FROM [information_schema].[views] WHERE table_name = 'vw_subtext_WebPartState_User' AND table_schema = '<dbUser,varchar,dbo>')
DROP VIEW [<dbUser,varchar,dbo>].[vw_subtext_WebPartState_User]
GO

IF EXISTS (SELECT * FROM [information_schema].[views] WHERE table_name = 'vw_subtext_Applications' AND table_schema = '<dbUser,varchar,dbo>')
DROP VIEW [<dbUser,varchar,dbo>].[vw_subtext_Applications]
GO

IF EXISTS (SELECT * FROM [information_schema].[views] WHERE table_name = 'vw_subtext_Users' AND table_schema = '<dbUser,varchar,dbo>')
DROP VIEW [<dbUser,varchar,dbo>].[vw_subtext_Users]
GO

-- Membership Provider Stored Procs
IF EXISTS (SELECT * FROM [information_schema].[routines] WHERE routine_name = 'subtext_RegisterSchemaVersion' AND routine_schema = '<dbUser,varchar,dbo>')
DROP PROCEDURE [<dbUser,varchar,dbo>].[subtext_RegisterSchemaVersion]
GO
IF EXISTS (SELECT * FROM [information_schema].[routines] WHERE routine_name = 'subtext_CheckSchemaVersion' AND routine_schema = '<dbUser,varchar,dbo>')
DROP PROCEDURE [<dbUser,varchar,dbo>].[subtext_CheckSchemaVersion]
GO
IF EXISTS (SELECT * FROM [information_schema].[routines] WHERE routine_name = 'subtext_UnRegisterSchemaVersion' AND routine_schema = '<dbUser,varchar,dbo>')
DROP PROCEDURE [<dbUser,varchar,dbo>].[subtext_UnRegisterSchemaVersion]
GO
IF EXISTS (SELECT * FROM [information_schema].[routines] WHERE routine_name = 'subtext_AnyDataInTables' AND routine_schema = '<dbUser,varchar,dbo>')
DROP PROCEDURE [<dbUser,varchar,dbo>].[subtext_AnyDataInTables]
GO
IF EXISTS (SELECT * FROM [information_schema].[routines] WHERE routine_name = 'subtext_Membership_CreateUser' AND routine_schema = '<dbUser,varchar,dbo>')
DROP PROCEDURE [<dbUser,varchar,dbo>].[subtext_Membership_CreateUser]
GO
IF EXISTS (SELECT * FROM [information_schema].[routines] WHERE routine_name = 'subtext_Membership_GetUserByName' AND routine_schema = '<dbUser,varchar,dbo>')
DROP PROCEDURE [<dbUser,varchar,dbo>].[subtext_Membership_GetUserByName]
GO
IF EXISTS (SELECT * FROM [information_schema].[routines] WHERE routine_name = 'subtext_Membership_GetUserByUserId' AND routine_schema = '<dbUser,varchar,dbo>')
DROP PROCEDURE [<dbUser,varchar,dbo>].[subtext_Membership_GetUserByUserId]
GO
IF EXISTS (SELECT * FROM [information_schema].[routines] WHERE routine_name = 'subtext_Membership_GetUserByEmail' AND routine_schema = '<dbUser,varchar,dbo>')
DROP PROCEDURE [<dbUser,varchar,dbo>].[subtext_Membership_GetUserByEmail]
GO
IF EXISTS (SELECT * FROM [information_schema].[routines] WHERE routine_name = 'subtext_Membership_GetPasswordWithFormat' AND routine_schema = '<dbUser,varchar,dbo>')
DROP PROCEDURE [<dbUser,varchar,dbo>].[subtext_Membership_GetPasswordWithFormat]
GO
IF EXISTS (SELECT * FROM [information_schema].[routines] WHERE routine_name = 'subtext_Membership_UpdateUserInfo' AND routine_schema = '<dbUser,varchar,dbo>')
DROP PROCEDURE [<dbUser,varchar,dbo>].[subtext_Membership_UpdateUserInfo]
GO
IF EXISTS (SELECT * FROM [information_schema].[routines] WHERE routine_name = 'subtext_Membership_GetPassword' AND routine_schema = '<dbUser,varchar,dbo>')
DROP PROCEDURE [<dbUser,varchar,dbo>].[subtext_Membership_GetPassword]
GO
IF EXISTS (SELECT * FROM [information_schema].[routines] WHERE routine_name = 'subtext_Membership_SetPassword' AND routine_schema = '<dbUser,varchar,dbo>')
DROP PROCEDURE [<dbUser,varchar,dbo>].[subtext_Membership_SetPassword]
GO
IF EXISTS (SELECT * FROM [information_schema].[routines] WHERE routine_name = 'subtext_Membership_ResetPassword' AND routine_schema = '<dbUser,varchar,dbo>')
DROP PROCEDURE [<dbUser,varchar,dbo>].[subtext_Membership_ResetPassword]
GO
IF EXISTS (SELECT * FROM [information_schema].[routines] WHERE routine_name = 'subtext_Membership_UnlockUser' AND routine_schema = '<dbUser,varchar,dbo>')
DROP PROCEDURE [<dbUser,varchar,dbo>].[subtext_Membership_UnlockUser]
GO
IF EXISTS (SELECT * FROM [information_schema].[routines] WHERE routine_name = 'subtext_Membership_UpdateUser' AND routine_schema = '<dbUser,varchar,dbo>')
DROP PROCEDURE [<dbUser,varchar,dbo>].[subtext_Membership_UpdateUser]
GO
IF EXISTS (SELECT * FROM [information_schema].[routines] WHERE routine_name = 'subtext_Membership_ChangePasswordQuestionAndAnswer' AND routine_schema = '<dbUser,varchar,dbo>')
DROP PROCEDURE [<dbUser,varchar,dbo>].[subtext_Membership_ChangePasswordQuestionAndAnswer]
GO
IF EXISTS (SELECT * FROM [information_schema].[routines] WHERE routine_name = 'subtext_Membership_GetAllUsers' AND routine_schema = '<dbUser,varchar,dbo>')
DROP PROCEDURE [<dbUser,varchar,dbo>].[subtext_Membership_GetAllUsers]
GO
IF EXISTS (SELECT * FROM [information_schema].[routines] WHERE routine_name = 'subtext_Membership_GetNumberOfUsersOnline' AND routine_schema = '<dbUser,varchar,dbo>')
DROP PROCEDURE [<dbUser,varchar,dbo>].[subtext_Membership_GetNumberOfUsersOnline]
GO
IF EXISTS (SELECT * FROM [information_schema].[routines] WHERE routine_name = 'subtext_Membership_FindUsersByName' AND routine_schema = '<dbUser,varchar,dbo>')
DROP PROCEDURE [<dbUser,varchar,dbo>].[subtext_Membership_FindUsersByName]
GO
IF EXISTS (SELECT * FROM [information_schema].[routines] WHERE routine_name = 'subtext_Membership_FindUsersByEmail' AND routine_schema = '<dbUser,varchar,dbo>')
DROP PROCEDURE [<dbUser,varchar,dbo>].[subtext_Membership_FindUsersByEmail]
GO
IF EXISTS (SELECT * FROM [information_schema].[routines] WHERE routine_name = 'subtext_Profile_GetProperties' AND routine_schema = '<dbUser,varchar,dbo>')
DROP PROCEDURE [<dbUser,varchar,dbo>].[subtext_Profile_GetProperties]
GO
IF EXISTS (SELECT * FROM [information_schema].[routines] WHERE routine_name = 'subtext_Profile_SetProperties' AND routine_schema = '<dbUser,varchar,dbo>')
DROP PROCEDURE [<dbUser,varchar,dbo>].[subtext_Profile_SetProperties]
GO
IF EXISTS (SELECT * FROM [information_schema].[routines] WHERE routine_name = 'subtext_Profile_DeleteProfiles' AND routine_schema = '<dbUser,varchar,dbo>')
DROP PROCEDURE [<dbUser,varchar,dbo>].[subtext_Profile_DeleteProfiles]
GO
IF EXISTS (SELECT * FROM [information_schema].[routines] WHERE routine_name = 'subtext_Profile_DeleteInactiveProfiles' AND routine_schema = '<dbUser,varchar,dbo>')
DROP PROCEDURE [<dbUser,varchar,dbo>].[subtext_Profile_DeleteInactiveProfiles]
GO
IF EXISTS (SELECT * FROM [information_schema].[routines] WHERE routine_name = 'subtext_Profile_GetNumberOfInactiveProfiles' AND routine_schema = '<dbUser,varchar,dbo>')
DROP PROCEDURE [<dbUser,varchar,dbo>].[subtext_Profile_GetNumberOfInactiveProfiles]
GO
IF EXISTS (SELECT * FROM [information_schema].[routines] WHERE routine_name = 'subtext_Profile_GetProfiles' AND routine_schema = '<dbUser,varchar,dbo>')
DROP PROCEDURE [<dbUser,varchar,dbo>].[subtext_Profile_GetProfiles]
GO
IF EXISTS (SELECT * FROM [information_schema].[routines] WHERE routine_name = 'subtext_UsersInRoles_IsUserInRole' AND routine_schema = '<dbUser,varchar,dbo>')
DROP PROCEDURE [<dbUser,varchar,dbo>].[subtext_UsersInRoles_IsUserInRole]
GO
IF EXISTS (SELECT * FROM [information_schema].[routines] WHERE routine_name = 'subtext_UsersInRoles_GetRolesForUser' AND routine_schema = '<dbUser,varchar,dbo>')
DROP PROCEDURE [<dbUser,varchar,dbo>].[subtext_UsersInRoles_GetRolesForUser]
GO
IF EXISTS (SELECT * FROM [information_schema].[routines] WHERE routine_name = 'subtext_Roles_CreateRole' AND routine_schema = '<dbUser,varchar,dbo>')
DROP PROCEDURE [<dbUser,varchar,dbo>].[subtext_Roles_CreateRole]
GO
IF EXISTS (SELECT * FROM [information_schema].[routines] WHERE routine_name = 'subtext_Roles_DeleteRole' AND routine_schema = '<dbUser,varchar,dbo>')
DROP PROCEDURE [<dbUser,varchar,dbo>].[subtext_Roles_DeleteRole]
GO
IF EXISTS (SELECT * FROM [information_schema].[routines] WHERE routine_name = 'subtext_Roles_RoleExists' AND routine_schema = '<dbUser,varchar,dbo>')
DROP PROCEDURE [<dbUser,varchar,dbo>].[subtext_Roles_RoleExists]
GO
IF EXISTS (SELECT * FROM [information_schema].[routines] WHERE routine_name = 'subtext_UsersInRoles_AddUsersToRoles' AND routine_schema = '<dbUser,varchar,dbo>')
DROP PROCEDURE [<dbUser,varchar,dbo>].[subtext_UsersInRoles_AddUsersToRoles]
GO
IF EXISTS (SELECT * FROM [information_schema].[routines] WHERE routine_name = 'subtext_UsersInRoles_RemoveUsersFromRoles' AND routine_schema = '<dbUser,varchar,dbo>')
DROP PROCEDURE [<dbUser,varchar,dbo>].[subtext_UsersInRoles_RemoveUsersFromRoles]
GO
IF EXISTS (SELECT * FROM [information_schema].[routines] WHERE routine_name = 'subtext_UsersInRoles_GetUsersInRoles' AND routine_schema = '<dbUser,varchar,dbo>')
DROP PROCEDURE [<dbUser,varchar,dbo>].[subtext_UsersInRoles_GetUsersInRoles]
GO
IF EXISTS (SELECT * FROM [information_schema].[routines] WHERE routine_name = 'subtext_UsersInRoles_FindUsersInRole' AND routine_schema = '<dbUser,varchar,dbo>')
DROP PROCEDURE [<dbUser,varchar,dbo>].[subtext_UsersInRoles_FindUsersInRole]
GO
IF EXISTS (SELECT * FROM [information_schema].[routines] WHERE routine_name = 'subtext_Roles_GetAllRoles' AND routine_schema = '<dbUser,varchar,dbo>')
DROP PROCEDURE [<dbUser,varchar,dbo>].[subtext_Roles_GetAllRoles]
GO
IF EXISTS (SELECT * FROM [information_schema].[routines] WHERE routine_name = 'subtext_PersonalizationAllUsers_GetPageSettings' AND routine_schema = '<dbUser,varchar,dbo>')
DROP PROCEDURE [<dbUser,varchar,dbo>].[subtext_PersonalizationAllUsers_GetPageSettings]
GO
IF EXISTS (SELECT * FROM [information_schema].[routines] WHERE routine_name = 'subtext_PersonalizationAllUsers_ResetPageSettings' AND routine_schema = '<dbUser,varchar,dbo>')
DROP PROCEDURE [<dbUser,varchar,dbo>].[subtext_PersonalizationAllUsers_ResetPageSettings]
GO
IF EXISTS (SELECT * FROM [information_schema].[routines] WHERE routine_name = 'subtext_PersonalizationAllUsers_SetPageSettings' AND routine_schema = '<dbUser,varchar,dbo>')
DROP PROCEDURE [<dbUser,varchar,dbo>].[subtext_PersonalizationAllUsers_SetPageSettings]
GO
IF EXISTS (SELECT * FROM [information_schema].[routines] WHERE routine_name = 'subtext_PersonalizationPerUser_GetPageSettings' AND routine_schema = '<dbUser,varchar,dbo>')
DROP PROCEDURE [<dbUser,varchar,dbo>].[subtext_PersonalizationPerUser_GetPageSettings]
GO
IF EXISTS (SELECT * FROM [information_schema].[routines] WHERE routine_name = 'subtext_PersonalizationPerUser_ResetPageSettings' AND routine_schema = '<dbUser,varchar,dbo>')
DROP PROCEDURE [<dbUser,varchar,dbo>].[subtext_PersonalizationPerUser_ResetPageSettings]
GO
IF EXISTS (SELECT * FROM [information_schema].[routines] WHERE routine_name = 'subtext_PersonalizationPerUser_SetPageSettings' AND routine_schema = '<dbUser,varchar,dbo>')
DROP PROCEDURE [<dbUser,varchar,dbo>].[subtext_PersonalizationPerUser_SetPageSettings]
GO
IF EXISTS (SELECT * FROM [information_schema].[routines] WHERE routine_name = 'subtext_PersonalizationAdministration_DeleteAllState' AND routine_schema = '<dbUser,varchar,dbo>')
DROP PROCEDURE [<dbUser,varchar,dbo>].[subtext_PersonalizationAdministration_DeleteAllState]
GO
IF EXISTS (SELECT * FROM [information_schema].[routines] WHERE routine_name = 'subtext_PersonalizationAdministration_ResetSharedState' AND routine_schema = '<dbUser,varchar,dbo>')
DROP PROCEDURE [<dbUser,varchar,dbo>].[subtext_PersonalizationAdministration_ResetSharedState]
GO
IF EXISTS (SELECT * FROM [information_schema].[routines] WHERE routine_name = 'subtext_PersonalizationAdministration_ResetUserState' AND routine_schema = '<dbUser,varchar,dbo>')
DROP PROCEDURE [<dbUser,varchar,dbo>].[subtext_PersonalizationAdministration_ResetUserState]
GO
IF EXISTS (SELECT * FROM [information_schema].[routines] WHERE routine_name = 'subtext_PersonalizationAdministration_FindState' AND routine_schema = '<dbUser,varchar,dbo>')
DROP PROCEDURE [<dbUser,varchar,dbo>].[subtext_PersonalizationAdministration_FindState]
GO
IF EXISTS (SELECT * FROM [information_schema].[routines] WHERE routine_name = 'subtext_PersonalizationAdministration_GetCountOfState' AND routine_schema = '<dbUser,varchar,dbo>')
DROP PROCEDURE [<dbUser,varchar,dbo>].[subtext_PersonalizationAdministration_GetCountOfState]
GO
IF EXISTS (SELECT * FROM [information_schema].[routines] WHERE routine_name = 'subtext_WebEvent_LogEvent' AND routine_schema = '<dbUser,varchar,dbo>')
DROP PROCEDURE [<dbUser,varchar,dbo>].[subtext_WebEvent_LogEvent]
GO
IF EXISTS (SELECT * FROM [information_schema].[routines] WHERE routine_name = 'subtext_Setup_RestorePermissions' AND routine_schema = '<dbUser,varchar,dbo>')
DROP PROCEDURE [<dbUser,varchar,dbo>].[subtext_Setup_RestorePermissions]
GO
IF EXISTS (SELECT * FROM [information_schema].[routines] WHERE routine_name = 'subtext_Setup_RemoveAllRoleMembers' AND routine_schema = '<dbUser,varchar,dbo>')
DROP PROCEDURE [<dbUser,varchar,dbo>].[subtext_Setup_RemoveAllRoleMembers]
GO
IF EXISTS (SELECT * FROM [information_schema].[routines] WHERE routine_name = 'subtext_Users_CreateUser' AND routine_schema = '<dbUser,varchar,dbo>')
DROP PROCEDURE [<dbUser,varchar,dbo>].[subtext_Users_CreateUser]
GO
IF EXISTS (SELECT * FROM [information_schema].[routines] WHERE routine_name = 'subtext_Applications_CreateApplication' AND routine_schema = '<dbUser,varchar,dbo>')
DROP PROCEDURE [<dbUser,varchar,dbo>].[subtext_Applications_CreateApplication]
GO
IF EXISTS (SELECT * FROM [information_schema].[routines] WHERE routine_name = 'subtext_Users_DeleteUser' AND routine_schema = '<dbUser,varchar,dbo>')
DROP PROCEDURE [<dbUser,varchar,dbo>].[subtext_Users_DeleteUser]
GO
IF EXISTS (SELECT * FROM [information_schema].[routines] WHERE routine_name = 'subtext_Personalization_GetApplicationId' AND routine_schema = '<dbUser,varchar,dbo>')
DROP PROCEDURE [<dbUser,varchar,dbo>].[subtext_Personalization_GetApplicationId]
GO
IF EXISTS (SELECT * FROM [information_schema].[routines] WHERE routine_name = 'subtext_Paths_CreatePath' AND routine_schema = '<dbUser,varchar,dbo>')
DROP PROCEDURE [<dbUser,varchar,dbo>].[subtext_Paths_CreatePath]

/* Note: DNW_* are the aggregate blog procs */
IF EXISTS (SELECT * FROM [information_schema].[routines] WHERE routine_name = 'DNW_GetRecentPosts' AND routine_schema = '<dbUser,varchar,dbo>')
DROP PROCEDURE [<dbUser,varchar,dbo>].[DNW_GetRecentPosts]
GO

IF EXISTS (SELECT * FROM [information_schema].[routines] WHERE routine_name = 'DNW_HomePageData' AND routine_schema = '<dbUser,varchar,dbo>')
DROP PROCEDURE [<dbUser,varchar,dbo>].[DNW_HomePageData]
GO

IF EXISTS (SELECT * FROM [information_schema].[routines] WHERE routine_name = 'DNW_Stats' AND routine_schema = '<dbUser,varchar,dbo>')
DROP PROCEDURE [<dbUser,varchar,dbo>].[DNW_Stats]
GO

IF EXISTS (SELECT * FROM [information_schema].[routines] WHERE routine_name = 'DNW_Total_Stats' AND routine_schema = '<dbUser,varchar,dbo>')
DROP PROCEDURE [<dbUser,varchar,dbo>].[DNW_Total_Stats]
GO

IF EXISTS (SELECT * FROM [information_schema].[routines] WHERE routine_name = 'iter_charlist_to_table' AND routine_schema = '<dbUser,varchar,dbo>')
DROP FUNCTION [<dbUser,varchar,dbo>].[iter_charlist_to_table]
GO

IF EXISTS (SELECT * FROM [information_schema].[routines] WHERE routine_name = 'subtext_CreateHost' AND routine_schema = '<dbUser,varchar,dbo>')
DROP PROCEDURE [<dbUser,varchar,dbo>].[subtext_CreateHost]
GO

IF EXISTS (SELECT * FROM [information_schema].[routines] WHERE routine_name = 'subtext_VersionAdd' AND routine_schema = '<dbUser,varchar,dbo>')
DROP PROCEDURE [<dbUser,varchar,dbo>].[subtext_VersionAdd]
GO

IF EXISTS (SELECT * FROM [information_schema].[routines] WHERE routine_name = 'subtext_VersionGetCurrent' AND routine_schema = '<dbUser,varchar,dbo>')
DROP PROCEDURE [<dbUser,varchar,dbo>].[subtext_VersionGetCurrent]
GO

IF EXISTS (SELECT * FROM [information_schema].[routines] WHERE routine_name = 'subtext_GetCommentByChecksumHash' AND routine_schema = '<dbUser,varchar,dbo>')
DROP PROCEDURE [<dbUser,varchar,dbo>].[subtext_GetCommentByChecksumHash]
GO

IF EXISTS (SELECT * FROM [information_schema].[routines] WHERE routine_name = 'subtext_GetPageableBlogs' AND routine_schema = '<dbUser,varchar,dbo>')
DROP PROCEDURE [<dbUser,varchar,dbo>].[subtext_GetPageableBlogs]
GO

IF EXISTS (SELECT * FROM [information_schema].[routines] WHERE routine_name = 'subtext_GetBlogById' AND routine_schema = '<dbUser,varchar,dbo>')
DROP PROCEDURE [<dbUser,varchar,dbo>].[subtext_GetBlogById]
GO

IF EXISTS (SELECT * FROM [information_schema].[routines] WHERE routine_name = 'subtext_DeleteCategory' AND routine_schema = '<dbUser,varchar,dbo>')
DROP PROCEDURE [<dbUser,varchar,dbo>].[subtext_DeleteCategory]
GO

IF EXISTS (SELECT * FROM [information_schema].[routines] WHERE routine_name = 'subtext_DeleteImage' AND routine_schema = '<dbUser,varchar,dbo>')
DROP PROCEDURE [<dbUser,varchar,dbo>].[subtext_DeleteImage]
GO

IF EXISTS (SELECT * FROM [information_schema].[routines] WHERE routine_name = 'subtext_DeleteImageCategory' AND routine_schema = '<dbUser,varchar,dbo>')
DROP PROCEDURE [<dbUser,varchar,dbo>].[subtext_DeleteImageCategory]
GO

IF EXISTS (SELECT * FROM [information_schema].[routines] WHERE routine_name = 'subtext_DeleteKeyWord' AND routine_schema = '<dbUser,varchar,dbo>')
DROP PROCEDURE [<dbUser,varchar,dbo>].[subtext_DeleteKeyWord]
GO

IF EXISTS (SELECT * FROM [information_schema].[routines] WHERE routine_name = 'subtext_DeleteLink' AND routine_schema = '<dbUser,varchar,dbo>')
DROP PROCEDURE [<dbUser,varchar,dbo>].[subtext_DeleteLink]
GO

IF EXISTS (SELECT * FROM [information_schema].[routines] WHERE routine_name = 'subtext_DeleteLinksByPostID' AND routine_schema = '<dbUser,varchar,dbo>')
DROP PROCEDURE [<dbUser,varchar,dbo>].[subtext_DeleteLinksByPostID]
GO

IF EXISTS (SELECT * FROM [information_schema].[routines] WHERE routine_name = 'subtext_DeletePost' AND routine_schema = '<dbUser,varchar,dbo>')
DROP PROCEDURE [<dbUser,varchar,dbo>].[subtext_DeletePost]
GO

IF EXISTS (SELECT * FROM [information_schema].[routines] WHERE routine_name = 'subtext_DeleteFeedbackByStatus' AND routine_schema = '<dbUser,varchar,dbo>')
DROP PROCEDURE [<dbUser,varchar,dbo>].[subtext_DeleteFeedbackByStatus]
GO

IF EXISTS (SELECT * FROM [information_schema].[routines] WHERE routine_name = 'subtext_DeleteFeedback' AND routine_schema = '<dbUser,varchar,dbo>')
DROP PROCEDURE [<dbUser,varchar,dbo>].[subtext_DeleteFeedback]
GO

IF EXISTS (SELECT * FROM [information_schema].[routines] WHERE routine_name = 'subtext_GetActiveCategoriesWithLinkCollection' AND routine_schema = '<dbUser,varchar,dbo>')
DROP PROCEDURE [<dbUser,varchar,dbo>].[subtext_GetActiveCategoriesWithLinkCollection]
GO

IF EXISTS (SELECT * FROM [information_schema].[routines] WHERE routine_name = 'subtext_GetAllCategories' AND routine_schema = '<dbUser,varchar,dbo>')
DROP PROCEDURE [<dbUser,varchar,dbo>].[subtext_GetAllCategories]
GO

IF EXISTS (SELECT * FROM [information_schema].[routines] WHERE routine_name = 'subtext_GetBlogKeyWords' AND routine_schema = '<dbUser,varchar,dbo>')
DROP PROCEDURE [<dbUser,varchar,dbo>].[subtext_GetBlogKeyWords]
GO

IF EXISTS (SELECT * FROM [information_schema].[routines] WHERE routine_name = 'subtext_GetCategory' AND routine_schema = '<dbUser,varchar,dbo>')
DROP PROCEDURE [<dbUser,varchar,dbo>].[subtext_GetCategory]
GO

IF EXISTS (SELECT * FROM [information_schema].[routines] WHERE routine_name = 'subtext_GetCategoryByName' AND routine_schema = '<dbUser,varchar,dbo>')
DROP PROCEDURE [<dbUser,varchar,dbo>].[subtext_GetCategoryByName]
GO

IF EXISTS (SELECT * FROM [information_schema].[routines] WHERE routine_name = 'subtext_GetConditionalEntries' AND routine_schema = '<dbUser,varchar,dbo>')
DROP PROCEDURE [<dbUser,varchar,dbo>].[subtext_GetConditionalEntries]
GO

IF EXISTS (SELECT * FROM [information_schema].[routines] WHERE routine_name = 'subtext_GetBlog' AND routine_schema = '<dbUser,varchar,dbo>')
DROP PROCEDURE [<dbUser,varchar,dbo>].[subtext_GetBlog]
GO

IF EXISTS (SELECT * FROM [information_schema].[routines] WHERE routine_name = 'subtext_GetEntriesByDayRange' AND routine_schema = '<dbUser,varchar,dbo>')
DROP PROCEDURE [<dbUser,varchar,dbo>].[subtext_GetEntriesByDayRange]
GO

IF EXISTS (SELECT * FROM [information_schema].[routines] WHERE routine_name = 'subtext_GetFeedbackCollection' AND routine_schema = '<dbUser,varchar,dbo>')
DROP PROCEDURE [<dbUser,varchar,dbo>].[subtext_GetFeedbackCollection]
GO

IF EXISTS (SELECT * FROM [information_schema].[routines] WHERE routine_name = 'subtext_GetFeedbackCountsByStatus' AND routine_schema = '<dbUser,varchar,dbo>')
DROP PROCEDURE [<dbUser,varchar,dbo>].[subtext_GetFeedbackCountsByStatus]
GO

IF EXISTS (SELECT * FROM [information_schema].[routines] WHERE routine_name = 'subtext_GetFeedback' AND routine_schema = '<dbUser,varchar,dbo>')
DROP PROCEDURE [<dbUser,varchar,dbo>].[subtext_GetFeedback]
GO

IF EXISTS (SELECT * FROM [information_schema].[routines] WHERE routine_name = 'subtext_GetImageCategory' AND routine_schema = '<dbUser,varchar,dbo>')
DROP PROCEDURE [<dbUser,varchar,dbo>].[subtext_GetImageCategory]
GO

IF EXISTS (SELECT * FROM [information_schema].[routines] WHERE routine_name = 'subtext_GetKeyWord' AND routine_schema = '<dbUser,varchar,dbo>')
DROP PROCEDURE [<dbUser,varchar,dbo>].[subtext_GetKeyWord]
GO

IF EXISTS (SELECT * FROM [information_schema].[routines] WHERE routine_name = 'subtext_GetLinkCollectionByPostID' AND routine_schema = '<dbUser,varchar,dbo>')
DROP PROCEDURE [<dbUser,varchar,dbo>].[subtext_GetLinkCollectionByPostID]
GO

IF EXISTS (SELECT * FROM [information_schema].[routines] WHERE routine_name = 'subtext_GetLinksByActiveCategoryID' AND routine_schema = '<dbUser,varchar,dbo>')
DROP PROCEDURE [<dbUser,varchar,dbo>].[subtext_GetLinksByActiveCategoryID]
GO

IF EXISTS (SELECT * FROM [information_schema].[routines] WHERE routine_name = 'subtext_GetLinksByCategoryID' AND routine_schema = '<dbUser,varchar,dbo>')
DROP PROCEDURE [<dbUser,varchar,dbo>].[subtext_GetLinksByCategoryID]
GO

IF EXISTS (SELECT * FROM [information_schema].[routines] WHERE routine_name = 'subtext_GetPageableEntries' AND routine_schema = '<dbUser,varchar,dbo>')
DROP PROCEDURE [<dbUser,varchar,dbo>].[subtext_GetPageableEntries]
GO

IF EXISTS (SELECT * FROM [information_schema].[routines] WHERE routine_name = 'subtext_GetEntriesForBlogMl' AND routine_schema = '<dbUser,varchar,dbo>')
DROP PROCEDURE [<dbUser,varchar,dbo>].[subtext_GetEntriesForBlogMl]
GO

IF EXISTS (SELECT * FROM [information_schema].[routines] WHERE routine_name = 'subtext_GetPageableEntriesByCategoryID' AND routine_schema = '<dbUser,varchar,dbo>')
DROP PROCEDURE [<dbUser,varchar,dbo>].[subtext_GetPageableEntriesByCategoryID]
GO

IF EXISTS (SELECT * FROM [information_schema].[routines] WHERE routine_name = 'subtext_GetPageableFeedback' AND routine_schema = '<dbUser,varchar,dbo>')
DROP PROCEDURE [<dbUser,varchar,dbo>].[subtext_GetPageableFeedback]
GO

IF EXISTS (SELECT * FROM [information_schema].[routines] WHERE routine_name = 'subtext_GetPageableLogEntries' AND routine_schema = '<dbUser,varchar,dbo>')
DROP PROCEDURE [<dbUser,varchar,dbo>].[subtext_GetPageableLogEntries]
GO

IF EXISTS (SELECT * FROM [information_schema].[routines] WHERE routine_name = 'subtext_GetPageableKeyWords' AND routine_schema = '<dbUser,varchar,dbo>')
DROP PROCEDURE [<dbUser,varchar,dbo>].[subtext_GetPageableKeyWords]
GO

IF EXISTS (SELECT * FROM [information_schema].[routines] WHERE routine_name = 'subtext_GetPageableLinks' AND routine_schema = '<dbUser,varchar,dbo>')
DROP PROCEDURE [<dbUser,varchar,dbo>].[subtext_GetPageableLinks]
GO

IF EXISTS (SELECT * FROM [information_schema].[routines] WHERE routine_name = 'subtext_GetPageableReferrers' AND routine_schema = '<dbUser,varchar,dbo>')
DROP PROCEDURE [<dbUser,varchar,dbo>].[subtext_GetPageableReferrers]
GO

IF EXISTS (SELECT * FROM [information_schema].[routines] WHERE routine_name = 'subtext_GetPostsByCategoryID' AND routine_schema = '<dbUser,varchar,dbo>')
DROP PROCEDURE [<dbUser,varchar,dbo>].[subtext_GetPostsByCategoryID]
GO

IF EXISTS (SELECT * FROM [information_schema].[routines] WHERE routine_name = 'subtext_GetPostsByDayRange' AND routine_schema = '<dbUser,varchar,dbo>')
DROP PROCEDURE [<dbUser,varchar,dbo>].[subtext_GetPostsByDayRange]
GO

IF EXISTS (SELECT * FROM [information_schema].[routines] WHERE routine_name = 'subtext_GetPostsByMonth' AND routine_schema = '<dbUser,varchar,dbo>')
DROP PROCEDURE [<dbUser,varchar,dbo>].[subtext_GetPostsByMonth]
GO

IF EXISTS (SELECT * FROM [information_schema].[routines] WHERE routine_name = 'subtext_GetPostsByMonthArchive' AND routine_schema = '<dbUser,varchar,dbo>')
DROP PROCEDURE [<dbUser,varchar,dbo>].[subtext_GetPostsByMonthArchive]
GO

IF EXISTS (SELECT * FROM [information_schema].[routines] WHERE routine_name = 'subtext_GetPostsByYearArchive' AND routine_schema = '<dbUser,varchar,dbo>')
DROP PROCEDURE [<dbUser,varchar,dbo>].[subtext_GetPostsByYearArchive]
GO

IF EXISTS (SELECT * FROM [information_schema].[routines] WHERE routine_name = 'subtext_GetSingleDay' AND routine_schema = '<dbUser,varchar,dbo>')
DROP PROCEDURE [<dbUser,varchar,dbo>].[subtext_GetSingleDay]
GO

IF EXISTS (SELECT * FROM [information_schema].[routines] WHERE routine_name = 'subtext_GetSingleEntry' AND routine_schema = '<dbUser,varchar,dbo>')
DROP PROCEDURE [<dbUser,varchar,dbo>].[subtext_GetSingleEntry]
GO

IF EXISTS (SELECT * FROM [information_schema].[routines] WHERE routine_name = 'subtext_GetSingleImage' AND routine_schema = '<dbUser,varchar,dbo>')
DROP PROCEDURE [<dbUser,varchar,dbo>].[subtext_GetSingleImage]
GO

IF EXISTS (SELECT * FROM [information_schema].[routines] WHERE routine_name = 'subtext_GetSingleLink' AND routine_schema = '<dbUser,varchar,dbo>')
DROP PROCEDURE [<dbUser,varchar,dbo>].[subtext_GetSingleLink]
GO

IF EXISTS (SELECT * FROM [information_schema].[routines] WHERE routine_name = 'subtext_GetUrlID' AND routine_schema = '<dbUser,varchar,dbo>')
DROP PROCEDURE [<dbUser,varchar,dbo>].[subtext_GetUrlID]
GO

IF EXISTS (SELECT * FROM [information_schema].[routines] WHERE routine_name = 'subtext_InsertCategory' AND routine_schema = '<dbUser,varchar,dbo>')
DROP PROCEDURE [<dbUser,varchar,dbo>].[subtext_InsertCategory]
GO

IF EXISTS (SELECT * FROM [information_schema].[routines] WHERE routine_name = 'subtext_InsertEntry' AND routine_schema = '<dbUser,varchar,dbo>')
DROP PROCEDURE [<dbUser,varchar,dbo>].[subtext_InsertEntry]
GO

IF EXISTS (SELECT * FROM [information_schema].[routines] WHERE routine_name = 'subtext_InsertEntryViewCount' AND routine_schema = '<dbUser,varchar,dbo>')
DROP PROCEDURE [<dbUser,varchar,dbo>].[subtext_InsertEntryViewCount]
GO

IF EXISTS (SELECT * FROM [information_schema].[routines] WHERE routine_name = 'subtext_InsertImage' AND routine_schema = '<dbUser,varchar,dbo>')
DROP PROCEDURE [<dbUser,varchar,dbo>].[subtext_InsertImage]
GO

IF EXISTS (SELECT * FROM [information_schema].[routines] WHERE routine_name = 'subtext_InsertKeyWord' AND routine_schema = '<dbUser,varchar,dbo>')
DROP PROCEDURE [<dbUser,varchar,dbo>].[subtext_InsertKeyWord]
GO

IF EXISTS (SELECT * FROM [information_schema].[routines] WHERE routine_name = 'subtext_InsertLink' AND routine_schema = '<dbUser,varchar,dbo>')
DROP PROCEDURE [<dbUser,varchar,dbo>].[subtext_InsertLink]
GO

IF EXISTS (SELECT * FROM [information_schema].[routines] WHERE routine_name = 'subtext_InsertLinkCategoryList' AND routine_schema = '<dbUser,varchar,dbo>')
DROP PROCEDURE [<dbUser,varchar,dbo>].[subtext_InsertLinkCategoryList]
GO

IF EXISTS (SELECT * FROM [information_schema].[routines] WHERE routine_name = 'subtext_InsertFeedback' AND routine_schema = '<dbUser,varchar,dbo>')
DROP PROCEDURE [<dbUser,varchar,dbo>].[subtext_InsertFeedback]
GO

IF EXISTS (SELECT * FROM [information_schema].[routines] WHERE routine_name = 'subtext_UpdateFeedbackCount' AND routine_schema = '<dbUser,varchar,dbo>')
DROP PROCEDURE [<dbUser,varchar,dbo>].[subtext_UpdateFeedbackCount]
GO

IF EXISTS (SELECT * FROM [information_schema].[routines] WHERE routine_name = 'subtext_UpdateFeedback' AND routine_schema = '<dbUser,varchar,dbo>')
DROP PROCEDURE [<dbUser,varchar,dbo>].[subtext_UpdateFeedback]
GO

IF EXISTS (SELECT * FROM [information_schema].[routines] WHERE routine_name = 'subtext_InsertReferral' AND routine_schema = '<dbUser,varchar,dbo>')
DROP PROCEDURE [<dbUser,varchar,dbo>].[subtext_InsertReferral]
GO

IF EXISTS (SELECT * FROM [information_schema].[routines] WHERE routine_name = 'subtext_InsertViewStats' AND routine_schema = '<dbUser,varchar,dbo>')
DROP PROCEDURE [<dbUser,varchar,dbo>].[subtext_InsertViewStats]
GO

IF EXISTS (SELECT * FROM [information_schema].[routines] WHERE routine_name = 'subtext_StatsSummary' AND routine_schema = '<dbUser,varchar,dbo>')
DROP PROCEDURE [<dbUser,varchar,dbo>].[subtext_StatsSummary]
GO

IF EXISTS (SELECT * FROM [information_schema].[routines] WHERE routine_name = 'subtext_TrackEntry' AND routine_schema = '<dbUser,varchar,dbo>')
DROP PROCEDURE [<dbUser,varchar,dbo>].[subtext_TrackEntry]
GO

IF EXISTS (SELECT * FROM [information_schema].[routines] WHERE routine_name = 'subtext_UTILITY_AddBlog' AND routine_schema = '<dbUser,varchar,dbo>')
DROP PROCEDURE [<dbUser,varchar,dbo>].[subtext_UTILITY_AddBlog]
GO

IF EXISTS (SELECT * FROM [information_schema].[routines] WHERE routine_name = 'subtext_UpdateCategory' AND routine_schema = '<dbUser,varchar,dbo>')
DROP PROCEDURE [<dbUser,varchar,dbo>].[subtext_UpdateCategory]
GO

IF EXISTS (SELECT * FROM [information_schema].[routines] WHERE routine_name = 'subtext_UpdateConfig' AND routine_schema = '<dbUser,varchar,dbo>')
DROP PROCEDURE [<dbUser,varchar,dbo>].[subtext_UpdateConfig]
GO

IF EXISTS (SELECT * FROM [information_schema].[routines] WHERE routine_name = 'subtext_UpdateConfigUpdateTime' AND routine_schema = '<dbUser,varchar,dbo>')
DROP PROCEDURE [<dbUser,varchar,dbo>].[subtext_UpdateConfigUpdateTime]
GO

IF EXISTS (SELECT * FROM [information_schema].[routines] WHERE routine_name = 'subtext_UpdateEntry' AND routine_schema = '<dbUser,varchar,dbo>')
DROP PROCEDURE [<dbUser,varchar,dbo>].[subtext_UpdateEntry]
GO

IF EXISTS (SELECT * FROM [information_schema].[routines] WHERE routine_name = 'subtext_UpdateImage' AND routine_schema = '<dbUser,varchar,dbo>')
DROP PROCEDURE [<dbUser,varchar,dbo>].[subtext_UpdateImage]
GO

IF EXISTS (SELECT * FROM [information_schema].[routines] WHERE routine_name = 'subtext_UpdateKeyWord' AND routine_schema = '<dbUser,varchar,dbo>')
DROP PROCEDURE [<dbUser,varchar,dbo>].[subtext_UpdateKeyWord]
GO

IF EXISTS (SELECT * FROM [information_schema].[routines] WHERE routine_name = 'subtext_UpdateLink' AND routine_schema = '<dbUser,varchar,dbo>')
DROP PROCEDURE [<dbUser,varchar,dbo>].[subtext_UpdateLink]
GO

IF EXISTS (SELECT * FROM [information_schema].[routines] WHERE routine_name = 'subtext_AddLogEntry' AND routine_schema = '<dbUser,varchar,dbo>')
DROP PROCEDURE [<dbUser,varchar,dbo>].[subtext_AddLogEntry]
GO

IF EXISTS (SELECT * FROM [information_schema].[routines] WHERE routine_name = 'subtext_LogClear' AND routine_schema = '<dbUser,varchar,dbo>')
DROP PROCEDURE [<dbUser,varchar,dbo>].[subtext_LogClear]
GO

IF EXISTS (SELECT * FROM [information_schema].[routines] WHERE routine_name = 'subtext_SearchEntries' AND routine_schema = '<dbUser,varchar,dbo>')
DROP PROCEDURE [<dbUser,varchar,dbo>].[subtext_SearchEntries]
GO

IF EXISTS (SELECT * FROM [information_schema].[routines] WHERE routine_name = 'subtext_GetRelatedLinks' AND routine_schema = '<dbUser,varchar,dbo>')
DROP PROCEDURE [<dbUser,varchar,dbo>].[subtext_GetRelatedLinks]
GO

IF EXISTS (SELECT * FROM [information_schema].[routines] WHERE routine_name = 'subtext_GetTop10byBlogId' AND routine_schema = '<dbUser,varchar,dbo>')
DROP PROCEDURE [<dbUser,varchar,dbo>].[subtext_GetTop10byBlogId]
GO

IF EXISTS (SELECT * FROM [information_schema].[routines] WHERE routine_name = 'subtext_GetPostsByCategoriesArchive' AND routine_schema = '<dbUser,varchar,dbo>')
DROP PROCEDURE [<dbUser,varchar,dbo>].subtext_GetPostsByCategoriesArchive
GO

if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_TYPE = 'PROCEDURE' and OBJECTPROPERTY(OBJECT_ID(ROUTINE_NAME), 'IsMsShipped') = 0 and ROUTINE_SCHEMA = '<dbUser,varchar,dbo>' AND ROUTINE_NAME = 'subtext_ClearBlogContent')
DROP PROCEDURE [<dbUser,varchar,dbo>].[subtext_ClearBlogContent]
GO

IF EXISTS (SELECT * FROM [information_schema].[routines] WHERE routine_name = 'subtext_InsertPluginData' AND routine_schema = '<dbUser,varchar,dbo>')
DROP PROCEDURE [<dbUser,varchar,dbo>].[subtext_InsertPluginData]
GO

IF EXISTS (SELECT * FROM [information_schema].[routines] WHERE routine_name = 'subtext_UpdatePluginData' AND routine_schema = '<dbUser,varchar,dbo>')
DROP PROCEDURE [<dbUser,varchar,dbo>].[subtext_UpdatePluginData]
GO

IF EXISTS (SELECT * FROM [information_schema].[routines] WHERE routine_name = 'subtext_DeletePluginBlog' AND routine_schema = '<dbUser,varchar,dbo>')
DROP PROCEDURE [<dbUser,varchar,dbo>].[subtext_DeletePluginBlog]
GO

IF EXISTS (SELECT * FROM [information_schema].[routines] WHERE routine_name = 'subtext_GetPluginBlog' AND routine_schema = '<dbUser,varchar,dbo>')
DROP PROCEDURE [<dbUser,varchar,dbo>].[subtext_GetPluginBlog]
GO

IF EXISTS (SELECT * FROM [information_schema].[routines] WHERE routine_name = 'subtext_InsertPluginBlog' AND routine_schema = '<dbUser,varchar,dbo>')
DROP PROCEDURE [<dbUser,varchar,dbo>].[subtext_InsertPluginBlog]
GO

IF EXISTS (SELECT * FROM [information_schema].[routines] WHERE routine_name = 'subtext_GetPluginData' AND routine_schema = '<dbUser,varchar,dbo>')
DROP PROCEDURE [<dbUser,varchar,dbo>].[subtext_GetPluginData]
GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS OFF 
GO

--Found at: http://www.algonet.se/~sommar/arrays-in-sql.html
  CREATE FUNCTION [<dbUser,varchar,dbo>].[iter_charlist_to_table]
                    (@list      ntext,
                     @delimiter nchar(1) = N',')
         RETURNS @tbl TABLE (listpos int IDENTITY(1, 1) NOT NULL,
                             str     varchar(4000),
                             nstr    nvarchar(2000)) AS

   BEGIN
      DECLARE @pos      int,
              @textpos  int,
              @chunklen smallint,
              @tmpstr   nvarchar(4000),
              @leftover nvarchar(4000),
              @tmpval   nvarchar(4000)

      SET @textpos = 1 
           SET @leftover = ''
                 WHILE @textpos <= datalength(@list) / 2
                       BEGIN
         SET @chunklen = 4000 - datalength(@leftover) / 2
         SET @tmpstr = @leftover + substring(@list, @textpos, @chunklen)
         SET @textpos = @textpos + @chunklen

         SET @pos = charindex(@delimiter, @tmpstr)

         WHILE @pos > 0
         BEGIN
            SET @tmpval = ltrim(rtrim(left(@tmpstr, @pos - 1)))
            INSERT @tbl (str, nstr) VALUES(@tmpval, @tmpval)
            SET @tmpstr = substring(@tmpstr, @pos + 1, len(@tmpstr))
            SET @pos = charindex(@delimiter, @tmpstr)
         END

         SET @leftover = @tmpstr
      END

      INSERT @tbl(str, nstr) VALUES (ltrim(rtrim(@leftover)), ltrim(rtrim(@leftover)))
   RETURN
   END

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

/*
Returns a single blog within the subtext_config table by id.
*/
CREATE PROC [<dbUser,varchar,dbo>].[subtext_GetBlogById]
(
	@BlogId int
)
AS

SELECT	BlogId 
		, ApplicationId
		, OwnerId
		, Title
		, SubTitle
		, Skin
		, Subfolder
		, Host
		, TimeZone
		, ItemCount
		, [Language]
		, News
		, SecondaryCss
		, LastUpdated
		, PostCount
		, StoryCount
		, PingTrackCount
		, CommentCount
		, IsAggregated
		, Flag
		, SkinCssFile 
		, BlogGroup
		, LicenseUrl
		, DaysTillCommentsClose
		, CommentDelayInMinutes
		, NumberOfRecentComments
		, RecentCommentsLength
		, AkismetAPIKey
		, FeedBurnerName
		, pop3User
		, pop3Pass
		, pop3Server
		, pop3StartTag
		, pop3EndTag
		, pop3SubjectPrefix
		, pop3MTBEnable
		, pop3DeleteOnlyProcessed
		, pop3InlineAttachedPictures
		, pop3HeightForThumbs
		
FROM [<dbUser,varchar,dbo>].[subtext_config]
WHERE	BlogId = @BlogId
GO


GRANT  EXECUTE  ON [<dbUser,varchar,dbo>].[subtext_GetBlogById]  TO [public]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO
CREATE PROC [<dbUser,varchar,dbo>].[subtext_UpdateFeedbackCount]
(
	@BlogId int
	,@EntryId int
)
AS
	-- Update the entry comment count.
	UPDATE [<dbUser,varchar,dbo>].[subtext_Content] 
	SET [<dbUser,varchar,dbo>].[subtext_Content].FeedbackCount = 
		(
			SELECT COUNT(1) 
			FROM  [<dbUser,varchar,dbo>].[subtext_Feedback] f  WITH (NOLOCK)
			WHERE f.EntryId = @EntryId 
				AND f.StatusFlag & 1 = 1
		)
	WHERE Id = @EntryId

	-- Update the blog comment count.
	UPDATE [<dbUser,varchar,dbo>].[subtext_Config] 
	SET CommentCount = 
		(
			SELECT COUNT(1) 
			FROM  [<dbUser,varchar,dbo>].[subtext_Feedback] f WITH (NOLOCK)
			WHERE f.BlogId = @BlogId
				AND f.StatusFlag & 1 = 1
				AND f.FeedbackType = 1
		)
	WHERE BlogId = @BlogId
	
	-- Update the blog trackback count.
	UPDATE [<dbUser,varchar,dbo>].[subtext_Config] 
	SET PingTrackCount = 
		(
			SELECT COUNT(1) 
			FROM  [<dbUser,varchar,dbo>].[subtext_Feedback] f WITH (NOLOCK)
			WHERE f.BlogId = @BlogId
				AND f.StatusFlag & 1 = 1
				AND f.FeedbackType = 2
		)
	WHERE BlogId = @BlogId

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

GRANT  EXECUTE  ON [<dbUser,varchar,dbo>].[subtext_UpdateFeedbackCount] TO [public]
GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

CREATE PROC [<dbUser,varchar,dbo>].[subtext_DeleteCategory]
(
	@CategoryID int,
	@BlogId int
)
AS
DELETE [<dbUser,varchar,dbo>].[subtext_Links] FROM [<dbUser,varchar,dbo>].[subtext_Links] WHERE CategoryID = @CategoryID AND BlogId = @BlogId
DELETE [<dbUser,varchar,dbo>].[subtext_LinkCategories] FROM [<dbUser,varchar,dbo>].[subtext_LinkCategories] WHERE subtext_LinkCategories.CategoryID = @CategoryID AND subtext_LinkCategories.BlogId = @BlogId


GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

GRANT  EXECUTE  ON [<dbUser,varchar,dbo>].[subtext_DeleteCategory]  TO [public]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO


CREATE PROC [<dbUser,varchar,dbo>].[subtext_DeleteImage]
(
	@BlogId int,
	@ImageID int
)
AS
DELETE [<dbUser,varchar,dbo>].[subtext_Images] 
FROM [<dbUser,varchar,dbo>].[subtext_Images] 
WHERE	ImageID = @ImageID 
	AND BlogId = @BlogId


GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

GRANT  EXECUTE  ON [<dbUser,varchar,dbo>].[subtext_DeleteImage]  TO [public]
GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO


CREATE PROC [<dbUser,varchar,dbo>].[subtext_DeleteImageCategory]
(
	@CategoryID int,
	@BlogId int
)
AS
DELETE [<dbUser,varchar,dbo>].[subtext_Images] FROM [<dbUser,varchar,dbo>].[subtext_Images] WHERE subtext_Images.CategoryID = @CategoryID AND subtext_Images.BlogId = @BlogId
DELETE [<dbUser,varchar,dbo>].[subtext_LinkCategories] FROM [<dbUser,varchar,dbo>].[subtext_LinkCategories] WHERE subtext_LinkCategories.CategoryID = @CategoryID AND subtext_LinkCategories.BlogId = @BlogId



GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

GRANT  EXECUTE  ON [<dbUser,varchar,dbo>].[subtext_DeleteImageCategory]  TO [public]
GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO


CREATE PROC [<dbUser,varchar,dbo>].[subtext_DeleteKeyWord]
(
	@KeyWordID int,
	@BlogId int
)

AS

DELETE FROM [<dbUser,varchar,dbo>].[subtext_KeyWords] WHERE BlogId = @BlogId AND KeyWordID = @KeyWordID


GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

GRANT  EXECUTE  ON [<dbUser,varchar,dbo>].[subtext_DeleteKeyWord]  TO [public]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO


CREATE PROC [<dbUser,varchar,dbo>].[subtext_DeleteLink]
(
	@LinkID int,
	@BlogId int
)
AS
DELETE [<dbUser,varchar,dbo>].[subtext_Links] FROM [<dbUser,varchar,dbo>].[subtext_Links] WHERE [LinkID] = @LinkID AND BlogId = @BlogId


GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

GRANT  EXECUTE  ON [<dbUser,varchar,dbo>].[subtext_DeleteLink]  TO [public]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO


CREATE PROC [<dbUser,varchar,dbo>].[subtext_DeleteLinksByPostID]
(
	@PostID int,
	@BlogId int
)
AS
Set NoCount ON
DELETE [<dbUser,varchar,dbo>].[subtext_Links] FROM [<dbUser,varchar,dbo>].[subtext_Links] WHERE PostID = @PostID AND BlogId = @BlogId



GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

GRANT  EXECUTE  ON [<dbUser,varchar,dbo>].[subtext_DeleteLinksByPostID]  TO [public]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

/*
Returns a count of feedback for the various statuses.
*/
CREATE PROC [<dbUser,varchar,dbo>].[subtext_GetFeedbackCountsByStatus]
(
	@BlogId int,
	@ApprovedCount int out,
	@NeedsModerationCount int out,
	@FlaggedSpam int out,
	@Deleted int out	
)
AS

SELECT @ApprovedCount = COUNT(1) FROM [<dbUser,varchar,dbo>].[subtext_Feedback] WHERE BlogId = @BlogId AND StatusFlag & 1 = 1
SELECT @NeedsModerationCount = COUNT(1) FROM [<dbUser,varchar,dbo>].[subtext_Feedback] WHERE BlogId = @BlogId AND StatusFlag & 2 = 2 AND StatusFlag & 8 != 8 AND StatusFlag & 1 != 1
SELECT @FlaggedSpam = COUNT(1) FROM [<dbUser,varchar,dbo>].[subtext_Feedback] WHERE BlogId = @BlogId AND StatusFlag & 4 = 4 AND StatusFlag & 8 != 8 AND StatusFlag & 1 != 1
SELECT @Deleted = COUNT(1) FROM [<dbUser,varchar,dbo>].[subtext_Feedback] WHERE BlogId = @BlogId AND StatusFlag & 8 = 8 AND StatusFlag & 1 != 1

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

GRANT  EXECUTE  ON [<dbUser,varchar,dbo>].[subtext_GetFeedbackCountsByStatus] TO [public]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO


SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

/*
Fully deletes a Feedback item from the db.
*/
CREATE PROC [<dbUser,varchar,dbo>].[subtext_DeleteFeedback]
(
	@Id int
)
AS

DECLARE @EntryId int
DECLARE @BlogId int

SELECT @EntryId = EntryId, @BlogId = BlogId FROM [<dbUser,varchar,dbo>].[subtext_Feedback] WHERE [Id] = @Id

DELETE [<dbUser,varchar,dbo>].[subtext_Feedback] WHERE [Id] = @Id

exec [<dbUser,varchar,dbo>].[subtext_UpdateFeedbackCount] @BlogId, @EntryId
GO

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

GRANT  EXECUTE  ON [<dbUser,varchar,dbo>].[subtext_DeleteFeedback] TO [public]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO


/*
Fully deletes a Feedback item from the db.
*/
CREATE PROC [<dbUser,varchar,dbo>].[subtext_GetHost]
AS
SELECT TOP 1 ApplicationId, OwnerId, DateCreated FROM [<dbUser,varchar,dbo>].[subtext_Host]
GO
GRANT  EXECUTE  ON [<dbUser,varchar,dbo>].[subtext_GetHost] TO [public]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO


/*
Fully deletes a Feedback item from the db.
*/
CREATE PROC [<dbUser,varchar,dbo>].[subtext_DeleteFeedbackByStatus]
(
	@BlogId int
	, @StatusFlag int
)
AS

DELETE [<dbUser,varchar,dbo>].[subtext_Feedback] 
WHERE [BlogId] = @BlogId 
	AND StatusFlag & @StatusFlag = @StatusFlag
	AND StatusFlag & 1 != 1 -- Do not delete approved.
	AND (
			(@StatusFlag = 4 AND StatusFlag & 8 != 8)
			OR
			@StatusFlag != 4
		)	

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

GRANT  EXECUTE  ON [<dbUser,varchar,dbo>].[subtext_DeleteFeedbackByStatus] TO [public]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO


/*
Deletes a record FROM [<dbUser,varchar,dbo>].[subtext_content], whether it be a post, a comment, etc..
*/
CREATE PROC [<dbUser,varchar,dbo>].[subtext_DeletePost]
(
	@ID int
)
AS

DELETE FROM [<dbUser,varchar,dbo>].[subtext_Links] WHERE PostID = @ID
DELETE FROM [<dbUser,varchar,dbo>].[subtext_EntryViewCount] WHERE EntryID = @ID
DELETE FROM [<dbUser,varchar,dbo>].[subtext_Referrals] WHERE EntryID = @ID
DELETE FROM [<dbUser,varchar,dbo>].[subtext_Feedback] WHERE EntryId = @ID
DELETE FROM [<dbUser,varchar,dbo>].[subtext_Content] WHERE [ID] = @ID

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

GRANT  EXECUTE  ON [<dbUser,varchar,dbo>].[subtext_DeletePost]  TO [public]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO


CREATE PROC [<dbUser,varchar,dbo>].[subtext_GetActiveCategoriesWithLinkCollection]
(
	@BlogId int = NULL
)
AS
SELECT subtext_LinkCategories.CategoryID
	, subtext_LinkCategories.Title
	, subtext_LinkCategories.Active
	, subtext_LinkCategories.CategoryType
	, subtext_LinkCategories.[Description]
FROM [<dbUser,varchar,dbo>].[subtext_LinkCategories]
WHERE	
			subtext_LinkCategories.Active= 1 
	AND		(subtext_LinkCategories.BlogId = @BlogId OR @BlogId IS NULL)
	AND		subtext_LinkCategories.CategoryType = 5
ORDER BY 
	subtext_LinkCategories.Title;

SELECT links.LinkID
	, links.Title
	, links.Url
	, links.Rss
	, links.Active
	, links.NewWindow
	, links.CategoryID
	, PostID = ISNULL(links.PostID, -1)
FROM [<dbUser,varchar,dbo>].[subtext_Links] links
	INNER JOIN [<dbUser,varchar,dbo>].[subtext_LinkCategories] categories ON links.CategoryID = categories.CategoryID
WHERE 
		links.Active = 1 
	AND categories.Active = 1
	AND (categories.BlogId = @BlogId OR @BlogId IS NULL)
	AND links.BlogId = @BlogId 
	AND categories.CategoryType = 5
ORDER BY 
	links.Title;



GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

GRANT  EXECUTE  ON [<dbUser,varchar,dbo>].[subtext_GetActiveCategoriesWithLinkCollection]  TO [public]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO


CREATE PROC [<dbUser,varchar,dbo>].[subtext_GetAllCategories]
(
	@BlogId int = NULL
	, @IsActive bit
	, @CategoryType tinyint
)
As
SELECT subtext_LinkCategories.CategoryID
	, subtext_LinkCategories.Title
	, subtext_LinkCategories.Active
	, subtext_LinkCategories.CategoryType
	, subtext_LinkCategories.[Description]
FROM [<dbUser,varchar,dbo>].[subtext_LinkCategories]
WHERE (subtext_LinkCategories.BlogId = @BlogId OR @BlogId IS NULL)
	AND subtext_LinkCategories.CategoryType = @CategoryType 
	AND subtext_LinkCategories.Active <> CASE @IsActive WHEN 1 THEN 0 ELSE -1 END
ORDER BY subtext_LinkCategories.Title;


GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

GRANT  EXECUTE  ON [<dbUser,varchar,dbo>].[subtext_GetAllCategories]  TO [public]
GO


SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO


CREATE PROC [<dbUser,varchar,dbo>].[subtext_GetCategory]
(
	@CategoryID int,
	@IsActive bit,
	@BlogId int
)
AS
SELECT	subtext_LinkCategories.CategoryID
		, subtext_LinkCategories.Title
		, subtext_LinkCategories.Active
		, subtext_LinkCategories.CategoryType
		, subtext_LinkCategories.[Description]
FROM [<dbUser,varchar,dbo>].[subtext_LinkCategories]
WHERE subtext_LinkCategories.CategoryID=@CategoryID 
	AND subtext_LinkCategories.BlogId = @BlogId 
	AND subtext_LinkCategories.Active <> CASE @IsActive WHEN 0 THEN -1 else 0 END



GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

GRANT  EXECUTE  ON [<dbUser,varchar,dbo>].[subtext_GetCategory]  TO [public]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO


CREATE PROC [<dbUser,varchar,dbo>].[subtext_GetCategoryByName] 
(
	@CategoryName nvarchar(150),
	@IsActive bit,
	@BlogId int
)
AS
SELECT	subtext_LinkCategories.CategoryID
		, subtext_LinkCategories.Title
		, subtext_LinkCategories.Active
		, subtext_LinkCategories.CategoryType
		, subtext_LinkCategories.[Description]
FROM [<dbUser,varchar,dbo>].[subtext_LinkCategories]
WHERE	subtext_LinkCategories.Title=@CategoryName 
	AND subtext_LinkCategories.BlogId = @BlogId 
	AND subtext_LinkCategories.Active <> CASE @IsActive WHEN 0 THEN -1 else 0 END


GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

GRANT  EXECUTE  ON [<dbUser,varchar,dbo>].[subtext_GetCategoryByName]  TO [public]
GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO


CREATE PROC [<dbUser,varchar,dbo>].[subtext_GetConditionalEntries]
(
	@ItemCount int 
	, @PostType int
	, @PostConfig int
	, @BlogId int = NULL
	, @IncludeCategories bit = 0
)
AS
/* 
//TODO: This proc is being used to populate home page 
and feed. But it should sort on different dates for each.
*/
CREATE Table #IDs  
(  
	 TempId int IDENTITY (0, 1) NOT NULL,  
	 Id int not NULL  
)

INSERT #IDs (Id)  
SELECT [Id]   
FROM [<dbUser,varchar,dbo>].[subtext_Content]
WHERE	PostType = @PostType 
	AND BlogId = COALESCE(@BlogId, BlogId)
	AND PostConfig & @PostConfig = @PostConfig
ORDER BY ISNULL([DateSyndicated], [DateAdded]) DESC

SET ROWCOUNT @ItemCount
SELECT BlogId
	, AuthorId
	, [<dbUser,varchar,dbo>].[subtext_Content].[Id]
	, Title
	, DateAdded
	, [Text]
	, [Description]
	, PostType
	, DateUpdated
	, FeedbackCount = ISNULL(FeedbackCount, 0)
	, PostConfig
	, EntryName 
	, DateSyndicated
FROM [<dbUser,varchar,dbo>].[subtext_Content]
	INNER JOIN #IDs ON #IDs.[Id] = [<dbUser,varchar,dbo>].[subtext_Content].[Id]
ORDER BY #IDs.TempId

IF @IncludeCategories = 1
BEGIN
	SELECT	c.Title  
			, p.[Id]
	FROM [<dbUser,varchar,dbo>].[subtext_Links] l
		INNER JOIN #IDs p ON l.[PostID] = p.[ID]  
		INNER JOIN [<dbUser,varchar,dbo>].[subtext_LinkCategories] c ON l.CategoryID = c.CategoryID
	ORDER BY p.[TempID] DESC
END
DROP TABLE #IDs

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

GRANT  EXECUTE  ON [<dbUser,varchar,dbo>].[subtext_GetConditionalEntries]  TO [public]
GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO
/*
Returns the blog that matches the given host/application combination.

@Strict -- If 0, then we return the one and only blog if there's one and only blog.
*/
CREATE PROC [<dbUser,varchar,dbo>].[subtext_GetBlog]
(
	@Host nvarchar(100)
	, @Subfolder nvarchar(50)
	, @Strict bit = 1 
)
AS

DECLARE @BlogId INT

SELECT
	@BlogID = BlogId
FROM [<dbUser,varchar,dbo>].[subtext_Config]
WHERE
	(
			Host = @Host
		AND Subfolder = @Subfolder
	)
	OR
	(
			(@Strict = 0) 
		AND (1 = (SELECT COUNT(1) FROM [<dbUser,varchar,dbo>].[subtext_config]))
	)

EXEC [<dbUser,varchar,dbo>].[subtext_GetBlogById] @BlogId

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

GRANT  EXECUTE  ON [<dbUser,varchar,dbo>].[subtext_GetBlog]  TO [public]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

CREATE PROC [<dbUser,varchar,dbo>].[subtext_GetEntriesByDayRange]
(
	@StartDate datetime,
	@StopDate datetime,
	@PostType int,
	@IsActive bit,
	@BlogId int
)
AS
SELECT	BlogId
	, [ID]
	, AuthorId
	, Title
	, DateAdded
	, [Text]
	, [Description]
	, PostType
	, DateUpdated
	, FeedbackCount = ISNULL(FeedbackCount, 0)
	, PostConfig
	, EntryName 
	, DateSyndicated
FROM [<dbUser,varchar,dbo>].[subtext_Content]
WHERE 
	(
		DateAdded > @StartDate 
		AND DateAdded < DateAdd(day, 1, @StopDate)
	)
	AND PostType=@PostType 
	AND BlogId = @BlogId 
	AND PostConfig & 1 <> CASE @IsActive WHEN 1 THEN 0 Else -1 END
ORDER BY DateAdded DESC;


GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

GRANT  EXECUTE  ON [<dbUser,varchar,dbo>].[subtext_GetEntriesByDayRange]  TO [public]
GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

/* Gets all the ACTIVE Feedback (comments, pingbacks/trackbacks) for the entry */
CREATE PROC [<dbUser,varchar,dbo>].[subtext_GetFeedbackCollection]
(
	@EntryId int
)
AS
	SELECT f.Id 
		, f.Title
		, f.Body
		, f.BlogId
		, f.EntryId
		, f.Author
		, f.IsBlogAuthor
		, f.Email
		, f.Url
		, f.FeedbackType
		, f.StatusFlag
		, f.CommentAPI
		, f.Referrer
		, f.IpAddress
		, f.UserAgent
		, f.FeedbackChecksumHash
		, f.DateCreated
		, f.DateModified
		, ParentEntryCreateDate = c.DateAdded
		, ParentEntryName = c.EntryName
FROM [<dbUser,varchar,dbo>].[subtext_Feedback] f
	LEFT OUTER JOIN [<dbUser,varchar,dbo>].[subtext_Content] c 
		ON c.Id = f.EntryId
WHERE f.EntryId = @EntryId
	AND f.StatusFlag & 1 = 1
ORDER BY f.[Id]


GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

GRANT  EXECUTE  ON [<dbUser,varchar,dbo>].[subtext_GetFeedbackCollection]  TO [public]
GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

/* Returns a single Feedback by id */
CREATE PROC [<dbUser,varchar,dbo>].[subtext_GetFeedback]
(
	@Id int
)
AS
	SELECT f.Id 
		, f.Title
		, f.Body
		, f.BlogId
		, f.EntryId
		, f.Author
		, f.IsBlogAuthor
		, f.Email
		, f.Url
		, f.FeedbackType
		, f.StatusFlag
		, f.CommentAPI
		, f.Referrer
		, f.IpAddress
		, f.UserAgent
		, f.FeedbackChecksumHash
		, f.DateCreated
		, f.DateModified
		, ParentEntryCreateDate = c.DateAdded
		, ParentEntryName = c.EntryName
FROM [<dbUser,varchar,dbo>].[subtext_Feedback] f
	LEFT OUTER JOIN [<dbUser,varchar,dbo>].[subtext_Content] c 
		ON c.Id = f.EntryId
WHERE f.Id = @Id

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

GRANT  EXECUTE  ON [<dbUser,varchar,dbo>].[subtext_GetFeedback] TO [public]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO


CREATE PROC [<dbUser,varchar,dbo>].[subtext_GetImageCategory]
(
	@CategoryID int
	, @IsActive bit
	, @BlogId int
)
AS
EXEC [<dbUser,varchar,dbo>].[subtext_GetCategory] @CategoryID, @IsActive, @BlogId

SELECT	Title
		, CategoryID
		, Height
		, Width
		, [File]
		, Active
		, ImageID 
FROM [<dbUser,varchar,dbo>].[subtext_Images]  
WHERE CategoryID = @CategoryID 
	AND BlogId = @BlogId 
	AND Active <> CASE @IsActive WHEN 1 THEN 0 Else -1 END
ORDER BY Title


GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

GRANT  EXECUTE  ON [<dbUser,varchar,dbo>].[subtext_GetImageCategory]  TO [public]
GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO


CREATE PROC [<dbUser,varchar,dbo>].[subtext_GetKeyWord]
(
	@KeyWordID int
	, @BlogId int
)
AS

SELECT 
	KeyWordID, Word,[Text],ReplaceFirstTimeOnly,OpenInNewWindow, CaseSensitive,Url,Title,BlogId
FROM
	subtext_keywords
WHERE 
	KeyWordID = @KeyWordID AND BlogId = @BlogId


GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

GRANT  EXECUTE  ON [<dbUser,varchar,dbo>].[subtext_GetKeyWord]  TO [public]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO


CREATE PROC [<dbUser,varchar,dbo>].[subtext_GetLinkCollectionByPostID]
(
	@PostID int,
	@BlogId int
)
AS

IF @PostID = -1
	SET @PostID = NULL

SELECT	LinkID
	, Title
	, Url
	, Rss
	, Active
	, CategoryID
	, PostID = ISNULL(PostID, -1)
	, NewWindow 
FROM [<dbUser,varchar,dbo>].[subtext_Links]
WHERE PostID = @PostID 
	AND BlogId = @BlogId


GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

GRANT  EXECUTE  ON [<dbUser,varchar,dbo>].[subtext_GetLinkCollectionByPostID]  TO [public]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO


CREATE PROC [<dbUser,varchar,dbo>].[subtext_GetLinksByActiveCategoryID]
(
	@CategoryID int
	, @BlogId int
)
AS
EXEC [<dbUser,varchar,dbo>].[subtext_GetCategory] @CategoryID, 0, @BlogId
SELECT	LinkID
		, Title
		, Url
		, Rss
		, Active
		, CategoryID
		, PostID = ISNULL(PostID, -1)
FROM [<dbUser,varchar,dbo>].[subtext_Links]
WHERE Active = 1 
	AND CategoryID = @CategoryID 
	AND BlogId = @BlogId
ORDER BY Title


GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

GRANT  EXECUTE  ON [<dbUser,varchar,dbo>].[subtext_GetLinksByActiveCategoryID]  TO [public]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO


CREATE PROC [<dbUser,varchar,dbo>].[subtext_GetLinksByCategoryID]
(
	@CategoryID int
	, @BlogId int
)
AS
EXEC [<dbUser,varchar,dbo>].[subtext_GetCategory] @CategoryID, @BlogId
SELECT	LinkID
		, Title
		, Url
		, Rss
		, Active
		, NewWindow
		, CategoryID
		, PostId = ISNULL(PostID, -1)
FROM [<dbUser,varchar,dbo>].[subtext_Links]
WHERE	CategoryID = @CategoryID 
	AND BlogId = @BlogId
ORDER BY Title


GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

GRANT  EXECUTE  ON [<dbUser,varchar,dbo>].[subtext_GetLinksByCategoryID]  TO [public]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

/*
Selects a page of blog posts within the admin section.
Updated this to use a more efficient paging technique:
http://www.4guysfromrolla.com/webtech/041206-1.shtml
*/
CREATE PROC [<dbUser,varchar,dbo>].[subtext_GetPageableEntries]
(
	@BlogId int
	, @PageIndex int
	, @PageSize int
	, @PostType int
)
AS

DECLARE @FirstId int
DECLARE @StartRow int
DECLARE @StartRowIndex int

SET @StartRowIndex = @PageIndex * @PageSize + 1

SET ROWCOUNT @StartRowIndex
-- Get the first entry id for the current page.
SELECT	@FirstId = [ID] FROM [<dbUser,varchar,dbo>].[subtext_Content]
WHERE	BlogId = @BlogId 
	AND PostType = @PostType 
ORDER BY [ID] DESC

-- Now, set the row count to MaximumRows and get
-- all records >= @first_id
SET ROWCOUNT @PageSize

SELECT	content.BlogId 
		, content.[ID] 
		, content.AuthorId 
		, content.Title 
		, content.DateAdded 
		, content.[Text] 
		, content.[Description]
		, content.PostType 
		, content.DateUpdated 
		, FeedbackCount = ISNULL(content.FeedbackCount, 0)
		, content.PostConfig
		, content.EntryName
		, content.DateSyndicated
		, vc.WebCount
		, vc.AggCount
		, vc.WebLastUpdated
		, vc.AggLastUpdated
		
FROM [<dbUser,varchar,dbo>].[subtext_Content] content
	Left JOIN  subtext_EntryViewCount vc ON (content.[ID] = vc.EntryID AND vc.BlogId = @BlogId)
WHERE 	content.BlogId = @BlogId 
	AND content.[ID] <= @FirstId
	AND PostType = @PostType
ORDER BY content.[ID] DESC
 
SELECT COUNT([ID]) AS TotalRecords
FROM [<dbUser,varchar,dbo>].[subtext_Content] 
WHERE 	BlogId = @BlogId 
	AND PostType = @PostType 

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

GRANT  EXECUTE  ON [<dbUser,varchar,dbo>].[subtext_GetPageableEntries]  TO [public]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

/*
Selects a page of blog posts within the admin section, when a category 
is selected.
Updated this to use a more efficient paging technique:
http://www.4guysfromrolla.com/webtech/041206-1.shtml
*/
CREATE PROC [<dbUser,varchar,dbo>].[subtext_GetPageableEntriesByCategoryID]
(
	@BlogId int
	, @CategoryID int
	, @PageIndex int
	, @PageSize int
	, @PostType int
)
AS

DECLARE @FirstId int
DECLARE @StartRow int
DECLARE @StartRowIndex int

SET @StartRowIndex = @PageIndex * @PageSize + 1

SET ROWCOUNT @StartRowIndex
-- Get the first entry id for the current page.
SELECT	@FirstId = content.[ID] 
FROM [<dbUser,varchar,dbo>].[subtext_Content] content
	INNER JOIN [<dbUser,varchar,dbo>].[subtext_Links] links ON content.[ID] = ISNULL(links.PostID, -1)
	INNER JOIN [<dbUser,varchar,dbo>].[subtext_LinkCategories] cats ON (links.CategoryID = cats.CategoryID)
WHERE	content.BlogId = @BlogId 
	AND content.PostType = @PostType 
	AND cats.CategoryID = @CategoryID
ORDER BY content.[ID] DESC

-- Now, set the row count to MaximumRows and get
-- all records >= @first_id
SET ROWCOUNT @PageSize

SELECT	content.BlogId 
		, content.[ID] 
		, content.AuthorId
		, content.Title 
		, content.DateAdded 
		, content.[Text] 
		, content.[Description]
		, content.PostType 
		, content.DateUpdated 
		, FeedbackCount = ISNULL(content.FeedbackCount, 0)
		, content.PostConfig
		, content.EntryName
		, content.DateSyndicated
		, vc.WebCount
		, vc.AggCount
		, vc.WebLastUpdated
		, vc.AggLastUpdated
		
FROM [<dbUser,varchar,dbo>].[subtext_Content] content
	INNER JOIN [<dbUser,varchar,dbo>].[subtext_Links] l ON content.[ID] = ISNULL(l.PostID, -1)
	INNER JOIN [<dbUser,varchar,dbo>].[subtext_LinkCategories] cats ON (l.CategoryID = cats.CategoryID)
	Left JOIN  subtext_EntryViewCount vc ON (content.[ID] = vc.EntryID AND vc.BlogId = @BlogId)
WHERE 	content.BlogId = @BlogId 
	AND content.[ID] <= @FirstId
	AND content.PostType = @PostType
	AND cats.CategoryID = @CategoryID
ORDER BY content.[ID] DESC
 
SELECT COUNT(content.[ID]) AS TotalRecords
FROM [<dbUser,varchar,dbo>].[subtext_Content] content
INNER JOIN [<dbUser,varchar,dbo>].[subtext_Links] links ON content.[ID] = ISNULL(links.PostID, -1)
	INNER JOIN [<dbUser,varchar,dbo>].[subtext_LinkCategories] cats ON (links.CategoryID = cats.CategoryID)
WHERE 	content.BlogId = @BlogId 
	AND content.PostType = @PostType 
	AND cats.CategoryID = @CategoryID

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

GRANT  EXECUTE  ON [<dbUser,varchar,dbo>].[subtext_GetPageableEntriesByCategoryID]  TO [public]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

/*
For the admin section. Gets a page of Feedback for the specified blog.
*/
CREATE PROC [<dbUser,varchar,dbo>].[subtext_GetPageableFeedback]
(
	@BlogId int
	, @PageIndex int
	, @PageSize int
	, @StatusFlag int
	, @ExcludeFeedbackStatusMask int = NULL
	, @FeedbackType int = NULL -- Null for all feedback.
)
AS

IF @ExcludeFeedbackStatusMask IS NULL
	SET @ExcludeFeedbackStatusMask = ~0

DECLARE @FirstId int
DECLARE @StartRow int
DECLARE @StartRowIndex int

SET @StartRowIndex = @PageIndex * @PageSize + 1

SET ROWCOUNT @StartRowIndex
-- Get the first entry id for the current page.
SELECT @FirstId = f.[Id] 
FROM [<dbUser,varchar,dbo>].[subtext_Feedback] f
WHERE 	f.BlogId = @BlogId 
	AND (f.StatusFlag & @StatusFlag = @StatusFlag)
	AND (f.StatusFlag & @ExcludeFeedbackStatusMask = 0) -- Make sure the status doesn't have any of the excluded statuses set
	AND (f.FeedbackType = @FeedbackType OR @FeedbackType IS NULL)
ORDER BY f.[ID] DESC

-- Now, set the row count to MaximumRows and get
-- all records >= @first_id
SET ROWCOUNT @PageSize

SELECT  f.Id
		, f.Title
		, f.Body
		, f.BlogId
		, f.EntryId
		, f.Author
		, f.IsBlogAuthor
		, f.Email
		, f.Url
		, f.FeedbackType
		, f.StatusFlag
		, f.CommentAPI
		, f.Referrer
		, f.IpAddress
		, f.UserAgent
		, f.FeedbackChecksumHash
		, f.DateCreated
		, f.DateModified
		, ParentEntryCreateDate = c.DateAdded
		, ParentEntryName = c.EntryName
FROM [<dbUser,varchar,dbo>].[subtext_Feedback] f
	LEFT OUTER JOIN [<dbUser,varchar,dbo>].[subtext_Content] c 
		ON c.Id = f.EntryId
WHERE 	f.BlogId = @BlogId 
	AND f.[Id] <= @FirstId
	AND f.StatusFlag & @StatusFlag = @StatusFlag
	AND (f.StatusFlag & @ExcludeFeedbackStatusMask = 0) -- Make sure the status doesn't have any of the excluded statuses set
	AND (f.FeedbackType = @FeedbackType OR @FeedbackType IS NULL)
ORDER BY f.[Id] DESC
 
SELECT COUNT(f.[Id]) AS TotalRecords
FROM [<dbUser,varchar,dbo>].[subtext_Feedback] f
WHERE 	f.BlogId = @BlogId 
	AND f.StatusFlag & @StatusFlag = @StatusFlag
	AND (f.StatusFlag & @ExcludeFeedbackStatusMask = 0) -- Make sure the status doesn't have any of the excluded statuses set
	AND (f.FeedbackType = @FeedbackType OR @FeedbackType IS NULL)
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

GRANT  EXECUTE  ON [<dbUser,varchar,dbo>].[subtext_GetPageableFeedback]  TO [public]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO


/*
Selects a page of log posts within the admin section.
Updated this to use a more efficient paging technique:
http://www.4guysfromrolla.com/webtech/041206-1.shtml
*/
CREATE PROC [<dbUser,varchar,dbo>].[subtext_GetPageableLogEntries]
(
	@BlogId int = NULL
	, @PageIndex int
	, @PageSize int
)
AS

DECLARE @FirstId int
DECLARE @StartRow int
DECLARE @StartRowIndex int

SET @StartRowIndex = @PageIndex * @PageSize + 1

SET ROWCOUNT @StartRowIndex
-- Get the first entry id for the current page.
SELECT	@FirstId = [ID] FROM [<dbUser,varchar,dbo>].[subtext_Log] 
WHERE	BlogId = @BlogId OR @BlogId IS NULL
ORDER BY [ID] DESC

-- Now, set the row count to MaximumRows and get
-- all records >= @first_id
SET ROWCOUNT @PageSize

SELECT	[log].[Id]
		, [log].[BlogId]
		, [log].[Date]
		, [log].[Thread]
		, [log].[Context]
		, [log].[Level]
		, [log].[Logger]
		, [log].[Message]
		, [log].[Exception]
		, [log].[Url]
FROM [<dbUser,varchar,dbo>].[subtext_Log] [log]
WHERE 	([log].BlogId = @BlogId or @BlogId IS NULL)
	AND [log].[ID] <= @FirstId
ORDER BY [log].[ID] DESC
 
SELECT COUNT([ID]) AS TotalRecords
FROM [<dbUser,varchar,dbo>].[subtext_Log] 
WHERE 	BlogId = @BlogId 
	OR 	@BlogId IS NULL

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

GRANT  EXECUTE  ON [<dbUser,varchar,dbo>].[subtext_GetPageableLogEntries]  TO [public]
GO


SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

/*
Selects a page of keywords within the admin section.
Updated this to use a more efficient paging technique:
http://www.4guysfromrolla.com/webtech/041206-1.shtml
*/

CREATE PROC [<dbUser,varchar,dbo>].[subtext_GetPageableKeyWords]
(
	@BlogId int
	, @PageIndex int
	, @PageSize int
)
AS
DECLARE @FirstWord nvarchar(100)
DECLARE @StartRow int
DECLARE @StartRowIndex int

SET @StartRowIndex = @PageIndex * @PageSize + 1

SET ROWCOUNT @StartRowIndex
-- Get the first entry id for the current page.
SELECT	@FirstWord = [Word] FROM [<dbUser,varchar,dbo>].[subtext_KeyWords]
WHERE	BlogId = @BlogId 
ORDER BY [Word] ASC

-- Now, set the row count to MaximumRows and get
-- all records >= @first_id
SET ROWCOUNT @PageSize

SELECT 	words.KeyWordID
		, words.Word
		, words.[Text]
		, words.ReplaceFirstTimeOnly
		, words.OpenInNewWindow
		, words.CaseSensitive
		, words.Url
		, words.Title
		, words.BlogId
FROM 	
	[<dbUser,varchar,dbo>].[subtext_KeyWords] words
WHERE 	
		words.BlogId = @BlogId 
	AND words.Word >= @FirstWord
ORDER BY
		words.Word ASC
 
SELECT 	COUNT([KeywordId]) AS 'TotalRecords'
FROM [<dbUser,varchar,dbo>].[subtext_KeyWords] 
WHERE 	BlogId = @BlogId


GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

GRANT  EXECUTE  ON [<dbUser,varchar,dbo>].[subtext_GetPageableKeyWords]  TO [public]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

/* Returns a page of links for the admin section */
CREATE PROC [<dbUser,varchar,dbo>].[subtext_GetPageableLinks]
(
	@BlogId int
	, @CategoryId int = NULL
	, @PageIndex int
	, @PageSize int
)
AS

DECLARE @FirstId int
DECLARE @StartRow int
DECLARE @StartRowIndex int

SET @StartRowIndex = @PageIndex * @PageSize + 1

SET ROWCOUNT @StartRowIndex
-- Get the first entry id for the current page.
SELECT @FirstId = LinkID
FROM [<dbUser,varchar,dbo>].[subtext_Links]
WHERE 	BlogId = @BlogId 
	AND (CategoryID = @CategoryID OR @CategoryID IS NULL)
	AND PostID IS NULL
ORDER BY [LinkID] DESC

-- Now, set the row count to MaximumRows and get
-- all records >= @first_id
SET ROWCOUNT @PageSize

SELECT links.LinkID 
	, links.Title 
	, links.Url
	, links.Rss 
	, links.Active 
	, links.NewWindow 
	, links.CategoryID
	, PostID = ISNULL(links.PostID, -1)
FROM [<dbUser,varchar,dbo>].[subtext_Links] links
WHERE 	links.BlogId = @BlogId 
	AND links.[LinkId] <= @FirstId
	AND (CategoryID = @CategoryID OR @CategoryID IS NULL)
	AND PostID IS NULL
ORDER BY links.[LinkID] DESC
 
SELECT COUNT([LinkID]) AS TotalRecords
FROM [<dbUser,varchar,dbo>].[subtext_Links] 
WHERE 	BlogId = @BlogId 
	AND (CategoryID = @CategoryID OR @CategoryID IS NULL)
	AND PostID IS NULL

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

GRANT  EXECUTE  ON [<dbUser,varchar,dbo>].[subtext_GetPageableLinks]  TO [public]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO


CREATE PROC [<dbUser,varchar,dbo>].[subtext_GetPageableLinksByCategoryID]
(
	@BlogId int
	, @CategoryID int = NULL
	, @PageIndex int
	, @PageSize int
	, @SortDesc bit
)
AS

DECLARE @PageLowerBound int
DECLARE @PageUpperBound int

SET @PageLowerBound = @PageSize * @PageIndex - @PageSize
SET @PageUpperBound = @PageLowerBound + @PageSize + 1

CREATE TABLE #TempPagedLinkIDs 
(
	TempID int IDENTITY (1, 1) NOT NULL,
	LinkID int NOT NULL
)	

IF NOT (@SortDesc = 1)
BEGIN
	INSERT INTO #TempPagedLinkIDs (LinkID)
	SELECT	LinkID
	FROM [<dbUser,varchar,dbo>].[subtext_Links] 
	WHERE 	BlogId = @BlogId 
		AND CategoryID = @CategoryID
		AND PostID IS NULL
	ORDER BY Title
END
ELSE
BEGIN
	INSERT INTO #TempPagedLinkIDs (LinkID)
	SELECT	LinkID
	FROM [<dbUser,varchar,dbo>].[subtext_Links]
	WHERE 	BlogId = @BlogId 
		AND CategoryID = @CategoryID
		AND PostID IS NULL
	ORDER BY Title DESC
END

SELECT 	links.LinkID
		, links.Title
		, links.Url
		, links.Rss 
		, links.Active 
		, links.NewWindow 
		, links.CategoryID  
		, PostId = ISNULL(links.PostID, -1)
FROM 	
	subtext_Links links
	INNER JOIN #TempPagedLinkIDs tmp ON (links.LinkID = tmp.LinkID)
WHERE 	
		links.BlogId = @BlogId 
	AND links.CategoryID = @CategoryID
	AND tmp.TempID > @PageLowerBound
	AND tmp.TempID < @PageUpperBound
ORDER BY
	tmp.TempID
 
DROP TABLE #TempPagedLinkIDs


SELECT  COUNT([LinkID]) AS TotalRecords
FROM [<dbUser,varchar,dbo>].[subtext_Links] 
WHERE 	BlogId = @BlogId 
	AND CategoryID = @CategoryID 
	AND PostID IS NULL


GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

GRANT  EXECUTE  ON [<dbUser,varchar,dbo>].[subtext_GetPageableLinksByCategoryID]  TO [public]
GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

CREATE PROC [<dbUser,varchar,dbo>].[subtext_GetPageableReferrers] 
(
	@BlogId INT,
	@EntryID int = NULL,
	@PageIndex INT,
	@PageSize INT
)
AS

DECLARE @FirstId int
DECLARE @StartRow int
DECLARE @StartRowIndex int

SET @StartRowIndex = @PageIndex * @PageSize + 1

SET ROWCOUNT @StartRowIndex
-- Get the first entry id for the current page.
SELECT	@FirstId = [UrlID] FROM [<dbUser,varchar,dbo>].[subtext_Referrals]
WHERE	BlogId = @BlogId 
	AND (EntryID = @EntryID OR @EntryID IS NULL)
ORDER BY [UrlID] DESC

SET ROWCOUNT @PageSize

SELECT	
	u.URL
	, c.Title
	, c.EntryName
	, r.[EntryId]
	, [Count]
	, r.LastUpdated
FROM [<dbUser,varchar,dbo>].[subtext_Referrals] r
	INNER JOIN [<dbUser,varchar,dbo>].[subtext_URLs] u ON u.UrlID = r.UrlID
	LEFT OUTER JOIN [<dbUser,varchar,dbo>].[subtext_Content] c ON c.ID = r.EntryID
WHERE 
	u.UrlID <= @FirstId
	AND (r.EntryID = @EntryID OR @EntryID IS NULL)
	AND r.BlogId = @BlogId
ORDER BY u.[UrlID] DESC

SELECT COUNT([UrlID]) AS TotalRecords
FROM [<dbUser,varchar,dbo>].[subtext_Referrals] 
WHERE 	BlogId = @BlogId 
	AND (EntryID = @EntryID OR @EntryID IS NULL)

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

GRANT  EXECUTE  ON [<dbUser,varchar,dbo>].[subtext_GetPageableReferrers]  TO [public]
GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

CREATE PROC [<dbUser,varchar,dbo>].[subtext_GetPostsByCategoryID]
(
	@ItemCount int
	, @CategoryID int
	, @IsActive bit
	, @BlogId int
)
AS
SET ROWCOUNT @ItemCount
SELECT	content.BlogId
	, content.[ID]
	, content.AuthorId
	, content.Title
	, content.DateAdded
	, content.[Text]
	, content.[Description]
	, content.PostType
	, content.DateUpdated
	, FeedbackCount = ISNULL(content.FeedbackCount, 0)
	, content.PostConfig
	, content.EntryName 
	, content.DateSyndicated
FROM [<dbUser,varchar,dbo>].[subtext_Content] content WITH (NOLOCK)
	INNER JOIN [<dbUser,varchar,dbo>].[subtext_Links] links WITH (NOLOCK) ON content.ID = ISNULL(links.PostID, -1)
	INNER JOIN [<dbUser,varchar,dbo>].[subtext_LinkCategories] categories WITH (NOLOCK) ON links.CategoryID = categories.CategoryID
WHERE  content.BlogId = @BlogId 
	AND content.PostConfig & 1 <> CASE @IsActive WHEN 1 THEN 0 Else -1 END AND categories.CategoryID = @CategoryID
ORDER BY content.DateAdded DESC


GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

GRANT  EXECUTE  ON [<dbUser,varchar,dbo>].[subtext_GetPostsByCategoryID]  TO [public]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

CREATE PROC [<dbUser,varchar,dbo>].[subtext_GetPostsByDayRange]
(
	@StartDate datetime,
	@StopDate datetime,
	@BlogId int
)
AS
SELECT	BlogId
		, [ID]
		, AuthorId
		, Title
		, DateAdded
		, [Text]
		, [Description]
		, PostType
		, DateUpdated
		, FeedbackCount = ISNULL(FeedbackCount, 0)
		, PostConfig
		, EntryName 
		, DateSyndicated
FROM [<dbUser,varchar,dbo>].[subtext_Content]
WHERE 
	(
			DateAdded > @StartDate 
		AND DateAdded < DateAdd(day,1,@StopDate)
	)
	AND PostType=1 
	AND BlogId = @BlogId
ORDER BY DateAdded DESC;


GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

GRANT  EXECUTE  ON [<dbUser,varchar,dbo>].[subtext_GetPostsByDayRange]  TO [public]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

CREATE PROC [<dbUser,varchar,dbo>].[subtext_GetPostsByMonth]
(
	@Month int
	, @Year int
	, @BlogId int = NULL
)
AS
SELECT	BlogId
	, [ID]
	, AuthorId
	, Title
	, DateAdded
	, [Text]
	, [Description]
	, PostType
	, DateUpdated
	, FeedbackCount = ISNULL(FeedbackCount, 0)
	, PostConfig
	, EntryName 
	, DateSyndicated
FROM [<dbUser,varchar,dbo>].[subtext_Content]
WHERE	PostType=1 
	AND (BlogId = @BlogId OR @BlogId IS NULL)
	AND PostConfig & 1 = 1 
	AND Month(DateAdded) = @Month 
	AND Year(DateAdded)  = @Year
ORDER BY DateAdded DESC


GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

GRANT  EXECUTE  ON [<dbUser,varchar,dbo>].[subtext_GetPostsByMonth]  TO [public]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO


CREATE PROC [<dbUser,varchar,dbo>].[subtext_GetPostsByMonthArchive]
(
	@BlogId int = NULL
)
AS
SELECT Month(DateAdded) AS [Month]
	, Year(DateAdded) AS [Year]
	, 1 AS Day, Count(*) AS [Count] 
FROM [<dbUser,varchar,dbo>].[subtext_Content] 
WHERE PostType = 1 AND PostConfig & 1 = 1 AND (BlogId = @BlogId OR @BlogId IS NULL)
GROUP BY Year(DateAdded), Month(DateAdded) ORDER BY [Year] DESC, [Month] DESC



GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

GRANT  EXECUTE  ON [<dbUser,varchar,dbo>].[subtext_GetPostsByMonthArchive]  TO [public]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

CREATE PROC [<dbUser,varchar,dbo>].[subtext_GetPostsByYearArchive] 
(
	@BlogId int
)
AS
SELECT 1 AS [Month], Year(DateAdded) AS [Year], 1 AS Day, Count(*) AS [Count] FROM [<dbUser,varchar,dbo>].[subtext_Content] 
WHERE PostType = 1 AND PostConfig & 1 = 1 AND BlogId = @BlogId 
GROUP BY Year(DateAdded) ORDER BY [Year] DESC

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

GRANT  EXECUTE  ON [<dbUser,varchar,dbo>].[subtext_GetPostsByYearArchive]  TO [public]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

CREATE PROC [<dbUser,varchar,dbo>].[subtext_GetSingleDay]
(
	@Date datetime
	,@BlogId int
)
AS
SELECT	BlogId
	, [ID]
	, AuthorId
	, Title
	, DateAdded
	, [Text]
	, [Description]
	, PostType
	, DateUpdated
	, FeedbackCount = ISNULL(FeedbackCount, 0)
	, PostConfig
	, EntryName 
	, DateSyndicated
FROM [<dbUser,varchar,dbo>].[subtext_Content]
WHERE Year(DateAdded) = Year(@Date) 
	AND Month(DateAdded) = Month(@Date)
    AND Day(DateAdded) = Day(@Date) 
    And PostType=1
    AND BlogId = @BlogId 
    AND PostConfig & 1 = 1 
ORDER BY DateAdded DESC;


GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

GRANT  EXECUTE  ON [<dbUser,varchar,dbo>].[subtext_GetSingleDay]  TO [public]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

CREATE PROC [<dbUser,varchar,dbo>].[subtext_GetSingleEntry]
(
	@ID int = NULL
	, @EntryName nvarchar(150) = NULL
	, @IsActive bit
	, @BlogId int
	, @IncludeCategories bit = 0
)
AS
SELECT	BlogId
	, [ID]
	, AuthorId
	, Title
	, DateAdded
	, [Text]
	, [Description]
	, PostType
	, DateUpdated
	, FeedbackCount = ISNULL(FeedbackCount, 0)
	, PostConfig
	, EntryName 
	, DateSyndicated
FROM [<dbUser,varchar,dbo>].[subtext_Content]
WHERE ID = COALESCE(@ID, ID)
	AND IsNull(EntryName, '') = COALESCE(@EntryName, EntryName, '') 
	AND BlogId = @BlogId 
	AND PostConfig & 1 <> CASE @IsActive WHEN 1 THEN 0 Else -1 END
ORDER BY [ID] DESC

IF @IncludeCategories = 1
BEGIN
	SELECT c.Title
		, PostID = l.PostID  
	FROM [<dbUser,varchar,dbo>].[subtext_Links] l  
	INNER JOIN [<dbUser,varchar,dbo>].[subtext_LinkCategories] c ON l.CategoryID = c.CategoryID  
	WHERE l.PostID = @Id
END


GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

GRANT  EXECUTE  ON [<dbUser,varchar,dbo>].[subtext_GetSingleEntry]  TO [public]
GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

CREATE PROC [<dbUser,varchar,dbo>].[subtext_GetSingleImage]
(
	@ImageID int
	, @IsActive bit
	, @BlogId int
)
AS
SELECT Title
	, CategoryID
	, Height
	, Width
	, [File]
	, Active
	, ImageID 
FROM [<dbUser,varchar,dbo>].[subtext_Images]  
WHERE ImageID = @ImageID 
	AND BlogId = @BlogId 
	AND  Active <> CASE @IsActive WHEN 1 THEN 0 Else -1 END


GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

GRANT  EXECUTE  ON [<dbUser,varchar,dbo>].[subtext_GetSingleImage]  TO [public]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO


CREATE PROC [<dbUser,varchar,dbo>].[subtext_GetSingleLink]
(
	@LinkID int
	, @BlogId int
)
AS
SELECT	subtext_Links.LinkID
		, subtext_Links.Title
		, subtext_Links.Url
		, subtext_Links.Rss
		, subtext_Links.Active
		, subtext_Links.NewWindow
		, subtext_Links.CategoryID
		, PostId = ISNULL(subtext_Links.PostID, -1)
FROM [<dbUser,varchar,dbo>].[subtext_Links]
WHERE subtext_Links.LinkID = @LinkID AND subtext_Links.BlogId = @BlogId


GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

GRANT  EXECUTE  ON [<dbUser,varchar,dbo>].[subtext_GetSingleLink]  TO [public]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO


CREATE PROC [<dbUser,varchar,dbo>].[subtext_GetUrlID]
(
	@Url nvarchar(255)
	, @UrlID int output
)
AS
IF EXISTS(SELECT UrlID FROM [<dbUser,varchar,dbo>].[subtext_Urls] WHERE Url = @Url AND Url != '')
BEGIN
	SELECT @UrlID = UrlID FROM [<dbUser,varchar,dbo>].[subtext_Urls] WHERE Url = @Url
END
Else
BEGIN
	IF(@Url != '' AND NOT @Url IS NULL)
		INSERT subtext_Urls VALUES (@Url)
		SELECT @UrlID = SCOPE_IDENTITY()
END


GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

GRANT  EXECUTE  ON [<dbUser,varchar,dbo>].[subtext_GetUrlID]  TO [public]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

CREATE PROC [<dbUser,varchar,dbo>].[subtext_InsertCategory]
(
	@Title nvarchar(150)
	, @Active bit
	, @BlogId int
	, @CategoryType tinyint
	, @Description nvarchar(1000)
	, @CategoryID int output
)
AS
Set NoCount ON
INSERT INTO subtext_LinkCategories 
( 
	Title
	, Active
	, CategoryType
	, [Description]
	, BlogId )
VALUES 
(
	@Title
	, @Active
	, @CategoryType
	, @Description
	, @BlogId
)
SELECT @CategoryID = SCOPE_IDENTITY()


GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

GRANT  EXECUTE  ON [<dbUser,varchar,dbo>].[subtext_InsertCategory]  TO [public]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

CREATE PROC [<dbUser,varchar,dbo>].[subtext_InsertEntryViewCount]-- 1, 0, 1
(
	@EntryID int,
	@BlogId int,
	@IsWeb bit
)

AS

BEGIN
	--Do we have an existing entry in the subtext_InsertEntryViewCount table?
	IF EXISTS(SELECT EntryID FROM [<dbUser,varchar,dbo>].[subtext_EntryViewCount] WHERE EntryID = @EntryID AND BlogId = @BlogId)
	BEGIN
		if(@IsWeb = 1) -- Is this a web view?
		BEGIN
			UPDATE [<dbUser,varchar,dbo>].[subtext_EntryViewCount]
			Set [WebCount] = [WebCount] + 1, WebLastUpdated = getdate()
			WHERE EntryID = @EntryID AND BlogId = @BlogId
		END
		else
		BEGIN
			UPDATE [<dbUser,varchar,dbo>].[subtext_EntryViewCount]
			Set [AggCount] = [AggCount] + 1, AggLastUpdated = getdate()
			WHERE EntryID = @EntryID AND BlogId = @BlogId
		END
	END
	else
	BEGIN
		if(@IsWeb = 1) -- Is this a web view
		BEGIN
			Insert subtext_EntryViewCount (EntryID, BlogId, WebCount, AggCount, WebLastUpdated, AggLastUpdated)
		       values (@EntryID, @BlogId, 1, 0, getdate(), NULL)
		END
		else
		BEGIN
			Insert subtext_EntryViewCount (EntryID, BlogId, WebCount, AggCount, WebLastUpdated, AggLastUpdated)
		       values (@EntryID, @BlogId, 0, 1, NULL, getdate())
		END
	END


END

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

GRANT  EXECUTE  ON [<dbUser,varchar,dbo>].[subtext_InsertEntryViewCount]  TO [public]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

CREATE PROC [<dbUser,varchar,dbo>].[subtext_InsertImage]
(
	@Title nvarchar(250),
	@CategoryID int,
	@Width int,
	@Height int,
	@File nvarchar(50),
	@Active bit,
	@BlogId int,
	@ImageID int output
)
AS
Insert subtext_Images
(
	Title, CategoryID, Width, Height, [File], Active, BlogId
)
Values
(
	@Title, @CategoryID, @Width, @Height, @File, @Active, @BlogId
)
Set @ImageID = SCOPE_IDENTITY()

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

GRANT  EXECUTE  ON [<dbUser,varchar,dbo>].[subtext_InsertImage]  TO [public]
GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

CREATE PROC [<dbUser,varchar,dbo>].[subtext_InsertKeyWord]
(
	@Word nvarchar(100),
	@Text nvarchar(100),
	@ReplaceFirstTimeOnly bit,
	@OpenInNewWindow bit,
	@CaseSensitive bit,
	@Url nvarchar(255),
	@Title nvarchar(100),
	@BlogId int,
	@KeyWordID int output
)

AS

Insert subtext_keywords 
	(Word,[Text],ReplaceFirstTimeOnly,OpenInNewWindow, CaseSensitive,Url,Title,BlogId)
Values
	(@Word,@Text,@ReplaceFirstTimeOnly,@OpenInNewWindow, @CaseSensitive,@Url,@Title,@BlogId)

SELECT @KeyWordID = SCOPE_IDENTITY()


GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

GRANT  EXECUTE  ON [<dbUser,varchar,dbo>].[subtext_InsertKeyWord]  TO [public]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

CREATE PROC [<dbUser,varchar,dbo>].[subtext_InsertLink]
(
	@Title nvarchar(150),
	@Url nvarchar(255),
	@Rss nvarchar(255),
	@Active bit,
	@NewWindow bit,
	@CategoryID int,
	@PostID int = NULL,
	@BlogId int,
	@LinkID int output
)
AS

IF @PostID = -1
	SET @PostID = NULL

INSERT INTO subtext_Links 
( Title, Url, Rss, Active, NewWindow, PostID, CategoryID, BlogId )
VALUES 
(@Title, @Url, @Rss, @Active, @NewWindow, @PostID, @CategoryID, @BlogId);
SELECT @LinkID = SCOPE_IDENTITY()


GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

GRANT  EXECUTE  ON [<dbUser,varchar,dbo>].[subtext_InsertLink]  TO [public]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

CREATE PROC [<dbUser,varchar,dbo>].[subtext_InsertLinkCategoryList]
(
	@CategoryList nvarchar(4000)
	, @PostID int
	, @BlogId int
)
AS

IF @PostID = -1
	SET @PostID = NULL

--DELETE categories that have been removed
DELETE [<dbUser,varchar,dbo>].[subtext_Links] FROM [<dbUser,varchar,dbo>].[subtext_Links]
WHERE 
	CategoryID not in (SELECT str FROM iter_charlist_to_table(@CategoryList,','))
And 
	BlogId = @BlogId AND (PostID = @PostID)

--Add updated/new categories
INSERT INTO subtext_Links ( Title, Url, Rss, Active, NewWindow, PostID, CategoryID, BlogId )
SELECT NULL, NULL, NULL, 1, 0, @PostID, Convert(int, [str]), @BlogId
FROM iter_charlist_to_table(@CategoryList,',')
WHERE 
	Convert(int, [str]) not in (SELECT CategoryID FROM [<dbUser,varchar,dbo>].[subtext_Links] WHERE PostID = @PostID AND BlogId = @BlogId)

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

GRANT  EXECUTE  ON [<dbUser,varchar,dbo>].[subtext_InsertLinkCategoryList]  TO [public]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

CREATE PROC [<dbUser,varchar,dbo>].[subtext_InsertReferral]
(
	@EntryID int,
	@BlogId int,
	@Url nvarchar(255)
)
AS

DECLARE @UrlID int

if(@Url is not NULL)
BEGIN
	EXEC [<dbUser,varchar,dbo>].[subtext_GetUrlID] @Url, @UrlID = @UrlID output
END

if(@UrlID is not NULL)
BEGIN

	IF EXISTS(SELECT EntryID FROM [<dbUser,varchar,dbo>].[subtext_Referrals] WHERE EntryID = @EntryID AND BlogId = @BlogId AND UrlID = @UrlID)
	BEGIN
		UPDATE [<dbUser,varchar,dbo>].[subtext_Referrals]
		Set [Count] = [Count] + 1, LastUpdated = getdate()
		WHERE EntryID = @EntryID AND BlogId = @BlogId AND UrlID = @UrlID
	END
	else
	BEGIN
		Insert [<dbUser,varchar,dbo>].[subtext_Referrals] (EntryID, BlogId, UrlID, [Count], LastUpdated)
		       values (@EntryID, @BlogId, @UrlID, 1, getdate())
	END
END

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

GRANT  EXECUTE  ON [<dbUser,varchar,dbo>].[subtext_InsertReferral]  TO [public]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO


CREATE PROC [<dbUser,varchar,dbo>].[subtext_InsertViewStats]
(
	@BlogId int,
	@PageType tinyint,
	@PostID int,
	@Day datetime,
	@Url nvarchar(255)
)
AS

DECLARE @UrlID int

if(@Url is not NULL)
BEGIN
	EXEC [<dbUser,varchar,dbo>].[subtext_GetUrlID] @Url, @UrlID = @UrlID output
END
if(@UrlID is NULL)
	set @UrlID = NULL


IF EXISTS (SELECT BlogId FROM [<dbUser,varchar,dbo>].[subtext_ViewStats] WHERE BlogId = @BlogId AND PageType = @PageType AND PostID = @PostID AND [Day] = @Day AND UrlID = @UrlID AND NOT @UrlID IS NULL)
BEGIN
	UPDATE [<dbUser,varchar,dbo>].[subtext_ViewStats]
	Set [Count] = [Count] + 1
	WHERE BlogId = @BlogId AND PageType = @PageType AND PostID = @PostID AND [Day] = @Day AND UrlID = @UrlID
END
Else
BEGIN
	Insert subtext_ViewStats (BlogId, PageType, PostID, [Day], UrlID, [Count])
	Values (@BlogId, @PageType, @PostID, @Day, @UrlID, 1)
END


GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

GRANT  EXECUTE  ON [<dbUser,varchar,dbo>].[subtext_InsertViewStats]  TO [public]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO


CREATE PROC [<dbUser,varchar,dbo>].[subtext_StatsSummary]
(
	@BlogId int
)
AS
DECLARE @ReferralCount int
DECLARE @WebCount int
DECLARE @AggCount int

SELECT @ReferralCount = Sum([Count]) FROM [<dbUser,varchar,dbo>].[subtext_Referrals] WHERE BlogId = @BlogId

SELECT @WebCount = Sum(WebCount), @AggCount = Sum(AggCount) FROM [<dbUser,varchar,dbo>].[subtext_EntryViewCount] WHERE BlogId = @BlogId

SELECT @ReferralCount AS 'ReferralCount', @WebCount AS 'WebCount', @AggCount AS 'AggCount'


GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

GRANT  EXECUTE  ON [<dbUser,varchar,dbo>].[subtext_StatsSummary]  TO [public]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO


CREATE PROC [<dbUser,varchar,dbo>].[subtext_TrackEntry]
(
	@EntryID int,
	@BlogId int,
	@Url nvarchar(255) = NULL,
	@IsWeb bit
)

AS

if(@Url is not NULL AND @IsWeb = 1)
BEGIN
	EXEC [<dbUser,varchar,dbo>].[subtext_InsertReferral] @EntryID, @BlogId, @Url
END

EXEC [<dbUser,varchar,dbo>].[subtext_InsertEntryViewCount] @EntryID, @BlogId, @IsWeb





GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

GRANT  EXECUTE  ON [<dbUser,varchar,dbo>].[subtext_TrackEntry]  TO [public]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO


SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO


CREATE PROC [<dbUser,varchar,dbo>].[subtext_UpdateCategory]
(
	@CategoryID int,
	@Title nvarchar(150),
	@Active bit,
	@CategoryType tinyint,
	@Description nvarchar(1000),
	@BlogId int
)
AS
UPDATE [<dbUser,varchar,dbo>].[subtext_LinkCategories] 
SET 
	[Title] = @Title, 
	[Active] = @Active,
	[CategoryType] = @CategoryType,
	[Description] = @Description
WHERE   
		[CategoryID] = @CategoryID 
	AND [BlogId] = @BlogId

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

GRANT  EXECUTE  ON [<dbUser,varchar,dbo>].[subtext_UpdateCategory]  TO [public]
GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

CREATE PROC [<dbUser,varchar,dbo>].[subtext_UpdateConfig]
(
	@OwnerId uniqueidentifier
	, @Title nvarchar(100)
	, @SubTitle nvarchar(250)
	, @Skin nvarchar(50)
	, @Subfolder nvarchar(50)
	, @Host nvarchar(100)
	, @Language nvarchar(10)
	, @TimeZone int = NULL
	, @ItemCount int
	, @CategoryListPostCount int
	, @News nText = NULL
	, @LastUpdated datetime = NULL
	, @SecondaryCss nText = NULL
	, @SkinCssFile varchar(100) = NULL
	, @Flag int = NULL
	, @BlogId int
	, @LicenseUrl nvarchar(64) = NULL
	, @DaysTillCommentsClose int = NULL
	, @CommentDelayInMinutes int = NULL
	, @NumberOfRecentComments int = NULL
	, @RecentCommentsLength int = NULL
	, @AkismetAPIKey varchar(16) = NULL
	, @FeedBurnerName nvarchar(64) = NULL
	, @pop3User varchar(32) = NULL
	, @pop3Pass varchar(32) = NULL
	, @pop3Server varchar(56) = NULL
	, @pop3StartTag varchar(10) = NULL
	, @pop3EndTag varchar(10) = NULL
	, @pop3SubjectPrefix nvarchar(10) = NULL
	, @pop3MTBEnable bit = NULL
	, @pop3DeleteOnlyProcessed bit = NULL
	, @pop3InlineAttachedPictures bit = NULL
	, @pop3HeightForThumbs int = NULL
)
AS
UPDATE [<dbUser,varchar,dbo>].[subtext_Config]
Set
	OwnerId = @OwnerId      
	, Title	   =   @Title        
	, SubTitle   =   @SubTitle     
	, Skin	  =    @Skin         
	, Subfolder =  @Subfolder
	, Host	  =    @Host         
	, [Language] = @Language
	, TimeZone   = @TimeZone
	, ItemCount = @ItemCount
	, CategoryListPostCount = @CategoryListPostCount
	, News      = @News
	, LastUpdated = @LastUpdated
	, Flag = @Flag
	, SecondaryCss = @SecondaryCss
	, SkinCssFile = @SkinCssFile
	, LicenseUrl = @LicenseUrl
	, DaysTillCommentsClose = @DaysTillCommentsClose
	, CommentDelayInMinutes = @CommentDelayInMinutes
	, NumberOfRecentComments = @NumberOfRecentComments
	, RecentCommentsLength = @RecentCommentsLength
	, AkismetAPIKey = @AkismetAPIKey
	, FeedBurnerName = @FeedBurnerName
	, pop3User = @pop3User
	, pop3Pass = @pop3Pass
	, pop3Server = @pop3Server
	, pop3StartTag = @pop3StartTag
	, pop3EndTag = @pop3EndTag
	, pop3SubjectPrefix = @pop3SubjectPrefix
	, pop3MTBEnable = @pop3MTBEnable
	, pop3DeleteOnlyProcessed = @pop3DeleteOnlyProcessed
	, pop3InlineAttachedPictures = @pop3InlineAttachedPictures
	, pop3HeightForThumbs = @pop3HeightForThumbs
	
WHERE BlogId = @BlogId

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

GRANT  EXECUTE  ON [<dbUser,varchar,dbo>].[subtext_UpdateConfig]  TO [public]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO


CREATE PROC [<dbUser,varchar,dbo>].[subtext_UpdateConfigUpdateTime]
(
	@BlogId int,
	@LastUpdated datetime
)
AS
UPDATE [<dbUser,varchar,dbo>].[subtext_Config]
SET LastUpdated = @LastUpdated
WHERE BlogId = @BlogId


GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

GRANT  EXECUTE  ON [<dbUser,varchar,dbo>].[subtext_UpdateConfigUpdateTime]  TO [public]
GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

CREATE PROC [<dbUser,varchar,dbo>].[subtext_UpdateEntry]
(
	@ID int
	, @Title nvarchar(255)
	, @Text ntext = NULL
	, @PostType int
	, @AuthorId uniqueidentifier
	, @Description nvarchar(500) = NULL
	, @DateUpdated datetime = NULL
	, @PostConfig int
	, @EntryName nvarchar(150) = NULL
	, @DateSyndicated DateTime = NULL
	, @BlogId int
)
AS

IF(LEN(RTRIM(LTRIM(@EntryName))) = 0)
	SET @EntryName = NULL

IF(@EntryName IS NOT NULL)
BEGIN
	IF EXISTS(SELECT EntryName FROM [<dbUser,varchar,dbo>].[subtext_Content] WHERE BlogId = @BlogId AND EntryName = @EntryName AND [ID] <> @ID)
	BEGIN
		RAISERROR('The EntryName of your entry is already in use with in this Blog. Please pick a unique EntryName.', 11, 1) 
		RETURN 1
	END
END
IF(LTRIM(RTRIM(@Description)) = '')
SET @Description = NULL

UPDATE [<dbUser,varchar,dbo>].[subtext_Content] 
SET 
	Title = @Title 
	, [Text] = @Text 
	, PostType = @PostType
	, AuthorId = @AuthorId
	, [Description] = @Description
	, DateUpdated = @DateUpdated
	, PostConfig = @PostConfig
	, EntryName = @EntryName
	, DateSyndicated = @DateSyndicated
WHERE 	
		[ID] = @ID 
	AND BlogId = @BlogId
EXEC [<dbUser,varchar,dbo>].[subtext_UpdateConfigUpdateTime] @BlogId, @DateUpdated

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

GRANT  EXECUTE  ON [<dbUser,varchar,dbo>].[subtext_UpdateEntry]  TO [public]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

CREATE PROC [<dbUser,varchar,dbo>].[subtext_UpdateImage]
(
	@Title nvarchar(250),
	@CategoryID int,
	@Width int,
	@Height int,
	@File nvarchar(50),
	@Active bit,
	@BlogId int,
	@ImageID int
)
AS
UPDATE [<dbUser,varchar,dbo>].[subtext_Images]
Set
	Title = @Title,
	CategoryID = @CategoryID,
	Width = @Width,
	Height = @Height,
	[File] = @File,
	Active = @Active
	
WHERE
	ImageID = @ImageID AND BlogId = @BlogId

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

GRANT  EXECUTE  ON [<dbUser,varchar,dbo>].[subtext_UpdateImage]  TO [public]
GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

CREATE PROC [<dbUser,varchar,dbo>].[subtext_UpdateKeyWord]
(
	@KeyWordID int,
	@Word nvarchar(100),
	@Text nvarchar(100),
	@ReplaceFirstTimeOnly bit,
	@OpenInNewWindow bit,
	@CaseSensitive bit,
	@Url nvarchar(255),
	@Title nvarchar(100),
	@BlogId int
)

AS

UPDATE [<dbUser,varchar,dbo>].[subtext_keywords] 
	Set
		Word = @Word,
		[Text] = @Text,
		ReplaceFirstTimeOnly = @ReplaceFirstTimeOnly,
		OpenInNewWindow = @OpenInNewWindow,
		CaseSensitive = @CaseSensitive,
		Url = @Url,
		Title = @Title
	WHERE
		BlogId = @BlogId AND KeyWordID = @KeyWordID


GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

GRANT  EXECUTE  ON [<dbUser,varchar,dbo>].[subtext_UpdateKeyWord]  TO [public]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO


CREATE PROC [<dbUser,varchar,dbo>].[subtext_UpdateLink]
(
	@LinkID int,
	@Title nvarchar(150),
	@Url nvarchar(255),
	@Rss nvarchar(255),
	@Active bit,
	@NewWindow bit,
	@CategoryID int,
	@BlogId int
	
)
AS
UPDATE [<dbUser,varchar,dbo>].[subtext_Links] 
SET 
	Title = @Title, 
	Url = @Url, 
	Rss = @Rss, 
	Active = @Active,
	NewWindow = @NewWindow, 
	CategoryID = @CategoryID
WHERE  
		LinkID = @LinkID 
	AND BlogId = @BlogId


GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

GRANT  EXECUTE  ON [<dbUser,varchar,dbo>].[subtext_UpdateLink]  TO [public]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

/*
Returns a page of blogs within subtext_config table
*/
CREATE PROC [<dbUser,varchar,dbo>].[subtext_GetPageableBlogs]
(
	@PageIndex int
	, @PageSize int
	, @Host nvarchar(100) = NULL
	, @ConfigurationFlags int
)
AS

DECLARE @FirstId int
DECLARE @StartRow int
DECLARE @StartRowIndex int

SET @StartRowIndex = @PageIndex * @PageSize + 1

SET ROWCOUNT @StartRowIndex
SELECT	@FirstId = [BlogId] FROM [<dbUser,varchar,dbo>].[subtext_Config]
WHERE @ConfigurationFlags & Flag = @ConfigurationFlags
	AND (Host = @Host OR @Host IS NULL)
ORDER BY [BlogId] ASC

SET ROWCOUNT @PageSize

SELECT
		BlogId
		, OwnerId
		, ApplicationId
		, Title
		, SubTitle
		, Skin
		, Subfolder
		, Host
		, TimeZone
		, ItemCount
		, CategoryListPostCount
		, [Language]
		, News
		, SecondaryCss
		, LastUpdated
		, PostCount
		, StoryCount
		, PingTrackCount
		, CommentCount
		, Flag
		, SkinCssFile 
		, LicenseUrl
		, DaysTillCommentsClose
		, CommentDelayInMinutes
		, NumberOfRecentComments
		, RecentCommentsLength
		, AkismetAPIKey
		, FeedBurnerName
		, pop3User
		, pop3Pass
		, pop3Server
		, pop3StartTag
		, pop3EndTag
		, pop3SubjectPrefix
		, pop3MTBEnable
		, pop3DeleteOnlyProcessed
		, pop3InlineAttachedPictures
		, pop3HeightForThumbs
		
	FROM [<dbUser,varchar,dbo>].[subtext_Config]
	WHERE 
		BlogId >= @FirstId
	AND @ConfigurationFlags & Flag = @ConfigurationFlags
	AND (Host = @Host OR @Host IS NULL)
ORDER BY BlogId ASC

SELECT COUNT([BlogId]) AS TotalRecords
FROM [<dbUser,varchar,dbo>].[subtext_config]
WHERE @ConfigurationFlags & Flag = @ConfigurationFlags
	AND (Host = @Host OR @Host IS NULL)
GO

GRANT  EXECUTE  ON [<dbUser,varchar,dbo>].[subtext_GetPageableBlogs]  TO [public]
GO


SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
SET ANSI_WARNINGS OFF
GO

CREATE PROC [<dbUser,varchar,dbo>].[subtext_InsertFeedback]
(
	@Title nvarchar(256)
	, @Body ntext = NULL
	, @BlogId int
	, @EntryId int = NULL
	, @Author nvarchar(64) = NULL
	, @IsBlogAuthor bit = 0
	, @Email varchar(128) = NULL
	, @Url varchar(256) = NULL
	, @FeedbackType int
	, @StatusFlag int
	, @CommentAPI bit
	, @Referrer varchar(256) = NULL
	, @IpAddress varchar(16) = NULL
	, @UserAgent nvarchar(128) = NULL
	, @FeedbackChecksumHash varchar(32)
	, @DateCreated datetime
	, @DateModified datetime = NULL
	, @Id int output	
)
AS

IF @DateModified IS NULL
    SET @DateModified = getdate()
    
INSERT INTO [<dbUser,varchar,dbo>].[subtext_Feedback]
( 
	Title
	, Body
	, BlogId
	, EntryId
	, Author
	, IsBlogAuthor
	, Email
	, Url
	, FeedbackType
	, StatusFlag
	, CommentAPI
	, Referrer
	, IpAddress
	, UserAgent
	, FeedbackChecksumHash
	, DateCreated
	, DateModified
)
VALUES 
(
	@Title
	, @Body
	, @BlogId
	, @EntryId
	, @Author
	, @IsBlogAuthor
	, @Email
	, @Url
	, @FeedbackType
	, @StatusFlag
	, @CommentAPI
	, @Referrer
	, @IpAddress
	, @UserAgent
	, @FeedbackChecksumHash
	, @DateCreated
	, @DateModified
)

SELECT @Id = SCOPE_IDENTITY()

exec [<dbUser,varchar,dbo>].[subtext_UpdateFeedbackCount] @BlogId, @EntryId


GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

GRANT  EXECUTE  ON [<dbUser,varchar,dbo>].[subtext_InsertFeedback]  TO [public]
GO


SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO
CREATE PROC [<dbUser,varchar,dbo>].[subtext_UpdateFeedback]
(
	@ID int
	, @Title nvarchar(256)
	, @Body ntext = NULL
	, @Author nvarchar(64) = NULL
	, @Email varchar(128) = NULL
	, @Url varchar(256) = NULL
	, @StatusFlag int
	, @FeedbackChecksumHash varchar(32)
	, @DateModified datetime
)
AS

DECLARE @EntryId int
DECLARE @BlogId int
SELECT @EntryId = EntryId, @BlogId = BlogId FROM [<dbUser,varchar,dbo>].[subtext_Feedback] WHERE Id = @Id

UPDATE [<dbUser,varchar,dbo>].[subtext_Feedback]
SET	Title = @Title
	, Body = @Body
	, Author = @Author
	, Email = @Email
	, Url = @Url
	, StatusFlag = @StatusFlag
	, FeedbackChecksumHash = @FeedbackChecksumHash
	, DateModified = @DateModified
WHERE Id = @Id

exec [<dbUser,varchar,dbo>].[subtext_UpdateFeedbackCount] @BlogId, @EntryId

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

GRANT  EXECUTE  ON [<dbUser,varchar,dbo>].[subtext_UpdateFeedback]  TO [public]
GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

CREATE PROC [<dbUser,varchar,dbo>].[subtext_InsertEntry]
(
	@Title nvarchar(255)
	, @AuthorId uniqueidentifier
	, @Text ntext = NULL
	, @PostType int
	, @Description nvarchar(500) = NULL
	, @BlogId int
	, @DateAdded datetime
	, @PostConfig int
	, @EntryName nvarchar(150) = NULL
	, @DateSyndicated DateTime = NULL
	, @ID int output
)
AS

IF(LEN(RTRIM(LTRIM(@EntryName))) = 0)
	SET @EntryName = NULL

IF(@EntryName IS NOT NULL)
BEGIN
	IF EXISTS(SELECT EntryName FROM [<dbUser,varchar,dbo>].[subtext_Content] WHERE BlogId = @BlogId AND EntryName = @EntryName)
	BEGIN
		RAISERROR('The EntryName of your entry is already in use with in this Blog. Please pick a unique EntryName.', 11, 1) 
		RETURN 1
	END
END
IF(LTRIM(RTRIM(@Description)) = '')
SET @Description = NULL

INSERT INTO subtext_Content 
(
	Title
	, AuthorId
	, [Text]
	, PostType
	, DateAdded
	, DateUpdated
	, [Description]
	, PostConfig
	, FeedbackCount
	, BlogId
	, EntryName 
	, DateSyndicated
)
VALUES 
(
	@Title
	, @AuthorId
	, @Text
	, @PostType
	, @DateAdded
	, @DateAdded
	, @Description
	, @PostConfig
	, 0 -- Feedback Count
	, @BlogId
	, @EntryName
	, @DateSyndicated
)
SELECT @ID = SCOPE_IDENTITY()

EXEC [<dbUser,varchar,dbo>].[subtext_UpdateConfigUpdateTime] @BlogId, @DateAdded


GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

GRANT  EXECUTE  ON [<dbUser,varchar,dbo>].[subtext_InsertEntry]  TO [public]
GO


SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

/*
Retrieves a comment (or pingback) that has the specified 
FeedbackChecksumHash.
*/
CREATE PROC [<dbUser,varchar,dbo>].[subtext_GetCommentByChecksumHash]
(
	@FeedbackChecksumHash varchar(32)
	, @BlogId int
)
AS
SELECT TOP 1 f.Title
		, f.Body
		, f.BlogId
		, f.EntryId
		, f.Author
		, f.IsBlogAuthor
		, f.Email
		, f.Url
		, f.FeedbackType
		, f.StatusFlag
		, f.CommentAPI
		, f.Referrer
		, f.IpAddress
		, f.UserAgent
		, f.FeedbackChecksumHash
		, f.DateCreated
		, f.DateModified
		, ParentEntryCreateDate = c.DateAdded
		, ParentEntryName = c.EntryName
FROM [<dbUser,varchar,dbo>].[subtext_Feedback] f
	INNER JOIN [<dbUser,varchar,dbo>].[subtext_Content] c ON f.EntryId = c.ID
WHERE 
	f.FeedbackChecksumHash = @FeedbackChecksumHash
	AND f.BlogId = @BlogId
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

GRANT  EXECUTE  ON [<dbUser,varchar,dbo>].[subtext_GetCommentByChecksumHash]  TO [public]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

CREATE PROC [<dbUser,varchar,dbo>].[DNW_GetRecentPosts]
	@Host nvarchar(100)
	, @GroupID int

AS
SELECT Top 35 Host
	, Subfolder
	, [EntryName] = IsNull(content.EntryName, content.[ID])
	, content.[ID]
	, content.AuthorId
	, content.Title
	, content.DateAdded
	, content.PostType
	, content.FeedbackCount
	, content.EntryName
	, [IsXHTML] = Convert(bit,CASE WHEN content.PostConfig & 2 = 2 THEN 1 else 0 END) 
	, [BlogTitle] = content.Title
	, content.PostConfig
	, config.TimeZone
	, [Description] = IsNull(CASE WHEN PostConfig & 32 = 32 THEN content.[Description] else content.[Text] END, '')
FROM [<dbUser,varchar,dbo>].[subtext_Content] content
INNER JOIN	[<dbUser,varchar,dbo>].[subtext_Config] config ON content.BlogId = config.BlogId
WHERE  content.PostType = 1 
	AND content.PostConfig & 1 = 1 
	AND content.PostConfig & 64 = 64 
	AND config.Flag & 2 = 2 
	AND config.Host = @Host
	AND BlogGroup & @GroupID = @GroupID
ORDER BY [ID] DESC


GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

GRANT  EXECUTE  ON [<dbUser,varchar,dbo>].[DNW_GetRecentPosts]  TO [public]
GO


SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO


CREATE PROC [<dbUser,varchar,dbo>].[DNW_Stats]
(
	@Host nvarchar(100),
	@GroupID int
)
AS
SELECT BlogId
	, OwnerId
	, Subfolder
	, Host
	, Title
	, PostCount
	, CommentCount
	, StoryCount
	, PingTrackCount
	, LastUpdated
FROM [<dbUser,varchar,dbo>].[subtext_Config] 
WHERE PostCount > 0 AND subtext_Config.Flag & 2 = 2 AND Host = @Host AND BlogGroup & @GroupID = @GroupID
ORDER BY PostCount DESC


GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

GRANT  EXECUTE  ON [<dbUser,varchar,dbo>].[DNW_Stats]  TO [public]
GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO


CREATE PROC [<dbUser,varchar,dbo>].[DNW_Total_Stats]
(
	@Host nvarchar(100),
	@GroupID int
)
AS
SELECT Count(*) AS [BlogCount], Sum(PostCount) AS PostCount, Sum(CommentCount) AS CommentCount, Sum(StoryCount) AS StoryCount, Sum(PingTrackCount) AS PingTrackCount 
FROM [<dbUser,varchar,dbo>].[subtext_Config] WHERE subtext_Config.Flag & 2 = 2 AND Host = @Host AND BlogGroup & @GroupID = @GroupID

SET QUOTED_IDENTIFIER ON


GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

GRANT  EXECUTE  ON [DNW_Total_Stats]  TO [public]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO


CREATE PROC [<dbUser,varchar,dbo>].[DNW_HomePageData]
(
	@Host nvarchar(100),
	@GroupID int
)
AS 
EXEC [<dbUser,varchar,dbo>].[DNW_Stats] @Host, @GroupID
EXEC [<dbUser,varchar,dbo>].[DNW_GetRecentPosts] @Host, @GroupID
EXEC [<dbUser,varchar,dbo>].[DNW_Total_Stats] @Host, @GroupID


GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

GRANT  EXECUTE  ON [<dbUser,varchar,dbo>].[DNW_HomePageData]  TO [public]
GO


SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

/* Gets the most recent version in the Version table */
CREATE PROC [<dbUser,varchar,dbo>].[subtext_VersionGetCurrent]
AS
SELECT	TOP 1
		[Id]
		, [Major]
		, [Minor]
		, [Build]
		, [DateCreated]
FROM	[<dbUser,varchar,dbo>].[subtext_Version]
ORDER BY [DateCreated] DESC

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

GRANT  EXECUTE  ON [<dbUser,varchar,dbo>].[subtext_VersionGetCurrent]  TO [public]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

/* Gets the most recent version in the Version table */
CREATE PROC [<dbUser,varchar,dbo>].[subtext_VersionAdd]
(
	 @Major	INT
	, @Minor INT
	, @Build INT
	, @DateCreated DATETIME = NULL
	, @Id INT = NULL OUTPUT
)
AS

IF @DateCreated IS NULL
	SET @DateCreated = getdate()

INSERT [<dbUser,varchar,dbo>].[subtext_Version]
SELECT	@Major, @Minor, @Build, @DateCreated

SELECT @Id = SCOPE_IDENTITY()

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

GRANT  EXECUTE  ON [<dbUser,varchar,dbo>].[subtext_VersionAdd]  TO [public]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

/* Creates a record in the subtext_log table */
CREATE PROC [<dbUser,varchar,dbo>].[subtext_LogClear]
(
	@BlogId int = NULL
)
AS

IF(@BlogId IS NULL)
	TRUNCATE TABLE [<dbUser,varchar,dbo>].[subtext_Log]
ELSE
	DELETE [<dbUser,varchar,dbo>].[subtext_Log] WHERE [BlogId] = @BlogId

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

GRANT  EXECUTE  ON [<dbUser,varchar,dbo>].[subtext_LogClear]  TO [public]
GO


SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

/* Creates a record in the subtext_log table */
CREATE PROC [<dbUser,varchar,dbo>].[subtext_AddLogEntry]
(
	 @Date DateTime
	 , @BlogId int = NULL
	 , @Thread varchar(255)
	 , @Context varchar(512)
	 , @Level varchar(20)
	 , @Logger nvarchar(256)
	 , @Message nvarchar(2000)
	 , @Exception nvarchar(1000)
	 , @Url varchar(255)
)
AS

if @BlogId < 0
	SET @BlogId = NULL

INSERT [<dbUser,varchar,dbo>].[subtext_Log]
SELECT	@BlogId, @Date, @Thread, @Context, @Level, @Logger, @Message, @Exception, @Url

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

GRANT  EXECUTE  ON [<dbUser,varchar,dbo>].[subtext_AddLogEntry]  TO [public]
GO

/*Search Entries-GY*/
SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

CREATE PROC [<dbUser,varchar,dbo>].subtext_SearchEntries
(
	@BlogId int
	, @SearchStr nvarchar(30)
)
as

Set @SearchStr = '%' + @SearchStr + '%'

Select [ID]
	, Title
	, DateAdded
	, EntryName
	, PostType
From [<dbUser,varchar,dbo>].[subtext_Content]
Where (PostType = 1 OR PostType = 2)
	AND PostConfig & 1 = 1 -- IsActive!
	AND ([Text] LIKE @SearchStr OR Title LIKE @SearchStr)
	AND BlogId = @BlogId
	
GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

GRANT  EXECUTE  ON [<dbUser,varchar,dbo>].[subtext_SearchEntries]  TO [public]
GO

/*Previous Next*/
IF EXISTS (SELECT * FROM [information_schema].[routines] WHERE routine_name = 'Subtext_GetEntry_PreviousNext' AND routine_schema = '<dbUser,varchar,dbo>')
DROP PROCEDURE [<dbUser,varchar,dbo>].[Subtext_GetEntry_PreviousNext]
GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

CREATE PROC [<dbUser,varchar,dbo>].[Subtext_GetEntry_PreviousNext]
(
	@ID int
	, @PostType int = 1
	, @BlogId int
)
AS

DECLARE @DateSyndicated DateTime
SELECT @DateSyndicated = ISNULL(DateSyndicated, DateAdded) 
FROM [<dbUser,varchar,dbo>].[subtext_Content]
WHERE ID = @ID

SELECT * FROM
(
	SELECT Top 1 BlogId
		, [ID]
		, Title
		, DateAdded
		, PostType
		, PostConfig
		, EntryName 
		, DateSyndicated
		, CardinalityDate = ISNULL(DateSyndicated, DateAdded) -- Must be here to order by
	FROM [<dbUser,varchar,dbo>].[subtext_Content]
	WHERE ISNULL([DateSyndicated], [DateAdded]) >= @DateSyndicated
		AND Subtext_Content.BlogId = @BlogId 
		AND Subtext_Content.PostConfig & 1 = 1 
		AND PostType = @PostType
		AND [ID] != @ID
	ORDER BY ISNULL(DateSyndicated, DateAdded) ASC
) [Previous]
UNION
SELECT * FROM
(
	SELECT Top 1 BlogId
		, [ID]
		, Title
		, DateAdded
		, PostType
		, PostConfig
		, EntryName 
		, DateSyndicated
		, CardinalityDate = ISNULL(DateSyndicated, DateAdded)
	FROM [<dbUser,varchar,dbo>].[subtext_Content]
	WHERE ISNULL([DateSyndicated], [DateAdded]) <= @DateSyndicated
		AND Subtext_Content.BlogId = @BlogId 
		AND Subtext_Content.PostConfig & 1 = 1 
		AND PostType = @PostType
		AND [ID] != @ID
	ORDER BY ISNULL(DateSyndicated, DateAdded) DESC
) [Next]

ORDER BY CardinalityDate DESC

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

GRANT  EXECUTE  ON [<dbUser,varchar,dbo>].[Subtext_GetEntry_PreviousNext]  TO [public]
GO


/*Get Related Links (called from RelatedLinks.ascx) - GY*/
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

CREATE PROCEDURE [<dbUser,varchar,dbo>].[subtext_GetRelatedLinks] 
@BlogId int,
@EntryID int
AS

Select Distinct Top 10 c.ID EntryID, c.Title, c.DateAdded 
From [<dbUser,varchar,dbo>].subtext_LinkCategories lc, [<dbUser,varchar,dbo>].subtext_Links l, [<dbUser,varchar,dbo>].subtext_Content c 
Where lc.CategoryType = 1 
And lc.Active = 1
And l.CategoryID = lc.CategoryID
And l.CategoryID In (Select CategoryID From [<dbUser,varchar,dbo>].subtext_links Where PostID = @EntryID)
And l.PostID = c.ID
And c.BlogId = @BlogId --param
And c.ID <> @EntryID --param --do not list the same entry in related links
Order By c.DateAdded Desc


GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

GRANT  EXECUTE  ON [<dbUser,varchar,dbo>].[subtext_GetRelatedLinks]  TO [public]
GO

/*Top10Posts - (called from Top10Module.ascx) - GY*/
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

CREATE PROCEDURE [<dbUser,varchar,dbo>].[subtext_GetTop10byBlogId]  
@BlogId int
AS
Select Distinct top 10 evc.EntryId, (evc.WebCount + evc.AggCount) As mcount, c.title, c.DateAdded
From [<dbUser,varchar,dbo>].subtext_EntryViewCount evc, [<dbUser,varchar,dbo>].subtext_Content c
Where evc.EntryId = c.Id
And c.BlogId = @BlogId --param
Order By mcount desc

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

GRANT  EXECUTE  ON [<dbUser,varchar,dbo>].[subtext_GetTop10byBlogId]  TO [public]
GO

/*
Selects a page of blog posts for export to blogml. These are 
sorted ascending by id to map to the database.
*/
CREATE PROC [<dbUser,varchar,dbo>].[subtext_GetEntriesForBlogMl]
(
	@BlogId int
	, @PageIndex int
	, @PageSize int
)
AS

DECLARE @FirstId int
DECLARE @StartRow int
DECLARE @StartRowIndex int

SET @StartRowIndex = @PageIndex * @PageSize + 1

SET ROWCOUNT @StartRowIndex
-- Get the first entry id for the current page.
SELECT	@FirstId = [ID] FROM [<dbUser,varchar,dbo>].[subtext_Content]
WHERE	BlogId = @BlogId 
	AND (PostType = 1 OR PostType = 2) -- PostType 1 = BlogPost, 2 = Story
ORDER BY [ID] ASC

-- Now, set the row count to MaximumRows and get
-- all records >= @first_id
SET ROWCOUNT @PageSize

CREATE Table #IDs  
(  
	 TempId int IDENTITY (0, 1) NOT NULL,  
	 Id int not NULL  
)

-- Store the IDs for this page in a temp table.
INSERT #IDs (Id)  
SELECT [Id]   
FROM [<dbUser,varchar,dbo>].[subtext_Content]
WHERE	(PostType = 1 OR PostType = 2)
	AND BlogId = @BlogId
	AND [ID] >= @FirstId
ORDER BY Id ASC

SET ROWCOUNT 0

SELECT	content.BlogId 
		, idTable.[ID] 
		, content.AuthorId
		, content.Title 
		, content.DateAdded 
		, content.[Text] 
		, content.[Description]
		, content.PostType 
		, content.DateUpdated 
		, FeedbackCount = ISNULL(content.FeedbackCount, 0)
		, content.PostConfig
		, content.EntryName
		, content.DateSyndicated
		
FROM [<dbUser,varchar,dbo>].[subtext_Content] content
	INNER JOIN #IDs idTable ON idTable.Id = content.[ID]
ORDER BY idTable.[ID] ASC
 
SELECT COUNT([ID]) AS TotalRecords
FROM [<dbUser,varchar,dbo>].[subtext_Content] 
WHERE 	BlogId = @BlogId 
	AND PostType = 1 OR PostType = 2

-- Select associated categories
SELECT	p.[Id]
		, c.CategoryID
	FROM [<dbUser,varchar,dbo>].[subtext_Links] l
		INNER JOIN #IDs p ON l.[PostID] = p.[ID]  
		INNER JOIN [<dbUser,varchar,dbo>].[subtext_LinkCategories] c ON l.CategoryID = c.CategoryID
	ORDER BY p.[ID] ASC

-- Select associated comments
SELECT	f.[Id]
		, Title
		, Body
		, BlogId
		, EntryId
		, Author
		, IsBlogAuthor
		, Email
		, Url
		, FeedbackType
		, StatusFlag
		, CommentAPI
		, Referrer
		, IpAddress
		, UserAgent
		, FeedbackChecksumHash
		, DateCreated
		, DateModified
FROM [<dbUser,varchar,dbo>].[subtext_Feedback] f
	INNER JOIN #IDs idTable ON idTable.Id = f.[EntryId]
	WHERE f.FeedbackType = 1 -- Comment
ORDER BY idTable.[ID] ASC

-- Select associated track/ping backs.
SELECT	f.[Id]
		, Title
		, Body
		, BlogId
		, EntryId
		, Author
		, IsBlogAuthor
		, Email
		, Url
		, FeedbackType
		, StatusFlag
		, CommentAPI
		, Referrer
		, IpAddress
		, UserAgent
		, FeedbackChecksumHash
		, DateCreated
		, DateModified
FROM [<dbUser,varchar,dbo>].[subtext_Feedback] f
	INNER JOIN #IDs idTable ON idTable.Id = f.[EntryId]
	WHERE f.FeedbackType = 2 -- Trackback/Pingback

ORDER BY idTable.[ID] ASC

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

GRANT  EXECUTE  ON [<dbUser,varchar,dbo>].[subtext_GetEntriesForBlogMl] TO [public]
GO




/*
	subtext_GetPostsByCategoriesArchive - (called from CategoryCloud.ascx) - SCH
	retrieves all active categories with realative post number
*/
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

CREATE PROCEDURE [<dbUser,varchar,dbo>].[subtext_GetPostsByCategoriesArchive]  
(
	@BlogId int = NULL
)
AS

SELECT	[Id] = c.CategoryID
		, c.Title 
		, [Count] = COUNT(1)
		, [Month] = 1
		, [Year] = 1
		, [Day] = 1
	
FROM [<dbUser,varchar,dbo>].[subtext_LinkCategories] c 
	INNER JOIN [<dbUser,varchar,dbo>].[subtext_Links] l on c.CategoryID = l.CategoryID
WHERE	c.Active= 1 
	AND	(c.BlogId = @BlogId OR @BlogId IS NULL)
	AND	c.CategoryType = 1 -- post category

GROUP BY c.CategoryID, c.Title
ORDER BY c.Title

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

GRANT  EXECUTE  ON [<dbUser,varchar,dbo>].[subtext_GetPostsByCategoriesArchive]  TO [public]
GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

CREATE PROC [<dbUser,varchar,dbo>].[subtext_GetBlogKeyWords]
(
	@BlogId int
)
AS

SELECT 
	KeyWordID
	, Word
	, Rel
	, [Text]
	, ReplaceFirstTimeOnly
	, OpenInNewWindow
	, CaseSensitive
	, Url
	, Title
	, BlogId
FROM
	[<dbUser,varchar,dbo>].[subtext_keywords]
WHERE 
	BlogId = @BlogId

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

GRANT  EXECUTE  ON [<dbUser,varchar,dbo>].[subtext_GetBlogKeyWords]  TO [public]
GO


/*	ClearBlogContent - used to delete all content (Entries, Comments, Track/Ping-backs, Statistices, etc...)
	for a given blog (sans the Image Galleries). Used from the Admin -> Import/Export Page.
*/
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

CREATE PROCEDURE [<dbUser,varchar,dbo>].[subtext_ClearBlogContent]
	@BlogId int
AS
DELETE FROM [<dbUser,varchar,dbo>].subtext_Referrals WHERE BlogId = @BlogId
DELETE FROM [<dbUser,varchar,dbo>].subtext_Log WHERE BlogId = @BlogId
DELETE FROM [<dbUser,varchar,dbo>].subtext_Links WHERE BlogId = @BlogId
--DELETE FROM [<dbUser,varchar,dbo>].subtext_Images WHERE BlogId = @BlogId  -- Don't want to wipe out the images this way b/c that would leave them on the disk.
DELETE FROM [<dbUser,varchar,dbo>].subtext_LinkCategories WHERE BlogId = @BlogId AND CategoryType <> 3 -- We're not doing Image Galleries.
DELETE FROM [<dbUser,varchar,dbo>].subtext_KeyWords WHERE BlogId = @BlogId
DELETE FROM [<dbUser,varchar,dbo>].subtext_EntryViewCount WHERE BlogId = @BlogId
DELETE FROM [<dbUser,varchar,dbo>].subtext_FeedBack WHERE BlogId = @BlogId
DELETE FROM [<dbUser,varchar,dbo>].subtext_Content WHERE BlogId = @BlogId

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

GRANT  EXECUTE  ON [<dbUser,varchar,dbo>].[subtext_ClearBlogContent]  TO [public]
GO




SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS OFF 
GO

CREATE PROC [<dbUser,varchar,dbo>].[subtext_UpdatePluginData]
(
	@PluginID uniqueidentifier,
	@BlogID int,
	@EntryID int,
	@Key nvarchar(256),
	@Value ntext
)
AS

UPDATE [<dbUser,varchar,dbo>].[subtext_PluginData]
SET
	[Value]=@Value
FROM [<dbUser,varchar,dbo>].[subtext_PluginBlog]
WHERE [<dbUser,varchar,dbo>].[subtext_PluginBlog].PluginID=@PluginID AND [<dbUser,varchar,dbo>].[subtext_PluginBlog].BlogID=@BlogID AND [<dbUser,varchar,dbo>].[subtext_PluginBlog].[Id]=[<dbUser,varchar,dbo>].[subtext_PluginData].BlogPluginID AND [<dbUser,varchar,dbo>].[subtext_PluginBlog].Enabled=1 AND [Key]=@Key AND EntryID=@EntryID
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS OFF 
GO


CREATE PROC [<dbUser,varchar,dbo>].[subtext_InsertPluginData]
(
	@PluginID uniqueidentifier,
	@BlogID int,
	@EntryID int,
	@Key nvarchar(256),
	@Value ntext
)
AS

DECLARE @BlogPluginID int

SELECT @BlogPluginID=[Id] FROM [<dbUser,varchar,dbo>].[subtext_PluginBlog]
WHERE PluginID=@PluginID AND BlogID=@BlogID

INSERT INTO [<dbUser,varchar,dbo>].[subtext_PluginData]
(
	BlogPluginID,
	EntryID,
	[Key],
	[Value]
)
VALUES
(
	@BlogPluginID,
	@EntryID,
	@Key,
	@Value
)


GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO


SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS OFF 
GO

CREATE PROCEDURE [<dbUser,varchar,dbo>].[subtext_DeletePluginBlog]
(
	@PluginID uniqueidentifier,
	@BlogId int
)
as

UPDATE  [<dbUser,varchar,dbo>].[subtext_PluginBlog]
SET Enabled=0
WHERE PluginID=@PluginID AND BlogId=@BlogId 
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS OFF 
GO

CREATE PROCEDURE [<dbUser,varchar,dbo>].[subtext_GetPluginBlog]
(
	@BlogId int
)

AS

SELECT PluginID FROM [<dbUser,varchar,dbo>].[subtext_PluginBlog]
WHERE
BlogID=@BlogId AND Enabled=1
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS OFF 
GO

CREATE PROCEDURE [<dbUser,varchar,dbo>].[subtext_InsertPluginBlog]
(
	@PluginID uniqueidentifier,
	@BlogId int
)
as

IF NOT EXISTS 
	(
		SELECT * FROM [<dbUser,varchar,dbo>].[subtext_PluginBlog]
		WHERE PluginID=@PluginID AND BlogId=@BlogId
	)

	BEGIN
	
		INSERT INTO [<dbUser,varchar,dbo>].[subtext_PluginBlog]
		(
			PluginID,
			BlogID,
			Enabled
		)
		VALUES
		(
			@PluginID,
			@BlogId,
			1
		)
	END
ELSE

	BEGIN
		UPDATE  [<dbUser,varchar,dbo>].[subtext_PluginBlog]
		SET Enabled=1
		WHERE PluginID=@PluginID AND BlogId=@BlogId 
	END
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO


SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [<dbUser,varchar,dbo>].[subtext_GetPluginData]
(
	@PluginID uniqueidentifier,
	@BlogId int,
	@EntryId int
)
as

SELECT [Key], [Value]
FROM [<dbUser,varchar,dbo>].[subtext_PluginData] INNER JOIN [<dbUser,varchar,dbo>].[subtext_PluginBlog] ON [<dbUser,varchar,dbo>].[subtext_PluginBlog].[Id]=[<dbUser,varchar,dbo>].[subtext_PluginData].BlogPluginID
WHERE [<dbUser,varchar,dbo>].[subtext_PluginBlog].PluginID=@PluginID and [<dbUser,varchar,dbo>].[subtext_PluginBlog].BlogId=@BlogId and EntryId=@EntryId AND [<dbUser,varchar,dbo>].[subtext_PluginBlog].Enabled=1
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

/* Membership SPs */
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE PROCEDURE [<dbUser,varchar,dbo>].[subtext_Setup_RestorePermissions]
    @name   sysname
AS
BEGIN
    DECLARE @object sysname
    DECLARE @protectType char(10)
    DECLARE @action varchar(20)
    DECLARE @grantee sysname
    DECLARE @cmd nvarchar(500)
    DECLARE c1 cursor FORWARD_ONLY FOR
        SELECT Object, ProtectType, [Action], Grantee FROM #subtext_Permissions where Object = @name

    OPEN c1

    FETCH c1 INTO @object, @protectType, @action, @grantee
    WHILE (@@fetch_status = 0)
    BEGIN
        SET @cmd = @protectType + ' ' + @action + ' on ' + @object + ' TO [' + @grantee + ']'
        EXEC (@cmd)
        FETCH c1 INTO @object, @protectType, @action, @grantee
    END

    CLOSE c1
    DEALLOCATE c1
END

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE PROCEDURE [<dbUser,varchar,dbo>].[subtext_Setup_RemoveAllRoleMembers]
    @name   sysname
AS
BEGIN
    CREATE TABLE #subtext_RoleMembers
    (
        Group_name      sysname,
        Group_id        smallint,
        Users_in_group  sysname,
        User_id         smallint
    )

    INSERT INTO #subtext_RoleMembers
    EXEC sp_helpuser @name

    DECLARE @user_id smallint
    DECLARE @cmd nvarchar(500)
    DECLARE c1 cursor FORWARD_ONLY FOR
        SELECT User_id FROM #subtext_RoleMembers

    OPEN c1

    FETCH c1 INTO @user_id
    WHILE (@@fetch_status = 0)
    BEGIN
        SET @cmd = 'EXEC sp_droprolemember ' + '''' + @name + ''', ''' + USER_NAME(@user_id) + ''''
        EXEC (@cmd)
        FETCH c1 INTO @user_id
    END

    CLOSE c1
    DEALLOCATE c1
END

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE PROCEDURE [<dbUser,varchar,dbo>].[subtext_RegisterSchemaVersion]
    @Feature                   nvarchar(128),
    @CompatibleSchemaVersion   nvarchar(128),
    @IsCurrentVersion          bit,
    @RemoveIncompatibleSchema  bit
AS
BEGIN
    IF( @RemoveIncompatibleSchema = 1 )
    BEGIN
        DELETE FROM [<dbUser,varchar,dbo>].[subtext_SchemaVersions] WHERE Feature = LOWER( @Feature )
    END
    ELSE
    BEGIN
        IF( @IsCurrentVersion = 1 )
        BEGIN
            UPDATE [<dbUser,varchar,dbo>].subtext_SchemaVersions
            SET IsCurrentVersion = 0
            WHERE Feature = LOWER( @Feature )
        END
    END

    INSERT  [<dbUser,varchar,dbo>].subtext_SchemaVersions( Feature, CompatibleSchemaVersion, IsCurrentVersion )
    VALUES( LOWER( @Feature ), @CompatibleSchemaVersion, @IsCurrentVersion )
END

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE PROCEDURE [<dbUser,varchar,dbo>].[subtext_CheckSchemaVersion]
    @Feature                   nvarchar(128),
    @CompatibleSchemaVersion   nvarchar(128)
AS
BEGIN
    IF (EXISTS( SELECT  *
                FROM    [<dbUser,varchar,dbo>].subtext_SchemaVersions
                WHERE   Feature = LOWER( @Feature ) AND
                        CompatibleSchemaVersion = @CompatibleSchemaVersion ))
        RETURN 0

    RETURN 1
END

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE PROCEDURE [<dbUser,varchar,dbo>].[subtext_UnRegisterSchemaVersion]
    @Feature                   nvarchar(128),
    @CompatibleSchemaVersion   nvarchar(128)
AS
BEGIN
    DELETE FROM [<dbUser,varchar,dbo>].subtext_SchemaVersions
        WHERE   Feature = LOWER(@Feature) AND @CompatibleSchemaVersion = CompatibleSchemaVersion
END

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [<dbUser,varchar,dbo>].[subtext_Membership_GetUserByName]
    @ApplicationName      nvarchar(256),
    @UserName             nvarchar(256),
    @CurrentTimeUtc       datetime,
    @UpdateLastActivity   bit = 0
AS
BEGIN
    DECLARE @UserId uniqueidentifier

    IF (@UpdateLastActivity = 1)
    BEGIN
        SELECT TOP 1 u.UserName, m.Email, m.PasswordQuestion, m.Comment, m.IsApproved,
                m.CreateDate, m.LastLoginDate, @CurrentTimeUtc, m.LastPasswordChangedDate,
                u.UserId, m.IsLockedOut,m.LastLockoutDate
        FROM    [<dbUser,varchar,dbo>].subtext_Applications a, [<dbUser,varchar,dbo>].subtext_Users u, [<dbUser,varchar,dbo>].subtext_Membership m
        WHERE    LOWER(@ApplicationName) = a.LoweredApplicationName AND
                u.ApplicationId = a.ApplicationId    AND
                LOWER(@UserName) = u.LoweredUserName AND u.UserId = m.UserId

        IF (@@ROWCOUNT = 0) -- Username not found
            RETURN -1

        UPDATE   [<dbUser,varchar,dbo>].subtext_Users
        SET      LastActivityDate = @CurrentTimeUtc
        WHERE    @UserId = UserId
    END
    ELSE
    BEGIN
        SELECT TOP 1 m.Email, m.PasswordQuestion, m.Comment, m.IsApproved,
                m.CreateDate, m.LastLoginDate, u.LastActivityDate, m.LastPasswordChangedDate,
                u.UserId, m.IsLockedOut,m.LastLockoutDate
        FROM    [<dbUser,varchar,dbo>].subtext_Applications a, [<dbUser,varchar,dbo>].subtext_Users u, [<dbUser,varchar,dbo>].subtext_Membership m
        WHERE    LOWER(@ApplicationName) = a.LoweredApplicationName AND
                u.ApplicationId = a.ApplicationId    AND
                LOWER(@UserName) = u.LoweredUserName AND u.UserId = m.UserId

        IF (@@ROWCOUNT = 0) -- Username not found
            RETURN -1
    END

    RETURN 0
END

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [<dbUser,varchar,dbo>].[subtext_Membership_GetUserByUserId]
    @UserId               uniqueidentifier,
    @CurrentTimeUtc       datetime,
    @UpdateLastActivity   bit = 0
AS
BEGIN
    IF ( @UpdateLastActivity = 1 )
    BEGIN
        UPDATE   [<dbUser,varchar,dbo>].subtext_Users
        SET      LastActivityDate = @CurrentTimeUtc
        FROM     [<dbUser,varchar,dbo>].subtext_Users
        WHERE    @UserId = UserId

        IF ( @@ROWCOUNT = 0 ) -- User ID not found
            RETURN -1
    END

    SELECT  m.UserId, m.Email, m.PasswordQuestion, m.Comment, m.IsApproved,
            m.CreateDate, m.LastLoginDate, u.LastActivityDate,
            m.LastPasswordChangedDate, u.UserName, m.IsLockedOut,
            m.LastLockoutDate
    FROM    [<dbUser,varchar,dbo>].subtext_Users u, [<dbUser,varchar,dbo>].subtext_Membership m
    WHERE   @UserId = u.UserId AND u.UserId = m.UserId

    IF ( @@ROWCOUNT = 0 ) -- User ID not found
       RETURN -1

    RETURN 0
END

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [<dbUser,varchar,dbo>].[subtext_Membership_GetUserByEmail]
    @ApplicationName  nvarchar(256),
    @Email            nvarchar(256)
AS
BEGIN
    IF( @Email IS NULL )
        SELECT  u.UserName
        FROM    [<dbUser,varchar,dbo>].subtext_Applications a, [<dbUser,varchar,dbo>].subtext_Users u, [<dbUser,varchar,dbo>].subtext_Membership m
        WHERE   LOWER(@ApplicationName) = a.LoweredApplicationName AND
                u.ApplicationId = a.ApplicationId    AND
                u.UserId = m.UserId AND
                m.LoweredEmail IS NULL
    ELSE
        SELECT  u.UserName
        FROM    [<dbUser,varchar,dbo>].subtext_Applications a, [<dbUser,varchar,dbo>].subtext_Users u, [<dbUser,varchar,dbo>].subtext_Membership m
        WHERE   LOWER(@ApplicationName) = a.LoweredApplicationName AND
                u.ApplicationId = a.ApplicationId    AND
                u.UserId = m.UserId AND
                LOWER(@Email) = m.LoweredEmail

    IF (@@rowcount = 0)
        RETURN(1)
    RETURN(0)
END

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [<dbUser,varchar,dbo>].[subtext_Membership_GetPasswordWithFormat]
    @ApplicationName                nvarchar(256),
    @UserName                       nvarchar(256),
    @UpdateLastLoginActivityDate    bit,
    @CurrentTimeUtc                 datetime
AS
BEGIN
    DECLARE @IsLockedOut                        bit
    DECLARE @UserId                             uniqueidentifier
    DECLARE @Password                           nvarchar(128)
    DECLARE @PasswordSalt                       nvarchar(128)
    DECLARE @PasswordFormat                     int
    DECLARE @FailedPasswordAttemptCount         int
    DECLARE @FailedPasswordAnswerAttemptCount   int
    DECLARE @IsApproved                         bit
    DECLARE @LastActivityDate                   datetime
    DECLARE @LastLoginDate                      datetime

    SELECT  @UserId          = NULL

    SELECT  @UserId = u.UserId, @IsLockedOut = m.IsLockedOut, @Password=Password, @PasswordFormat=PasswordFormat,
            @PasswordSalt=PasswordSalt, @FailedPasswordAttemptCount=FailedPasswordAttemptCount,
		    @FailedPasswordAnswerAttemptCount=FailedPasswordAnswerAttemptCount, @IsApproved=IsApproved,
            @LastActivityDate = LastActivityDate, @LastLoginDate = LastLoginDate
    FROM    [<dbUser,varchar,dbo>].subtext_Applications a, [<dbUser,varchar,dbo>].subtext_Users u, [<dbUser,varchar,dbo>].subtext_Membership m
    WHERE   LOWER(@ApplicationName) = a.LoweredApplicationName AND
            u.ApplicationId = a.ApplicationId    AND
            u.UserId = m.UserId AND
            LOWER(@UserName) = u.LoweredUserName

    IF (@UserId IS NULL)
        RETURN 1

    IF (@IsLockedOut = 1)
        RETURN 99

    SELECT   Password = @Password, PasswordFormat = @PasswordFormat, PasswordSalt = @PasswordSalt, FailedPasswordAttemptCount = @FailedPasswordAttemptCount,
             FailedPasswordAnswerAttemptCount = @FailedPasswordAnswerAttemptCount, IsApproved = @IsApproved, LastLoginDate = @LastLoginDate, LastActivityDate = @LastActivityDate

    IF (@UpdateLastLoginActivityDate = 1 AND @IsApproved = 1)
    BEGIN
        UPDATE  [<dbUser,varchar,dbo>].subtext_Membership
        SET     LastLoginDate = @CurrentTimeUtc
        WHERE   UserId = @UserId

        UPDATE  [<dbUser,varchar,dbo>].subtext_Users
        SET     LastActivityDate = @CurrentTimeUtc
        WHERE   @UserId = UserId
    END


    RETURN 0
END

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [<dbUser,varchar,dbo>].[subtext_Membership_UpdateUserInfo]
    @ApplicationName                nvarchar(256),
    @UserName                       nvarchar(256),
    @IsPasswordCorrect              bit,
    @UpdateLastLoginActivityDate    bit,
    @MaxInvalidPasswordAttempts     int,
    @PasswordAttemptWindow          int,
    @CurrentTimeUtc                 datetime,
    @LastLoginDate                  datetime,
    @LastActivityDate               datetime
AS
BEGIN
    DECLARE @UserId                                 uniqueidentifier
    DECLARE @IsApproved                             bit
    DECLARE @IsLockedOut                            bit
    DECLARE @LastLockoutDate                        datetime
    DECLARE @FailedPasswordAttemptCount             int
    DECLARE @FailedPasswordAttemptWindowStart       datetime
    DECLARE @FailedPasswordAnswerAttemptCount       int
    DECLARE @FailedPasswordAnswerAttemptWindowStart datetime

    DECLARE @ErrorCode     int
    SET @ErrorCode = 0

    DECLARE @TranStarted   bit
    SET @TranStarted = 0

    IF( @@TRANCOUNT = 0 )
    BEGIN
	    BEGIN TRANSACTION
	    SET @TranStarted = 1
    END
    ELSE
    	SET @TranStarted = 0

    SELECT  @UserId = u.UserId,
            @IsApproved = m.IsApproved,
            @IsLockedOut = m.IsLockedOut,
            @LastLockoutDate = m.LastLockoutDate,
            @FailedPasswordAttemptCount = m.FailedPasswordAttemptCount,
            @FailedPasswordAttemptWindowStart = m.FailedPasswordAttemptWindowStart,
            @FailedPasswordAnswerAttemptCount = m.FailedPasswordAnswerAttemptCount,
            @FailedPasswordAnswerAttemptWindowStart = m.FailedPasswordAnswerAttemptWindowStart
    FROM    [<dbUser,varchar,dbo>].subtext_Applications a, [<dbUser,varchar,dbo>].subtext_Users u, [<dbUser,varchar,dbo>].subtext_Membership m WITH ( UPDLOCK )
    WHERE   LOWER(@ApplicationName) = a.LoweredApplicationName AND
            u.ApplicationId = a.ApplicationId    AND
            u.UserId = m.UserId AND
            LOWER(@UserName) = u.LoweredUserName

    IF ( @@rowcount = 0 )
    BEGIN
        SET @ErrorCode = 1
        GOTO Cleanup
    END

    IF( @IsLockedOut = 1 )
    BEGIN
        GOTO Cleanup
    END

    IF( @IsPasswordCorrect = 0 )
    BEGIN
        IF( @CurrentTimeUtc > DATEADD( minute, @PasswordAttemptWindow, @FailedPasswordAttemptWindowStart ) )
        BEGIN
            SET @FailedPasswordAttemptWindowStart = @CurrentTimeUtc
            SET @FailedPasswordAttemptCount = 1
        END
        ELSE
        BEGIN
            SET @FailedPasswordAttemptWindowStart = @CurrentTimeUtc
            SET @FailedPasswordAttemptCount = @FailedPasswordAttemptCount + 1
        END

        BEGIN
            IF( @FailedPasswordAttemptCount >= @MaxInvalidPasswordAttempts )
            BEGIN
                SET @IsLockedOut = 1
                SET @LastLockoutDate = @CurrentTimeUtc
            END
        END
    END
    ELSE
    BEGIN
        IF( @FailedPasswordAttemptCount > 0 OR @FailedPasswordAnswerAttemptCount > 0 )
        BEGIN
            SET @FailedPasswordAttemptCount = 0
            SET @FailedPasswordAttemptWindowStart = CONVERT( datetime, '17540101', 112 )
            SET @FailedPasswordAnswerAttemptCount = 0
            SET @FailedPasswordAnswerAttemptWindowStart = CONVERT( datetime, '17540101', 112 )
            SET @LastLockoutDate = CONVERT( datetime, '17540101', 112 )
        END
    END

    IF( @UpdateLastLoginActivityDate = 1 )
    BEGIN
        UPDATE  [<dbUser,varchar,dbo>].subtext_Users
        SET     LastActivityDate = @LastActivityDate
        WHERE   @UserId = UserId

        IF( @@ERROR <> 0 )
        BEGIN
            SET @ErrorCode = -1
            GOTO Cleanup
        END

        UPDATE  [<dbUser,varchar,dbo>].subtext_Membership
        SET     LastLoginDate = @LastLoginDate
        WHERE   UserId = @UserId

        IF( @@ERROR <> 0 )
        BEGIN
            SET @ErrorCode = -1
            GOTO Cleanup
        END
    END


    UPDATE [<dbUser,varchar,dbo>].subtext_Membership
    SET IsLockedOut = @IsLockedOut, LastLockoutDate = @LastLockoutDate,
        FailedPasswordAttemptCount = @FailedPasswordAttemptCount,
        FailedPasswordAttemptWindowStart = @FailedPasswordAttemptWindowStart,
        FailedPasswordAnswerAttemptCount = @FailedPasswordAnswerAttemptCount,
        FailedPasswordAnswerAttemptWindowStart = @FailedPasswordAnswerAttemptWindowStart
    WHERE @UserId = UserId

    IF( @@ERROR <> 0 )
    BEGIN
        SET @ErrorCode = -1
        GOTO Cleanup
    END

    IF( @TranStarted = 1 )
    BEGIN
	SET @TranStarted = 0
	COMMIT TRANSACTION
    END

    RETURN @ErrorCode

Cleanup:

    IF( @TranStarted = 1 )
    BEGIN
        SET @TranStarted = 0
    	ROLLBACK TRANSACTION
    END

    RETURN @ErrorCode

END

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [<dbUser,varchar,dbo>].[subtext_Membership_GetPassword]
    @ApplicationName                nvarchar(256),
    @UserName                       nvarchar(256),
    @MaxInvalidPasswordAttempts     int,
    @PasswordAttemptWindow          int,
    @CurrentTimeUtc                 datetime,
    @PasswordAnswer                 nvarchar(128) = NULL
AS
BEGIN
    DECLARE @UserId                                 uniqueidentifier
    DECLARE @PasswordFormat                         int
    DECLARE @Password                               nvarchar(128)
    DECLARE @passAns                                nvarchar(128)
    DECLARE @IsLockedOut                            bit
    DECLARE @LastLockoutDate                        datetime
    DECLARE @FailedPasswordAttemptCount             int
    DECLARE @FailedPasswordAttemptWindowStart       datetime
    DECLARE @FailedPasswordAnswerAttemptCount       int
    DECLARE @FailedPasswordAnswerAttemptWindowStart datetime

    DECLARE @ErrorCode     int
    SET @ErrorCode = 0

    DECLARE @TranStarted   bit
    SET @TranStarted = 0

    IF( @@TRANCOUNT = 0 )
    BEGIN
	    BEGIN TRANSACTION
	    SET @TranStarted = 1
    END
    ELSE
    	SET @TranStarted = 0

    SELECT  @UserId = u.UserId,
            @Password = m.Password,
            @passAns = m.PasswordAnswer,
            @PasswordFormat = m.PasswordFormat,
            @IsLockedOut = m.IsLockedOut,
            @LastLockoutDate = m.LastLockoutDate,
            @FailedPasswordAttemptCount = m.FailedPasswordAttemptCount,
            @FailedPasswordAttemptWindowStart = m.FailedPasswordAttemptWindowStart,
            @FailedPasswordAnswerAttemptCount = m.FailedPasswordAnswerAttemptCount,
            @FailedPasswordAnswerAttemptWindowStart = m.FailedPasswordAnswerAttemptWindowStart
    FROM    [<dbUser,varchar,dbo>].subtext_Applications a, [<dbUser,varchar,dbo>].subtext_Users u, [<dbUser,varchar,dbo>].subtext_Membership m WITH ( UPDLOCK )
    WHERE   LOWER(@ApplicationName) = a.LoweredApplicationName AND
            u.ApplicationId = a.ApplicationId    AND
            u.UserId = m.UserId AND
            LOWER(@UserName) = u.LoweredUserName

    IF ( @@rowcount = 0 )
    BEGIN
        SET @ErrorCode = 1
        GOTO Cleanup
    END

    IF( @IsLockedOut = 1 )
    BEGIN
        SET @ErrorCode = 99
        GOTO Cleanup
    END

    IF ( NOT( @PasswordAnswer IS NULL ) )
    BEGIN
        IF( ( @passAns IS NULL ) OR ( LOWER( @passAns ) <> LOWER( @PasswordAnswer ) ) )
        BEGIN
            IF( @CurrentTimeUtc > DATEADD( minute, @PasswordAttemptWindow, @FailedPasswordAnswerAttemptWindowStart ) )
            BEGIN
                SET @FailedPasswordAnswerAttemptWindowStart = @CurrentTimeUtc
                SET @FailedPasswordAnswerAttemptCount = 1
            END
            ELSE
            BEGIN
                SET @FailedPasswordAnswerAttemptCount = @FailedPasswordAnswerAttemptCount + 1
                SET @FailedPasswordAnswerAttemptWindowStart = @CurrentTimeUtc
            END

            BEGIN
                IF( @FailedPasswordAnswerAttemptCount >= @MaxInvalidPasswordAttempts )
                BEGIN
                    SET @IsLockedOut = 1
                    SET @LastLockoutDate = @CurrentTimeUtc
                END
            END

            SET @ErrorCode = 3
        END
        ELSE
        BEGIN
            IF( @FailedPasswordAnswerAttemptCount > 0 )
            BEGIN
                SET @FailedPasswordAnswerAttemptCount = 0
                SET @FailedPasswordAnswerAttemptWindowStart = CONVERT( datetime, '17540101', 112 )
            END
        END

        UPDATE [<dbUser,varchar,dbo>].subtext_Membership
        SET IsLockedOut = @IsLockedOut, LastLockoutDate = @LastLockoutDate,
            FailedPasswordAttemptCount = @FailedPasswordAttemptCount,
            FailedPasswordAttemptWindowStart = @FailedPasswordAttemptWindowStart,
            FailedPasswordAnswerAttemptCount = @FailedPasswordAnswerAttemptCount,
            FailedPasswordAnswerAttemptWindowStart = @FailedPasswordAnswerAttemptWindowStart
        WHERE @UserId = UserId

        IF( @@ERROR <> 0 )
        BEGIN
            SET @ErrorCode = -1
            GOTO Cleanup
        END
    END

    IF( @TranStarted = 1 )
    BEGIN
	SET @TranStarted = 0
	COMMIT TRANSACTION
    END

    IF( @ErrorCode = 0 )
        SELECT @Password, @PasswordFormat

    RETURN @ErrorCode

Cleanup:

    IF( @TranStarted = 1 )
    BEGIN
        SET @TranStarted = 0
    	ROLLBACK TRANSACTION
    END

    RETURN @ErrorCode

END

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [<dbUser,varchar,dbo>].[subtext_Membership_GetNumberOfUsersOnline]
    @ApplicationName            nvarchar(256),
    @MinutesSinceLastInActive   int,
    @CurrentTimeUtc             datetime
AS
BEGIN
    DECLARE @DateActive datetime
    SELECT  @DateActive = DATEADD(minute,  -(@MinutesSinceLastInActive), @CurrentTimeUtc)

    DECLARE @NumOnline int
    SELECT  @NumOnline = COUNT(*)
    FROM    [<dbUser,varchar,dbo>].subtext_Users u(NOLOCK),
            [<dbUser,varchar,dbo>].subtext_Applications a(NOLOCK),
            [<dbUser,varchar,dbo>].subtext_Membership m(NOLOCK)
    WHERE   u.ApplicationId = a.ApplicationId                  AND
            LastActivityDate > @DateActive                     AND
            a.LoweredApplicationName = LOWER(@ApplicationName) AND
            u.UserId = m.UserId
    RETURN(@NumOnline)
END

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [<dbUser,varchar,dbo>].[subtext_Membership_SetPassword]
    @ApplicationName  nvarchar(256),
    @UserName         nvarchar(256),
    @NewPassword      nvarchar(128),
    @PasswordSalt     nvarchar(128),
    @CurrentTimeUtc   datetime,
    @PasswordFormat   int = 0
AS
BEGIN
    DECLARE @UserId uniqueidentifier
    SELECT  @UserId = NULL
    SELECT  @UserId = u.UserId
    FROM    [<dbUser,varchar,dbo>].subtext_Users u, [<dbUser,varchar,dbo>].subtext_Applications a, [<dbUser,varchar,dbo>].subtext_Membership m
    WHERE   LoweredUserName = LOWER(@UserName) AND
            u.ApplicationId = a.ApplicationId  AND
            LOWER(@ApplicationName) = a.LoweredApplicationName AND
            u.UserId = m.UserId

    IF (@UserId IS NULL)
        RETURN(1)

    UPDATE [<dbUser,varchar,dbo>].subtext_Membership
    SET Password = @NewPassword, PasswordFormat = @PasswordFormat, PasswordSalt = @PasswordSalt,
        LastPasswordChangedDate = @CurrentTimeUtc
    WHERE @UserId = UserId
    RETURN(0)
END

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [<dbUser,varchar,dbo>].[subtext_Membership_ResetPassword]
    @ApplicationName             nvarchar(256),
    @UserName                    nvarchar(256),
    @NewPassword                 nvarchar(128),
    @MaxInvalidPasswordAttempts  int,
    @PasswordAttemptWindow       int,
    @PasswordSalt                nvarchar(128),
    @CurrentTimeUtc              datetime,
    @PasswordFormat              int = 0,
    @PasswordAnswer              nvarchar(128) = NULL
AS
BEGIN
    DECLARE @IsLockedOut                            bit
    DECLARE @LastLockoutDate                        datetime
    DECLARE @FailedPasswordAttemptCount             int
    DECLARE @FailedPasswordAttemptWindowStart       datetime
    DECLARE @FailedPasswordAnswerAttemptCount       int
    DECLARE @FailedPasswordAnswerAttemptWindowStart datetime

    DECLARE @UserId                                 uniqueidentifier
    SET     @UserId = NULL

    DECLARE @ErrorCode     int
    SET @ErrorCode = 0

    DECLARE @TranStarted   bit
    SET @TranStarted = 0

    IF( @@TRANCOUNT = 0 )
    BEGIN
	    BEGIN TRANSACTION
	    SET @TranStarted = 1
    END
    ELSE
    	SET @TranStarted = 0

    SELECT  @UserId = u.UserId
    FROM    [<dbUser,varchar,dbo>].subtext_Users u, [<dbUser,varchar,dbo>].subtext_Applications a, [<dbUser,varchar,dbo>].subtext_Membership m
    WHERE   LoweredUserName = LOWER(@UserName) AND
            u.ApplicationId = a.ApplicationId  AND
            LOWER(@ApplicationName) = a.LoweredApplicationName AND
            u.UserId = m.UserId

    IF ( @UserId IS NULL )
    BEGIN
        SET @ErrorCode = 1
        GOTO Cleanup
    END

    SELECT @IsLockedOut = IsLockedOut,
           @LastLockoutDate = LastLockoutDate,
           @FailedPasswordAttemptCount = FailedPasswordAttemptCount,
           @FailedPasswordAttemptWindowStart = FailedPasswordAttemptWindowStart,
           @FailedPasswordAnswerAttemptCount = FailedPasswordAnswerAttemptCount,
           @FailedPasswordAnswerAttemptWindowStart = FailedPasswordAnswerAttemptWindowStart
    FROM [<dbUser,varchar,dbo>].subtext_Membership WITH ( UPDLOCK )
    WHERE @UserId = UserId

    IF( @IsLockedOut = 1 )
    BEGIN
        SET @ErrorCode = 99
        GOTO Cleanup
    END

    UPDATE [<dbUser,varchar,dbo>].subtext_Membership
    SET    Password = @NewPassword,
           LastPasswordChangedDate = @CurrentTimeUtc,
           PasswordFormat = @PasswordFormat,
           PasswordSalt = @PasswordSalt
    WHERE  @UserId = UserId AND
           ( ( @PasswordAnswer IS NULL ) OR ( LOWER( PasswordAnswer ) = LOWER( @PasswordAnswer ) ) )

    IF ( @@ROWCOUNT = 0 )
        BEGIN
            IF( @CurrentTimeUtc > DATEADD( minute, @PasswordAttemptWindow, @FailedPasswordAnswerAttemptWindowStart ) )
            BEGIN
                SET @FailedPasswordAnswerAttemptWindowStart = @CurrentTimeUtc
                SET @FailedPasswordAnswerAttemptCount = 1
            END
            ELSE
            BEGIN
                SET @FailedPasswordAnswerAttemptWindowStart = @CurrentTimeUtc
                SET @FailedPasswordAnswerAttemptCount = @FailedPasswordAnswerAttemptCount + 1
            END

            BEGIN
                IF( @FailedPasswordAnswerAttemptCount >= @MaxInvalidPasswordAttempts )
                BEGIN
                    SET @IsLockedOut = 1
                    SET @LastLockoutDate = @CurrentTimeUtc
                END
            END

            SET @ErrorCode = 3
        END
    ELSE
        BEGIN
            IF( @FailedPasswordAnswerAttemptCount > 0 )
            BEGIN
                SET @FailedPasswordAnswerAttemptCount = 0
                SET @FailedPasswordAnswerAttemptWindowStart = CONVERT( datetime, '17540101', 112 )
            END
        END

    IF( NOT ( @PasswordAnswer IS NULL ) )
    BEGIN
        UPDATE [<dbUser,varchar,dbo>].subtext_Membership
        SET IsLockedOut = @IsLockedOut, LastLockoutDate = @LastLockoutDate,
            FailedPasswordAttemptCount = @FailedPasswordAttemptCount,
            FailedPasswordAttemptWindowStart = @FailedPasswordAttemptWindowStart,
            FailedPasswordAnswerAttemptCount = @FailedPasswordAnswerAttemptCount,
            FailedPasswordAnswerAttemptWindowStart = @FailedPasswordAnswerAttemptWindowStart
        WHERE @UserId = UserId

        IF( @@ERROR <> 0 )
        BEGIN
            SET @ErrorCode = -1
            GOTO Cleanup
        END
    END

    IF( @TranStarted = 1 )
    BEGIN
	SET @TranStarted = 0
	COMMIT TRANSACTION
    END

    RETURN @ErrorCode

Cleanup:

    IF( @TranStarted = 1 )
    BEGIN
        SET @TranStarted = 0
    	ROLLBACK TRANSACTION
    END

    RETURN @ErrorCode

END

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [<dbUser,varchar,dbo>].[subtext_Membership_UnlockUser]
    @ApplicationName                         nvarchar(256),
    @UserName                                nvarchar(256)
AS
BEGIN
    DECLARE @UserId uniqueidentifier
    SELECT  @UserId = NULL
    SELECT  @UserId = u.UserId
    FROM    [<dbUser,varchar,dbo>].subtext_Users u, [<dbUser,varchar,dbo>].subtext_Applications a, [<dbUser,varchar,dbo>].subtext_Membership m
    WHERE   LoweredUserName = LOWER(@UserName) AND
            u.ApplicationId = a.ApplicationId  AND
            LOWER(@ApplicationName) = a.LoweredApplicationName AND
            u.UserId = m.UserId

    IF ( @UserId IS NULL )
        RETURN 1

    UPDATE [<dbUser,varchar,dbo>].subtext_Membership
    SET IsLockedOut = 0,
        FailedPasswordAttemptCount = 0,
        FailedPasswordAttemptWindowStart = CONVERT( datetime, '17540101', 112 ),
        FailedPasswordAnswerAttemptCount = 0,
        FailedPasswordAnswerAttemptWindowStart = CONVERT( datetime, '17540101', 112 ),
        LastLockoutDate = CONVERT( datetime, '17540101', 112 )
    WHERE @UserId = UserId

    RETURN 0
END

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [<dbUser,varchar,dbo>].[subtext_Membership_UpdateUser]
    @ApplicationName      nvarchar(256),
    @UserName             nvarchar(256),
    @Email                nvarchar(256),
    @Comment              ntext = NULL,
    @IsApproved           bit,
    @LastLoginDate        datetime,
    @LastActivityDate     datetime,
    @UniqueEmail          int,
    @CurrentTimeUtc       datetime
AS
BEGIN
    DECLARE @UserId uniqueidentifier
    DECLARE @ApplicationId uniqueidentifier
    SELECT  @UserId = NULL
    SELECT  @UserId = u.UserId, @ApplicationId = a.ApplicationId
    FROM    [<dbUser,varchar,dbo>].subtext_Users u, [<dbUser,varchar,dbo>].subtext_Applications a, [<dbUser,varchar,dbo>].subtext_Membership m
    WHERE   LoweredUserName = LOWER(@UserName) AND
            u.ApplicationId = a.ApplicationId  AND
            LOWER(@ApplicationName) = a.LoweredApplicationName AND
            u.UserId = m.UserId

    IF (@UserId IS NULL)
        RETURN(1)

    IF (@UniqueEmail = 1)
    BEGIN
        IF (EXISTS (SELECT *
                    FROM  [<dbUser,varchar,dbo>].subtext_Membership WITH (UPDLOCK, HOLDLOCK)
                    WHERE ApplicationId = @ApplicationId  AND @UserId <> UserId AND LoweredEmail = LOWER(@Email)))
        BEGIN
            RETURN(7)
        END
    END

    DECLARE @TranStarted   bit
    SET @TranStarted = 0

    IF( @@TRANCOUNT = 0 )
    BEGIN
	    BEGIN TRANSACTION
	    SET @TranStarted = 1
    END
    ELSE
	SET @TranStarted = 0

    UPDATE [<dbUser,varchar,dbo>].subtext_Users WITH (ROWLOCK)
    SET
         LastActivityDate = @LastActivityDate
    WHERE
       @UserId = UserId

    IF( @@ERROR <> 0 )
        GOTO Cleanup

    UPDATE [<dbUser,varchar,dbo>].subtext_Membership WITH (ROWLOCK)
    SET
         Email            = @Email,
         LoweredEmail     = LOWER(@Email),
         Comment          = @Comment,
         IsApproved       = @IsApproved,
         LastLoginDate    = @LastLoginDate
    WHERE
       @UserId = UserId

    IF( @@ERROR <> 0 )
        GOTO Cleanup

    IF( @TranStarted = 1 )
    BEGIN
	SET @TranStarted = 0
	COMMIT TRANSACTION
    END

    RETURN 0

Cleanup:

    IF( @TranStarted = 1 )
    BEGIN
        SET @TranStarted = 0
    	ROLLBACK TRANSACTION
    END

    RETURN -1
END

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [<dbUser,varchar,dbo>].[subtext_Membership_ChangePasswordQuestionAndAnswer]
    @ApplicationName       nvarchar(256),
    @UserName              nvarchar(256),
    @NewPasswordQuestion   nvarchar(256),
    @NewPasswordAnswer     nvarchar(128)
AS
BEGIN
    DECLARE @UserId uniqueidentifier
    SELECT  @UserId = NULL
    SELECT  @UserId = u.UserId
    FROM    [<dbUser,varchar,dbo>].subtext_Membership m, [<dbUser,varchar,dbo>].subtext_Users u, [<dbUser,varchar,dbo>].subtext_Applications a
    WHERE   LoweredUserName = LOWER(@UserName) AND
            u.ApplicationId = a.ApplicationId  AND
            LOWER(@ApplicationName) = a.LoweredApplicationName AND
            u.UserId = m.UserId
    IF (@UserId IS NULL)
    BEGIN
        RETURN(1)
    END

    UPDATE [<dbUser,varchar,dbo>].subtext_Membership
    SET    PasswordQuestion = @NewPasswordQuestion, PasswordAnswer = @NewPasswordAnswer
    WHERE  UserId=@UserId
    RETURN(0)
END

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE PROCEDURE [<dbUser,varchar,dbo>].[subtext_Profile_GetProperties]
    @ApplicationName      nvarchar(256),
    @UserName             nvarchar(256),
    @CurrentTimeUtc       datetime
AS
BEGIN
    DECLARE @ApplicationId uniqueidentifier
    SELECT  @ApplicationId = NULL
    SELECT  @ApplicationId = ApplicationId FROM [<dbUser,varchar,dbo>].subtext_Applications WHERE LOWER(@ApplicationName) = LoweredApplicationName
    IF (@ApplicationId IS NULL)
        RETURN

    DECLARE @UserId uniqueidentifier
    SELECT  @UserId = NULL

    SELECT @UserId = UserId
    FROM   [<dbUser,varchar,dbo>].subtext_Users
    WHERE  ApplicationId = @ApplicationId AND LoweredUserName = LOWER(@UserName)

    IF (@UserId IS NULL)
        RETURN
    SELECT TOP 1 PropertyNames, PropertyValuesString, PropertyValuesBinary
    FROM         [<dbUser,varchar,dbo>].subtext_Profile
    WHERE        UserId = @UserId

    IF (@@ROWCOUNT > 0)
    BEGIN
        UPDATE [<dbUser,varchar,dbo>].subtext_Users
        SET    LastActivityDate=@CurrentTimeUtc
        WHERE  UserId = @UserId
    END
END

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE PROCEDURE [<dbUser,varchar,dbo>].[subtext_Profile_DeleteInactiveProfiles]
    @ApplicationName        nvarchar(256),
    @ProfileAuthOptions     int,
    @InactiveSinceDate      datetime
AS
BEGIN
    DECLARE @ApplicationId uniqueidentifier
    SELECT  @ApplicationId = NULL
    SELECT  @ApplicationId = ApplicationId FROM subtext_Applications WHERE LOWER(@ApplicationName) = LoweredApplicationName
    IF (@ApplicationId IS NULL)
    BEGIN
        SELECT  0
        RETURN
    END

    DELETE
    FROM    [<dbUser,varchar,dbo>].subtext_Profile
    WHERE   UserId IN
            (   SELECT  UserId
                FROM    [<dbUser,varchar,dbo>].subtext_Users u
                WHERE   ApplicationId = @ApplicationId
                        AND (LastActivityDate <= @InactiveSinceDate)
                        AND (
                                (@ProfileAuthOptions = 2)
                             OR (@ProfileAuthOptions = 0 AND IsAnonymous = 1)
                             OR (@ProfileAuthOptions = 1 AND IsAnonymous = 0)
                            )
            )

    SELECT  @@ROWCOUNT
END

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE PROCEDURE [<dbUser,varchar,dbo>].[subtext_Profile_GetNumberOfInactiveProfiles]
    @ApplicationName        nvarchar(256),
    @ProfileAuthOptions     int,
    @InactiveSinceDate      datetime
AS
BEGIN
    DECLARE @ApplicationId uniqueidentifier
    SELECT  @ApplicationId = NULL
    SELECT  @ApplicationId = ApplicationId FROM subtext_Applications WHERE LOWER(@ApplicationName) = LoweredApplicationName
    IF (@ApplicationId IS NULL)
    BEGIN
        SELECT 0
        RETURN
    END

    SELECT  COUNT(*)
    FROM    [<dbUser,varchar,dbo>].subtext_Users u, [<dbUser,varchar,dbo>].subtext_Profile p
    WHERE   ApplicationId = @ApplicationId
        AND u.UserId = p.UserId
        AND (LastActivityDate <= @InactiveSinceDate)
        AND (
                (@ProfileAuthOptions = 2)
                OR (@ProfileAuthOptions = 0 AND IsAnonymous = 1)
                OR (@ProfileAuthOptions = 1 AND IsAnonymous = 0)
            )
END

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE PROCEDURE [<dbUser,varchar,dbo>].[subtext_UsersInRoles_IsUserInRole]
    @ApplicationName  nvarchar(256),
    @UserName         nvarchar(256),
    @RoleName         nvarchar(256)
AS
BEGIN
    DECLARE @ApplicationId uniqueidentifier
    SELECT  @ApplicationId = NULL
    SELECT  @ApplicationId = ApplicationId FROM subtext_Applications WHERE LOWER(@ApplicationName) = LoweredApplicationName
    IF (@ApplicationId IS NULL)
        RETURN(2)
    DECLARE @UserId uniqueidentifier
    SELECT  @UserId = NULL
    DECLARE @RoleId uniqueidentifier
    SELECT  @RoleId = NULL

    SELECT  @UserId = UserId
    FROM    [<dbUser,varchar,dbo>].subtext_Users
    WHERE   LoweredUserName = LOWER(@UserName) AND ApplicationId = @ApplicationId

    IF (@UserId IS NULL)
        RETURN(2)

    SELECT  @RoleId = RoleId
    FROM    [<dbUser,varchar,dbo>].subtext_Roles
    WHERE   LoweredRoleName = LOWER(@RoleName) AND ApplicationId = @ApplicationId

    IF (@RoleId IS NULL)
        RETURN(3)

    IF (EXISTS( SELECT * FROM [<dbUser,varchar,dbo>].subtext_UsersInRoles WHERE  UserId = @UserId AND RoleId = @RoleId))
        RETURN(1)
    ELSE
        RETURN(0)
END

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE PROCEDURE [<dbUser,varchar,dbo>].[subtext_UsersInRoles_GetRolesForUser]
    @ApplicationName  nvarchar(256),
    @UserName         nvarchar(256)
AS
BEGIN
    DECLARE @ApplicationId uniqueidentifier
    SELECT  @ApplicationId = NULL
    SELECT  @ApplicationId = ApplicationId FROM subtext_Applications WHERE LOWER(@ApplicationName) = LoweredApplicationName
    IF (@ApplicationId IS NULL)
        RETURN(1)
    DECLARE @UserId uniqueidentifier
    SELECT  @UserId = NULL

    SELECT  @UserId = UserId
    FROM    [<dbUser,varchar,dbo>].subtext_Users
    WHERE   LoweredUserName = LOWER(@UserName) AND ApplicationId = @ApplicationId

    IF (@UserId IS NULL)
        RETURN(1)

    SELECT r.RoleName
    FROM   [<dbUser,varchar,dbo>].subtext_Roles r, [<dbUser,varchar,dbo>].subtext_UsersInRoles ur
    WHERE  r.RoleId = ur.RoleId AND r.ApplicationId = @ApplicationId AND ur.UserId = @UserId
    ORDER BY r.RoleName
    RETURN (0)
END

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE PROCEDURE [<dbUser,varchar,dbo>].[subtext_Roles_DeleteRole]
    @ApplicationName            nvarchar(256),
    @RoleName                   nvarchar(256),
    @DeleteOnlyIfRoleIsEmpty    bit
AS
BEGIN
    DECLARE @ApplicationId uniqueidentifier
    SELECT  @ApplicationId = NULL
    SELECT  @ApplicationId = ApplicationId FROM subtext_Applications WHERE LOWER(@ApplicationName) = LoweredApplicationName
    IF (@ApplicationId IS NULL)
        RETURN(1)

    DECLARE @ErrorCode     int
    SET @ErrorCode = 0

    DECLARE @TranStarted   bit
    SET @TranStarted = 0

    IF( @@TRANCOUNT = 0 )
    BEGIN
        BEGIN TRANSACTION
        SET @TranStarted = 1
    END
    ELSE
        SET @TranStarted = 0

    DECLARE @RoleId   uniqueidentifier
    SELECT  @RoleId = NULL
    SELECT  @RoleId = RoleId FROM [<dbUser,varchar,dbo>].subtext_Roles WHERE LoweredRoleName = LOWER(@RoleName) AND ApplicationId = @ApplicationId

    IF (@RoleId IS NULL)
    BEGIN
        SELECT @ErrorCode = 1
        GOTO Cleanup
    END
    IF (@DeleteOnlyIfRoleIsEmpty <> 0)
    BEGIN
        IF (EXISTS (SELECT RoleId FROM [<dbUser,varchar,dbo>].subtext_UsersInRoles  WHERE @RoleId = RoleId))
        BEGIN
            SELECT @ErrorCode = 2
            GOTO Cleanup
        END
    END


    DELETE FROM [<dbUser,varchar,dbo>].subtext_UsersInRoles  WHERE @RoleId = RoleId

    IF( @@ERROR <> 0 )
    BEGIN
        SET @ErrorCode = -1
        GOTO Cleanup
    END

    DELETE FROM [<dbUser,varchar,dbo>].subtext_Roles WHERE @RoleId = RoleId  AND ApplicationId = @ApplicationId

    IF( @@ERROR <> 0 )
    BEGIN
        SET @ErrorCode = -1
        GOTO Cleanup
    END

    IF( @TranStarted = 1 )
    BEGIN
        SET @TranStarted = 0
        COMMIT TRANSACTION
    END

    RETURN(0)

Cleanup:

    IF( @TranStarted = 1 )
    BEGIN
        SET @TranStarted = 0
        ROLLBACK TRANSACTION
    END

    RETURN @ErrorCode
END

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE PROCEDURE [<dbUser,varchar,dbo>].[subtext_Roles_RoleExists]
    @ApplicationName  nvarchar(256),
    @RoleName         nvarchar(256)
AS
BEGIN
    DECLARE @ApplicationId uniqueidentifier
    SELECT  @ApplicationId = NULL
    SELECT  @ApplicationId = ApplicationId FROM subtext_Applications WHERE LOWER(@ApplicationName) = LoweredApplicationName
    IF (@ApplicationId IS NULL)
        RETURN(0)
    IF (EXISTS (SELECT RoleName FROM [<dbUser,varchar,dbo>].subtext_Roles WHERE LOWER(@RoleName) = LoweredRoleName AND ApplicationId = @ApplicationId ))
        RETURN(1)
    ELSE
        RETURN(0)
END

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE PROCEDURE [<dbUser,varchar,dbo>].[subtext_UsersInRoles_AddUsersToRoles]
	@ApplicationName  nvarchar(256),
	@UserNames		  nvarchar(4000),
	@RoleNames		  nvarchar(4000),
	@CurrentTimeUtc   datetime
AS
BEGIN
	DECLARE @AppId uniqueidentifier
	SELECT  @AppId = NULL
	SELECT  @AppId = ApplicationId FROM subtext_Applications WHERE LOWER(@ApplicationName) = LoweredApplicationName
	IF (@AppId IS NULL)
		RETURN(2)
	DECLARE @TranStarted   bit
	SET @TranStarted = 0

	IF( @@TRANCOUNT = 0 )
	BEGIN
		BEGIN TRANSACTION
		SET @TranStarted = 1
	END

	DECLARE @tbNames	table(Name nvarchar(256) NOT NULL PRIMARY KEY)
	DECLARE @tbRoles	table(RoleId uniqueidentifier NOT NULL PRIMARY KEY)
	DECLARE @tbUsers	table(UserId uniqueidentifier NOT NULL PRIMARY KEY)
	DECLARE @Num		int
	DECLARE @Pos		int
	DECLARE @NextPos	int
	DECLARE @Name		nvarchar(256)

	SET @Num = 0
	SET @Pos = 1
	WHILE(@Pos <= LEN(@RoleNames))
	BEGIN
		SELECT @NextPos = CHARINDEX(N',', @RoleNames,  @Pos)
		IF (@NextPos = 0 OR @NextPos IS NULL)
			SELECT @NextPos = LEN(@RoleNames) + 1
		SELECT @Name = RTRIM(LTRIM(SUBSTRING(@RoleNames, @Pos, @NextPos - @Pos)))
		SELECT @Pos = @NextPos+1

		INSERT INTO @tbNames VALUES (@Name)
		SET @Num = @Num + 1
	END

	INSERT INTO @tbRoles
	  SELECT RoleId
	  FROM   [<dbUser,varchar,dbo>].subtext_Roles ar, @tbNames t
	  WHERE  LOWER(t.Name) = ar.LoweredRoleName AND ar.ApplicationId = @AppId

	IF (@@ROWCOUNT <> @Num)
	BEGIN
		SELECT TOP 1 Name
		FROM   @tbNames
		WHERE  LOWER(Name) NOT IN (SELECT ar.LoweredRoleName FROM [<dbUser,varchar,dbo>].subtext_Roles ar,  @tbRoles r WHERE r.RoleId = ar.RoleId)
		IF( @TranStarted = 1 )
			ROLLBACK TRANSACTION
		RETURN(2)
	END

	DELETE FROM @tbNames WHERE 1=1
	SET @Num = 0
	SET @Pos = 1

	WHILE(@Pos <= LEN(@UserNames))
	BEGIN
		SELECT @NextPos = CHARINDEX(N',', @UserNames,  @Pos)
		IF (@NextPos = 0 OR @NextPos IS NULL)
			SELECT @NextPos = LEN(@UserNames) + 1
		SELECT @Name = RTRIM(LTRIM(SUBSTRING(@UserNames, @Pos, @NextPos - @Pos)))
		SELECT @Pos = @NextPos+1

		INSERT INTO @tbNames VALUES (@Name)
		SET @Num = @Num + 1
	END

	INSERT INTO @tbUsers
	  SELECT UserId
	  FROM   [<dbUser,varchar,dbo>].subtext_Users ar, @tbNames t
	  WHERE  LOWER(t.Name) = ar.LoweredUserName AND ar.ApplicationId = @AppId

	IF (@@ROWCOUNT <> @Num)
	BEGIN
		DELETE FROM @tbNames
		WHERE LOWER(Name) IN (SELECT LoweredUserName FROM [<dbUser,varchar,dbo>].subtext_Users au,  @tbUsers u WHERE au.UserId = u.UserId)

		INSERT [<dbUser,varchar,dbo>].subtext_Users (ApplicationId, UserId, UserName, LoweredUserName, IsAnonymous, LastActivityDate)
		  SELECT @AppId, NEWID(), Name, LOWER(Name), 0, @CurrentTimeUtc
		  FROM   @tbNames

		INSERT INTO @tbUsers
		  SELECT  UserId
		  FROM	[<dbUser,varchar,dbo>].subtext_Users au, @tbNames t
		  WHERE   LOWER(t.Name) = au.LoweredUserName AND au.ApplicationId = @AppId
	END

	IF (EXISTS (SELECT * FROM [<dbUser,varchar,dbo>].subtext_UsersInRoles ur, @tbUsers tu, @tbRoles tr WHERE tu.UserId = ur.UserId AND tr.RoleId = ur.RoleId))
	BEGIN
		SELECT TOP 1 UserName, RoleName
		FROM		 [<dbUser,varchar,dbo>].subtext_UsersInRoles ur, @tbUsers tu, @tbRoles tr, subtext_Users u, subtext_Roles r
		WHERE		u.UserId = tu.UserId AND r.RoleId = tr.RoleId AND tu.UserId = ur.UserId AND tr.RoleId = ur.RoleId

		IF( @TranStarted = 1 )
			ROLLBACK TRANSACTION
		RETURN(3)
	END

	INSERT INTO [<dbUser,varchar,dbo>].subtext_UsersInRoles (UserId, RoleId)
	SELECT UserId, RoleId
	FROM @tbUsers, @tbRoles

	IF( @TranStarted = 1 )
		COMMIT TRANSACTION
	RETURN(0)
END                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE PROCEDURE [<dbUser,varchar,dbo>].[subtext_UsersInRoles_RemoveUsersFromRoles]
	@ApplicationName  nvarchar(256),
	@UserNames		  nvarchar(4000),
	@RoleNames		  nvarchar(4000)
AS
BEGIN
	DECLARE @AppId uniqueidentifier
	SELECT  @AppId = NULL
	SELECT  @AppId = ApplicationId FROM subtext_Applications WHERE LOWER(@ApplicationName) = LoweredApplicationName
	IF (@AppId IS NULL)
		RETURN(2)


	DECLARE @TranStarted   bit
	SET @TranStarted = 0

	IF( @@TRANCOUNT = 0 )
	BEGIN
		BEGIN TRANSACTION
		SET @TranStarted = 1
	END

	DECLARE @tbNames  table(Name nvarchar(256) NOT NULL PRIMARY KEY)
	DECLARE @tbRoles  table(RoleId uniqueidentifier NOT NULL PRIMARY KEY)
	DECLARE @tbUsers  table(UserId uniqueidentifier NOT NULL PRIMARY KEY)
	DECLARE @Num	  int
	DECLARE @Pos	  int
	DECLARE @NextPos  int
	DECLARE @Name	  nvarchar(256)
	DECLARE @CountAll int
	DECLARE @CountU	  int
	DECLARE @CountR	  int


	SET @Num = 0
	SET @Pos = 1
	WHILE(@Pos <= LEN(@RoleNames))
	BEGIN
		SELECT @NextPos = CHARINDEX(N',', @RoleNames,  @Pos)
		IF (@NextPos = 0 OR @NextPos IS NULL)
			SELECT @NextPos = LEN(@RoleNames) + 1
		SELECT @Name = RTRIM(LTRIM(SUBSTRING(@RoleNames, @Pos, @NextPos - @Pos)))
		SELECT @Pos = @NextPos+1

		INSERT INTO @tbNames VALUES (@Name)
		SET @Num = @Num + 1
	END

	INSERT INTO @tbRoles
	  SELECT RoleId
	  FROM   [<dbUser,varchar,dbo>].subtext_Roles ar, @tbNames t
	  WHERE  LOWER(t.Name) = ar.LoweredRoleName AND ar.ApplicationId = @AppId
	SELECT @CountR = @@ROWCOUNT

	IF (@CountR <> @Num)
	BEGIN
		SELECT TOP 1 N'', Name
		FROM   @tbNames
		WHERE  LOWER(Name) NOT IN (SELECT ar.LoweredRoleName FROM [<dbUser,varchar,dbo>].subtext_Roles ar,  @tbRoles r WHERE r.RoleId = ar.RoleId)
		IF( @TranStarted = 1 )
			ROLLBACK TRANSACTION
		RETURN(2)
	END


	DELETE FROM @tbNames WHERE 1=1
	SET @Num = 0
	SET @Pos = 1


	WHILE(@Pos <= LEN(@UserNames))
	BEGIN
		SELECT @NextPos = CHARINDEX(N',', @UserNames,  @Pos)
		IF (@NextPos = 0 OR @NextPos IS NULL)
			SELECT @NextPos = LEN(@UserNames) + 1
		SELECT @Name = RTRIM(LTRIM(SUBSTRING(@UserNames, @Pos, @NextPos - @Pos)))
		SELECT @Pos = @NextPos+1

		INSERT INTO @tbNames VALUES (@Name)
		SET @Num = @Num + 1
	END

	INSERT INTO @tbUsers
	  SELECT UserId
	  FROM   [<dbUser,varchar,dbo>].subtext_Users ar, @tbNames t
	  WHERE  LOWER(t.Name) = ar.LoweredUserName AND ar.ApplicationId = @AppId

	SELECT @CountU = @@ROWCOUNT
	IF (@CountU <> @Num)
	BEGIN
		SELECT TOP 1 Name, N''
		FROM   @tbNames
		WHERE  LOWER(Name) NOT IN (SELECT au.LoweredUserName FROM [<dbUser,varchar,dbo>].subtext_Users au,  @tbUsers u WHERE u.UserId = au.UserId)

		IF( @TranStarted = 1 )
			ROLLBACK TRANSACTION
		RETURN(1)
	END

	SELECT  @CountAll = COUNT(*)
	FROM	[<dbUser,varchar,dbo>].subtext_UsersInRoles ur, @tbUsers u, @tbRoles r
	WHERE   ur.UserId = u.UserId AND ur.RoleId = r.RoleId

	IF (@CountAll <> @CountU * @CountR)
	BEGIN
		SELECT TOP 1 UserName, RoleName
		FROM		 @tbUsers tu, @tbRoles tr, [<dbUser,varchar,dbo>].subtext_Users u, [<dbUser,varchar,dbo>].subtext_Roles r
		WHERE		 u.UserId = tu.UserId AND r.RoleId = tr.RoleId AND
					 tu.UserId NOT IN (SELECT ur.UserId FROM [<dbUser,varchar,dbo>].subtext_UsersInRoles ur WHERE ur.RoleId = tr.RoleId) AND
					 tr.RoleId NOT IN (SELECT ur.RoleId FROM [<dbUser,varchar,dbo>].subtext_UsersInRoles ur WHERE ur.UserId = tu.UserId)
		IF( @TranStarted = 1 )
			ROLLBACK TRANSACTION
		RETURN(3)
	END

	DELETE FROM [<dbUser,varchar,dbo>].subtext_UsersInRoles
	WHERE UserId IN (SELECT UserId FROM @tbUsers)
	  AND RoleId IN (SELECT RoleId FROM @tbRoles)
	IF( @TranStarted = 1 )
		COMMIT TRANSACTION
	RETURN(0)
END
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE PROCEDURE [<dbUser,varchar,dbo>].[subtext_Roles_GetAllRoles] (
    @ApplicationName           nvarchar(256))
AS
BEGIN
    DECLARE @ApplicationId uniqueidentifier
    SELECT  @ApplicationId = NULL
    SELECT  @ApplicationId = ApplicationId FROM subtext_Applications WHERE LOWER(@ApplicationName) = LoweredApplicationName
    IF (@ApplicationId IS NULL)
        RETURN
    SELECT RoleName
    FROM   [<dbUser,varchar,dbo>].subtext_Roles WHERE ApplicationId = @ApplicationId
    ORDER BY RoleName
END

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE PROCEDURE [<dbUser,varchar,dbo>].[subtext_UsersInRoles_GetUsersInRoles]
    @ApplicationName  nvarchar(256),
    @RoleName         nvarchar(256)
AS
BEGIN
    DECLARE @ApplicationId uniqueidentifier
    SELECT  @ApplicationId = NULL
    SELECT  @ApplicationId = ApplicationId FROM subtext_Applications WHERE LOWER(@ApplicationName) = LoweredApplicationName
    IF (@ApplicationId IS NULL)
        RETURN(1)
     DECLARE @RoleId uniqueidentifier
     SELECT  @RoleId = NULL

     SELECT  @RoleId = RoleId
     FROM    [<dbUser,varchar,dbo>].subtext_Roles
     WHERE   LOWER(@RoleName) = LoweredRoleName AND ApplicationId = @ApplicationId

     IF (@RoleId IS NULL)
         RETURN(1)

    SELECT u.UserName
    FROM   [<dbUser,varchar,dbo>].subtext_Users u, [<dbUser,varchar,dbo>].subtext_UsersInRoles ur
    WHERE  u.UserId = ur.UserId AND @RoleId = ur.RoleId AND u.ApplicationId = @ApplicationId
    ORDER BY u.UserName
    RETURN(0)
END

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE PROCEDURE [<dbUser,varchar,dbo>].[subtext_UsersInRoles_FindUsersInRole]
    @ApplicationName  nvarchar(256),
    @RoleName         nvarchar(256),
    @UserNameToMatch  nvarchar(256)
AS
BEGIN
    DECLARE @ApplicationId uniqueidentifier
    SELECT  @ApplicationId = NULL
    SELECT  @ApplicationId = ApplicationId FROM subtext_Applications WHERE LOWER(@ApplicationName) = LoweredApplicationName
    IF (@ApplicationId IS NULL)
        RETURN(1)
     DECLARE @RoleId uniqueidentifier
     SELECT  @RoleId = NULL

     SELECT  @RoleId = RoleId
     FROM    [<dbUser,varchar,dbo>].subtext_Roles
     WHERE   LOWER(@RoleName) = LoweredRoleName AND ApplicationId = @ApplicationId

     IF (@RoleId IS NULL)
         RETURN(1)

    SELECT u.UserName
    FROM   [<dbUser,varchar,dbo>].subtext_Users u, [<dbUser,varchar,dbo>].subtext_UsersInRoles ur
    WHERE  u.UserId = ur.UserId AND @RoleId = ur.RoleId AND u.ApplicationId = @ApplicationId AND LoweredUserName LIKE LOWER(@UserNameToMatch)
    ORDER BY u.UserName
    RETURN(0)
END

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [<dbUser,varchar,dbo>].[subtext_Paths_CreatePath]
    @ApplicationId UNIQUEIDENTIFIER,
    @Path           NVARCHAR(256),
    @PathId         UNIQUEIDENTIFIER OUTPUT
AS
BEGIN
    BEGIN TRANSACTION
    IF (NOT EXISTS(SELECT * FROM [<dbUser,varchar,dbo>].subtext_Paths WHERE LoweredPath = LOWER(@Path) AND ApplicationId = @ApplicationId))
    BEGIN
        INSERT [<dbUser,varchar,dbo>].subtext_Paths (ApplicationId, Path, LoweredPath) VALUES (@ApplicationId, @Path, LOWER(@Path))
    END
    COMMIT TRANSACTION
    SELECT @PathId = PathId FROM [<dbUser,varchar,dbo>].subtext_Paths WHERE LOWER(@Path) = LoweredPath AND ApplicationId = @ApplicationId
END

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [<dbUser,varchar,dbo>].[subtext_WebEvent_LogEvent]
        @EventId         char(32),
        @EventTimeUtc    datetime,
        @EventTime       datetime,
        @EventType       nvarchar(256),
        @EventSequence   decimal(19,0),
        @EventOccurrence decimal(19,0),
        @EventCode       int,
        @EventDetailCode int,
        @Message         nvarchar(1024),
        @ApplicationPath nvarchar(256),
        @ApplicationVirtualPath nvarchar(256),
        @MachineName    nvarchar(256),
        @RequestUrl      nvarchar(1024),
        @ExceptionType   nvarchar(256),
        @Details         ntext
AS
BEGIN
    INSERT
        [<dbUser,varchar,dbo>].subtext_WebEvent_Events
        (
            EventId,
            EventTimeUtc,
            EventTime,
            EventType,
            EventSequence,
            EventOccurrence,
            EventCode,
            EventDetailCode,
            Message,
            ApplicationPath,
            ApplicationVirtualPath,
            MachineName,
            RequestUrl,
            ExceptionType,
            Details
        )
    VALUES
    (
        @EventId,
        @EventTimeUtc,
        @EventTime,
        @EventType,
        @EventSequence,
        @EventOccurrence,
        @EventCode,
        @EventDetailCode,
        @Message,
        @ApplicationPath,
        @ApplicationVirtualPath,
        @MachineName,
        @RequestUrl,
        @ExceptionType,
        @Details
    )
END

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [<dbUser,varchar,dbo>].[subtext_Personalization_GetApplicationId] (
    @ApplicationName NVARCHAR(256),
    @ApplicationId UNIQUEIDENTIFIER OUT)
AS
BEGIN
    SELECT @ApplicationId = ApplicationId FROM [<dbUser,varchar,dbo>].subtext_Applications WHERE LOWER(@ApplicationName) = LoweredApplicationName
END

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE PROCEDURE [<dbUser,varchar,dbo>].[subtext_Profile_GetProfiles]
    @ApplicationName        nvarchar(256),
    @ProfileAuthOptions     int,
    @PageIndex              int,
    @PageSize               int,
    @UserNameToMatch        nvarchar(256) = NULL,
    @InactiveSinceDate      datetime      = NULL
AS
BEGIN
    DECLARE @ApplicationId uniqueidentifier
    SELECT  @ApplicationId = NULL
    SELECT  @ApplicationId = ApplicationId FROM subtext_Applications WHERE LOWER(@ApplicationName) = LoweredApplicationName
    IF (@ApplicationId IS NULL)
        RETURN

    -- Set the page bounds
    DECLARE @PageLowerBound int
    DECLARE @PageUpperBound int
    DECLARE @TotalRecords   int
    SET @PageLowerBound = @PageSize * @PageIndex
    SET @PageUpperBound = @PageSize - 1 + @PageLowerBound

    -- Create a temp table TO store the select results
    CREATE TABLE #PageIndexForUsers
    (
        IndexId int IDENTITY (0, 1) NOT NULL,
        UserId uniqueidentifier
    )

    -- Insert into our temp table
    INSERT INTO #PageIndexForUsers (UserId)
        SELECT  u.UserId
        FROM    [<dbUser,varchar,dbo>].subtext_Users u, [<dbUser,varchar,dbo>].subtext_Profile p
        WHERE   ApplicationId = @ApplicationId
            AND u.UserId = p.UserId
            AND (@InactiveSinceDate IS NULL OR LastActivityDate <= @InactiveSinceDate)
            AND (     (@ProfileAuthOptions = 2)
                   OR (@ProfileAuthOptions = 0 AND IsAnonymous = 1)
                   OR (@ProfileAuthOptions = 1 AND IsAnonymous = 0)
                 )
            AND (@UserNameToMatch IS NULL OR LoweredUserName LIKE LOWER(@UserNameToMatch))
        ORDER BY UserName

    SELECT  u.UserName, u.IsAnonymous, u.LastActivityDate, p.LastUpdatedDate,
            DATALENGTH(p.PropertyNames) + DATALENGTH(p.PropertyValuesString) + DATALENGTH(p.PropertyValuesBinary)
    FROM    [<dbUser,varchar,dbo>].subtext_Users u, [<dbUser,varchar,dbo>].subtext_Profile p, #PageIndexForUsers i
    WHERE   u.UserId = p.UserId AND p.UserId = i.UserId AND i.IndexId >= @PageLowerBound AND i.IndexId <= @PageUpperBound

    SELECT COUNT(*)
    FROM   #PageIndexForUsers

    DROP TABLE #PageIndexForUsers
END

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [<dbUser,varchar,dbo>].[subtext_Membership_FindUsersByName]
    @ApplicationName       nvarchar(256),
    @UserNameToMatch       nvarchar(256),
    @PageIndex             int,
    @PageSize              int
AS
BEGIN
    DECLARE @ApplicationId uniqueidentifier
    SELECT  @ApplicationId = NULL
    SELECT  @ApplicationId = ApplicationId FROM [<dbUser,varchar,dbo>].subtext_Applications WHERE LOWER(@ApplicationName) = LoweredApplicationName
    IF (@ApplicationId IS NULL)
        RETURN 0

    -- Set the page bounds
    DECLARE @PageLowerBound int
    DECLARE @PageUpperBound int
    DECLARE @TotalRecords   int
    SET @PageLowerBound = @PageSize * @PageIndex
    SET @PageUpperBound = @PageSize - 1 + @PageLowerBound

    -- Create a temp table TO store the select results
    CREATE TABLE #PageIndexForUsers
    (
        IndexId int IDENTITY (0, 1) NOT NULL,
        UserId uniqueidentifier
    )

    -- Insert into our temp table
    INSERT INTO #PageIndexForUsers (UserId)
        SELECT u.UserId
        FROM   [<dbUser,varchar,dbo>].subtext_Users u, [<dbUser,varchar,dbo>].subtext_Membership m
        WHERE  u.ApplicationId = @ApplicationId AND m.UserId = u.UserId AND u.LoweredUserName LIKE LOWER(@UserNameToMatch)
        ORDER BY u.UserName


    SELECT  u.UserName, m.Email, m.PasswordQuestion, m.Comment, m.IsApproved,
            m.CreateDate,
            m.LastLoginDate,
            u.LastActivityDate,
            m.LastPasswordChangedDate,
            u.UserId, m.IsLockedOut,
            m.LastLockoutDate
    FROM   [<dbUser,varchar,dbo>].subtext_Membership m, [<dbUser,varchar,dbo>].subtext_Users u, #PageIndexForUsers p
    WHERE  u.UserId = p.UserId AND u.UserId = m.UserId AND
           p.IndexId >= @PageLowerBound AND p.IndexId <= @PageUpperBound
    ORDER BY u.UserName

    SELECT  @TotalRecords = COUNT(*)
    FROM    #PageIndexForUsers
    RETURN @TotalRecords
END

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [<dbUser,varchar,dbo>].[subtext_Membership_FindUsersByEmail]
    @ApplicationName       nvarchar(256),
    @EmailToMatch          nvarchar(256),
    @PageIndex             int,
    @PageSize              int
AS
BEGIN
    DECLARE @ApplicationId uniqueidentifier
    SELECT  @ApplicationId = NULL
    SELECT  @ApplicationId = ApplicationId FROM [<dbUser,varchar,dbo>].subtext_Applications WHERE LOWER(@ApplicationName) = LoweredApplicationName
    IF (@ApplicationId IS NULL)
        RETURN 0

    -- Set the page bounds
    DECLARE @PageLowerBound int
    DECLARE @PageUpperBound int
    DECLARE @TotalRecords   int
    SET @PageLowerBound = @PageSize * @PageIndex
    SET @PageUpperBound = @PageSize - 1 + @PageLowerBound

    -- Create a temp table TO store the select results
    CREATE TABLE #PageIndexForUsers
    (
        IndexId int IDENTITY (0, 1) NOT NULL,
        UserId uniqueidentifier
    )

    -- Insert into our temp table
    IF( @EmailToMatch IS NULL )
        INSERT INTO #PageIndexForUsers (UserId)
            SELECT u.UserId
            FROM   [<dbUser,varchar,dbo>].subtext_Users u, [<dbUser,varchar,dbo>].subtext_Membership m
            WHERE  u.ApplicationId = @ApplicationId AND m.UserId = u.UserId AND m.Email IS NULL
            ORDER BY m.LoweredEmail
    ELSE
        INSERT INTO #PageIndexForUsers (UserId)
            SELECT u.UserId
            FROM   [<dbUser,varchar,dbo>].subtext_Users u, [<dbUser,varchar,dbo>].subtext_Membership m
            WHERE  u.ApplicationId = @ApplicationId AND m.UserId = u.UserId AND m.LoweredEmail LIKE LOWER(@EmailToMatch)
            ORDER BY m.LoweredEmail

    SELECT  u.UserName, m.Email, m.PasswordQuestion, m.Comment, m.IsApproved,
            m.CreateDate,
            m.LastLoginDate,
            u.LastActivityDate,
            m.LastPasswordChangedDate,
            u.UserId, m.IsLockedOut,
            m.LastLockoutDate
    FROM   [<dbUser,varchar,dbo>].subtext_Membership m, [<dbUser,varchar,dbo>].subtext_Users u, #PageIndexForUsers p
    WHERE  u.UserId = p.UserId AND u.UserId = m.UserId AND
           p.IndexId >= @PageLowerBound AND p.IndexId <= @PageUpperBound
    ORDER BY m.LoweredEmail

    SELECT  @TotalRecords = COUNT(*)
    FROM    #PageIndexForUsers
    RETURN @TotalRecords
END

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [<dbUser,varchar,dbo>].[subtext_Membership_GetAllUsers]
    @ApplicationName       nvarchar(256),
    @PageIndex             int,
    @PageSize              int
AS
BEGIN
    DECLARE @ApplicationId uniqueidentifier
    SELECT  @ApplicationId = NULL
    SELECT  @ApplicationId = ApplicationId FROM [<dbUser,varchar,dbo>].subtext_Applications WHERE LOWER(@ApplicationName) = LoweredApplicationName
    IF (@ApplicationId IS NULL)
        RETURN 0


    -- Set the page bounds
    DECLARE @PageLowerBound int
    DECLARE @PageUpperBound int
    DECLARE @TotalRecords   int
    SET @PageLowerBound = @PageSize * @PageIndex
    SET @PageUpperBound = @PageSize - 1 + @PageLowerBound

    -- Create a temp table TO store the select results
    CREATE TABLE #PageIndexForUsers
    (
        IndexId int IDENTITY (0, 1) NOT NULL,
        UserId uniqueidentifier
    )

    -- Insert into our temp table
    INSERT INTO #PageIndexForUsers (UserId)
    SELECT u.UserId
    FROM   [<dbUser,varchar,dbo>].subtext_Membership m, [<dbUser,varchar,dbo>].subtext_Users u
    WHERE  u.ApplicationId = @ApplicationId AND u.UserId = m.UserId
    ORDER BY u.UserName

    SELECT @TotalRecords = @@ROWCOUNT

    SELECT u.UserName, m.Email, m.PasswordQuestion, m.Comment, m.IsApproved,
            m.CreateDate,
            m.LastLoginDate,
            u.LastActivityDate,
            m.LastPasswordChangedDate,
            u.UserId, m.IsLockedOut,
            m.LastLockoutDate
    FROM   [<dbUser,varchar,dbo>].subtext_Membership m, [<dbUser,varchar,dbo>].subtext_Users u, #PageIndexForUsers p
    WHERE  u.UserId = p.UserId AND u.UserId = m.UserId AND
           p.IndexId >= @PageLowerBound AND p.IndexId <= @PageUpperBound
    ORDER BY u.UserName
    RETURN @TotalRecords
END

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [<dbUser,varchar,dbo>].[subtext_Users_DeleteUser]
    @ApplicationName  nvarchar(256),
    @UserName         nvarchar(256),
    @TablesToDeleteFrom int,
    @NumTablesDeletedFrom int OUTPUT
AS
BEGIN
    DECLARE @UserId               uniqueidentifier
    SELECT  @UserId               = NULL
    SELECT  @NumTablesDeletedFrom = 0

    DECLARE @TranStarted   bit
    SET @TranStarted = 0

    IF( @@TRANCOUNT = 0 )
    BEGIN
	    BEGIN TRANSACTION
	    SET @TranStarted = 1
    END
    ELSE
	SET @TranStarted = 0

    DECLARE @ErrorCode   int
    DECLARE @RowCount    int

    SET @ErrorCode = 0
    SET @RowCount  = 0

    SELECT  @UserId = u.UserId
    FROM    [<dbUser,varchar,dbo>].subtext_Users u, [<dbUser,varchar,dbo>].subtext_Applications a
    WHERE   u.LoweredUserName       = LOWER(@UserName)
        AND u.ApplicationId         = a.ApplicationId
        AND LOWER(@ApplicationName) = a.LoweredApplicationName

    IF (@UserId IS NULL)
    BEGIN
        GOTO Cleanup
    END

    -- Delete from Membership table if (@TablesToDeleteFrom & 1) is set
    IF ((@TablesToDeleteFrom & 1) <> 0 AND
        (EXISTS (SELECT name FROM sysobjects WHERE (name = N'vw_subtext_MembershipUsers') AND (type = 'V'))))
    BEGIN
        DELETE FROM [<dbUser,varchar,dbo>].subtext_Membership WHERE @UserId = UserId

        SELECT @ErrorCode = @@ERROR,
               @RowCount = @@ROWCOUNT

        IF( @ErrorCode <> 0 )
            GOTO Cleanup

        IF (@RowCount <> 0)
            SELECT  @NumTablesDeletedFrom = @NumTablesDeletedFrom + 1
    END

    -- Delete from subtext_UsersInRoles table if (@TablesToDeleteFrom & 2) is set
    IF ((@TablesToDeleteFrom & 2) <> 0  AND
        (EXISTS (SELECT name FROM sysobjects WHERE (name = N'vw_subtext_UsersInRoles') AND (type = 'V'))) )
    BEGIN
        DELETE FROM [<dbUser,varchar,dbo>].subtext_UsersInRoles WHERE @UserId = UserId

        SELECT @ErrorCode = @@ERROR,
                @RowCount = @@ROWCOUNT

        IF( @ErrorCode <> 0 )
            GOTO Cleanup

        IF (@RowCount <> 0)
            SELECT  @NumTablesDeletedFrom = @NumTablesDeletedFrom + 1
    END

    -- Delete from subtext_Profile table if (@TablesToDeleteFrom & 4) is set
    IF ((@TablesToDeleteFrom & 4) <> 0  AND
        (EXISTS (SELECT name FROM sysobjects WHERE (name = N'vw_subtext_Profiles') AND (type = 'V'))) )
    BEGIN
        DELETE FROM [<dbUser,varchar,dbo>].subtext_Profile WHERE @UserId = UserId

        SELECT @ErrorCode = @@ERROR,
                @RowCount = @@ROWCOUNT

        IF( @ErrorCode <> 0 )
            GOTO Cleanup

        IF (@RowCount <> 0)
            SELECT  @NumTablesDeletedFrom = @NumTablesDeletedFrom + 1
    END

    -- Delete from subtext_PersonalizationPerUser table if (@TablesToDeleteFrom & 8) is set
    IF ((@TablesToDeleteFrom & 8) <> 0  AND
        (EXISTS (SELECT name FROM sysobjects WHERE (name = N'vw_subtext_WebPartState_User') AND (type = 'V'))) )
    BEGIN
        DELETE FROM [<dbUser,varchar,dbo>].subtext_PersonalizationPerUser WHERE @UserId = UserId

        SELECT @ErrorCode = @@ERROR,
                @RowCount = @@ROWCOUNT

        IF( @ErrorCode <> 0 )
            GOTO Cleanup

        IF (@RowCount <> 0)
            SELECT  @NumTablesDeletedFrom = @NumTablesDeletedFrom + 1
    END

    -- Delete from subtext_Users table if (@TablesToDeleteFrom & 1,2,4 & 8) are all set
    IF ((@TablesToDeleteFrom & 1) <> 0 AND
        (@TablesToDeleteFrom & 2) <> 0 AND
        (@TablesToDeleteFrom & 4) <> 0 AND
        (@TablesToDeleteFrom & 8) <> 0 AND
        (EXISTS (SELECT UserId FROM [<dbUser,varchar,dbo>].subtext_Users WHERE @UserId = UserId)))
    BEGIN
        DELETE FROM [<dbUser,varchar,dbo>].subtext_Users WHERE @UserId = UserId

        SELECT @ErrorCode = @@ERROR,
                @RowCount = @@ROWCOUNT

        IF( @ErrorCode <> 0 )
            GOTO Cleanup

        IF (@RowCount <> 0)
            SELECT  @NumTablesDeletedFrom = @NumTablesDeletedFrom + 1
    END

    IF( @TranStarted = 1 )
    BEGIN
	    SET @TranStarted = 0
	    COMMIT TRANSACTION
    END

    RETURN 0

Cleanup:
    SET @NumTablesDeletedFrom = 0

    IF( @TranStarted = 1 )
    BEGIN
        SET @TranStarted = 0
	    ROLLBACK TRANSACTION
    END

    RETURN @ErrorCode

END

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE PROCEDURE [<dbUser,varchar,dbo>].[subtext_Applications_CreateApplication]
    @ApplicationName      nvarchar(256),
    @ApplicationId        uniqueidentifier OUTPUT
AS
BEGIN
    SELECT  @ApplicationId = ApplicationId FROM [<dbUser,varchar,dbo>].subtext_Applications WHERE LOWER(@ApplicationName) = LoweredApplicationName

    IF(@ApplicationId IS NULL)
    BEGIN
        DECLARE @TranStarted   bit
        SET @TranStarted = 0

        IF( @@TRANCOUNT = 0 )
        BEGIN
	        BEGIN TRANSACTION
	        SET @TranStarted = 1
        END
        ELSE
    	    SET @TranStarted = 0

        SELECT  @ApplicationId = ApplicationId
        FROM [<dbUser,varchar,dbo>].subtext_Applications WITH (UPDLOCK, HOLDLOCK)
        WHERE LOWER(@ApplicationName) = LoweredApplicationName

        IF(@ApplicationId IS NULL)
        BEGIN
            SELECT  @ApplicationId = NEWID()
            INSERT  [<dbUser,varchar,dbo>].subtext_Applications (ApplicationId, ApplicationName, LoweredApplicationName)
            VALUES  (@ApplicationId, @ApplicationName, LOWER(@ApplicationName))
        END


        IF( @TranStarted = 1 )
        BEGIN
            IF(@@ERROR = 0)
            BEGIN
	        SET @TranStarted = 0
	        COMMIT TRANSACTION
            END
            ELSE
            BEGIN
                SET @TranStarted = 0
                ROLLBACK TRANSACTION
            END
        END
    END
END

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [<dbUser,varchar,dbo>].[subtext_AnyDataInTables]
    @TablesToCheck int
AS
BEGIN
    -- Check Membership table if (@TablesToCheck & 1) is set
    IF ((@TablesToCheck & 1) <> 0 AND
        (EXISTS (SELECT name FROM sysobjects WHERE (name = N'vw_subtext_MembershipUsers') AND (type = 'V'))))
    BEGIN
        IF (EXISTS(SELECT TOP 1 UserId FROM [<dbUser,varchar,dbo>].subtext_Membership))
        BEGIN
            SELECT N'subtext_Membership'
            RETURN
        END
    END

    -- Check subtext_Roles table if (@TablesToCheck & 2) is set
    IF ((@TablesToCheck & 2) <> 0  AND
        (EXISTS (SELECT name FROM sysobjects WHERE (name = N'vw_subtext_Roles') AND (type = 'V'))) )
    BEGIN
        IF (EXISTS(SELECT TOP 1 RoleId FROM [<dbUser,varchar,dbo>].subtext_Roles))
        BEGIN
            SELECT N'subtext_Roles'
            RETURN
        END
    END

    -- Check subtext_Profile table if (@TablesToCheck & 4) is set
    IF ((@TablesToCheck & 4) <> 0  AND
        (EXISTS (SELECT name FROM sysobjects WHERE (name = N'vw_subtext_Profiles') AND (type = 'V'))) )
    BEGIN
        IF (EXISTS(SELECT TOP 1 UserId FROM [<dbUser,varchar,dbo>].subtext_Profile))
        BEGIN
            SELECT N'subtext_Profile'
            RETURN
        END
    END

    -- Check subtext_PersonalizationPerUser table if (@TablesToCheck & 8) is set
    IF ((@TablesToCheck & 8) <> 0  AND
        (EXISTS (SELECT name FROM sysobjects WHERE (name = N'vw_subtext_WebPartState_User') AND (type = 'V'))) )
    BEGIN
        IF (EXISTS(SELECT TOP 1 UserId FROM [<dbUser,varchar,dbo>].subtext_PersonalizationPerUser))
        BEGIN
            SELECT N'subtext_PersonalizationPerUser'
            RETURN
        END
    END

    -- Check subtext_PersonalizationPerUser table if (@TablesToCheck & 16) is set
    IF ((@TablesToCheck & 16) <> 0  AND
        (EXISTS (SELECT name FROM sysobjects WHERE (name = N'subtext_WebEvent_LogEvent') AND (type = 'P'))) )
    BEGIN
        IF (EXISTS(SELECT TOP 1 * FROM [<dbUser,varchar,dbo>].subtext_WebEvent_Events))
        BEGIN
            SELECT N'subtext_WebEvent_Events'
            RETURN
        END
    END

    -- Check subtext_Users table if (@TablesToCheck & 1,2,4 & 8) are all set
    IF ((@TablesToCheck & 1) <> 0 AND
        (@TablesToCheck & 2) <> 0 AND
        (@TablesToCheck & 4) <> 0 AND
        (@TablesToCheck & 8) <> 0 AND
        (@TablesToCheck & 32) <> 0 AND
        (@TablesToCheck & 128) <> 0 AND
        (@TablesToCheck & 256) <> 0 AND
        (@TablesToCheck & 512) <> 0 AND
        (@TablesToCheck & 1024) <> 0)
    BEGIN
        IF (EXISTS(SELECT TOP 1 UserId FROM [<dbUser,varchar,dbo>].subtext_Users))
        BEGIN
            SELECT N'subtext_Users'
            RETURN
        END
        IF (EXISTS(SELECT TOP 1 ApplicationId FROM [<dbUser,varchar,dbo>].subtext_Applications))
        BEGIN
            SELECT N'subtext_Applications'
            RETURN
        END
    END
END

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE PROCEDURE [<dbUser,varchar,dbo>].[subtext_Users_CreateUser]
    @ApplicationId    uniqueidentifier,
    @UserName         nvarchar(256),
    @IsUserAnonymous  bit,
    @LastActivityDate DATETIME,
    @UserId           uniqueidentifier OUTPUT
AS
BEGIN
    IF( @UserId IS NULL )
        SELECT @UserId = NEWID()
    ELSE
    BEGIN
        IF( EXISTS( SELECT UserId FROM [<dbUser,varchar,dbo>].subtext_Users
                    WHERE @UserId = UserId ) )
            RETURN -1
    END

    INSERT [<dbUser,varchar,dbo>].subtext_Users (ApplicationId, UserId, UserName, LoweredUserName, IsAnonymous, LastActivityDate)
    VALUES (@ApplicationId, @UserId, @UserName, LOWER(@UserName), @IsUserAnonymous, @LastActivityDate)

    RETURN 0
END

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [<dbUser,varchar,dbo>].[subtext_PersonalizationAllUsers_SetPageSettings] (
    @ApplicationName  NVARCHAR(256),
    @Path             NVARCHAR(256),
    @PageSettings     IMAGE,
    @CurrentTimeUtc   DATETIME)
AS
BEGIN
    DECLARE @ApplicationId UNIQUEIDENTIFIER
    DECLARE @PathId UNIQUEIDENTIFIER

    SELECT @ApplicationId = NULL
    SELECT @PathId = NULL

    EXEC [<dbUser,varchar,dbo>].subtext_Applications_CreateApplication @ApplicationName, @ApplicationId OUTPUT

    SELECT @PathId = u.PathId FROM [<dbUser,varchar,dbo>].subtext_Paths u WHERE u.ApplicationId = @ApplicationId AND u.LoweredPath = LOWER(@Path)
    IF (@PathId IS NULL)
    BEGIN
        EXEC [<dbUser,varchar,dbo>].subtext_Paths_CreatePath @ApplicationId, @Path, @PathId OUTPUT
    END

    IF (EXISTS(SELECT PathId FROM [<dbUser,varchar,dbo>].subtext_PersonalizationAllUsers WHERE PathId = @PathId))
        UPDATE [<dbUser,varchar,dbo>].subtext_PersonalizationAllUsers SET PageSettings = @PageSettings, LastUpdatedDate = @CurrentTimeUtc WHERE PathId = @PathId
    ELSE
        INSERT INTO [<dbUser,varchar,dbo>].subtext_PersonalizationAllUsers(PathId, PageSettings, LastUpdatedDate) VALUES (@PathId, @PageSettings, @CurrentTimeUtc)
    RETURN 0
END

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [<dbUser,varchar,dbo>].[subtext_Roles_CreateRole]
    @ApplicationName  nvarchar(256),
    @RoleName         nvarchar(256)
AS
BEGIN
    DECLARE @ApplicationId uniqueidentifier
    SELECT  @ApplicationId = NULL

    DECLARE @ErrorCode     int
    SET @ErrorCode = 0

    DECLARE @TranStarted   bit
    SET @TranStarted = 0

    IF( @@TRANCOUNT = 0 )
    BEGIN
        BEGIN TRANSACTION
        SET @TranStarted = 1
    END
    ELSE
        SET @TranStarted = 0

    EXEC [<dbUser,varchar,dbo>].subtext_Applications_CreateApplication @ApplicationName, @ApplicationId OUTPUT

    IF( @@ERROR <> 0 )
    BEGIN
        SET @ErrorCode = -1
        GOTO Cleanup
    END

    IF (EXISTS(SELECT RoleId FROM [<dbUser,varchar,dbo>].subtext_Roles WHERE LoweredRoleName = LOWER(@RoleName) AND ApplicationId = @ApplicationId))
    BEGIN
        SET @ErrorCode = 1
        GOTO Cleanup
    END

    INSERT INTO [<dbUser,varchar,dbo>].subtext_Roles
                (ApplicationId, RoleName, LoweredRoleName)
         VALUES (@ApplicationId, @RoleName, LOWER(@RoleName))

    IF( @@ERROR <> 0 )
    BEGIN
        SET @ErrorCode = -1
        GOTO Cleanup
    END

    IF( @TranStarted = 1 )
    BEGIN
        SET @TranStarted = 0
        COMMIT TRANSACTION
    END

    RETURN(0)

Cleanup:

    IF( @TranStarted = 1 )
    BEGIN
        SET @TranStarted = 0
        ROLLBACK TRANSACTION
    END

    RETURN @ErrorCode

END

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE PROCEDURE [<dbUser,varchar,dbo>].[subtext_Profile_SetProperties]
    @ApplicationName        nvarchar(256),
    @PropertyNames          ntext,
    @PropertyValuesString   ntext,
    @PropertyValuesBinary   image,
    @UserName               nvarchar(256),
    @IsUserAnonymous        bit,
    @CurrentTimeUtc         datetime
AS
BEGIN
    DECLARE @ApplicationId uniqueidentifier
    SELECT  @ApplicationId = NULL

    DECLARE @ErrorCode     int
    SET @ErrorCode = 0

    DECLARE @TranStarted   bit
    SET @TranStarted = 0

    IF( @@TRANCOUNT = 0 )
    BEGIN
       BEGIN TRANSACTION
       SET @TranStarted = 1
    END
    ELSE
    	SET @TranStarted = 0

    EXEC [<dbUser,varchar,dbo>].subtext_Applications_CreateApplication @ApplicationName, @ApplicationId OUTPUT

    IF( @@ERROR <> 0 )
    BEGIN
        SET @ErrorCode = -1
        GOTO Cleanup
    END

    DECLARE @UserId uniqueidentifier
    DECLARE @LastActivityDate datetime
    SELECT  @UserId = NULL
    SELECT  @LastActivityDate = @CurrentTimeUtc

    SELECT @UserId = UserId
    FROM   [<dbUser,varchar,dbo>].subtext_Users
    WHERE  ApplicationId = @ApplicationId AND LoweredUserName = LOWER(@UserName)
    IF (@UserId IS NULL)
        EXEC [<dbUser,varchar,dbo>].subtext_Users_CreateUser @ApplicationId, @UserName, @IsUserAnonymous, @LastActivityDate, @UserId OUTPUT

    IF( @@ERROR <> 0 )
    BEGIN
        SET @ErrorCode = -1
        GOTO Cleanup
    END

    UPDATE [<dbUser,varchar,dbo>].subtext_Users
    SET    LastActivityDate=@CurrentTimeUtc
    WHERE  UserId = @UserId

    IF( @@ERROR <> 0 )
    BEGIN
        SET @ErrorCode = -1
        GOTO Cleanup
    END

    IF (EXISTS( SELECT *
               FROM   [<dbUser,varchar,dbo>].subtext_Profile
               WHERE  UserId = @UserId))
        UPDATE [<dbUser,varchar,dbo>].subtext_Profile
        SET    PropertyNames=@PropertyNames, PropertyValuesString = @PropertyValuesString,
               PropertyValuesBinary = @PropertyValuesBinary, LastUpdatedDate=@CurrentTimeUtc
        WHERE  UserId = @UserId
    ELSE
        INSERT INTO [<dbUser,varchar,dbo>].subtext_Profile(UserId, PropertyNames, PropertyValuesString, PropertyValuesBinary, LastUpdatedDate)
             VALUES (@UserId, @PropertyNames, @PropertyValuesString, @PropertyValuesBinary, @CurrentTimeUtc)

    IF( @@ERROR <> 0 )
    BEGIN
        SET @ErrorCode = -1
        GOTO Cleanup
    END

    IF( @TranStarted = 1 )
    BEGIN
    	SET @TranStarted = 0
    	COMMIT TRANSACTION
    END

    RETURN 0

Cleanup:

    IF( @TranStarted = 1 )
    BEGIN
        SET @TranStarted = 0
    	ROLLBACK TRANSACTION
    END

    RETURN @ErrorCode

END

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [<dbUser,varchar,dbo>].[subtext_Membership_CreateUser]
    @ApplicationName                        nvarchar(256),
    @UserName                               nvarchar(256),
    @Password                               nvarchar(128),
    @PasswordSalt                           nvarchar(128),
    @Email                                  nvarchar(256),
    @PasswordQuestion                       nvarchar(256),
    @PasswordAnswer                         nvarchar(128),
    @IsApproved                             bit,
    @CurrentTimeUtc                         datetime,
    @CreateDate                             datetime = NULL,
    @UniqueEmail                            int      = 0,
    @PasswordFormat                         int      = 0,
    @UserId                                 uniqueidentifier OUTPUT
AS
BEGIN
    DECLARE @ApplicationId uniqueidentifier
    SELECT  @ApplicationId = NULL

    DECLARE @NewUserId uniqueidentifier
    SELECT @NewUserId = NULL

    DECLARE @IsLockedOut bit
    SET @IsLockedOut = 0

    DECLARE @LastLockoutDate  datetime
    SET @LastLockoutDate = CONVERT( datetime, '17540101', 112 )

    DECLARE @FailedPasswordAttemptCount int
    SET @FailedPasswordAttemptCount = 0

    DECLARE @FailedPasswordAttemptWindowStart  datetime
    SET @FailedPasswordAttemptWindowStart = CONVERT( datetime, '17540101', 112 )

    DECLARE @FailedPasswordAnswerAttemptCount int
    SET @FailedPasswordAnswerAttemptCount = 0

    DECLARE @FailedPasswordAnswerAttemptWindowStart  datetime
    SET @FailedPasswordAnswerAttemptWindowStart = CONVERT( datetime, '17540101', 112 )

    DECLARE @NewUserCreated bit
    DECLARE @ReturnValue   int
    SET @ReturnValue = 0

    DECLARE @ErrorCode     int
    SET @ErrorCode = 0

    DECLARE @TranStarted   bit
    SET @TranStarted = 0

    IF( @@TRANCOUNT = 0 )
    BEGIN
	    BEGIN TRANSACTION
	    SET @TranStarted = 1
    END
    ELSE
    	SET @TranStarted = 0

    EXEC [<dbUser,varchar,dbo>].subtext_Applications_CreateApplication @ApplicationName, @ApplicationId OUTPUT

    IF( @@ERROR <> 0 )
    BEGIN
        SET @ErrorCode = -1
        GOTO Cleanup
    END

    SET @CreateDate = @CurrentTimeUtc

    SELECT  @NewUserId = UserId FROM [<dbUser,varchar,dbo>].subtext_Users WHERE LOWER(@UserName) = LoweredUserName AND @ApplicationId = ApplicationId
    IF ( @NewUserId IS NULL )
    BEGIN
        SET @NewUserId = @UserId
        EXEC @ReturnValue = [<dbUser,varchar,dbo>].subtext_Users_CreateUser @ApplicationId, @UserName, 0, @CreateDate, @NewUserId OUTPUT
        SET @NewUserCreated = 1
    END
    ELSE
    BEGIN
        SET @NewUserCreated = 0
        IF( @NewUserId <> @UserId AND @UserId IS NOT NULL )
        BEGIN
            SET @ErrorCode = 6
            GOTO Cleanup
        END
    END

    IF( @@ERROR <> 0 )
    BEGIN
        SET @ErrorCode = -1
        GOTO Cleanup
    END

    IF( @ReturnValue = -1 )
    BEGIN
        SET @ErrorCode = 10
        GOTO Cleanup
    END

    IF ( EXISTS ( SELECT UserId
                  FROM   [<dbUser,varchar,dbo>].subtext_Membership
                  WHERE  @NewUserId = UserId ) )
    BEGIN
        SET @ErrorCode = 6
        GOTO Cleanup
    END

    SET @UserId = @NewUserId

    IF (@UniqueEmail = 1)
    BEGIN
        IF (EXISTS (SELECT *
                    FROM  [<dbUser,varchar,dbo>].subtext_Membership m WITH ( UPDLOCK, HOLDLOCK )
                    WHERE ApplicationId = @ApplicationId AND LoweredEmail = LOWER(@Email)))
        BEGIN
            SET @ErrorCode = 7
            GOTO Cleanup
        END
    END

    IF (@NewUserCreated = 0)
    BEGIN
        UPDATE [<dbUser,varchar,dbo>].subtext_Users
        SET    LastActivityDate = @CreateDate
        WHERE  @UserId = UserId
        IF( @@ERROR <> 0 )
        BEGIN
            SET @ErrorCode = -1
            GOTO Cleanup
        END
    END

    INSERT INTO [<dbUser,varchar,dbo>].subtext_Membership
                ( ApplicationId,
                  UserId,
                  Password,
                  PasswordSalt,
                  Email,
                  LoweredEmail,
                  PasswordQuestion,
                  PasswordAnswer,
                  PasswordFormat,
                  IsApproved,
                  IsLockedOut,
                  CreateDate,
                  LastLoginDate,
                  LastPasswordChangedDate,
                  LastLockoutDate,
                  FailedPasswordAttemptCount,
                  FailedPasswordAttemptWindowStart,
                  FailedPasswordAnswerAttemptCount,
                  FailedPasswordAnswerAttemptWindowStart )
         VALUES ( @ApplicationId,
                  @UserId,
                  @Password,
                  @PasswordSalt,
                  @Email,
                  LOWER(@Email),
                  @PasswordQuestion,
                  @PasswordAnswer,
                  @PasswordFormat,
                  @IsApproved,
                  @IsLockedOut,
                  @CreateDate,
                  @CreateDate,
                  @CreateDate,
                  @LastLockoutDate,
                  @FailedPasswordAttemptCount,
                  @FailedPasswordAttemptWindowStart,
                  @FailedPasswordAnswerAttemptCount,
                  @FailedPasswordAnswerAttemptWindowStart )

    IF( @@ERROR <> 0 )
    BEGIN
        SET @ErrorCode = -1
        GOTO Cleanup
    END

    IF( @TranStarted = 1 )
    BEGIN
	    SET @TranStarted = 0
	    COMMIT TRANSACTION
    END

    RETURN 0

Cleanup:

    IF( @TranStarted = 1 )
    BEGIN
        SET @TranStarted = 0
    	ROLLBACK TRANSACTION
    END

    RETURN @ErrorCode

END

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [<dbUser,varchar,dbo>].[subtext_PersonalizationPerUser_SetPageSettings] (
    @ApplicationName  NVARCHAR(256),
    @UserName         NVARCHAR(256),
    @Path             NVARCHAR(256),
    @PageSettings     IMAGE,
    @CurrentTimeUtc   DATETIME)
AS
BEGIN
    DECLARE @ApplicationId UNIQUEIDENTIFIER
    DECLARE @PathId UNIQUEIDENTIFIER
    DECLARE @UserId UNIQUEIDENTIFIER

    SELECT @ApplicationId = NULL
    SELECT @PathId = NULL
    SELECT @UserId = NULL

    EXEC [<dbUser,varchar,dbo>].subtext_Applications_CreateApplication @ApplicationName, @ApplicationId OUTPUT

    SELECT @PathId = u.PathId FROM [<dbUser,varchar,dbo>].subtext_Paths u WHERE u.ApplicationId = @ApplicationId AND u.LoweredPath = LOWER(@Path)
    IF (@PathId IS NULL)
    BEGIN
        EXEC [<dbUser,varchar,dbo>].subtext_Paths_CreatePath @ApplicationId, @Path, @PathId OUTPUT
    END

    SELECT @UserId = u.UserId FROM [<dbUser,varchar,dbo>].subtext_Users u WHERE u.ApplicationId = @ApplicationId AND u.LoweredUserName = LOWER(@UserName)
    IF (@UserId IS NULL)
    BEGIN
        EXEC [<dbUser,varchar,dbo>].subtext_Users_CreateUser @ApplicationId, @UserName, 0, @CurrentTimeUtc, @UserId OUTPUT
    END

    UPDATE   [<dbUser,varchar,dbo>].subtext_Users WITH (ROWLOCK)
    SET      LastActivityDate = @CurrentTimeUtc
    WHERE    UserId = @UserId
    IF (@@ROWCOUNT = 0) -- Username not found
        RETURN

    IF (EXISTS(SELECT PathId FROM [<dbUser,varchar,dbo>].subtext_PersonalizationPerUser WHERE UserId = @UserId AND PathId = @PathId))
        UPDATE [<dbUser,varchar,dbo>].subtext_PersonalizationPerUser SET PageSettings = @PageSettings, LastUpdatedDate = @CurrentTimeUtc WHERE UserId = @UserId AND PathId = @PathId
    ELSE
        INSERT INTO [<dbUser,varchar,dbo>].subtext_PersonalizationPerUser(UserId, PathId, PageSettings, LastUpdatedDate) VALUES (@UserId, @PathId, @PageSettings, @CurrentTimeUtc)
    RETURN 0
END

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE PROCEDURE [<dbUser,varchar,dbo>].[subtext_Profile_DeleteProfiles]
    @ApplicationName        nvarchar(256),
    @UserNames              nvarchar(4000)
AS
BEGIN
    DECLARE @UserName     nvarchar(256)
    DECLARE @CurrentPos   int
    DECLARE @NextPos      int
    DECLARE @NumDeleted   int
    DECLARE @DeletedUser  int
    DECLARE @TranStarted  bit
    DECLARE @ErrorCode    int

    SET @ErrorCode = 0
    SET @CurrentPos = 1
    SET @NumDeleted = 0
    SET @TranStarted = 0

    IF( @@TRANCOUNT = 0 )
    BEGIN
        BEGIN TRANSACTION
        SET @TranStarted = 1
    END
    ELSE
    	SET @TranStarted = 0

    WHILE (@CurrentPos <= LEN(@UserNames))
    BEGIN
        SELECT @NextPos = CHARINDEX(N',', @UserNames,  @CurrentPos)
        IF (@NextPos = 0 OR @NextPos IS NULL)
            SELECT @NextPos = LEN(@UserNames) + 1

        SELECT @UserName = SUBSTRING(@UserNames, @CurrentPos, @NextPos - @CurrentPos)
        SELECT @CurrentPos = @NextPos+1

        IF (LEN(@UserName) > 0)
        BEGIN
            SELECT @DeletedUser = 0
            EXEC [<dbUser,varchar,dbo>].subtext_Users_DeleteUser @ApplicationName, @UserName, 4, @DeletedUser OUTPUT
            IF( @@ERROR <> 0 )
            BEGIN
                SET @ErrorCode = -1
                GOTO Cleanup
            END
            IF (@DeletedUser <> 0)
                SELECT @NumDeleted = @NumDeleted + 1
        END
    END
    SELECT @NumDeleted
    IF (@TranStarted = 1)
    BEGIN
    	SET @TranStarted = 0
    	COMMIT TRANSACTION
    END
    SET @TranStarted = 0

    RETURN 0

Cleanup:
    IF (@TranStarted = 1 )
    BEGIN
        SET @TranStarted = 0
    	ROLLBACK TRANSACTION
    END
    RETURN @ErrorCode
END

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [<dbUser,varchar,dbo>].[subtext_PersonalizationAllUsers_GetPageSettings] (
    @ApplicationName  NVARCHAR(256),
    @Path              NVARCHAR(256))
AS
BEGIN
    DECLARE @ApplicationId UNIQUEIDENTIFIER
    DECLARE @PathId UNIQUEIDENTIFIER

    SELECT @ApplicationId = NULL
    SELECT @PathId = NULL

    EXEC [<dbUser,varchar,dbo>].subtext_Personalization_GetApplicationId @ApplicationName, @ApplicationId OUTPUT
    IF (@ApplicationId IS NULL)
    BEGIN
        RETURN
    END

    SELECT @PathId = u.PathId FROM [<dbUser,varchar,dbo>].subtext_Paths u WHERE u.ApplicationId = @ApplicationId AND u.LoweredPath = LOWER(@Path)
    IF (@PathId IS NULL)
    BEGIN
        RETURN
    END

    SELECT p.PageSettings FROM [<dbUser,varchar,dbo>].subtext_PersonalizationAllUsers p WHERE p.PathId = @PathId
END

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [<dbUser,varchar,dbo>].[subtext_PersonalizationAllUsers_ResetPageSettings] (
    @ApplicationName  NVARCHAR(256),
    @Path              NVARCHAR(256))
AS
BEGIN
    DECLARE @ApplicationId UNIQUEIDENTIFIER
    DECLARE @PathId UNIQUEIDENTIFIER

    SELECT @ApplicationId = NULL
    SELECT @PathId = NULL

    EXEC [<dbUser,varchar,dbo>].subtext_Personalization_GetApplicationId @ApplicationName, @ApplicationId OUTPUT
    IF (@ApplicationId IS NULL)
    BEGIN
        RETURN
    END

    SELECT @PathId = u.PathId FROM [<dbUser,varchar,dbo>].subtext_Paths u WHERE u.ApplicationId = @ApplicationId AND u.LoweredPath = LOWER(@Path)
    IF (@PathId IS NULL)
    BEGIN
        RETURN
    END

    DELETE FROM [<dbUser,varchar,dbo>].subtext_PersonalizationAllUsers WHERE PathId = @PathId
    RETURN 0
END

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [<dbUser,varchar,dbo>].[subtext_PersonalizationPerUser_GetPageSettings] (
    @ApplicationName  NVARCHAR(256),
    @UserName         NVARCHAR(256),
    @Path             NVARCHAR(256),
    @CurrentTimeUtc   DATETIME)
AS
BEGIN
    DECLARE @ApplicationId UNIQUEIDENTIFIER
    DECLARE @PathId UNIQUEIDENTIFIER
    DECLARE @UserId UNIQUEIDENTIFIER

    SELECT @ApplicationId = NULL
    SELECT @PathId = NULL
    SELECT @UserId = NULL

    EXEC [<dbUser,varchar,dbo>].subtext_Personalization_GetApplicationId @ApplicationName, @ApplicationId OUTPUT
    IF (@ApplicationId IS NULL)
    BEGIN
        RETURN
    END

    SELECT @PathId = u.PathId FROM [<dbUser,varchar,dbo>].subtext_Paths u WHERE u.ApplicationId = @ApplicationId AND u.LoweredPath = LOWER(@Path)
    IF (@PathId IS NULL)
    BEGIN
        RETURN
    END

    SELECT @UserId = u.UserId FROM [<dbUser,varchar,dbo>].subtext_Users u WHERE u.ApplicationId = @ApplicationId AND u.LoweredUserName = LOWER(@UserName)
    IF (@UserId IS NULL)
    BEGIN
        RETURN
    END

    UPDATE   [<dbUser,varchar,dbo>].subtext_Users WITH (ROWLOCK)
    SET      LastActivityDate = @CurrentTimeUtc
    WHERE    UserId = @UserId
    IF (@@ROWCOUNT = 0) -- Username not found
        RETURN

    SELECT p.PageSettings FROM [<dbUser,varchar,dbo>].subtext_PersonalizationPerUser p WHERE p.PathId = @PathId AND p.UserId = @UserId
END

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [<dbUser,varchar,dbo>].[subtext_PersonalizationPerUser_ResetPageSettings] (
    @ApplicationName  NVARCHAR(256),
    @UserName         NVARCHAR(256),
    @Path             NVARCHAR(256),
    @CurrentTimeUtc   DATETIME)
AS
BEGIN
    DECLARE @ApplicationId UNIQUEIDENTIFIER
    DECLARE @PathId UNIQUEIDENTIFIER
    DECLARE @UserId UNIQUEIDENTIFIER

    SELECT @ApplicationId = NULL
    SELECT @PathId = NULL
    SELECT @UserId = NULL

    EXEC [<dbUser,varchar,dbo>].subtext_Personalization_GetApplicationId @ApplicationName, @ApplicationId OUTPUT
    IF (@ApplicationId IS NULL)
    BEGIN
        RETURN
    END

    SELECT @PathId = u.PathId FROM [<dbUser,varchar,dbo>].subtext_Paths u WHERE u.ApplicationId = @ApplicationId AND u.LoweredPath = LOWER(@Path)
    IF (@PathId IS NULL)
    BEGIN
        RETURN
    END

    SELECT @UserId = u.UserId FROM [<dbUser,varchar,dbo>].subtext_Users u WHERE u.ApplicationId = @ApplicationId AND u.LoweredUserName = LOWER(@UserName)
    IF (@UserId IS NULL)
    BEGIN
        RETURN
    END

    UPDATE   [<dbUser,varchar,dbo>].subtext_Users WITH (ROWLOCK)
    SET      LastActivityDate = @CurrentTimeUtc
    WHERE    UserId = @UserId
    IF (@@ROWCOUNT = 0) -- Username not found
        RETURN

    DELETE FROM [<dbUser,varchar,dbo>].subtext_PersonalizationPerUser WHERE PathId = @PathId AND UserId = @UserId
    RETURN 0
END

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [<dbUser,varchar,dbo>].[subtext_PersonalizationAdministration_DeleteAllState] (
    @AllUsersScope bit,
    @ApplicationName NVARCHAR(256),
    @Count int OUT)
AS
BEGIN
    DECLARE @ApplicationId UNIQUEIDENTIFIER
    EXEC [<dbUser,varchar,dbo>].subtext_Personalization_GetApplicationId @ApplicationName, @ApplicationId OUTPUT
    IF (@ApplicationId IS NULL)
        SELECT @Count = 0
    ELSE
    BEGIN
        IF (@AllUsersScope = 1)
            DELETE FROM subtext_PersonalizationAllUsers
            WHERE PathId IN
               (SELECT Paths.PathId
                FROM [<dbUser,varchar,dbo>].subtext_Paths Paths
                WHERE Paths.ApplicationId = @ApplicationId)
        ELSE
            DELETE FROM subtext_PersonalizationPerUser
            WHERE PathId IN
               (SELECT Paths.PathId
                FROM [<dbUser,varchar,dbo>].subtext_Paths Paths
                WHERE Paths.ApplicationId = @ApplicationId)

        SELECT @Count = @@ROWCOUNT
    END
END

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [<dbUser,varchar,dbo>].[subtext_PersonalizationAdministration_ResetSharedState] (
    @Count int OUT,
    @ApplicationName NVARCHAR(256),
    @Path NVARCHAR(256))
AS
BEGIN
    DECLARE @ApplicationId UNIQUEIDENTIFIER
    EXEC [<dbUser,varchar,dbo>].subtext_Personalization_GetApplicationId @ApplicationName, @ApplicationId OUTPUT
    IF (@ApplicationId IS NULL)
        SELECT @Count = 0
    ELSE
    BEGIN
        DELETE FROM [<dbUser,varchar,dbo>].subtext_PersonalizationAllUsers
        WHERE PathId IN
            (SELECT AllUsers.PathId
             FROM [<dbUser,varchar,dbo>].subtext_PersonalizationAllUsers AllUsers, [<dbUser,varchar,dbo>].subtext_Paths Paths
             WHERE Paths.ApplicationId = @ApplicationId
                   AND AllUsers.PathId = Paths.PathId
                   AND Paths.LoweredPath = LOWER(@Path))

        SELECT @Count = @@ROWCOUNT
    END
END

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [<dbUser,varchar,dbo>].[subtext_PersonalizationAdministration_ResetUserState] (
    @Count                  int                 OUT,
    @ApplicationName        NVARCHAR(256),
    @InactiveSinceDate      DATETIME            = NULL,
    @UserName               NVARCHAR(256)       = NULL,
    @Path                   NVARCHAR(256)       = NULL)
AS
BEGIN
    DECLARE @ApplicationId UNIQUEIDENTIFIER
    EXEC [<dbUser,varchar,dbo>].subtext_Personalization_GetApplicationId @ApplicationName, @ApplicationId OUTPUT
    IF (@ApplicationId IS NULL)
        SELECT @Count = 0
    ELSE
    BEGIN
        DELETE FROM [<dbUser,varchar,dbo>].subtext_PersonalizationPerUser
        WHERE Id IN (SELECT PerUser.Id
                     FROM [<dbUser,varchar,dbo>].subtext_PersonalizationPerUser PerUser, [<dbUser,varchar,dbo>].subtext_Users Users, [<dbUser,varchar,dbo>].subtext_Paths Paths
                     WHERE Paths.ApplicationId = @ApplicationId
                           AND PerUser.UserId = Users.UserId
                           AND PerUser.PathId = Paths.PathId
                           AND (@InactiveSinceDate IS NULL OR Users.LastActivityDate <= @InactiveSinceDate)
                           AND (@UserName IS NULL OR Users.LoweredUserName = LOWER(@UserName))
                           AND (@Path IS NULL OR Paths.LoweredPath = LOWER(@Path)))

        SELECT @Count = @@ROWCOUNT
    END
END

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [<dbUser,varchar,dbo>].[subtext_PersonalizationAdministration_GetCountOfState] (
    @Count int OUT,
    @AllUsersScope bit,
    @ApplicationName NVARCHAR(256),
    @Path NVARCHAR(256) = NULL,
    @UserName NVARCHAR(256) = NULL,
    @InactiveSinceDate DATETIME = NULL)
AS
BEGIN

    DECLARE @ApplicationId UNIQUEIDENTIFIER
    EXEC [<dbUser,varchar,dbo>].subtext_Personalization_GetApplicationId @ApplicationName, @ApplicationId OUTPUT
    IF (@ApplicationId IS NULL)
        SELECT @Count = 0
    ELSE
        IF (@AllUsersScope = 1)
            SELECT @Count = COUNT(*)
            FROM [<dbUser,varchar,dbo>].subtext_PersonalizationAllUsers AllUsers, [<dbUser,varchar,dbo>].subtext_Paths Paths
            WHERE Paths.ApplicationId = @ApplicationId
                  AND AllUsers.PathId = Paths.PathId
                  AND (@Path IS NULL OR Paths.LoweredPath LIKE LOWER(@Path))
        ELSE
            SELECT @Count = COUNT(*)
            FROM [<dbUser,varchar,dbo>].subtext_PersonalizationPerUser PerUser, [<dbUser,varchar,dbo>].subtext_Users Users, [<dbUser,varchar,dbo>].subtext_Paths Paths
            WHERE Paths.ApplicationId = @ApplicationId
                  AND PerUser.UserId = Users.UserId
                  AND PerUser.PathId = Paths.PathId
                  AND (@Path IS NULL OR Paths.LoweredPath LIKE LOWER(@Path))
                  AND (@UserName IS NULL OR Users.LoweredUserName LIKE LOWER(@UserName))
                  AND (@InactiveSinceDate IS NULL OR Users.LastActivityDate <= @InactiveSinceDate)
END

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [<dbUser,varchar,dbo>].[subtext_PersonalizationAdministration_FindState] (
    @AllUsersScope bit,
    @ApplicationName NVARCHAR(256),
    @PageIndex              INT,
    @PageSize               INT,
    @Path NVARCHAR(256) = NULL,
    @UserName NVARCHAR(256) = NULL,
    @InactiveSinceDate DATETIME = NULL)
AS
BEGIN
    DECLARE @ApplicationId UNIQUEIDENTIFIER
    EXEC [<dbUser,varchar,dbo>].subtext_Personalization_GetApplicationId @ApplicationName, @ApplicationId OUTPUT
    IF (@ApplicationId IS NULL)
        RETURN

    -- Set the page bounds
    DECLARE @PageLowerBound INT
    DECLARE @PageUpperBound INT
    DECLARE @TotalRecords   INT
    SET @PageLowerBound = @PageSize * @PageIndex
    SET @PageUpperBound = @PageSize - 1 + @PageLowerBound

    -- Create a temp table to store the selected results
    CREATE TABLE #PageIndex (
        IndexId int IDENTITY (0, 1) NOT NULL,
        ItemId UNIQUEIDENTIFIER
    )

    IF (@AllUsersScope = 1)
    BEGIN
        -- Insert into our temp table
        INSERT INTO #PageIndex (ItemId)
        SELECT Paths.PathId
        FROM [<dbUser,varchar,dbo>].subtext_Paths Paths,
             ((SELECT Paths.PathId
               FROM [<dbUser,varchar,dbo>].subtext_PersonalizationAllUsers AllUsers, [<dbUser,varchar,dbo>].subtext_Paths Paths
               WHERE Paths.ApplicationId = @ApplicationId
                      AND AllUsers.PathId = Paths.PathId
                      AND (@Path IS NULL OR Paths.LoweredPath LIKE LOWER(@Path))
              ) AS SharedDataPerPath
              FULL OUTER JOIN
              (SELECT DISTINCT Paths.PathId
               FROM [<dbUser,varchar,dbo>].subtext_PersonalizationPerUser PerUser, [<dbUser,varchar,dbo>].subtext_Paths Paths
               WHERE Paths.ApplicationId = @ApplicationId
                      AND PerUser.PathId = Paths.PathId
                      AND (@Path IS NULL OR Paths.LoweredPath LIKE LOWER(@Path))
              ) AS UserDataPerPath
              ON SharedDataPerPath.PathId = UserDataPerPath.PathId
             )
        WHERE Paths.PathId = SharedDataPerPath.PathId OR Paths.PathId = UserDataPerPath.PathId
        ORDER BY Paths.Path ASC

        SELECT @TotalRecords = @@ROWCOUNT

        SELECT Paths.Path,
               SharedDataPerPath.LastUpdatedDate,
               SharedDataPerPath.SharedDataLength,
               UserDataPerPath.UserDataLength,
               UserDataPerPath.UserCount
        FROM [<dbUser,varchar,dbo>].subtext_Paths Paths,
             ((SELECT PageIndex.ItemId AS PathId,
                      AllUsers.LastUpdatedDate AS LastUpdatedDate,
                      DATALENGTH(AllUsers.PageSettings) AS SharedDataLength
               FROM [<dbUser,varchar,dbo>].subtext_PersonalizationAllUsers AllUsers, #PageIndex PageIndex
               WHERE AllUsers.PathId = PageIndex.ItemId
                     AND PageIndex.IndexId >= @PageLowerBound AND PageIndex.IndexId <= @PageUpperBound
              ) AS SharedDataPerPath
              FULL OUTER JOIN
              (SELECT PageIndex.ItemId AS PathId,
                      SUM(DATALENGTH(PerUser.PageSettings)) AS UserDataLength,
                      COUNT(*) AS UserCount
               FROM subtext_PersonalizationPerUser PerUser, #PageIndex PageIndex
               WHERE PerUser.PathId = PageIndex.ItemId
                     AND PageIndex.IndexId >= @PageLowerBound AND PageIndex.IndexId <= @PageUpperBound
               GROUP BY PageIndex.ItemId
              ) AS UserDataPerPath
              ON SharedDataPerPath.PathId = UserDataPerPath.PathId
             )
        WHERE Paths.PathId = SharedDataPerPath.PathId OR Paths.PathId = UserDataPerPath.PathId
        ORDER BY Paths.Path ASC
    END
    ELSE
    BEGIN
        -- Insert into our temp table
        INSERT INTO #PageIndex (ItemId)
        SELECT PerUser.Id
        FROM [<dbUser,varchar,dbo>].subtext_PersonalizationPerUser PerUser, [<dbUser,varchar,dbo>].subtext_Users Users, [<dbUser,varchar,dbo>].subtext_Paths Paths
        WHERE Paths.ApplicationId = @ApplicationId
              AND PerUser.UserId = Users.UserId
              AND PerUser.PathId = Paths.PathId
              AND (@Path IS NULL OR Paths.LoweredPath LIKE LOWER(@Path))
              AND (@UserName IS NULL OR Users.LoweredUserName LIKE LOWER(@UserName))
              AND (@InactiveSinceDate IS NULL OR Users.LastActivityDate <= @InactiveSinceDate)
        ORDER BY Paths.Path ASC, Users.UserName ASC

        SELECT @TotalRecords = @@ROWCOUNT

        SELECT Paths.Path, PerUser.LastUpdatedDate, DATALENGTH(PerUser.PageSettings), Users.UserName, Users.LastActivityDate
        FROM [<dbUser,varchar,dbo>].subtext_PersonalizationPerUser PerUser, [<dbUser,varchar,dbo>].subtext_Users Users, [<dbUser,varchar,dbo>].subtext_Paths Paths, #PageIndex PageIndex
        WHERE PerUser.Id = PageIndex.ItemId
              AND PerUser.UserId = Users.UserId
              AND PerUser.PathId = Paths.PathId
              AND PageIndex.IndexId >= @PageLowerBound AND PageIndex.IndexId <= @PageUpperBound
        ORDER BY Paths.Path ASC, Users.UserName ASC
    END

    RETURN @TotalRecords
END

GO
GRANT EXECUTE ON [<dbUser,varchar,dbo>].[subtext_RegisterSchemaVersion] TO [public]
GO
GRANT EXECUTE ON [<dbUser,varchar,dbo>].[subtext_RegisterSchemaVersion] TO [public]
GO
GRANT EXECUTE ON [<dbUser,varchar,dbo>].[subtext_RegisterSchemaVersion] TO [public]
GO
GRANT EXECUTE ON [<dbUser,varchar,dbo>].[subtext_RegisterSchemaVersion] TO [public]
GO
GRANT EXECUTE ON [<dbUser,varchar,dbo>].[subtext_RegisterSchemaVersion] TO [public]
GO
GRANT EXECUTE ON [<dbUser,varchar,dbo>].[subtext_RegisterSchemaVersion] TO [public]
GO
GRANT EXECUTE ON [<dbUser,varchar,dbo>].[subtext_RegisterSchemaVersion] TO [public]
GO
GRANT EXECUTE ON [<dbUser,varchar,dbo>].[subtext_RegisterSchemaVersion] TO [public]
GO
GRANT EXECUTE ON [<dbUser,varchar,dbo>].[subtext_RegisterSchemaVersion] TO [public]
GO
GRANT EXECUTE ON [<dbUser,varchar,dbo>].[subtext_CheckSchemaVersion] TO [public]
GO
GRANT EXECUTE ON [<dbUser,varchar,dbo>].[subtext_CheckSchemaVersion] TO [public]
GO
GRANT EXECUTE ON [<dbUser,varchar,dbo>].[subtext_CheckSchemaVersion] TO [public]
GO
GRANT EXECUTE ON [<dbUser,varchar,dbo>].[subtext_CheckSchemaVersion] TO [public]
GO
GRANT EXECUTE ON [<dbUser,varchar,dbo>].[subtext_CheckSchemaVersion] TO [public]
GO
GRANT EXECUTE ON [<dbUser,varchar,dbo>].[subtext_CheckSchemaVersion] TO [public]
GO
GRANT EXECUTE ON [<dbUser,varchar,dbo>].[subtext_CheckSchemaVersion] TO [public]
GO
GRANT EXECUTE ON [<dbUser,varchar,dbo>].[subtext_CheckSchemaVersion] TO [public]
GO
GRANT EXECUTE ON [<dbUser,varchar,dbo>].[subtext_CheckSchemaVersion] TO [public]
GO
GRANT EXECUTE ON [<dbUser,varchar,dbo>].[subtext_UnRegisterSchemaVersion] TO [public]
GO
GRANT EXECUTE ON [<dbUser,varchar,dbo>].[subtext_UnRegisterSchemaVersion] TO [public]
GO
GRANT EXECUTE ON [<dbUser,varchar,dbo>].[subtext_UnRegisterSchemaVersion] TO [public]
GO
GRANT EXECUTE ON [<dbUser,varchar,dbo>].[subtext_UnRegisterSchemaVersion] TO [public]
GO
GRANT EXECUTE ON [<dbUser,varchar,dbo>].[subtext_UnRegisterSchemaVersion] TO [public]
GO
GRANT EXECUTE ON [<dbUser,varchar,dbo>].[subtext_UnRegisterSchemaVersion] TO [public]
GO
GRANT EXECUTE ON [<dbUser,varchar,dbo>].[subtext_UnRegisterSchemaVersion] TO [public]
GO
GRANT EXECUTE ON [<dbUser,varchar,dbo>].[subtext_UnRegisterSchemaVersion] TO [public]
GO
GRANT EXECUTE ON [<dbUser,varchar,dbo>].[subtext_UnRegisterSchemaVersion] TO [public]
GO
GRANT EXECUTE ON [<dbUser,varchar,dbo>].[subtext_Membership_GetUserByName] TO [public]
GO
GRANT EXECUTE ON [<dbUser,varchar,dbo>].[subtext_Membership_GetUserByName] TO [public]
GO
GRANT EXECUTE ON [<dbUser,varchar,dbo>].[subtext_Membership_GetUserByUserId] TO [public]
GO
GRANT EXECUTE ON [<dbUser,varchar,dbo>].[subtext_Membership_GetUserByUserId] TO [public]
GO
GRANT EXECUTE ON [<dbUser,varchar,dbo>].[subtext_Membership_GetUserByEmail] TO [public]
GO
GRANT EXECUTE ON [<dbUser,varchar,dbo>].[subtext_Membership_GetUserByEmail] TO [public]
GO
GRANT EXECUTE ON [<dbUser,varchar,dbo>].[subtext_Membership_GetPasswordWithFormat] TO [public]
GO
GRANT EXECUTE ON [<dbUser,varchar,dbo>].[subtext_Membership_UpdateUserInfo] TO [public]
GO
GRANT EXECUTE ON [<dbUser,varchar,dbo>].[subtext_Membership_GetPassword] TO [public]
GO
GRANT EXECUTE ON [<dbUser,varchar,dbo>].[subtext_Membership_GetNumberOfUsersOnline] TO [public]
GO
GRANT EXECUTE ON [<dbUser,varchar,dbo>].[subtext_Membership_GetNumberOfUsersOnline] TO [public]
GO
GRANT EXECUTE ON [<dbUser,varchar,dbo>].[subtext_Membership_SetPassword] TO [public]
GO
GRANT EXECUTE ON [<dbUser,varchar,dbo>].[subtext_Membership_ResetPassword] TO [public]
GO
GRANT EXECUTE ON [<dbUser,varchar,dbo>].[subtext_Membership_UnlockUser] TO [public]
GO
GRANT EXECUTE ON [<dbUser,varchar,dbo>].[subtext_Membership_UpdateUser] TO [public]
GO
GRANT EXECUTE ON [<dbUser,varchar,dbo>].[subtext_Membership_ChangePasswordQuestionAndAnswer] TO [public]
GO
GRANT EXECUTE ON [<dbUser,varchar,dbo>].[subtext_Profile_GetProperties] TO [public]
GO
GRANT EXECUTE ON [<dbUser,varchar,dbo>].[subtext_Profile_DeleteInactiveProfiles] TO [public]
GO
GRANT EXECUTE ON [<dbUser,varchar,dbo>].[subtext_Profile_GetNumberOfInactiveProfiles] TO [public]
GO
GRANT EXECUTE ON [<dbUser,varchar,dbo>].[subtext_UsersInRoles_IsUserInRole] TO [public]
GO
GRANT EXECUTE ON [<dbUser,varchar,dbo>].[subtext_UsersInRoles_IsUserInRole] TO [public]
GO
GRANT EXECUTE ON [<dbUser,varchar,dbo>].[subtext_UsersInRoles_GetRolesForUser] TO [public]
GO
GRANT EXECUTE ON [<dbUser,varchar,dbo>].[subtext_UsersInRoles_GetRolesForUser] TO [public]
GO
GRANT EXECUTE ON [<dbUser,varchar,dbo>].[subtext_Roles_DeleteRole] TO [public]
GO
GRANT EXECUTE ON [<dbUser,varchar,dbo>].[subtext_Roles_RoleExists] TO [public]
GO
GRANT EXECUTE ON [<dbUser,varchar,dbo>].[subtext_UsersInRoles_AddUsersToRoles] TO [public]
GO
GRANT EXECUTE ON [<dbUser,varchar,dbo>].[subtext_UsersInRoles_RemoveUsersFromRoles] TO [public]
GO
GRANT EXECUTE ON [<dbUser,varchar,dbo>].[subtext_Roles_GetAllRoles] TO [public]
GO
GRANT EXECUTE ON [<dbUser,varchar,dbo>].[subtext_UsersInRoles_GetUsersInRoles] TO [public]
GO
GRANT EXECUTE ON [<dbUser,varchar,dbo>].[subtext_UsersInRoles_FindUsersInRole] TO [public]
GO
GRANT EXECUTE ON [<dbUser,varchar,dbo>].[subtext_Paths_CreatePath] TO [public]
GO
GRANT EXECUTE ON [<dbUser,varchar,dbo>].[subtext_WebEvent_LogEvent] TO [public]
GO
GRANT EXECUTE ON [<dbUser,varchar,dbo>].[subtext_Personalization_GetApplicationId] TO [public]
GO
GRANT EXECUTE ON [<dbUser,varchar,dbo>].[subtext_Profile_GetProfiles] TO [public]
GO
GRANT EXECUTE ON [<dbUser,varchar,dbo>].[subtext_Membership_FindUsersByName] TO [public]
GO
GRANT EXECUTE ON [<dbUser,varchar,dbo>].[subtext_Membership_FindUsersByEmail] TO [public]
GO
GRANT EXECUTE ON [<dbUser,varchar,dbo>].[subtext_Membership_GetAllUsers] TO [public]
GO
GRANT EXECUTE ON [<dbUser,varchar,dbo>].[subtext_Users_DeleteUser] TO [public]
GO
GRANT EXECUTE ON [<dbUser,varchar,dbo>].[subtext_PersonalizationAllUsers_SetPageSettings] TO [public]
GO
GRANT EXECUTE ON [<dbUser,varchar,dbo>].[subtext_Roles_CreateRole] TO [public]
GO
GRANT EXECUTE ON [<dbUser,varchar,dbo>].[subtext_Profile_SetProperties] TO [public]
GO
GRANT EXECUTE ON [<dbUser,varchar,dbo>].[subtext_Membership_CreateUser] TO [public]
GO
GRANT EXECUTE ON [<dbUser,varchar,dbo>].[subtext_PersonalizationPerUser_SetPageSettings] TO [public]
GO
GRANT EXECUTE ON [<dbUser,varchar,dbo>].[subtext_Profile_DeleteProfiles] TO [public]
GO
GRANT EXECUTE ON [<dbUser,varchar,dbo>].[subtext_PersonalizationAllUsers_GetPageSettings] TO [public]
GO
GRANT EXECUTE ON [<dbUser,varchar,dbo>].[subtext_PersonalizationAllUsers_ResetPageSettings] TO [public]
GO
GRANT EXECUTE ON [<dbUser,varchar,dbo>].[subtext_PersonalizationPerUser_GetPageSettings] TO [public]
GO
GRANT EXECUTE ON [<dbUser,varchar,dbo>].[subtext_PersonalizationPerUser_ResetPageSettings] TO [public]
GO
GRANT EXECUTE ON [<dbUser,varchar,dbo>].[subtext_PersonalizationAdministration_DeleteAllState] TO [public]
GO
GRANT EXECUTE ON [<dbUser,varchar,dbo>].[subtext_PersonalizationAdministration_ResetSharedState] TO [public]
GO
GRANT EXECUTE ON [<dbUser,varchar,dbo>].[subtext_PersonalizationAdministration_ResetUserState] TO [public]
GO
GRANT EXECUTE ON [<dbUser,varchar,dbo>].[subtext_PersonalizationAdministration_GetCountOfState] TO [public]
GO
GRANT EXECUTE ON [<dbUser,varchar,dbo>].[subtext_PersonalizationAdministration_FindState] TO [public]

/* Views */
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

  CREATE VIEW [<dbUser,varchar,dbo>].[vw_subtext_MembershipUsers]
  AS SELECT [<dbUser,varchar,dbo>].[subtext_Membership].[UserId],
            [<dbUser,varchar,dbo>].[subtext_Membership].[PasswordFormat],
            [<dbUser,varchar,dbo>].[subtext_Membership].[MobilePIN],
            [<dbUser,varchar,dbo>].[subtext_Membership].[Email],
            [<dbUser,varchar,dbo>].[subtext_Membership].[LoweredEmail],
            [<dbUser,varchar,dbo>].[subtext_Membership].[PasswordQuestion],
            [<dbUser,varchar,dbo>].[subtext_Membership].[PasswordAnswer],
            [<dbUser,varchar,dbo>].[subtext_Membership].[IsApproved],
            [<dbUser,varchar,dbo>].[subtext_Membership].[IsLockedOut],
            [<dbUser,varchar,dbo>].[subtext_Membership].[CreateDate],
            [<dbUser,varchar,dbo>].[subtext_Membership].[LastLoginDate],
            [<dbUser,varchar,dbo>].[subtext_Membership].[LastPasswordChangedDate],
            [<dbUser,varchar,dbo>].[subtext_Membership].[LastLockoutDate],
            [<dbUser,varchar,dbo>].[subtext_Membership].[FailedPasswordAttemptCount],
            [<dbUser,varchar,dbo>].[subtext_Membership].[FailedPasswordAttemptWindowStart],
            [<dbUser,varchar,dbo>].[subtext_Membership].[FailedPasswordAnswerAttemptCount],
            [<dbUser,varchar,dbo>].[subtext_Membership].[FailedPasswordAnswerAttemptWindowStart],
            [<dbUser,varchar,dbo>].[subtext_Membership].[Comment],
            [<dbUser,varchar,dbo>].[subtext_Users].[ApplicationId],
            [<dbUser,varchar,dbo>].[subtext_Users].[UserName],
            [<dbUser,varchar,dbo>].[subtext_Users].[MobileAlias],
            [<dbUser,varchar,dbo>].[subtext_Users].[IsAnonymous],
            [<dbUser,varchar,dbo>].[subtext_Users].[LastActivityDate]
  FROM [<dbUser,varchar,dbo>].[subtext_Membership] INNER JOIN [<dbUser,varchar,dbo>].[subtext_Users]
      ON [<dbUser,varchar,dbo>].[subtext_Membership].[UserId] = [<dbUser,varchar,dbo>].[subtext_Users].[UserId]
  
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

  CREATE VIEW [<dbUser,varchar,dbo>].[vw_subtext_Profiles]
  AS SELECT [<dbUser,varchar,dbo>].[subtext_Profile].[UserId], [<dbUser,varchar,dbo>].[subtext_Profile].[LastUpdatedDate],
      [DataSize]=  DATALENGTH([<dbUser,varchar,dbo>].[subtext_Profile].[PropertyNames])
                 + DATALENGTH([<dbUser,varchar,dbo>].[subtext_Profile].[PropertyValuesString])
                 + DATALENGTH([<dbUser,varchar,dbo>].[subtext_Profile].[PropertyValuesBinary])
  FROM [<dbUser,varchar,dbo>].[subtext_Profile]
  
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

  CREATE VIEW [<dbUser,varchar,dbo>].[vw_subtext_Roles]
  AS SELECT [<dbUser,varchar,dbo>].[subtext_Roles].[ApplicationId], [<dbUser,varchar,dbo>].[subtext_Roles].[RoleId], [<dbUser,varchar,dbo>].[subtext_Roles].[RoleName], [<dbUser,varchar,dbo>].[subtext_Roles].[LoweredRoleName], [<dbUser,varchar,dbo>].[subtext_Roles].[Description]
  FROM [<dbUser,varchar,dbo>].[subtext_Roles]
  
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

  CREATE VIEW [<dbUser,varchar,dbo>].[vw_subtext_UsersInRoles]
  AS SELECT [<dbUser,varchar,dbo>].[subtext_UsersInRoles].[UserId], [<dbUser,varchar,dbo>].[subtext_UsersInRoles].[RoleId]
  FROM [<dbUser,varchar,dbo>].[subtext_UsersInRoles]
  
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

  CREATE VIEW [<dbUser,varchar,dbo>].[vw_subtext_WebPartState_Paths]
  AS SELECT [<dbUser,varchar,dbo>].[subtext_Paths].[ApplicationId], [<dbUser,varchar,dbo>].[subtext_Paths].[PathId], [<dbUser,varchar,dbo>].[subtext_Paths].[Path], [<dbUser,varchar,dbo>].[subtext_Paths].[LoweredPath]
  FROM [<dbUser,varchar,dbo>].[subtext_Paths]
  
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

  CREATE VIEW [<dbUser,varchar,dbo>].[vw_subtext_WebPartState_Shared]
  AS SELECT [<dbUser,varchar,dbo>].[subtext_PersonalizationAllUsers].[PathId], [DataSize]=DATALENGTH([<dbUser,varchar,dbo>].[subtext_PersonalizationAllUsers].[PageSettings]), [<dbUser,varchar,dbo>].[subtext_PersonalizationAllUsers].[LastUpdatedDate]
  FROM [<dbUser,varchar,dbo>].[subtext_PersonalizationAllUsers]
  
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

  CREATE VIEW [<dbUser,varchar,dbo>].[vw_subtext_WebPartState_User]
  AS SELECT [<dbUser,varchar,dbo>].[subtext_PersonalizationPerUser].[PathId], [<dbUser,varchar,dbo>].[subtext_PersonalizationPerUser].[UserId], [DataSize]=DATALENGTH([<dbUser,varchar,dbo>].[subtext_PersonalizationPerUser].[PageSettings]), [<dbUser,varchar,dbo>].[subtext_PersonalizationPerUser].[LastUpdatedDate]
  FROM [<dbUser,varchar,dbo>].[subtext_PersonalizationPerUser]
  
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

  CREATE VIEW [<dbUser,varchar,dbo>].[vw_subtext_Applications]
  AS SELECT [<dbUser,varchar,dbo>].[subtext_Applications].[ApplicationName], [<dbUser,varchar,dbo>].[subtext_Applications].[LoweredApplicationName], [<dbUser,varchar,dbo>].[subtext_Applications].[ApplicationId], [<dbUser,varchar,dbo>].[subtext_Applications].[Description]
  FROM [<dbUser,varchar,dbo>].[subtext_Applications]
  
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

  CREATE VIEW [<dbUser,varchar,dbo>].[vw_subtext_Users]
  AS SELECT [<dbUser,varchar,dbo>].[subtext_Users].[ApplicationId], [<dbUser,varchar,dbo>].[subtext_Users].[UserId], [<dbUser,varchar,dbo>].[subtext_Users].[UserName], [<dbUser,varchar,dbo>].[subtext_Users].[LoweredUserName], [<dbUser,varchar,dbo>].[subtext_Users].[MobileAlias], [<dbUser,varchar,dbo>].[subtext_Users].[IsAnonymous], [<dbUser,varchar,dbo>].[subtext_Users].[LastActivityDate]
  FROM [<dbUser,varchar,dbo>].[subtext_Users]
  
GO
/* permission grants for views */

GRANT SELECT ON [<dbUser,varchar,dbo>].[vw_subtext_MembershipUsers] TO [public]
GO
GRANT SELECT ON [<dbUser,varchar,dbo>].[vw_subtext_MembershipUsers] ([UserId]) TO [public]
GO
GRANT SELECT ON [<dbUser,varchar,dbo>].[vw_subtext_MembershipUsers] ([PasswordFormat]) TO [public]
GO
GRANT SELECT ON [<dbUser,varchar,dbo>].[vw_subtext_MembershipUsers] ([MobilePIN]) TO [public]
GO
GRANT SELECT ON [<dbUser,varchar,dbo>].[vw_subtext_MembershipUsers] ([Email]) TO [public]
GO
GRANT SELECT ON [<dbUser,varchar,dbo>].[vw_subtext_MembershipUsers] ([LoweredEmail]) TO [public]
GO
GRANT SELECT ON [<dbUser,varchar,dbo>].[vw_subtext_MembershipUsers] ([PasswordQuestion]) TO [public]
GO
GRANT SELECT ON [<dbUser,varchar,dbo>].[vw_subtext_MembershipUsers] ([PasswordAnswer]) TO [public]
GO
GRANT SELECT ON [<dbUser,varchar,dbo>].[vw_subtext_MembershipUsers] ([IsApproved]) TO [public]
GO
GRANT SELECT ON [<dbUser,varchar,dbo>].[vw_subtext_MembershipUsers] ([IsLockedOut]) TO [public]
GO
GRANT SELECT ON [<dbUser,varchar,dbo>].[vw_subtext_MembershipUsers] ([CreateDate]) TO [public]
GO
GRANT SELECT ON [<dbUser,varchar,dbo>].[vw_subtext_MembershipUsers] ([LastLoginDate]) TO [public]
GO
GRANT SELECT ON [<dbUser,varchar,dbo>].[vw_subtext_MembershipUsers] ([LastPasswordChangedDate]) TO [public]
GO
GRANT SELECT ON [<dbUser,varchar,dbo>].[vw_subtext_MembershipUsers] ([LastLockoutDate]) TO [public]
GO
GRANT SELECT ON [<dbUser,varchar,dbo>].[vw_subtext_MembershipUsers] ([FailedPasswordAttemptCount]) TO [public]
GO
GRANT SELECT ON [<dbUser,varchar,dbo>].[vw_subtext_MembershipUsers] ([FailedPasswordAttemptWindowStart]) TO [public]
GO
GRANT SELECT ON [<dbUser,varchar,dbo>].[vw_subtext_MembershipUsers] ([FailedPasswordAnswerAttemptCount]) TO [public]
GO
GRANT SELECT ON [<dbUser,varchar,dbo>].[vw_subtext_MembershipUsers] ([FailedPasswordAnswerAttemptWindowStart]) TO [public]
GO
GRANT SELECT ON [<dbUser,varchar,dbo>].[vw_subtext_MembershipUsers] ([Comment]) TO [public]
GO
GRANT SELECT ON [<dbUser,varchar,dbo>].[vw_subtext_MembershipUsers] ([ApplicationId]) TO [public]
GO
GRANT SELECT ON [<dbUser,varchar,dbo>].[vw_subtext_MembershipUsers] ([UserName]) TO [public]
GO
GRANT SELECT ON [<dbUser,varchar,dbo>].[vw_subtext_MembershipUsers] ([MobileAlias]) TO [public]
GO
GRANT SELECT ON [<dbUser,varchar,dbo>].[vw_subtext_MembershipUsers] ([IsAnonymous]) TO [public]
GO
GRANT SELECT ON [<dbUser,varchar,dbo>].[vw_subtext_MembershipUsers] ([LastActivityDate]) TO [public]
GO
GRANT SELECT ON [<dbUser,varchar,dbo>].[vw_subtext_Profiles] TO [public]
GO
GRANT SELECT ON [<dbUser,varchar,dbo>].[vw_subtext_Profiles] ([UserId]) TO [public]
GO
GRANT SELECT ON [<dbUser,varchar,dbo>].[vw_subtext_Profiles] ([LastUpdatedDate]) TO [public]
GO
GRANT SELECT ON [<dbUser,varchar,dbo>].[vw_subtext_Profiles] ([DataSize]) TO [public]
GO
GRANT SELECT ON [<dbUser,varchar,dbo>].[vw_subtext_Roles] TO [public]
GO
GRANT SELECT ON [<dbUser,varchar,dbo>].[vw_subtext_Roles] ([ApplicationId]) TO [public]
GO
GRANT SELECT ON [<dbUser,varchar,dbo>].[vw_subtext_Roles] ([RoleId]) TO [public]
GO
GRANT SELECT ON [<dbUser,varchar,dbo>].[vw_subtext_Roles] ([RoleName]) TO [public]
GO
GRANT SELECT ON [<dbUser,varchar,dbo>].[vw_subtext_Roles] ([LoweredRoleName]) TO [public]
GO
GRANT SELECT ON [<dbUser,varchar,dbo>].[vw_subtext_Roles] ([Description]) TO [public]
GO
GRANT SELECT ON [<dbUser,varchar,dbo>].[vw_subtext_UsersInRoles] TO [public]
GO
GRANT SELECT ON [<dbUser,varchar,dbo>].[vw_subtext_UsersInRoles] ([UserId]) TO [public]
GO
GRANT SELECT ON [<dbUser,varchar,dbo>].[vw_subtext_UsersInRoles] ([RoleId]) TO [public]
GO
GRANT SELECT ON [<dbUser,varchar,dbo>].[vw_subtext_WebPartState_Paths] TO [public]
GO
GRANT SELECT ON [<dbUser,varchar,dbo>].[vw_subtext_WebPartState_Paths] ([ApplicationId]) TO [public]
GO
GRANT SELECT ON [<dbUser,varchar,dbo>].[vw_subtext_WebPartState_Paths] ([PathId]) TO [public]
GO
GRANT SELECT ON [<dbUser,varchar,dbo>].[vw_subtext_WebPartState_Paths] ([Path]) TO [public]
GO
GRANT SELECT ON [<dbUser,varchar,dbo>].[vw_subtext_WebPartState_Paths] ([LoweredPath]) TO [public]
GO
GRANT SELECT ON [<dbUser,varchar,dbo>].[vw_subtext_WebPartState_Shared] TO [public]
GO
GRANT SELECT ON [<dbUser,varchar,dbo>].[vw_subtext_WebPartState_Shared] ([PathId]) TO [public]
GO
GRANT SELECT ON [<dbUser,varchar,dbo>].[vw_subtext_WebPartState_Shared] ([DataSize]) TO [public]
GO
GRANT SELECT ON [<dbUser,varchar,dbo>].[vw_subtext_WebPartState_Shared] ([LastUpdatedDate]) TO [public]
GO
GRANT SELECT ON [<dbUser,varchar,dbo>].[vw_subtext_WebPartState_User] TO [public]
GO
GRANT SELECT ON [<dbUser,varchar,dbo>].[vw_subtext_WebPartState_User] ([PathId]) TO [public]
GO
GRANT SELECT ON [<dbUser,varchar,dbo>].[vw_subtext_WebPartState_User] ([UserId]) TO [public]
GO
GRANT SELECT ON [<dbUser,varchar,dbo>].[vw_subtext_WebPartState_User] ([DataSize]) TO [public]
GO
GRANT SELECT ON [<dbUser,varchar,dbo>].[vw_subtext_WebPartState_User] ([LastUpdatedDate]) TO [public]
GO
GRANT SELECT ON [<dbUser,varchar,dbo>].[vw_subtext_Applications] TO [public]
GO
GRANT SELECT ON [<dbUser,varchar,dbo>].[vw_subtext_Applications] TO [public]
GO
GRANT SELECT ON [<dbUser,varchar,dbo>].[vw_subtext_Applications] TO [public]
GO
GRANT SELECT ON [<dbUser,varchar,dbo>].[vw_subtext_Applications] TO [public]
GO
GRANT SELECT ON [<dbUser,varchar,dbo>].[vw_subtext_Applications] ([ApplicationName]) TO [public]
GO
GRANT SELECT ON [<dbUser,varchar,dbo>].[vw_subtext_Applications] ([ApplicationName]) TO [public]
GO
GRANT SELECT ON [<dbUser,varchar,dbo>].[vw_subtext_Applications] ([ApplicationName]) TO [public]
GO
GRANT SELECT ON [<dbUser,varchar,dbo>].[vw_subtext_Applications] ([ApplicationName]) TO [public]
GO
GRANT SELECT ON [<dbUser,varchar,dbo>].[vw_subtext_Applications] ([LoweredApplicationName]) TO [public]
GO
GRANT SELECT ON [<dbUser,varchar,dbo>].[vw_subtext_Applications] ([LoweredApplicationName]) TO [public]
GO
GRANT SELECT ON [<dbUser,varchar,dbo>].[vw_subtext_Applications] ([LoweredApplicationName]) TO [public]
GO
GRANT SELECT ON [<dbUser,varchar,dbo>].[vw_subtext_Applications] ([LoweredApplicationName]) TO [public]
GO
GRANT SELECT ON [<dbUser,varchar,dbo>].[vw_subtext_Applications] ([ApplicationId]) TO [public]
GO
GRANT SELECT ON [<dbUser,varchar,dbo>].[vw_subtext_Applications] ([ApplicationId]) TO [public]
GO
GRANT SELECT ON [<dbUser,varchar,dbo>].[vw_subtext_Applications] ([ApplicationId]) TO [public]
GO
GRANT SELECT ON [<dbUser,varchar,dbo>].[vw_subtext_Applications] ([ApplicationId]) TO [public]
GO
GRANT SELECT ON [<dbUser,varchar,dbo>].[vw_subtext_Applications] ([Description]) TO [public]
GO
GRANT SELECT ON [<dbUser,varchar,dbo>].[vw_subtext_Applications] ([Description]) TO [public]
GO
GRANT SELECT ON [<dbUser,varchar,dbo>].[vw_subtext_Applications] ([Description]) TO [public]
GO
GRANT SELECT ON [<dbUser,varchar,dbo>].[vw_subtext_Applications] ([Description]) TO [public]
GO
GRANT SELECT ON [<dbUser,varchar,dbo>].[vw_subtext_Users] TO [public]
GO
GRANT SELECT ON [<dbUser,varchar,dbo>].[vw_subtext_Users] TO [public]
GO
GRANT SELECT ON [<dbUser,varchar,dbo>].[vw_subtext_Users] TO [public]
GO
GRANT SELECT ON [<dbUser,varchar,dbo>].[vw_subtext_Users] TO [public]
GO
GRANT SELECT ON [<dbUser,varchar,dbo>].[vw_subtext_Users] ([ApplicationId]) TO [public]
GO
GRANT SELECT ON [<dbUser,varchar,dbo>].[vw_subtext_Users] ([ApplicationId]) TO [public]
GO
GRANT SELECT ON [<dbUser,varchar,dbo>].[vw_subtext_Users] ([ApplicationId]) TO [public]
GO
GRANT SELECT ON [<dbUser,varchar,dbo>].[vw_subtext_Users] ([ApplicationId]) TO [public]
GO
GRANT SELECT ON [<dbUser,varchar,dbo>].[vw_subtext_Users] ([UserId]) TO [public]
GO
GRANT SELECT ON [<dbUser,varchar,dbo>].[vw_subtext_Users] ([UserId]) TO [public]
GO
GRANT SELECT ON [<dbUser,varchar,dbo>].[vw_subtext_Users] ([UserId]) TO [public]
GO
GRANT SELECT ON [<dbUser,varchar,dbo>].[vw_subtext_Users] ([UserId]) TO [public]
GO
GRANT SELECT ON [<dbUser,varchar,dbo>].[vw_subtext_Users] ([UserName]) TO [public]
GO
GRANT SELECT ON [<dbUser,varchar,dbo>].[vw_subtext_Users] ([UserName]) TO [public]
GO
GRANT SELECT ON [<dbUser,varchar,dbo>].[vw_subtext_Users] ([UserName]) TO [public]
GO
GRANT SELECT ON [<dbUser,varchar,dbo>].[vw_subtext_Users] ([UserName]) TO [public]
GO
GRANT SELECT ON [<dbUser,varchar,dbo>].[vw_subtext_Users] ([LoweredUserName]) TO [public]
GO
GRANT SELECT ON [<dbUser,varchar,dbo>].[vw_subtext_Users] ([LoweredUserName]) TO [public]
GO
GRANT SELECT ON [<dbUser,varchar,dbo>].[vw_subtext_Users] ([LoweredUserName]) TO [public]
GO
GRANT SELECT ON [<dbUser,varchar,dbo>].[vw_subtext_Users] ([LoweredUserName]) TO [public]
GO
GRANT SELECT ON [<dbUser,varchar,dbo>].[vw_subtext_Users] ([MobileAlias]) TO [public]
GO
GRANT SELECT ON [<dbUser,varchar,dbo>].[vw_subtext_Users] ([MobileAlias]) TO [public]
GO
GRANT SELECT ON [<dbUser,varchar,dbo>].[vw_subtext_Users] ([MobileAlias]) TO [public]
GO
GRANT SELECT ON [<dbUser,varchar,dbo>].[vw_subtext_Users] ([MobileAlias]) TO [public]
GO
GRANT SELECT ON [<dbUser,varchar,dbo>].[vw_subtext_Users] ([IsAnonymous]) TO [public]
GO
GRANT SELECT ON [<dbUser,varchar,dbo>].[vw_subtext_Users] ([IsAnonymous]) TO [public]
GO
GRANT SELECT ON [<dbUser,varchar,dbo>].[vw_subtext_Users] ([IsAnonymous]) TO [public]
GO
GRANT SELECT ON [<dbUser,varchar,dbo>].[vw_subtext_Users] ([IsAnonymous]) TO [public]
GO
GRANT SELECT ON [<dbUser,varchar,dbo>].[vw_subtext_Users] ([LastActivityDate]) TO [public]
GO
GRANT SELECT ON [<dbUser,varchar,dbo>].[vw_subtext_Users] ([LastActivityDate]) TO [public]
GO
GRANT SELECT ON [<dbUser,varchar,dbo>].[vw_subtext_Users] ([LastActivityDate]) TO [public]
GO
GRANT SELECT ON [<dbUser,varchar,dbo>].[vw_subtext_Users] ([LastActivityDate]) TO [public]
GO


SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

CREATE PROC [<dbUser,varchar,dbo>].[subtext_UTILITY_AddBlog]
(
	@Title nvarchar(100), 
	@UserName nvarchar(256),
	@Password nvarchar(128),
	@PasswordSalt nvarchar(128),
	@Email nvarchar(256) = NULL,
	@Host nvarchar(50),
	@Subfolder nvarchar(50),
	@CurrentTimeUtc DateTime
)

AS

IF NOT EXISTS(SELECT * FROM [<dbUser,varchar,dbo>].[subtext_config] WHERE Host = @Host AND Subfolder = @Subfolder)
BEGIN
	/* Create the Membership Application for this blog */
	DECLARE @ApplicationId UNIQUEIDENTIFIER
	DECLARE @ApplicationName nvarchar(256)
	SET @ApplicationName = @Host + '/' + @Subfolder

	EXEC subtext_Applications_CreateApplication @ApplicationName, @ApplicationId OUTPUT
	
	DECLARE @UserId UNIQUEIDENTIFIER
	DECLARE @CreateDate DateTime
	SELECT @CreateDate = getdate()
	
	/* Create the Owner of this blog */
	EXEC subtext_Membership_CreateUser 
		@ApplicationName
		, @UserName
		, @Password
		, @PasswordSalt
		, @Email
		, NULL	-- PasswordQuestion
		, NULL	-- PasswordAnswer
		, 1		-- IsApproved
		, @CurrentTimeUtc
		, @CreateDate
		, 0		-- UniqueEmail
		, 1		-- PasswordFormat
		, @UserId OUTPUT

	/* Add User to Administrators */
	

	/* Create this blog */
	INSERT subtext_Config  
	(
		LastUpdated
		, ApplicationId
		, OwnerId
		, Title
		, SubTitle
		, Skin
		, SkinCssFile
		, Subfolder
		, Host
		, TimeZone
		, [Language]
		, ItemCount
		, Flag
	)
	Values             
	(
		getdate()
		, @ApplicationId
		, @UserId
		, @Title
		, 'Another Subtext Powered Blog'
		, 'RedBook'
		, 'blue.css'
		, @Subfolder
		, @Host
		, -1188006249
		,'en-US'
		, 10
		, 55 -- Flag
	)

	DECLARE @newBlogId int
	SET @newBlogId = SCOPE_IDENTITY()

	EXEC subtext_GetBlogById @newBlogId
END

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

GRANT  EXECUTE  ON [<dbUser,varchar,dbo>].[subtext_UTILITY_AddBlog]  TO [public]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

CREATE PROC [<dbUser,varchar,dbo>].[subtext_CreateHost]
(
	@UserName nvarchar(256),
	@Password nvarchar(128),
	@PasswordSalt nvarchar(128),
	@Email nvarchar(256) = NULL,
	@CurrentTimeUtc DateTime
)

AS

IF NOT EXISTS(SELECT * FROM [<dbUser,varchar,dbo>].[subtext_Host])
BEGIN
	/* Create the Membership Application for this blog */
	DECLARE @ApplicationId UNIQUEIDENTIFIER
	
	SELECT @ApplicationId FROM [<dbUser,varchar,dbo>].[subtext_Applications] WHERE ApplicationName = '/'
	IF(@ApplicationID IS NULL)
	BEGIN
		EXEC subtext_Applications_CreateApplication '/', @ApplicationId OUTPUT
	END
	
	DECLARE @UserId UNIQUEIDENTIFIER
	DECLARE @CreateDate DateTime
	SELECT @CreateDate = getdate()

	/* Create the Host Admin Owner */
	EXEC subtext_Membership_CreateUser 
		'/'
		, @UserName
		, @Password
		, @PasswordSalt
		, @Email
		, NULL	-- PasswordQuestion
		, NULL	-- PasswordAnswer
		, 1		-- IsApproved
		, @CurrentTimeUtc
		, @CreateDate
		, 0		-- UniqueEmail
		, 1		-- PasswordFormat
		, @UserId OUTPUT

	/* Create the host */
	INSERT subtext_Host
	(
		ApplicationId
		, OwnerId
		, DateCreated
	)
	Values             
	(
		@ApplicationId
		, @UserId
		, @CreateDate
	)
	
	DECLARE @HostId int
	SELECT @HostId = SCOPE_IDENTITY()
	
	EXEC subtext_GetHost
END

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

GRANT  EXECUTE  ON [<dbUser,varchar,dbo>].[subtext_CreateHost]  TO [public]
GO