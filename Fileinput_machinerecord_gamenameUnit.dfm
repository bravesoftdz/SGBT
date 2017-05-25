object frm_Fileinput_machinerecord_gamename: Tfrm_Fileinput_machinerecord_gamename
  Left = 406
  Top = 260
  Width = 617
  Height = 201
  BorderIcons = []
  Caption = #28155#21152#26426#21488
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 609
    Height = 174
    Align = alClient
    BevelOuter = bvNone
    Caption = 'Panel1'
    TabOrder = 0
    object GroupBox1: TGroupBox
      Left = 0
      Top = 0
      Width = 609
      Height = 174
      Align = alClient
      Caption = #26426#21488#22522#26412#20449#24687
      TabOrder = 0
      object Label1: TLabel
        Left = 8
        Top = 24
        Width = 60
        Height = 13
        Caption = #28216#25103#32534#21495#65306
      end
      object Label2: TLabel
        Left = 192
        Top = 24
        Width = 60
        Height = 13
        Caption = #28216#25103#31867#22411#65306
        Visible = False
      end
      object Label3: TLabel
        Left = 256
        Top = 24
        Width = 60
        Height = 13
        Caption = #28216#25103#21517#31216#65306
      end
      object Edit_GameNo: TEdit
        Left = 75
        Top = 20
        Width = 126
        Height = 21
        Enabled = False
        TabOrder = 0
      end
      object ComboBox1: TComboBox
        Left = 256
        Top = 19
        Width = 105
        Height = 21
        ItemHeight = 13
        TabOrder = 1
        Text = #28216#25103#36890
        Visible = False
        Items.Strings = (
          #28216#25103#36890)
      end
      object Edit_GameName: TEdit
        Left = 344
        Top = 19
        Width = 249
        Height = 21
        TabOrder = 2
      end
      object Edit_Model: TEdit
        Left = 368
        Top = 19
        Width = 57
        Height = 21
        TabOrder = 3
        Text = 'Add'
        Visible = False
      end
      object Bit_Save: TBitBtn
        Left = 504
        Top = 69
        Width = 81
        Height = 33
        Caption = #30830#35748
        TabOrder = 4
        OnClick = Bit_SaveClick
      end
      object BitBtn12: TBitBtn
        Left = 504
        Top = 118
        Width = 81
        Height = 33
        Caption = #21462#28040
        TabOrder = 5
        OnClick = BitBtn12Click
      end
    end
  end
  object Panel2: TPanel
    Left = 184
    Top = 176
    Width = 349
    Height = 332
    Caption = 'Panel2'
    TabOrder = 1
    Visible = False
    object GroupBox2: TGroupBox
      Left = 1
      Top = 1
      Width = 347
      Height = 330
      Align = alClient
      Caption = #28216#25103#36890#21442#25968#35774#32622
      TabOrder = 0
      Visible = False
      object Label4: TLabel
        Left = 8
        Top = 32
        Width = 99
        Height = 13
        Caption = #26159#21542#20351#29992#24320#26426#21345#65306' '
      end
      object Label5: TLabel
        Left = 8
        Top = 69
        Width = 111
        Height = 13
        Caption = #26159#21542#24102#25237#36864#24065#20849#29992#65306' '
      end
      object Label6: TLabel
        Left = 8
        Top = 100
        Width = 87
        Height = 13
        Caption = #26159#21542#33258#21160#36864#24065#65306' '
      end
      object Label7: TLabel
        Left = 8
        Top = 132
        Width = 87
        Height = 13
        Caption = #26159#21542#24425#31080#26426#21488#65306' '
      end
      object Label8: TLabel
        Left = 8
        Top = 167
        Width = 75
        Height = 13
        Caption = #19978#20998#20449#21495#32447#65306' '
      end
      object Label9: TLabel
        Left = 8
        Top = 197
        Width = 87
        Height = 13
        Caption = #36864#20998#25509#32447#26041#24335#65306' '
      end
      object Label10: TLabel
        Left = 9
        Top = 228
        Width = 39
        Height = 13
        Caption = #36864#20998#65306' '
      end
      object Label11: TLabel
        Left = 8
        Top = 378
        Width = 99
        Height = 13
        Caption = #28216#25103#36890#31867#22411#35774#23450#65306' '
      end
      object Label12: TLabel
        Left = 8
        Top = 274
        Width = 129
        Height = 13
        Caption = #36865#20998#28040#36153#39069'(500-5000)'#65306'  '
      end
      object Label13: TLabel
        Left = 8
        Top = 300
        Width = 90
        Height = 13
        Caption = #36865#20998#39069'(0-1000)'#65306' '
      end
      object Label14: TLabel
        Left = 9
        Top = 323
        Width = 114
        Height = 13
        Caption = #24080#25143#28040#36153#20313#39069'(0-20)'#65306' '
      end
      object Label15: TLabel
        Left = 8
        Top = 347
        Width = 120
        Height = 13
        Caption = #25237#24065#26377#25928#26102#38388'(0-100)'#65306' '
      end
      object Label16: TLabel
        Left = 8
        Top = 418
        Width = 39
        Height = 13
        Caption = #22791#27880#65306' '
      end
      object Label17: TLabel
        Left = 316
        Top = 33
        Width = 108
        Height = 13
        Caption = #19978#20998'1'#25187#20540'(0-1000)'#65306' '
      end
      object Label18: TLabel
        Left = 316
        Top = 68
        Width = 120
        Height = 13
        Caption = #19978#20998'1'#25237#24065#25968'(0-1000)'#65306' '
      end
      object Label19: TLabel
        Left = 316
        Top = 99
        Width = 108
        Height = 13
        Caption = #19978#20998'2'#25187#20540'(0-1000)'#65306' '
      end
      object Label20: TLabel
        Left = 316
        Top = 131
        Width = 120
        Height = 13
        Caption = #19978#20998'1'#25237#24065#25968'(0-1000)'#65306' '
      end
      object Label21: TLabel
        Left = 316
        Top = 166
        Width = 126
        Height = 13
        Caption = #19978#20998#20449#21495#38271#24230'(10-500)'#65306' '
      end
      object Label22: TLabel
        Left = 316
        Top = 196
        Width = 126
        Height = 13
        Caption = #19978#20998#33033#20914#38388#38548'(10-500)'#65306' '
      end
      object Label23: TLabel
        Left = 316
        Top = 227
        Width = 120
        Height = 13
        Caption = #39318#20004#20010#19978#20998#38388#38548'(0-5)'#65306' '
      end
      object Label24: TLabel
        Left = 316
        Top = 273
        Width = 102
        Height = 13
        Caption = #36864#20998#33033#20914#25968'(1-10)'#65306' '
      end
      object Label25: TLabel
        Left = 316
        Top = 299
        Width = 96
        Height = 13
        Caption = #36864#20998#20998#25968'(1-100)'#65306' '
      end
      object Label26: TLabel
        Left = 315
        Top = 322
        Width = 117
        Height = 13
        Caption = 'HOPPER'#38271#24230'(1-100)'#65306' '
      end
      object Label27: TLabel
        Left = 316
        Top = 346
        Width = 117
        Height = 13
        Caption = 'HOPPER'#38388#38548'(1-100)'#65306' '
      end
      object Label28: TLabel
        Left = 315
        Top = 372
        Width = 138
        Height = 13
        Caption = #36864#20998#38190#36755#20986#38271#24230'(10-500)'#65306' '
      end
      object Label29: TLabel
        Left = 315
        Top = 396
        Width = 132
        Height = 13
        Caption = #21333#27425#36864#20998#38480#39069'(0-10000)'#65306' '
      end
      object Label30: TLabel
        Left = 315
        Top = 420
        Width = 144
        Height = 13
        Caption = #26426#21488#28040#36153#38480#39069'(100-60000)'#65306' '
      end
      object RdA: TRadioGroup
        Left = 160
        Top = 24
        Width = 129
        Height = 31
        BiDiMode = bdRightToLeft
        Columns = 2
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ItemIndex = 1
        Items.Strings = (
          #26159
          #21542)
        ParentBiDiMode = False
        ParentFont = False
        TabOrder = 0
      end
      object RdB: TRadioGroup
        Left = 160
        Top = 56
        Width = 129
        Height = 31
        BiDiMode = bdRightToLeft
        Columns = 2
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ItemIndex = 1
        Items.Strings = (
          #26159
          #21542)
        ParentBiDiMode = False
        ParentFont = False
        TabOrder = 1
      end
      object RdC: TRadioGroup
        Left = 160
        Top = 88
        Width = 129
        Height = 31
        BiDiMode = bdRightToLeft
        Columns = 2
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ItemIndex = 1
        Items.Strings = (
          #26159
          #21542)
        ParentBiDiMode = False
        ParentFont = False
        TabOrder = 2
      end
      object RdE: TRadioGroup
        Left = 160
        Top = 156
        Width = 129
        Height = 31
        BiDiMode = bdRightToLeft
        Columns = 2
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ItemIndex = 0
        Items.Strings = (
          '1'#26465
          '2'#26465)
        ParentBiDiMode = False
        ParentFont = False
        TabOrder = 3
      end
      object RdF: TRadioGroup
        Left = 112
        Top = 187
        Width = 177
        Height = 31
        Hint = #35831#21452#20987#35760#24405#36827#20837#20462#25913#30011#38754
        BiDiMode = bdRightToLeft
        Columns = 2
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ItemIndex = 0
        Items.Strings = (
          #26631#20934#36864#20998
          #30721#34920#36864#20998)
        ParentBiDiMode = False
        ParentFont = False
        TabOrder = 4
      end
      object RdG: TRadioGroup
        Left = 56
        Top = 217
        Width = 233
        Height = 31
        BiDiMode = bdRightToLeft
        Columns = 3
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ItemIndex = 0
        Items.Strings = (
          #26631#20934#36864#20998
          #37096#20998#36864#20998
          #38271#25353#36864#20998)
        ParentBiDiMode = False
        ParentFont = False
        TabOrder = 5
      end
      object Redit2: TEdit
        Left = 160
        Top = 295
        Width = 129
        Height = 21
        TabOrder = 6
        Text = '0'
      end
      object Redit3: TEdit
        Left = 160
        Top = 319
        Width = 129
        Height = 21
        TabOrder = 7
        Text = '2'
      end
      object Redit4: TEdit
        Left = 160
        Top = 343
        Width = 129
        Height = 21
        TabOrder = 8
        Text = '0'
      end
      object MacType: TRadioGroup
        Left = 161
        Top = 367
        Width = 129
        Height = 31
        BiDiMode = bdRightToLeft
        Columns = 4
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ItemIndex = 0
        Items.Strings = (
          'A'
          'B'
          'C'
          'D')
        ParentBiDiMode = False
        ParentFont = False
        TabOrder = 9
      end
      object Remark: TMemo
        Left = 56
        Top = 401
        Width = 233
        Height = 72
        TabOrder = 10
      end
      object RdD: TRadioGroup
        Left = 160
        Top = 121
        Width = 129
        Height = 31
        BiDiMode = bdRightToLeft
        Columns = 2
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ItemIndex = 1
        Items.Strings = (
          #26159
          #21542)
        ParentBiDiMode = False
        ParentFont = False
        TabOrder = 11
      end
      object Redit1: TComboBox
        Left = 160
        Top = 271
        Width = 129
        Height = 21
        ItemHeight = 13
        TabOrder = 12
        Text = '1000'
        Items.Strings = (
          '500'
          '1000'
          '1500'
          '2000'
          '2500'
          '3000'
          '3500'
          '4000'
          '4500'
          '5000')
      end
      object Edt1: TEdit
        Left = 466
        Top = 32
        Width = 129
        Height = 21
        TabOrder = 13
        Text = '100'
      end
      object Edt2: TEdit
        Left = 466
        Top = 64
        Width = 129
        Height = 21
        TabOrder = 14
        Text = '10'
      end
      object Edt3: TEdit
        Left = 466
        Top = 96
        Width = 129
        Height = 21
        TabOrder = 15
        Text = '10'
      end
      object Edt4: TEdit
        Left = 466
        Top = 128
        Width = 129
        Height = 21
        TabOrder = 16
        Text = '1'
      end
      object Edt5: TEdit
        Left = 466
        Top = 160
        Width = 129
        Height = 21
        TabOrder = 17
        Text = '50'
      end
      object Edt6: TEdit
        Left = 466
        Top = 192
        Width = 129
        Height = 21
        TabOrder = 18
        Text = '50'
      end
      object Edt7: TEdit
        Left = 466
        Top = 219
        Width = 129
        Height = 21
        TabOrder = 19
        Text = '0'
      end
      object Edt8: TEdit
        Left = 465
        Top = 271
        Width = 129
        Height = 21
        TabOrder = 20
        Text = '1'
      end
      object Edt9: TEdit
        Left = 465
        Top = 295
        Width = 129
        Height = 21
        TabOrder = 21
        Text = '10'
      end
      object Edt10: TEdit
        Left = 465
        Top = 319
        Width = 129
        Height = 21
        TabOrder = 22
        Text = '28'
      end
      object Edt11: TEdit
        Left = 465
        Top = 344
        Width = 129
        Height = 21
        TabOrder = 23
        Text = '30'
      end
      object Edt14: TEdit
        Left = 464
        Top = 416
        Width = 129
        Height = 21
        TabOrder = 24
        Text = '5000'
      end
      object Edt13: TEdit
        Left = 464
        Top = 391
        Width = 129
        Height = 21
        TabOrder = 25
        Text = '0'
      end
      object Edt12: TEdit
        Left = 464
        Top = 367
        Width = 129
        Height = 21
        TabOrder = 26
        Text = '50'
      end
    end
  end
end
