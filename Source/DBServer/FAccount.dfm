object FrmAccountForm: TFrmAccountForm
  Left = 355
  Top = 214
  Width = 406
  Height = 282
  Caption = '���� �߰�/����   (F1: Ȯ��,  ESC: ���)'
  Color = clBtnFace
  Font.Charset = HANGEUL_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = '����'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  OnKeyDown = FormKeyDown
  OnKeyPress = FormKeyPress
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 44
    Top = 24
    Width = 65
    Height = 13
    Caption = '���̵� / IP'
  end
  object Label2: TLabel
    Left = 12
    Top = 48
    Width = 97
    Height = 13
    Caption = 'ĳ���̸�/��ȣ��'
  end
  object Label3: TLabel
    Left = 56
    Top = 96
    Width = 52
    Height = 13
    Caption = '��ݹ��'
  end
  object Label4: TLabel
    Left = 68
    Top = 120
    Width = 39
    Height = 13
    Caption = '�����'
  end
  object Label5: TLabel
    Left = 168
    Top = 120
    Width = 13
    Height = 13
    Caption = '��'
  end
  object Label6: TLabel
    Left = 212
    Top = 120
    Width = 13
    Height = 13
    Caption = '��'
  end
  object Label7: TLabel
    Left = 256
    Top = 120
    Width = 13
    Height = 13
    Caption = '��'
  end
  object Label8: TLabel
    Left = 68
    Top = 144
    Width = 39
    Height = 13
    Caption = '��Ϸ�'
  end
  object Label9: TLabel
    Left = 196
    Top = 144
    Width = 26
    Height = 13
    Caption = '�Ϻ�'
  end
  object Label10: TLabel
    Left = 80
    Top = 168
    Width = 26
    Height = 13
    Caption = '�޸�'
  end
  object Label11: TLabel
    Left = 56
    Top = 72
    Width = 61
    Height = 13
    Caption = 'PC�� ��ǥ'
  end
  object Label12: TLabel
    Left = 256
    Top = 96
    Width = 52
    Height = 13
    Caption = '�ߺ�����'
  end
  object EdID: TEdit
    Tag = 1
    Left = 120
    Top = 20
    Width = 121
    Height = 21
    AutoSelect = False
    Enabled = False
    ImeName = '�ѱ���(�ѱ�) (MS-IME95)'
    MaxLength = 15
    TabOrder = 0
    OnKeyPress = EdChrNameKeyPress
  end
  object EdChrName: TEdit
    Tag = 2
    Left = 120
    Top = 44
    Width = 217
    Height = 21
    Enabled = False
    ImeName = '�ѱ���(�ѱ�) (MS-IME95)'
    MaxLength = 20
    TabOrder = 1
    OnKeyPress = EdChrNameKeyPress
  end
  object CbFeeMode: TComboBox
    Tag = 4
    Left = 120
    Top = 92
    Width = 121
    Height = 21
    Style = csDropDownList
    ImeName = '�ѱ���(�ѱ�) (MS-IME95)'
    ItemHeight = 13
    TabOrder = 3
    OnKeyPress = EdChrNameKeyPress
    Items.Strings = (
      '����'
      '������'
      '������')
  end
  object EdYear: TEdit
    Tag = 6
    Left = 120
    Top = 116
    Width = 45
    Height = 21
    ImeName = '�ѱ���(�ѱ�) (MS-IME95)'
    MaxLength = 4
    TabOrder = 5
    OnKeyPress = EdChrNameKeyPress
  end
  object EdMon: TEdit
    Tag = 7
    Left = 184
    Top = 116
    Width = 25
    Height = 21
    ImeName = '�ѱ���(�ѱ�) (MS-IME95)'
    MaxLength = 2
    TabOrder = 6
    OnKeyPress = EdChrNameKeyPress
  end
  object EdDay: TEdit
    Tag = 8
    Left = 228
    Top = 116
    Width = 25
    Height = 21
    ImeName = '�ѱ���(�ѱ�) (MS-IME95)'
    MaxLength = 2
    TabOrder = 7
    OnKeyPress = EdChrNameKeyPress
  end
  object EdCount: TEdit
    Tag = 9
    Left = 120
    Top = 140
    Width = 69
    Height = 21
    ImeName = '�ѱ���(�ѱ�) (MS-IME95)'
    MaxLength = 6
    TabOrder = 8
    OnKeyPress = EdChrNameKeyPress
  end
  object EdMemo: TEdit
    Tag = 10
    Left = 120
    Top = 164
    Width = 253
    Height = 21
    ImeName = '�ѱ���(�ѱ�) (MS-IME95)'
    MaxLength = 20
    TabOrder = 9
    OnKeyPress = EdChrNameKeyPress
  end
  object Button1: TButton
    Left = 148
    Top = 212
    Width = 85
    Height = 25
    Caption = 'Ȯ�� (F1)'
    ModalResult = 1
    TabOrder = 10
  end
  object Button2: TButton
    Left = 268
    Top = 212
    Width = 85
    Height = 25
    Caption = '��� (ESC)'
    ModalResult = 2
    TabOrder = 11
  end
  object EdOwner: TEdit
    Tag = 3
    Left = 120
    Top = 68
    Width = 77
    Height = 21
    ImeName = '�ѱ���(�ѱ�) (MS-IME95)'
    MaxLength = 10
    TabOrder = 2
    OnKeyPress = EdChrNameKeyPress
  end
  object EdDupCount: TEdit
    Tag = 5
    Left = 312
    Top = 92
    Width = 37
    Height = 21
    ImeName = '�ѱ���(�ѱ�) (MS-IME95)'
    TabOrder = 4
    OnKeyPress = EdChrNameKeyPress
  end
end
