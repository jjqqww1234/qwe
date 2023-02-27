object FrmFDBViewer: TFrmFDBViewer
  Left = 191
  Top = 200
  Width = 833
  Height = 258
  Caption = 'FrmFDBViewer'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object TabbedNotebook1: TTabbedNotebook
    Left = 54
    Top = 0
    Width = 771
    Height = 231
    Align = alClient
    TabFont.Charset = DEFAULT_CHARSET
    TabFont.Color = clBtnText
    TabFont.Height = -11
    TabFont.Name = 'MS Sans Serif'
    TabFont.Style = []
    TabOrder = 0
    object TTabPage
      Left = 4
      Top = 24
      Caption = 'Human'
      object HumanGrid: TStringGrid
        Left = 0
        Top = 0
        Width = 763
        Height = 203
        Align = alClient
        ColCount = 12
        DefaultRowHeight = 20
        FixedCols = 0
        RowCount = 15
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goColSizing, goThumbTracking]
        TabOrder = 0
        RowHeights = (
          5
          20
          20
          20
          20
          20
          20
          20
          20
          20
          20
          20
          20
          20
          20)
      end
    end
    object TTabPage
      Left = 4
      Top = 24
      HelpContext = 1
      Caption = 'BagItem'
      object BagItemGrid: TStringGrid
        Left = 0
        Top = 0
        Width = 763
        Height = 203
        Align = alClient
        ColCount = 4
        DefaultRowHeight = 20
        FixedCols = 0
        RowCount = 63
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goColSizing, goThumbTracking]
        TabOrder = 0
        ColWidths = (
          48
          88
          63
          125)
      end
    end
    object TTabPage
      Left = 4
      Top = 24
      HelpContext = 2
      Caption = 'SaveItem'
      object SaveItemGrid: TStringGrid
        Left = 0
        Top = 0
        Width = 763
        Height = 203
        Align = alClient
        ColCount = 3
        DefaultRowHeight = 20
        FixedCols = 0
        RowCount = 52
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goColSizing, goThumbTracking]
        TabOrder = 0
        ColWidths = (
          102
          57
          126)
      end
    end
    object TTabPage
      Left = 4
      Top = 24
      HelpContext = 3
      Caption = 'UseMagic'
      object UseMagicGrid: TStringGrid
        Left = 0
        Top = 0
        Width = 763
        Height = 203
        Align = alClient
        ColCount = 4
        DefaultRowHeight = 20
        FixedCols = 0
        RowCount = 27
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goColSizing, goThumbTracking]
        TabOrder = 0
        ColWidths = (
          117
          67
          116
          112)
      end
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 54
    Height = 231
    Align = alLeft
    BevelOuter = bvNone
    Caption = ' '
    TabOrder = 1
    object BtnReadOnly: TSpeedButton
      Left = 0
      Top = 144
      Width = 52
      Height = 24
      AllowAllUp = True
      GroupIndex = 1
      Caption = 'ReadOnly'
      OnClick = BtnReadOnlyClick
    end
    object Label1: TLabel
      Left = 8
      Top = 16
      Width = 32
      Height = 13
      Caption = 'Label1'
    end
    object BtnApply: TButton
      Left = 0
      Top = 176
      Width = 52
      Height = 24
      Caption = 'Apply'
      TabOrder = 0
      OnClick = BtnApplyClick
    end
    object ResetPosition: TButton
      Left = 1
      Top = 114
      Width = 52
      Height = 24
      Caption = 'Pos-Reset'
      TabOrder = 1
      OnClick = ResetPositionClick
    end
  end
end
