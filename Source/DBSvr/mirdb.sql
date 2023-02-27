if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[TBL_ABILITY]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[TBL_ABILITY]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[TBL_CHARACTER]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[TBL_CHARACTER]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[TBL_ITEM]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[TBL_ITEM]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[TBL_MAGIC]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[TBL_MAGIC]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[TBL_QUEST]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[TBL_QUEST]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[TBL_SAVEDITEM]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[TBL_SAVEDITEM]
GO

CREATE TABLE [dbo].[TBL_ABILITY] (
	[FLD_CHARACTER] [char] (15) COLLATE Korean_Wansung_CI_AS NOT NULL ,
	[FLD_LEVEL] [tinyint] NULL ,
	[FLD_RESERVED1] [tinyint] NULL ,
	[FLD_AC] [int] NULL ,
	[FLD_MAC] [int] NULL ,
	[FLD_DC] [int] NULL ,
	[FLD_MC] [int] NULL ,
	[FLD_SC] [int] NULL ,
	[FLD_HP] [int] NULL ,
	[FLD_MP] [int] NULL ,
	[FLD_MAXHP] [int] NULL ,
	[FLD_MAXMP] [int] NULL ,
	[FLD_EXP] [bigint] NULL ,
	[FLD_MAXEXP] [bigint] NULL ,
	[FLD_WEIGHT] [int] NULL ,
	[FLD_MAXWEIGHT] [int] NULL ,
	[FLD_WEARWEIGHT] [int] NULL ,
	[FLD_MAXWEARWEIGHT] [int] NULL ,
	[FLD_HANDWEIGHT] [int] NULL ,
	[FLD_MAXHANDWEIGHT] [int] NULL ,
	[FLD_ATOMFIRE_MC] [smallint] NULL ,
	[FLD_ATOMICE_MC] [smallint] NULL ,
	[FLD_ATOMLIGHT_MC] [smallint] NULL ,
	[FLD_ATOMWIND_MC] [smallint] NULL ,
	[FLD_ATOMHOLY_MC] [smallint] NULL ,
	[FLD_ATOMDARK_MC] [smallint] NULL ,
	[FLD_ATOMPHANTOM_MC] [smallint] NULL ,
	[FLD_ATOMFIRE_MAC] [smallint] NULL ,
	[FLD_ATOMICE_MAC] [smallint] NULL ,
	[FLD_ATOMLIGHT_MAC] [smallint] NULL ,
	[FLD_ATOMWIND_MAC] [smallint] NULL ,
	[FLD_ATOMHOLY_MAC] [smallint] NULL ,
	[FLD_ATOMDARK_MAC] [smallint] NULL ,
	[FLD_ATOMPHANTOM_MAC] [smallint] NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[TBL_CHARACTER] (
	[FLD_CHARACTER] [char] (15) COLLATE Korean_Wansung_CI_AS NOT NULL ,
	[FLD_USERID] [char] (21) COLLATE Korean_Wansung_CI_AS NOT NULL ,
	[FLD_DELETED] [tinyint] NULL ,
	[FLD_UPDATEDATETIME] [datetime] NULL ,
	[FLD_DBVERSION] [tinyint] NULL ,
	[FLD_MAPNAME] [char] (20) COLLATE Korean_Wansung_CI_AS NULL ,
	[FLD_CX] [smallint] NULL ,
	[FLD_CY] [smallint] NULL ,
	[FLD_DIR] [tinyint] NULL ,
	[FLD_HAIR] [tinyint] NULL ,
	[FLD_HAIRCOLORR] [tinyint] NOT NULL ,
	[FLD_HAIRCOLORG] [tinyint] NOT NULL ,
	[FLD_HAIRCOLORB] [tinyint] NOT NULL ,
	[FLD_SEX] [tinyint] NULL ,
	[FLD_JOB] [tinyint] NULL ,
	[FLD_LEVEL] [tinyint] NULL ,
	[FLD_GOLD] [int] NULL ,
	[FLD_HOMEMAP] [char] (20) COLLATE Korean_Wansung_CI_AS NULL ,
	[FLD_HOMEX] [smallint] NULL ,
	[FLD_HOMEY] [smallint] NULL ,
	[FLD_PKPOINT] [int] NULL ,
	[FLD_ALLOWPARTY] [tinyint] NULL ,
	[FLD_FREEGULITYCOUNT] [tinyint] NULL ,
	[FLD_ATTACKMODE] [tinyint] NULL ,
	[FLD_FIGHTZONEDIE] [tinyint] NULL ,
	[FLD_BODYLUCK] [float] NULL ,
	[FLD_INCHEALTH] [tinyint] NULL ,
	[FLD_INCSPELL] [tinyint] NULL ,
	[FLD_INCHEALING] [tinyint] NULL ,
	[FLD_BONUSAPPLY] [tinyint] NULL ,
	[FLD_BONUSPOINT] [int] NULL ,
	[FLD_HUNGRYSTATE] [tinyint] NULL ,
	[FLD_TESTSERVERRESETCOUNT] [int] NULL ,
	[FLD_CGHUSETIME] [int] NULL ,
	[FLD_RESERVED] [char] (100) COLLATE Korean_Wansung_CI_AS NULL ,
	[FLD_ENABLEGRECALL] [tinyint] NULL ,
	[FLD_BYTES_1] [char] (3) COLLATE Korean_Wansung_CI_AS NULL ,
	[FLD_HORSERACE] [smallint] NULL ,
	[FLD_MAKEDATE] [datetime] NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[TBL_ITEM] (
	[FLD_CHARACTER] [char] (15) COLLATE Korean_Wansung_CI_AS NOT NULL ,
	[FLD_TYPE] [tinyint] NULL ,
	[FLD_MAKEINDEX] [int] NOT NULL ,
	[FLD_INDEX] [int] NULL ,
	[FLD_DURA] [int] NULL ,
	[FLD_DURAMAX] [int] NULL ,
	[FLD_DESC0] [tinyint] NULL ,
	[FLD_DESC1] [tinyint] NULL ,
	[FLD_DESC2] [tinyint] NULL ,
	[FLD_DESC3] [tinyint] NULL ,
	[FLD_DESC4] [tinyint] NULL ,
	[FLD_DESC5] [tinyint] NULL ,
	[FLD_DESC6] [tinyint] NULL ,
	[FLD_DESC7] [tinyint] NULL ,
	[FLD_DESC8] [tinyint] NULL ,
	[FLD_DESC9] [tinyint] NULL ,
	[FLD_DESC10] [tinyint] NULL ,
	[FLD_DESC11] [tinyint] NULL ,
	[FLD_DESC12] [tinyint] NULL ,
	[FLD_DESC13] [tinyint] NULL ,
	[FLD_COLORR] [tinyint] NULL ,
	[FLD_COLORG] [tinyint] NULL ,
	[FLD_COLORB] [tinyint] NULL ,
	[FLD_NAMEPREFIX] [char] (30) COLLATE Korean_Wansung_CI_AS NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[TBL_MAGIC] (
	[FLD_CHARACTER] [char] (15) COLLATE Korean_Wansung_CI_AS NOT NULL ,
	[FLD_MAGICID] [int] NOT NULL ,
	[FLD_LEVEL] [tinyint] NULL ,
	[FLD_KEY] [tinyint] NULL ,
	[FLD_CURTRAIN] [int] NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[TBL_QUEST] (
	[FLD_CHARACTER] [char] (15) COLLATE Korean_Wansung_CI_AS NOT NULL ,
	[FLD_QUESTOPENINDEX] [varchar] (64) COLLATE Korean_Wansung_CI_AS NULL ,
	[FLD_QUESTFININDEX] [varchar] (64) COLLATE Korean_Wansung_CI_AS NULL ,
	[FLD_QUEST] [varchar] (256) COLLATE Korean_Wansung_CI_AS NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[TBL_SAVEDITEM] (
	[FLD_CHARACTER] [char] (15) COLLATE Korean_Wansung_CI_AS NOT NULL ,
	[FLD_TYPE] [tinyint] NULL ,
	[FLD_MAKEINDEX] [int] NOT NULL ,
	[FLD_INDEX] [int] NULL ,
	[FLD_DURA] [int] NULL ,
	[FLD_DURAMAX] [int] NULL ,
	[FLD_DESC0] [tinyint] NULL ,
	[FLD_DESC1] [tinyint] NULL ,
	[FLD_DESC2] [tinyint] NULL ,
	[FLD_DESC3] [tinyint] NULL ,
	[FLD_DESC4] [tinyint] NULL ,
	[FLD_DESC5] [tinyint] NULL ,
	[FLD_DESC6] [tinyint] NULL ,
	[FLD_DESC7] [tinyint] NULL ,
	[FLD_DESC8] [tinyint] NULL ,
	[FLD_DESC9] [tinyint] NULL ,
	[FLD_DESC10] [tinyint] NULL ,
	[FLD_DESC11] [tinyint] NULL ,
	[FLD_DESC12] [tinyint] NULL ,
	[FLD_DESC13] [tinyint] NULL ,
	[FLD_COLORR] [tinyint] NULL ,
	[FLD_COLORG] [tinyint] NULL ,
	[FLD_COLORB] [tinyint] NULL ,
	[FLD_NAMEPREFIX] [char] (30) COLLATE Korean_Wansung_CI_AS NULL 
) ON [PRIMARY]
GO

