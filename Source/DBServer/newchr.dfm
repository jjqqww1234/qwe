object FrmNewChr: TFrmNewChr
  Left = 205
  Top = 259
  Width = 288
  Height = 145
  Caption = 'FrmNewChr'
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
  object EdName: TEdit
    Left = 24
    Top = 32
    Width = 129
    Height = 21
    ImeName = '한국어(한글) (MS-IME95)'
    TabOrder = 0
    OnKeyPress = EdNameKeyPress
  end
  object Button1: TButton
    Left = 176
    Top = 32
    Width = 75
    Height = 25
    Caption = 'Ok'
    ModalResult = 1
    TabOrder = 1
    OnClick = Button1Click
  end
end
