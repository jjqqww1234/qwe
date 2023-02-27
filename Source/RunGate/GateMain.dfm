object FrmMain: TFrmMain
  Left = 280
  Top = 105
  Width = 257
  Height = 144
  Caption = 'RunGate (Max=1000)'
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
    Width = 241
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
    Width = 241
    Height = 108
    Align = alBottom
    BevelOuter = bvNone
    Caption = ' '
    TabOrder = 1
    object Label1: TLabel
      Left = 5
      Top = 6
      Width = 59
      Height = 13
      Caption = 'Connections'
    end
    object LbConStatue: TLabel
      Left = 126
      Top = 5
      Width = 3
      Height = 13
      Caption = ' '
    end
    object LbHold: TLabel
      Left = 109
      Top = 6
      Width = 3
      Height = 13
      Caption = ' '
    end
    object LbLack: TLabel
      Left = 180
      Top = 57
      Width = 17
      Height = 13
      Caption = '0/0'
    end
    object Label2: TLabel
      Left = 4
      Top = 36
      Width = 69
      Height = 17
      AutoSize = False
      Caption = '-----'
    end
    object Label3: TLabel
      Left = 68
      Top = 36
      Width = 69
      Height = 17
      AutoSize = False
      Caption = '-----'
    end
    object Label4: TLabel
      Left = 132
      Top = 36
      Width = 117
      Height = 17
      AutoSize = False
      Caption = '-----'
    end
    object Label5: TLabel
      Left = 216
      Top = 5
      Width = 32
      Height = 13
      Alignment = taRightJustify
      Caption = 'Label5'
      OnDblClick = Label5DblClick
    end
    object Label6: TLabel
      Left = 8
      Top = 77
      Width = 22
      Height = 13
      Caption = 'Port:'
    end
    object LbPort: TLabel
      Left = 32
      Top = 77
      Width = 29
      Height = 13
      Caption = '1000'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label7: TLabel
      Left = 216
      Top = 21
      Width = 32
      Height = 13
      Alignment = taRightJustify
      Caption = 'Label5'
      OnDblClick = Label5DblClick
    end
    object EdUserCount: TEdit
      Left = 72
      Top = 2
      Width = 29
      Height = 21
      Color = clWhite
      ImeName = #199#209#177#185#190#238'('#199#209#177#219') (MS-IME95)'
      ReadOnly = True
      TabOrder = 0
      Text = ' '
      OnDblClick = EdUserCountDblClick
    end
    object BtnRun: TButton
      Left = 136
      Top = 52
      Width = 35
      Height = 21
      Caption = 'Run'
      Default = True
      TabOrder = 1
      OnClick = BtnRunClick
    end
    object CbAddrs: TComboBox
      Left = 8
      Top = 52
      Width = 121
      Height = 21
      Style = csDropDownList
      Color = clLime
      ImeName = #199#209#177#185#190#238'('#199#209#177#219') (MS-IME95)'
      ItemHeight = 13
      TabOrder = 2
      OnChange = CbAddrsChange
    end
    object CbDisplay: TCheckBox
      Left = 120
      Top = 76
      Width = 105
      Height = 17
      Caption = 'Show Messages'
      TabOrder = 3
    end
    object CbShowSocData: TCheckBox
      Left = 120
      Top = 92
      Width = 121
      Height = 17
      Caption = 'Show SocketRead'
      TabOrder = 4
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
    Left = 32
    Top = 40
  end
  object SendTimer: TTimer
    Enabled = False
    Interval = 5000
    OnTimer = SendTimerTimer
    Left = 64
    Top = 40
  end
  object ClientSocket: TClientSocket
    Active = False
    ClientType = ctNonBlocking
    Port = 0
    OnConnect = ClientSocketConnect
    OnDisconnect = ClientSocketDisconnect
    OnRead = ClientSocketRead
    OnError = ClientSocketError
    Top = 40
  end
  object Timer1: TTimer
    OnTimer = Timer1Timer
    Left = 96
    Top = 40
  end
  object DecodeTimer: TTimer
    Interval = 1
    OnTimer = DecodeTimerTimer
    Left = 128
    Top = 40
  end
end
