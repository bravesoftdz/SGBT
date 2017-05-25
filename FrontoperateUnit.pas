unit FrontoperateUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, ComCtrls, Buttons;

type
  Tfrm_frontoperate = class(TForm)
    pnlTitle: TPanel;
    pgcFrontoperate: TPageControl;
    tbsConfig: TTabSheet;
    tbsLowLevel: TTabSheet;
    tbsPassDown: TTabSheet;
    gbPasswordDown: TGroupBox;
    lblPDSector0: TLabel;
    lblPDSector1: TLabel;
    lblPDSector2: TLabel;
    lblPDSector3: TLabel;
    lblPDSector4: TLabel;
    lblPDSector5: TLabel;
    lblPDSector6: TLabel;
    lblPDSector7: TLabel;
    lblPDSector8: TLabel;
    lblPDSector9: TLabel;
    lblPDSectorA: TLabel;
    lblPDSectorB: TLabel;
    lblPDSectorC: TLabel;
    lblPDSectorD: TLabel;
    lblPDSectorE: TLabel;
    lblPDSectorF: TLabel;
    edtSecPwd0: TEdit;
    edtSecPwd1: TEdit;
    edtSecPwd2: TEdit;
    edtSecPwd3: TEdit;
    edtSecPwd4: TEdit;
    edtSecPwd5: TEdit;
    edtSecPwd6: TEdit;
    edtSecPwd7: TEdit;
    edtSecPwd8: TEdit;
    edtSecPwd9: TEdit;
    edtSecPwd10: TEdit;
    edtSecPwd11: TEdit;
    edtSecPwd12: TEdit;
    edtSecPwd13: TEdit;
    edtSecPwd14: TEdit;
    edtSecPwd15: TEdit;
    rgSePwdOrg: TRadioGroup;
    btnPwdDwn: TButton;
    tbsDataOper: TTabSheet;
    gbRWSector: TGroupBox;
    lblBlock0: TLabel;
    lblBlock1: TLabel;
    lblBlock2: TLabel;
    lblBlock3: TLabel;
    edtBlock0: TEdit;
    edtBlock1: TEdit;
    edtBlock2: TEdit;
    edtBlock3: TEdit;
    gbRWSeSec: TGroupBox;
    cbRWSec: TComboBox;
    btnBlockRd: TButton;
    btnBlockWt: TButton;
    tbsBlockOper: TTabSheet;
    gbReOrWt: TGroupBox;
    lblCurValue: TLabel;
    lblOpeValue: TLabel;
    edtCurValue: TEdit;
    edtOpeValue: TEdit;
    gbBkSec: TGroupBox;
    cbBSecSe: TComboBox;
    gbBlokSe: TGroupBox;
    cbBSe: TComboBox;
    btnBlockInit: TButton;
    btnBlockRead: TButton;
    btnBlockAdd: TButton;
    btnBlockSub: TButton;
    tbsPassCh: TTabSheet;
    gbEntryPwd: TGroupBox;
    lblPwdA: TLabel;
    lblPwdB: TLabel;
    edtPwdA: TEdit;
    edtPwdB: TEdit;
    gbConBit: TGroupBox;
    lblConBit0: TLabel;
    lblConBit1: TLabel;
    lblConBit2: TLabel;
    lblConBit3: TLabel;
    edtConBit0: TEdit;
    edtConBit1: TEdit;
    edtConBit2: TEdit;
    edtConBit3: TEdit;
    gbChPwdSec: TGroupBox;
    cbChPwdSec: TComboBox;
    btnChPwd: TButton;
    btnChCon: TButton;
    tbsSeRe: TTabSheet;
    gbComSendRec: TGroupBox;
    lblExplain: TLabel;
    memComSeRe: TMemo;
    TabSheet1: TTabSheet;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    GroupBox3: TGroupBox;
    GroupBox4: TGroupBox;
    GroupBox5: TGroupBox;
    Panel1: TPanel;
    Label1: TLabel;
    ComboBox1: TComboBox;
    Label2: TLabel;
    Edit1: TEdit;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    ComboBox2: TComboBox;
    Label10: TLabel;
    ComboBox3: TComboBox;
    Edit5: TEdit;
    Edit6: TEdit;
    Edit7: TEdit;
    Label11: TLabel;
    ComboBox4: TComboBox;
    Label12: TLabel;
    RadioGroup1: TRadioGroup;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    Label13: TLabel;
    Edit8: TEdit;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    BitBtn3: TBitBtn;
    Edit9: TEdit;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frm_frontoperate: Tfrm_frontoperate;

implementation

{$R *.dfm}

end.
