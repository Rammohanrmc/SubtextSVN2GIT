/* Shrink the Message Column to make room for the Exception Column */
ALTER TABLE [<dbUser,varchar,dbo>].[subtext_Log] 
ALTER COLUMN [Message] NVARCHAR(255)
GO

/* Expand the Exception Column to fit more details */
ALTER TABLE [<dbUser,varchar,dbo>].[subtext_Log] 
ALTER COLUMN [Exception] NVARCHAR(2745)
GO

/* Add the Url column to the subtext_Log table if it doesn't exist */
IF NOT EXISTS 
	(
		SELECT	* FROM [information_schema].[columns] 
		WHERE	table_name = 'subtext_Log' 
		AND		table_schema = '<dbUser,varchar,dbo>'
		AND		column_name = 'Url'
	)
	/* Add an URL column so we can see which URL caused the problem */
	ALTER TABLE [<dbUser,varchar,dbo>].[subtext_Log] 
	ADD [Url] VARCHAR(255) NULL
GO

/*
	Going to add a default value constraint (0) to column FeedBackCount 
	in table subtext_Content 
*/
UPDATE [<dbUser,varchar,dbo>].[subtext_Content] 
SET [FeedBackCount] = 0
WHERE [FeedBackCount] IS NULL
GO

IF (SELECT COLUMN_DEFAULT FROM [information_schema].[columns] 
		WHERE	table_name = 'subtext_Content'
		AND		table_schema = 'dbo'
		AND		column_name = 'FeedBackCount') IS NULL
BEGIN
	ALTER TABLE [<dbUser,varchar,dbo>].[subtext_Content]  ADD CONSTRAINT
		DF_subtext_Content_FeedBackCount DEFAULT 0 FOR FeedBackCount
END
GO

ALTER TABLE [<dbUser,varchar,dbo>].[subtext_Content]  
	ALTER COLUMN FeedBackCount int NOT NULL
GO

/*
	Going to add a default value constraint (1) to column BlogGroup 
	in table subtext_Config 
*/
UPDATE [<dbUser,varchar,dbo>].[subtext_Config] 
SET [BlogGroup] = 1
WHERE [BlogGroup] IS NULL
GO

IF (SELECT COLUMN_DEFAULT FROM [information_schema].[columns] 
		WHERE	table_name = 'subtext_Config'
		AND		table_schema = 'dbo'
		AND		column_name = 'BlogGroup') IS NULL
BEGIN
	ALTER TABLE [<dbUser,varchar,dbo>].[subtext_Config]  ADD CONSTRAINT
		DF_subtext_Config_BlogGroup DEFAULT 1 FOR BlogGroup
END
GO

ALTER TABLE [<dbUser,varchar,dbo>].[subtext_Config]
	ALTER COLUMN BlogGroup int NOT NULL
GO