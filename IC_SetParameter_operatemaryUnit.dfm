object frm_IC_SetParameter_operatemary: Tfrm_IC_SetParameter_operatemary
  Left = 297
  Top = 127
  Width = 803
  Height = 500
  BorderIcons = []
  Caption = #25805#20316#26085#24535
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object pgcMenberfor: TPageControl
    Left = 0
    Top = 0
    Width = 795
    Height = 466
    ActivePage = tbsConfig
    Align = alClient
    MultiLine = True
    TabOrder = 0
    object tbsConfig: TTabSheet
      Caption = #31995#32479#25805#20316#26085#24535
      ImageIndex = 1
      object Panel3: TPanel
        Left = 0
        Top = 0
        Width = 787
        Height = 51
        Align = alTop
        TabOrder = 0
        object Panel8: TPanel
          Left = 1
          Top = 1
          Width = 600
          Height = 49
          Align = alLeft
          BevelOuter = bvLowered
          TabOrder = 0
          object Label4: TLabel
            Left = 401
            Top = 20
            Width = 15
            Height = 13
            Caption = #33267' '
          end
          object Label5: TLabel
            Left = 152
            Top = 19
            Width = 60
            Height = 13
            Caption = #25805#20316#26085#26399'    '
          end
          object Label6: TLabel
            Left = 8
            Top = 19
            Width = 57
            Height = 13
            Caption = #25805#20316#20154#21592'   '
          end
          object DateTimePicker1: TDateTimePicker
            Left = 208
            Top = 15
            Width = 86
            Height = 21
            Date = 39996.465388541670000000
            Format = 'yyyy-MM-dd'
            Time = 39996.465388541670000000
            Enabled = False
            TabOrder = 0
          end
          object DateTimePicker2: TDateTimePicker
            Left = 416
            Top = 14
            Width = 81
            Height = 21
            Date = 41080.465738587960000000
            Format = 'yyyy-MM-dd'
            Time = 41080.465738587960000000
            Enabled = False
            TabOrder = 1
          end
          object DateTimePicker3: TDateTimePicker
            Left = 296
            Top = 15
            Width = 89
            Height = 19
            Date = 40457.670287175920000000
            Format = 'hh:mm:ss'
            Time = 40457.670287175920000000
            Enabled = False
            Kind = dtkTime
            TabOrder = 2
          end
          object DateTimePicker4: TDateTimePicker
            Left = 504
            Top = 16
            Width = 89
            Height = 19
            Date = 40457.670287175920000000
            Time = 40457.670287175920000000
            Enabled = False
            Kind = dtkTime
            TabOrder = 3
          end
          object ComboBox1: TComboBox
            Left = 64
            Top = 16
            Width = 89
            Height = 21
            ItemHeight = 13
            TabOrder = 4
            Text = #20840#37096
          end
        end
        object Panel9: TPanel
          Left = 601
          Top = 1
          Width = 185
          Height = 49
          Align = alClient
          BevelOuter = bvLowered
          TabOrder = 1
          object BitBtn2: TBitBtn
            Left = 101
            Top = 8
            Width = 81
            Height = 33
            Caption = #20851#38381
            TabOrder = 0
            OnClick = BitBtn2Click
          end
          object BitBtn3: TBitBtn
            Left = 5
            Top = 8
            Width = 89
            Height = 33
            Caption = #26597#35810
            TabOrder = 1
          end
        end
      end
      object Panel2: TPanel
        Left = 0
        Top = 51
        Width = 787
        Height = 387
        Align = alClient
        TabOrder = 1
        object DBGrid1: TDBGrid
          Left = 1
          Top = 1
          Width = 785
          Height = 385
          Align = alClient
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
              FieldName = 'MI_ID'
              Title.Alignment = taCenter
              Title.Caption = #24207#21495
              Width = 50
              Visible = True
            end
            item
              Alignment = taCenter
              Expanded = False
              FieldName = 'MemCardNo'
              Title.Alignment = taCenter
              Title.Caption = #25805#20316#26102#38388
              Width = 170
              Visible = True
            end
            item
              Alignment = taCenter
              Expanded = False
              FieldName = 'MemberName'
              Title.Alignment = taCenter
              Title.Caption = #25805#20316#20107#20214
              Width = 400
              Visible = True
            end
            item
              Alignment = taCenter
              Expanded = False
              FieldName = 'MemType'
              Title.Alignment = taCenter
              Title.Caption = #25805#20316#21592#22995#21517
              Width = 150
              Visible = True
            end>
        end
      end
    end
    object tbsLowLevel: TTabSheet
      Caption = #21151#33021#26426#27969#27700#24080
      object Panel1: TPanel
        Left = 0
        Top = 0
        Width = 787
        Height = 438
        Align = alClient
        Caption = 'Panel1'
        TabOrder = 0
        object Panel4: TPanel
          Left = 1
          Top = 57
          Width = 785
          Height = 380
          Align = alClient
          TabOrder = 0
          object DBGrid2: TDBGrid
            Left = 1
            Top = 1
            Width = 783
            Height = 378
            Align = alClient
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
                FieldName = 'MI_ID'
                Title.Alignment = taCenter
                Title.Caption = #24207#21495
                Width = 50
                Visible = True
              end
              item
                Alignment = taCenter
                Expanded = False
                FieldName = 'MemCardNo'
                Title.Alignment = taCenter
                Title.Caption = #29992#25143#21345#21495
                Width = 100
                Visible = True
              end
              item
                Alignment = taCenter
                Expanded = False
                FieldName = 'MemberName'
                Title.Alignment = taCenter
                Title.Caption = #29992#25143#22995#21517
                Width = 100
                Visible = True
              end
              item
                Alignment = taCenter
                Expanded = False
                FieldName = 'MemType'
                Title.Alignment = taCenter
                Title.Caption = #26426#21488#32534#21495
                Width = 100
                Visible = True
              end
              item
                Expanded = False
                Title.Caption = #25805#20316#20107#20214
                Width = 270
                Visible = True
              end
              item
                Expanded = False
                Title.Caption = #25805#20316#26102#38388
                Width = 150
                Visible = True
              end>
          end
        end
        object Panel7: TPanel
          Left = 1
          Top = 1
          Width = 785
          Height = 56
          Align = alTop
          TabOrder = 1
          object Panel5: TPanel
            Left = 1
            Top = 1
            Width = 600
            Height = 54
            Align = alLeft
            BevelOuter = bvLowered
            TabOrder = 0
            object Label1: TLabel
              Left = 265
              Top = 20
              Width = 15
              Height = 13
              Caption = #33267' '
            end
            object Label2: TLabel
              Left = 16
              Top = 19
              Width = 60
              Height = 13
              Caption = #25805#20316#26085#26399'    '
            end
            object DateTimePicker5: TDateTimePicker
              Left = 72
              Top = 15
              Width = 86
              Height = 21
              Date = 39996.465388541670000000
              Format = 'yyyy-MM-dd'
              Time = 39996.465388541670000000
              Enabled = False
              TabOrder = 0
            end
            object DateTimePicker6: TDateTimePicker
              Left = 280
              Top = 14
              Width = 81
              Height = 21
              Date = 41080.465738587960000000
              Format = 'yyyy-MM-dd'
              Time = 41080.465738587960000000
              Enabled = False
              TabOrder = 1
            end
            object DateTimePicker7: TDateTimePicker
              Left = 160
              Top = 15
              Width = 89
              Height = 19
              Date = 40457.670287175920000000
              Format = 'hh:mm:ss'
              Time = 40457.670287175920000000
              Enabled = False
              Kind = dtkTime
              TabOrder = 2
            end
            object DateTimePicker8: TDateTimePicker
              Left = 368
              Top = 16
              Width = 89
              Height = 19
              Date = 40457.670287175920000000
              Time = 40457.670287175920000000
              Enabled = False
              Kind = dtkTime
              TabOrder = 3
            end
          end
          object Panel6: TPanel
            Left = 601
            Top = 1
            Width = 183
            Height = 54
            Align = alClient
            BevelOuter = bvLowered
            TabOrder = 1
            object BitBtn4: TBitBtn
              Left = 101
              Top = 8
              Width = 81
              Height = 33
              Caption = #20851#38381
              TabOrder = 0
              OnClick = BitBtn4Click
            end
            object BitBtn5: TBitBtn
              Left = 5
              Top = 8
              Width = 89
              Height = 33
              Caption = #26597#35810
              TabOrder = 1
            end
          end
        end
      end
    end
  end
end
