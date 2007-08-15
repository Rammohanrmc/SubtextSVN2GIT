/* 
    WARNING: This SCRIPT USES SQL TEMPLATE PARAMETERS.
	Be sure to hit CTRL+SHIFT+M in Query Analyzer if running manually.
*/

/* add some missing Foreign Keys */

IF NOT EXISTS
(
	SELECT * FROM [INFORMATION_SCHEMA].[REFERENTIAL_CONSTRAINTS]
	WHERE CONSTRAINT_NAME = 'FK_subtext_EntryTag_subtext_Config'
	AND CONSTRAINT_SCHEMA = '<dbUser,varchar,dbo>'
)
BEGIN
	ALTER TABLE [<dbUser,varchar,dbo>].[subtext_EntryTag] WITH NOCHECK
	ADD CONSTRAINT [FK_subtext_EntryTag_subtext_Config] FOREIGN KEY
	( [BlogId] ) REFERENCES <dbUser,varchar,dbo>.[subtext_Config]
	( [BlogId] )
END
GO

IF NOT EXISTS
(
	SELECT * FROM [INFORMATION_SCHEMA].[REFERENTIAL_CONSTRAINTS]
	WHERE CONSTRAINT_NAME = 'FK_subtext_Tag_subtext_Config'
	AND CONSTRAINT_SCHEMA = '<dbUser,varchar,dbo>'
)
BEGIN
	ALTER TABLE [<dbUser,varchar,dbo>].[subtext_Tag] WITH NOCHECK
	ADD CONSTRAINT [FK_subtext_Tag_subtext_Config] FOREIGN KEY
	( [BlogId] ) REFERENCES <dbUser,varchar,dbo>.[subtext_Config]
	( [BlogId] )
END
GO

IF NOT EXISTS
(
	SELECT * FROM [INFORMATION_SCHEMA].[REFERENTIAL_CONSTRAINTS]
	WHERE CONSTRAINT_NAME = 'FK_subtext_EntryViewCount_subtext_Content'
	AND CONSTRAINT_SCHEMA = '<dbUser,varchar,dbo>'
)
BEGIN
	ALTER TABLE [<dbUser,varchar,dbo>].[subtext_EntryViewCount] WITH NOCHECK
	ADD CONSTRAINT [FK_subtext_EntryViewCount_subtext_Content] FOREIGN KEY
	( [EntryId] ) REFERENCES <dbUser,varchar,dbo>.[subtext_Content]
	( [ID] )
END
GO 

IF NOT EXISTS 
(
    SELECT * FROM [INFORMATION_SCHEMA].[COLUMNS] 
    WHERE   TABLE_NAME = 'subtext_Config' 
    AND TABLE_SCHEMA = '<dbUser,varchar,dbo>'
    AND COLUMN_NAME = 'CustomMetaTags'
)
BEGIN
	ALTER TABLE [<dbUser,varchar,dbo>].[subtext_Config]
		ADD [CustomMetaTags] [ntext] COLLATE SQL_Latin1_General_CP1_CI_AS NULL
END
GO


IF NOT EXISTS 
(
    SELECT * FROM [INFORMATION_SCHEMA].[COLUMNS] 
    WHERE   TABLE_NAME = 'subtext_Config' 
    AND TABLE_SCHEMA = '<dbUser,varchar,dbo>'
    AND COLUMN_NAME = 'TrackingCode'
)
BEGIN
	ALTER TABLE [<dbUser,varchar,dbo>].[subtext_Config]
		ADD [TrackingCode] [ntext] COLLATE SQL_Latin1_General_CP1_CI_AS NULL
END
GO
