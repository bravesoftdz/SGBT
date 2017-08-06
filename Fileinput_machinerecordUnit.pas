unit Fileinput_machinerecordUnit;

interface            

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, DBGrids, StdCtrls, Buttons, ExtCtrls, ComCtrls, DB, ADODB;

type
  Tfrm_Fileinput_machinerecord = class(TForm)
    pgcMachinerecord: TPageControl;
    tbsConfig: TTabSheet;
    Panel3: TPanel;
    Tab_Gamenameinput: TTabSheet;
    Panel8: TPanel;
    dsPosition: TDataSource;
    ADOQPosition: TADOQuery;
    DataSource_LostvalueMC: TDataSource;
    ADOQuery_LostvalueMC: TADOQuery;
    DBGrid12: TDBGrid;
    Panel2: TPanel;
    btnCardPositionConfirm: TBitBtn;
    btnCardPositionCancel: TBitBtn;
    Image1: TImage;
    Panel5: TPanel;
    btnConfirm: TBitBtn;
    btnCancel: TBitBtn;
    Image2: TImage;
    DBGrid6: TDBGrid;
    grmachine: TGroupBox;
    lbl1: TLabel;
    edtMachineName: TEdit;
    ADOQMachineRecord: TADOQuery;
    dsMachineRecord: TDataSource;
    grpCardPosition: TGroupBox;
    Label1: TLabel;
    cbMachineName: TComboBox;
    lbl2: TLabel;
    cbCardPositionNum: TComboBox;

    procedure btnCardPositionConfirmClick(Sender: TObject);
    procedure btnCardPositionCancelClick(Sender: TObject);
    procedure btnConfirmClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure pgcMachinerecordChange(Sender: TObject);

    procedure saveMachineRecord();
    procedure savePositionRecord();
    procedure InitDataBase;
    procedure initcbMachineName;
    procedure initcbCardPositionNum;
    function getMachineNoByName(machinename:String):String;
    function getMachineNameByNO(machineno:String) :String;
    function checkUniqueMachine(machinename: string): boolean;
    function checkUniqueCardPosition(machinename: string): boolean;


  private
    { Private declarations }
//    procedure Querylevel_name(S1: string);

  public
    { Public declarations }
  end;

var
  frm_Fileinput_machinerecord: Tfrm_Fileinput_machinerecord;

implementation

uses ICFunctionUnit,ICDataModule, ICCommunalVarUnit, ICmain, ICEventTypeUnit, Fileinput_machinerecord_gamenameUnit, Fileinput_gamenameinputUnit,
  Fileinput_menbermatialupdateUnit;
{$R *.dfm}

procedure Tfrm_Fileinput_machinerecord.btnConfirmClick(Sender: TObject);
begin
  if (edtMachineName.Text = '') then
  begin
      ShowMessage('请输入正确的机台名称');
      exit
  end;
  if checkUniqueMachine(Trim(edtMachineName.Text)) = true then
  begin
         ShowMessage('机台已存在,请输入另一个名称');
         exit;
  end;
    saveMachineRecord();
    InitDataBase;
end;


function Tfrm_Fileinput_machinerecord.checkUniqueMachine(machinename: string): boolean;
var
  ADOQ: TADOQuery;
  strSQL :String;
begin
  ADOQ := TADOQuery.Create(Self);
  ADOQ.Connection := DataModule_3F.ADOConnection_Main;

  with ADOQ do begin
    Close;
    SQL.Clear;
    strSQL := 'select 1 from tmachineset where MACHINE_NAME =''' + machinename  + '''';
    ICFunction.loginfo('Exist check  strSQL: ' + strSQL);
    SQL.Add(strSQL);
    Open;
    if (Eof) then
      result := false
    else
      result := true;
  end;
  ADOQ.Close;
  ADOQ.Free;
end;


function Tfrm_Fileinput_machinerecord.checkUniqueCardPosition(machinename: string): boolean;
var
  ADOQ: TADOQuery;
  strSQL :String;
begin
  ADOQ := TADOQuery.Create(Self);
  ADOQ.Connection := DataModule_3F.ADOConnection_Main;

  with ADOQ do begin
    Close;
    SQL.Clear;
    strSQL := 'select 1 from tpositionset where MACHINE_NAME =''' + machinename  + '''';
    ICFunction.loginfo('Exist check  strSQL: ' + strSQL);
    SQL.Add(strSQL);
    Open;
    if (Eof) then
      result := false
    else
      result := true;
  end;
  ADOQ.Close;
  ADOQ.Free;
end;



procedure Tfrm_Fileinput_machinerecord.saveMachineRecord();
var
  strSQL,machinename,operatetime,operatorno: string;

begin
  machinename := trim(edtMachineName.Text);

  ShortDateFormat := 'yyyy-MM-dd'; //指定格式即可
  DateSeparator := '-';
  operatetime := FormatDateTime('yyyy-MM-dd HH:mm:ss', now);
  operatorno := '001';

  with ADOQMachineRecord do begin
    Connection := DataModule_3F.ADOConnection_Main;
    Active := false;
    SQL.Clear;
    strSQL := 'select * from tmachineset order by operate_time desc'; //为什么要查全部？
    ICFunction.loginfo('strSQL :' + strSQL);
    SQL.Add(strSQL);
    Active := True;
    Append;
    FieldByName('MACHINE_NAME').AsString := machinename; //机台名    
    FieldByName('OPERATE_TIME').AsString := operatetime; //用户名
    FieldByName('OPERATOR_NO').AsString := operatorno; //充值操作

    post;
  end; 

end;

             


procedure Tfrm_Fileinput_machinerecord.savePositionRecord();
var
  strSQL,machineno,machinename,operatetime,operatorno: string;
  i : Integer;
begin
  machinename := trim(cbMachineName.Text);
  machineno :=  getMachineNoByName(machinename);


  ShortDateFormat := 'yyyy-MM-dd'; //指定格式即可
  DateSeparator := '-';
  operatetime := FormatDateTime('yyyy-MM-dd HH:mm:ss', now);
  operatorno := '001';

  with ADOQMachineRecord do begin
    Connection := DataModule_3F.ADOConnection_Main;
    Active := false;
    SQL.Clear;
    strSQL := 'select * from tpositionset where MACHINE_NAME =''' + machinename  + '''';
    ICFunction.loginfo('strSQL :' + strSQL);
    SQL.Add(strSQL);
    Active := True;
    for i :=1 to strToInt(cbCardPositionNum.text) do
    begin
      ICFunction.loginfo('machineno+IntTostr(i):' + machineno+IntTostr(i));
      Append;
      FieldByName('MACHINE_NO').AsString := machineno; //机台号
      FieldByName('MACHINE_NAME').AsString := machinename; //机台名
      FieldByName('CARD_POSITION_NO').AsString := machinename+'_'+IntTostr(i); //卡位号
      FieldByName('OPERATE_TIME').AsString := operatetime; //操作时间
      FieldByName('OPERATOR_NO').AsString := operatorno; //操作员
      post;
    end;

  end; 

end;


procedure Tfrm_Fileinput_machinerecord.InitDataBase;
var
  strSQL: string;
begin
      //机台资料

  with ADOQMachineRecord do begin
    Connection := DataModule_3F.ADOConnection_Main;
    Active := false;
    SQL.Clear;
    strSQL := 'select * from tmachineset order by operate_time desc ';
    ICFunction.loginfo('strSQL: ' + strSQL);
    SQL.Add(strSQL);
    Active := True;
  end;

   with ADOQPosition do begin
    Connection := DataModule_3F.ADOConnection_Main;
    Active := false;
    SQL.Clear;
    strSQL := 'select * from tpositionset order by operate_time desc ,CARD_POSITION_NO asc';
    ICFunction.loginfo('strSQL: ' + strSQL);
    SQL.Add(strSQL);
    Active := True;
  end;
 

end;


function Tfrm_Fileinput_machinerecord.getMachineNoByName(machinename:String) :String;
var
  ADOQTemp: TADOQuery;
  strSQL: string;
  MACHINE_NO:Integer;
begin
  MACHINE_NO := 0;
  ADOQTemp := TADOQuery.Create(nil);
  strSQL := 'select ID from tmachineset where MACHINE_NAME =''' + machinename  + '''';
  ICFunction.loginfo('strSQL: ' + strSQL);
  with ADOQTemp do
  begin
    Connection := DataModule_3F.ADOConnection_Main;
    SQL.Clear;
    SQL.Add(strSQL);
    Active := True;
    if (not eof) then
        begin
          MACHINE_NO := ADOQTemp.Fields[0].AsInteger;;
          Close;
        end;
        FreeAndNil(ADOQTemp);
  end;
      result := intTostr(MACHINE_NO);

end;


function Tfrm_Fileinput_machinerecord.getMachineNameByNO(machineno:String) :String;
var
  ADOQTemp: TADOQuery;
  strSQL: string;
  machineName:string;
begin
  machineName := '';
  ADOQTemp := TADOQuery.Create(nil);
  strSQL := 'select machinename from tmachineset where ID =''' + machineno  + '''';
  ICFunction.loginfo('strSQL: ' + strSQL);
  with ADOQTemp do
  begin
    Connection := DataModule_3F.ADOConnection_Main;
    SQL.Clear;
    SQL.Add(strSQL);
    Active := True;
    if (not eof) then
        begin
          machineName := ADOQTemp.Fields[0].AsString;;
          Close;
        end;
        FreeAndNil(ADOQTemp);
  end;
      result := machineName;

end;



//初始化游戏名称下来框
procedure Tfrm_Fileinput_machinerecord.initcbMachineName;
var
  ADOQTemp: TADOQuery;
  strSQL: string;
begin
  ADOQTemp := TADOQuery.Create(nil);  
  strSQL := 'select MACHINE_NAME from tmachineset order by operate_time Desc ';
  with ADOQTemp do
  begin
    Connection := DataModule_3F.ADOConnection_Main;
    SQL.Clear;
    SQL.Add(strSQL);
    Active := True;
    cbMachineName.Items.Clear;
    while not Eof do
    begin
      cbMachineName.Items.Add(FieldByName('MACHINE_NAME').AsString);
      Next;
    end;
  end;
  FreeAndNil(ADOQTemp);

end;



//卡位个数下拉列表实始化

procedure Tfrm_Fileinput_machinerecord.initcbCardPositionNum;
begin
  cbCardPositionNum.Items.clear();
  cbCardPositionNum.Items.Add('1');
  cbCardPositionNum.Items.Add('2');
  cbCardPositionNum.Items.Add('3');
  cbCardPositionNum.Items.Add('4');
  cbCardPositionNum.Items.Add('5');
  cbCardPositionNum.Items.Add('6');
  cbCardPositionNum.Items.Add('7');
  cbCardPositionNum.Items.Add('8');
  cbCardPositionNum.Items.Add('9');
  cbCardPositionNum.Items.Add('10');
  cbCardPositionNum.Items.Add('11');
  cbCardPositionNum.Items.Add('12');
end;


procedure Tfrm_Fileinput_machinerecord.btnCardPositionConfirmClick(Sender: TObject);
begin
  if (cbMachineName.Text = '请选择机台') then
  begin
      ShowMessage('请选择一个机台');
      exit
  end;
  if checkUniqueCardPosition(Trim(cbMachineName.Text)) = true then
  begin
         ShowMessage('机台已存在,请选择另一个机台');
         exit;
  end;
    savePositionRecord();
    InitDataBase();

end;


//删除机台
procedure Tfrm_Fileinput_machinerecord.btnCancelClick(Sender: TObject);
var
  strTemp: string;
  strGameno: string;
  strsql: string;

begin
  strTemp := ADOQMachineRecord.FieldByName('MACHINE_NAME').AsString;
  strGameno := ADOQMachineRecord.FieldByName('ID').AsString;

  if (MessageDlg('确实要删除' + strTemp + ' 机台及机台下的所有卡头位吗?', mtConfirmation, [mbYes, mbNo], 0) = mrYes) then

  begin
    strsql := 'delete from tpositionset where MACHINE_NO = ' + strGameno;
    DataModule_3F.executesql(strsql);
    ICFunction.loginfo('strSQL :' + strSQL);

    strsql := 'delete from T_BIND_CARDHEADID where MACHINE_NO = ' + strGameno;
    DataModule_3F.executesql(strsql);
    ICFunction.loginfo('strSQL :' + strSQL);    


    strsql := 'delete from tmachineset where ID = ' + strGameno;
    DataModule_3F.executesql(strsql);
    ICFunction.loginfo('strSQL :' + strSQL);
        
    InitDataBase;
  end;

end;


procedure Tfrm_Fileinput_machinerecord.FormShow(Sender: TObject);
begin
//  BitBtn11.Visible := false;
//  BitBtn3.Visible := false;

  InitDataBase;
  initcbMachineName();
  initcbCardPositionNum();

end;

procedure Tfrm_Fileinput_machinerecord.pgcMachinerecordChange(
  Sender: TObject);
begin
  InitDataBase();
  initcbMachineName();
  initcbCardPositionNum();  

end;





//删除机台位

procedure Tfrm_Fileinput_machinerecord.btnCardPositionCancelClick(Sender: TObject);
var strgameno: string;
var strsql: string;
begin
  strGameno := ADOQPosition.FieldByName('CARD_POSITION_NO').AsString;
  if (MessageDlg('确实要删除' + strGameno + ' 卡头位吗?', mtConfirmation, [mbYes, mbNo], 0) = mrYes) then
  begin
    strsql := 'delete from tpositionset where CARD_POSITION_NO = ''' + strGameno + '''';
    DataModule_3F.executesql(strsql);
    ICFunction.loginfo('strSQL :' + strSQL);

    strsql := 'delete from T_BIND_CARDHEADID where POSITION_NO = ''' + strGameno + '''';
    DataModule_3F.executesql(strsql);
    ICFunction.loginfo('strSQL :' + strSQL);

    InitDataBase;
  end;


end;

end.
