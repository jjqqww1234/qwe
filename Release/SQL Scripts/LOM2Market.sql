-- SQL Manager 2008 Lite for SQL Server 3.2.0.2
-- ---------------------------------------
-- Host      : MMORPG-NETWORK\SQLEXPRESS
-- Database  : LOM2Market
-- Version   : Microsoft SQL Server  9.00.1399.06


CREATE DATABASE [LOM2Market]
ON PRIMARY
  ( NAME = [MarketDB],
    FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL10.SQLEXPRESS\MSSQL\DATA\MarketDB.mdf',
    SIZE = 3 MB,
    MAXSIZE = UNLIMITED,
    FILEGROWTH = 1 MB )
LOG ON
  ( NAME = [MarketDB_log],
    FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL10.SQLEXPRESS\MSSQL\DATA\MarketDB_log.ldf',
    SIZE = 1 MB,
    MAXSIZE = UNLIMITED,
    FILEGROWTH = 10 % )
COLLATE Korean_Wansung_CI_AS
GO

USE [LOM2Market]
GO

--
-- Definition for stored procedure GABOARD_LOAD : 
--
GO
CREATE PROCEDURE [dbo].[GABOARD_LOAD]  
	@gname nchar(25),
	@nKind int
AS
	Select  * from TBL_GABOARD where FLD_GUILDNAME = @Gname and FLD_KIND = @nKind;
GO

--//**************************************//
--//   GABOARD_DEL ????              //
--//**************************************//
CREATE PROCEDURE [dbo].[GABOARD_DEL] 
	@gname nchar(25),
	@ORGNUM int,
	@SrcNum1 int,
	@SrcNum2 int,
	@SrcNum3 int
AS
	Delete from TBL_GABOARD where FLD_GUILDNAME = @Gname and 
			FLD_ORGNUM = @ORGNum and 
			FLD_SRCNUM1= @SrcNum1 and
			FLD_SRCNUM2= @SrcNum2 and
			FLD_SRCNUM3= @SrcNum3;
GO

--
-- Definition for table TBL_ITEMMARKET : 
--

CREATE TABLE [dbo].[TBL_ITEMMARKET] (
  [FLD_MARKETNAME] nchar(30) COLLATE Korean_Wansung_CI_AS NULL,
  [FLD_SELLOK] smallint NULL,
  [FLD_ITEMTYPE] int NULL,
  [FLD_ITEMSET] int NULL,
  [FLD_ITEMNAME] nchar(25) COLLATE Korean_Wansung_CI_AS NULL,
  [FLD_SELLWHO] nchar(25) COLLATE Korean_Wansung_CI_AS NULL,
  [FLD_SELLPRICE] int NULL,
  [FLD_SELLDATE] datetime NULL,
  [FLD_MAKEINDEX] int NULL,
  [FLD_INDEX] int NULL,
  [FLD_DURA] int NULL,
  [FLD_DURAMAX] int NULL,
  [FLD_DESC0] int NULL,
  [FLD_DESC1] int NULL,
  [FLD_DESC2] int NULL,
  [FLD_DESC3] int NULL,
  [FLD_DESC4] int NULL,
  [FLD_DESC5] int NULL,
  [FLD_DESC6] int NULL,
  [FLD_DESC7] int NULL,
  [FLD_DESC8] int NULL,
  [FLD_DESC9] int NULL,
  [FLD_DESC10] int NULL,
  [FLD_DESC11] int NULL,
  [FLD_DESC12] int NULL,
  [FLD_DESC13] int NULL,
  [FLD_COLORR] int NULL,
  [FLD_COLORG] int NULL,
  [FLD_COLORB] int NULL,
  [FLD_PREFIX] nchar(13) COLLATE Korean_Wansung_CI_AS NULL
)
ON [PRIMARY]
GO

--
-- Definition for stored procedure UM_READYTOSELL_NEW : 
--
GO
CREATE PROCEDURE [dbo].[UM_READYTOSELL_NEW]
	@MakeName nChar(30),
	@SellWho nChar(25)
AS
	Select * from TBL_ITEMMARKET where FLD_MARKETNAME = @MakeName and FLD_SELLWHO=@SellWho ;
GO

--
-- Definition for stored procedure UM_LOAD_USERNAME : 
--
GO
CREATE PROCEDURE [dbo].[UM_LOAD_USERNAME]
	@MakeName nChar(30),
	@SellWho nChar(25)
AS
	Select * from TBL_ITEMMARKET where FLD_MARKETNAME = @MakeName and FLD_SELLWHO=@SellWho;
GO

--
-- Definition for stored procedure UM_LOAD_ITEMTYPE : 
--
GO
CREATE PROCEDURE [dbo].[UM_LOAD_ITEMTYPE]
	@MakeName nChar(30),
	@ItemType int
AS
	Select * from TBL_ITEMMARKET where FLD_MARKETNAME = @MakeName and FLD_ITEMTYPE=@ItemType;
GO

--
-- Definition for stored procedure UM_LOAD_ITEMSET : 
--
GO
CREATE PROCEDURE [dbo].[UM_LOAD_ITEMSET]
	@MakeName nChar(30),
	@ItemSet int
AS
	Select * from TBL_ITEMMARKET where FLD_MARKETNAME = @MakeName and FLD_ITEMSET=@ItemSet;
GO

--
-- Definition for stored procedure UM_LOAD_ITEMNAME : 
--
GO
CREATE PROCEDURE [dbo].[UM_LOAD_ITEMNAME]
	@MakeName nChar(30),
	@ItemName nChar(25)
AS
	Select * from TBL_ITEMMARKET where FLD_MARKETNAME = @MakeName and FLD_ITEMNAME=@ItemName;
GO

--
-- Definition for stored procedure UM_LOAD_INDEX : 
--
GO
CREATE PROCEDURE [dbo].[UM_LOAD_INDEX]
	@MakeName nChar(30),
	@Sellwho nChar(25),
	@ItemIndex int,
	@CheckType int,
        @ChangeType int
AS
	Select * from TBL_ITEMMARKET 
                where FLD_MARKETNAME = @MakeName and 
                      FLD_SELLWHO=@Sellwho and  
			FLD_MAKEINDEX = @ItemIndex and
			FLD_ITEMTYPE = @CheckType and 
			FLD_ITEMSET = @ChangeType
GO

--
-- Definition for stored procedure UM_CHECK_MAKEINDEX : 
--
GO
CREATE PROCEDURE [dbo].[UM_CHECK_MAKEINDEX]
	@MakeName nChar(30),
	@Sellwho nChar(25),
	@ItemIndex int,
	@CheckType int,
        @ChangeType int
AS
	Select * from TBL_ITEMMARKET 
                where FLD_MARKETNAME = @MakeName and 
                      FLD_SELLWHO=@Sellwho and  
			FLD_MAKEINDEX = @ItemIndex and
			FLD_ITEMTYPE = @CheckType and 
			FLD_ITEMSET = @ChangeType
GO

--
-- Definition for stored procedure UM_CHECK_INDEX_BUY : 
--
GO
CREATE PROCEDURE [dbo].[UM_CHECK_INDEX_BUY]
	@MakeName nChar(30),
	@Sellwho nChar(25),
	@ItemIndex int,
	@CheckType int,
        @ChangeType int
AS
	Select * from TBL_ITEMMARKET 
                where FLD_MARKETNAME = @MakeName and 
                      FLD_SELLWHO=@Sellwho and  
			FLD_MAKEINDEX = @ItemIndex and
			FLD_ITEMTYPE = @CheckType and 
			FLD_ITEMSET = @ChangeType
GO

--
-- Definition for stored procedure UM_CHECK_INDEX : 
--
GO
CREATE PROCEDURE [dbo].[UM_CHECK_INDEX]
	@MakeName nChar(30),
	@Sellwho nChar(25),
	@ItemIndex int,
	@CheckType int,
        @ChangeType int
AS
	Select * from TBL_ITEMMARKET 
                where FLD_MARKETNAME = @MakeName and 
                      FLD_SELLWHO=@Sellwho and  
			FLD_MAKEINDEX = @ItemIndex and
			FLD_ITEMTYPE = @CheckType and 
			FLD_ITEMSET = @ChangeType
GO

--
-- Definition for table TBL_GABOARD : 
--

CREATE TABLE [dbo].[TBL_GABOARD] (
  [FLD_AGITNUM] int NULL,
  [FLD_GUILDNAME] nchar(25) COLLATE Korean_Wansung_CI_AS NULL,
  [FLD_ORGNUM] int NULL,
  [FLD_SRCNUM1] int NULL,
  [FLD_SRCNUM2] int NULL,
  [FLD_SRCNUM3] int NULL,
  [FLD_KIND] int NULL,
  [FLD_USERNAME] nchar(25) COLLATE Korean_Wansung_CI_AS NULL,
  [FLD_CONTENT] nchar(100) COLLATE Korean_Wansung_CI_AS NULL
)
ON [PRIMARY]
GO