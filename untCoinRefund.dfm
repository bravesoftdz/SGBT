object frmCoinRefund: TfrmCoinRefund
  Left = 352
  Top = 124
  Width = 907
  Height = 644
  BorderStyle = bsSizeToolWin
  Caption = #30005#23376#24065#20805#20540
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
  object lbl2: TLabel
    Left = 73
    Top = 114
    Width = 137
    Height = 33
    Alignment = taCenter
    AutoSize = False
    Caption = #24403#21069#37329#39069':'
  end
  object Panel1: TPanel
    Left = 0
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
      object btnSubmit: TButton
        Left = 40
        Top = 41
        Width = 153
        Height = 49
        Caption = #36864#24065
        TabOrder = 0
        OnClick = btnSubmitClick
      end
      object btnCancel: TButton
        Left = 40
        Top = 120
        Width = 153
        Height = 42
        Caption = #21462#28040
        TabOrder = 1
        OnClick = btnCancelClick
      end
    end
    object GroupBox1: TGroupBox
      Left = 0
      Top = 8
      Width = 617
      Height = 229
      Caption = #20805#20540
      TabOrder = 1
      object Label1: TLabel
        Left = 97
        Top = 57
        Width = 123
        Height = 33
        Alignment = taCenter
        AutoSize = False
        Caption = #30005#23376#24065'ID:'
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
      object lbl1: TLabel
        Left = 89
        Top = 114
        Width = 137
        Height = 33
        Alignment = taCenter
        AutoSize = False
        Caption = #24403#21069#37329#39069':'
      end
      object edtCoinID: TEdit
        Left = 232
        Top = 56
        Width = 162
        Height = 21
        ReadOnly = True
        TabOrder = 0
      end
      object edtLeftCoin: TEdit
        Left = 232
        Top = 112
        Width = 157
        Height = 21
        TabOrder = 1
      end
    end
    object GroupBox3: TGroupBox
      Left = 8
      Top = 240
      Width = 857
      Height = 329
      Caption = #36864#24065#35760#24405
      TabOrder = 2
      object dbgrdCoinRecharge: TDBGrid
        Left = 0
        Top = 15
        Width = 849
        Height = 258
        DataSource = dsCoinRecharge
        TabOrder = 0
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -11
        TitleFont.Name = 'MS Sans Serif'
        TitleFont.Style = []
        Columns = <
          item
            Expanded = False
            FieldName = 'id'
            Title.Caption = #24207#21495
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'COIN_ID'
            Title.Caption = #30005#23376#24065'ID'
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'oper_coin'
            Title.Caption = #25805#20316#37329#39069
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'operate_time'
            Title.Caption = #25805#20316#26102#38388
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'operator_no'
            Title.Caption = #25805#20316#21592
            Visible = True
          end>
      end
    end
  end
  object ADOQCoinRecharge: TADOQuery
    Parameters = <>
    Left = 280
    Top = 534
  end
  object dsCoinRecharge: TDataSource
    DataSet = ADOQCoinRecharge
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
