unit Fileinput_machinerecord_gamenameUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Buttons, DB, ADODB;

type
  Tfrm_Fileinput_machinerecord_gamename = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    Label1: TLabel;
    Edit_GameNo: TEdit;
    Label3: TLabel;
    RdA: TRadioGroup;
    Label4: TLabel;
    RdB: TRadioGroup;
    RdC: TRadioGroup;
    RdE: TRadioGroup;
    RdF: TRadioGroup;
    RdG: TRadioGroup;
    Redit2: TEdit;
    Redit3: TEdit;
    Redit4: TEdit;
    MacType: TRadioGroup;
    Remark: TMemo;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    RdD: TRadioGroup;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Redit1: TComboBox;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    Label19: TLabel;
    Label20: TLabel;
    Label21: TLabel;
    Label22: TLabel;
    Label23: TLabel;
    Label24: TLabel;
    Label25: TLabel;
    Label26: TLabel;
    Label27: TLabel;
    Label28: TLabel;
    Edt1: TEdit;
    Edt2: TEdit;
    Edt3: TEdit;
    Edt4: TEdit;
    Edt5: TEdit;
    Edt6: TEdit;
    Edt7: TEdit;
    Edt8: TEdit;
    Edt9: TEdit;
    Label29: TLabel;
    Label30: TLabel;
    Edt10: TEdit;
    Edt11: TEdit;
    Edt14: TEdit;
    Edt13: TEdit;
    Edt12: TEdit;
    Bit_Save: TBitBtn;
    BitBtn12: TBitBtn;
    Edit_GameName: TEdit;
//    procedure FormCreate(Sender: TObject);
    procedure BitBtn12Click(Sender: TObject);
    procedure Bit_SaveClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    procedure QueryMax_GameNo;
    procedure Add_record;
  public
    { Public declarations }
  end;

var
  frm_Fileinput_machinerecord_gamename: Tfrm_Fileinput_machinerecord_gamename;

implementation
uses ICDataModule, ICCommunalVarUnit, ICmain, Fileinput_machinerecordUnit;
{$R *.dfm}

//procedure Tfrm_Fileinput_machinerecord_gamename.FormCreate(
//  Sender: TObject);
//begin
//
////
//end;

procedure Tfrm_Fileinput_machinerecord_gamename.BitBtn12Click(
  Sender: TObject);
begin
  close;
end;


//根据最大游戏编号

procedure Tfrm_Fileinput_machinerecord_gamename.QueryMax_GameNo;
var
  ADOQTemp: TADOQuery;
  strSQL: string;
  nameStr: string;
  Str: string;
  i: integer;
begin

  ADOQTemp := TADOQuery.Create(nil);
  strSQL := 'select Count(ID) from [TGameSet]'; //考虑追加同名的处理
  with ADOQTemp do
  begin
    Connection := DataModule_3F.ADOConnection_Main;
    SQL.Clear;
    SQL.Add(strSQL);
    Open;
    if (ADOQTemp.Fields[0].AsInteger > 0) then
    begin
      i := ADOQTemp.Fields[0].AsInteger;

      if (i + 1) < 10 then
      begin
        Edit_GameNo.Text := '00' + IntToStr(i + 1);
      end
      else if ((i + 1) < 99) and ((i + 1) > 9) then
      begin
        Edit_GameNo.Text := '0' + IntToStr(i + 1);
      end
      else
      begin
        Edit_GameNo.Text := IntToStr(i + 1);
      end;
    end
    else
    begin
      Edit_GameNo.Text := '001';
    end;
                           //Close;
  end;
  FreeAndNil(ADOQTemp);

end;



procedure Tfrm_Fileinput_machinerecord_gamename.Add_record;
var
  strinputdatetime, strMemo_instruction, strOperator: string;
  i, leng: integer;
  strRdA, strRdB, strRdC, strRdD: Boolean;
  strGameNo, strComboBox1, strGameName, strRdE, strRdF, strRdG, strRemark: string;
  strRedit1, strRedit2, strRedit3, strRedit4, strMacType, strEdt1, strEdt2, strEdt3, strEdt4, strEdt5: string;
  strEdt6, strEdt7, strEdt8, strEdt9, strEdt10, strEdt11, strEdt12, strEdt13, strEdt14: string;
label ExitSub;
begin

  strGameNo := Edit_GameNo.Text;
   // ComboBox1
  strGameName := Edit_GameName.Text;
  if RdA.ItemIndex = 0 then
    strRdA := true
  else
    strRdA := false;
  if RdB.ItemIndex = 0 then
    strRdB := true
  else
    strRdB := false;

  if RdC.ItemIndex = 0 then
    strRdC := true
  else
    strRdC := false;
  if RdD.ItemIndex = 0 then
    strRdD := true
  else
    strRdD := false;
  if RdE.ItemIndex = 0 then
    strRdE := '1'
  else
    strRdE := '0';

  if RdF.ItemIndex = 0 then
    strRdF := '1'
  else
    strRdF := '0';
  if RdG.ItemIndex = 0 then
    strRdG := '0'
  else if RdG.ItemIndex = 1 then
    strRdG := '1'
  else
    strRdG := '2';

  strRedit1 := Redit1.Text;
  strRedit2 := Redit2.Text;
  strRedit3 := Redit3.Text;
  strRedit4 := Redit4.Text;

  if MacType.ItemIndex = 0 then
    strMacType := 'A'
  else if MacType.ItemIndex = 1 then
    strMacType := 'B'
  else if MacType.ItemIndex = 2 then
    strMacType := 'C'
  else
    strMacType := 'D';

  strEdt1 := Edt1.Text;
  strEdt2 := Edt2.Text;
  strEdt3 := Edt3.Text;
  strEdt4 := Edt4.Text;
  strEdt5 := Edt5.Text;
  strEdt6 := Edt6.Text;
  strEdt7 := Edt7.Text;
  strEdt8 := Edt8.Text;
  strEdt9 := Edt9.Text;
  strEdt10 := Edt10.Text;
  strEdt11 := Edt11.Text;
  strEdt12 := Edt12.Text;
  strEdt13 := Edt13.Text;
  strEdt14 := Edt14.Text;

  strOperator := G_User.UserNO;
  strinputdatetime := DateTimetostr((now())); //录入时间，读取系统时间
  strRemark := Remark.Text;

  if strGameName = '' then
  begin
    ShowMessage('游戏名称不能空');
    exit;
  end
  else
  begin
    with frm_Fileinput_machinerecord.ADOQPosition do
    begin
      if (Locate('GameName', TrimRight(strGameName), [])) then
      begin
        if (MessageDlg('已经存在  ' + strGameName + '  要更新吗？', mtInformation, [mbYes, mbNo], 0) = mrYes) then
          Edit
        else
          exit;

      end
      else
      begin
        Append;
        FieldByName('GameNo').AsString := strGameNo; //
        FieldByName('GameName').AsString := strGameName; //
        FieldByName('cUserNo').AsString := strOperator; //
        FieldByName('GetTime').AsString := strinputdatetime; //
        FieldByName('RdA').AsBoolean := strRdA; //
        FieldByName('RdB').AsBoolean := strRdB; //
        FieldByName('RdC').AsBoolean := strRdC; //
        FieldByName('RdD').AsBoolean := strRdD;
        FieldByName('RdE').AsString := strRdE;
        FieldByName('RdF').AsString := strRdF; //
        FieldByName('RdG').AsString := strRdG; //

        FieldByName('Redit1').AsString := strRedit1; //

        FieldByName('Redit2').AsString := strRedit2;
        FieldByName('Redit3').AsString := strRedit3;
        FieldByName('Redit4').AsString := strRedit4; //
        FieldByName('MacType').AsString := strMacType; //
        FieldByName('Remark').AsString := strRemark; //

        FieldByName('Edt1').AsString := strEdt1;
        FieldByName('Edt2').AsString := strEdt2;
        FieldByName('Edt3').AsString := strEdt3; //
        FieldByName('Edt4').AsString := strEdt4; //
        FieldByName('Edt5').AsString := strEdt5; //

        FieldByName('Edt6').AsString := strEdt6;
        FieldByName('Edt7').AsString := strEdt7;
        FieldByName('Edt8').AsString := strEdt8; //
        FieldByName('Edt9').AsString := strEdt9; //
        FieldByName('Edt10').AsString := strEdt10; //

        FieldByName('Edt11').AsString := strEdt11;
        FieldByName('Edt12').AsString := strEdt12;
        FieldByName('Edt13').AsString := strEdt13; //
        FieldByName('Edt14').AsString := strEdt14; //串口号

        try
          Post;
        except
          on e: Exception do ShowMessage(e.Message);
        end;

      end;
    end;
    Edit_GameName.Text := '';
    close;
  end;

end;

procedure Tfrm_Fileinput_machinerecord_gamename.Bit_SaveClick(
  Sender: TObject);
begin
//  if Edit_Model.Text = 'Update' then
//    Update_record //更新记录
//  else
    Add_record; //新增记录
end;

procedure Tfrm_Fileinput_machinerecord_gamename.FormShow(Sender: TObject);
begin
  QueryMax_GameNo;
end;

end.
