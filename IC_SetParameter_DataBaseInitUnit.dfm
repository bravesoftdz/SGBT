object frm_IC_SetParameter_DataBaseInit: Tfrm_IC_SetParameter_DataBaseInit
  Left = 642
  Top = 409
  Width = 578
  Height = 278
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
    Width = 562
    Height = 240
    Align = alClient
    Caption = 'Panel1'
    TabOrder = 0
    object GroupBox5: TGroupBox
      Left = 1
      Top = 1
      Width = 560
      Height = 238
      Align = alClient
      Caption = #20986#21378#21021#22987#21270
      TabOrder = 0
      object lblMessage: TPanel
        Left = 8
        Top = 136
        Width = 545
        Height = 41
        BevelOuter = bvNone
        Caption = #25552#31034#20449#24687
        TabOrder = 0
      end
      object GroupBox1: TGroupBox
        Left = 8
        Top = 16
        Width = 385
        Height = 105
        Caption = #20449#24687
        TabOrder = 1
        object Label2: TLabel
          Left = 16
          Top = 20
          Width = 60
          Height = 13
          Caption = #23458#25143#32534#21495#65306
        end
        object Label8: TLabel
          Left = 16
          Top = 68
          Width = 60
          Height = 13
          Caption = #20986#21378#23494#30721#65306
        end
        object edtCusotmerPasswd: TEdit
          Left = 90
          Top = 63
          Width = 201
          Height = 21
          Enabled = False
          TabOrder = 0
        end
        object Comb_Customer_Name: TComboBox
          Left = 90
          Top = 15
          Width = 201
          Height = 21
          ItemHeight = 13
          TabOrder = 1
          Text = #35831#28857#20987#36873#25321
          OnClick = Comb_Customer_NameClick
        end
      end
      object GroupBox2: TGroupBox
        Left = 400
        Top = 16
        Width = 161
        Height = 105
        Caption = #25805#20316
        TabOrder = 2
        object Bit_Close: TBitBtn
          Left = 38
          Top = 64
          Width = 97
          Height = 25
          Caption = #20851#38381
          TabOrder = 0
          OnClick = Bit_CloseClick
        end
        object Bit_Add: TBitBtn
          Left = 38
          Top = 24
          Width = 97
          Height = 25
          Caption = #20986#21378#21021#22987#21270
          TabOrder = 1
          OnClick = Bit_AddClick
        end
      end
    end
  end
  object ADOQuery_newCustomer: TADOQuery
    Parameters = <>
    Left = 113
    Top = 196
  end
  object DataSource_Newmenber: TDataSource
    DataSet = ADOQuery_newCustomer
    Left = 153
    Top = 196
  end
  object Comm_Check: TComm
    CommName = 'COM4'
    BaudRate = 115200
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
    Left = 193
    Top = 193
  end
  object Timer_HAND: TTimer
    Enabled = False
    Interval = 100
    OnTimer = Timer_HANDTimer
    Left = 320
    Top = 200
  end
  object Timer_USERPASSWORD: TTimer
    Enabled = False
    Interval = 100
    OnTimer = Timer_USERPASSWORDTimer
    Left = 376
    Top = 200
  end
  object Timer_3FPASSWORD: TTimer
    Enabled = False
    Interval = 100
    OnTimer = Timer_3FPASSWORDTimer
    Left = 424
    Top = 200
  end
  object Timer_3FLOADDATE: TTimer
    Enabled = False
    Interval = 100
    OnTimer = Timer_3FLOADDATETimer
    Left = 464
    Top = 200
  end
end
