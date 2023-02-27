object FrmCreateId: TFrmCreateId
  Left = 448
  Top = 199
  Width = 317
  Height = 172
  Caption = '새 아이디 만들기'
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
    Left = 64
    Top = 28
    Width = 12
    Height = 13
    Caption = 'ID'
  end
  object Label2: TLabel
    Left = 43
    Top = 52
    Width = 64
    Height = 13
    Caption = 'Password'
  end
  object EdId: TEdit
    Left = 120
    Top = 24
    Width = 121
    Height = 21
    ImeName = '한국어(한글) (MS-IME95)'
    TabOrder = 0
  end
  object EdPasswd: TEdit
    Left = 120
    Top = 48
    Width = 121
    Height = 21
    ImeName = '한국어(한글) (MS-IME95)'
    TabOrder = 1
  end
  object BitBtn1: TBitBtn
    Left = 48
    Top = 96
    Width = 75
    Height = 25
    TabOrder = 2
    Kind = bkOK
  end
  object BitBtn2: TBitBtn
    Left = 192
    Top = 96
    Width = 75
    Height = 25
    TabOrder = 3
    Kind = bkCancel
  end
end
