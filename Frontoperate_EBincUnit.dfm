object frm_EBInc: Tfrm_EBInc
  Left = 192
  Top = 114
  Width = 526
  Height = 444
  Caption = 'frm_EBInc'
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
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 518
    Height = 253
    Align = alClient
    Caption = 'Panel1'
    TabOrder = 0
    object GroupBox5: TGroupBox
      Left = 1
      Top = 1
      Width = 516
      Height = 251
      Align = alClient
      Caption = #30005#23376#24065#20805#20540#25805#20316
      TabOrder = 0
      object Label3: TLabel
        Left = 201
        Top = 25
        Width = 60
        Height = 13
        Caption = #24065#19978#20313#39069#65306
      end
      object Label9: TLabel
        Left = 16
        Top = 24
        Width = 47
        Height = 13
        Caption = #24065'ID'#21495#65306
      end
      object Label1: TLabel
        Left = 345
        Top = 25
        Width = 36
        Height = 13
        Caption = #25805#20316#65306
      end
      object Edit_ID: TEdit
        Left = 64
        Top = 24
        Width = 129
        Height = 21
        Enabled = False
        TabOrder = 0
      end
      object Edit_PrintNO: TEdit
        Left = 264
        Top = 24
        Width = 73
        Height = 21
        Enabled = False
        TabOrder = 1
      end
      object BitBtn1: TBitBtn
        Left = 408
        Top = 155
        Width = 81
        Height = 30
        Caption = #28165#21345#20540
        TabOrder = 2
        OnClick = BitBtn1Click
      end
      object BitBtn2: TBitBtn
        Left = 14
        Top = 64
        Width = 65
        Height = 57
        Caption = '500'
        TabOrder = 3
      end
      object BitBtn3: TBitBtn
        Left = 93
        Top = 64
        Width = 65
        Height = 57
        Caption = '400'
        TabOrder = 4
      end
      object BitBtn4: TBitBtn
        Left = 168
        Top = 64
        Width = 65
        Height = 57
        Caption = '300'
        TabOrder = 5
      end
      object BitBtn5: TBitBtn
        Left = 248
        Top = 64
        Width = 65
        Height = 57
        Caption = '200'
        TabOrder = 6
      end
      object BitBtn6: TBitBtn
        Left = 328
        Top = 64
        Width = 65
        Height = 57
        Caption = '100'
        TabOrder = 7
      end
      object BitBtn7: TBitBtn
        Left = 14
        Top = 131
        Width = 65
        Height = 57
        Caption = '50'
        TabOrder = 8
      end
      object BitBtn8: TBitBtn
        Left = 93
        Top = 131
        Width = 65
        Height = 57
        Caption = '40'
        TabOrder = 9
      end
      object BitBtn9: TBitBtn
        Left = 168
        Top = 131
        Width = 65
        Height = 57
        Caption = '30'
        TabOrder = 10
      end
      object BitBtn10: TBitBtn
        Left = 248
        Top = 131
        Width = 65
        Height = 57
        Caption = '20'
        TabOrder = 11
      end
      object BitBtn11: TBitBtn
        Left = 328
        Top = 131
        Width = 65
        Height = 57
        Caption = '10'
        TabOrder = 12
      end
      object BitBtn12: TBitBtn
        Left = 14
        Top = 200
        Width = 65
        Height = 57
        Caption = '5'
        TabOrder = 13
      end
      object BitBtn13: TBitBtn
        Left = 93
        Top = 200
        Width = 65
        Height = 57
        Caption = '4'
        TabOrder = 14
      end
      object BitBtn14: TBitBtn
        Left = 168
        Top = 200
        Width = 65
        Height = 57
        Caption = '3'
        TabOrder = 15
      end
      object BitBtn15: TBitBtn
        Left = 248
        Top = 200
        Width = 65
        Height = 57
        Caption = '2'
        TabOrder = 16
      end
      object BitBtn16: TBitBtn
        Left = 328
        Top = 200
        Width = 65
        Height = 57
        Caption = '1'
        TabOrder = 17
      end
      object BitBtn17: TBitBtn
        Left = 408
        Top = 65
        Width = 81
        Height = 32
        Caption = #39564#35777#21345
        TabOrder = 18
      end
      object BitBtn18: TBitBtn
        Left = 407
        Top = 200
        Width = 81
        Height = 57
        Caption = #20851#38381
        TabOrder = 19
      end
      object Edit_OPResult: TEdit
        Left = 376
        Top = 24
        Width = 121
        Height = 21
        TabOrder = 20
      end
      object BitBtn19: TBitBtn
        Left = 408
        Top = 112
        Width = 81
        Height = 30
        Caption = #35835#21345#20540
        TabOrder = 21
      end
      object Edit1: TEdit
        Left = 16
        Top = 48
        Width = 481
        Height = 21
        TabOrder = 22
        Text = 'Edit1'
      end
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 253
    Width = 518
    Height = 157
    Align = alBottom
    Caption = 'Panel1'
    TabOrder = 1
    object DBGrid2: TDBGrid
      Left = 1
      Top = 1
      Width = 516
      Height = 155
      Align = alClient
      DataSource = DataSource_Incvalue
      Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit]
      TabOrder = 0
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -11
      TitleFont.Name = 'MS Sans Serif'
      TitleFont.Style = []
      Columns = <
        item
          Alignment = taCenter
          Expanded = False
          FieldName = 'MD_ID'
          Title.Alignment = taCenter
          Title.Caption = #24207#21495
          Width = 50
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'IDCardNo'
          Title.Caption = #24065'ID'
          Visible = True
        end
        item
          Alignment = taCenter
          Expanded = False
          FieldName = 'cUserNo'
          Title.Alignment = taCenter
          Title.Caption = #25805#20316#21592
          Width = 116
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'CostMoney'
          Title.Caption = #20805#20540
          Visible = True
        end
        item
          Alignment = taCenter
          Expanded = False
          FieldName = 'GetTime'
          Title.Alignment = taCenter
          Title.Caption = #20132#26131#26102#38388
          Width = 141
          Visible = True
        end>
    end
  end
  object DataSource_Incvalue: TDataSource
    DataSet = ADOQuery_Incvalue
    Left = 41
    Top = 276
  end
  object ADOQuery_Incvalue: TADOQuery
    Parameters = <>
    Left = 73
    Top = 276
  end
  object DataSource_Newmenber: TDataSource
    DataSet = ADOQuery_newmenber
    Left = 81
    Top = 116
  end
  object ADOQuery_newmenber: TADOQuery
    Parameters = <>
    Left = 113
    Top = 116
  end
  object comReader: TComm
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
    OnReceiveData = comReaderReceiveData
    Left = 113
    Top = 273
  end
end
