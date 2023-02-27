object FrmFeeUtil: TFrmFeeUtil
  Left = 140
  Top = 220
  Width = 764
  Height = 496
  Caption = #176#232#193#164' '#186#184#177#226
  Color = clBtnFace
  Font.Charset = HANGEUL_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = #177#188#184#178
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  PixelsPerInch = 96
  TextHeight = 16
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 756
    Height = 78
    Align = alTop
    BevelOuter = bvNone
    Caption = ' '
    TabOrder = 0
    object Label1: TLabel
      Left = 5
      Top = 44
      Width = 103
      Height = 16
      Caption = #190#198#192#204#181#240' / IP '#195#163#177#226
    end
    object Label2: TLabel
      Left = 10
      Top = 10
      Width = 68
      Height = 16
      Caption = 'PC '#185#230' '#195#163#177#226
    end
    object Label3: TLabel
      Left = 834
      Top = 10
      Width = 4
      Height = 16
      Caption = ' '
    end
    object BtnConvert: TSpeedButton
      Left = 768
      Top = 44
      Width = 110
      Height = 21
      Caption = #181#165#192#204#197#184' '#186#175#200#175
      OnClick = BtnConvertClick
    end
    object BtnFindId: TSpeedButton
      Left = 300
      Top = 39
      Width = 41
      Height = 27
      Caption = #195#163#177#226
      OnClick = BtnFindIDClick
    end
    object BtnFindIdAll: TSpeedButton
      Left = 345
      Top = 39
      Width = 85
      Height = 27
      Caption = #180#217#195#163#177#226'(F6)'
      OnClick = BtnFindIDAllClick
    end
    object BtnFindGroup: TSpeedButton
      Left = 300
      Top = 5
      Width = 41
      Height = 27
      Caption = #195#163#177#226
      OnClick = BtnFindGroupClick
    end
    object BtnFindPCAll: TSpeedButton
      Left = 345
      Top = 5
      Width = 85
      Height = 27
      Caption = #180#217#195#163#177#226'(F5)'
      OnClick = BtnFindPCAllClick
    end
    object BtnAddRcd: TSpeedButton
      Left = 532
      Top = 5
      Width = 78
      Height = 26
      Caption = #195#223#176#161'(Ins)'
      OnClick = BtnAddRcdClick
    end
    object BtnDelRcd: TSpeedButton
      Left = 615
      Top = 5
      Width = 99
      Height = 26
      Caption = #187#232#193#166'(C+Del)'
      OnClick = BtnDelRcdClick
    end
    object BtnChangeRcd: TSpeedButton
      Left = 719
      Top = 5
      Width = 99
      Height = 26
      Caption = #186#175#176#230'(C+Ent)'
      OnClick = BtnChangeRcdClick
    end
    object BtnBack: TSpeedButton
      Left = 433
      Top = 5
      Width = 70
      Height = 27
      Caption = #181#218#183#206'(F4)'
      OnClick = BtnBackClick
    end
    object LbPlus: TLabel
      Left = 620
      Top = 49
      Width = 11
      Height = 24
      Caption = '0'
      Font.Charset = HANGEUL_CHARSET
      Font.Color = clWindowText
      Font.Height = -20
      Font.Name = #177#188#184#178
      Font.Style = []
      ParentFont = False
    end
    object EdFindID: TEdit
      Left = 128
      Top = 39
      Width = 164
      Height = 24
      ImeName = #199#209#177#185#190#238'('#199#209#177#219') (MS-IME95)'
      TabOrder = 1
      OnKeyPress = EdFindIDKeyPress
    end
    object EdFindPC: TEdit
      Left = 98
      Top = 5
      Width = 194
      Height = 24
      ImeName = #199#209#177#185#190#238'('#199#209#177#219') (MS-IME95)'
      TabOrder = 0
      OnKeyPress = EdFindPCKeyPress
    end
  end
  object FGrid: TStringGrid
    Left = 0
    Top = 78
    Width = 756
    Height = 384
    Align = alClient
    ColCount = 10
    DefaultRowHeight = 18
    FixedCols = 0
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goColSizing, goThumbTracking]
    TabOrder = 1
    OnClick = FGridClick
    OnDblClick = FGridDblClick
    OnDrawCell = FGridDrawCell
    OnKeyPress = FGridKeyPress
    ColWidths = (
      12
      107
      161
      51
      55
      34
      63
      37
      64
      138)
  end
  object OpenDialog1: TOpenDialog
    Left = 560
    Top = 32
  end
end
