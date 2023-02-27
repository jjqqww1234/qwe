object FrmIDHum: TFrmIDHum
  Left = 305
  Top = 169
  Width = 689
  Height = 418
  HorzScrollBar.Visible = False
  VertScrollBar.Visible = False
  Caption = 'Char DB Manager'
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 16
  object Label1: TLabel
    Left = 288
    Top = 432
    Width = 41
    Height = 16
    Caption = 'Label1'
  end
  object Label3: TLabel
    Left = 216
    Top = 12
    Width = 57
    Height = 16
    Caption = 'ChrName'
  end
  object Label4: TLabel
    Left = 8
    Top = 40
    Width = 13
    Height = 16
    Caption = 'ID'
  end
  object Label5: TLabel
    Left = 8
    Top = 136
    Width = 28
    Height = 16
    Caption = 'Char'
  end
  object BtnCreateChr: TSpeedButton
    Left = 8
    Top = 328
    Width = 73
    Height = 25
    Caption = 'Add Char'
    OnClick = BtnCreateChrClick
  end
  object BtnEraseChr: TSpeedButton
    Left = 88
    Top = 328
    Width = 157
    Height = 25
    Caption = 'Remove Char Rcd(HUM)'
    OnClick = BtnEraseChrClick
  end
  object BtnChrNameSearch: TSpeedButton
    Left = 400
    Top = 8
    Width = 38
    Height = 25
    Caption = 'Find'
    OnClick = BtnChrNameSearchClick
  end
  object BtnSelAll: TSpeedButton
    Left = 448
    Top = 8
    Width = 65
    Height = 25
    Caption = 'Find Like'
    OnClick = BtnSelAllClick
  end
  object BtnDeleteChr: TSpeedButton
    Left = 248
    Top = 328
    Width = 89
    Height = 25
    Caption = 'Mark Delete'
    OnClick = BtnDeleteChrClick
  end
  object BtnRevival: TSpeedButton
    Left = 344
    Top = 328
    Width = 104
    Height = 25
    Caption = 'Unmark delete'
    OnClick = BtnRevivalClick
  end
  object SpeedButton1: TSpeedButton
    Left = 8
    Top = 360
    Width = 281
    Height = 25
    Caption = 'Professional FDB record tool'
    OnClick = SpeedButton1Click
  end
  object Label2: TLabel
    Left = 8
    Top = 12
    Width = 13
    Height = 16
    Caption = 'ID'
  end
  object BtnDeleteChrAllInfo: TSpeedButton
    Left = 296
    Top = 360
    Width = 281
    Height = 25
    Caption = 'Remove Charactor'#39's all data (HUM + FDB)'
    OnClick = BtnDeleteChrAllInfoClick
  end
  object SpeedButton2: TSpeedButton
    Left = 456
    Top = 328
    Width = 161
    Height = 25
    Caption = 'Find by index number'
    OnClick = SpeedButton2Click
  end
  object Edit1: TEdit
    Left = 16
    Top = 432
    Width = 113
    Height = 21
    Font.Charset = HANGEUL_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = '굴림'
    Font.Style = []
    ImeName = '한국어(한글) (MS-IME95)'
    ParentFont = False
    PasswordChar = '*'
    TabOrder = 0
    Text = 'Edit1'
  end
  object Edit2: TEdit
    Left = 152
    Top = 432
    Width = 113
    Height = 21
    Font.Charset = HANGEUL_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = '굴림'
    Font.Style = []
    ImeName = '한국어(한글) (MS-IME95)'
    ParentFont = False
    PasswordChar = '*'
    TabOrder = 1
    Text = 'fds'
    OnKeyPress = Edit2KeyPress
  end
  object EdChrName: TEdit
    Left = 280
    Top = 8
    Width = 113
    Height = 24
    ImeName = '한국어(한글) (MS-IME95)'
    TabOrder = 2
    OnKeyPress = EdChrNameKeyPress
  end
  object IdGrid: TStringGrid
    Left = 8
    Top = 56
    Width = 665
    Height = 73
    ColCount = 8
    DefaultRowHeight = 20
    FixedCols = 0
    RowCount = 2
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goColSizing, goEditing]
    TabOrder = 3
    ColWidths = (
      69
      70
      77
      95
      70
      78
      194
      64)
  end
  object ChrGrid: TStringGrid
    Left = 8
    Top = 152
    Width = 665
    Height = 169
    ColCount = 6
    DefaultRowHeight = 20
    FixedCols = 0
    RowCount = 3
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goColSizing, goEditing]
    TabOrder = 4
    OnClick = ChrGridClick
    OnDblClick = ChrGridDblClick
    ColWidths = (
      66
      74
      75
      80
      213
      64)
  end
  object CbShowDelChr: TCheckBox
    Left = 531
    Top = 11
    Width = 110
    Height = 17
    Caption = 'Show with deleted'
    TabOrder = 5
  end
  object Button1: TButton
    Left = 8
    Top = 396
    Width = 165
    Height = 25
    Caption = '관리자정보다시읽기'
    TabOrder = 6
    OnClick = Button1Click
  end
  object EdUserId: TEdit
    Left = 28
    Top = 8
    Width = 133
    Height = 24
    ImeName = '한국어(한글) (MS-IME98)'
    TabOrder = 7
    OnKeyPress = EdUserIdKeyPress
  end
  object Query1: TQuery
    DatabaseName = 'mud_db'
    Left = 352
    Top = 432
  end
end
