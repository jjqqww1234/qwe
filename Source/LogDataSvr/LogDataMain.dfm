object FrmLogData: TFrmLogData
  Left = 260
  Top = 103
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'UDP LOG Server'
  ClientHeight = 53
  ClientWidth = 343
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
  object Label3: TLabel
    Left = 8
    Top = 8
    Width = 77
    Height = 13
    Caption = 'Current LogFile :'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsUnderline]
    ParentFont = False
  end
  object Label4: TLabel
    Left = 8
    Top = 24
    Width = 24
    Height = 13
    Caption = '????'
  end
  object Timer1: TTimer
    Interval = 3000
    OnTimer = Timer1Timer
    Left = 184
    Top = 8
  end
  object IdUDPServer: TIdUDPServer
    Bindings = <>
    DefaultPort = 10000
    OnUDPRead = IdUDPServerUDPRead
    Left = 216
    Top = 8
  end
end
