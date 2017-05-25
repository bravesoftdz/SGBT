unit IC_SetParameter_operatemaryUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, Spin, Mask, Buttons, ComCtrls, Grids,
  DBGrids;

type
  Tfrm_IC_SetParameter_operatemary = class(TForm)
    pgcMenberfor: TPageControl;
    tbsConfig: TTabSheet;
    Panel3: TPanel;
    Panel2: TPanel;
    tbsLowLevel: TTabSheet;
    Panel1: TPanel;
    Panel4: TPanel;
    Panel7: TPanel;
    Panel8: TPanel;
    Label4: TLabel;
    Label5: TLabel;
    DateTimePicker1: TDateTimePicker;
    DateTimePicker2: TDateTimePicker;
    DateTimePicker3: TDateTimePicker;
    DateTimePicker4: TDateTimePicker;
    Panel9: TPanel;
    BitBtn2: TBitBtn;
    BitBtn3: TBitBtn;
    Label6: TLabel;
    ComboBox1: TComboBox;
    Panel5: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    DateTimePicker5: TDateTimePicker;
    DateTimePicker6: TDateTimePicker;
    DateTimePicker7: TDateTimePicker;
    DateTimePicker8: TDateTimePicker;
    Panel6: TPanel;
    BitBtn4: TBitBtn;
    BitBtn5: TBitBtn;
    DBGrid1: TDBGrid;
    DBGrid2: TDBGrid;
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn4Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frm_IC_SetParameter_operatemary: Tfrm_IC_SetParameter_operatemary;

implementation

{$R *.dfm}

procedure Tfrm_IC_SetParameter_operatemary.BitBtn2Click(Sender: TObject);
begin
  Close;
end;

procedure Tfrm_IC_SetParameter_operatemary.BitBtn4Click(Sender: TObject);
begin
  Close;
end;

end.
