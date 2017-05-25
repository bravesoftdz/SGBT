object frm_check_detail: Tfrm_check_detail
  Left = 486
  Top = 203
  Width = 644
  Height = 544
  Caption = #30005#23376#24065#26657#39564
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
  object panel_checkdetail: TPanel
    Left = 8
    Top = 0
    Width = 625
    Height = 97
    TabOrder = 0
    object Lab_id: TLabel
      Left = 8
      Top = 32
      Width = 105
      Height = 25
      AutoSize = False
      Caption = #30005#23376#24065'ID:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -18
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object edit_id: TEdit
      Left = 112
      Top = 31
      Width = 193
      Height = 21
      TabOrder = 0
    end
  end
  object GroupBox_checkdetail: TGroupBox
    Left = 0
    Top = 88
    Width = 633
    Height = 361
    Caption = #30005#23376#24065#26126#32454
    TabOrder = 1
    object DBGrid_checkdetail: TDBGrid
      Left = 0
      Top = 16
      Width = 633
      Height = 321
      DataSource = ds_checkdetail
      TabOrder = 0
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -11
      TitleFont.Name = 'MS Sans Serif'
      TitleFont.Style = []
      Columns = <
        item
          Expanded = False
          FieldName = 'MD_ID'
          Title.Caption = #24207#21495
          Width = 50
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'ID_USERCARD'
          Title.Caption = #30005#23376#24065'ID'
          Width = 60
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'MEMCARDNO'
          Title.Caption = #20250#21592
          Width = 60
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'CUSERNO'
          Title.Caption = #25805#20316#21592
          Width = 50
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'GETTIME'
          Title.Caption = #20805#20540#26102#38388
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'COSTMONEY'
          Title.Caption = #20805#20540
          Width = 50
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'EXPIRETIME'
          Title.Caption = #22833#25928#26102#38388
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'TUIBI_TIME'
          Title.Caption = #36864#24065#26102#38388
          Visible = True
        end>
    end
  end
  object ds_checkdetail: TDataSource
    DataSet = ADOQuery_checkdetail
    Left = 504
    Top = 112
  end
  object ADOQuery_checkdetail: TADOQuery
    Parameters = <>
    Left = 504
    Top = 144
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
    Left = 9
    Top = 452
  end
end
