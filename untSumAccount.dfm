object frmAccountSum: TfrmAccountSum
  Left = 399
  Top = 60
  Width = 952
  Height = 614
  BorderStyle = bsSizeToolWin
  Caption = #24635#36134
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
    Left = 0
    Top = 0
    Width = 937
    Height = 577
    Caption = 'Panel1'
    TabOrder = 0
    object GroupBox1: TGroupBox
      Left = 0
      Top = 0
      Width = 649
      Height = 225
      Caption = #24635#36134#26126#32454
      TabOrder = 0
      object Label1: TLabel
        Left = 5
        Top = 21
        Width = 124
        Height = 25
        Alignment = taCenter
        AutoSize = False
        Caption = #20844#20247#21495
      end
      object Label2: TLabel
        Left = 325
        Top = 21
        Width = 132
        Height = 25
        Alignment = taCenter
        AutoSize = False
        Caption = #21543#21488#21495
      end
      object Label3: TLabel
        Left = 325
        Top = 144
        Width = 118
        Height = 24
        Alignment = taCenter
        AutoSize = False
        Caption = #24635#36134
      end
      object Label4: TLabel
        Left = 5
        Top = 84
        Width = 118
        Height = 25
        Alignment = taCenter
        AutoSize = False
        Caption = #25163#29615'ID'
      end
      object Label5: TLabel
        Left = 5
        Top = 144
        Width = 124
        Height = 25
        Alignment = taCenter
        AutoSize = False
        Caption = #36134#26399
      end
      object lblMessage: TLabel
        Left = 96
        Top = 184
        Width = 505
        Height = 25
        Alignment = taCenter
        AutoSize = False
        Caption = #25552#31034#20449#24687
      end
      object Label6: TLabel
        Left = 325
        Top = 88
        Width = 124
        Height = 25
        Alignment = taCenter
        AutoSize = False
        Caption = #21345#31867#22411
      end
      object edtAPPID: TEdit
        Left = 142
        Top = 16
        Width = 164
        Height = 21
        ReadOnly = True
        TabOrder = 0
      end
      object edtShopID: TEdit
        Left = 470
        Top = 21
        Width = 169
        Height = 21
        ReadOnly = True
        TabOrder = 1
      end
      object edtAccountSum: TEdit
        Left = 469
        Top = 144
        Width = 167
        Height = 21
        TabOrder = 2
      end
      object edtBandID: TEdit
        Left = 142
        Top = 88
        Width = 164
        Height = 21
        ReadOnly = True
        TabOrder = 3
      end
      object edtGatherID: TEdit
        Left = 142
        Top = 144
        Width = 164
        Height = 21
        ReadOnly = True
        TabOrder = 4
      end
      object edtTypeName: TEdit
        Left = 470
        Top = 84
        Width = 171
        Height = 21
        ReadOnly = True
        TabOrder = 5
      end
    end
    object GroupBox2: TGroupBox
      Left = 656
      Top = 0
      Width = 273
      Height = 225
      Caption = #25805#20316
      TabOrder = 1
      object btnCollect: TButton
        Left = 48
        Top = 24
        Width = 169
        Height = 57
        Caption = #37319#38598
        TabOrder = 0
        OnClick = btnCollectClick
      end
      object btnUpload: TButton
        Left = 48
        Top = 112
        Width = 174
        Height = 57
        Caption = #19978#20256
        TabOrder = 1
        OnClick = btnUploadClick
      end
    end
    object GroupBox3: TGroupBox
      Left = 0
      Top = 224
      Width = 929
      Height = 321
      Caption = #24635#36134#35760#24405
      TabOrder = 2
      object dgAccountSum: TDBGrid
        Left = 4
        Top = 15
        Width = 645
        Height = 120
        DataSource = dsAccountSum
        TabOrder = 0
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -11
        TitleFont.Name = 'MS Sans Serif'
        TitleFont.Style = []
        Columns = <
          item
            Expanded = False
            FieldName = 'collectid'
            Title.Caption = #25209#27425#21495
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'appid'
            Title.Caption = #20844#20247#21495
            Width = 48
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'shopid'
            Title.Caption = #21543#21488#21495
            Width = 60
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'coin'
            Title.Caption = #24635#36134
            Width = 60
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'state'
            Title.Caption = #29366#24577
            Width = 60
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'operatetime'
            Title.Caption = #25805#20316#26102#38388
            Visible = True
          end>
      end
    end
  end
  object commAccountSum: TComm
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
    OnReceiveData = commAccountSumReceiveData
    Left = 448
    Top = 544
  end
  object dsAccountSum: TDataSource
    DataSet = ADOQAccountSum
    Left = 416
    Top = 544
  end
  object ADOQAccountSum: TADOQuery
    Parameters = <>
    Left = 384
    Top = 544
  end
end
