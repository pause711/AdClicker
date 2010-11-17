object MainForm: TMainForm
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'EvilAdClicker'
  ClientHeight = 516
  ClientWidth = 556
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object lblAdLinks: TLabel
    Left = 5
    Top = 205
    Width = 40
    Height = 13
    Caption = '&Ad links:'
  end
  object lblLog: TLabel
    Left = 5
    Top = 365
    Width = 21
    Height = 13
    Caption = '&Log:'
    FocusControl = mmoLog
  end
  object mmoAddLinks: TMemo
    Left = 5
    Top = 220
    Width = 546
    Height = 131
    Lines.Strings = (
      
        'http://googleads.g.doubleclick.net/aclk?sa=l&ai=BvUtNkyTgTPapHNH' +
        'n_Aaa2ay7Du6F3MABluz76BWu3tXdDrDqARABGAEg4qfvFjgAUM7st-kCYMDp24P' +
        'gDKABoOHu6gOyARBrbm93eW91cm1lbWUuY29tugEJNzI4eDkwX2FzyAED2gEYaHR' +
        '0cDovL2tub3d5b3VybWVtZS5jb20vwAIEyAK21PQVqAMByAMV6AO4A-gDnwToAyD' +
        '1AwAAAMA&num=1&sig=AGiWqtzOpIiMH1_FNzu5GqxYZxF8jVJz-w&client=ca-' +
        'pub-6553040735644309&adurl=http://stage.traffiliate.com/TrafficC' +
        'op.aspx%3FCampaignUid%3D7f63e0517fbdb428%26SourceId%3D364%26Crea' +
        'tiveId%3D5762421902%26SectionId%3Dknowyourmeme.com%26Keyword%3D%' +
        '26af%3Duaco_knowyourmeme.com&nm=14')
    ScrollBars = ssBoth
    TabOrder = 0
    WordWrap = False
  end
  object btnStartStop: TButton
    Left = 365
    Top = 145
    Width = 186
    Height = 46
    Caption = 'Start'
    TabOrder = 1
    OnClick = btnStartStopClick
  end
  object mmoLog: TMemo
    Left = 5
    Top = 380
    Width = 546
    Height = 131
    Color = clBtnFace
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBtnText
    Font.Height = -13
    Font.Name = 'Courier New'
    Font.Style = []
    ParentFont = False
    ReadOnly = True
    ScrollBars = ssVertical
    TabOrder = 2
  end
  object grpProxyConfig: TGroupBox
    Left = 5
    Top = 5
    Width = 356
    Height = 186
    Caption = 'Proxy config'
    TabOrder = 3
    object lblSOCKSHost: TLabel
      Left = 10
      Top = 155
      Width = 62
      Height = 13
      Caption = 'SOCKS Host:'
      FocusControl = edtSOCKSProxyHost
    end
    object lblTorProxyType: TLabel
      Left = 260
      Top = 140
      Width = 57
      Height = 13
      Caption = '&Proxy type:'
      FocusControl = cmbSOCKSProxyType
    end
    object lblHTTPProxy: TLabel
      Left = 10
      Top = 60
      Width = 60
      Height = 13
      Caption = 'HTTP Proxy:'
      FocusControl = edtHTTPProxyHost
    end
    object lblPort: TLabel
      Left = 210
      Top = 45
      Width = 24
      Height = 13
      Caption = 'Port:'
      FocusControl = edtHTTPProxyPort
    end
    object lblSSLProxy: TLabel
      Left = 10
      Top = 85
      Width = 52
      Height = 13
      Caption = 'SSL Proxy:'
      FocusControl = edtSSLProxyHost
    end
    object lblFTPProxy: TLabel
      Left = 10
      Top = 110
      Width = 53
      Height = 13
      Caption = 'FTP Proxy:'
      FocusControl = edtFTPProxyHost
    end
    object lblHost: TLabel
      Left = 80
      Top = 45
      Width = 26
      Height = 13
      Caption = 'Host:'
      FocusControl = edtHTTPProxyPort
    end
    object edtSOCKSProxyHost: TEdit
      Left = 80
      Top = 155
      Width = 126
      Height = 21
      TabOrder = 0
      Text = '127.0.0.1'
    end
    object edtSOCKSProxyPort: TEdit
      Left = 210
      Top = 155
      Width = 46
      Height = 21
      Alignment = taRightJustify
      NumbersOnly = True
      TabOrder = 1
      Text = '9050'
    end
    object cmbSOCKSProxyType: TComboBox
      Left = 260
      Top = 155
      Width = 86
      Height = 21
      Style = csDropDownList
      ItemIndex = 3
      TabOrder = 2
      Text = 'Socks v5'
      Items.Strings = (
        'No socks'
        'Socks v4'
        'Socks v4a'
        'Socks v5')
    end
    object chkUseProxy: TCheckBox
      Left = 10
      Top = 20
      Width = 97
      Height = 17
      Caption = 'Use Proxy'
      Checked = True
      State = cbChecked
      TabOrder = 3
      OnClick = chkUseProxyClick
    end
    object edtHTTPProxyHost: TEdit
      Left = 80
      Top = 60
      Width = 126
      Height = 21
      TabOrder = 4
      Text = '127.0.0.1'
    end
    object edtHTTPProxyPort: TEdit
      Left = 210
      Top = 60
      Width = 46
      Height = 21
      Alignment = taRightJustify
      NumbersOnly = True
      TabOrder = 5
      Text = '8118'
    end
    object edtSSLProxyHost: TEdit
      Left = 80
      Top = 85
      Width = 126
      Height = 21
      TabOrder = 6
      Text = '127.0.0.1'
    end
    object edtSSLProxyPort: TEdit
      Left = 210
      Top = 85
      Width = 46
      Height = 21
      Alignment = taRightJustify
      NumbersOnly = True
      TabOrder = 7
      Text = '8118'
    end
    object edtFTPProxyHost: TEdit
      Left = 80
      Top = 110
      Width = 126
      Height = 21
      TabOrder = 8
      Text = '127.0.0.1'
    end
    object edtFTPProxyPort: TEdit
      Left = 210
      Top = 110
      Width = 46
      Height = 21
      Alignment = taRightJustify
      NumbersOnly = True
      TabOrder = 9
      Text = '0'
    end
  end
  object grpBotOptions: TGroupBox
    Left = 365
    Top = 5
    Width = 186
    Height = 76
    Caption = 'Bot options'
    TabOrder = 4
    object lblBotCount: TLabel
      Left = 15
      Top = 25
      Width = 50
      Height = 13
      Caption = 'Bot count:'
    end
    object lblBotClickTimer: TLabel
      Left = 15
      Top = 50
      Width = 69
      Height = 13
      Caption = 'Bot click timer:'
    end
    object lblSeconds: TLabel
      Left = 135
      Top = 50
      Width = 43
      Height = 13
      Caption = 'seconds.'
    end
    object edtBotCount: TEdit
      Left = 90
      Top = 20
      Width = 36
      Height = 21
      Alignment = taRightJustify
      NumbersOnly = True
      TabOrder = 0
      Text = '10'
    end
    object edtBotClickTimer: TEdit
      Left = 90
      Top = 45
      Width = 36
      Height = 21
      Alignment = taRightJustify
      TabOrder = 1
      Text = '5'
    end
  end
end
