object FrmMain: TFrmMain
  Left = 232
  Top = 136
  Width = 366
  Height = 530
  Caption = 'FrmMain'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = MainMenu
  OldCreateOrder = False
  Position = poDesktopCenter
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Memo1: TMemo
    Left = 0
    Top = 0
    Width = 358
    Height = 351
    Align = alClient
    ImeName = #199#209#177#185#190#238'('#199#209#177#219') (MS-IME95)'
    ScrollBars = ssVertical
    TabOrder = 0
  end
  object Panel1: TPanel
    Left = 0
    Top = 351
    Width = 358
    Height = 125
    Align = alBottom
    BevelInner = bvLowered
    BevelOuter = bvNone
    Caption = ' '
    TabOrder = 1
    OnDblClick = Panel1DblClick
    object LbRunTime: TLabel
      Left = 168
      Top = 8
      Width = 55
      Height = 13
      Caption = 'LbRunTime'
    end
    object LbUserCount: TLabel
      Left = 319
      Top = 8
      Width = 28
      Height = 13
      Alignment = taRightJustify
      Caption = 'Count'
    end
    object Label1: TLabel
      Left = 8
      Top = 8
      Width = 32
      Height = 13
      Caption = 'Label1'
    end
    object Label2: TLabel
      Left = 8
      Top = 21
      Width = 32
      Height = 13
      Caption = 'Label2'
    end
    object Label3: TLabel
      Left = 1
      Top = 71
      Width = 356
      Height = 53
      Align = alBottom
      AutoSize = False
      Caption = 'Label3'
      Color = clBtnShadow
      ParentColor = False
      WordWrap = True
    end
    object Label4: TLabel
      Left = 0
      Top = 58
      Width = 200
      Height = 13
      Caption = '** B-Count/Remain SendBytes SendCount'
      Color = clBtnShadow
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsUnderline]
      ParentColor = False
      ParentFont = False
    end
    object LbTimeCount: TLabel
      Left = 204
      Top = 58
      Width = 63
      Height = 13
      Caption = 'LbTimeCount'
    end
    object Label5: TLabel
      Left = 8
      Top = 34
      Width = 32
      Height = 13
      Caption = 'Label5'
    end
  end
  object GateSocket: TServerSocket
    Active = True
    Port = 5000
    ServerType = stNonBlocking
    OnClientConnect = GateSocketClientConnect
    OnClientDisconnect = GateSocketClientDisconnect
    OnClientRead = GateSocketClientRead
    OnClientError = GateSocketClientError
    Left = 24
    Top = 16
  end
  object DBSocket: TClientSocket
    Active = False
    ClientType = ctNonBlocking
    Port = 6000
    OnConnect = DBSocketConnect
    OnDisconnect = DBSocketDisconnect
    OnRead = DBSocketRead
    OnError = DBSocketError
    Left = 24
    Top = 48
  end
  object ConnectTimer: TTimer
    Enabled = False
    Interval = 30000
    OnTimer = ConnectTimerTimer
    Left = 64
    Top = 48
  end
  object Timer1: TTimer
    Enabled = False
    Interval = 2000
    OnTimer = Timer1Timer
    Left = 64
    Top = 16
  end
  object RunTimer: TTimer
    Enabled = False
    Interval = 1
    OnTimer = RunTimerTimer
    Left = 96
    Top = 16
  end
  object TCloseTimer: TTimer
    Enabled = False
    Interval = 100
    OnTimer = TCloseTimerTimer
    Left = 96
    Top = 48
  end
  object StartTimer: TTimer
    Enabled = False
    Interval = 100
    OnTimer = StartTimerTimer
    Left = 128
    Top = 16
  end
  object SaveVariableTimer: TTimer
    Interval = 10000
    OnTimer = SaveVariableTimerTimer
    Left = 160
    Top = 16
  end
  object IdUDPClient: TIdUDPClient
    Port = 0
    Left = 24
    Top = 80
  end
  object MainMenu: TMainMenu
    Left = 64
    Top = 80
    object Service1: TMenuItem
      Caption = '&Service'
      object Initialize1: TMenuItem
        Caption = '&Initialize'
        OnClick = Initialize1Click
      end
      object Reload1: TMenuItem
        Caption = 'Reload'
        object AdminList1: TMenuItem
          Caption = 'AdminList'
          OnClick = AdminList1Click
        end
        object ChatLogList1: TMenuItem
          Caption = 'ChatLogList'
          OnClick = ChatLogList1Click
        end
      end
      object N1: TMenuItem
        Caption = '-'
      end
      object Exit1: TMenuItem
        Caption = 'E&xit'
        OnClick = Exit1Click
      end
    end
    object Help1: TMenuItem
      Caption = '&Help'
    end
  end
end
