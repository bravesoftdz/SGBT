object frm_Frontoperate_InitID: Tfrm_Frontoperate_InitID
  Left = 565
  Top = 80
  Width = 815
  Height = 654
  BorderIcons = [biSystemMenu, biMinimize]
  Caption = #20986#21378#21021#22987#21270'-'#21021#22987#21270'ID'#21345
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 799
    Height = 459
    Align = alClient
    Caption = 'Panel1'
    TabOrder = 0
    object GroupBox5: TGroupBox
      Left = 1
      Top = 1
      Width = 797
      Height = 457
      Align = alClient
      Caption = 'ID'#20986#21378#21021#22987#21270#25805#20316
      TabOrder = 0
      object Label2: TLabel
        Left = 8
        Top = 24
        Width = 36
        Height = 13
        Caption = #21345#20540'    '
      end
      object Edit1: TEdit
        Left = 80
        Top = 19
        Width = 641
        Height = 21
        TabOrder = 0
      end
      object GroupBox1: TGroupBox
        Left = 408
        Top = 40
        Width = 313
        Height = 377
        Caption = #21021#22987#21270#20540#35774#23450
        TabOrder = 1
        object Label9: TLabel
          Left = 26
          Top = 78
          Width = 47
          Height = 13
          Caption = #24065'ID'#21495#65306
        end
        object Label4: TLabel
          Left = 25
          Top = 105
          Width = 47
          Height = 13
          Caption = #21345#21378'ID'#65306
        end
        object Label5: TLabel
          Left = 24
          Top = 132
          Width = 63
          Height = 13
          Caption = #21345#21378#23494#30721' '#65306
        end
        object Label7: TLabel
          Left = 25
          Top = 241
          Width = 57
          Height = 13
          Caption = #26657#39564#21644#65306'   '
        end
        object Label10: TLabel
          Left = 25
          Top = 213
          Width = 69
          Height = 13
          Caption = #21021#22987#25968#25454#65306'   '
        end
        object Label8: TLabel
          Left = 26
          Top = 186
          Width = 48
          Height = 13
          Caption = #21345#31867#22411#65306
        end
        object Label6: TLabel
          Left = 25
          Top = 159
          Width = 60
          Height = 13
          Caption = #29992#25143#23494#30721#65306
        end
        object Label11: TLabel
          Left = 25
          Top = 24
          Width = 69
          Height = 13
          Caption = #23458#25143#21517#31216#65306'   '
        end
        object Label12: TLabel
          Left = 25
          Top = 51
          Width = 69
          Height = 13
          Caption = #23458#25143#20195#30721#65306'   '
        end
        object Edit_ID: TEdit
          Left = 177
          Top = 78
          Width = 129
          Height = 21
          Enabled = False
          TabOrder = 0
        end
        object ID_3F: TEdit
          Left = 177
          Top = 106
          Width = 129
          Height = 21
          Enabled = False
          TabOrder = 1
        end
        object ID_Password_3F: TEdit
          Left = 177
          Top = 130
          Width = 129
          Height = 21
          Enabled = False
          TabOrder = 2
        end
        object ID_Password_USER: TEdit
          Left = 177
          Top = 157
          Width = 129
          Height = 21
          Enabled = False
          TabOrder = 3
          Text = '000'
        end
        object ID_Value: TEdit
          Left = 177
          Top = 214
          Width = 129
          Height = 21
          TabOrder = 4
          Text = '000000'
        end
        object ID_CheckSum: TEdit
          Left = 177
          Top = 241
          Width = 129
          Height = 21
          TabOrder = 5
        end
        object BitBtn_INIT: TBitBtn
          Left = 232
          Top = 328
          Width = 73
          Height = 41
          Caption = #21345#21021#22987#21270
          TabOrder = 6
          OnClick = BitBtn_INITClick
        end
        object BitBtn12: TBitBtn
          Left = 80
          Top = 328
          Width = 65
          Height = 41
          Caption = #37325#26032#35774#23450
          TabOrder = 7
          OnClick = BitBtn12Click
        end
        object ComboBox_Menbertype: TComboBox
          Left = 176
          Top = 187
          Width = 129
          Height = 21
          ItemHeight = 13
          TabOrder = 8
          Text = #29992#25143#21345
        end
        object BitBtn_Update: TBitBtn
          Left = 160
          Top = 328
          Width = 65
          Height = 41
          Caption = #26356#26032#20449#24687
          TabOrder = 9
          Visible = False
          OnClick = BitBtn_UpdateClick
        end
        object CheckBox_Update: TCheckBox
          Left = 8
          Top = 264
          Width = 297
          Height = 25
          Caption = #20462#25913#24403#21069#21345#30340#20449#24687#65292#35831#36873#25321
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clRed
          Font.Height = -16
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 10
          Visible = False
          OnClick = CheckBox_UpdateClick
        end
        object BitBtn18: TBitBtn
          Left = 8
          Top = 328
          Width = 65
          Height = 41
          Caption = #20851#38381
          TabOrder = 11
          OnClick = BitBtn18Click
        end
        object cbCustomName: TComboBox
          Left = 176
          Top = 16
          Width = 129
          Height = 21
          ItemHeight = 13
          TabOrder = 12
          Text = #35831#36873#25321#23458#25143#21517#31216
          OnClick = cbCustomNameClick
        end
        object cbCustomerNO: TComboBox
          Left = 176
          Top = 52
          Width = 129
          Height = 21
          ItemHeight = 13
          TabOrder = 13
          Text = #35831#36873#25321#23458#25143#32534#21495
          OnClick = cbCustomerNOClick
        end
      end
      object GroupBox2: TGroupBox
        Left = 8
        Top = 120
        Width = 393
        Height = 297
        Caption = #24403#21069#21345#30340#29992#25143#20449#24687
        TabOrder = 2
        object Label14: TLabel
          Left = 8
          Top = 16
          Width = 135
          Height = 13
          Caption = #23458#25143#21517#31216'('#25163#26426#21495#20026#20934')'#65306'   '
        end
        object Label15: TLabel
          Left = 8
          Top = 37
          Width = 141
          Height = 13
          Caption = #23458#25143#20195#30721'('#25968#25454#38271#24230'6'#20301')'#65306'   '
        end
        object Label16: TLabel
          Left = 8
          Top = 58
          Width = 141
          Height = 13
          Caption = #27492#23458#25143#25317#26377#19975#33021#21345#25968#37327#65306'   '
        end
        object Label17: TLabel
          Left = 8
          Top = 82
          Width = 150
          Height = 13
          Caption = #27492#23458#25143#25317#26377#32769#26495#21345#25968#37327#65306'      '
        end
        object Label18: TLabel
          Left = 8
          Top = 106
          Width = 150
          Height = 13
          Caption = #27492#23458#25143#25317#26377#31649#29702#21345#25968#37327#65306'      '
        end
        object Label19: TLabel
          Left = 8
          Top = 130
          Width = 150
          Height = 13
          Caption = #27492#23458#25143#25317#26377#26597#24080#21345#25968#37327#65306'      '
        end
        object Label20: TLabel
          Left = 8
          Top = 154
          Width = 150
          Height = 13
          Caption = #27492#23458#25143#25317#26377#25910#38134#21345#25968#37327#65306'      '
        end
        object Label21: TLabel
          Left = 8
          Top = 178
          Width = 150
          Height = 13
          Caption = #27492#23458#25143#25317#26377#35774#23450#21345#25968#37327#65306'      '
        end
        object Label22: TLabel
          Left = 8
          Top = 202
          Width = 150
          Height = 13
          Caption = #27492#23458#25143#25317#26377#24320#26426#21345#25968#37327#65306'      '
        end
        object Label23: TLabel
          Left = 8
          Top = 226
          Width = 150
          Height = 13
          Caption = #27492#23458#25143#25317#26377#29992#25143#21345#25968#37327#65306'      '
        end
        object Label24: TLabel
          Left = 8
          Top = 250
          Width = 138
          Height = 13
          Caption = #27492#23458#25143#25317#26377#24635#21345#25968#37327#65306'      '
        end
        object Label25: TLabel
          Left = 8
          Top = 274
          Width = 138
          Height = 13
          Caption = #27492#23458#25143#26368#21518#24320#21345#26102#38388#65306'      '
        end
        object Edit2: TEdit
          Left = 177
          Top = 10
          Width = 200
          Height = 21
          TabOrder = 0
        end
        object Edit3: TEdit
          Left = 177
          Top = 34
          Width = 200
          Height = 21
          TabOrder = 1
        end
        object Edit4: TEdit
          Left = 177
          Top = 58
          Width = 200
          Height = 21
          TabOrder = 2
        end
        object Edit5: TEdit
          Left = 177
          Top = 82
          Width = 200
          Height = 21
          TabOrder = 3
        end
        object Edit6: TEdit
          Left = 177
          Top = 106
          Width = 200
          Height = 21
          TabOrder = 4
        end
        object Edit7: TEdit
          Left = 177
          Top = 130
          Width = 200
          Height = 21
          TabOrder = 5
        end
        object Edit8: TEdit
          Left = 177
          Top = 154
          Width = 200
          Height = 21
          TabOrder = 6
        end
        object Edit9: TEdit
          Left = 177
          Top = 178
          Width = 200
          Height = 21
          TabOrder = 7
        end
        object Edit10: TEdit
          Left = 177
          Top = 202
          Width = 200
          Height = 21
          TabOrder = 8
        end
        object Edit11: TEdit
          Left = 177
          Top = 226
          Width = 200
          Height = 21
          TabOrder = 9
        end
        object Edit12: TEdit
          Left = 177
          Top = 250
          Width = 200
          Height = 21
          TabOrder = 10
        end
        object Edit13: TEdit
          Left = 177
          Top = 274
          Width = 200
          Height = 21
          TabOrder = 11
        end
      end
      object GroupBox3: TGroupBox
        Left = 8
        Top = 40
        Width = 393
        Height = 73
        Caption = #21021#22987#21270#25805#20316#20449#24687
        TabOrder = 3
        object Label3: TLabel
          Left = 9
          Top = 25
          Width = 60
          Height = 13
          Caption = #24065#19978#20313#39069#65306
        end
        object Label1: TLabel
          Left = 187
          Top = 25
          Width = 60
          Height = 13
          Caption = #25805#20316#36807#31243#65306
        end
        object Label13: TLabel
          Left = 8
          Top = 47
          Width = 78
          Height = 13
          Caption = #21021#22987#21270#32467#26524':     '
        end
        object Edit_PrintNO: TEdit
          Left = 80
          Top = 16
          Width = 73
          Height = 21
          Enabled = False
          TabOrder = 0
        end
        object Edit_OPResult: TEdit
          Left = 264
          Top = 16
          Width = 121
          Height = 21
          TabOrder = 1
        end
        object Edit14: TEdit
          Left = 80
          Top = 42
          Width = 305
          Height = 21
          TabOrder = 2
        end
      end
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 459
    Width = 799
    Height = 157
    Align = alBottom
    Caption = 'Panel1'
    TabOrder = 1
    object DBGrid2: TDBGrid
      Left = 1
      Top = 1
      Width = 797
      Height = 155
      Align = alClient
      DataSource = DataSource_Init
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
          FieldName = 'ID'
          Title.Alignment = taCenter
          Title.Caption = #24207#21495
          Width = 50
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'ID_INIT'
          Title.Caption = #24065'ID'
          Width = 55
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'ID_3F'
          Title.Caption = #21345#21378'ID'
          Width = 55
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'ID_typeName'
          Title.Caption = #21345#21151#33021
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'Customer_Name'
          Title.Caption = #23458#25143#21517#31216
          Visible = True
        end
        item
          Alignment = taCenter
          Expanded = False
          FieldName = 'ID_Inittime'
          Title.Alignment = taCenter
          Title.Caption = #20132#26131#26102#38388
          Visible = True
        end>
    end
  end
  object DataSource_Init: TDataSource
    DataSet = ADOQuery_Init
    Left = 73
    Top = 492
  end
  object ADOQuery_Init: TADOQuery
    Parameters = <>
    Left = 113
    Top = 492
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
    Left = 185
    Top = 492
  end
end
