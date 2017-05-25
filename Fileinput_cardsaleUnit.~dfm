object frm_Fileinput_cardsale: Tfrm_Fileinput_cardsale
  Left = 278
  Top = 223
  Width = 845
  Height = 500
  BorderIcons = []
  Caption = '3F'#20339#26519#31185#25216'-'#36164#26009#24405#20837'-'#21806#24065#22871#39184
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
    Width = 837
    Height = 121
    Align = alTop
    BorderStyle = bsSingle
    TabOrder = 0
    object Label1: TLabel
      Left = 8
      Top = 8
      Width = 48
      Height = 13
      Caption = #22871#39184#32534#21495
    end
    object Label2: TLabel
      Left = 8
      Top = 35
      Width = 33
      Height = 13
      Caption = #37329#39069'   '
    end
    object Label3: TLabel
      Left = 8
      Top = 60
      Width = 33
      Height = 13
      Caption = #24065#25968'   '
    end
    object Label4: TLabel
      Left = 8
      Top = 84
      Width = 57
      Height = 13
      Caption = #36192#36865#24065#25968'   '
    end
    object Label5: TLabel
      Left = 208
      Top = 8
      Width = 42
      Height = 13
      Caption = #25805#20316#21592'  '
    end
    object Label6: TLabel
      Left = 208
      Top = 41
      Width = 60
      Height = 13
      Caption = #26159#21542#21551#29992'    '
    end
    object Label7: TLabel
      Left = 208
      Top = 88
      Width = 33
      Height = 13
      Caption = #22791#27880'   '
    end
    object Bit_Update_Package: TBitBtn
      Left = 528
      Top = 48
      Width = 89
      Height = 33
      Caption = #20462#25913
      Enabled = False
      TabOrder = 0
      OnClick = Bit_Update_PackageClick
    end
    object Bit__Del_TPackage: TBitBtn
      Left = 632
      Top = 48
      Width = 81
      Height = 33
      Caption = #21024#38500
      TabOrder = 1
      OnClick = Bit__Del_TPackageClick
    end
    object BitBtn8: TBitBtn
      Left = 736
      Top = 48
      Width = 81
      Height = 33
      Caption = #20851#38381
      TabOrder = 2
      OnClick = BitBtn8Click
    end
    object BitBtn1: TBitBtn
      Left = 424
      Top = 48
      Width = 89
      Height = 33
      Caption = #28155#21152
      TabOrder = 3
      OnClick = BitBtn1Click
    end
    object Edit_PackNo: TEdit
      Left = 72
      Top = 8
      Width = 121
      Height = 21
      TabOrder = 4
    end
    object Edit_CostMoney: TEdit
      Left = 72
      Top = 35
      Width = 121
      Height = 21
      TabOrder = 5
      OnKeyPress = Edit_CostMoneyKeyPress
    end
    object Edit_CoinCount: TEdit
      Left = 72
      Top = 60
      Width = 121
      Height = 21
      TabOrder = 6
      OnKeyPress = Edit_CoinCountKeyPress
    end
    object Edit_GivePer: TEdit
      Left = 72
      Top = 84
      Width = 121
      Height = 21
      TabOrder = 7
      OnKeyPress = Edit_GivePerKeyPress
    end
    object Edit_cUserNo: TEdit
      Left = 272
      Top = 8
      Width = 121
      Height = 21
      Enabled = False
      TabOrder = 8
    end
    object IfStart: TRadioGroup
      Left = 272
      Top = 26
      Width = 121
      Height = 32
      Columns = 2
      ItemIndex = 0
      Items.Strings = (
        #26159
        #21542)
      TabOrder = 9
    end
    object Memo_Remark: TMemo
      Left = 272
      Top = 64
      Width = 121
      Height = 49
      Lines.Strings = (
        '')
      TabOrder = 10
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 121
    Width = 837
    Height = 345
    Align = alClient
    Caption = 'Panel1'
    TabOrder = 1
    object DBGrid_Package: TDBGrid
      Left = 1
      Top = 1
      Width = 835
      Height = 343
      Align = alClient
      DataSource = DataSource_Package
      Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit]
      TabOrder = 0
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -11
      TitleFont.Name = 'MS Sans Serif'
      TitleFont.Style = []
      OnDblClick = DBGrid_PackageDblClick
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
          Alignment = taCenter
          Expanded = False
          FieldName = 'PackNo'
          Title.Alignment = taCenter
          Title.Caption = #22871#39184#32534#21495
          Width = 80
          Visible = True
        end
        item
          Alignment = taCenter
          Expanded = False
          FieldName = 'CostMoney'
          Title.Alignment = taCenter
          Title.Caption = #37329#39069
          Width = 80
          Visible = True
        end
        item
          Alignment = taCenter
          Expanded = False
          FieldName = 'CoinCount'
          Title.Alignment = taCenter
          Title.Caption = #24065#25968
          Width = 100
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'GivePer'
          Title.Caption = #36192#36865#24065#25968
          Width = 120
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'cUserNo'
          Title.Caption = #25805#20316#21592
          Width = 60
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'GetTime'
          Title.Caption = #26356#26032#26102#38388
          Width = 120
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'IfStart'
          Title.Caption = #26159#21542#21551#29992
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'Remark'
          Title.Caption = #22791#27880
          Width = 120
          Visible = True
        end>
    end
  end
  object DataSource_Package: TDataSource
    DataSet = ADOQuery_Package
    Left = 537
    Top = 276
  end
  object ADOQuery_Package: TADOQuery
    Parameters = <>
    Left = 577
    Top = 276
  end
end
