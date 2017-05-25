object frm_Fileinput_menbermatial: Tfrm_Fileinput_menbermatial
  Left = 222
  Top = 167
  Width = 908
  Height = 500
  BorderIcons = []
  Caption = '3F'#20339#26519#31185#25216'-'#36164#26009#24405#20837'-'#29992#25143#36164#26009
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
  object Panel4: TPanel
    Left = 0
    Top = 0
    Width = 900
    Height = 89
    Align = alTop
    BorderStyle = bsSingle
    Caption = 'Panel2'
    TabOrder = 0
    object Panel2: TPanel
      Left = 521
      Top = 1
      Width = 374
      Height = 83
      Align = alClient
      BevelOuter = bvLowered
      TabOrder = 0
      object BitBtn1: TBitBtn
        Left = 101
        Top = 24
        Width = 89
        Height = 33
        Caption = #20462#25913
        TabOrder = 0
        OnClick = BitBtn1Click
      end
      object Bit_Del: TBitBtn
        Left = 197
        Top = 24
        Width = 81
        Height = 33
        Caption = #21024#38500
        TabOrder = 1
        OnClick = Bit_DelClick
      end
      object Bit_Close: TBitBtn
        Left = 285
        Top = 24
        Width = 81
        Height = 33
        Caption = #20851#38381
        TabOrder = 2
        OnClick = Bit_CloseClick
      end
      object Bit_Query: TBitBtn
        Left = 5
        Top = 24
        Width = 89
        Height = 33
        Caption = #26597#35810
        TabOrder = 3
        OnClick = Bit_QueryClick
      end
    end
    object Panel3: TPanel
      Left = 1
      Top = 1
      Width = 520
      Height = 83
      Align = alLeft
      BevelOuter = bvLowered
      TabOrder = 1
      object Label1: TLabel
        Left = 313
        Top = 12
        Width = 15
        Height = 13
        Caption = #33267' '
      end
      object DateTimePicker_Start: TDateTimePicker
        Left = 128
        Top = 7
        Width = 86
        Height = 21
        Date = 39996.465388541670000000
        Format = 'yyyy-MM-dd'
        Time = 39996.465388541670000000
        Enabled = False
        TabOrder = 0
      end
      object DateTimePicker_End: TDateTimePicker
        Left = 328
        Top = 6
        Width = 81
        Height = 21
        Date = 41080.465738587960000000
        Format = 'yyyy-MM-dd'
        Time = 41080.465738587960000000
        Enabled = False
        TabOrder = 1
      end
      object ComboBox_Cardstate: TComboBox
        Left = 127
        Top = 31
        Width = 89
        Height = 21
        Enabled = False
        ItemHeight = 13
        TabOrder = 2
        Text = #20840#37096
        Items.Strings = (
          #20840#37096
          #27491#24120
          #25439#22351
          #36864#21345
          #20923#32467)
      end
      object ComboBox_other: TComboBox
        Left = 128
        Top = 55
        Width = 89
        Height = 21
        Enabled = False
        ItemHeight = 13
        TabOrder = 3
        Text = #20840#37096
        Items.Strings = (
          #20840#37096
          #29992#25143#32534#21495
          #29992#25143#22995#21517)
      end
      object Edit_other: TEdit
        Left = 217
        Top = 55
        Width = 145
        Height = 21
        Enabled = False
        TabOrder = 4
      end
      object TimePicker_Start: TDateTimePicker
        Left = 216
        Top = 7
        Width = 89
        Height = 19
        Date = 40457.670287175920000000
        Format = 'hh:mm:ss'
        Time = 40457.670287175920000000
        Enabled = False
        Kind = dtkTime
        TabOrder = 5
      end
      object TimePicker_End: TDateTimePicker
        Left = 416
        Top = 8
        Width = 89
        Height = 19
        Date = 40457.670287175920000000
        Time = 40457.670287175920000000
        Enabled = False
        Kind = dtkTime
        TabOrder = 6
      end
      object CheckBox_Date: TCheckBox
        Left = 8
        Top = 8
        Width = 121
        Height = 17
        Caption = #20197#21457#21345#26085#26399#26597#35810
        TabOrder = 7
        OnClick = CheckBox_DateClick
      end
      object CheckBox_Cardstate: TCheckBox
        Left = 8
        Top = 31
        Width = 105
        Height = 17
        Caption = #20197#21345#29366#24577#26597#35810
        TabOrder = 8
        OnClick = CheckBox_CardstateClick
      end
      object CheckBox_other: TCheckBox
        Left = 8
        Top = 55
        Width = 90
        Height = 17
        Caption = #20854#20182#26597#35810
        TabOrder = 9
        OnClick = CheckBox_otherClick
      end
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 89
    Width = 900
    Height = 377
    Align = alClient
    Caption = 'Panel1'
    TabOrder = 1
    object DBGrid2: TDBGrid
      Left = 1
      Top = 1
      Width = 898
      Height = 375
      Align = alClient
      DataSource = DataSource_Newmenber
      Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit]
      TabOrder = 0
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -11
      TitleFont.Name = 'MS Sans Serif'
      TitleFont.Style = []
      OnDblClick = DBGrid2DblClick
      Columns = <
        item
          Expanded = False
          FieldName = 'MI_ID'
          Visible = True
        end
        item
          Alignment = taCenter
          Expanded = False
          FieldName = 'MemCardNo'
          Title.Alignment = taCenter
          Title.Caption = #29992#25143#32534#21495
          Width = 80
          Visible = True
        end
        item
          Alignment = taCenter
          Expanded = False
          FieldName = 'MemberName'
          Title.Alignment = taCenter
          Title.Caption = #29992#25143#22995#21517
          Width = 80
          Visible = True
        end
        item
          Alignment = taCenter
          Expanded = False
          FieldName = 'MemType'
          Title.Alignment = taCenter
          Title.Caption = #36134#21495#31867#22411
          Width = 100
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'LevNum'
          Title.Caption = #20250#21592#31561#32423
          Width = 120
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'OpenCardDT'
          Title.Caption = #21150#21345#26085#26399
          Width = 60
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'EffectiveDT'
          Title.Caption = #21345#26377#25928#26399
          Width = 80
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'Deposit'
          Title.Caption = #25276#37329
          Width = 80
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'CardAmount'
          Title.Caption = #21345#29255#20313#39069
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'TickAmount'
          Title.Caption = #24425#31080#25968
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'IsAble'
          Title.Caption = #20351#29992#29366#24577
          Width = 50
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'DocNumber'
          Title.Caption = #35777#20214#21495#30721
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'Mobile'
          Title.Caption = #25163#26426
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'Birthday'
          Title.Caption = #29983#26085
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'InfoKey'
          Title.Caption = #39044#30041#23494#30721
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'cUserNo'
          Title.Caption = #21150#29702#32463#25163#20154
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'IDCardNo'
          Title.Caption = 'ID'#21345#21495
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'Picture'
          Title.Caption = #30456#29255
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'IsDownLoad'
          Title.Caption = #26159#21542#24050#20923#32467
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'Remark'
          Title.Caption = #22791#27880
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'Sex'
          Title.Caption = #24615#21035
          Visible = True
        end>
    end
  end
  object PopupMenu1: TPopupMenu
    Left = 481
    Top = 41
    object N1111: TMenuItem
      Caption = '1222'
    end
    object N11121: TMenuItem
      Caption = '1112'
    end
  end
  object DataSource_Newmenber: TDataSource
    Left = 33
    Top = 268
  end
  object ADOQuery_newmenber: TADOQuery
    Parameters = <>
    Left = 65
    Top = 268
  end
end
