object FrmMain: TFrmMain
  Left = 338
  Top = 116
  Width = 253
  Height = 114
  Caption = 'SelGate'
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
  PixelsPerInch = 96
  TextHeight = 13
  object Memo: TMemo
    Left = 0
    Top = 0
    Width = 237
    Height = 0
    Align = alClient
    ImeName = #199#209#177#185#190#238'('#199#209#177#219') (MS-IME95)'
    TabOrder = 0
    OnChange = MemoChange
    OnDblClick = MemoDblClick
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 237
    Height = 78
    Align = alBottom
    BevelOuter = bvNone
    Caption = ' '
    TabOrder = 1
    object Label1: TLabel
      Left = 5
      Top = 9
      Width = 59
      Height = 13
      Caption = 'Connections'
    end
    object LbConStatue: TLabel
      Left = 130
      Top = 8
      Width = 3
      Height = 13
      Caption = ' '
    end
    object LbHold: TLabel
      Left = 98
      Top = 9
      Width = 3
      Height = 13
      Caption = ' '
    end
    object LbLack: TLabel
      Left = 180
      Top = 30
      Width = 17
      Height = 13
      Caption = '0/0'
    end
    object Label2: TLabel
      Left = 184
      Top = 10
      Width = 32
      Height = 13
      Caption = 'Label2'
    end
    object EdUserCount: TEdit
      Left = 69
      Top = 5
      Width = 36
      Height = 21
      ImeName = #199#209#177#185#190#238'('#199#209#177#219') (MS-IME95)'
      ReadOnly = True
      TabOrder = 0
      Text = ' '
    end
    object BtnRun: TButton
      Left = 136
      Top = 28
      Width = 35
      Height = 21
      Caption = 'Run'
      Default = True
      TabOrder = 1
      OnClick = BtnRunClick
    end
    object CbAddrs: TComboBox
      Left = 8
      Top = 28
      Width = 121
      Height = 21
      Style = csDropDownList
      ImeName = #199#209#177#185#190#238'('#199#209#177#219') (MS-IME95)'
      ItemHeight = 13
      TabOrder = 2
      OnChange = CbAddrsChange
    end
    object CbShowMessages: TCheckBox
      Left = 8
      Top = 54
      Width = 97
      Height = 17
      Caption = 'Show Messages'
      TabOrder = 3
    end
  end
  object ServerSocket: TServerSocket
    Active = False
    Port = 0
    ServerType = stNonBlocking
    OnClientConnect = ServerSocketClientConnect
    OnClientDisconnect = ServerSocketClientDisconnect
    OnClientRead = ServerSocketClientRead
    OnClientError = ServerSocketClientError
    Left = 40
    Top = 16
  end
  object SendTimer: TTimer
    Enabled = False
    Interval = 3000
    OnTimer = SendTimerTimer
    Left = 72
    Top = 16
  end
  object ClientSocket: TClientSocket
    Active = False
    ClientType = ctNonBlocking
    Port = 0
    OnConnect = ClientSocketConnect
    OnDisconnect = ClientSocketDisconnect
    OnRead = ClientSocketRead
    OnError = ClientSocketError
    Left = 8
    Top = 16
  end
  object Timer1: TTimer
    OnTimer = Timer1Timer
    Left = 104
    Top = 16
  end
  object DecodeTimer: TTimer
    Interval = 1
    OnTimer = DecodeTimerTimer
    Left = 144
    Top = 16
  end
end
