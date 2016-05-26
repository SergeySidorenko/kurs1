object Form1: TForm1
  Left = 250
  Top = 176
  BorderStyle = bsToolWindow
  Caption = 'dddd'
  ClientHeight = 592
  ClientWidth = 809
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 120
  TextHeight = 16
  object Label1: TLabel
    Left = 20
    Top = 10
    Width = 165
    Height = 16
    Caption = #1058#1072#1073#1083#1080#1094#1072' '#1087#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1077#1081':'
  end
  object Label2: TLabel
    Left = 20
    Top = 335
    Width = 128
    Height = 16
    Caption = #1056#1072#1073#1086#1090#1072' '#1089' '#1089#1077#1088#1074#1077#1088#1086#1084':'
  end
  object Memo1: TMemo
    Left = 20
    Top = 363
    Width = 769
    Height = 209
    ReadOnly = True
    ScrollBars = ssVertical
    TabOrder = 0
  end
  object SG: TStringGrid
    Left = 20
    Top = 39
    Width = 769
    Height = 280
    ColCount = 6
    DefaultColWidth = 100
    FixedCols = 0
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goRowSelect]
    ScrollBars = ssVertical
    TabOrder = 1
    ColWidths = (
      51
      50
      186
      100
      100
      112)
  end
  object Timer1: TTimer
    Interval = 2000
    OnTimer = Timer1Timer
    Left = 512
  end
  object ADOConnection1: TADOConnection
    ConnectionString = 
      'Provider=MSDASQL.1;Persist Security Info=False;Data Source=dbsen' +
      'der'
    LoginPrompt = False
    Provider = 'MSDASQL.1'
    Left = 608
  end
  object ADOQuery1: TADOQuery
    Connection = ADOConnection1
    Parameters = <>
    SQL.Strings = (
      'select login, status from user where login = '#39'slava'#39)
    Left = 544
  end
  object IdTCPServer1: TIdTCPServer
    Bindings = <>
    CommandHandlers = <
      item
        CmdDelimiter = ' '
        Command = 'Login'
        Disconnect = False
        Name = 'TIdCH_Login'
        OnCommand = IdTCPServer1TIdCH_LoginCommand
        ParamDelimiter = ' '
        ReplyExceptionCode = 0
        ReplyNormal.NumericCode = 0
        Tag = 0
      end
      item
        CmdDelimiter = ' '
        Command = 'Registration'
        Disconnect = False
        Name = 'TIdCH_Registration'
        OnCommand = IdTCPServer1TIdCH_RegistrationCommand
        ParamDelimiter = ' '
        ReplyExceptionCode = 0
        ReplyNormal.NumericCode = 0
        Tag = 0
      end
      item
        CmdDelimiter = ' '
        Command = 'ReadContactList'
        Disconnect = False
        Name = 'TIdCH_ReadContactList'
        OnCommand = IdTCPServer1TIdCH_ReadContactListCommand
        ParamDelimiter = ' '
        ReplyExceptionCode = 0
        ReplyNormal.NumericCode = 0
        Tag = 0
      end
      item
        CmdDelimiter = ' '
        Command = 'AddFriend'
        Disconnect = False
        Name = 'TIdCH_AddFriend'
        OnCommand = IdTCPServer1TIdCH_AddFriendCommand
        ParamDelimiter = ' '
        ReplyExceptionCode = 0
        ReplyNormal.NumericCode = 0
        Tag = 0
      end
      item
        CmdDelimiter = ' '
        Command = 'SearchUser'
        Disconnect = False
        Name = 'TIdCH_SearchUser'
        OnCommand = IdTCPServer1TIdCH_SearchUserCommand
        ParamDelimiter = ' '
        ReplyExceptionCode = 0
        ReplyNormal.NumericCode = 0
        Tag = 0
      end
      item
        CmdDelimiter = ' '
        Command = 'DeleteFriend'
        Disconnect = False
        Name = 'TIdCH_DeleteFriend'
        OnCommand = IdTCPServer1TIdCH_DeleteFriendCommand
        ParamDelimiter = ' '
        ReplyExceptionCode = 0
        ReplyNormal.NumericCode = 0
        Tag = 0
      end
      item
        CmdDelimiter = ' '
        Command = 'DeleteAccount'
        Disconnect = False
        Name = 'TIdCH_DeleteAccount'
        OnCommand = IdTCPServer1TIdCH_DeleteAccountCommand
        ParamDelimiter = ' '
        ReplyExceptionCode = 0
        ReplyNormal.NumericCode = 0
        Tag = 0
      end
      item
        CmdDelimiter = ' '
        Command = 'LogOut'
        Disconnect = True
        Name = 'TIdCH_LogOut'
        OnCommand = IdTCPServer1TIdCH_LogOutCommand
        ParamDelimiter = ' '
        ReplyExceptionCode = 0
        ReplyNormal.NumericCode = 0
        Tag = 0
      end>
    DefaultPort = 0
    Greeting.NumericCode = 0
    MaxConnectionReply.NumericCode = 0
    ReplyExceptionCode = 0
    ReplyTexts = <>
    ReplyUnknownCommand.NumericCode = 0
    Left = 576
  end
  object MainMenu1: TMainMenu
    Left = 480
    object N1: TMenuItem
      Caption = #1054' '#1087#1088#1086#1075#1088#1072#1084#1084#1077
      OnClick = N1Click
    end
  end
  object sSkinManager1: TsSkinManager
    InternalSkins = <>
    MenuSupport.IcoLineSkin = 'ICOLINE'
    MenuSupport.ExtraLineFont.Charset = DEFAULT_CHARSET
    MenuSupport.ExtraLineFont.Color = clWindowText
    MenuSupport.ExtraLineFont.Height = -11
    MenuSupport.ExtraLineFont.Name = 'MS Sans Serif'
    MenuSupport.ExtraLineFont.Style = []
    SkinDirectory = 'c:\Skins'
    SkinName = 'GPlus'
    SkinInfo = '10.25'
    ThirdParty.ThirdEdits = 
      'TEdit'#13#10'TMemo'#13#10'TMaskEdit'#13#10'TLabeledEdit'#13#10'THotKey'#13#10'TListBox'#13#10'TCheck' +
      'ListBox'#13#10'TRichEdit'#13#10'TDateTimePicker'
    ThirdParty.ThirdButtons = 'TButton'
    ThirdParty.ThirdBitBtns = 'TBitBtn'
    ThirdParty.ThirdCheckBoxes = 'TCheckBox'#13#10'TRadioButton'#13#10'TGroupButton'
    ThirdParty.ThirdGroupBoxes = 'TGroupBox'#13#10'TRadioGroup'
    ThirdParty.ThirdListViews = 'TListView'
    ThirdParty.ThirdPanels = 'TPanel'
    ThirdParty.ThirdGrids = 'TStringGrid'#13#10'TDrawGrid'
    ThirdParty.ThirdTreeViews = 'TTreeView'
    ThirdParty.ThirdComboBoxes = 'TComboBox'#13#10'TColorBox'
    ThirdParty.ThirdWWEdits = ' '
    ThirdParty.ThirdVirtualTrees = ' '
    ThirdParty.ThirdGridEh = ' '
    ThirdParty.ThirdPageControl = 'TPageControl'
    ThirdParty.ThirdTabControl = 'TTabControl'
    ThirdParty.ThirdToolBar = 'TToolBar'
    ThirdParty.ThirdStatusBar = 'TStatusBar'
    ThirdParty.ThirdSpeedButton = 'TSpeedButton'
    ThirdParty.ThirdScrollControl = 'TScrollBox'
    ThirdParty.ThirdUpDown = 'TUpDown'
    ThirdParty.ThirdScrollBar = 'TScrollBar'
    ThirdParty.ThirdStaticText = 'TStaticText'
    ThirdParty.ThirdNativePaint = ' '
    Left = 8
    Top = 120
  end
end
