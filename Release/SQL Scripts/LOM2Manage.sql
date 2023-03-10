-- SQL Manager 2008 Lite for SQL Server 3.2.0.2
-- ---------------------------------------
-- Host      : MMORPG-NETWORK\SQLEXPRESS
-- Database  : LOM2Manage
-- Version   : Microsoft SQL Server  9.00.1399.06


CREATE DATABASE [LOM2Manage]
ON PRIMARY
  ( NAME = [ManageDB_Data],
    FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL10.SQLEXPRESS\MSSQL\DATA\LOM2Manage.mdf',
    SIZE = 3 MB,
    MAXSIZE = UNLIMITED,
    FILEGROWTH = 10 % )
LOG ON
  ( NAME = [ManageDB_Log],
    FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL10.SQLEXPRESS\MSSQL\DATA\LOM2Manage_log.ldf',
    SIZE = 1 MB,
    MAXSIZE = UNLIMITED,
    FILEGROWTH = 10 % )
COLLATE Korean_Wansung_CI_AS
GO

USE [LOM2Manage]
GO

--
-- Definition for table MR3_PCRoomStatusTable : 
--

CREATE TABLE [dbo].[MR3_PCRoomStatusTable] (
  [PCRoomStatus_PCRoomIndex] int NOT NULL,
  [PCRoomStatus_CurrentPoint] int NULL,
  [PCRoomStatus_TotalPoint] int NULL,
  [PCRoomStatus_AccountType] tinyint NULL,
  [PCRoomStatus_RemainedDay] datetime NULL,
  [PCRoomStatus_M2RemainedDay] datetime NULL,
  [PCRoomStatus_M3RemainedDay] datetime NULL,
  [PCRoomStatus_LastLoginDate] datetime NULL,
  [PCRoomStatus_LastLogoutDate] datetime NULL,
  [PCRoomStatus_RegDate] datetime NULL,
  [PCRoomStatus_RemainedTime] int NULL,
  [PCRoomStatus_M2RemainedTime] int NULL,
  [PCRoomStatus_M3RemainedTime] int NULL,
  [PCRoomStatus_Staff] nvarchar(20) COLLATE Korean_Wansung_CI_AS NULL,
  [PCRoomStatus_FromDate] datetime NULL,
  [PCRoomStatus_M2FromDate] datetime NULL,
  [PCRoomStatus_M3FromDate] datetime NULL,
  [PCRoomStatus_IPCount] int NULL,
  [PCRoomStatus_UsingIPCount] int NULL,
  [PCRoomStatus_Remarks] nvarchar(100) COLLATE Korean_Wansung_CI_AS NULL
)
ON [PRIMARY]
GO

--
-- Definition for table MR3_IPTable : 
--

CREATE TABLE [dbo].[MR3_IPTable] (
  [IP_Address] nvarchar(16) COLLATE Korean_Wansung_CI_AS NOT NULL,
  [IP_PCRoomIndex] int NOT NULL,
  [IP_TimeStamp] datetime NULL
)
ON [PRIMARY]
GO

