object FrmDBSrv: TFrmDBSrv
  Left = 541
  Top = 133
  Width = 315
  Height = 225
  HorzScrollBar.Visible = False
  VertScrollBar.Visible = False
  Caption = 'SelChr/Hum/DB Server'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Memo1: TMemo
    Left = 0
    Top = 64
    Width = 307
    Height = 68
    Align = alClient
    ImeName = #199#209#177#185#190#238'('#199#209#177#219') (MS-IME95)'
    TabOrder = 0
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 307
    Height = 64
    Align = alTop
    BevelOuter = bvNone
    Caption = ' '
    TabOrder = 1
    object Label1: TLabel
      Left = 8
      Top = 17
      Width = 75
      Height = 13
      Alignment = taCenter
      Caption = 'Disconnected !!'
    end
    object Label3: TLabel
      Left = 10
      Top = 1
      Width = 32
      Height = 13
      Caption = 'Label3'
    end
    object Label4: TLabel
      Left = 50
      Top = 1
      Width = 32
      Height = 13
      Caption = 'Label4'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clMaroon
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object LbAutoClean: TLabel
      Left = 230
      Top = 1
      Width = 34
      Height = 13
      Caption = 'LbAuto'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clGray
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object LbTransCount: TLabel
      Left = 204
      Top = 17
      Width = 67
      Height = 13
      Caption = 'LbTransCount'
    end
    object Label2: TLabel
      Left = 111
      Top = 17
      Width = 68
      Height = 13
      Alignment = taRightJustify
      Caption = 'Connections 0'
    end
    object Label6: TLabel
      Left = 8
      Top = 32
      Width = 84
      Height = 13
      Caption = 'User Connections'
    end
    object LbUserCount: TLabel
      Left = 96
      Top = 32
      Width = 36
      Height = 13
      Caption = '000000'
    end
    object Label8: TLabel
      Left = 8
      Top = 48
      Width = 32
      Height = 13
      Caption = 'Label8'
    end
    object Label9: TLabel
      Left = 80
      Top = 48
      Width = 32
      Height = 13
      Caption = 'Label9'
    end
    object Label10: TLabel
      Left = 152
      Top = 48
      Width = 38
      Height = 13
      Caption = 'Label10'
    end
    object Label11: TLabel
      Left = 224
      Top = 48
      Width = 38
      Height = 13
      Caption = 'Label11'
    end
    object CkViewHackMsg: TCheckBox
      Left = 152
      Top = 32
      Width = 113
      Height = 17
      Caption = 'View Hack-Msgs'
      TabOrder = 0
      OnClick = CkViewHackMsgClick
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 132
    Width = 307
    Height = 59
    Align = alBottom
    BevelOuter = bvNone
    Caption = ' '
    Color = clSkyBlue
    TabOrder = 2
    object Label5: TLabel
      Left = 0
      Top = 0
      Width = 307
      Height = 33
      Align = alTop
      AutoSize = False
      Caption = 'Label5'
      WordWrap = True
    end
    object BtnUserDBTool: TSpeedButton
      Left = 128
      Top = 39
      Width = 169
      Height = 17
      Caption = 'Record Tools'
      OnClick = BtnUserDBToolClick
    end
    object BtnReloadAddr: TButton
      Left = 232
      Top = 20
      Width = 65
      Height = 17
      Caption = 'Reload Addr'
      TabOrder = 0
      OnClick = BtnReloadAddrClick
    end
    object BtnEditAddrs: TButton
      Left = 166
      Top = 20
      Width = 61
      Height = 17
      Caption = 'Edit Addrs'
      TabOrder = 1
      OnClick = BtnEditAddrsClick
    end
  end
  object ServerSocket1: TServerSocket
    Active = False
    Port = 6000
    ServerType = stNonBlocking
    OnClientConnect = ServerSocket1ClientConnect
    OnClientDisconnect = ServerSocket1ClientDisconnect
    OnClientRead = ServerSocket1ClientRead
    OnClientError = ServerSocket1ClientError
    Left = 140
    Top = 80
  end
  object Timer1: TTimer
    OnTimer = Timer1Timer
    Left = 268
    Top = 80
  end
  object AniTimer: TTimer
    Interval = 300
    OnTimer = AniTimerTimer
    Left = 236
    Top = 80
  end
  object StartTimer: TTimer
    Enabled = False
    Interval = 100
    OnTimer = StartTimerTimer
    Left = 236
    Top = 112
  end
  object Timer2: TTimer
    Interval = 5000
    OnTimer = Timer2Timer
    Left = 268
    Top = 112
  end
end
