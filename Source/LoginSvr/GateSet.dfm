object FrmGateSetting: TFrmGateSetting
  Left = 318
  Top = 238
  Width = 482
  Height = 375
  Caption = 'Gate 접속 제어창'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Label2: TLabel
    Left = 8
    Top = 44
    Width = 23
    Height = 13
    Caption = 'Gate'
  end
  object Label3: TLabel
    Left = 64
    Top = 96
    Width = 74
    Height = 13
    Caption = 'Private Address'
  end
  object Label4: TLabel
    Left = 240
    Top = 96
    Width = 70
    Height = 13
    Caption = 'Public Address'
  end
  object Label5: TLabel
    Left = 48
    Top = 152
    Width = 51
    Height = 13
    Caption = '접속 주소'
  end
  object Label6: TLabel
    Left = 184
    Top = 152
    Width = 48
    Height = 13
    Caption = '사용가능'
  end
  object Label7: TLabel
    Left = 272
    Top = 152
    Width = 51
    Height = 13
    Caption = '접속 주소'
  end
  object Label8: TLabel
    Left = 408
    Top = 152
    Width = 48
    Height = 13
    Caption = '사용가능'
  end
  object Label9: TLabel
    Left = 31
    Top = 172
    Width = 6
    Height = 13
    Caption = '1'
  end
  object Label10: TLabel
    Left = 31
    Top = 196
    Width = 6
    Height = 13
    Caption = '2'
  end
  object Label11: TLabel
    Left = 31
    Top = 220
    Width = 6
    Height = 13
    Caption = '3'
  end
  object Label12: TLabel
    Left = 31
    Top = 244
    Width = 6
    Height = 13
    Caption = '4'
  end
  object Label13: TLabel
    Left = 31
    Top = 268
    Width = 6
    Height = 13
    Caption = '5'
  end
  object Label14: TLabel
    Left = 255
    Top = 172
    Width = 6
    Height = 13
    Caption = '6'
  end
  object Label15: TLabel
    Left = 255
    Top = 196
    Width = 6
    Height = 13
    Caption = '7'
  end
  object Label16: TLabel
    Left = 255
    Top = 220
    Width = 6
    Height = 13
    Caption = '8'
  end
  object Label17: TLabel
    Left = 255
    Top = 244
    Width = 6
    Height = 13
    Caption = '9'
  end
  object Label18: TLabel
    Left = 255
    Top = 268
    Width = 12
    Height = 13
    Caption = '10'
  end
  object BtnChangeTitle: TSpeedButton
    Left = 400
    Top = 40
    Width = 57
    Height = 22
    Caption = '이름변경'
    OnClick = BtnChangeTitleClick
  end
  object Label1: TLabel
    Left = 8
    Top = 12
    Width = 24
    Height = 13
    Caption = '서버'
  end
  object CbGateList: TComboBox
    Left = 40
    Top = 40
    Width = 193
    Height = 21
    Style = csDropDownList
    ImeName = '한국어(한글) (MS-IME95)'
    ItemHeight = 13
    TabOrder = 0
    OnChange = CbGateListChange
  end
  object EdPrivateAddr: TEdit
    Left = 64
    Top = 112
    Width = 121
    Height = 21
    ImeName = '한국어(한글) (MS-IME95)'
    TabOrder = 1
    Text = '5.5.2.1'
  end
  object EdPublicAddr: TEdit
    Left = 240
    Top = 112
    Width = 121
    Height = 21
    ImeName = '한국어(한글) (MS-IME95)'
    TabOrder = 2
    Text = '210.121.143.202'
  end
  object CkGate1: TCheckBox
    Left = 200
    Top = 168
    Width = 15
    Height = 17
    Caption = 'CkGate1'
    Checked = True
    State = cbChecked
    TabOrder = 3
  end
  object EdGate1: TEdit
    Left = 48
    Top = 168
    Width = 121
    Height = 21
    ImeName = '한국어(한글) (MS-IME95)'
    TabOrder = 4
    Text = '210.121.143.202'
  end
  object CkGate2: TCheckBox
    Left = 200
    Top = 192
    Width = 15
    Height = 17
    Caption = 'CheckBox1'
    Checked = True
    State = cbChecked
    TabOrder = 5
  end
  object EdGate2: TEdit
    Left = 48
    Top = 192
    Width = 121
    Height = 21
    ImeName = '한국어(한글) (MS-IME95)'
    TabOrder = 6
    Text = '210.121.143.203'
  end
  object CkGate3: TCheckBox
    Left = 200
    Top = 216
    Width = 15
    Height = 17
    Caption = 'CheckBox1'
    Checked = True
    State = cbChecked
    TabOrder = 7
  end
  object EdGate3: TEdit
    Left = 48
    Top = 216
    Width = 121
    Height = 21
    ImeName = '한국어(한글) (MS-IME95)'
    TabOrder = 8
    Text = '210.121.143.203'
  end
  object CkGate4: TCheckBox
    Left = 200
    Top = 240
    Width = 15
    Height = 17
    Caption = 'CheckBox1'
    Checked = True
    State = cbChecked
    TabOrder = 9
  end
  object EdGate4: TEdit
    Left = 48
    Top = 240
    Width = 121
    Height = 21
    ImeName = '한국어(한글) (MS-IME95)'
    TabOrder = 10
    Text = '210.121.143.203'
  end
  object CkGate5: TCheckBox
    Left = 200
    Top = 264
    Width = 15
    Height = 17
    Caption = 'CheckBox1'
    Checked = True
    State = cbChecked
    TabOrder = 11
  end
  object EdGate5: TEdit
    Left = 48
    Top = 264
    Width = 121
    Height = 21
    ImeName = '한국어(한글) (MS-IME95)'
    TabOrder = 12
    Text = '210.121.143.203'
  end
  object CkGate6: TCheckBox
    Left = 424
    Top = 168
    Width = 15
    Height = 17
    Caption = 'CheckBox1'
    Checked = True
    State = cbChecked
    TabOrder = 13
  end
  object EdGate6: TEdit
    Left = 272
    Top = 168
    Width = 121
    Height = 21
    ImeName = '한국어(한글) (MS-IME95)'
    TabOrder = 14
    Text = '210.121.143.203'
  end
  object CkGate7: TCheckBox
    Left = 424
    Top = 192
    Width = 15
    Height = 17
    Caption = 'CheckBox1'
    Checked = True
    State = cbChecked
    TabOrder = 15
  end
  object EdGate7: TEdit
    Left = 272
    Top = 192
    Width = 121
    Height = 21
    ImeName = '한국어(한글) (MS-IME95)'
    TabOrder = 16
    Text = '210.121.143.203'
  end
  object CkGate8: TCheckBox
    Left = 424
    Top = 216
    Width = 15
    Height = 17
    Caption = 'CheckBox1'
    Checked = True
    State = cbChecked
    TabOrder = 17
  end
  object EdGate8: TEdit
    Left = 272
    Top = 216
    Width = 121
    Height = 21
    ImeName = '한국어(한글) (MS-IME95)'
    TabOrder = 18
    Text = '210.121.143.203'
  end
  object CkGate9: TCheckBox
    Left = 424
    Top = 240
    Width = 15
    Height = 17
    Caption = 'CheckBox1'
    Checked = True
    State = cbChecked
    TabOrder = 19
  end
  object EdGate9: TEdit
    Left = 272
    Top = 240
    Width = 121
    Height = 21
    ImeName = '한국어(한글) (MS-IME95)'
    TabOrder = 20
    Text = '210.121.143.203'
  end
  object CkGate10: TCheckBox
    Left = 424
    Top = 264
    Width = 15
    Height = 17
    Caption = 'CheckBox1'
    Checked = True
    State = cbChecked
    TabOrder = 21
  end
  object EdGate10: TEdit
    Left = 272
    Top = 264
    Width = 121
    Height = 21
    ImeName = '한국어(한글) (MS-IME95)'
    TabOrder = 22
    Text = '210.121.143.203'
  end
  object BtnOk: TBitBtn
    Left = 64
    Top = 312
    Width = 105
    Height = 25
    Caption = '설정적용'
    TabOrder = 23
    OnClick = BtnOkClick
    Glyph.Data = {
      DE010000424DDE01000000000000760000002800000024000000120000000100
      0400000000006801000000000000000000001000000010000000000000000000
      80000080000000808000800000008000800080800000C0C0C000808080000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
      3333333333333333333333330000333333333333333333333333F33333333333
      00003333344333333333333333388F3333333333000033334224333333333333
      338338F3333333330000333422224333333333333833338F3333333300003342
      222224333333333383333338F3333333000034222A22224333333338F338F333
      8F33333300003222A3A2224333333338F3838F338F33333300003A2A333A2224
      33333338F83338F338F33333000033A33333A222433333338333338F338F3333
      0000333333333A222433333333333338F338F33300003333333333A222433333
      333333338F338F33000033333333333A222433333333333338F338F300003333
      33333333A222433333333333338F338F00003333333333333A22433333333333
      3338F38F000033333333333333A223333333333333338F830000333333333333
      333A333333333333333338330000333333333333333333333333333333333333
      0000}
    NumGlyphs = 2
  end
  object BtnClose: TBitBtn
    Left = 336
    Top = 312
    Width = 75
    Height = 25
    TabOrder = 24
    Kind = bkClose
  end
  object EdTitle: TEdit
    Left = 272
    Top = 40
    Width = 121
    Height = 21
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ImeName = '한국어(한글) (MS-IME95)'
    ParentFont = False
    TabOrder = 25
  end
  object CbServerList: TComboBox
    Left = 40
    Top = 8
    Width = 193
    Height = 21
    Style = csDropDownList
    ImeName = '한국어(한글) (MS-IME98)'
    ItemHeight = 13
    TabOrder = 26
    OnChange = CbServerListChange
  end
end
