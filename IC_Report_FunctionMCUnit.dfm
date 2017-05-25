object frm_IC_Report_FunctionMC: Tfrm_IC_Report_FunctionMC
  Left = 252
  Top = 130
  Width = 827
  Height = 500
  BorderIcons = []
  Caption = #21151#33021#26426#24635#24080
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Panel8: TPanel
    Left = 0
    Top = 0
    Width = 819
    Height = 466
    Align = alClient
    Caption = 'Panel1'
    TabOrder = 0
    object Panel1: TPanel
      Left = 1
      Top = 1
      Width = 817
      Height = 88
      Align = alTop
      Caption = 'Panel1'
      TabOrder = 0
      object Panel5: TPanel
        Left = 545
        Top = 1
        Width = 271
        Height = 86
        Align = alClient
        BevelOuter = bvLowered
        TabOrder = 0
        object BitBtn2: TBitBtn
          Left = 29
          Top = 16
          Width = 76
          Height = 33
          Caption = #26597#35810
          TabOrder = 0
        end
        object BitBtn5: TBitBtn
          Left = 144
          Top = 16
          Width = 70
          Height = 33
          Caption = #20851#38381
          TabOrder = 1
          OnClick = BitBtn5Click
        end
      end
      object Panel4: TPanel
        Left = 1
        Top = 1
        Width = 544
        Height = 86
        Align = alLeft
        BevelOuter = bvLowered
        TabOrder = 1
        object Label1: TLabel
          Left = 8
          Top = 8
          Width = 3
          Height = 13
        end
        object Label3: TLabel
          Left = 9
          Top = 34
          Width = 75
          Height = 13
          Caption = #33829#19994#26102#38388#65306'     '
        end
        object Panel_SaleDate_GameMC: TPanel
          Left = 72
          Top = 24
          Width = 369
          Height = 33
          BevelOuter = bvNone
          TabOrder = 0
          object Label10: TLabel
            Left = 177
            Top = 12
            Width = 15
            Height = 13
            Caption = #33267' '
          end
          object DateTimePicker3: TDateTimePicker
            Left = 0
            Top = 7
            Width = 86
            Height = 21
            Date = 39996.465388541670000000
            Format = 'yyyy-MM-dd'
            Time = 39996.465388541670000000
            TabOrder = 0
          end
          object DateTimePicker4: TDateTimePicker
            Left = 88
            Top = 7
            Width = 89
            Height = 19
            Date = 40457.670287175920000000
            Format = 'hh:mm:ss'
            Time = 40457.670287175920000000
            Kind = dtkTime
            TabOrder = 1
          end
          object DateTimePicker5: TDateTimePicker
            Left = 192
            Top = 6
            Width = 81
            Height = 21
            Date = 41080.465738587960000000
            Format = 'yyyy-MM-dd'
            Time = 41080.465738587960000000
            TabOrder = 2
          end
          object DateTimePicker6: TDateTimePicker
            Left = 276
            Top = 7
            Width = 89
            Height = 19
            Date = 40457.670287175920000000
            Time = 40457.670287175920000000
            Kind = dtkTime
            TabOrder = 3
          end
        end
      end
    end
    object Panel2: TPanel
      Left = 1
      Top = 89
      Width = 817
      Height = 376
      Align = alClient
      Caption = 'Panel2'
      TabOrder = 1
      object pgcMachinerecord: TPageControl
        Left = 1
        Top = 1
        Width = 815
        Height = 374
        ActivePage = tbsConfig
        Align = alClient
        MultiLine = True
        TabOrder = 0
        TabWidth = 120
        object tbsConfig: TTabSheet
          Caption = #21806#24065#26426'|'#20313#24065#24080
          ImageIndex = 1
          object DBGridEh1: TDBGridEh
            Left = 0
            Top = 0
            Width = 807
            Height = 346
            Align = alClient
            DataGrouping.Active = True
            DataGrouping.GroupLevels = <>
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
                FieldName = 'MemCardNo'
                Footers = <>
                MaxWidth = 120
                Title.Caption = #26426#21488#32534#21495
                Width = 120
              end
              item
                EditButtons = <>
                FieldName = 'MemberName'
                Footers = <>
                MaxWidth = 120
                Title.Caption = #26426#21488#21517#31216
                Width = 120
              end
              item
                EditButtons = <>
                FieldName = 'SexName'
                Footers = <>
                Title.Caption = #23384#24065#25968
                Width = 120
              end
              item
                EditButtons = <>
                FieldName = 'LevName'
                Footers = <>
                Title.Caption = #28165#28857#20313#24065
                Width = 120
              end
              item
                EditButtons = <>
                FieldName = 'Score'
                Footers = <>
                Title.Caption = #21806#24065#25968
                Width = 120
              end
              item
                EditButtons = <>
                FieldName = 'CardAmount'
                Footers = <>
                Title.Caption = #20132#26131#26102#38388
                Width = 80
              end
              item
                EditButtons = <>
                FieldName = 'TickAmount'
                Footers = <>
                Title.Caption = #25805#20316#21592#22995#21517
                Width = 100
              end>
            object RowDetailData: TRowDetailPanelControlEh
            end
          end
        end
        object Tab_Gamenameinput: TTabSheet
          Caption = #36828#31243#28040#20998#26426'|'#24403#29677#24080
          ImageIndex = 2
          object DBGridEh2: TDBGridEh
            Left = 0
            Top = 0
            Width = 807
            Height = 346
            Align = alClient
            DataGrouping.Active = True
            DataGrouping.GroupLevels = <>
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
                FieldName = 'MemCardNo'
                Footers = <>
                MaxWidth = 120
                Title.Caption = #26426#21488#32534#21495
                Width = 120
              end
              item
                EditButtons = <>
                FieldName = 'MemberName'
                Footers = <>
                MaxWidth = 120
                Title.Caption = #26426#21488#21517#31216
                Width = 120
              end
              item
                EditButtons = <>
                FieldName = 'Score'
                Footers = <>
                Title.Caption = #24403#29677#24080
                Width = 150
              end
              item
                EditButtons = <>
                FieldName = 'CardAmount'
                Footers = <>
                Title.Caption = #20132#26131#26102#38388
                Width = 240
              end
              item
                EditButtons = <>
                FieldName = 'TickAmount'
                Footers = <>
                Title.Caption = #25805#20316#21592#22995#21517
                Width = 150
              end>
            object RowDetailData: TRowDetailPanelControlEh
            end
          end
        end
        object TabSheet1: TTabSheet
          Caption = #36828#31243#28040#20998#26426'|'#24635#24080
          ImageIndex = 2
          object DBGridEh3: TDBGridEh
            Left = 0
            Top = 0
            Width = 807
            Height = 346
            Align = alClient
            DataGrouping.Active = True
            DataGrouping.GroupLevels = <>
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
                FieldName = 'MemCardNo'
                Footers = <>
                MaxWidth = 120
                Title.Caption = #26426#21488#32534#21495
                Width = 120
              end
              item
                EditButtons = <>
                FieldName = 'MemberName'
                Footers = <>
                MaxWidth = 120
                Title.Caption = #26426#21488#21517#31216
                Width = 120
              end
              item
                EditButtons = <>
                FieldName = 'Score'
                Footers = <>
                Title.Caption = #24635#24080
                Width = 150
              end
              item
                EditButtons = <>
                FieldName = 'CardAmount'
                Footers = <>
                Title.Caption = #20132#26131#26102#38388
                Width = 240
              end
              item
                EditButtons = <>
                FieldName = 'TickAmount'
                Footers = <>
                Title.Caption = #25805#20316#21592#22995#21517
                Width = 150
              end>
            object RowDetailData: TRowDetailPanelControlEh
            end
          end
        end
      end
    end
  end
end
