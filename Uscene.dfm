object Fscene: TFscene
  Left = 192
  Top = 125
  BorderStyle = bsToolWindow
  Caption = 'Scene copy'
  ClientHeight = 321
  ClientWidth = 443
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnActivate = FormActivate
  OnClose = FormClose
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object TntLabel1: TTntLabel
    Left = 16
    Top = 8
    Width = 362
    Height = 13
    Caption = 
      'This is only for private purposes, use it under own responsabili' +
      'ty'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object TntLabel2: TTntLabel
    Left = 16
    Top = 32
    Width = 215
    Height = 13
    Caption = 'Source folder (exploration will be recursive) :'
  end
  object TntSpeedButton1: TTntSpeedButton
    Left = 400
    Top = 48
    Width = 23
    Height = 22
    Caption = '...'
    OnClick = TntSpeedButton1Click
  end
  object TntEdit1: TTntEdit
    Left = 16
    Top = 48
    Width = 377
    Height = 21
    Color = clBtnFace
    ReadOnly = True
    TabOrder = 0
  end
  object TntBitBtn1: TTntBitBtn
    Left = 120
    Top = 288
    Width = 75
    Height = 25
    Caption = 'Start'
    TabOrder = 1
    OnClick = TntBitBtn1Click
  end
  object TntBitBtn2: TTntBitBtn
    Left = 216
    Top = 288
    Width = 75
    Height = 25
    Caption = 'Stop'
    Enabled = False
    TabOrder = 2
    OnClick = TntBitBtn2Click
  end
  object RxRichEdit1: TRxRichEdit
    Left = 16
    Top = 80
    Width = 409
    Height = 201
    DrawEndPage = False
    BorderStyle = bsNone
    Color = clBtnFace
    ReadOnly = True
    ScrollBars = ssVertical
    TabOrder = 3
  end
end
