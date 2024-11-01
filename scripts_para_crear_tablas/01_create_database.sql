-- Connect to the 'master' database to run this snippet
USE master
GO

-- Drop the database if it exists
IF EXISTS (
    SELECT 1
    FROM sys.databases
    WHERE [name] = N'PermitSystem'
)
BEGIN
    DROP DATABASE PermitSystem;
END
GO

-- Create the new database if it does not exist
IF NOT EXISTS (
    SELECT 1
    FROM sys.databases
    WHERE [name] = N'PermitSystem'
)
BEGIN
    CREATE DATABASE PermitSystem;
END
GO


USE PermitSystem;
GO