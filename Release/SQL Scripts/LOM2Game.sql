-- SQL Manager 2008 Lite for SQL Server 3.2.0.2
-- ---------------------------------------
-- Host      : MMORPG-NETWORK\SQLEXPRESS
-- Database  : LOM2Game
-- Version   : Microsoft SQL Server  9.00.1399.06


CREATE DATABASE [LOM2Game]
ON PRIMARY
  ( NAME = [LOM2Game_Data],
    FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL10.SQLEXPRESS\MSSQL\DATA\LOM2Game_Data.MDF',
    SIZE = 3 MB,
    MAXSIZE = UNLIMITED,
    FILEGROWTH = 1 MB )
LOG ON
  ( NAME = [LOM2Game_Log],
    FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL10.SQLEXPRESS\MSSQL\DATA\LOM2Game_Log.LDF',
    SIZE = 5 MB,
    MAXSIZE = UNLIMITED,
    FILEGROWTH = 1 MB )
COLLATE Korean_Wansung_CS_AI
GO

USE [LOM2Game]
GO

--
-- Definition for table TBL_TAG_REJECT : 
--

CREATE TABLE [dbo].[TBL_TAG_REJECT] (
  [FLD_CHARACTER] nvarchar(60) COLLATE Korean_Wansung_CI_AS NOT NULL,
  [FLD_REJECTER] nvarchar(60) COLLATE Korean_Wansung_CI_AS NOT NULL
)
ON [PRIMARY]
GO

--
-- Definition for stored procedure SP_TAG_REJECTLIST : 
--
GO
CREATE PROCEDURE [dbo].SP_TAG_REJECTLIST
	( @szReciever nvarchar(30) )
AS
	IF (@szReciever = NULL)
	BEGIN
	
		RETURN 2 
	END

	SELECT FLD_REJECTER  FROM TBL_TAG_REJECT WHERE FLD_CHARACTER = @szReciever

RETURN 1
GO

--
-- Definition for stored procedure SP_TAG_REJECTDELETE : 
--
GO
CREATE PROCEDURE [dbo].SP_TAG_REJECTDELETE
	( @szReciever nvarchar(30) ,
	  @szRejecter nvarchar(30)
	)
AS
	IF (@szReciever = NULL) or ( @szRejecter = NULL )
	BEGIN
		SELECT 2[FLD_RETURN]
		RETURN 2 
	END

	DELETE TBL_TAG_REJECT WHERE FLD_CHARACTER=@szReciever AND FLD_REJECTER = @szRejecter

SELECT 1[FLD_RETURN]
RETURN 1
GO

--
-- Definition for table TBL_TAG : 
--

CREATE TABLE [dbo].[TBL_TAG] (
  [FLD_CHARACTER] nvarchar(60) COLLATE Korean_Wansung_CI_AS NOT NULL,
  [FLD_DATE] nchar(24) COLLATE Korean_Wansung_CI_AS NULL,
  [FLD_STATE] smallint NULL,
  [FLD_SENDER] nvarchar(60) COLLATE Korean_Wansung_CI_AS NULL,
  [FLD_DESC] nvarchar(160) COLLATE Korean_Wansung_CI_AS NULL
)
ON [PRIMARY]
GO

--
-- Definition for stored procedure SP_TAG_SETSTATE : 
--
GO
CREATE PROCEDURE [dbo].SP_TAG_SETSTATE
	( @szReciever nvarchar(30) ,
	  @szDate nchar(12),
	  @nState int
	)
AS
	IF (@szReciever = NULL) or (@szDate = NULL ) 
	BEGIN
		SELECT 2[FLD_RETURN]
		RETURN 2 
	END

	UPDATE TBL_TAG SET 
		FLD_STATE = @nState
	WHERE FLD_CHARACTER=@szReciever AND FLD_DATE = @szDate

SELECT 1[FLD_RETURN]
RETURN 1
GO

--
-- Definition for stored procedure SP_TAG_NOTREADCOUNT : 
--
GO
CREATE PROCEDURE [dbo].SP_TAG_NOTREADCOUNT
	( @szReciever nvarchar(30) )
AS
	IF (@szReciever = NULL)
	BEGIN
	
		RETURN 2
	END

	SELECT COUNT(*) [FLD_COUNT] FROM TBL_TAG WHERE FLD_STATE = 0

RETURN 1
GO

--
-- Definition for stored procedure SP_TAG_LIST : 
--
GO
CREATE PROCEDURE [dbo].SP_TAG_LIST
	( @szReciever nvarchar(30) )
AS
	IF (@szReciever = NULL)
	BEGIN
	
		RETURN 2 
	END

	SELECT FLD_STATE,FLD_DATE,FLD_SENDER,FLD_DESC  FROM TBL_TAG WHERE FLD_CHARACTER = @szReciever order by FLD_STATE

RETURN 1
GO

--
-- Definition for stored procedure SP_TAG_DELETEALL : 
--
GO
CREATE PROCEDURE [dbo].SP_TAG_DELETEALL
	( @szReciever nvarchar(30) 
	)
AS
	IF (@szReciever = NULL)
	BEGIN
		SELECT 2[FLD_RETURN]
		RETURN 2 
	END

	DELETE TBL_TAG WHERE (FLD_CHARACTER = @szReciever) AND ( FLD_STATE !=  2 )

SELECT 1[FLD_RETURN]
RETURN 1
GO

--
-- Definition for stored procedure SP_TAG_DELETE : 
--
GO
CREATE PROCEDURE [dbo].SP_TAG_DELETE
	( @szReciever nvarchar(30) ,
	  @szDate nchar(12)
	)
AS
	IF (@szReciever = NULL) or (@szDate = NULL )
	BEGIN
		SELECT 2[FLD_RETURN]
		RETURN 2
	END

	DELETE TBL_TAG WHERE FLD_CHARACTER=@szReciever AND FLD_DATE = @szDate AND FLD_STATE != 2

SELECT 1[FLD_RETURN]
RETURN 1
GO

--
-- Definition for table TBL_SAVEDITEM : 
--

CREATE TABLE [dbo].[TBL_SAVEDITEM] (
  [FLD_CHARACTER] char(15) COLLATE Korean_Wansung_CI_AS NOT NULL,
  [FLD_TYPE] tinyint NULL,
  [FLD_MAKEINDEX] int NOT NULL,
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
  [FLD_COLORR] tinyint NULL,
  [FLD_COLORG] tinyint NULL,
  [FLD_COLORB] tinyint NULL,
  [FLD_NAMEPREFIX] char(30) COLLATE Korean_Wansung_CI_AS NULL
)
ON [PRIMARY]
GO

--
-- Definition for table TBL_RELATION : 
--

CREATE TABLE [dbo].[TBL_RELATION] (
  [FLD_CHARACTER] nchar(30) COLLATE Korean_Wansung_CI_AS NOT NULL,
  [FLD_OTHER] nchar(30) COLLATE Korean_Wansung_CI_AS NOT NULL,
  [FLD_STATE] int NULL,
  [FLD_MSG] int NULL,
  [FLD_DATE] datetime NULL
)
ON [PRIMARY]
GO

--
-- Definition for stored procedure SP_LM_EDIT : 
--
GO
CREATE PROCEDURE [dbo].SP_LM_EDIT
	( @szOwner nvarchar(30) ,
	  @szOther nvarchar(30),
      @nState int,
	  @szMsg int
	)
AS
	IF (@szOwner = NULL) or @szOther = NULL 
	BEGIN
		SELECT 2[FLD_RETURN]
		RETURN 2 
	END
	
	UPDATE TBL_RELATION SET
		FLD_STATE = @nState, FLD_MSG = @szMsg
	WHERE FLD_CHARACTER = @szOwner AND FLD_OTHER = @szOther

SELECT 1[FLD_RETURN]
RETURN 1
GO

--
-- Definition for stored procedure SP_LM_DELETE : 
--
GO
CREATE PROCEDURE [dbo].SP_LM_DELETE
	( @szOwner nvarchar(30) , 
	  @szOther nvarchar(30) )

AS
	IF ( @szOwner = NULL ) or ( @szOther = NULL )
	BEGIN
		SELECT 2[FLD_RETURN]
		RETURN 2
	END
	
	DELETE TBL_RELATION WHERE FLD_CHARACTER = @szOwner AND FLD_OTHER= @szOther

SELECT 1[FLD_RETURN]
RETURN 1
GO

--
-- Definition for table TBL_QUEST : 
--

CREATE TABLE [dbo].[TBL_QUEST] (
  [FLD_CHARACTER] char(15) COLLATE Korean_Wansung_CI_AS NOT NULL,
  [FLD_QUESTOPENINDEX] varchar(64) COLLATE Korean_Wansung_CI_AS NULL,
  [FLD_QUESTFININDEX] varchar(64) COLLATE Korean_Wansung_CI_AS NULL,
  [FLD_QUEST] varchar(256) COLLATE Korean_Wansung_CI_AS NULL
)
ON [PRIMARY]
GO

--
-- Definition for table TBL_MAGIC : 
--

CREATE TABLE [dbo].[TBL_MAGIC] (
  [FLD_CHARACTER] char(15) COLLATE Korean_Wansung_CI_AS NOT NULL,
  [FLD_MAGICID] int NOT NULL,
  [FLD_POS] int NULL,
  [FLD_LEVEL] tinyint NULL,
  [FLD_KEY] tinyint NULL,
  [FLD_CURTRAIN] int NULL
)
ON [PRIMARY]
GO

--
-- Definition for table TBL_ITEM : 
--

CREATE TABLE [dbo].[TBL_ITEM] (
  [FLD_CHARACTER] char(15) COLLATE Korean_Wansung_CI_AS NOT NULL,
  [FLD_TYPE] tinyint NULL,
  [FLD_POS] int NULL,
  [FLD_MAKEINDEX] int NOT NULL,
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
  [FLD_COLORR] tinyint NULL,
  [FLD_COLORG] tinyint NULL,
  [FLD_COLORB] tinyint NULL,
  [FLD_NAMEPREFIX] char(30) COLLATE Korean_Wansung_CI_AS NULL
)
ON [PRIMARY]
GO

--
-- Definition for table TBL_FRIEND : 
--

CREATE TABLE [dbo].[TBL_FRIEND] (
  [FLD_CHARACTER] nvarchar(60) COLLATE Korean_Wansung_CI_AS NOT NULL,
  [FLD_FRIEND] nvarchar(60) COLLATE Korean_Wansung_CI_AS NOT NULL,
  [FLD_STATE] smallint NULL,
  [FLD_DESC] nvarchar(80) COLLATE Korean_Wansung_CI_AS NULL
)
ON [PRIMARY]
GO

--
-- Definition for stored procedure SP_FRIEND_SETDESC : 
--
GO
CREATE PROCEDURE [dbo].SP_FRIEND_SETDESC
	( @szOwner nvarchar(30) ,
	  @szFriend nvarchar(30),
	  @szDesc  nvarchar(40)
	)
AS
	IF (@szOwner = NULL) or @szFriend = NULL 
	BEGIN
		SELECT 2[FLD_RETURN]
		RETURN 2 
	END
	
	UPDATE TBL_FRIEND SET
		FLD_DESC = @szDESC
	WHERE FLD_CHARACTER = @szOwner AND FLD_FRIEND = @szFriend

SELECT 1[FLD_RETURN]
RETURN 1
GO

--
-- Definition for stored procedure SP_FRIEND_LIST : 
--
GO
CREATE PROCEDURE [dbo].SP_FRIEND_LIST
	( @szOwner nvarchar(30) )
AS
	IF (@szOwner = NULL)
	BEGIN
	
		RETURN 2 
	END

	SELECT FLD_FRIEND,FLD_STATE,FLD_DESC  FROM TBL_FRIEND WHERE FLD_CHARACTER = @szOwner

RETURN 1
GO

--
-- Definition for stored procedure SP_FRIEND_LINKEDLIST : 
--
GO
CREATE PROCEDURE [dbo].SP_FRIEND_LINKEDLIST
	( @szOwner nvarchar(30) )
AS
	IF (@szOwner = NULL)
	BEGIN
		RETURN 2 
	END

	SELECT FLD_CHARACTER  FROM TBL_FRIEND WHERE FLD_FRIEND = @szOwner

RETURN 1
GO

--
-- Definition for stored procedure SP_FRIEND_DELETEALL : 
--
GO
CREATE PROCEDURE [dbo].SP_FRIEND_DELETEALL
	( @szOwner nvarchar(30) )
AS
	IF (@szOwner = NULL)
	BEGIN
		SELECT 2[FLD_RETURN]
		RETURN 2
	END

	DELETE TBL_FRIEND WHERE FLD_CHARACTER=@szOwner

SELECT 1[FLD_RETURN]
RETURN 1
GO

--
-- Definition for stored procedure SP_FRIEND_DELETE : 
--
GO
CREATE PROCEDURE [dbo].SP_FRIEND_DELETE
	( @szOwner nvarchar(30) , 
	  @szFriend nvarchar(30) )

AS
	IF ( @szOwner = NULL ) or ( @szFriend = NULL )
	BEGIN
		SELECT 2[FLD_RETURN]
		RETURN 2
	END
	
	DELETE TBL_FRIEND WHERE FLD_CHARACTER = @szOwner AND FLD_FRIEND= @szFriend

SELECT 1[FLD_RETURN]
RETURN 1
GO

--
-- Definition for table TBL_CHARACTER : 
--

CREATE TABLE [dbo].[TBL_CHARACTER] (
  [FLD_CHARACTER] char(15) COLLATE Korean_Wansung_CI_AS NOT NULL,
  [FLD_USERID] char(21) COLLATE Korean_Wansung_CI_AS NOT NULL,
  [FLD_DELETED] tinyint NULL,
  [FLD_UPDATEDATETIME] datetime NULL,
  [FLD_DBVERSION] tinyint NULL,
  [FLD_MAPNAME] char(20) COLLATE Korean_Wansung_CI_AS NULL,
  [FLD_CX] smallint NULL,
  [FLD_CY] smallint NULL,
  [FLD_DIR] tinyint NULL,
  [FLD_HAIR] tinyint NULL,
  [FLD_HAIRCOLORR] tinyint NOT NULL,
  [FLD_HAIRCOLORG] tinyint NOT NULL,
  [FLD_HAIRCOLORB] tinyint NOT NULL,
  [FLD_SEX] tinyint NULL,
  [FLD_JOB] tinyint NULL,
  [FLD_LEVEL] int NULL,
  [FLD_HP] int NULL,
  [FLD_MP] int NULL,
  [FLD_EXP] bigint NULL,
  [FLD_GOLD] int NULL,
  [FLD_HOMEMAP] char(20) COLLATE Korean_Wansung_CI_AS NULL,
  [FLD_HOMEX] smallint NULL,
  [FLD_HOMEY] smallint NULL,
  [FLD_PKPOINT] int NULL,
  [FLD_ALLOWPARTY] tinyint NULL,
  [FLD_FREEGULITYCOUNT] tinyint NULL,
  [FLD_ATTACKMODE] tinyint NULL,
  [FLD_FIGHTZONEDIE] tinyint NULL,
  [FLD_BODYLUCK] float NULL,
  [FLD_INCHEALTH] tinyint NULL,
  [FLD_INCSPELL] tinyint NULL,
  [FLD_INCHEALING] tinyint NULL,
  [FLD_BONUSAPPLY] tinyint NULL,
  [FLD_BONUSPOINT] int NULL,
  [FLD_HUNGRYSTATE] tinyint NULL,
  [FLD_TESTSERVERRESETCOUNT] int NULL,
  [FLD_CGHUSETIME] int NULL,
  [FLD_RESERVED] char(100) COLLATE Korean_Wansung_CI_AS NULL,
  [FLD_ENABLEGRECALL] tinyint NULL,
  [FLD_BYTES_1] char(3) COLLATE Korean_Wansung_CI_AS NULL,
  [FLD_HORSERACE] smallint NULL,
  [FLD_MAKEDATE] datetime NULL,
  [FLD_FAMECUR] int NULL,
  [FLD_FAMEBASE] int NULL
)
ON [PRIMARY]
GO

--
-- Definition for stored procedure SP_TAG_REJECTADD : 
--
GO
CREATE PROCEDURE [dbo].SP_TAG_REJECTADD
	( @szReciever nvarchar(30) ,
	  @szRejecter nvarchar(30)
	)
AS
	IF (@szReciever = NULL) or (@szRejecter = NULL)
	BEGIN
		SELECT 2[FLD_RETURN]
		RETURN 2 
	END

	IF  0 = ( SELECT COUNT(*) FROM TBL_CHARACTER WHERE FLD_CHARACTER = @szReciever )
	BEGIN
		SELECT 3[FLD_RETURN]
		RETURN 3 
	END

	IF 100  <=  (SELECT COUNT(*) FROM TBL_TAG_REJECT  WHERE FLD_CHARACTER=@szReciever)
	BEGIN
		SELECT 4[FLD_RETURN]
		RETURN 4 
	END

	INSERT INTO TBL_TAG_REJECT ( FLD_CHARACTER , FLD_REJECTER) 
			VALUES ( @szReciever , @szRejecter)

SELECT 1[FLD_RETURN]
RETURN 1
GO

--
-- Definition for stored procedure SP_TAG_ADD : 
--
GO
CREATE PROCEDURE [dbo].SP_TAG_ADD
	( @szReciever nvarchar(30) ,
	  @szDate nchar(12),
	  @nState int,
	  @szSender nvarchar(30),
	  @szDesc nvarchar(80)
	)
AS
	IF (@szReciever = NULL) or ( @szDate = NULL)
	BEGIN
	
		SELECT 2[FLD_RETURN]
		RETURN 2
	END


	IF  0 = ( SELECT COUNT(*) FROM TBL_CHARACTER WHERE FLD_CHARACTER = @szReciever )
	BEGIN
		SELECT 3[FLD_RETURN]
		RETURN 3 
	END

	IF 100  <=  (SELECT COUNT(*) FROM TBL_TAG WHERE FLD_CHARACTER=@szReciever)
	BEGIN
		SELECT 4[FLD_RETURN]
		RETURN 4
	END

	IF 1 <=  (SELECT COUNT(*) FROM TBL_TAG_REJECT WHERE FLD_CHARACTER = @szReciever AND FLD_REJECTER = @szSender )
	BEGIN
		SELECT 5[FLD_RETURN]
		RETURN 5
	END

	IF 1 <=  (SELECT COUNT(*) FROM TBL_TAG WHERE FLD_CHARACTER = @szReciever AND FLD_DATE = @szDate)
	BEGIN
		SELECT 6[FLD_RETURN]
		RETURN 6
	END

	INSERT INTO TBL_TAG ( FLD_CHARACTER , FLD_DATE , FLD_STATE , FLD_SENDER ,FLD_DESC ) 
			VALUES ( @szReciever , @szDate , @nState , @szSender ,@szDesc )

SELECT 1[FLD_RETURN]
RETURN 1
GO

--
-- Definition for stored procedure SP_LM_LIST : 
--
GO
CREATE PROCEDURE [dbo].SP_LM_LIST
	( @szReciever nvarchar(30) )
AS
	IF (@szReciever = NULL)
	BEGIN
	
		RETURN 2 
	END

	SELECT A.FLD_OTHER , A.FLD_STATE, A.FLD_MSG,A.FLD_DATE ,B.FLD_LEVEL,B.FLD_SEX  FROM TBL_RELATION A , TBL_CHARACTER B WHERE A.FLD_CHARACTER = @szReciever and A.FLD_OTHER = B.FLD_CHARACTER

RETURN 1
GO

--
-- Definition for stored procedure SP_LM_ADD : 
--
GO
CREATE PROCEDURE [dbo].SP_LM_ADD 
	( @szOwner nvarchar(30) , 
	  @szOther nvarchar(30),
	  @nState int,
	  @szDate nvarchar(12))
AS
	IF (@szOwner = null) or ( @szOther = null )
	BEGIN
		SELECT 2[FLD_RETURN]
		RETURN 2
	END
	ELSE
	BEGIN
		IF  2  > ( SELECT COUNT ( *) FROM TBL_CHARACTER WHERE  FLD_CHARACTER = @szOwner OR FLD_CHARACTER = @szOther )
		BEGIN
			SELECT 3[FLD_RETURN]
			RETURN 3
		END

		IF  1 <=  ( SELECT COUNT (*) FROM TBL_RELATION WHERE FLD_CHARACTER = @szOwner and FLD_OTHER = @szOther )
		BEGIN
			SELECT 4[FLD_RETURN]
			RETURN 4
		END
	
		INSERT INTO TBL_RELATION (FLD_CHARACTER , FLD_OTHER , FLD_STATE , FLD_DATE)  VALUES ( @szOwner , @szOther , @nState ,@szDate)
		
		SELECT 1[FLD_RETURN]
		RETURN 1
	END
SELECT 1[FLD_RETURN]
RETURN 1
GO

--=====================Selected  Views=====================--
--=====================Selected  Proceudre=====================--
CREATE PROCEDURE [dbo].SP_FRIEND_ADD 
	( @szOwner nvarchar(30) , 
	  @nState int,
	  @szFriend nvarchar(30),
	  @szDesc nvarchar(40))
AS
	IF (@szOwner = null) or ( @szFriend = null )
	BEGIN
		-- PRINT ' ERROR 1 :Parameter is Null '
		-- PRINT '1'
		SELECT 2[FLD_RETURN]
		RETURN 2
	END
	ELSE
	BEGIN
		IF  2  > ( SELECT COUNT ( *) FROM TBL_CHARACTER WHERE  FLD_CHARACTER = @szOwner OR FLD_CHARACTER = @szFriend )
		BEGIN
			--PRINT 'ERROR 2: Do Not Find Character Name  or Same Character Name' 
			--PRINT '2'
			SELECT 3[FLD_RETURN]
			RETURN 3
		END

		IF  1 <=  ( SELECT COUNT (*) FROM TBL_FRIEND WHERE FLD_CHARACTER = @szOwner and FLD_FRIEND = @szFriend )
		BEGIN
			-- PRINT 'ERROR 3: Do Not Insert Same Friend Name'
			-- PRINT '3'
			SELECT 4[FLD_RETURN]
			RETURN 4
		END
	
		INSERT INTO TBL_FRIEND (FLD_CHARACTER , FLD_FRIEND , FLD_STATE , FLD_DESC)  VALUES ( @szOwner , @szFriend , @nState ,@szDesc)
		
		-- PRINT '0'
		SELECT 1[FLD_RETURN]
		RETURN 1
	END

SELECT 1[FLD_RETURN]
RETURN 1
GO

--
-- Definition for table TBL_ABILITY : 
--

CREATE TABLE [dbo].[TBL_ABILITY] (
  [FLD_CHARACTER] char(15) COLLATE Korean_Wansung_CI_AS NOT NULL,
  [FLD_LEVEL] tinyint NULL,
  [FLD_RESERVED1] tinyint NULL,
  [FLD_AC] int NULL,
  [FLD_MAC] int NULL,
  [FLD_DC] int NULL,
  [FLD_MC] int NULL,
  [FLD_SC] int NULL,
  [FLD_HP] int NULL,
  [FLD_MP] int NULL,
  [FLD_MAXHP] int NULL,
  [FLD_MAXMP] int NULL,
  [FLD_EXP] bigint NULL,
  [FLD_MAXEXP] bigint NULL,
  [FLD_WEIGHT] int NULL,
  [FLD_MAXWEIGHT] int NULL,
  [FLD_WEARWEIGHT] int NULL,
  [FLD_MAXWEARWEIGHT] int NULL,
  [FLD_HANDWEIGHT] int NULL,
  [FLD_MAXHANDWEIGHT] int NULL,
  [FLD_ATOMFIRE_MC] smallint NULL,
  [FLD_ATOMICE_MC] smallint NULL,
  [FLD_ATOMLIGHT_MC] smallint NULL,
  [FLD_ATOMWIND_MC] smallint NULL,
  [FLD_ATOMHOLY_MC] smallint NULL,
  [FLD_ATOMDARK_MC] smallint NULL,
  [FLD_ATOMPHANTOM_MC] smallint NULL,
  [FLD_ATOMFIRE_MAC] smallint NULL,
  [FLD_ATOMICE_MAC] smallint NULL,
  [FLD_ATOMLIGHT_MAC] smallint NULL,
  [FLD_ATOMWIND_MAC] smallint NULL,
  [FLD_ATOMHOLY_MAC] smallint NULL,
  [FLD_ATOMDARK_MAC] smallint NULL,
  [FLD_ATOMPHANTOM_MAC] smallint NULL
)
ON [PRIMARY]
GO


