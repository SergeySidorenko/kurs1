object LoginForm: TLoginForm
  Left = 376
  Top = 8
  BorderStyle = bsToolWindow
  Caption = 'Client - '#1042#1093#1086#1076' '#1074' '#1089#1080#1089#1090#1077#1084#1091
  ClientHeight = 283
  ClientWidth = 485
  Color = 16250871
  Font.Charset = RUSSIAN_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Sitka Text'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  OnMouseMove = FormMouseMove
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 16
  object InfoLabel: TLabel
    Left = 122
    Top = 226
    Width = 3
    Height = 16
  end
  object Label1: TLabel
    Left = 116
    Top = 80
    Width = 33
    Height = 16
    Caption = #1051#1086#1075#1080#1085
  end
  object Label2: TLabel
    Left = 116
    Top = 117
    Width = 39
    Height = 16
    Caption = #1055#1072#1088#1086#1083#1100
  end
  object Label3: TLabel
    Left = 219
    Top = 20
    Width = 55
    Height = 33
    Caption = #1042#1093#1086#1076
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = 7578636
    Font.Height = -23
    Font.Name = 'Sitka Text'
    Font.Style = []
    ParentFont = False
  end
  object LoginEdit: TEdit
    Left = 181
    Top = 75
    Width = 169
    Height = 24
    MaxLength = 64
    TabOrder = 0
    OnKeyDown = LoginEditKeyDown
  end
  object PassEdit: TEdit
    Left = 181
    Top = 115
    Width = 169
    Height = 24
    MaxLength = 64
    PasswordChar = '*'
    TabOrder = 1
    OnKeyDown = LoginEditKeyDown
  end
  object LoginButton: TButton
    Left = 365
    Top = 96
    Width = 110
    Height = 28
    Caption = #1042#1086#1081#1090#1080
    TabOrder = 2
    Visible = False
    OnClick = LoginButtonClick
  end
  object SaveData: TCheckBox
    Left = 181
    Top = 148
    Width = 164
    Height = 19
    Caption = #1047#1072#1087#1086#1084#1085#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
    TabOrder = 3
  end
  object Button1: TButton
    Left = 358
    Top = 58
    Width = 111
    Height = 27
    Caption = #1056#1077#1075#1080#1089#1090#1088#1072#1094#1080#1103
    TabOrder = 4
    Visible = False
    OnClick = Button1Click
  end
  object Panel1: TPanel
    Left = 26
    Top = -16
    Width = 462
    Height = 300
    BevelOuter = bvNone
    Color = 16250871
    TabOrder = 5
    Visible = False
    OnMouseMove = Panel1MouseMove
    object RegLoginLabel: TLabel
      Left = 349
      Top = 90
      Width = 48
      Height = 26
      AutoSize = False
      WordWrap = True
    end
    object RegPassLabel: TLabel
      Left = 349
      Top = 131
      Width = 48
      Height = 28
      AutoSize = False
      WordWrap = True
    end
    object Label5: TLabel
      Left = 68
      Top = 92
      Width = 33
      Height = 16
      Caption = #1051#1086#1075#1080#1085
    end
    object Label6: TLabel
      Left = 68
      Top = 133
      Width = 39
      Height = 16
      Caption = #1055#1072#1088#1086#1083#1100
    end
    object Label7: TLabel
      Left = 68
      Top = 172
      Width = 98
      Height = 16
      Caption = #1055#1086#1074#1090#1086#1088#1080#1090#1077' '#1087#1072#1088#1086#1083#1100
    end
    object Label8: TLabel
      Left = 148
      Top = 33
      Width = 144
      Height = 33
      Caption = #1056#1077#1075#1080#1089#1090#1088#1072#1094#1080#1103
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = 7578636
      Font.Height = -23
      Font.Name = 'Sitka Text'
      Font.Style = []
      ParentFont = False
    end
    object Label9: TLabel
      Left = 143
      Top = 258
      Width = 3
      Height = 16
    end
    object RegisterButton: TButton
      Left = 200
      Top = 254
      Width = 153
      Height = 25
      Caption = #1047#1072#1088#1077#1075#1080#1089#1090#1088#1080#1088#1086#1074#1072#1090#1100#1089#1103
      TabOrder = 0
      Visible = False
      OnClick = RegisterButtonClick
    end
    object RegLoginEdit: TEdit
      Left = 182
      Top = 88
      Width = 156
      Height = 24
      MaxLength = 40
      TabOrder = 1
      OnKeyDown = RegLoginEditKeyDown
      OnKeyPress = RegLoginEditKeyPress
    end
    object RegPass1Edit: TEdit
      Left = 182
      Top = 128
      Width = 156
      Height = 24
      MaxLength = 40
      PasswordChar = '*'
      TabOrder = 2
      OnKeyDown = RegLoginEditKeyDown
    end
    object RegPass2Edit: TEdit
      Left = 182
      Top = 169
      Width = 156
      Height = 24
      MaxLength = 40
      PasswordChar = '*'
      TabOrder = 3
      OnKeyDown = RegLoginEditKeyDown
    end
    object Button2: TButton
      Left = 85
      Top = 261
      Width = 104
      Height = 24
      Caption = #1053#1072#1079#1072#1076
      TabOrder = 4
      Visible = False
      OnClick = Button2Click
    end
    object Panel4: TPanel
      Left = 65
      Top = 214
      Width = 104
      Height = 24
      BevelOuter = bvNone
      Caption = #1053#1072#1079#1072#1076
      Color = 15855077
      Ctl3D = False
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = 'Sitka Text'
      Font.Style = []
      ParentCtl3D = False
      ParentFont = False
      TabOrder = 5
      OnClick = Panel4Click
      OnMouseMove = Panel2MouseMove
    end
    object Panel5: TPanel
      Left = 182
      Top = 214
      Width = 155
      Height = 24
      BevelOuter = bvNone
      Caption = #1047#1072#1088#1077#1075#1080#1089#1090#1088#1080#1088#1086#1074#1072#1090#1100#1089#1103
      Color = 15855077
      Ctl3D = False
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = 'Sitka Text'
      Font.Style = []
      ParentCtl3D = False
      ParentFont = False
      TabOrder = 6
      OnClick = Panel5Click
      OnMouseMove = Panel2MouseMove
    end
  end
  object Panel2: TPanel
    Left = 241
    Top = 188
    Width = 111
    Height = 24
    BevelOuter = bvNone
    Caption = #1042#1086#1081#1090#1080
    Color = 15855077
    Ctl3D = False
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clBlack
    Font.Height = -12
    Font.Name = 'Sitka Text'
    Font.Style = []
    ParentCtl3D = False
    ParentFont = False
    TabOrder = 6
    OnClick = Panel2Click
    OnMouseMove = Panel2MouseMove
  end
  object Panel3: TPanel
    Left = 117
    Top = 188
    Width = 111
    Height = 24
    BevelOuter = bvNone
    Caption = #1056#1077#1075#1080#1089#1090#1088#1072#1094#1080#1103
    Color = 15855077
    Ctl3D = False
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clBlack
    Font.Height = -12
    Font.Name = 'Sitka Text'
    Font.Style = []
    ParentCtl3D = False
    ParentFont = False
    TabOrder = 7
    OnClick = Panel3Click
    OnMouseMove = Panel2MouseMove
  end
  object MainMenu1: TMainMenu
    Top = 144
    object G1: TMenuItem
      Caption = #1055#1086#1084#1086#1097#1100
      ShortCut = 112
      OnClick = G1Click
    end
  end
end
