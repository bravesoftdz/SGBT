object frm_PS_MCtest: Tfrm_PS_MCtest
  Left = 192
  Top = 114
  Width = 870
  Height = 500
  Caption = 'frm_PS_MCtest'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object GroupBox2: TGroupBox
    Left = 120
    Top = 24
    Width = 241
    Height = 161
    Caption = 'PLC'#20889#20837#27979#35797
    TabOrder = 0
    object Label1: TLabel
      Left = 24
      Top = 44
      Width = 48
      Height = 13
      Caption = #22320#22336#21306#65306
    end
    object Label2: TLabel
      Left = 24
      Top = 76
      Width = 36
      Height = 13
      Caption = #20869#23481#65306
    end
    object Btn_PLCWrite: TButton
      Left = 120
      Top = 104
      Width = 75
      Height = 25
      Caption = #20889#20837
      TabOrder = 0
    end
    object Edit_WriteAddress: TEdit
      Left = 96
      Top = 40
      Width = 121
      Height = 21
      TabOrder = 1
      Text = 'Edit_WriteAddress'
    end
    object Edit_WriteValue: TEdit
      Left = 96
      Top = 72
      Width = 121
      Height = 21
      TabOrder = 2
      Text = 'Edit_WriteValue'
    end
  end
  object GroupBox1: TGroupBox
    Left = 536
    Top = 24
    Width = 241
    Height = 153
    Caption = 'PLC'#35835#20986#27979#35797
    TabOrder = 1
    object Label3: TLabel
      Left = 24
      Top = 44
      Width = 48
      Height = 13
      Caption = #22320#22336#21306#65306
    end
    object Label4: TLabel
      Left = 24
      Top = 76
      Width = 36
      Height = 13
      Caption = #20869#23481#65306
    end
    object btn_PLCRead: TButton
      Left = 128
      Top = 104
      Width = 75
      Height = 25
      Caption = #35835#21462
      TabOrder = 0
    end
    object Edit_ReadAddress: TEdit
      Left = 96
      Top = 40
      Width = 121
      Height = 21
      TabOrder = 1
      Text = 'Edit1'
    end
    object Edit_ReadValue: TEdit
      Left = 96
      Top = 72
      Width = 121
      Height = 21
      TabOrder = 2
      Text = 'Edit2'
    end
  end
  object GroupBox3: TGroupBox
    Left = 16
    Top = 224
    Width = 403
    Height = 225
    Caption = 'DI'#21345#20889#21345#35774#22791#27979#35797
    TabOrder = 2
    object Label5: TLabel
      Left = 185
      Top = 4
      Width = 48
      Height = 13
      Caption = #22320#22336#21306#65306
      Visible = False
    end
    object Label10: TLabel
      Left = 16
      Top = 76
      Width = 36
      Height = 13
      Caption = #20869#23481#65306
    end
    object Label6: TLabel
      Left = 217
      Top = 42
      Width = 36
      Height = 13
      Caption = #20889#20869#23481
      WordWrap = True
    end
    object Label11: TLabel
      Left = 20
      Top = 42
      Width = 36
      Height = 13
      Caption = #35835#38271#24230
    end
    object Edit_DIWriteArea: TEdit
      Left = 257
      Top = 0
      Width = 121
      Height = 21
      TabOrder = 0
      Text = 'Edit_WriteAddress'
      Visible = False
    end
    object Edit_DIWriteV: TEdit
      Left = 274
      Top = 40
      Width = 121
      Height = 21
      TabOrder = 1
      Text = 'Edit_DIWriteV'
    end
    object Memo_DIWriteV: TMemo
      Left = 16
      Top = 104
      Width = 370
      Height = 113
      Lines.Strings = (
        'Memo_DIReadV')
      ScrollBars = ssBoth
      TabOrder = 2
    end
    object Btn_DIReadR: TButton
      Left = 312
      Top = 72
      Width = 75
      Height = 25
      Caption = #35835#21462
      TabOrder = 3
    end
    object btn_DIWrite: TButton
      Left = 232
      Top = 72
      Width = 75
      Height = 25
      Caption = #20889#20837
      TabOrder = 4
    end
    object Edit_DIWriteLength: TEdit
      Left = 77
      Top = 40
      Width = 121
      Height = 21
      TabOrder = 5
    end
  end
  object GroupBox4: TGroupBox
    Left = 472
    Top = 224
    Width = 385
    Height = 225
    Caption = 'DI'#28165#21345#35774#22791#27979#35797
    TabOrder = 3
    object Label7: TLabel
      Left = 168
      Top = 4
      Width = 48
      Height = 13
      Caption = #22320#22336#21306#65306
      Visible = False
    end
    object Label8: TLabel
      Left = 16
      Top = 76
      Width = 36
      Height = 13
      Caption = #20869#23481#65306
    end
    object Label9: TLabel
      Left = 204
      Top = 43
      Width = 36
      Height = 13
      Caption = #20889#20869#23481
      WordWrap = True
    end
    object Label12: TLabel
      Left = 7
      Top = 43
      Width = 36
      Height = 13
      Caption = #35835#38271#24230
    end
    object btn_DIRead: TButton
      Left = 296
      Top = 72
      Width = 75
      Height = 25
      Caption = #35835#21462
      TabOrder = 0
    end
    object Edit_DIReadArea: TEdit
      Left = 240
      Top = 0
      Width = 121
      Height = 21
      TabOrder = 1
      Text = 'Edit1'
      Visible = False
    end
    object Memo_DIReadV: TMemo
      Left = 16
      Top = 104
      Width = 353
      Height = 113
      Lines.Strings = (
        'Memo_DIReadV')
      ScrollBars = ssBoth
      TabOrder = 2
    end
    object Edit_DIReadV: TEdit
      Left = 258
      Top = 40
      Width = 121
      Height = 21
      TabOrder = 3
      Text = 'Edit_DIWriteV'
    end
    object Btn_DIReadW: TButton
      Left = 215
      Top = 72
      Width = 75
      Height = 25
      Caption = #20889#20837
      TabOrder = 4
    end
    object Edit_DIReadLength: TEdit
      Left = 63
      Top = 40
      Width = 121
      Height = 21
      TabOrder = 5
    end
  end
end
