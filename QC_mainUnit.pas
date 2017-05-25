unit QC_mainUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, Buttons;

type
  TFrm_QC_Main = class(TForm)
    Panel2: TPanel;
    Panel3: TPanel;
    Panel8: TPanel;
    BitBtn_Frontoperate: TBitBtn;
    Panel4: TPanel;
    Panel9: TPanel;
    BitBtn_Aculate: TBitBtn;
    Panel5: TPanel;
    Panel10: TPanel;
    BitBtn_TestIC: TBitBtn;
    Panel6: TPanel;
    Panel11: TPanel;
    BitBtn_Behindoperate: TBitBtn;
    Panel7: TPanel;
    Panel12: TPanel;
    BitBtn_SetParameter: TBitBtn;
    Panel13: TPanel;
    Panel15: TPanel;
    BitBtn_Fileinput: TBitBtn;
    Panel17: TPanel;
    Panel16: TPanel;
    Panel1: TPanel;
    Image1: TImage;
    Label_Title3: TLabel;
    Label_Title2: TLabel;
    Label_Title1: TLabel;
    Panel18: TPanel;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    M_Frontoperate_incvalue: TBitBtn;
    M_Frontoperate_pwdchange: TBitBtn;
    M_Frontoperate_lostuser: TBitBtn;
    M_Frontoperate_sale: TBitBtn;
    M_Frontoperate_userback: TBitBtn;
    M_Frontoperate_lostvalue: TBitBtn;
    M_Frontoperate_renewuser: TBitBtn;
    M_Frontoperate_newuser: TBitBtn;
    TabSheet2: TTabSheet;
    M_Behindoperate_setpara: TBitBtn;
    M_Behindoperate_pwdchange: TBitBtn;
    M_Behindoperate_softset: TBitBtn;
    M_Behindoperate_softexit: TBitBtn;
    TabSheet3: TTabSheet;
    M_SetParameter_operatemary: TBitBtn;
    M_SetParameter_loginpwdchange: TBitBtn;
    M_SetParameter_cardsalepwdchange: TBitBtn;
    M_SetParameter_machineparaset: TBitBtn;
    M_SetParameter_levelchange: TBitBtn;
    M_SetParameter_softparaset: TBitBtn;
    M_SetParameter_datamentain: TBitBtn;
    M_SetParameter_syspwdmanage: TBitBtn;
    TabSheet4: TTabSheet;
    M_Fileinput_menberfor: TBitBtn;
    M_Fileinput_machinerecord: TBitBtn;
    M_Fileinput_machinerstate: TBitBtn;
    M_Fileinput_prezentquery: TBitBtn;
    M_Fileinput_prezentmatial: TBitBtn;
    M_Fileinput_cardsale: TBitBtn;
    M_Fileinput_menbermatial: TBitBtn;
    TabSheet5: TTabSheet;
    BitBtn30: TBitBtn;
    BitBtn31: TBitBtn;
    BitBtn32: TBitBtn;
    BitBtn33: TBitBtn;
    BitBtn34: TBitBtn;
    TabSheet6: TTabSheet;
    ICtest: TBitBtn;
    procedure M_Frontoperate_newuserClick(Sender: TObject);
    procedure Panel18Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Frm_QC_Main: TFrm_QC_Main;

implementation

uses QC_AE_LineBarscanUnit;

{$R *.dfm}

procedure TFrm_QC_Main.M_Frontoperate_newuserClick(Sender: TObject);
begin
frm_QC_AE_LineBarscan.show;
end;

procedure TFrm_QC_Main.Panel18Click(Sender: TObject);
begin
 close;
end;

end.
