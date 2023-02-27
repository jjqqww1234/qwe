object FrmAccountView: TFrmAccountView
  Left = 377
  Top = 120
  Width = 410
  Height = 483
  Caption = '계정 리스트'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object EdFindID: TEdit
    Left = 8
    Top = 408
    Width = 193
    Height = 21
    ImeName = '한국어(한글) (MS-IME98)'
    TabOrder = 0
    OnKeyPress = EdFindIDKeyPress
  end
  object EdFindIP: TEdit
    Left = 208
    Top = 408
    Width = 185
    Height = 21
    ImeName = '한국어(한글) (MS-IME98)'
    TabOrder = 1
    OnKeyPress = EdFindIPKeyPress
  end
  object ListBox1: TListBox
    Left = 8
    Top = 8
    Width = 193
    Height = 393
    ImeName = '한국어(한글) (MS-IME98)'
    ItemHeight = 13
    TabOrder = 2
  end
  object ListBox2: TListBox
    Left = 208
    Top = 8
    Width = 193
    Height = 393
    ImeName = '한국어(한글) (MS-IME98)'
    ItemHeight = 13
    TabOrder = 3
  end
end
