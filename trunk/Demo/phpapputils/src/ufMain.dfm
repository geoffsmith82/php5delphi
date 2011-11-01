object frmMain: TfrmMain
  Left = 0
  Top = 0
  Caption = 'frmMain'
  ClientHeight = 600
  ClientWidth = 800
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object bvlTop: TBevel
    AlignWithMargins = True
    Left = 3
    Top = 3
    Width = 794
    Height = 73
    Align = alTop
    Style = bsRaised
    ExplicitLeft = 0
    ExplicitTop = 0
    ExplicitWidth = 800
  end
  object pgcMain: TPageControl
    AlignWithMargins = True
    Left = 3
    Top = 82
    Width = 794
    Height = 496
    ActivePage = tsGeneral
    Align = alClient
    MultiLine = True
    TabOrder = 0
    TabPosition = tpRight
    object tsGeneral: TTabSheet
      Caption = 'General'
      object btnRunPhpInfo: TButton
        Left = 24
        Top = 16
        Width = 75
        Height = 25
        Caption = 'PhpInfo();'
        TabOrder = 0
        OnClick = btnRunPhpInfoClick
      end
      object mmoLog: TMemo
        AlignWithMargins = True
        Left = 3
        Top = 328
        Width = 760
        Height = 157
        Align = alBottom
        TabOrder = 1
      end
      object btnGetGlobalVariants: TButton
        Left = 128
        Top = 16
        Width = 113
        Height = 25
        Caption = 'GetGlobalVariants'
        TabOrder = 2
        OnClick = btnGetGlobalVariantsClick
      end
    end
    object tsWebView: TTabSheet
      Caption = 'WebView'
      ImageIndex = 1
      object webkitView: TChromium
        AlignWithMargins = True
        Left = 3
        Top = 3
        Width = 760
        Height = 482
        Align = alClient
        TabOrder = 0
      end
    end
  end
  object statPanel: TStatusBar
    Left = 0
    Top = 581
    Width = 800
    Height = 19
    Panels = <>
  end
  object phpEngine: TPHPEngine
    Constants = <>
    ReportDLLError = False
    Left = 656
    Top = 8
  end
  object phpPSV: TpsvPHP
    Variables = <
      item
        Name = 'avc'
      end>
    Left = 704
    Top = 8
  end
  object phpLib: TPHPLibrary
    Functions = <>
    Left = 752
    Top = 8
  end
end
