object FrmFindUserId: TFrmFindUserId
  Left = 189
  Top = 484
  Width = 764
  Height = 200
  Caption = 'Find ID tool'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object IdGrid: TStringGrid
    Left = 0
    Top = 0
    Width = 756
    Height = 135
    Align = alClient
    ColCount = 16
    DefaultRowHeight = 20
    FixedCols = 0
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goColSizing]
    TabOrder = 0
    OnDblClick = BtnEditClick
    ColWidths = (
      64
      64
      71
      91
      89
      150
      141
      169
      170
      83
      90
      72
      76
      182
      159
      218)
  end
  object Panel1: TPanel
    Left = 0
    Top = 135
    Width = 756
    Height = 38
    Align = alBottom
    BevelOuter = bvNone
    Caption = ' '
    TabOrder = 1
    object Label1: TLabel
      Left = 16
      Top = 12
      Width = 34
      Height = 13
      Caption = 'Find ID'
    end
    object EdFindId: TEdit
      Left = 64
      Top = 8
      Width = 121
      Height = 21
      ImeName = '한국어(한글) (MS-IME98)'
      TabOrder = 0
      OnKeyPress = EdFindIdKeyPress
    end
    object BtnFindAll: TButton
      Left = 192
      Top = 8
      Width = 57
      Height = 21
      Caption = 'Find'
      TabOrder = 1
      OnClick = BtnFindAllClick
    end
    object Button1: TButton
      Left = 642
      Top = 10
      Width = 75
      Height = 21
      Caption = 'Reload Addrs'
      TabOrder = 2
      OnClick = Button1Click
    end
    object BtnEdit: TButton
      Left = 288
      Top = 8
      Width = 75
      Height = 21
      Caption = 'Edit'
      TabOrder = 3
      OnClick = BtnEditClick
    end
    object Button2: TButton
      Left = 376
      Top = 8
      Width = 75
      Height = 21
      Caption = 'Add'
      TabOrder = 4
      OnClick = Button2Click
    end
  end
end
