object FrmMain: TFrmMain
  Left = 380
  Top = 99
  Width = 354
  Height = 264
  Caption = 'LogIn Server (ID/Passwd)'
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
  object Panel1: TPanel
    Left = 0
    Top = 39
    Width = 338
    Height = 189
    Align = alClient
    BevelOuter = bvNone
    Caption = ' '
    Color = clTeal
    TabOrder = 0
    object BtnDump: TSpeedButton
      Left = 568
      Top = 2
      Width = 57
      Height = 17
      Caption = 'Dump'
      OnClick = BtnDumpClick
    end
    object MonitorGrid: TStringGrid
      Left = 0
      Top = 39
      Width = 338
      Height = 150
      Align = alClient
      ColCount = 6
      DefaultRowHeight = 17
      FixedCols = 0
      Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goColSizing]
      TabOrder = 0
      ColWidths = (
        65
        50
        40
        65
        50
        40)
    end
    object Panel2: TPanel
      Left = 0
      Top = 0
      Width = 338
      Height = 39
      Align = alTop
      Caption = ' '
      ParentColor = True
      TabOrder = 1
      object Label1: TLabel
        Left = 8
        Top = 22
        Width = 12
        Height = 13
        Caption = '00'
      end
      object SpeedButton1: TSpeedButton
        Left = 148
        Top = 2
        Width = 42
        Height = 17
        Caption = 'ID Tool'
        Flat = True
        OnClick = SpeedButton1Click
      end
      object LbMasCount: TLabel
        Left = 131
        Top = 22
        Width = 60
        Height = 13
        Caption = 'LbMasCount'
      end
      object BtnView: TSpeedButton
        Left = 200
        Top = 2
        Width = 39
        Height = 16
        Caption = 'ID-View'
        Flat = True
        OnClick = BtnViewClick
      end
      object BtnShowServerUsers: TSpeedButton
        Left = 241
        Top = 2
        Width = 42
        Height = 16
        Caption = 'Shw-Sv'
        Flat = True
        OnClick = BtnShowServerUsersClick
      end
      object SpeedButton2: TSpeedButton
        Left = 121
        Top = 2
        Width = 15
        Height = 16
        Caption = '#'
        Flat = True
        OnClick = SpeedButton2Click
      end
      object CkLogin: TCheckBox
        Left = 8
        Top = 1
        Width = 65
        Height = 17
        Caption = 'Login (0)'
        Enabled = False
        TabOrder = 0
      end
      object CbViewLog: TCheckBox
        Left = 56
        Top = 20
        Width = 73
        Height = 17
        Caption = 'View Log'
        TabOrder = 1
      end
    end
  end
  object Memo1: TMemo
    Left = 0
    Top = 0
    Width = 338
    Height = 39
    Align = alTop
    Font.Charset = HANGEUL_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Fixedsys'
    Font.Style = []
    ImeName = #199#209#177#185#190#238'('#199#209#177#219') (MS-IME95)'
    ParentFont = False
    TabOrder = 1
    OnDblClick = Memo1DblClick
  end
  object GSocket: TServerSocket
    Active = False
    Port = 0
    ServerType = stNonBlocking
    OnClientConnect = GSocketClientConnect
    OnClientDisconnect = GSocketClientDisconnect
    OnClientRead = GSocketClientRead
    OnClientError = GSocketClientError
    Left = 17
    Top = 123
  end
  object ExecTimer: TTimer
    Enabled = False
    Interval = 1
    OnTimer = ExecTimerTimer
    Left = 57
    Top = 123
  end
  object Timer1: TTimer
    OnTimer = Timer1Timer
    Left = 97
    Top = 123
  end
  object DebugTimer: TTimer
    Enabled = False
    Interval = 100
    OnTimer = DebugTimerTimer
    Left = 137
    Top = 123
  end
  object StartTimer: TTimer
    OnTimer = StartTimerTimer
    Left = 57
    Top = 155
  end
  object WebLogTimer: TTimer
    Interval = 60000
    OnTimer = WebLogTimerTimer
    Left = 97
    Top = 155
  end
  object LogTimer: TTimer
    OnTimer = LogTimerTimer
    Left = 136
    Top = 155
  end
  object CountLogTimer: TTimer
    Interval = 300000
    OnTimer = CountLogTimerTimer
    Left = 177
    Top = 155
  end
  object MonitorTimer: TTimer
    Interval = 3000
    OnTimer = MonitorTimerTimer
    Left = 216
    Top = 123
  end
end
