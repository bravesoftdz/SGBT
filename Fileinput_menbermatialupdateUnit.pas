unit Fileinput_menbermatialupdateUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, Buttons, DB, ADODB;

type
  Tfrm_Fileinput_menbermatialupdate = class(TForm)
    Panel1: TPanel;
    GroupBox2: TGroupBox;
    GroupBox5: TGroupBox;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Edit01: TEdit;
    Edit02: TEdit;
    Comb_Month: TComboBox;
    Comb_Day: TComboBox;
    Edit04: TEdit;
    Comb_menberlevel: TComboBox;
    Edit07: TEdit;
    rgSex: TRadioGroup;
    Label1: TLabel;
    Label2: TLabel;
    Edit05: TEdit;
    Edit06: TEdit;
    Label6: TLabel;
    Label9: TLabel;
    Edit08: TEdit;
    Edit09: TEdit;
    Label14: TLabel;
    Edit10: TEdit;
    Label15: TLabel;
    Edit03: TEdit;
    Label16: TLabel;
    rgIable: TRadioGroup;
    CheckBox1: TCheckBox;
    Edit12: TEdit;
    Panel2: TPanel;
    Bit_Add: TBitBtn;
    Bit_Close: TBitBtn;
    Edit11: TEdit;
    DataSource_updatemenber: TDataSource;
    ADOQuery_updatemenber: TADOQuery;
    procedure FormCreate(Sender: TObject);
    procedure Bit_AddClick(Sender: TObject);
    procedure Bit_CloseClick(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
  private
    { Private declarations }
    procedure InitLevel; //初始化等级列表
    function Querylevel_LevNO(S1: string): string; //查询等级代码
  public
    { Public declarations }
  end;

var
  frm_Fileinput_menbermatialupdate: Tfrm_Fileinput_menbermatialupdate;

implementation

uses ICDataModule, Fileinput_menbermatialUnit;

{$R *.dfm}

//初始化操作员列表

procedure Tfrm_Fileinput_menbermatialupdate.InitLevel;
var
  ADOQTemp: TADOQuery;
  strSQL: string;
  nameStr: string;
  i: integer;
begin

  ADOQTemp := TADOQuery.Create(nil);
  strSQL := 'select distinct [LevName] from [TLevel]'; //考虑追加同名的处理
  with ADOQTemp do
  begin
    Connection := DataModule_3F.ADOConnection_Main;
    SQL.Clear;
    SQL.Add(strSQL);
    Active := True;
    Comb_menberlevel.Items.Clear;
    while not Eof do
    begin
      Comb_menberlevel.Items.Add(FieldByName('LevName').AsString);
      Next;
    end;
  end;
  FreeAndNil(ADOQTemp);

end;



procedure Tfrm_Fileinput_menbermatialupdate.FormCreate(Sender: TObject);
begin
  InitLevel;
end;

procedure Tfrm_Fileinput_menbermatialupdate.Bit_AddClick(Sender: TObject);
var
  strLevNo: string;
begin

  strLevNo := 'OK';
  if CheckBox1.Checked then
  begin
    strLevNo := 'NG';
    strLevNo := Querylevel_LevNO(TrimRight(Comb_menberlevel.text)); //查询等级代码
  end;

  if strLevNo <> 'NG' then
  begin

    with frm_Fileinput_menbermatial.ADOQuery_newmenber do
    begin
      Edit;
      FieldByName('MemCardNo').AsString := Edit01.Text;
      FieldByName('MemberName').AsString := Edit02.Text;
      FieldByName('Mobile').AsString := Edit03.Text;
      FieldByName('InfoKey').AsString := Edit04.Text;
      FieldByName('cUserNo').AsString := Edit05.Text;

      FieldByName('Birthday').AsString := Comb_Month.Text + '-' + Comb_Day.Text;
      if rgSex.ItemIndex = 1 then
        FieldByName('Sex').AsBoolean := true
      else
        FieldByName('Sex').AsBoolean := false;

      if rgIable.ItemIndex = 1 then
        FieldByName('IsAble').AsString := '4';

      if CheckBox1.Checked then //选择了人工变更时才需要更新
        FieldByName('LevNum').AsString := strLevNo; //查询等级代码

      try
        Post;
      except
        on e: Exception do ShowMessage(e.Message);
      end;
    end;

    close;
  end;

end;


 //查询等级代码

function Tfrm_Fileinput_menbermatialupdate.Querylevel_LevNO(S1: string): string;
var
  strSQL: string;
  temp: string;
  temp_levelno: string;
begin
  //temp:='普通会员';
  with ADOQuery_updatemenber do begin
    Connection := DataModule_3F.ADOConnection_Main;
    Active := false;
    SQL.Clear;
    strSQL := 'select LevNo from [TLevel] where  LevName=''' + S1 + '''';
    SQL.Add(strSQL);
    Open;
    if (RecordCount > 0) then
      temp_levelno := ADOQuery_updatemenber.Fields[0].AsString;
    Close;
  end;
  result := temp_levelno;

end;

procedure Tfrm_Fileinput_menbermatialupdate.Bit_CloseClick(
  Sender: TObject);
begin
  close;
end;

procedure Tfrm_Fileinput_menbermatialupdate.BitBtn1Click(Sender: TObject);

begin
  Edit12.Text := Querylevel_LevNO(Comb_menberlevel.Text);

end;

end.
