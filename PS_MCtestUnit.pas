unit PS_MCtestUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  Tfrm_PS_MCtest = class(TForm)
    GroupBox2: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Btn_PLCWrite: TButton;
    Edit_WriteAddress: TEdit;
    Edit_WriteValue: TEdit;
    GroupBox1: TGroupBox;
    Label3: TLabel;
    Label4: TLabel;
    btn_PLCRead: TButton;
    Edit_ReadAddress: TEdit;
    Edit_ReadValue: TEdit;
    GroupBox3: TGroupBox;
    Label5: TLabel;
    Label10: TLabel;
    Label6: TLabel;
    Label11: TLabel;
    Edit_DIWriteArea: TEdit;
    Edit_DIWriteV: TEdit;
    Memo_DIWriteV: TMemo;
    Btn_DIReadR: TButton;
    btn_DIWrite: TButton;
    Edit_DIWriteLength: TEdit;
    GroupBox4: TGroupBox;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label12: TLabel;
    btn_DIRead: TButton;
    Edit_DIReadArea: TEdit;
    Memo_DIReadV: TMemo;
    Edit_DIReadV: TEdit;
    Btn_DIReadW: TButton;
    Edit_DIReadLength: TEdit;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frm_PS_MCtest: Tfrm_PS_MCtest;

implementation

{$R *.dfm}

end.
