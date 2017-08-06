object frm_SetParameter_CardMC_IDINIT: Tfrm_SetParameter_CardMC_IDINIT
  Left = 245
  Top = 145
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = #20986#21378#21021#22987#21270'-'#21345#22836'ID'#21021#22987#21270
  ClientHeight = 396
  ClientWidth = 524
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 524
    Height = 396
    Align = alClient
    Caption = 'Panel1'
    TabOrder = 0
    object Panel4: TPanel
      Left = 1
      Top = 241
      Width = 522
      Height = 154
      Align = alClient
      TabOrder = 0
      object GroupBox2: TGroupBox
        Left = 1
        Top = 1
        Width = 520
        Height = 152
        Align = alClient
        Caption = #21345#22836'ID'#35774#32622#35760#24405
        TabOrder = 0
        object DBGrid_CardID_3FInit: TDBGrid
          Left = 2
          Top = 15
          Width = 516
          Height = 135
          Align = alClient
          DataSource = DataSource_CardID_3FInit
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
              FieldName = 'Customer_Name'
              Title.Caption = #23458#25143#21517#31216
              Width = 60
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'Customer_NO'
              Title.Caption = #23458#25143#32534#21495
              Width = 50
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'CardHead_ID'
              Title.Caption = #21345#22836'ID'
              Width = 50
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'cardhead_id_ic'
              Title.Caption = #21345#22836'IC_ID'
              Width = 50
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'Customer_Time'
              Title.Caption = #35774#32622#26085#26399
              Visible = True
            end>
        end
      end
    end
    object Panel1: TPanel
      Left = 1
      Top = 1
      Width = 522
      Height = 240
      Align = alTop
      Caption = 'Panel1'
      TabOrder = 1
      object GroupBox1: TGroupBox
        Left = 1
        Top = 1
        Width = 520
        Height = 238
        Align = alClient
        Caption = #21021#22987#21270#20540#35774#23450
        TabOrder = 0
        object Label4: TLabel
          Left = 8
          Top = 110
          Width = 143
          Height = 13
          Caption = #23558#35201#35774#32622#30340#21345#22836'ID'#21495#65306'        '
        end
        object Label5: TLabel
          Left = 7
          Top = 49
          Width = 93
          Height = 13
          Caption = #23458#25143#32534#21495#65306'           '
        end
        object Label1: TLabel
          Left = 8
          Top = 125
          Width = 108
          Height = 20
          Caption = #25805#20316#20449#24687#65306'       '
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clRed
          Font.Height = -16
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          OnClick = Label1Click
        end
        object Label2: TLabel
          Left = 9
          Top = 20
          Width = 93
          Height = 13
          Caption = #23458#25143#21517#31216#65306'           '
        end
        object Label3: TLabel
          Left = 8
          Top = 80
          Width = 132
          Height = 13
          Caption = #27492#23458#25143#20849#26377#21345#22836#25968#65306'        '
        end
        object MC_ID_Set_Count: TEdit
          Left = 168
          Top = 105
          Width = 233
          Height = 21
          Enabled = False
          MaxLength = 4
          TabOrder = 0
          OnKeyPress = MC_ID_Set_CountKeyPress
        end
        object Panel3: TPanel
          Left = 2
          Top = 144
          Width = 516
          Height = 92
          Align = alBottom
          BevelOuter = bvNone
          Caption = #35831#24744#20808#23558#21345#22836#19982#30005#33041#20027#26426#36830#25509'! (Com3)    '
          Color = clWhite
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -15
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 1
          object BitBtn2: TBitBtn
            Left = 8
            Top = 64
            Width = 81
            Height = 25
            Caption = ' '#21024#38500#25968#25454#24211
            TabOrder = 0
            OnClick = BitBtn2Click
          end
          object BitBtn3: TBitBtn
            Left = 104
            Top = 64
            Width = 75
            Height = 25
            Caption = #22635#20805#35760#24405
            TabOrder = 1
            OnClick = BitBtn3Click
          end
        end
        object ComboBox_CardMC_ID: TComboBox
          Left = 168
          Top = 48
          Width = 233
          Height = 21
          ItemHeight = 13
          TabOrder = 2
          Text = #35831#28857#20987#36873#25321
          OnClick = ComboBox_CardMC_IDClick
        end
        object Edit_CardHead_Count: TEdit
          Left = 168
          Top = 75
          Width = 233
          Height = 21
          Enabled = False
          TabOrder = 3
        end
        object Combo_MCname: TComboBox
          Left = 168
          Top = 14
          Width = 233
          Height = 21
          ItemHeight = 13
          TabOrder = 4
          Text = #35831#28857#20987#36873#25321
          OnClick = Combo_MCnameClick
        end
        object BitBtn18: TBitBtn
          Left = 440
          Top = 87
          Width = 73
          Height = 41
          Caption = #21462#28040
          TabOrder = 5
          OnClick = BitBtn18Click
          Kind = bkClose
        end
        object BitBtn1: TBitBtn
          Left = 432
          Top = 48
          Width = 73
          Height = 33
          Caption = 'BitBtn1'
          TabOrder = 6
          Visible = False
          OnClick = BitBtn1Click
        end
        object BitBtn_INIT: TBitBtn
          Left = 440
          Top = 16
          Width = 73
          Height = 41
          Caption = #35774#23450
          TabOrder = 7
          OnClick = BitBtn_INITClick
          Glyph.Data = {
            360C0000424D360C000000000000360000002800000020000000200000000100
            180000000000000C0000C40E0000C40E00000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            000000000000000000000000000000000000000000000000000000000000006C
            3200411D00000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            00000000000000000000000000000000000000000000000000000000893B00CD
            5800D25800582500000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            000000000000000000000000000000000000000000000000009B3F00C456D0FA
            E7D8F9E800C74E006B2B00000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            00000000000000000000000000000000000000000000A53F0DBF5AB1F6D36EF0
            A893F9C7EFFEF800C04E00803000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            00000000000000000000000000000000000000AD4017BB5D90F4BF4DE88B70EF
            A889F4BDA1FDD3EFFFFA0ABB5100903400000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            000000000000000000000000000F0500AD3C21BA6367EFA329DF6B4DE68B65EC
            9F7BF1B18CF5BF93FAC8D4FFEC1AB85800983200000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            00000000000000000000210B00AB3824B96537E67E04D64D29DD6D40E37F54E8
            9167EDA074EFAC7BF1B174F2AEAEFCD527B55E009F3200010000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            000000000000002F0F00A73320BA641FDD6800CE3D03D54C1ADA5F2FDF7142E4
            8050E78C5CEA9660EB9B60EB9A52E98F82F6B631B56400A02D000D0400000000
            0000000000000000000000000000000000000000000000000000000000000000
            000000004515009F2C16BC610ED35300C73A00CE4400D24607D64F1BDB602CDE
            6E38E17842E38146E48445E48440E37F2EE07151EE9235B769009B28001E0900
            0000000000000000000000000000000000000000000000000000000000000000
            00551700942609BE5C04C84200C03500C63D00CA4000CE4400D24401D54A10D8
            571CDA6124DC6728DE6B28DE6B25DD681DDB6109D7511EE36831BA6900972300
            2B0B000000000000000000000000000000000000000000000000000000006117
            008B2000BC5300BD3500B93100BF3600C23600C53700C93B0AD04B13D45520D9
            5F27DB6529DC6928DB681FDA610DD75400D34500D14200CE3D0BD95427BC6700
            8E1C003F0F00000000000000000000000000000000000000000000370B00871B
            00B84A00B22900B22B00B52900BB3225C95544D36F57D97F55DB7F5FDF8926D7
            613FDC7458E18651E08152E08254E08352DE8139D86D17D05300C53300CC4019
            BF61008517004E10000000000000000000000000000000000000002E0800B940
            00A82000A91F00AF2943C86569D58564D58360D7825FD9836DDE8F1DD25600C7
            3800D73C41DB736AE1915EDE885EDF885FDD8761DD8866DD8A62DB8627CA5600
            C02D09C057007C13005A0E000000000000000000000000000000004B1200AE1D
            00A21935BB527DD49074D48B70D5896FD78B72D98E7EDE9914CC4A00CF380001
            0000020000D7393BD86C80E39E70DF926FDE916FDE916FDC9070DB8F7BDC964F
            CE7200B52000BD4A00750F00620C000000000000000000000000000000008F14
            17B33499DBA682D5947FD5927FD89483DA998ADDA008C53C00AD2B0000000000
            0000000000040100CA3131D56192E4AB80DF9C7FDE9A7FDE9A7FDD997FDC9888
            DC9E6BD28400AC1D00B53D006F0B006607000000000000000000000000000000
            00850F0DB32C9CDCA993DBA296DCA591DDA300BE2E00A2250000000000000000
            0000000000000000000000AD2822CF53A3E7B691E1A68FE0A48FDFA48FDEA38F
            DDA296DDA68AD99C00A82000AD2E006B09006802000000000000000000000000
            00000000650B00B222A8E0B397DBA500B61F007D190000000000000000000000
            0000000000000000000000000000A02213CA43B1E8BFA4E3B3A0E2B0A0E1AFA0
            E0AEA0DFADA4E0B0A7DFB206A32100A21F006706006800000900000000000000
            000000000000005A0905B72500B51D0069130000000000000000000000000000
            0000000000000000000000000000000000731505C332B9E9C4B6E7C2AFE4BBAF
            E4BAAFE3BAAFE2B9B3E2BBBCE5C210A024009711006E06002900000000000000
            00000000000000000000320500450A0000000000000000000000000000000000
            0000000000000000000000000000000000000000671100BB22BCE8C5CBEDD2C1
            E8C8C1E8C7C1E7C7C1E6C7C3E6C9D8EFDA2EA53B00990D003004000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            00000000000000000000000000000000000000000000003B0800B211B7E4BFE0
            F3E4D0EDD5D0ECD4D0ECD4D0ECD4E4F3E6B9DFBB009500003402000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            00000000000000000000000000000000000000000000000000002C0400A803A8
            DEB0F8FCF9E1F2E4E1F2E3FBFDFB99D19E008F00003901000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000170100
            950090D398FFFFFFFFFFFF7EC584008E00002500000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0400008C0085CD8B70BF75008500001D00000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000007F00009000000400000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000}
        end
      end
    end
  end
  object comReader: TComm
    CommName = 'COM3'
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
    Left = 193
    Top = 156
  end
  object DataSource_CardID_3FInit: TDataSource
    DataSet = ADOQuery_CardID_3FInit
    Left = 89
    Top = 156
  end
  object ADOQuery_CardID_3FInit: TADOQuery
    Parameters = <>
    Left = 137
    Top = 156
  end
end
