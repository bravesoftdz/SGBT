object frmNewMember: TfrmNewMember
  Left = 394
  Top = 267
  Width = 883
  Height = 617
  BorderStyle = bsSizeToolWin
  Caption = #26032#24314#20250#21592
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  WindowState = wsMaximized
  OnClose = FormClose
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = -16
    Top = 0
    Width = 881
    Height = 721
    Caption = 'Panel1'
    TabOrder = 0
    object GroupBox2: TGroupBox
      Left = 632
      Top = 8
      Width = 233
      Height = 229
      Caption = #25805#20316
      TabOrder = 0
      object btnOnlineRecharge: TButton
        Left = 40
        Top = 41
        Width = 153
        Height = 49
        Caption = #30830#35748#30003#35831
        TabOrder = 0
        OnClick = btnOnlineRechargeClick
      end
      object btnOfflineRecharge: TButton
        Left = 40
        Top = 120
        Width = 153
        Height = 42
        Caption = #30830#35748#36864#21345
        TabOrder = 1
        OnClick = btnOfflineRechargeClick
      end
    end
    object GroupBox1: TGroupBox
      Left = 8
      Top = 8
      Width = 617
      Height = 229
      Caption = #20250#21592#20449#24687
      TabOrder = 1
      object Label1: TLabel
        Left = 9
        Top = 73
        Width = 123
        Height = 33
        Alignment = taCenter
        AutoSize = False
        Caption = #20250#21592#21345'ID:'
      end
      object Label2: TLabel
        Left = 320
        Top = 19
        Width = 121
        Height = 33
        Alignment = taCenter
        AutoSize = False
        Caption = #22330#22320#21495':'
      end
      object Label3: TLabel
        Left = 319
        Top = 123
        Width = 123
        Height = 33
        Alignment = taCenter
        AutoSize = False
        Caption = #25163#26426#21495':'
      end
      object Label4: TLabel
        Left = 9
        Top = 130
        Width = 137
        Height = 33
        Alignment = taCenter
        AutoSize = False
        Caption = #20250#21592#32534#21495':'
      end
      object lblMessage: TLabel
        Left = 8
        Top = 200
        Width = 601
        Height = 25
        Alignment = taCenter
        AutoSize = False
        Caption = #25552#31034#20449#24687
      end
      object Label5: TLabel
        Left = 9
        Top = 19
        Width = 137
        Height = 33
        Alignment = taCenter
        AutoSize = False
        Caption = #20844#20247#21495
      end
      object Label6: TLabel
        Left = 320
        Top = 73
        Width = 121
        Height = 25
        Alignment = taCenter
        AutoSize = False
        Caption = #31867#22411':'
      end
      object edtBandID: TEdit
        Left = 148
        Top = 73
        Width = 154
        Height = 21
        ReadOnly = True
        TabOrder = 0
      end
      object edtShopID: TEdit
        Left = 447
        Top = 19
        Width = 154
        Height = 21
        ReadOnly = True
        TabOrder = 1
      end
      object edtLeftCoin: TEdit
        Left = 445
        Top = 128
        Width = 148
        Height = 21
        ReadOnly = True
        TabOrder = 2
      end
      object edtRechargeCoin: TEdit
        Left = 148
        Top = 128
        Width = 157
        Height = 21
        TabOrder = 3
        Text = '10'
      end
      object edtAPPID: TEdit
        Left = 148
        Top = 19
        Width = 154
        Height = 21
        ReadOnly = True
        TabOrder = 4
      end
      object edtTypeName: TEdit
        Left = 444
        Top = 73
        Width = 158
        Height = 21
        TabOrder = 5
      end
    end
    object GroupBox3: TGroupBox
      Left = 8
      Top = 240
      Width = 857
      Height = 329
      Caption = #20250#21592#35760#24405
      TabOrder = 2
      object dgRecharge: TDBGrid
        Left = 0
        Top = 15
        Width = 849
        Height = 258
        DataSource = dsRecharge
        TabOrder = 0
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -11
        TitleFont.Name = 'MS Sans Serif'
        TitleFont.Style = []
        Columns = <
          item
            Expanded = False
            FieldName = 'trxid'
            Title.Caption = #27969#27700#21495
            Width = 200
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'appid'
            Title.Caption = #20844#20247#21495
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'shopid'
            Title.Caption = #21543#21488#21495
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'bandid'
            Title.Caption = #25163#29615'ID'
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'coin'
            Title.Caption = #20805#24065
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'leftcoin'
            Title.Caption = #20313#24065
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'totalcoin'
            Title.Caption = #24635#24065
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'payid'
            Title.Caption = #20805#20540#26041#24335
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'operatetime'
            Title.Caption = #20805#20540#26102#38388
            Visible = True
          end>
      end
    end
  end
  object ADOQRecharge: TADOQuery
    Parameters = <>
    Left = 280
    Top = 534
  end
  object dsRecharge: TDataSource
    DataSet = ADOQRecharge
    Left = 240
    Top = 536
  end
  object commRecharge: TComm
    CommName = 'COM1'
    BaudRate = 9600
    ParityCheck = False
    Outx_CtsFlow = False
    Outx_DsrFlow = False
    DtrControl = DtrEnable
    DsrSensitivity = False
    TxContinueOnXoff = True
    Outx_XonXoffFlow = False
    Inx_XonXoffFlow = False
    ReplaceWhenParityError = False
    IgnoreNullChar = False
    RtsControl = RtsEnable
    XonLimit = 500
    XoffLimit = 500
    ByteSize = _8
    Parity = None
    StopBits = _1
    XonChar = #17
    XoffChar = #19
    ReplacedChar = #0
    ReadIntervalTimeout = 100
    ReadTotalTimeoutMultiplier = 0
    ReadTotalTimeoutConstant = 0
    WriteTotalTimeoutMultiplier = 0
    WriteTotalTimeoutConstant = 0
    OnReceiveData = commRechargeReceiveData
    Left = 320
    Top = 536
  end
end
