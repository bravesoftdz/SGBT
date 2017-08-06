object frmMemberConfig: TfrmMemberConfig
  Left = 399
  Top = 132
  Width = 896
  Height = 602
  BorderStyle = bsSizeToolWin
  Caption = #20250#21592#37197#32622
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  WindowState = wsMaximized
  OnClose = FormClose
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = -16
    Top = 0
    Width = 881
    Height = 721
    Caption = 'Panel1'
    TabOrder = 0
    object GroupBox2: TGroupBox
      Left = 632
      Top = 8
      Width = 233
      Height = 229
      Caption = #25805#20316
      TabOrder = 0
      object btnSubmit: TButton
        Left = 40
        Top = 41
        Width = 153
        Height = 49
        Caption = #30830#23450
        TabOrder = 0
        OnClick = btnSubmitClick
      end
      object btnCancel: TButton
        Left = 40
        Top = 120
        Width = 153
        Height = 42
        Caption = #21462#28040
        TabOrder = 1
        OnClick = btnCancelClick
      end
    end
    object GroupBox1: TGroupBox
      Left = 8
      Top = 8
      Width = 617
      Height = 229
      Caption = #20250#21592#20449#24687
      TabOrder = 1
      object Label2: TLabel
        Left = 320
        Top = 51
        Width = 121
        Height = 33
        Alignment = taCenter
        AutoSize = False
        Caption = #22330#22320#21495':'
      end
      object lblMessage: TLabel
        Left = 8
        Top = 200
        Width = 601
        Height = 25
        Alignment = taCenter
        AutoSize = False
        Caption = #25552#31034#20449#24687
      end
      object Label5: TLabel
        Left = 9
        Top = 51
        Width = 137
        Height = 33
        Alignment = taCenter
        AutoSize = False
        Caption = #20844#20247#21495
      end
      object Label6: TLabel
        Left = 12
        Top = 96
        Width = 121
        Height = 25
        Alignment = taCenter
        AutoSize = False
        Caption = #27425#25968':'
      end
      object lbl1: TLabel
        Left = 320
        Top = 99
        Width = 121
        Height = 33
        Alignment = taCenter
        AutoSize = False
        Caption = #37329#39069
      end
      object lbl2: TLabel
        Left = 309
        Top = 97
        Width = 47
        Height = 25
        AutoSize = False
        Caption = #27425
      end
      object edtShopID: TEdit
        Left = 447
        Top = 51
        Width = 154
        Height = 21
        ReadOnly = True
        TabOrder = 0
      end
      object edtAPPID: TEdit
        Left = 148
        Top = 51
        Width = 154
        Height = 21
        ReadOnly = True
        TabOrder = 1
      end
      object edtCoinValue: TEdit
        Left = 447
        Top = 99
        Width = 154
        Height = 21
        TabOrder = 2
      end
      object edtTimes: TEdit
        Left = 149
        Top = 95
        Width = 153
        Height = 21
        TabOrder = 3
      end
    end
    object GroupBox3: TGroupBox
      Left = 8
      Top = 240
      Width = 857
      Height = 329
      Caption = #20250#21592#35760#24405
      TabOrder = 2
      object dgRecharge: TDBGrid
        Left = 0
        Top = 15
        Width = 849
        Height = 258
        DataSource = dsRecharge
        TabOrder = 0
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -11
        TitleFont.Name = 'MS Sans Serif'
        TitleFont.Style = []
        Columns = <
          item
            Expanded = False
            FieldName = 'id'
            Title.Caption = 'ID'
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'coin_type'
            Title.Caption = #27425#25968
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'coin_value'
            Title.Caption = #37329#39069
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'operate_time'
            Title.Caption = #25805#20316#26102#38388
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'operatorno'
            Title.Caption = #25805#20316#21592
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'appid'
            Title.Caption = #20844#20247#21495
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'shopid'
            Title.Caption = #21543#21488#21495
            Visible = True
          end>
      end
    end
  end
  object ADOQ: TADOQuery
    Parameters = <>
    Left = 280
    Top = 534
  end
  object dsRecharge: TDataSource
    DataSet = ADOQ
    Left = 240
    Top = 536
  end
end
