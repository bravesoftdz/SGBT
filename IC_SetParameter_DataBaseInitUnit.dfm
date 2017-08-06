object frm_IC_SetParameter_DataBaseInit: Tfrm_IC_SetParameter_DataBaseInit
  Left = 705
  Top = 387
  Width = 592
  Height = 296
  Caption = #20986#21378#37197#32622#21021#22987#21270
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 576
    Height = 258
    Align = alClient
    Caption = 'Panel1'
    TabOrder = 0
    object GroupBox5: TGroupBox
      Left = 1
      Top = 1
      Width = 574
      Height = 256
      Align = alClient
      Caption = #20986#21378#21021#22987#21270
      TabOrder = 0
      object lblMessage: TPanel
        Left = 8
        Top = 136
        Width = 545
        Height = 41
        BevelOuter = bvNone
        Caption = #25552#31034#20449#24687','#20986#21378#21021#22987#21270#20250#21024#38500#25152#26377#25968#25454','#35831#35880#24910#25805#20316
        Color = clRed
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
      end
      object GroupBox2: TGroupBox
        Left = 8
        Top = 16
        Width = 553
        Height = 105
        Caption = #25805#20316
        TabOrder = 1
        object btnFactoryInitial: TBitBtn
          Left = 22
          Top = 16
          Width = 163
          Height = 34
          Caption = #20986#21378#21021#22987#21270#28165#38500#25152#26377#25968#25454
          TabOrder = 0
          OnClick = btnFactoryInitialClick
        end
        object btnClearCoinRecharge: TButton
          Left = 24
          Top = 56
          Width = 161
          Height = 42
          Caption = #20805#20540#35760#24405#21021#22987#21270
          TabOrder = 1
          OnClick = btnClearCoinRechargeClick
        end
        object btnClearBarFlow: TButton
          Left = 208
          Top = 16
          Width = 145
          Height = 33
          Caption = #20817#25442#27969#27700#21021#22987#21270
          TabOrder = 2
          OnClick = btnClearBarFlowClick
        end
        object btnClearCoinRefund: TButton
          Left = 208
          Top = 56
          Width = 145
          Height = 41
          Caption = #36864#24065#35760#24405#21021#22987#21270
          TabOrder = 3
          OnClick = btnClearCoinRefundClick
        end
      end
    end
  end
  object Comm_Check: TComm
    CommName = 'COM1'
    BaudRate = 9600
    ParityCheck = False
    Outx_CtsFlow = False
    Outx_DsrFlow = False
    DtrControl = DtrEnable
    DsrSensitivity = False
    TxContinueOnXoff = False
    Outx_XonXoffFlow = False
    Inx_XonXoffFlow = False
    ReplaceWhenParityError = False
    IgnoreNullChar = False
    RtsControl = RtsDisable
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
    OnReceiveData = Comm_CheckReceiveData
    Left = 137
    Top = 169
  end
end
