object FrmEditAddr: TFrmEditAddr
  Left = 353
  Top = 131
  Width = 636
  Height = 303
  Caption = 'Edit Connection Address'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object AddrGrid: TStringGrid
    Left = 0
    Top = 0
    Width = 628
    Height = 235
    Align = alClient
    ColCount = 7
    DefaultRowHeight = 20
    FixedCols = 0
    RowCount = 9
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goColSizing, goEditing]
    TabOrder = 0
    ColWidths = (
      106
      100
      55
      98
      46
      100
      64)
  end
  object Panel1: TPanel
    Left = 0
    Top = 235
    Width = 628
    Height = 41
    Align = alBottom
    BevelOuter = bvNone
    Caption = ' '
    TabOrder = 1
    object Label1: TLabel
      Left = 8
      Top = 12
      Width = 22
      Height = 13
      Caption = 'Row'
    end
    object BtnApplyRow: TSpeedButton
      Left = 120
      Top = 8
      Width = 57
      Height = 22
      Caption = 'Row Apply'
      OnClick = BtnApplyRowClick
    end
    object BtnApplyAndClose: TButton
      Left = 480
      Top = 8
      Width = 113
      Height = 25
      Caption = 'Apply and Close'
      TabOrder = 0
      OnClick = BtnApplyAndCloseClick
    end
    object ERowCount: TSpinEdit
      Left = 40
      Top = 8
      Width = 73
      Height = 22
      MaxValue = 0
      MinValue = 0
      TabOrder = 1
      Value = 0
    end
  end
end
