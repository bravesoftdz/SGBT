object frmInitial: TfrmInitial
  Left = 1001
  Top = 206
  Width = 853
  Height = 571
  Caption = #21021#22987#21270#30028#38754
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
    Width = 833
    Height = 529
    Caption = 'Panel1'
    TabOrder = 0
    object GroupBox1: TGroupBox
      Left = 0
      Top = 0
      Width = 513
      Height = 209
      Caption = #21021#22987#21270#36873#39033
      TabOrder = 0
      object Label1: TLabel
        Left = 8
        Top = 25
        Width = 153
        Height = 25
        AutoSize = False
        Caption = #22330#22320#32534#21495'ShopID'
      end
      object Label2: TLabel
        Left = 8
        Top = 105
        Width = 153
        Height = 25
        AutoSize = False
        Caption = #21345#21151#33021#31867#22411
      end
      object lblMessage: TLabel
        Left = 8
        Top = 168
        Width = 489
        Height = 33
        Alignment = taCenter
        AutoSize = False
        Caption = #25552#31034#20449#24687
      end
      object Label3: TLabel
        Left = 8
        Top = 65
        Width = 153
        Height = 25
        AutoSize = False
        Caption = #25163#29615'ID'
      end
      object edtShopID: TEdit
        Left = 176
        Top = 25
        Width = 233
        Height = 21
        TabOrder = 0
      end
      object cbCoinType: TComboBox
        Left = 176
        Top = 105
        Width = 233
        Height = 21
        ItemHeight = 13
        TabOrder = 1
        Text = #29992#25143#21345
      end
      object edtBandID: TEdit
        Left = 176
        Top = 65
        Width = 233
        Height = 21
        TabOrder = 2
      end
      object memo1: TMemo
        Left = 416
        Top = 16
        Width = 81
        Height = 105
        Lines.Strings = (
          'memo1')
        TabOrder = 3
      end
    end
    object GroupBox2: TGroupBox
      Left = 520
      Top = 0
      Width = 289
      Height = 209
      Caption = #25805#20316
      TabOrder = 1
      object btnInitial: TButton
        Left = 56
        Top = 40
        Width = 169
        Height = 49
        Caption = #21021#22987#21270
        TabOrder = 0
        OnClick = btnInitialClick
      end
      object btnExit: TButton
        Left = 56
        Top = 112
        Width = 169
        Height = 49
        Caption = #36864#20986
        TabOrder = 1
      end
    end
    object GroupBox3: TGroupBox
      Left = 0
      Top = 216
      Width = 817
      Height = 313
      Caption = #21021#22987#21270#35760#24405
      TabOrder = 2
      object dgInitial: TDBGrid
        Left = 0
        Top = 18
        Width = 809
        Height = 265
        DataSource = dsInitial
        TabOrder = 0
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -11
        TitleFont.Name = 'MS Sans Serif'
        TitleFont.Style = []
        Columns = <
          item
            Expanded = False
            FieldName = 'coinid'
            Title.Caption = #25163#29615'ID'
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'id_3f'
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'password_3f'
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'password_user'
            Title.Caption = #22330#22320
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'id_type'
            Title.Caption = #31867#22411
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'id_value'
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'operatorno'
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'operatetime'
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
    Outx_XonXoffFlow = True
    Inx_XonXoffFlow = True
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
