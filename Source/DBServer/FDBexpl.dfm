object FrmFDBExplore: TFrmFDBExplore
  Left = 333
  Top = 158
  Width = 585
  Height = 265
  Caption = '!!Watch out!! before push the button....'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 16
    Top = 152
    Width = 26
    Height = 13
    Caption = 'Find :'
  end
  object BtnIDHum: TSpeedButton
    Left = 421
    Top = 200
    Width = 136
    Height = 20
    Caption = 'User ID/Chr Data'
    OnClick = BtnIDHumClick
  end
  object ListBox1: TListBox
    Left = 16
    Top = 8
    Width = 89
    Height = 137
    ImeName = '한국어(한글) (MS-IME95)'
    ItemHeight = 13
    TabOrder = 0
    OnClick = ListBox1Click
  end
  object EdFind: TEdit
    Left = 16
    Top = 168
    Width = 121
    Height = 21
    ImeName = '한국어(한글) (MS-IME95)'
    TabOrder = 1
    OnKeyPress = EdFindKeyPress
  end
  object BtnViewRecord: TButton
    Left = 272
    Top = 8
    Width = 76
    Height = 18
    Caption = 'Vew Rcd'
    TabOrder = 2
    OnClick = BtnViewRecordClick
  end
  object BtnAdd: TButton
    Left = 272
    Top = 78
    Width = 65
    Height = 18
    Caption = 'Add Rcd'
    TabOrder = 3
    OnClick = BtnAddClick
  end
  object BtnDel: TButton
    Left = 272
    Top = 98
    Width = 65
    Height = 25
    Caption = 'Del Rcd'
    TabOrder = 4
    OnClick = BtnDelClick
  end
  object ListBox2: TListBox
    Left = 112
    Top = 8
    Width = 137
    Height = 137
    ImeName = '한국어(한글) (MS-IME95)'
    ItemHeight = 13
    TabOrder = 5
  end
  object BtnRebuild: TButton
    Left = 272
    Top = 174
    Width = 65
    Height = 17
    Caption = 'Rebuild'
    TabOrder = 6
    OnClick = BtnRebuildClick
  end
  object BtnBlankCount: TButton
    Left = 272
    Top = 156
    Width = 65
    Height = 17
    Caption = 'Blank Cnt'
    TabOrder = 7
    OnClick = BtnBlankCountClick
  end
  object GroupBox1: TGroupBox
    Left = 432
    Top = 7
    Width = 121
    Height = 93
    Caption = 'Delete Condition'
    TabOrder = 8
    object BtnAutoClean: TButton
      Left = 8
      Top = 70
      Width = 97
      Height = 17
      Caption = 'Auto Clean'
      TabOrder = 0
      OnClick = BtnAutoCleanClick
    end
    object CkLv1: TCheckBox
      Left = 8
      Top = 12
      Width = 108
      Height = 25
      Caption = 'Level 1 (1 Week)'
      Checked = True
      State = cbChecked
      TabOrder = 1
    end
    object CkLv7: TCheckBox
      Left = 8
      Top = 32
      Width = 108
      Height = 17
      Caption = 'Level 7 (1 Month)'
      Checked = True
      State = cbChecked
      TabOrder = 2
    end
    object CkLv14: TCheckBox
      Left = 8
      Top = 48
      Width = 108
      Height = 17
      Caption = 'Level 14 (4 Month)'
      Checked = True
      State = cbChecked
      TabOrder = 3
    end
  end
  object BtnReloadDir: TButton
    Left = 421
    Top = 178
    Width = 136
    Height = 19
    Caption = 'Reload envirnoment value'
    TabOrder = 9
    OnClick = BtnReloadDirClick
  end
  object BtnCopyRcd: TButton
    Left = 360
    Top = 8
    Width = 65
    Height = 20
    Caption = 'Copy Rcd'
    TabOrder = 10
    OnClick = BtnCopyRcdClick
  end
  object BtnCopyNew: TButton
    Left = 360
    Top = 29
    Width = 66
    Height = 19
    Caption = 'Copy New'
    TabOrder = 11
    OnClick = BtnCopyNewClick
  end
  object BtnViewBackup: TButton
    Left = 272
    Top = 32
    Width = 76
    Height = 17
    Caption = 'View Backup'
    TabOrder = 12
    OnClick = BtnViewBackupClick
  end
  object CkEnableMakeNewChar: TCheckBox
    Left = 416
    Top = 112
    Width = 153
    Height = 17
    Caption = 'Enable Make New Chr.'
    Checked = True
    State = cbChecked
    TabOrder = 13
    OnClick = CkEnableMakeNewCharClick
  end
  object Timer1: TTimer
    Interval = 3000
    OnTimer = Timer1Timer
    Left = 224
    Top = 160
  end
end
