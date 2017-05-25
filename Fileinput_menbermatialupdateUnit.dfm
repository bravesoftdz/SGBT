object frm_Fileinput_menbermatialupdate: Tfrm_Fileinput_menbermatialupdate
  Left = 320
  Top = 136
  Width = 699
  Height = 418
  BorderIcons = []
  Caption = #29992#25143#36164#26009#20462#25913
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 691
    Height = 384
    Align = alClient
    Caption = 'Panel1'
    TabOrder = 0
    object GroupBox2: TGroupBox
      Left = 488
      Top = 16
      Width = 201
      Height = 209
      Caption = #29992#25143#29031#29255
      TabOrder = 0
    end
    object GroupBox5: TGroupBox
      Left = 0
      Top = 16
      Width = 481
      Height = 329
      Caption = #29992#25143#22522#26412#36164#26009#24405#20837
      TabOrder = 1
      object Label3: TLabel
        Left = 17
        Top = 33
        Width = 60
        Height = 13
        Caption = #29992#25143#21345#21495#65306
      end
      object Label4: TLabel
        Left = 17
        Top = 65
        Width = 60
        Height = 13
        Caption = #29992#25143#22995#21517#65306
      end
      object Label5: TLabel
        Left = 17
        Top = 105
        Width = 60
        Height = 13
        Caption = #29992#25143#29983#26085#65306
      end
      object Label7: TLabel
        Left = 249
        Top = 241
        Width = 60
        Height = 13
        Caption = #21345#25276#37329#20026#65306
      end
      object Label8: TLabel
        Left = 17
        Top = 201
        Width = 60
        Height = 13
        Caption = #39044#30041#23494#30721#65306
      end
      object Label10: TLabel
        Left = 145
        Top = 105
        Width = 6
        Height = 13
        Caption = '_'
      end
      object Label11: TLabel
        Left = 49
        Top = 297
        Width = 108
        Height = 13
        Caption = #25163#21160#35774#32622#20250#21592#31561#32423#65306
      end
      object Label12: TLabel
        Left = 18
        Top = 140
        Width = 36
        Height = 13
        Caption = #24615#21035#65306
      end
      object Label13: TLabel
        Left = 248
        Top = 104
        Width = 60
        Height = 13
        Caption = #26377#25928#26085#26399#65306
      end
      object Label1: TLabel
        Left = 249
        Top = 33
        Width = 48
        Height = 13
        Caption = #25805#20316#21592#65306
      end
      object Label2: TLabel
        Left = 249
        Top = 65
        Width = 60
        Height = 13
        Caption = #21457#21345#26085#26399#65306
      end
      object Label6: TLabel
        Left = 249
        Top = 137
        Width = 60
        Height = 13
        Caption = #20351#29992#29366#24577#65306
      end
      object Label9: TLabel
        Left = 248
        Top = 176
        Width = 60
        Height = 13
        Caption = #21345#37329#39069#20026#65306
      end
      object Label14: TLabel
        Left = 249
        Top = 209
        Width = 60
        Height = 13
        Caption = #24425#31080#25968#20026#65306
      end
      object Label15: TLabel
        Left = 17
        Top = 169
        Width = 60
        Height = 13
        Caption = #32852#31995#30005#35805#65306
      end
      object Label16: TLabel
        Left = 16
        Top = 244
        Width = 60
        Height = 13
        Caption = #26159#21542#20923#32467#65306
      end
      object Edit01: TEdit
        Left = 80
        Top = 32
        Width = 145
        Height = 21
        TabOrder = 0
      end
      object Edit02: TEdit
        Left = 80
        Top = 64
        Width = 145
        Height = 21
        TabOrder = 1
      end
      object Comb_Month: TComboBox
        Left = 80
        Top = 104
        Width = 65
        Height = 21
        ItemHeight = 13
        TabOrder = 2
        Text = '01'
        Items.Strings = (
          '01'
          '02'
          '03'
          '04'
          '05'
          '06'
          '07'
          '08'
          '09'
          '10'
          '11'
          '12')
      end
      object Comb_Day: TComboBox
        Left = 160
        Top = 104
        Width = 65
        Height = 21
        ItemHeight = 13
        TabOrder = 3
        Text = '01'
        Items.Strings = (
          '01'
          '02'
          '03'
          '04'
          '05'
          '06'
          '07'
          '08'
          '09'
          '10'
          '11'
          '12'
          '13'
          '14'
          '15'
          '16'
          '17'
          '18'
          '19'
          '20'
          '21'
          '22'
          '23'
          '24'
          '25'
          '26'
          '27'
          '28'
          '29'
          '30'
          '31')
      end
      object Edit11: TEdit
        Left = 328
        Top = 240
        Width = 145
        Height = 21
        Enabled = False
        TabOrder = 4
      end
      object Edit04: TEdit
        Left = 80
        Top = 200
        Width = 145
        Height = 21
        TabOrder = 5
      end
      object Comb_menberlevel: TComboBox
        Left = 184
        Top = 296
        Width = 145
        Height = 21
        ItemHeight = 13
        TabOrder = 6
      end
      object Edit07: TEdit
        Left = 328
        Top = 104
        Width = 145
        Height = 21
        Enabled = False
        TabOrder = 7
      end
      object rgSex: TRadioGroup
        Left = 80
        Top = 129
        Width = 145
        Height = 32
        Columns = 2
        ItemIndex = 0
        Items.Strings = (
          #30007
          #22899)
        TabOrder = 8
      end
      object Edit05: TEdit
        Left = 328
        Top = 32
        Width = 145
        Height = 21
        Enabled = False
        TabOrder = 9
      end
      object Edit06: TEdit
        Left = 328
        Top = 64
        Width = 145
        Height = 21
        Enabled = False
        TabOrder = 10
      end
      object Edit08: TEdit
        Left = 328
        Top = 136
        Width = 145
        Height = 21
        Enabled = False
        TabOrder = 11
      end
      object Edit09: TEdit
        Left = 328
        Top = 176
        Width = 145
        Height = 21
        Enabled = False
        TabOrder = 12
      end
      object Edit10: TEdit
        Left = 328
        Top = 208
        Width = 145
        Height = 21
        TabOrder = 13
      end
      object Edit03: TEdit
        Left = 80
        Top = 168
        Width = 145
        Height = 21
        TabOrder = 14
      end
      object rgIable: TRadioGroup
        Left = 80
        Top = 233
        Width = 145
        Height = 32
        Columns = 2
        ItemIndex = 0
        Items.Strings = (
          #26159
          #21542)
        TabOrder = 15
      end
      object CheckBox1: TCheckBox
        Left = 16
        Top = 296
        Width = 17
        Height = 17
        Caption = 'CheckBox1'
        TabOrder = 16
      end
    end
    object Edit12: TEdit
      Left = 488
      Top = 231
      Width = 201
      Height = 21
      TabOrder = 2
    end
    object Panel2: TPanel
      Left = 1
      Top = 342
      Width = 689
      Height = 41
      Align = alBottom
      BevelOuter = bvLowered
      TabOrder = 3
      object Bit_Add: TBitBtn
        Left = 88
        Top = 8
        Width = 97
        Height = 25
        Caption = #20445#23384
        TabOrder = 0
        OnClick = Bit_AddClick
      end
      object Bit_Close: TBitBtn
        Left = 472
        Top = 8
        Width = 97
        Height = 25
        Caption = #20851#38381
        TabOrder = 1
        OnClick = Bit_CloseClick
      end
    end
  end
  object DataSource_updatemenber: TDataSource
    DataSet = ADOQuery_updatemenber
    Left = 537
    Top = 292
  end
  object ADOQuery_updatemenber: TADOQuery
    Parameters = <>
    Left = 569
    Top = 292
  end
end
