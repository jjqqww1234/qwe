object FrmCopyRcd: TFrmCopyRcd
  Left = 351
  Top = 132
  Width = 295
  Height = 209
  Caption = 'FrmCopyRcd'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 24
    Top = 24
    Width = 57
    Height = 13
    Caption = 'Source Rcd'
  end
  object Label2: TLabel
    Left = 24
    Top = 48
    Width = 54
    Height = 13
    Caption = 'Target Rcd'
  end
  object Label3: TLabel
    Left = 24
    Top = 72
    Width = 36
    Height = 13
    Caption = 'User ID'
  end
  object Edit1: TEdit
    Left = 96
    Top = 24
    Width = 121
    Height = 21
    ImeName = '한국어(한글) (MS-IME95)'
    TabOrder = 0
  end
  object Edit2: TEdit
    Left = 96
    Top = 48
    Width = 121
    Height = 21
    ImeName = '한국어(한글) (MS-IME95)'
    TabOrder = 1
  end
  object BitBtn1: TBitBtn
    Left = 48
    Top = 128
    Width = 75
    Height = 25
    TabOrder = 3
    Kind = bkOK
  end
  object BitBtn2: TBitBtn
    Left = 168
    Top = 128
    Width = 75
    Height = 25
    TabOrder = 4
    Kind = bkCancel
  end
  object EdWithID: TEdit
    Left = 96
    Top = 72
    Width = 121
    Height = 21
    ImeName = '한국어(한글) (MS-IME98)'
    TabOrder = 2
  end
end
