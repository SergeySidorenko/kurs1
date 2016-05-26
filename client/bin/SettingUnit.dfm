object SettingForm: TSettingForm
  Left = 427
  Top = 78
  BorderStyle = bsToolWindow
  Caption = 'Client - '#1053#1072#1089#1090#1088#1086#1081#1082#1080
  ClientHeight = 394
  ClientWidth = 449
  Color = 16250871
  Font.Charset = RUSSIAN_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Sitka Text'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  OnMouseMove = FormMouseMove
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 16
  object GroupBox2: TGroupBox
    Left = 13
    Top = 13
    Width = 423
    Height = 268
    Caption = ' '#1054#1073#1097#1080#1077' '#1085#1072#1089#1090#1088#1086#1081#1082#1080' '
    Color = 16250871
    ParentColor = False
    TabOrder = 0
    OnMouseMove = FormMouseMove
    object Label4: TLabel
      Left = 20
      Top = 65
      Width = 260
      Height = 16
      Caption = #1055#1077#1088#1077#1082#1083#1102#1095#1080#1090#1100#1089#1103' '#1085#1072' '#1087#1088#1077#1076#1099#1076#1091#1097#1077#1075#1086' '#1087#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1103':'
    end
    object Label5: TLabel
      Left = 20
      Top = 98
      Width = 255
      Height = 16
      Caption = #1055#1077#1088#1077#1082#1083#1102#1095#1080#1090#1100#1089#1103' '#1085#1072' '#1089#1083#1077#1076#1091#1102#1097#1077#1075#1086' '#1087#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1103': '
    end
    object Label6: TLabel
      Left = 20
      Top = 33
      Width = 127
      Height = 16
      Caption = #1054#1090#1087#1088#1072#1074#1080#1090#1100' '#1089#1086#1086#1073#1097#1077#1085#1080#1077': '
    end
    object CheckBox1: TCheckBox
      Left = 20
      Top = 144
      Width = 189
      Height = 13
      Caption = #1059#1074#1077#1076#1086#1084#1083#1103#1090#1100' '#1086' '#1079#1072#1103#1074#1082#1072#1093' '#1074' '#1076#1088#1091#1079#1100#1103
      TabOrder = 0
    end
    object CheckBox2: TCheckBox
      Left = 20
      Top = 176
      Width = 189
      Height = 13
      Caption = #1059#1074#1077#1076#1086#1084#1083#1103#1090#1100' '#1086' '#1085#1086#1074#1099#1093' '#1089#1086#1086#1073#1097#1077#1085#1080#1103#1093
      TabOrder = 1
    end
    object Edit1: TEdit
      Left = 306
      Top = 31
      Width = 46
      Height = 24
      TabOrder = 2
      OnKeyDown = Edit1KeyDown
      OnKeyPress = Edit2KeyPress
    end
    object Edit2: TEdit
      Left = 306
      Top = 93
      Width = 46
      Height = 24
      TabOrder = 3
      OnKeyDown = Edit2KeyDown
      OnKeyPress = Edit2KeyPress
    end
    object Edit3: TEdit
      Left = 306
      Top = 63
      Width = 46
      Height = 24
      TabOrder = 4
      OnKeyDown = Edit3KeyDown
      OnKeyPress = Edit2KeyPress
    end
    object Button1: TButton
      Left = 196
      Top = 215
      Width = 234
      Height = 20
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1089#1090#1072#1085#1076#1072#1088#1090#1085#1099#1077' '#1085#1072#1089#1090#1088#1086#1081#1082#1080
      TabOrder = 5
      Visible = False
      OnClick = Button1Click
    end
  end
  object GroupBox3: TGroupBox
    Left = 13
    Top = 294
    Width = 423
    Height = 85
    Caption = ' '#1059#1087#1088#1072#1074#1083#1077#1085#1080#1077' '#1072#1082#1082#1072#1091#1085#1086#1084' '
    TabOrder = 1
    OnMouseMove = FormMouseMove
    object Button3: TButton
      Left = 33
      Top = 7
      Width = 163
      Height = 20
      Caption = #1054#1095#1080#1089#1090#1080#1090#1100' '#1074#1089#1102' '#1080#1089#1090#1086#1088#1080#1102
      TabOrder = 0
      Visible = False
      OnClick = Button3Click
    end
    object Button4: TButton
      Left = 209
      Top = 7
      Width = 162
      Height = 20
      Caption = #1059#1076#1072#1083#1080#1090#1100' '#1072#1082#1082#1072#1091#1085#1090
      TabOrder = 1
      Visible = False
      OnClick = Button4Click
    end
  end
  object Panel2: TPanel
    Left = 33
    Top = 235
    Width = 182
    Height = 24
    BevelOuter = bvNone
    Caption = #1057#1090#1072#1085#1076#1072#1088#1090#1085#1099#1077' '#1085#1072#1089#1090#1088#1086#1081#1082#1080
    Color = 15855077
    Ctl3D = False
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clBlack
    Font.Height = -12
    Font.Name = 'Sitka Text'
    Font.Style = []
    ParentCtl3D = False
    ParentFont = False
    TabOrder = 2
    OnClick = Panel2Click
    OnMouseMove = Panel2MouseMove
  end
  object Panel1: TPanel
    Left = 236
    Top = 327
    Width = 137
    Height = 24
    BevelOuter = bvNone
    Caption = #1059#1076#1072#1083#1080#1090#1100' '#1072#1082#1082#1072#1091#1085#1090
    Color = 15855077
    Ctl3D = False
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clBlack
    Font.Height = -12
    Font.Name = 'Sitka Text'
    Font.Style = []
    ParentCtl3D = False
    ParentFont = False
    TabOrder = 3
    OnClick = Panel1Click
    OnMouseMove = Panel2MouseMove
  end
  object Panel3: TPanel
    Left = 65
    Top = 327
    Width = 144
    Height = 24
    BevelOuter = bvNone
    Caption = #1054#1095#1080#1089#1090#1080#1090#1100' '#1080#1089#1090#1086#1088#1080#1102
    Color = 15855077
    Ctl3D = False
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clBlack
    Font.Height = -12
    Font.Name = 'Sitka Text'
    Font.Style = []
    ParentCtl3D = False
    ParentFont = False
    TabOrder = 4
    OnClick = Panel3Click
    OnMouseMove = Panel2MouseMove
  end
  object MainMenu1: TMainMenu
    Left = 264
    Top = 8
    object G1: TMenuItem
      Caption = #1055#1086#1084#1086#1097#1100
      OnClick = G1Click
    end
  end
end
