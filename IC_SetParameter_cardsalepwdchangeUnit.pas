unit IC_SetParameter_cardsalepwdchangeUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls;

type
  Tfrm_IC_SetParameter_cardsalepwdchange = class(TForm)
    Panel1: TPanel;
    Panel3: TPanel;
    Label2: TLabel;
    Edit2: TEdit;
    Panel2: TPanel;
    BitBtn2: TBitBtn;
    BitBtn3: TBitBtn;
    Label1: TLabel;
    procedure BitBtn3Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frm_IC_SetParameter_cardsalepwdchange: Tfrm_IC_SetParameter_cardsalepwdchange;

implementation

{$R *.dfm}

procedure Tfrm_IC_SetParameter_cardsalepwdchange.BitBtn3Click(
  Sender: TObject);
begin
  Close;
end;

end.
