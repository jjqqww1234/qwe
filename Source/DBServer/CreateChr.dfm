object FrmCreateChr: TFrmCreateChr
  Left = 423
  Top = 356
  Width = 292
  Height = 187
  Caption = '새 캐릭터 만들기'
  Color = clBtnFace
  Font.Charset = HANGEUL_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = '굴림'
  Font.Style = []
  OldCreateOrder = False
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 48
    Top = 28
    Width = 12
    Height = 13
    Caption = 'ID'
  end
  object Label2: TLabel
    Left = 28
    Top = 60
    Width = 70
    Height = 13
    Caption = 'Char Name'
  end
  object EdUserId: TEdit
    Left = 104
    Top = 24
    Width = 121
    Height = 21
    ImeName = '한국어(한글) (MS-IME95)'
    TabOrder = 0
  end
  object EdChrName: TEdit
    Left = 104
    Top = 56
    Width = 121
    Height = 21
    ImeName = '한국어(한글) (MS-IME95)'
    TabOrder = 1
  end
  object BitBtn1: TBitBtn
    Left = 32
    Top = 112
    Width = 75
    Height = 25
    TabOrder = 2
    Kind = bkOK
  end
  object BitBtn2: TBitBtn
    Left = 176
    Top = 112
    Width = 75
    Height = 25
    TabOrder = 3
    Kind = bkCancel
  end
end
