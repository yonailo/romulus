object Form1: TForm1
  Left = 225
  Top = 177
  Width = 906
  Height = 464
  Caption = 'TEmbeddedWB - EwbControl Demo'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  Scaled = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label3: TLabel
    Left = 168
    Top = 16
    Width = 71
    Height = 13
    Caption = '[active Control]'
  end
  object EmbeddedWB1: TEmbeddedWB
    Left = 160
    Top = 56
    Width = 281
    Height = 297
    TabOrder = 0
    Silent = False
    DisableCtrlShortcuts = 'N'
    UserInterfaceOptions = [EnablesFormsAutoComplete, EnableThemes]
    About = ' EmbeddedWB http://bsalsa.com/'
    HTMLCode.Strings = (
      'http://bsalsa.com/test/FlashTest.htm')
    PrintOptions.Margins.Left = 19.050000000000000000
    PrintOptions.Margins.Right = 19.050000000000000000
    PrintOptions.Margins.Top = 19.050000000000000000
    PrintOptions.Margins.Bottom = 19.050000000000000000
    PrintOptions.HTMLHeader.Strings = (
      '<HTML></HTML>')
    PrintOptions.Footer = '&u'
    PrintOptions.Orientation = poPortrait
    ControlData = {
      4C000000F7260000B21E00000000000000000000000000000000000000000000
      000000004C000000000000000000000001000000E0D057007335CF11AE690800
      2B2E126208000000000000004C0000000114020000000000C000000000000046
      8000000000000000000000000000000000000000000000000000000000000000
      00000000000000000100000000000000000000000000000000000000}
  end
  object EmbeddedWB2: TEmbeddedWB
    Left = 448
    Top = 56
    Width = 265
    Height = 297
    TabOrder = 1
    Silent = False
    DisableCtrlShortcuts = 'N'
    UserInterfaceOptions = [EnablesFormsAutoComplete, EnableThemes]
    About = ' EmbeddedWB http://bsalsa.com/'
    HTMLCode.Strings = (
      'http://bsalsa.com/test/FlashTest.htm')
    PrintOptions.Margins.Left = 19.050000000000000000
    PrintOptions.Margins.Right = 19.050000000000000000
    PrintOptions.Margins.Top = 19.050000000000000000
    PrintOptions.Margins.Bottom = 19.050000000000000000
    PrintOptions.HTMLHeader.Strings = (
      '<HTML></HTML>')
    PrintOptions.Footer = '&u'
    PrintOptions.Orientation = poPortrait
    ControlData = {
      4C000000021F0000810F00000000000000000000000000000000000000000000
      000000004C000000000000000000000001000000E0D057007335CF11AE690800
      2B2E126208000000000000004C0000000114020000000000C000000000000046
      8000000000000000000000000000000000000000000000000000000000000000
      00000000000000000100000000000000000000000000000000000000}
  end
  object ListBox1: TListBox
    Left = 737
    Top = 0
    Width = 153
    Height = 426
    Align = alRight
    ItemHeight = 13
    TabOrder = 2
  end
  object Button2: TButton
    Left = 581
    Top = 13
    Width = 131
    Height = 28
    Caption = 'Show Form2'
    TabOrder = 3
    OnClick = Button2Click
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 153
    Height = 426
    Align = alLeft
    TabOrder = 4
    object Image1: TImage
      Left = 16
      Top = 8
      Width = 28
      Height = 28
      AutoSize = True
      Picture.Data = {
        07544269746D617066090000424D660900000000000036000000280000001C00
        00001C0000000100180000000000300900000000000000000000000000000000
        0000FF00FF99A8AC99A8AC99A8AC99A8AC99A8AC99A8AC99A8AC99A8AC99A8AC
        99A8AC99A8AC99A8AC99A8AC99A8AC99A8AC99A8AC99A8AC99A8AC99A8AC99A8
        AC99A8AC99A8AC99A8AC99A8AC99A8AC99A8AC99A8ACFFFFFFFF00FFFF00FFFF
        00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
        FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
        FFFF00FFFF00FF99A8ACFFFFFFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
        00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
        FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF99A8ACFFFF
        FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFA4
        A0A0A4A0A0A4A0A0A4A0A0A4A0A0A4A0A0A4A0A0A4A0A099A8AC99A8ACA4A0A0
        FF00FFFF00FFC0DCC0FF00FFFF00FF99A8ACFFFFFFFF00FFFF00FFFF00FFFF00
        FFFF00FFFF00FFFF00FFFF00FFA4A0A099A8AC80806080806080806080806080
        6060406040A4A0A0C0DCC099A8AC806060FF00FFFF00FFFF00FFC0DCC0FF00FF
        FF00FF99A8ACFFFFFFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFC0A0
        A0C0A080F0CAA6F0CAA6F0CAA6F0CAA6F0CAA6C0C080808040C0A0A0FF00FFFF
        00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF99A8ACFFFFFFFF00FF
        FF00FFFF00FFFF00FFFF00FFFF00FFF0CAA6F0CAA6F0CAA6F0CAA6F0CAA6C0C0
        80C0A060C08060C0A0A0A4A0A0FF00FFFF00FFC0A0A0A4A0A0A4A0A0A4A0A0C0
        A0A0C0A0A0C0DCC0FF00FF99A8ACFFFFFFFF00FFFF00FFFF00FFFF00FFFF00FF
        C0C080F0CAA6F0CAA6C0A060C0A060C08040C08040806020808060F0FBFFFF00
        FFFF00FFFF00FFFF00FFFF00FFA4A0A0A4A0A0A4A0A0D8E9ECF0FBFFFF00FF99
        A8ACFFFFFFFF00FFFF00FFFF00FFFF00FFC0C060F0CAA6C0A060C08040C08040
        C06020C06020C06020804020806040C0DCC0FF00FFC0DCC0FF00FFF0FBFFF0FB
        FFA4A0A0C0C0A0A4A0A0D8E9ECF0FBFFFF00FF99A8ACFFFFFFFF00FFFF00FFFF
        00FFC0C0A0C0C040C0A060C08040C06040C06020C06020C06020C06020804020
        804040C0A0A0FF00FFC0DCC0FF00FFA4A0A0A4A0A0C0A0A0C0DCC0D8E9ECC0A0
        A0F0FBFFFF00FF99A8ACFFFFFFFF00FFFF00FFFF00FF40C040C0A040C08040C0
        6020C06020C06020C06020C06020C06020804020804020D8E9ECC0DCC0C0DCC0
        C0DCC0C0C0A0C0A080C0DCC0D8E9ECD8E9ECD8E9ECC0DCC0FF00FF99A8ACFFFF
        FFFF00FFFF00FFC0C08000E02040C020C08020C06020C06020C06020C06020C0
        6020C06020804020806040F0FBFFF0FBFFC0DCC0C0DCC0F0FBFFF0FBFFC0DCC0
        C0DCC0C0DCC0C0DCC0C0DCC0FF00FF99A8ACFFFFFFFF00FFFF00FF80C06000E0
        2000C020C08020C06020C06020C06020C06040C08040C06040806020806040F0
        FBFFFFFFFFA4A0A0F0FBFFF0FBFFF0FBFFF0FBFFD8E9ECD8E9ECF0FBFFC0DCC0
        FF00FF99A8ACFFFFFFFF00FFFF00FF40C04000C02040C020808020C06020C080
        40C08040C08040C08040C08040C08040806040C0A0A080A080A4A0A0F0FBFFF0
        FBFFF0FBFFF0FBFFC0DCC0808060C0DCC0FF00FFFF00FF99A8ACFFFFFFFF00FF
        FF00FF40C02000C02000A02080A040C08040C08040C0A060C0A060C0A060C0A0
        60C0A060C0A060C0804000600080A0A0FFFFFFC0DCC0F0FBFFD8E9ECF0FBFFC0
        6020F0CAA6FF00FFFF00FF99A8ACFFFFFFFF00FFFF00FF40C02040A02080A020
        C08040C08040C0A060C0C080C0C080C0C080C0C080C0C080F0CAA6C0C06000A0
        2080A080FFFFFF408060406020D8E9ECF0FBFFC08020F0CAA6FF00FFFF00FF99
        A8ACFFFFFFFF00FFFF00FF40C02080A020C08040C0A040C0C080F0CAA6F0CAA6
        F0CAA6F0CAA6C0C080F0CAA6C0C080C0C08040C06040A06080C06040A0400080
        20408040C08040C08020C0DCC0FF00FFFF00FF99A8ACFFFFFFFF00FFFF00FF40
        A040808020C0A040C0A080F0CAA6F0CAA6F0CAA6F0CAA6C0DCC0C0DCC0C0DCC0
        C0DCC0C0DCC0C0DCC080E0A080E08080E08040C040808040C08020C08040F0FB
        FFFF00FFFF00FF99A8ACFFFFFFFF00FFFF00FFC0A080C08040C0A060F0CAA6F0
        CAA6F0CAA6F0CAA6F0CAA6F0FBFFF0FBFFF0FBFFF0FBFFF0FBFFC0DCC0C0DCC0
        C0DCC0C0DCC0C0C0A040C04040A020C0A060FF00FFFF00FFFF00FF99A8ACFFFF
        FFFF00FFFF00FFF0CAA6C0A040C0A080F0CAA6F0FBFFF0CAA6F0CAA6C0DCC0F0
        FBFFF0FBFFF0FBFFF0FBFFF0FBFFF0FBFFF0FBFFF0FBFFF0FBFFC0DCC080C060
        80A040C0C0A0FF00FFFF00FFFF00FF99A8ACFFFFFFFF00FFFF00FFFF00FFC0A0
        60C0C080F0CAA6F0FBFFF0FBFFF0FBFFF0CAA6F0FBFFF0FBFFF0FBFFF0FBFFF0
        FBFFF0FBFFF0FBFFF0FBFFF0FBFFF0FBFF80C08080C040FF00FFFF00FFFF00FF
        FF00FF99A8ACFFFFFFFF00FFFF00FFFF00FFC0DCC0C0A060F0CAA6FFFFFFFFFF
        FFFFFFFFFFFFFFF0FBFFF0FBFFF0FBFFF0FBFFF0FBFFF0FBFFF0FBFFF0FBFFF0
        FBFFC0DCC080C060C0DCC0FF00FFFF00FFFF00FFFF00FF99A8ACFFFFFFFF00FF
        FF00FFFF00FFFF00FFF0CAA6C0C080FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFF0FBFFF0FBFFFFFFFFFFFFFFFFFFFFFFFFFFF0FBFFC0C080C0DCC0FF00FFFF
        00FFFF00FFFF00FFFF00FF99A8ACFFFFFFFF00FFFF00FFFF00FFFF00FFFF00FF
        F0CAA6C0C080FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFC0DCC0C0C0A0FF00FFFF00FFFF00FFFF00FFFF00FFFF00FF99
        A8ACFFFFFFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFF0CAA6F0CAA6F0CAA6
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0FBFFC0DCC0C0DCC0C0DCC0FF00
        FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF99A8ACFFFFFFFF00FFFF00FFFF
        00FFFF00FFFF00FFFF00FFFF00FFFF00FFF0CAA6F0CAA6F0CAA6F0CAA6F0CAA6
        F0CAA6FF00FFFF00FFC0DCC0FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
        FFFF00FFFF00FF99A8ACFFFFFFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
        00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
        FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF99A8ACFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF}
      Transparent = True
    end
    object Label1: TLabel
      Left = 16
      Top = 64
      Width = 101
      Height = 13
      Caption = '+ MouseWheelFix'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label2: TLabel
      Left = 16
      Top = 139
      Width = 86
      Height = 13
      Caption = '+ FocusControl'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object chkFocusControl: TCheckBox
      Left = 24
      Top = 158
      Width = 97
      Height = 17
      Caption = 'Active'
      TabOrder = 0
      OnClick = chkFocusControlClick
    end
    object ChkMouseWheelFix: TCheckBox
      Left = 24
      Top = 88
      Width = 105
      Height = 17
      Caption = 'Active'
      TabOrder = 1
      OnClick = ChkMouseWheelFixClick
    end
    object chkActiveFormOnly: TCheckBox
      Left = 24
      Top = 109
      Width = 109
      Height = 17
      Caption = 'ActiveFormOnly'
      TabOrder = 2
      OnClick = chkActiveFormOnlyClick
    end
  end
  object EwbControl1: TEwbControl
    OnMouseWheel = EwbControl1MouseWheel
    InternetFeatures = [ObjectCaching, Behaviors, DisableMkProtocol, GetUrlDomFilePathUnencoded, DisableLegacyCompression, XmlHttp]
    Left = 16
    Top = 8
  end
  object Timer1: TTimer
    OnTimer = Timer1Timer
    Left = 680
    Top = 384
  end
end
