object FrmUserInfoEdit: TFrmUserInfoEdit
  Left = 679
  Top = 101
  Width = 316
  Height = 441
  Caption = 'FrmUserInfoEdit'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 16
    Top = 16
    Width = 11
    Height = 13
    Caption = 'ID'
  end
  object Label2: TLabel
    Left = 16
    Top = 40
    Width = 37
    Height = 13
    Caption = 'Passwd'
  end
  object Label3: TLabel
    Left = 16
    Top = 64
    Width = 50
    Height = 13
    Caption = 'UserName'
  end
  object Label4: TLabel
    Left = 16
    Top = 112
    Width = 40
    Height = 13
    Caption = 'BirthDay'
  end
  object Label5: TLabel
    Left = 16
    Top = 232
    Width = 31
    Height = 13
    Caption = 'Phone'
  end
  object Label9: TLabel
    Left = 16
    Top = 88
    Width = 28
    Height = 13
    Caption = 'SSNo'
  end
  object Label6: TLabel
    Left = 16
    Top = 136
    Width = 30
    Height = 13
    Caption = 'Quiz 1'
  end
  object Label7: TLabel
    Left = 16
    Top = 160
    Width = 44
    Height = 13
    Caption = 'Answer 1'
  end
  object Label10: TLabel
    Left = 16
    Top = 184
    Width = 30
    Height = 13
    Caption = 'Quiz 2'
  end
  object Label11: TLabel
    Left = 16
    Top = 208
    Width = 44
    Height = 13
    Caption = 'Answer 2'
  end
  object Label12: TLabel
    Left = 16
    Top = 256
    Width = 44
    Height = 13
    Caption = 'Mobile P.'
  end
  object Label13: TLabel
    Left = 16
    Top = 280
    Width = 38
    Height = 13
    Caption = 'Memo 1'
  end
  object Label14: TLabel
    Left = 16
    Top = 304
    Width = 38
    Height = 13
    Caption = 'Memo 2'
  end
  object Label8: TLabel
    Left = 16
    Top = 328
    Width = 54
    Height = 13
    Caption = 'E-Mail Addr'
  end
  object EdId: TEdit
    Left = 80
    Top = 16
    Width = 121
    Height = 21
    Enabled = False
    ImeName = '한국어(한글) (MS-IME98)'
    MaxLength = 10
    TabOrder = 0
  end
  object EdPasswd: TEdit
    Left = 80
    Top = 40
    Width = 121
    Height = 21
    ImeName = '한국어(한글) (MS-IME98)'
    MaxLength = 10
    TabOrder = 1
  end
  object EdUserName: TEdit
    Left = 80
    Top = 64
    Width = 121
    Height = 21
    ImeName = '한국어(한글) (MS-IME98)'
    MaxLength = 20
    TabOrder = 2
  end
  object EdBirthDay: TEdit
    Left = 80
    Top = 112
    Width = 121
    Height = 21
    ImeName = '한국어(한글) (MS-IME98)'
    MaxLength = 10
    TabOrder = 4
  end
  object EdPhone: TEdit
    Left = 80
    Top = 232
    Width = 121
    Height = 21
    ImeName = '한국어(한글) (MS-IME98)'
    MaxLength = 14
    TabOrder = 9
  end
  object Button1: TButton
    Left = 72
    Top = 376
    Width = 75
    Height = 25
    Caption = '확인'
    ModalResult = 1
    TabOrder = 14
  end
  object Button2: TButton
    Left = 208
    Top = 376
    Width = 75
    Height = 25
    Caption = '취소'
    ModalResult = 2
    TabOrder = 15
  end
  object CkFullEdit: TCheckBox
    Left = 216
    Top = 16
    Width = 73
    Height = 17
    Caption = '전체편집'
    TabOrder = 16
    OnClick = CkFullEditClick
  end
  object EdSSNo: TEdit
    Left = 80
    Top = 88
    Width = 121
    Height = 21
    ImeName = '한국어(한글) (MS-IME98)'
    MaxLength = 14
    TabOrder = 3
  end
  object EdQuiz: TEdit
    Left = 80
    Top = 136
    Width = 209
    Height = 21
    ImeName = '한국어(한글) (MS-IME98)'
    MaxLength = 20
    TabOrder = 5
  end
  object EdAnswer: TEdit
    Left = 80
    Top = 160
    Width = 209
    Height = 21
    ImeName = '한국어(한글) (MS-IME98)'
    MaxLength = 12
    TabOrder = 6
  end
  object EdQuiz2: TEdit
    Left = 80
    Top = 184
    Width = 209
    Height = 21
    ImeName = '한국어(한글) (MS-IME98)'
    MaxLength = 20
    TabOrder = 7
  end
  object EdAnswer2: TEdit
    Left = 80
    Top = 208
    Width = 209
    Height = 21
    ImeName = '한국어(한글) (MS-IME98)'
    MaxLength = 12
    TabOrder = 8
  end
  object EdMobilePhone: TEdit
    Left = 80
    Top = 256
    Width = 121
    Height = 21
    ImeName = '한국어(한글) (MS-IME98)'
    MaxLength = 13
    TabOrder = 10
  end
  object EdMemo1: TEdit
    Left = 80
    Top = 280
    Width = 185
    Height = 21
    ImeName = '한국어(한글) (MS-IME98)'
    MaxLength = 20
    TabOrder = 11
  end
  object EdMemo2: TEdit
    Left = 80
    Top = 304
    Width = 185
    Height = 21
    ImeName = '한국어(한글) (MS-IME98)'
    MaxLength = 20
    TabOrder = 12
  end
  object EdEMail: TEdit
    Left = 80
    Top = 328
    Width = 209
    Height = 21
    ImeName = '한국어(한글) (MS-IME98)'
    MaxLength = 40
    TabOrder = 13
  end
end
