object frmPresentRecharge: TfrmPresentRecharge
  Left = 364
  Top = 156
  Width = 886
  Height = 619
  BorderStyle = bsSizeToolWin
  Caption = #31036#21697#20817#25442
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  WindowState = wsMaximized
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 8
    Width = 865
    Height = 569
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
        Caption = #20837#24211
        TabOrder = 0
        OnClick = btnSubmitClick
      end
      object btnCancel: TButton
        Left = 40
        Top = 120
        Width = 153
        Height = 42
        Caption = #20817#25442
        TabOrder = 1
        OnClick = btnCancelClick
      end
    end
    object GroupBox1: TGroupBox
      Left = 0
      Top = 8
      Width = 617
      Height = 229
      Caption = #31036#21697#20449#24687
      TabOrder = 1
      object Label1: TLabel
        Left = 9
        Top = 33
        Width = 123
        Height = 33
        Alignment = taCenter
        AutoSize = False
        Caption = #31036#21697#21517#31216':'
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
      object lbl1: TLabel
        Left = 1
        Top = 90
        Width = 137
        Height = 33
        Alignment = taCenter
        AutoSize = False
        Caption = #24635#25968':'
      end
      object lbl2: TLabel
        Left = 290
        Top = 38
        Width = 137
        Height = 33
        Alignment = taCenter
        AutoSize = False
        Caption = #31036#21697#20215#20540':'
      end
      object lbl3: TLabel
        Left = 312
        Top = 90
        Width = 97
        Height = 33
        Alignment = taCenter
        AutoSize = False
        Caption = #25805#20316#25968#37327':'
      end
      object edtPresentName: TEdit
        Left = 132
        Top = 33
        Width = 154
        Height = 21
        TabOrder = 0
      end
      object edtTotalNum: TEdit
        Left = 132
        Top = 88
        Width = 157
        Height = 21
        ReadOnly = True
        TabOrder = 1
        Text = '0'
      end
      object edtPresentValue: TEdit
        Left = 416
        Top = 34
        Width = 177
        Height = 21
        TabOrder = 2
        Text = '0'
      end
      object edtOperNum: TEdit
        Left = 420
        Top = 88
        Width = 177
        Height = 21
        TabOrder = 3
        Text = '0'
      end
    end
    object GroupBox3: TGroupBox
      Left = 8
      Top = 240
      Width = 857
      Height = 329
      Caption = #31036#21697#35760#24405
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
            Title.Caption = #20250#21592#21345'ID'
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'present_name'
            Title.Caption = #31036#21697#21517
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'present_value'
            Title.Caption = #31036#21697#20215#20540
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'total_num'
            Title.Caption = #24635#25968
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'oper_num'
            Title.Caption = #25805#20316#25968#37327
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'oper_type'
            Title.Caption = #31867#22411
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'oper_state'
            Title.Caption = #29366#24577
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
            FieldName = 'operator_no'
            Title.Caption = #25805#20316#21592
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
