object frmCoinInitial: TfrmCoinInitial
  Left = 354
  Top = 284
  Width = 1065
  Height = 565
  BorderStyle = bsSizeToolWin
  Caption = #30005#23376#24065#21021#22987#21270
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  WindowState = wsMaximized
  OnClose = FormClose
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 1001
    Height = 529
    Caption = 'Panel1'
    TabOrder = 0
    object GroupBox1: TGroupBox
      Left = 0
      Top = 0
      Width = 593
      Height = 193
      Caption = #21021#22987#21270#36873#39033
      TabOrder = 0
      object Label1: TLabel
        Left = 16
        Top = 19
        Width = 116
        Height = 25
        AutoSize = False
        Caption = #20844#20247#21495
      end
      object Label2: TLabel
        Left = 309
        Top = 21
        Width = 115
        Height = 25
        Alignment = taCenter
        AutoSize = False
        Caption = #21345#21151#33021#31867#22411
      end
      object lblMessage: TLabel
        Left = 16
        Top = 168
        Width = 489
        Height = 17
        Alignment = taCenter
        AutoSize = False
        Caption = #25552#31034#20449#24687
      end
      object Label3: TLabel
        Left = 16
        Top = 122
        Width = 116
        Height = 25
        AutoSize = False
        Caption = #30005#23376#24065'ID'
      end
      object Label4: TLabel
        Left = 16
        Top = 71
        Width = 116
        Height = 25
        AutoSize = False
        Caption = #21543#21488#32534#21495
      end
      object Label6: TLabel
        Left = 314
        Top = 72
        Width = 102
        Height = 25
        Alignment = taCenter
        AutoSize = False
        Caption = #21021#22987#24065#25968
      end
      object Label7: TLabel
        Left = 315
        Top = 120
        Width = 105
        Height = 25
        Alignment = taCenter
        AutoSize = False
        Caption = #28040#36153#23450#39069
      end
      object label5: TLabel
        Left = 308
        Top = 164
        Width = 116
        Height = 25
        Alignment = taCenter
        AutoSize = False
        Caption = #21345#31867#22411'ID'
      end
      object edtShopID: TEdit
        Left = 146
        Top = 71
        Width = 158
        Height = 21
        ReadOnly = True
        TabOrder = 0
      end
      object cbCoinType: TComboBox
        Left = 424
        Top = 21
        Width = 143
        Height = 21
        ItemHeight = 13
        TabOrder = 1
        Text = #29992#25143#21345
      end
      object edtBandID: TEdit
        Left = 146
        Top = 122
        Width = 158
        Height = 21
        ReadOnly = True
        TabOrder = 2
      end
      object edtAPPID: TEdit
        Left = 146
        Top = 21
        Width = 158
        Height = 21
        ReadOnly = True
        TabOrder = 3
      end
      object edtCoin: TEdit
        Left = 424
        Top = 68
        Width = 148
        Height = 21
        TabOrder = 4
        Text = '0'
      end
      object edtCoinCost: TEdit
        Left = 424
        Top = 114
        Width = 149
        Height = 21
        TabOrder = 5
        Text = '1'
      end
      object edtTypeID: TEdit
        Left = 426
        Top = 166
        Width = 145
        Height = 21
        TabOrder = 6
      end
    end
    object GroupBox2: TGroupBox
      Left = 600
      Top = 8
      Width = 385
      Height = 185
      Caption = #25805#20316
      TabOrder = 1
      object btnInitial: TButton
        Left = 83
        Top = 36
        Width = 177
        Height = 49
        Caption = #21021#22987#21270
        TabOrder = 0
        OnClick = btnInitialClick
      end
      object btnDelete: TButton
        Left = 88
        Top = 104
        Width = 169
        Height = 49
        Caption = #21024#38500
        TabOrder = 1
        OnClick = btnDeleteClick
      end
    end
    object GroupBox3: TGroupBox
      Left = 4
      Top = 192
      Width = 981
      Height = 335
      Caption = #21021#22987#21270#35760#24405
      TabOrder = 2
      object dgInitial: TDBGrid
        Left = 0
        Top = 18
        Width = 977
        Height = 311
        DataSource = dsInitial
        ReadOnly = True
        TabOrder = 0
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -11
        TitleFont.Name = 'MS Sans Serif'
        TitleFont.Style = []
        Columns = <
          item
            Expanded = False
            FieldName = 'ID'
            Title.Caption = #24207#21495
            Width = 32
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
            FieldName = 'TYPE_NAME'
            Title.Caption = #31867#22411
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'APPID'
            Title.Caption = #20844#20247#21495
            Width = 60
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'SHOPID'
            Title.Caption = #21543#21488#21495
            Width = 60
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'INITIAL_COIN'
            Title.Caption = #21021#22987#24065#25968
            Width = 55
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'OPERATE_TIME'
            Title.Caption = #25805#20316#26102#38388
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'OPERATOR_NO'
            Title.Caption = #25805#20316#21592
            Visible = True
          end>
      end
    end
  end
  object ADOQueryInitial: TADOQuery
    Parameters = <>
    Left = 192
    Top = 496
  end
  object dsInitial: TDataSource
    DataSet = ADOQueryInitial
    Left = 240
    Top = 496
  end
  object commInitial: TComm
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
    OnReceiveData = commInitialReceiveData
    Left = 280
    Top = 496
  end
end
