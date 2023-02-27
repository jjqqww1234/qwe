object MIEForm: TMIEForm
  Left = 228
  Top = 120
  Width = 937
  Height = 640
  Caption = 'MIR2 DATA Editor v 1.4 With ADO'
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = #181#184#191#242#195#188
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 16
  object Bevel1: TBevel
    Left = 0
    Top = 25
    Width = 921
    Height = 2
    Align = alTop
  end
  object ToolBar1: TToolBar
    Left = 0
    Top = 0
    Width = 921
    Height = 25
    Caption = 'ToolBar1'
    Flat = True
    Images = ImageList1
    TabOrder = 0
    object ToolButton1: TToolButton
      Left = 0
      Top = 0
      Width = 8
      Caption = 'ToolButton1'
      Style = tbsSeparator
    end
    object ConnBtn: TToolButton
      Left = 8
      Top = 0
      Hint = 'Connect'
      Caption = 'ConnBtn'
      Grouped = True
      ImageIndex = 0
      ParentShowHint = False
      ShowHint = True
      OnClick = ConnBtnClick
    end
    object ToolButton3: TToolButton
      Left = 31
      Top = 0
      Width = 8
      Caption = 'ToolButton3'
      ImageIndex = 3
      Style = tbsSeparator
    end
    object DisConnBtn: TToolButton
      Left = 39
      Top = 0
      Hint = 'Disconnect'
      Caption = 'DisConnBtn'
      Grouped = True
      ImageIndex = 1
      ParentShowHint = False
      ShowHint = True
      OnClick = DisConnBtnClick
    end
    object ToolButton2: TToolButton
      Left = 62
      Top = 0
      Width = 8
      Caption = 'ToolButton2'
      ImageIndex = 2
      Style = tbsSeparator
    end
  end
  object InfoBar: TStatusBar
    Left = 0
    Top = 583
    Width = 921
    Height = 19
    Panels = <>
  end
  object DataPage: TPageControl
    Left = 0
    Top = 27
    Width = 921
    Height = 556
    ActivePage = ItemTab
    Align = alClient
    TabOrder = 2
    object ItemTab: TTabSheet
      Caption = 'ITEM'
      object Panel2: TPanel
        Left = 0
        Top = 0
        Width = 913
        Height = 60
        Align = alTop
        BevelInner = bvLowered
        BevelOuter = bvNone
        BorderWidth = 2
        TabOrder = 0
        DesignSize = (
          913
          60)
        object ItemEditBtn: TSpeedButton
          Left = 374
          Top = 12
          Width = 110
          Height = 36
          AllowAllUp = True
          GroupIndex = 2
          Caption = 'DONTEDIT'
          OnClick = ItemEditBtnClick
        end
        object ItemDBNavigator: TDBNavigator
          Left = 12
          Top = 12
          Width = 328
          Height = 36
          DataSource = RES_DATAS.ItemDataSource
          VisibleButtons = [nbFirst, nbPrior, nbNext, nbLast, nbEdit, nbPost, nbCancel, nbRefresh]
          Flat = True
          ParentShowHint = False
          ShowHint = True
          TabOrder = 0
          OnClick = ItemDBNavigatorClick
        end
        object ItemFindEdit: TEdit
          Left = 847
          Top = 14
          Width = 271
          Height = 24
          Anchors = [akLeft, akTop, akRight]
          ImeName = 'Microsoft Korean IME 2002'
          TabOrder = 1
          OnKeyDown = ItemFindEditKeyDown
        end
        object ItemFindBtn: TButton
          Left = 729
          Top = 14
          Width = 109
          Height = 35
          Caption = 'FIND'
          TabOrder = 2
          OnClick = ItemFindBtnClick
        end
        object DBEdit2: TDBEdit
          Left = 497
          Top = 14
          Width = 176
          Height = 24
          DataField = 'NAME'
          DataSource = RES_DATAS.ItemDataSource
          ImeName = 'Microsoft Korean IME 2002'
          ReadOnly = True
          TabOrder = 3
        end
      end
      object ItemDBGrid: TDBGrid
        Left = 0
        Top = 60
        Width = 913
        Height = 465
        Align = alClient
        DataSource = RES_DATAS.ItemDataSource
        ImeName = 'Microsoft Korean IME 2002'
        Options = [dgEditing, dgAlwaysShowEditor, dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgCancelOnExit]
        ReadOnly = True
        TabOrder = 1
        TitleFont.Charset = ANSI_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -13
        TitleFont.Name = #181#184#191#242#195#188
        TitleFont.Style = []
        OnColEnter = ItemDBGridColEnter
      end
    end
    object MagicTab: TTabSheet
      Caption = 'MAGIC'
      ImageIndex = 1
      object Panel3: TPanel
        Left = 0
        Top = 0
        Width = 1134
        Height = 60
        Align = alTop
        BevelInner = bvLowered
        BevelOuter = bvNone
        BorderWidth = 2
        TabOrder = 0
        DesignSize = (
          913
          60)
        object MgicEditBtn: TSpeedButton
          Left = 374
          Top = 12
          Width = 110
          Height = 36
          AllowAllUp = True
          GroupIndex = 2
          Caption = 'DONTEDIT'
          OnClick = MgicEditBtnClick
        end
        object MagicDBNavigator: TDBNavigator
          Left = 12
          Top = 12
          Width = 328
          Height = 36
          DataSource = RES_DATAS.MagicDataSource
          VisibleButtons = [nbFirst, nbPrior, nbNext, nbLast, nbEdit, nbPost, nbCancel, nbRefresh]
          Flat = True
          ParentShowHint = False
          ShowHint = True
          TabOrder = 0
          OnClick = MagicDBNavigatorClick
        end
        object DBEdit3: TDBEdit
          Left = 497
          Top = 14
          Width = 176
          Height = 21
          DataField = 'NAME'
          DataSource = RES_DATAS.MagicDataSource
          ImeName = 'Microsoft Korean IME 2002'
          ReadOnly = True
          TabOrder = 1
        end
        object MagicFindBtn: TButton
          Left = 729
          Top = 14
          Width = 109
          Height = 35
          Caption = 'FIND'
          TabOrder = 2
          OnClick = MagicFindBtnClick
        end
        object MagicFindEdit: TEdit
          Left = 847
          Top = 14
          Width = 50
          Height = 21
          Anchors = [akLeft, akTop, akRight]
          ImeName = 'Microsoft Korean IME 2002'
          TabOrder = 3
          OnKeyDown = MagicFindEditKeyDown
        end
      end
      object MagicDBGrid: TDBGrid
        Left = 0
        Top = 60
        Width = 913
        Height = 465
        Align = alClient
        DataSource = RES_DATAS.MagicDataSource
        ImeName = 'Microsoft Korean IME 2002'
        Options = [dgEditing, dgAlwaysShowEditor, dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgCancelOnExit]
        ReadOnly = True
        TabOrder = 1
        TitleFont.Charset = ANSI_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -13
        TitleFont.Name = #181#184#191#242#195#188
        TitleFont.Style = []
        OnColEnter = MagicDBGridColEnter
      end
    end
    object MobTab: TTabSheet
      Caption = 'MONSTER'
      ImageIndex = 2
      object Splitter1: TSplitter
        Left = 523
        Top = 98
        Width = 5
        Height = 565
      end
      object Panel1: TPanel
        Left = 0
        Top = 0
        Width = 1134
        Height = 98
        Align = alTop
        BevelInner = bvLowered
        BevelOuter = bvNone
        BorderWidth = 2
        TabOrder = 0
        DesignSize = (
          913
          98)
        object LeftLockBtn: TSpeedButton
          Left = 374
          Top = 12
          Width = 110
          Height = 36
          AllowAllUp = True
          GroupIndex = 2
          Caption = 'DONTEDIT'
          OnClick = LeftLockBtnClick
        end
        object RightLockBtn: TSpeedButton
          Left = 469
          Top = 12
          Width = 110
          Height = 36
          AllowAllUp = True
          Anchors = [akTop, akRight]
          GroupIndex = 1
          Caption = 'DONTEDIT'
          OnClick = RightLockBtnClick
        end
        object LeftNavigator: TDBNavigator
          Left = 12
          Top = 12
          Width = 328
          Height = 36
          DataSource = RES_DATAS.LeftDataSource
          VisibleButtons = [nbFirst, nbPrior, nbNext, nbLast, nbEdit, nbPost, nbCancel, nbRefresh]
          Flat = True
          ParentShowHint = False
          ShowHint = True
          TabOrder = 0
          OnClick = LeftNavigatorClick
        end
        object DBEdit1: TDBEdit
          Left = 311
          Top = 15
          Width = 149
          Height = 21
          Anchors = [akTop, akRight]
          DataField = 'NAME'
          DataSource = RES_DATAS.RightDataSource
          ImeName = 'Microsoft Korean IME 2002'
          ReadOnly = True
          TabOrder = 1
        end
        object RightNavigator: TDBNavigator
          Left = 586
          Top = 12
          Width = 312
          Height = 36
          DataSource = RES_DATAS.RightDataSource
          VisibleButtons = [nbFirst, nbPrior, nbNext, nbLast, nbEdit, nbPost, nbCancel, nbRefresh]
          Anchors = [akTop, akRight]
          Flat = True
          ParentShowHint = False
          ShowHint = True
          TabOrder = 2
          OnClick = RightNavigatorClick
        end
        object MobFindBtn: TButton
          Left = 689
          Top = 53
          Width = 110
          Height = 36
          Caption = 'FIND'
          TabOrder = 3
          OnClick = MobFindBtnClick
        end
        object MobFindEdit: TEdit
          Left = 807
          Top = 55
          Width = 96
          Height = 21
          Anchors = [akLeft, akTop, akRight]
          ImeName = 'Microsoft Korean IME 2002'
          TabOrder = 4
          OnKeyDown = MobFindEditKeyDown
        end
      end
      object LeftGrid: TDBGrid
        Left = 0
        Top = 98
        Width = 523
        Height = 427
        Align = alLeft
        DataSource = RES_DATAS.LeftDataSource
        ImeName = 'Microsoft Korean IME 2002'
        Options = [dgEditing, dgAlwaysShowEditor, dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgCancelOnExit]
        ReadOnly = True
        TabOrder = 1
        TitleFont.Charset = ANSI_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -13
        TitleFont.Name = #181#184#191#242#195#188
        TitleFont.Style = []
        OnColEnter = LeftGridColEnter
        Columns = <
          item
            DropDownRows = 35
            Expanded = False
            FieldName = 'ITEMNAME'
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'SELPOINT'
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'MAXPOINT'
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'COUNT'
            Width = 42
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'DROPCOUNT'
            Width = 41
            Visible = True
          end>
      end
      object RightGrid: TDBGrid
        Left = 528
        Top = 98
        Width = 385
        Height = 427
        Align = alClient
        DataSource = RES_DATAS.RightDataSource
        ImeName = 'Microsoft Korean IME 2002'
        Options = [dgEditing, dgAlwaysShowEditor, dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgCancelOnExit]
        ReadOnly = True
        TabOrder = 2
        TitleFont.Charset = ANSI_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -13
        TitleFont.Name = #181#184#191#242#195#188
        TitleFont.Style = []
        OnColEnter = RightGridColEnter
      end
    end
    object MobItemTab: TTabSheet
      Caption = 'MOBITEM'
      ImageIndex = 3
      object Panel4: TPanel
        Left = 0
        Top = 0
        Width = 1134
        Height = 60
        Align = alTop
        BevelInner = bvLowered
        BevelOuter = bvNone
        BorderWidth = 2
        TabOrder = 0
        object ItemBox: TComboBox
          Left = 20
          Top = 20
          Width = 286
          Height = 21
          DropDownCount = 15
          ImeName = #199#209#177#185#190#238'('#199#209#177#219') (MS-IME98)'
          ItemHeight = 0
          TabOrder = 0
        end
        object ITemQuertBtn: TBitBtn
          Left = 315
          Top = 16
          Width = 92
          Height = 31
          Caption = 'Search'
          TabOrder = 1
          OnClick = ITemQuertBtnClick
        end
      end
      object DBGrid1: TDBGrid
        Left = 0
        Top = 60
        Width = 913
        Height = 465
        Align = alClient
        DataSource = RES_DATAS.MobItemSource
        ImeName = #199#209#177#185#190#238'('#199#209#177#219') (MS-IME98)'
        Options = [dgEditing, dgAlwaysShowEditor, dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgCancelOnExit]
        ReadOnly = True
        TabOrder = 1
        TitleFont.Charset = ANSI_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -13
        TitleFont.Name = #181#184#191#242#195#188
        TitleFont.Style = []
        OnDblClick = DBGrid1DblClick
      end
    end
  end
  object ImageList1: TImageList
    Left = 336
    Top = 13
    Bitmap = {
      494C010102000400040010001000FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000001000000001002000000000000010
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFF0000FFFF0000FFFF0000FFFF
      0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF
      0000FFFF0000FFFF0000FFFF000000000000FFFF0000FFFF0000FFFF0000FFFF
      0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF
      0000FFFF0000FFFF0000FFFF0000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFF000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FFFF000000000000FFFF000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FFFF0000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFF000000000000FFFFFF007B7B
      7B007B7B7B007B7B7B007B7B7B007B7B7B007B7B7B007B7B7B007B7B7B007B7B
      7B007B7B7B0000000000FFFF000000000000FFFF000000000000FFFFFF007B7B
      7B007B7B7B007B7B7B007B7B7B007B7B7B007B7B7B007B7B7B007B7B7B007B7B
      7B007B7B7B0000000000FFFF0000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFF000000000000FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      00007B7B7B0000000000FFFF000000000000FFFF000000000000FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      00007B7B7B0000000000FFFF0000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFF000000000000FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      00007B7B7B0000000000FFFF000000000000FFFF000000000000FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      00007B7B7B0000000000FFFF0000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFF000000000000FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      00007B7B7B0000000000FFFF000000000000FFFF000000000000FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      00007B7B7B0000000000FFFF0000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFF000000000000FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      00007B7B7B0000000000FFFF000000000000FFFF000000000000FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      00007B7B7B0000000000FFFF0000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFF000000000000FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      00007B7B7B0000000000FFFF000000000000FFFF000000000000FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      00007B7B7B0000000000FFFF0000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFF000000000000FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      00007B7B7B0000000000FFFF000000000000FFFF000000000000FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      00007B7B7B0000000000FFFF0000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFF000000000000FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      00007B7B7B0000000000FFFF000000000000FFFF000000000000FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      00007B7B7B0000000000FFFF0000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFF000000000000FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      00007B7B7B0000000000FFFF000000000000FFFF000000000000FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      00007B7B7B0000000000FFFF0000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFF000000000000FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      00007B7B7B0000000000FFFF000000000000FFFF000000000000FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      00007B7B7B0000000000FFFF0000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFF000000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF0000000000FFFF000000000000FFFF000000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF0000000000FFFF0000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFF000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FFFF000000000000FFFF000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FFFF0000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFF0000FFFF0000FFFF0000FFFF
      0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF
      0000FFFF0000FFFF0000FFFF000000000000FFFF0000FFFF0000FFFF0000FFFF
      0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF
      0000FFFF0000FFFF0000FFFF0000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000040000000100000000100010000000000800000000000000000000000
      000000000000000000000000FFFFFF00FFFFFFFF000000000001000100000000
      000100010000000000010001000000001FF11FF1000000001DF11FF100000000
      1CF11831000000001C711831000000001C311831000000001C71183100000000
      1CF11831000000001DF11FF1000000001FF11FF1000000000001000100000000
      0001000100000000000100010000000000000000000000000000000000000000
      000000000000}
  end
end
