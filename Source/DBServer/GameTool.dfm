object Form1: TForm1
  Left = 314
  Top = 47
  Width = 615
  Height = 309
  Caption = 'Form1'
  Color = clBtnFace
  Font.Charset = HANGEUL_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = '굴림'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 20
    Top = 12
    Width = 39
    Height = 13
    Caption = '아이디'
  end
  object Label2: TLabel
    Left = 228
    Top = 12
    Width = 52
    Height = 13
    Caption = '캐릭이름'
  end
  object SpeedButton1: TSpeedButton
    Left = 168
    Top = 8
    Width = 41
    Height = 22
    Caption = '찾기'
  end
  object SpeedButton2: TSpeedButton
    Left = 388
    Top = 8
    Width = 41
    Height = 22
    Caption = '찾기'
  end
  object Edit1: TEdit
    Left = 64
    Top = 8
    Width = 101
    Height = 21
    ImeName = '한국어(한글) (MS-IME95)'
    TabOrder = 0
  end
  object Edit2: TEdit
    Left = 284
    Top = 8
    Width = 101
    Height = 21
    ImeName = '한국어(한글) (MS-IME95)'
    TabOrder = 1
  end
  object StringGrid1: TStringGrid
    Left = 8
    Top = 36
    Width = 589
    Height = 61
    ColCount = 7
    DefaultRowHeight = 18
    FixedCols = 0
    RowCount = 2
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goRangeSelect]
    TabOrder = 2
    ColWidths = (
      72
      66
      74
      81
      64
      64
      125)
  end
  object StringGrid2: TStringGrid
    Left = 8
    Top = 100
    Width = 589
    Height = 89
    DefaultRowHeight = 18
    FixedCols = 0
    RowCount = 2
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goRangeSelect]
    TabOrder = 3
    ColWidths = (
      72
      66
      74
      209
      64)
  end
end
