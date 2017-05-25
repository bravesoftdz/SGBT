object frm_IC_Report_SaleDetial: Tfrm_IC_Report_SaleDetial
  Left = 231
  Top = 166
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = #33829#19994#25253#34920'-'#20132#26131#26126#32454#25253#34920
  ClientHeight = 553
  ClientWidth = 772
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Panel8: TPanel
    Left = 0
    Top = 0
    Width = 772
    Height = 553
    Align = alClient
    Caption = 'Panel1'
    TabOrder = 0
    object Panel2: TPanel
      Left = 1
      Top = 1
      Width = 770
      Height = 551
      Align = alClient
      Caption = 'Panel2'
      TabOrder = 0
      object pgcMachinerecord: TPageControl
        Left = 1
        Top = 1
        Width = 768
        Height = 549
        ActivePage = TabSheet3
        Align = alClient
        MultiLine = True
        Style = tsFlatButtons
        TabOrder = 0
        TabWidth = 82
        OnChange = pgcMachinerecordChange
        object TabSheet2: TTabSheet
          Caption = #20805#20540#26126#32454
          ImageIndex = 1
          object Panel3: TPanel
            Left = 0
            Top = 97
            Width = 760
            Height = 421
            Align = alClient
            Caption = 'Panel7'
            TabOrder = 0
            object DBGridEh1: TDBGridEh
              Left = 1
              Top = 1
              Width = 758
              Height = 419
              Align = alClient
              DataGrouping.Active = True
              DataGrouping.GroupLevels = <>
              DataSource = DataSource_Recrod
              Flat = False
              FooterColor = clWindow
              FooterFont.Charset = DEFAULT_CHARSET
              FooterFont.Color = clWindowText
              FooterFont.Height = -11
              FooterFont.Name = 'MS Sans Serif'
              FooterFont.Style = []
              RowDetailPanel.Color = clBtnFace
              SumList.Active = True
              TabOrder = 0
              TitleFont.Charset = DEFAULT_CHARSET
              TitleFont.Color = clWindowText
              TitleFont.Height = -11
              TitleFont.Name = 'MS Sans Serif'
              TitleFont.Style = []
              TitleLines = 1
              UseMultiTitle = True
              Columns = <
                item
                  Checkboxes = False
                  EditButtons = <>
                  FieldName = 'cUserNo'
                  Footers = <>
                  MaxWidth = 120
                  Title.Caption = #20805#20540#25805#20316#21592
                  Width = 80
                end
                item
                  EditButtons = <>
                  FieldName = 'ID_INCttime'
                  Footers = <>
                  Title.Caption = #20805#20540#26102#38388
                  Width = 120
                end
                item
                  EditButtons = <>
                  FieldName = 'ID_value'
                  Footers = <>
                  Title.Caption = #20805#20540#39069
                  Width = 120
                end>
              object RowDetailData: TRowDetailPanelControlEh
                object DBGridEh2: TDBGridEh
                  Left = 0
                  Top = 0
                  Width = 0
                  Height = 0
                  Align = alClient
                  DataGrouping.Active = True
                  DataGrouping.GroupLevels = <>
                  DataSource = DataSource_Recrod
                  Flat = False
                  FooterColor = clWindow
                  FooterFont.Charset = DEFAULT_CHARSET
                  FooterFont.Color = clWindowText
                  FooterFont.Height = -11
                  FooterFont.Name = 'MS Sans Serif'
                  FooterFont.Style = []
                  RowDetailPanel.Color = clBtnFace
                  SumList.Active = True
                  TabOrder = 0
                  TitleFont.Charset = DEFAULT_CHARSET
                  TitleFont.Color = clWindowText
                  TitleFont.Height = -11
                  TitleFont.Name = 'MS Sans Serif'
                  TitleFont.Style = []
                  TitleLines = 1
                  UseMultiTitle = True
                  Columns = <
                    item
                      Checkboxes = False
                      EditButtons = <>
                      FieldName = 'cUserNo'
                      Footers = <>
                      MaxWidth = 120
                      Title.Caption = #20805#20540#25805#20316#21592
                      Width = 80
                    end
                    item
                      EditButtons = <>
                      FieldName = 'ID_INCttime'
                      Footers = <>
                      Title.Caption = #20805#20540#26102#38388
                      Width = 120
                    end
                    item
                      EditButtons = <>
                      FieldName = 'ID_value'
                      Footers = <>
                      Title.Caption = #20805#20540#39069
                      Width = 120
                    end>
                  object RowDetailData: TRowDetailPanelControlEh
                  end
                end
              end
            end
            object Edit1: TEdit
              Left = 64
              Top = 40
              Width = 553
              Height = 21
              TabOrder = 1
              Text = 'Edit1'
              Visible = False
            end
            object DBGridEh3: TDBGridEh
              Left = 1
              Top = 1
              Width = 758
              Height = 419
              Align = alClient
              DataGrouping.Active = True
              DataGrouping.GroupLevels = <>
              DataSource = DataSource_Recrod
              Flat = False
              FooterColor = clWindow
              FooterFont.Charset = DEFAULT_CHARSET
              FooterFont.Color = clWindowText
              FooterFont.Height = -11
              FooterFont.Name = 'MS Sans Serif'
              FooterFont.Style = []
              RowDetailPanel.Color = clBtnFace
              SumList.Active = True
              TabOrder = 2
              TitleFont.Charset = DEFAULT_CHARSET
              TitleFont.Color = clWindowText
              TitleFont.Height = -11
              TitleFont.Name = 'MS Sans Serif'
              TitleFont.Style = []
              TitleLines = 1
              UseMultiTitle = True
              Columns = <
                item
                  EditButtons = <>
                  FieldName = 'md_id'
                  Footers = <>
                  Title.Caption = #24207#21495
                  Width = 50
                end
                item
                  EditButtons = <>
                  FieldName = 'id_usercard'
                  Footers = <>
                  Title.Caption = #30005#23376#24065'ID'
                  Width = 60
                end
                item
                  Checkboxes = False
                  EditButtons = <>
                  FieldName = 'memcardno'
                  Footers = <>
                  MaxWidth = 120
                  Title.Caption = #20250#21592
                  Width = 80
                end
                item
                  EditButtons = <>
                  FieldName = 'cuserno'
                  Footers = <>
                  Title.Caption = #25805#20316#21592
                  Width = 50
                end
                item
                  EditButtons = <>
                  FieldName = 'GetTime'
                  Footers = <>
                  Title.Caption = #20805#20540#26102#38388
                end
                item
                  EditButtons = <>
                  FieldName = 'costmoney'
                  Footers = <>
                  Title.Caption = #20805#20540
                  Width = 40
                end
                item
                  EditButtons = <>
                  FieldName = 'expiretime'
                  Footers = <>
                  Title.Caption = #22833#25928#26102#38388
                end>
              object RowDetailData: TRowDetailPanelControlEh
                object DBGridEh4: TDBGridEh
                  Left = 0
                  Top = 0
                  Width = 0
                  Height = 0
                  Align = alClient
                  DataGrouping.Active = True
                  DataGrouping.GroupLevels = <>
                  DataSource = DataSource_Recrod
                  Flat = False
                  FooterColor = clWindow
                  FooterFont.Charset = DEFAULT_CHARSET
                  FooterFont.Color = clWindowText
                  FooterFont.Height = -11
                  FooterFont.Name = 'MS Sans Serif'
                  FooterFont.Style = []
                  RowDetailPanel.Color = clBtnFace
                  SumList.Active = True
                  TabOrder = 0
                  TitleFont.Charset = DEFAULT_CHARSET
                  TitleFont.Color = clWindowText
                  TitleFont.Height = -11
                  TitleFont.Name = 'MS Sans Serif'
                  TitleFont.Style = []
                  TitleLines = 1
                  UseMultiTitle = True
                  Columns = <
                    item
                      Checkboxes = False
                      EditButtons = <>
                      FieldName = 'cUserNo'
                      Footers = <>
                      MaxWidth = 120
                      Title.Caption = #20805#20540#25805#20316#21592
                      Width = 80
                    end
                    item
                      EditButtons = <>
                      FieldName = 'ID_INCttime'
                      Footers = <>
                      Title.Caption = #20805#20540#26102#38388
                      Width = 120
                    end
                    item
                      EditButtons = <>
                      FieldName = 'ID_value'
                      Footers = <>
                      Title.Caption = #20805#20540#39069
                      Width = 120
                    end>
                  object RowDetailData: TRowDetailPanelControlEh
                  end
                end
              end
            end
          end
          object Panel4: TPanel
            Left = 0
            Top = 0
            Width = 760
            Height = 97
            Align = alTop
            Caption = 'Panel1'
            TabOrder = 1
            object Panel5: TPanel
              Left = 1
              Top = 1
              Width = 552
              Height = 95
              Align = alLeft
              BevelOuter = bvLowered
              TabOrder = 0
              object Label1: TLabel
                Left = 8
                Top = 8
                Width = 3
                Height = 13
              end
              object Label3: TLabel
                Left = 9
                Top = 20
                Width = 75
                Height = 13
                Caption = #33829#19994#26102#38388#65306'     '
              end
              object Label10: TLabel
                Left = 280
                Top = 19
                Width = 15
                Height = 13
                Caption = #33267' '
              end
              object Label12: TLabel
                Left = 9
                Top = 64
                Width = 75
                Height = 13
                Caption = #26597#35810#26465#20214#65306'     '
              end
              object DateTimePicker_Start: TDateTimePicker
                Left = 87
                Top = 14
                Width = 86
                Height = 21
                Date = 39996.465388541670000000
                Format = 'yyyy-MM-dd'
                Time = 39996.465388541670000000
                TabOrder = 0
              end
              object DateTimePicker_End: TDateTimePicker
                Left = 295
                Top = 13
                Width = 81
                Height = 21
                Date = 41080.465738587960000000
                Format = 'yyyy-MM-dd'
                Time = 41080.465738587960000000
                TabOrder = 1
              end
              object TimePicker_End: TDateTimePicker
                Left = 380
                Top = 14
                Width = 89
                Height = 19
                Date = 40457.670287175920000000
                Time = 40457.670287175920000000
                Kind = dtkTime
                TabOrder = 2
              end
              object TimePicker_Start: TDateTimePicker
                Left = 180
                Top = 14
                Width = 89
                Height = 19
                Date = 40457.670287175920000000
                Time = 40457.670287175920000000
                Kind = dtkTime
                TabOrder = 3
              end
              object cob_recharge: TComboBox
                Left = 88
                Top = 61
                Width = 86
                Height = 21
                ItemHeight = 13
                TabOrder = 4
                Text = #20840#37096
                OnClick = cob_rechargeClick
                Items.Strings = (
                  #20840#37096
                  #33829#19994#21592#32534#21495
                  #20250#21592#32534#21495)
              end
              object Panel_Meber: TPanel
                Left = 184
                Top = 48
                Width = 233
                Height = 41
                BevelOuter = bvNone
                TabOrder = 5
                Visible = False
                object Label14: TLabel
                  Left = 2
                  Top = 16
                  Width = 75
                  Height = 13
                  Caption = #20250#21592#32534#21495#65306'     '
                end
                object ComboBox4: TComboBox
                  Left = 88
                  Top = 12
                  Width = 97
                  Height = 21
                  ItemHeight = 13
                  TabOrder = 0
                  Text = #20840#37096
                  Items.Strings = (
                    '')
                end
              end
              object Panel_Operator: TPanel
                Left = 184
                Top = 52
                Width = 201
                Height = 41
                BevelOuter = bvNone
                TabOrder = 6
                Visible = False
                object Label13: TLabel
                  Left = 10
                  Top = 12
                  Width = 63
                  Height = 13
                  Caption = #33829#19994#21592#65306'     '
                end
                object cob_recharge_operator: TComboBox
                  Left = 72
                  Top = 10
                  Width = 97
                  Height = 21
                  ItemHeight = 13
                  TabOrder = 0
                  Text = #20840#37096
                  Items.Strings = (
                    '')
                end
              end
            end
            object Panel12: TPanel
              Left = 553
              Top = 1
              Width = 206
              Height = 95
              Align = alClient
              BevelOuter = bvLowered
              TabOrder = 1
              object BitBtn1: TBitBtn
                Left = 5
                Top = 16
                Width = 76
                Height = 41
                Caption = #26597#35810
                TabOrder = 0
                OnClick = Bit_charge_queryClick
                Glyph.Data = {
                  360C0000424D360C000000000000360000002800000020000000200000000100
                  180000000000000C0000C40E0000C40E00000000000000000000FFFFFFFFFFFF
                  E0F8FF61DBFF53D8FF96E8FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                  FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                  FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFC6F2FF
                  00C5FF1ACDFF1CCDFF08C9FF91E3FEFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                  FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                  FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF55DBFF
                  22D0FF2BD2FF2BD2FF2ED6FF00A6F8FFFEFEFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                  FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                  FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF88E1FE
                  25D4FF36D7FF37D9FF32D3FF099CF464BFF8FFFFFFFFFFFFFFFFFFFFFFFFFFFF
                  FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                  FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                  1DBDFC1DC2FC1FBDFB0FA5F714A5F70093F4F0F8FEFFFFFFFFFFFFFFFFFFFFFF
                  FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                  FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                  FFFFFF00A8F90AACF811AAF714A7F60FA0F53BAEF6FFFFFFFFFFFFFFFFFFFFFF
                  FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                  FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                  FFFFFFC8EEFE00A5F910ACF913A8F715A5F60095F4DFF1FDFFFFFFFFFFFFFFFF
                  FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                  FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                  FFFFFFFFFFFF86D8FD00A6F811AAF714A6F713A1F5139CF4FFFFFFFFFFFFFFFF
                  FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                  FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                  FFFFFFFFFFFFFFFFFF2EBAFA07A9F813A8F716A4F50397F3B4DFFBFFFFFFFFFF
                  FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                  FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                  FFFFFFFFFFFFFFFFFFFFFFFF00A4F810A9F815A6F714A1F6189DF4FFFFFFFFFF
                  FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                  FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                  FFFFFFFFFFFFFFFFFFFFFFFFDEF4FE009EF613A7F616A3F50D99F463C8FA59DC
                  FF4BD6FF00C4FF00C5FF00C5FF00C5FF00C5FF23CDFF44D5FF7CE1FFADEDFFFF
                  FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                  FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF8FD9FC04A2F715A5F618A0F5129CF415D1
                  FF16CBFF1DCCFF1DCCFF1DCCFF1DCCFF1DCCFF1ACCFF17CBFF12CAFF0CC9FF00
                  C5FF59DAFFB0EDFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                  FFFFFFFFFFFFFFFFFFFFFFFF67DDFF0ACDFF17B9FB13A3F617A3F6199BF41EB8
                  FA20D0FF20CEFF20CEFF20CEFF20CEFF20CEFF21CDFF21CDFF21CDFF21CDFF21
                  CDFF18CCFF0BC9FF1ACCFFDFF8FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                  FFFFFFFFFFFFF4FCFF06C8FF15CBFF21CEFF24D4FF15ADF815A2F5189FF41C9E
                  F423D3FF22CEFF22CEFF22CEFF23CFFF23CFFF23CFFF23CFFF23CFFF22CFFF22
                  CFFF23CFFF23CFFF20CEFF02C7FF7CE2FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                  FFFFFFF2FCFF0BC9FF20CEFF24CFFF24CFFF24D0FF24D0FF14A5F7169FF520C2
                  FC22D0FF20CDFF20CEFF1FCDFF1FCDFF20CEFF21CEFF23CFFF24CFFF25CFFF25
                  CFFF25D0FF25D0FF25D0FF25D0FF0FCBFF6ADEFFFFFFFFFFFFFFFFFFFFFFFFFF
                  FFFFFF1DCEFF21CFFF27D0FF27D0FF27D0FF26D0FF23CFFF21D1FF1DD1FF21D0
                  FF35D5FF42DBFF48DDFF4FDFFF4CDFFF46DCFF3CD8FF2AD1FF1BCCFF1FCDFF22
                  CEFF26D0FF28D0FF28D0FF28D0FF27D0FF09CAFFDBF7FFFFFFFFFFFFFFFFFFFF
                  C2F2FF13CCFF29D0FF29D0FF28D0FF22CEFF1DCCFF41D9FF64E8FF7FF3FF8DFA
                  FF88F8FF90F8FFA0F8FDA0F8FE9FF6FA95F6FB8AF7FF89F9FF89F8FF6FEDFF52
                  E0FF27D0FF20CEFF27D0FF2AD1FF2AD1FF22D0FF5FDCFFFFFFFFFFFFFFFFFFFF
                  90E8FF1DCFFF2AD2FF26D0FF21CEFF5AE3FF8AF7FF87F8FFA0F6FACBF3EFECF2
                  E7FFF1E1FFF1E0FFF0DFFFF3E5FFF8EFFFFAF3FFF6EAF7F3E7D8F0E6B4F3F189
                  F8FF8FFAFF71ECFF33D5FF24CFFF2CD2FF2DD2FF0ACBFFFFFFFFFFFFFFFFFFFF
                  96E8FF20CFFF25CFFF40D9FF8FF7FF84F7FFB0F4F6F7F2E5FFF2E2FFF3E4FFF3
                  E5FCF3E6FCF3E7FCF3E6FCF3E6FBF2E3FCF3E6FEFAF6FFFBF6FFFAF4FFF4E5FF
                  ECD7CFF0E98AF6FF92FAFF66E7FF24CFFF2DD2FF15CDFFFFFFFFFFFFFFFFFFFF
                  97E9FF19CDFF56E2FF96FAFF86F5FFECF3E9FFF3E4FEF3E7FBF4E9FBF4E9FCF4
                  EAFCF5EAFCF5EAFCF4EAFBF4E9FBF4E9FBF3E7FBF2E5FEFAF5FEFAF5FEFAF6FE
                  F9F2FFEEDBFFEDD8A8F3F588F8FF82F2FF28D0FF16CEFFFFFFFFFFFFFFFFFFFF
                  94E8FF3CDAFF96FAFF86F5FFFFF3E5FFF4E7FCF4EAFCF5EBFCF5ECFDF6ECFDF6
                  ECFDF6EDFDF6EDFDF6ECFDF6ECFCF5ECFCF5EBFCF4E9FCF4E9FEFBF8FEFAF6FE
                  FAF6FDF9F3FBEEDCFFEDD6B0F2F289F7FF7DF0FF0FCBFFFFFFFFFFFFFFFFFFFF
                  90E6FF83F4FF83F7FFE5F4ECFFF5E8FCF5EBFDF6ECFDF6EDFDF7EEFDF7EEFDF7
                  EFFCF7EFFCF7EFFDF7EFFDF7EEFDF7EEFDF6EDFDF6ECFCF4E9FDF9F4FEFBF7FE
                  FBF5FEFBF7FCF4E9FBEFDDFFEFD78AF3FE93F9FF36DAFFFFFFFFFFFFFFFFFFFF
                  AEF1FF87F6FF85EDFD9FC1EAFFFFEBFDF6EEFDF7EEFCF7F0FCF8F1FCF8F1FCF8
                  F2FDF8F1FDF8F1FCF8F2FCF8F1FCF8F1FCF7F0FDF7EEFCF6EDFEF8F1FEFBF8FE
                  FAF7FEFBF6FEF9F3FFF3DFE5E2DF78C8F18EFAFF5EE9FFFFFFFFFFFFFFFFFFFF
                  C0F8FF84F6FF87E4FA73B3EEAED3EFFFFFEFFFF9F1FDF9F2FDF9F3FEF9F3FEF9
                  F3FEFAF4FEFAF4FEF9F3FEF9F3FDF9F2FDF9F2FCF8F1FCF7EFFEF8F3FEFCF9FE
                  FBF8FEFBF7FFFFF7EDEAE372B2EA82C6ED8CFAFF75F1FFFFFFFFFFFFFFFFFFFF
                  C1F9FF85F6FF76E5FD6DB1EF77BBF28DC7F2F7F6F3FFFFF4FFFCF5FEFBF6FEFA
                  F6FEFBF6FEFBF6FEFBF6FEFAF6FEFAF4FEFAF4FDF9F3FDF8F1FEFBF6FFFCF9FF
                  FEF8FFFFF8DEEDF669B3EC84BCEA59BFF48DFAFF8DF5FFFFFFFFFFFFFFFFFFFF
                  F4FEFF78F3FF96FFFF239DF377BCF280C2F26CB9F39FD1F4DFEDF6FFFFF7FFFF
                  F8FFFFF8FFFEF8FFFEF8FFFDF7FFFDF7FFFDF6FFFDF5FFFDF3FFFFFAFDFCFADA
                  ECF8B4DAF6AFD8F582C1EC2C96EF76E6FE87F6FFAFF8FFFFFFFFFFFFFFFFFFFF
                  FFFFFFBBF9FF84F6FF85F1FE068BF151B0F388C9F47BC3F570BEF56FBDF696CF
                  F6B6DDF7C8E5F8D4EAF8E7F2F8DEEEF7CDE6F7C0E0F5A6D5F4BBDFF9ABD8F7B6
                  DCF8C6E3F79BD0F41190F14CC4F893FDFF7DF3FFFFFFFFFFFFFFFFFFFFFFFFFF
                  FFFFFFFFFFFF90F5FF86F8FF84F0FE1299F31396F351B3F57DC6F684C9F77DC6
                  F778C3F675C2F672C1F670C0F671C0F673C1F670C0F5ACDAF8C2E3F9C4E4F98C
                  CCF638A7F40088F256CCFA95FFFF7EF4FFF9FEFFFFFFFFFFFFFFFFFFFFFFFFFF
                  FFFFFFFFFFFFFFFFFFBBF9FF7CF5FF93FEFF51C9FA0A96F40393F31FA0F43FAE
                  F656B8F764BEF76EC2F76FC2F770C2F767BFF664BEF66BC1F739ABF50494F300
                  8EF32DB0F783F0FE8AFBFF86F4FFF8FEFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                  FFFFFFFFFFFFFFFFFFFFFFFFECFDFF9DF7FF83F9FF90FDFF65DBFB38BAF8119F
                  F50194F40396F40397F40397F40397F40396F40195F40397F426AEF651CCFA84
                  F3FE8CFDFF82F6FFC4FAFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                  FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5FEFFBBF9FF90F8FF84FAFF8EFE
                  FF89F8FF73E9FD68E1FD64DEFC64DEFC6FE6FD7FF1FE8EFDFF89FBFF89F9FFAA
                  F9FFD6FBFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                  FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEDFD
                  FFC9FBFFCFFCFFD0FDFFD0FDFFD0FDFFCFFDFFCBFBFFE5FDFFF4FEFFFFFFFFFF
                  FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF}
              end
              object BitBtn2: TBitBtn
                Left = 112
                Top = 8
                Width = 70
                Height = 41
                Caption = #21462#28040
                TabOrder = 1
                OnClick = bit_refund_cancel_click
                Kind = bkClose
              end
              object BitBtn5: TBitBtn
                Left = 93
                Top = 48
                Width = 76
                Height = 33
                Caption = #25171#21360
                TabOrder = 2
                Visible = False
              end
            end
          end
        end
        object TabSheet1: TTabSheet
          Caption = #20817#25442#26126#32454
          ImageIndex = 1
          object Panel1: TPanel
            Left = 0
            Top = 0
            Width = 760
            Height = 97
            Align = alTop
            Caption = 'Panel1'
            TabOrder = 0
            object Panel9: TPanel
              Left = 1
              Top = 1
              Width = 552
              Height = 95
              Align = alLeft
              BevelOuter = bvLowered
              TabOrder = 0
              object Label4: TLabel
                Left = 8
                Top = 8
                Width = 3
                Height = 13
              end
              object Label6: TLabel
                Left = 9
                Top = 66
                Width = 75
                Height = 13
                Caption = #26597#35810#26465#20214#65306'     '
              end
              object Label5: TLabel
                Left = 9
                Top = 20
                Width = 75
                Height = 13
                Caption = #33829#19994#26102#38388#65306'     '
              end
              object Label9: TLabel
                Left = 257
                Top = 19
                Width = 15
                Height = 13
                Caption = #33267' '
              end
              object Combo_Sel: TComboBox
                Left = 72
                Top = 61
                Width = 89
                Height = 21
                ItemHeight = 13
                TabOrder = 0
                Text = #20840#37096
                OnClick = Combo_SelClick
                Items.Strings = (
                  #20840#37096
                  #26426#21488#32534#21495
                  #33829#19994#21592#32534#21495
                  #20250#21592#32534#21495)
              end
              object DateTimePicker_Start_Menberinfo: TDateTimePicker
                Left = 72
                Top = 14
                Width = 86
                Height = 21
                Date = 39996.465388541670000000
                Format = 'yyyy-MM-dd'
                Time = 39996.465388541670000000
                TabOrder = 1
              end
              object DateTimePicker_End_Menberinfo: TDateTimePicker
                Left = 272
                Top = 13
                Width = 81
                Height = 21
                Date = 41080.465738587960000000
                Format = 'yyyy-MM-dd'
                Time = 41080.465738587960000000
                TabOrder = 2
              end
              object TimePicker_End_Menberinfo: TDateTimePicker
                Left = 357
                Top = 14
                Width = 89
                Height = 19
                Date = 40457.670287175920000000
                Time = 40457.670287175920000000
                Kind = dtkTime
                TabOrder = 3
              end
              object Panel_GameMC: TPanel
                Left = 168
                Top = 56
                Width = 297
                Height = 33
                BevelOuter = bvNone
                TabOrder = 4
                Visible = False
                object Label7: TLabel
                  Left = 6
                  Top = 8
                  Width = 75
                  Height = 13
                  Caption = #28216#25103#26426#21488#65306'     '
                end
                object Label8: TLabel
                  Left = 178
                  Top = 12
                  Width = 63
                  Height = 13
                  Caption = #26426#21488#20301#65306'     '
                end
                object Combo_MCname: TComboBox
                  Left = 72
                  Top = 4
                  Width = 97
                  Height = 21
                  ItemHeight = 13
                  TabOrder = 0
                  Text = #20840#37096
                  OnClick = Combo_MCnameClick
                  Items.Strings = (
                    #20840#37096
                    #26426#21488#32534#21495
                    #26426#21488#21517#31216
                    #29992#25143#32534#21495
                    #29992#25143#22995#21517)
                end
                object ComboBox_CardMC_ID: TComboBox
                  Left = 235
                  Top = 9
                  Width = 65
                  Height = 21
                  ItemHeight = 0
                  TabOrder = 1
                  Text = #20840#37096
                end
              end
              object Panel_Man: TPanel
                Left = 315
                Top = 32
                Width = 218
                Height = 33
                BevelOuter = bvNone
                Caption = 'Panel10'
                TabOrder = 5
                Visible = False
                object Label11: TLabel
                  Left = 6
                  Top = 8
                  Width = 87
                  Height = 13
                  Caption = #24403#29677#33829#19994#21592#65306'     '
                end
                object Combo_OP: TComboBox
                  Left = 160
                  Top = -4
                  Width = 97
                  Height = 21
                  ItemHeight = 13
                  TabOrder = 0
                  Text = #20840#37096
                  Items.Strings = (
                    #20840#37096
                    #26426#21488#32534#21495
                    #26426#21488#21517#31216
                    #29992#25143#32534#21495
                    #29992#25143#22995#21517)
                end
              end
              object TimePicker_Start_Menberinfo: TDateTimePicker
                Left = 165
                Top = 14
                Width = 89
                Height = 19
                Date = 40457.670287175920000000
                Time = 40457.670287175920000000
                Kind = dtkTime
                TabOrder = 6
              end
              object Panel_Menber: TPanel
                Left = 167
                Top = 58
                Width = 170
                Height = 33
                BevelOuter = bvNone
                TabOrder = 7
                Visible = False
                object Label2: TLabel
                  Left = 6
                  Top = 8
                  Width = 75
                  Height = 13
                  Caption = #20250#21592#32534#21495#65306'     '
                end
                object ComboBox1: TComboBox
                  Left = 88
                  Top = 4
                  Width = 81
                  Height = 21
                  ItemHeight = 0
                  TabOrder = 0
                  Text = #20840#37096
                end
              end
            end
            object Panel11: TPanel
              Left = 553
              Top = 1
              Width = 206
              Height = 95
              Align = alClient
              BevelOuter = bvLowered
              TabOrder = 1
              object BitBtn3: TBitBtn
                Left = 13
                Top = 24
                Width = 76
                Height = 41
                Caption = #26597#35810
                TabOrder = 0
                OnClick = BitBtn3Click
                Glyph.Data = {
                  360C0000424D360C000000000000360000002800000020000000200000000100
                  180000000000000C0000C40E0000C40E00000000000000000000FFFFFFFFFFFF
                  E0F8FF61DBFF53D8FF96E8FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                  FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                  FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFC6F2FF
                  00C5FF1ACDFF1CCDFF08C9FF91E3FEFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                  FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                  FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF55DBFF
                  22D0FF2BD2FF2BD2FF2ED6FF00A6F8FFFEFEFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                  FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                  FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF88E1FE
                  25D4FF36D7FF37D9FF32D3FF099CF464BFF8FFFFFFFFFFFFFFFFFFFFFFFFFFFF
                  FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                  FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                  1DBDFC1DC2FC1FBDFB0FA5F714A5F70093F4F0F8FEFFFFFFFFFFFFFFFFFFFFFF
                  FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                  FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                  FFFFFF00A8F90AACF811AAF714A7F60FA0F53BAEF6FFFFFFFFFFFFFFFFFFFFFF
                  FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                  FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                  FFFFFFC8EEFE00A5F910ACF913A8F715A5F60095F4DFF1FDFFFFFFFFFFFFFFFF
                  FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                  FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                  FFFFFFFFFFFF86D8FD00A6F811AAF714A6F713A1F5139CF4FFFFFFFFFFFFFFFF
                  FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                  FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                  FFFFFFFFFFFFFFFFFF2EBAFA07A9F813A8F716A4F50397F3B4DFFBFFFFFFFFFF
                  FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                  FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                  FFFFFFFFFFFFFFFFFFFFFFFF00A4F810A9F815A6F714A1F6189DF4FFFFFFFFFF
                  FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                  FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                  FFFFFFFFFFFFFFFFFFFFFFFFDEF4FE009EF613A7F616A3F50D99F463C8FA59DC
                  FF4BD6FF00C4FF00C5FF00C5FF00C5FF00C5FF23CDFF44D5FF7CE1FFADEDFFFF
                  FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                  FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF8FD9FC04A2F715A5F618A0F5129CF415D1
                  FF16CBFF1DCCFF1DCCFF1DCCFF1DCCFF1DCCFF1ACCFF17CBFF12CAFF0CC9FF00
                  C5FF59DAFFB0EDFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                  FFFFFFFFFFFFFFFFFFFFFFFF67DDFF0ACDFF17B9FB13A3F617A3F6199BF41EB8
                  FA20D0FF20CEFF20CEFF20CEFF20CEFF20CEFF21CDFF21CDFF21CDFF21CDFF21
                  CDFF18CCFF0BC9FF1ACCFFDFF8FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                  FFFFFFFFFFFFF4FCFF06C8FF15CBFF21CEFF24D4FF15ADF815A2F5189FF41C9E
                  F423D3FF22CEFF22CEFF22CEFF23CFFF23CFFF23CFFF23CFFF23CFFF22CFFF22
                  CFFF23CFFF23CFFF20CEFF02C7FF7CE2FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                  FFFFFFF2FCFF0BC9FF20CEFF24CFFF24CFFF24D0FF24D0FF14A5F7169FF520C2
                  FC22D0FF20CDFF20CEFF1FCDFF1FCDFF20CEFF21CEFF23CFFF24CFFF25CFFF25
                  CFFF25D0FF25D0FF25D0FF25D0FF0FCBFF6ADEFFFFFFFFFFFFFFFFFFFFFFFFFF
                  FFFFFF1DCEFF21CFFF27D0FF27D0FF27D0FF26D0FF23CFFF21D1FF1DD1FF21D0
                  FF35D5FF42DBFF48DDFF4FDFFF4CDFFF46DCFF3CD8FF2AD1FF1BCCFF1FCDFF22
                  CEFF26D0FF28D0FF28D0FF28D0FF27D0FF09CAFFDBF7FFFFFFFFFFFFFFFFFFFF
                  C2F2FF13CCFF29D0FF29D0FF28D0FF22CEFF1DCCFF41D9FF64E8FF7FF3FF8DFA
                  FF88F8FF90F8FFA0F8FDA0F8FE9FF6FA95F6FB8AF7FF89F9FF89F8FF6FEDFF52
                  E0FF27D0FF20CEFF27D0FF2AD1FF2AD1FF22D0FF5FDCFFFFFFFFFFFFFFFFFFFF
                  90E8FF1DCFFF2AD2FF26D0FF21CEFF5AE3FF8AF7FF87F8FFA0F6FACBF3EFECF2
                  E7FFF1E1FFF1E0FFF0DFFFF3E5FFF8EFFFFAF3FFF6EAF7F3E7D8F0E6B4F3F189
                  F8FF8FFAFF71ECFF33D5FF24CFFF2CD2FF2DD2FF0ACBFFFFFFFFFFFFFFFFFFFF
                  96E8FF20CFFF25CFFF40D9FF8FF7FF84F7FFB0F4F6F7F2E5FFF2E2FFF3E4FFF3
                  E5FCF3E6FCF3E7FCF3E6FCF3E6FBF2E3FCF3E6FEFAF6FFFBF6FFFAF4FFF4E5FF
                  ECD7CFF0E98AF6FF92FAFF66E7FF24CFFF2DD2FF15CDFFFFFFFFFFFFFFFFFFFF
                  97E9FF19CDFF56E2FF96FAFF86F5FFECF3E9FFF3E4FEF3E7FBF4E9FBF4E9FCF4
                  EAFCF5EAFCF5EAFCF4EAFBF4E9FBF4E9FBF3E7FBF2E5FEFAF5FEFAF5FEFAF6FE
                  F9F2FFEEDBFFEDD8A8F3F588F8FF82F2FF28D0FF16CEFFFFFFFFFFFFFFFFFFFF
                  94E8FF3CDAFF96FAFF86F5FFFFF3E5FFF4E7FCF4EAFCF5EBFCF5ECFDF6ECFDF6
                  ECFDF6EDFDF6EDFDF6ECFDF6ECFCF5ECFCF5EBFCF4E9FCF4E9FEFBF8FEFAF6FE
                  FAF6FDF9F3FBEEDCFFEDD6B0F2F289F7FF7DF0FF0FCBFFFFFFFFFFFFFFFFFFFF
                  90E6FF83F4FF83F7FFE5F4ECFFF5E8FCF5EBFDF6ECFDF6EDFDF7EEFDF7EEFDF7
                  EFFCF7EFFCF7EFFDF7EFFDF7EEFDF7EEFDF6EDFDF6ECFCF4E9FDF9F4FEFBF7FE
                  FBF5FEFBF7FCF4E9FBEFDDFFEFD78AF3FE93F9FF36DAFFFFFFFFFFFFFFFFFFFF
                  AEF1FF87F6FF85EDFD9FC1EAFFFFEBFDF6EEFDF7EEFCF7F0FCF8F1FCF8F1FCF8
                  F2FDF8F1FDF8F1FCF8F2FCF8F1FCF8F1FCF7F0FDF7EEFCF6EDFEF8F1FEFBF8FE
                  FAF7FEFBF6FEF9F3FFF3DFE5E2DF78C8F18EFAFF5EE9FFFFFFFFFFFFFFFFFFFF
                  C0F8FF84F6FF87E4FA73B3EEAED3EFFFFFEFFFF9F1FDF9F2FDF9F3FEF9F3FEF9
                  F3FEFAF4FEFAF4FEF9F3FEF9F3FDF9F2FDF9F2FCF8F1FCF7EFFEF8F3FEFCF9FE
                  FBF8FEFBF7FFFFF7EDEAE372B2EA82C6ED8CFAFF75F1FFFFFFFFFFFFFFFFFFFF
                  C1F9FF85F6FF76E5FD6DB1EF77BBF28DC7F2F7F6F3FFFFF4FFFCF5FEFBF6FEFA
                  F6FEFBF6FEFBF6FEFBF6FEFAF6FEFAF4FEFAF4FDF9F3FDF8F1FEFBF6FFFCF9FF
                  FEF8FFFFF8DEEDF669B3EC84BCEA59BFF48DFAFF8DF5FFFFFFFFFFFFFFFFFFFF
                  F4FEFF78F3FF96FFFF239DF377BCF280C2F26CB9F39FD1F4DFEDF6FFFFF7FFFF
                  F8FFFFF8FFFEF8FFFEF8FFFDF7FFFDF7FFFDF6FFFDF5FFFDF3FFFFFAFDFCFADA
                  ECF8B4DAF6AFD8F582C1EC2C96EF76E6FE87F6FFAFF8FFFFFFFFFFFFFFFFFFFF
                  FFFFFFBBF9FF84F6FF85F1FE068BF151B0F388C9F47BC3F570BEF56FBDF696CF
                  F6B6DDF7C8E5F8D4EAF8E7F2F8DEEEF7CDE6F7C0E0F5A6D5F4BBDFF9ABD8F7B6
                  DCF8C6E3F79BD0F41190F14CC4F893FDFF7DF3FFFFFFFFFFFFFFFFFFFFFFFFFF
                  FFFFFFFFFFFF90F5FF86F8FF84F0FE1299F31396F351B3F57DC6F684C9F77DC6
                  F778C3F675C2F672C1F670C0F671C0F673C1F670C0F5ACDAF8C2E3F9C4E4F98C
                  CCF638A7F40088F256CCFA95FFFF7EF4FFF9FEFFFFFFFFFFFFFFFFFFFFFFFFFF
                  FFFFFFFFFFFFFFFFFFBBF9FF7CF5FF93FEFF51C9FA0A96F40393F31FA0F43FAE
                  F656B8F764BEF76EC2F76FC2F770C2F767BFF664BEF66BC1F739ABF50494F300
                  8EF32DB0F783F0FE8AFBFF86F4FFF8FEFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                  FFFFFFFFFFFFFFFFFFFFFFFFECFDFF9DF7FF83F9FF90FDFF65DBFB38BAF8119F
                  F50194F40396F40397F40397F40397F40396F40195F40397F426AEF651CCFA84
                  F3FE8CFDFF82F6FFC4FAFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                  FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5FEFFBBF9FF90F8FF84FAFF8EFE
                  FF89F8FF73E9FD68E1FD64DEFC64DEFC6FE6FD7FF1FE8EFDFF89FBFF89F9FFAA
                  F9FFD6FBFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                  FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEDFD
                  FFC9FBFFCFFCFFD0FDFFD0FDFFD0FDFFCFFDFFCBFBFFE5FDFFF4FEFFFFFFFFFF
                  FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF}
              end
              object BitBtn4: TBitBtn
                Left = 120
                Top = 24
                Width = 70
                Height = 41
                Caption = #21462#28040
                TabOrder = 1
                OnClick = bit_refund_cancel_click
                Kind = bkClose
              end
              object BitBtn6: TBitBtn
                Left = 77
                Top = 56
                Width = 76
                Height = 33
                Caption = #25171#21360
                TabOrder = 2
                Visible = False
              end
            end
          end
          object Panel7: TPanel
            Left = 0
            Top = 97
            Width = 760
            Height = 421
            Align = alClient
            Caption = 'Panel7'
            TabOrder = 1
            object DBGridEh_QueryRecord: TDBGridEh
              Left = 1
              Top = 1
              Width = 758
              Height = 419
              Align = alClient
              DataGrouping.Active = True
              DataGrouping.GroupLevels = <>
              DataSource = DataSource_QueryRecord
              Flat = False
              FooterColor = clWindow
              FooterFont.Charset = DEFAULT_CHARSET
              FooterFont.Color = clWindowText
              FooterFont.Height = -11
              FooterFont.Name = 'MS Sans Serif'
              FooterFont.Style = []
              RowDetailPanel.Color = clBtnFace
              SumList.Active = True
              TabOrder = 0
              TitleFont.Charset = DEFAULT_CHARSET
              TitleFont.Color = clWindowText
              TitleFont.Height = -11
              TitleFont.Name = 'MS Sans Serif'
              TitleFont.Style = []
              TitleLines = 1
              UseMultiTitle = True
              Columns = <
                item
                  Checkboxes = False
                  EditButtons = <>
                  FieldName = 'Scaner'
                  Footers = <>
                  MaxWidth = 120
                  Title.Caption = #24403#29677#33829#19994#21592
                  Width = 80
                end
                item
                  EditButtons = <>
                  FieldName = 'GameName'
                  Footers = <>
                  Title.Caption = #28216#25103#26426#21488
                  Width = 120
                end
                item
                  EditButtons = <>
                  FieldName = 'MacNo'
                  Footers = <>
                  Title.Caption = #26426#21488#20301
                  Width = 100
                end
                item
                  EditButtons = <>
                  FieldName = 'CORE'
                  Footers = <>
                  Title.Caption = #31080#25454#31215#20998
                end
                item
                  EditButtons = <>
                  FieldName = 'FLOWbar'
                  Footers = <>
                  Title.Caption = #31080#25454#27969#27700#21495
                  Width = 120
                end
                item
                  EditButtons = <>
                  FieldName = 'DATETIME_OPERATE'
                  Footers = <>
                  Title.Caption = #25171#31080#26102#38388
                  Width = 120
                end
                item
                  EditButtons = <>
                  FieldName = 'DATETIME_SCAN'
                  Footers = <>
                  Title.Caption = #31080#25454#20817#25442#26102#38388
                  Width = 120
                end>
              object RowDetailData: TRowDetailPanelControlEh
              end
            end
          end
        end
        object TabSheet3: TTabSheet
          Caption = #36864#24065#26126#32454
          ImageIndex = 2
          object Panel6: TPanel
            Left = 0
            Top = 16
            Width = 761
            Height = 81
            Caption = 'Panel6'
            TabOrder = 0
            object Panel10: TPanel
              Left = 0
              Top = 0
              Width = 489
              Height = 81
              TabOrder = 0
              object Panel14: TPanel
                Left = 1
                Top = 1
                Width = 552
                Height = 79
                Align = alLeft
                BevelOuter = bvLowered
                TabOrder = 0
                object Label15: TLabel
                  Left = 8
                  Top = 8
                  Width = 3
                  Height = 13
                end
                object Label16: TLabel
                  Left = 9
                  Top = 20
                  Width = 75
                  Height = 13
                  Caption = #33829#19994#26102#38388#65306'     '
                end
                object Label17: TLabel
                  Left = 280
                  Top = 19
                  Width = 15
                  Height = 13
                  Caption = #33267' '
                end
                object Label18: TLabel
                  Left = 9
                  Top = 64
                  Width = 75
                  Height = 13
                  Caption = #26597#35810#26465#20214#65306'     '
                  Visible = False
                end
                object DTP_refund_start_date: TDateTimePicker
                  Left = 87
                  Top = 14
                  Width = 86
                  Height = 21
                  Date = 39996.465388541670000000
                  Format = 'yyyy-MM-dd'
                  Time = 39996.465388541670000000
                  TabOrder = 0
                end
                object dtp_refund_end_date: TDateTimePicker
                  Left = 295
                  Top = 13
                  Width = 81
                  Height = 21
                  Date = 41080.465738587960000000
                  Format = 'yyyy-MM-dd'
                  Time = 41080.465738587960000000
                  TabOrder = 1
                end
                object dtp_refund_end_time: TDateTimePicker
                  Left = 380
                  Top = 14
                  Width = 89
                  Height = 19
                  Date = 40457.670287175920000000
                  Time = 40457.670287175920000000
                  Kind = dtkTime
                  TabOrder = 2
                end
                object dtp_refund_start_time: TDateTimePicker
                  Left = 180
                  Top = 14
                  Width = 89
                  Height = 19
                  Date = 40457.000000000000000000
                  Time = 40457.000000000000000000
                  Kind = dtkTime
                  TabOrder = 3
                end
                object cob_refund: TComboBox
                  Left = 88
                  Top = 61
                  Width = 86
                  Height = 21
                  Enabled = False
                  ItemHeight = 13
                  TabOrder = 4
                  Text = #20840#37096
                  Visible = False
                  OnClick = cob_rechargeClick
                  Items.Strings = (
                    #20840#37096
                    #33829#19994#21592#32534#21495
                    #20250#21592#32534#21495)
                end
                object Panel15: TPanel
                  Left = 184
                  Top = 48
                  Width = 233
                  Height = 41
                  BevelOuter = bvNone
                  TabOrder = 5
                  Visible = False
                  object Label19: TLabel
                    Left = 2
                    Top = 16
                    Width = 75
                    Height = 13
                    Caption = #20250#21592#32534#21495#65306'     '
                  end
                  object ComboBox6: TComboBox
                    Left = 88
                    Top = 12
                    Width = 97
                    Height = 21
                    ItemHeight = 13
                    TabOrder = 0
                    Text = #20840#37096
                    Items.Strings = (
                      '')
                  end
                end
                object Panel16: TPanel
                  Left = 184
                  Top = 52
                  Width = 201
                  Height = 41
                  BevelOuter = bvNone
                  TabOrder = 6
                  Visible = False
                  object Label20: TLabel
                    Left = 10
                    Top = 12
                    Width = 63
                    Height = 13
                    Caption = #33829#19994#21592#65306'     '
                    Enabled = False
                    Visible = False
                  end
                  object cob_refund_operator: TComboBox
                    Left = 72
                    Top = 10
                    Width = 97
                    Height = 21
                    Enabled = False
                    ItemHeight = 13
                    TabOrder = 0
                    Text = #20840#37096
                    Items.Strings = (
                      '')
                  end
                end
              end
            end
          end
          object Panel13: TPanel
            Left = 496
            Top = 16
            Width = 265
            Height = 73
            TabOrder = 1
            object Panel17: TPanel
              Left = 1
              Top = 1
              Width = 263
              Height = 71
              Align = alClient
              BevelOuter = bvLowered
              TabOrder = 0
              object Bit_refund_query: TBitBtn
                Left = 13
                Top = 16
                Width = 76
                Height = 41
                Caption = #26597#35810
                TabOrder = 0
                OnClick = Bit_refund_queryClick
                Glyph.Data = {
                  360C0000424D360C000000000000360000002800000020000000200000000100
                  180000000000000C0000C40E0000C40E00000000000000000000FFFFFFFFFFFF
                  E0F8FF61DBFF53D8FF96E8FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                  FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                  FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFC6F2FF
                  00C5FF1ACDFF1CCDFF08C9FF91E3FEFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                  FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                  FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF55DBFF
                  22D0FF2BD2FF2BD2FF2ED6FF00A6F8FFFEFEFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                  FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                  FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF88E1FE
                  25D4FF36D7FF37D9FF32D3FF099CF464BFF8FFFFFFFFFFFFFFFFFFFFFFFFFFFF
                  FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                  FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                  1DBDFC1DC2FC1FBDFB0FA5F714A5F70093F4F0F8FEFFFFFFFFFFFFFFFFFFFFFF
                  FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                  FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                  FFFFFF00A8F90AACF811AAF714A7F60FA0F53BAEF6FFFFFFFFFFFFFFFFFFFFFF
                  FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                  FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                  FFFFFFC8EEFE00A5F910ACF913A8F715A5F60095F4DFF1FDFFFFFFFFFFFFFFFF
                  FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                  FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                  FFFFFFFFFFFF86D8FD00A6F811AAF714A6F713A1F5139CF4FFFFFFFFFFFFFFFF
                  FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                  FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                  FFFFFFFFFFFFFFFFFF2EBAFA07A9F813A8F716A4F50397F3B4DFFBFFFFFFFFFF
                  FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                  FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                  FFFFFFFFFFFFFFFFFFFFFFFF00A4F810A9F815A6F714A1F6189DF4FFFFFFFFFF
                  FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                  FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                  FFFFFFFFFFFFFFFFFFFFFFFFDEF4FE009EF613A7F616A3F50D99F463C8FA59DC
                  FF4BD6FF00C4FF00C5FF00C5FF00C5FF00C5FF23CDFF44D5FF7CE1FFADEDFFFF
                  FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                  FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF8FD9FC04A2F715A5F618A0F5129CF415D1
                  FF16CBFF1DCCFF1DCCFF1DCCFF1DCCFF1DCCFF1ACCFF17CBFF12CAFF0CC9FF00
                  C5FF59DAFFB0EDFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                  FFFFFFFFFFFFFFFFFFFFFFFF67DDFF0ACDFF17B9FB13A3F617A3F6199BF41EB8
                  FA20D0FF20CEFF20CEFF20CEFF20CEFF20CEFF21CDFF21CDFF21CDFF21CDFF21
                  CDFF18CCFF0BC9FF1ACCFFDFF8FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                  FFFFFFFFFFFFF4FCFF06C8FF15CBFF21CEFF24D4FF15ADF815A2F5189FF41C9E
                  F423D3FF22CEFF22CEFF22CEFF23CFFF23CFFF23CFFF23CFFF23CFFF22CFFF22
                  CFFF23CFFF23CFFF20CEFF02C7FF7CE2FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                  FFFFFFF2FCFF0BC9FF20CEFF24CFFF24CFFF24D0FF24D0FF14A5F7169FF520C2
                  FC22D0FF20CDFF20CEFF1FCDFF1FCDFF20CEFF21CEFF23CFFF24CFFF25CFFF25
                  CFFF25D0FF25D0FF25D0FF25D0FF0FCBFF6ADEFFFFFFFFFFFFFFFFFFFFFFFFFF
                  FFFFFF1DCEFF21CFFF27D0FF27D0FF27D0FF26D0FF23CFFF21D1FF1DD1FF21D0
                  FF35D5FF42DBFF48DDFF4FDFFF4CDFFF46DCFF3CD8FF2AD1FF1BCCFF1FCDFF22
                  CEFF26D0FF28D0FF28D0FF28D0FF27D0FF09CAFFDBF7FFFFFFFFFFFFFFFFFFFF
                  C2F2FF13CCFF29D0FF29D0FF28D0FF22CEFF1DCCFF41D9FF64E8FF7FF3FF8DFA
                  FF88F8FF90F8FFA0F8FDA0F8FE9FF6FA95F6FB8AF7FF89F9FF89F8FF6FEDFF52
                  E0FF27D0FF20CEFF27D0FF2AD1FF2AD1FF22D0FF5FDCFFFFFFFFFFFFFFFFFFFF
                  90E8FF1DCFFF2AD2FF26D0FF21CEFF5AE3FF8AF7FF87F8FFA0F6FACBF3EFECF2
                  E7FFF1E1FFF1E0FFF0DFFFF3E5FFF8EFFFFAF3FFF6EAF7F3E7D8F0E6B4F3F189
                  F8FF8FFAFF71ECFF33D5FF24CFFF2CD2FF2DD2FF0ACBFFFFFFFFFFFFFFFFFFFF
                  96E8FF20CFFF25CFFF40D9FF8FF7FF84F7FFB0F4F6F7F2E5FFF2E2FFF3E4FFF3
                  E5FCF3E6FCF3E7FCF3E6FCF3E6FBF2E3FCF3E6FEFAF6FFFBF6FFFAF4FFF4E5FF
                  ECD7CFF0E98AF6FF92FAFF66E7FF24CFFF2DD2FF15CDFFFFFFFFFFFFFFFFFFFF
                  97E9FF19CDFF56E2FF96FAFF86F5FFECF3E9FFF3E4FEF3E7FBF4E9FBF4E9FCF4
                  EAFCF5EAFCF5EAFCF4EAFBF4E9FBF4E9FBF3E7FBF2E5FEFAF5FEFAF5FEFAF6FE
                  F9F2FFEEDBFFEDD8A8F3F588F8FF82F2FF28D0FF16CEFFFFFFFFFFFFFFFFFFFF
                  94E8FF3CDAFF96FAFF86F5FFFFF3E5FFF4E7FCF4EAFCF5EBFCF5ECFDF6ECFDF6
                  ECFDF6EDFDF6EDFDF6ECFDF6ECFCF5ECFCF5EBFCF4E9FCF4E9FEFBF8FEFAF6FE
                  FAF6FDF9F3FBEEDCFFEDD6B0F2F289F7FF7DF0FF0FCBFFFFFFFFFFFFFFFFFFFF
                  90E6FF83F4FF83F7FFE5F4ECFFF5E8FCF5EBFDF6ECFDF6EDFDF7EEFDF7EEFDF7
                  EFFCF7EFFCF7EFFDF7EFFDF7EEFDF7EEFDF6EDFDF6ECFCF4E9FDF9F4FEFBF7FE
                  FBF5FEFBF7FCF4E9FBEFDDFFEFD78AF3FE93F9FF36DAFFFFFFFFFFFFFFFFFFFF
                  AEF1FF87F6FF85EDFD9FC1EAFFFFEBFDF6EEFDF7EEFCF7F0FCF8F1FCF8F1FCF8
                  F2FDF8F1FDF8F1FCF8F2FCF8F1FCF8F1FCF7F0FDF7EEFCF6EDFEF8F1FEFBF8FE
                  FAF7FEFBF6FEF9F3FFF3DFE5E2DF78C8F18EFAFF5EE9FFFFFFFFFFFFFFFFFFFF
                  C0F8FF84F6FF87E4FA73B3EEAED3EFFFFFEFFFF9F1FDF9F2FDF9F3FEF9F3FEF9
                  F3FEFAF4FEFAF4FEF9F3FEF9F3FDF9F2FDF9F2FCF8F1FCF7EFFEF8F3FEFCF9FE
                  FBF8FEFBF7FFFFF7EDEAE372B2EA82C6ED8CFAFF75F1FFFFFFFFFFFFFFFFFFFF
                  C1F9FF85F6FF76E5FD6DB1EF77BBF28DC7F2F7F6F3FFFFF4FFFCF5FEFBF6FEFA
                  F6FEFBF6FEFBF6FEFBF6FEFAF6FEFAF4FEFAF4FDF9F3FDF8F1FEFBF6FFFCF9FF
                  FEF8FFFFF8DEEDF669B3EC84BCEA59BFF48DFAFF8DF5FFFFFFFFFFFFFFFFFFFF
                  F4FEFF78F3FF96FFFF239DF377BCF280C2F26CB9F39FD1F4DFEDF6FFFFF7FFFF
                  F8FFFFF8FFFEF8FFFEF8FFFDF7FFFDF7FFFDF6FFFDF5FFFDF3FFFFFAFDFCFADA
                  ECF8B4DAF6AFD8F582C1EC2C96EF76E6FE87F6FFAFF8FFFFFFFFFFFFFFFFFFFF
                  FFFFFFBBF9FF84F6FF85F1FE068BF151B0F388C9F47BC3F570BEF56FBDF696CF
                  F6B6DDF7C8E5F8D4EAF8E7F2F8DEEEF7CDE6F7C0E0F5A6D5F4BBDFF9ABD8F7B6
                  DCF8C6E3F79BD0F41190F14CC4F893FDFF7DF3FFFFFFFFFFFFFFFFFFFFFFFFFF
                  FFFFFFFFFFFF90F5FF86F8FF84F0FE1299F31396F351B3F57DC6F684C9F77DC6
                  F778C3F675C2F672C1F670C0F671C0F673C1F670C0F5ACDAF8C2E3F9C4E4F98C
                  CCF638A7F40088F256CCFA95FFFF7EF4FFF9FEFFFFFFFFFFFFFFFFFFFFFFFFFF
                  FFFFFFFFFFFFFFFFFFBBF9FF7CF5FF93FEFF51C9FA0A96F40393F31FA0F43FAE
                  F656B8F764BEF76EC2F76FC2F770C2F767BFF664BEF66BC1F739ABF50494F300
                  8EF32DB0F783F0FE8AFBFF86F4FFF8FEFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                  FFFFFFFFFFFFFFFFFFFFFFFFECFDFF9DF7FF83F9FF90FDFF65DBFB38BAF8119F
                  F50194F40396F40397F40397F40397F40396F40195F40397F426AEF651CCFA84
                  F3FE8CFDFF82F6FFC4FAFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                  FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5FEFFBBF9FF90F8FF84FAFF8EFE
                  FF89F8FF73E9FD68E1FD64DEFC64DEFC6FE6FD7FF1FE8EFDFF89FBFF89F9FFAA
                  F9FFD6FBFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                  FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEDFD
                  FFC9FBFFCFFCFFD0FDFFD0FDFFD0FDFFCFFDFFCBFBFFE5FDFFF4FEFFFFFFFFFF
                  FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF}
              end
              object bit_refund_cancel: TBitBtn
                Left = 176
                Top = 8
                Width = 70
                Height = 41
                Caption = #21462#28040
                TabOrder = 1
                OnClick = bit_refund_cancel_click
                Kind = bkClose
              end
              object bit_refund_print: TBitBtn
                Left = 93
                Top = 40
                Width = 76
                Height = 33
                Caption = #25171#21360
                TabOrder = 2
                Visible = False
              end
            end
          end
          object Panel18: TPanel
            Left = 0
            Top = 112
            Width = 761
            Height = 401
            Caption = 'Panel18'
            TabOrder = 2
          end
          object DBGrid_refund: TDBGrid
            Left = 0
            Top = 104
            Width = 753
            Height = 401
            DataSource = DataSource_refund
            TabOrder = 3
            TitleFont.Charset = DEFAULT_CHARSET
            TitleFont.Color = clWindowText
            TitleFont.Height = -11
            TitleFont.Name = 'MS Sans Serif'
            TitleFont.Style = []
            Columns = <
              item
                Expanded = False
                FieldName = 'md_id'
                Title.Caption = #24207#21495
                Width = 30
                Visible = True
              end
              item
                Expanded = False
                FieldName = 'id_usercard'
                Title.Caption = #30005#23376#24065'ID'
                Visible = True
              end
              item
                Expanded = False
                FieldName = 'cUserno'
                Title.Caption = #25805#20316#21592
                Width = 50
                Visible = True
              end
              item
                Expanded = False
                FieldName = 'membername'
                Title.Caption = #20250#21592
                Width = 40
                Visible = True
              end
              item
                Expanded = False
                FieldName = 'gettime'
                Title.Caption = #20805#20540#26102#38388
                Visible = True
              end
              item
                Expanded = False
                FieldName = 'costmoney'
                Title.Caption = #24065#20540
                Width = 30
                Visible = True
              end
              item
                Expanded = False
                FieldName = 'tuibi_time'
                Title.Caption = #36864#24065#26102#38388
                Visible = True
              end>
          end
        end
      end
    end
  end
  object DataSource_Recrod: TDataSource
    DataSet = ADOQuery_Recrod
    Left = 113
    Top = 324
  end
  object ADOQuery_Recrod: TADOQuery
    Parameters = <>
    Left = 137
    Top = 324
  end
  object DataSource_QueryRecord: TDataSource
    DataSet = ADOQuery_QueryRecord
    Left = 209
    Top = 324
  end
  object ADOQuery_QueryRecord: TADOQuery
    Parameters = <>
    Left = 241
    Top = 324
  end
  object DataSource_refund: TDataSource
    DataSet = ADOQuery_refund
    Left = 326
    Top = 325
  end
  object ADOQuery_refund: TADOQuery
    Parameters = <>
    Left = 374
    Top = 325
  end
end
