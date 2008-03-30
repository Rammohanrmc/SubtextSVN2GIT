REM Recreates a local Subtext Database. Used for testing installation.

::SET VARIABLES
SET DBNAME=%1%
IF "%DBNAME%" == "" SET DBNAME=SubtextData_1.9

TITLE Creating %DBNAME% Database

::PUT DATABASE IN SINGLE USER MODE TO ALLOW DROPPING IF IT EXISTS
OSQL -E -d master -Q "IF EXISTS (SELECT * FROM   master..sysdatabases WHERE  name = N'%DBNAME%') ALTER DATABASE [%DBNAME%] SET SINGLE_USER WITH ROLLBACK IMMEDIATE"

::DROP DATABASE IF IT EXISTS
OSQL -E -d master -Q "IF EXISTS (SELECT * FROM   master..sysdatabases WHERE  name = N'%DBNAME%') DROP DATABASE [%DBNAME%]"

::CREATE DATABASE
OSQL -E -d master -Q "CREATE DATABASE [%DBNAME%]"

::GRANT PERMISSION TO ASPNET USER
OSQL -E -d %DBNAME% -Q "sp_grantdbaccess '%COMPUTERNAME%\ASPNET'"
OSQL -E -d %DBNAME% -Q "sp_addrolemember 'db_owner', '%COMPUTERNAME%\ASPNET'"

REM IISRESET /RESTART
REM NET START W3SVC

PAUSE