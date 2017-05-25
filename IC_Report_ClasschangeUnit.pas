unit IC_Report_ClasschangeUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, DBGrids, StdCtrls, Buttons, ExtCtrls, ComCtrls, RpDefine,
  RpRender, RpRenderCanvas, RpRenderPrinter, RpRave, RpBase, RpSystem,
  RpRenderPreview, DBGridEhGrouping, GridsEh, DBGridEh, DB, ADODB, RpCon,
  RpConDS, RpConBDE, SPComm;

type
  Tfrm_IC_Report_Classchange = class(TForm)
    RvRenderPrinter1: TRvRenderPrinter;
    RvProject1: TRvProject;
    RvSystem1: TRvSystem;
    RvRenderPreview1: TRvRenderPreview;
    DataSource_Recrod: TDataSource;
    ADOQuery_Recrod: TADOQuery;
    DataSource_QueryRecord: TDataSource;
    ADOQuery_QueryRecord: TADOQuery;
    RvDataSetConnection1: TRvDataSetConnection;
    Panel8: TPanel;
    Panel2: TPanel;
    pgcMachinerecord: TPageControl;
    TabSheet2: TTabSheet;
    Tab_Gamenameinput: TTabSheet;
    Panel3: TPanel;
    Panel6: TPanel;
    Panel7: TPanel;
    DBGridEh3: TDBGridEh;
    Panel1: TPanel;
    Panel5: TPanel;
    Panel4: TPanel;
    Label1: TLabel;
    Label3: TLabel;
    Label2: TLabel;
    Label4: TLabel;
    Combo_Send: TComboBox;
    Panel9: TPanel;
    Panel10: TPanel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Combo_OP: TComboBox;
    ComboBox4: TComboBox;
    Panel12: TPanel;
    BitBtn4: TBitBtn;
    BitBtn6: TBitBtn;
    Edit_Sendmenber: TEdit;
    Edit_Acount: TEdit;
    Label11: TLabel;
    Label10: TLabel;
    Label12: TLabel;
    Edit_Recemenber: TEdit;
    BitBtn7: TBitBtn;
    Edit_ReceFromBoss: TEdit;
    Label13: TLabel;
    Edit_Have: TEdit;
    Label14: TLabel;
    comReader: TComm;
    Edit_ID: TEdit;
    DBGridEh_QueryRecord: TDBGridEh;
    DateTimePicker_Start_Menberinfo: TDateTimePicker;
    Label9: TLabel;
    DateTimePicker_End_Menberinfo: TDateTimePicker;
    TimePicker_End_Menberinfo: TDateTimePicker;
    TimePicker_Start_Menberinfo: TDateTimePicker;
    BitBtn2: TBitBtn;
    BitBtn5: TBitBtn;
    BitBtn1: TBitBtn;
    BitBtn3: TBitBtn;
    Edit1: TEdit;
    procedure BitBtn5Click(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn7Click(Sender: TObject);
    procedure Edit_AcountKeyPress(Sender: TObject; var Key: Char);
    procedure Edit_ReceFromBossKeyPress(Sender: TObject; var Key: Char);
    procedure Edit_HaveKeyPress(Sender: TObject; var Key: Char);
    procedure FormShow(Sender: TObject);
    procedure comReaderReceiveData(Sender: TObject; Buffer: Pointer;
      BufferLength: Word);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn6Click(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure BitBtn4Click(Sender: TObject);
  private
    { Private declarations }
    procedure InitDataBase;
    procedure SaveData_CardID;
    procedure InitCombo_OP;
    procedure CheckCMD();
    procedure ClearText;
    function Query_UserNo(StrUserNo: string): string;
  public
    { Public declarations }
  end;

var
  frm_IC_Report_Classchange: Tfrm_IC_Report_Classchange;
  orderLst, recDataLst, recData_fromICLst: Tstrings;
implementation
uses ICDataModule, ICCommunalVarUnit, ICFunctionUnit, ICmain, ICEventTypeUnit, Fileinput_machinerecord_gamenameUnit, Fileinput_gamenameinputUnit,
  Fileinput_menbermatialupdateUnit;
{$R *.dfm}

procedure Tfrm_IC_Report_Classchange.InitDataBase;
var
  strSQL: string;
  comname: string;
begin

  with ADOQuery_Recrod do begin
    Connection := DataModule_3F.ADOConnection_Main;
    Active := false;
    SQL.Clear;
    comname := '4';
    strSQL := 'select * from [TClassChangeInfor] order by ID DESC';
    SQL.Add(strSQL);
    Active := True;
  end;

end;

procedure Tfrm_IC_Report_Classchange.InitCombo_OP; //初始化游戏名称下来框
var
  ADOQTemp: TADOQuery;
  strSQL: string;
  nameStr: string;
  i: integer;
begin
  ADOQTemp := TADOQuery.Create(nil);
  strSQL := 'select distinct[UserNo] from [3F_SysUser]   order by UserNo ASC ';
  with ADOQTemp do
  begin
    Connection := DataModule_3F.ADOConnection_Main;
    SQL.Clear;
    SQL.Add(strSQL);
    Active := True;
    Combo_OP.Items.Clear;
    Combo_OP.Items.Add('全部');
    while not Eof do
    begin
      Combo_OP.Items.Add(FieldByName('UserNo').AsString);
      Next;
    end;
  end;
  FreeAndNil(ADOQTemp);
end;


procedure Tfrm_IC_Report_Classchange.BitBtn5Click(Sender: TObject);
begin
//RvProject1.Execute ; //或者 RvProject1.ExecuteReport('Report1');
  Edit_Recemenber.Text := '';
  Edit_Recemenber.Text := Edit_ID.Text;
end;

procedure Tfrm_IC_Report_Classchange.BitBtn1Click(Sender: TObject);
begin
      //保存条码记录
     //唯一性判断
  if (length(Trim(Edit_Sendmenber.Text)) = 0) then
  begin
    ShowMessage('交班人信息不能空');
    exit;
  end;

  if (length(Trim(Edit_Recemenber.Text)) = 0) then
  begin
    ShowMessage('接班人信息不能空');
    exit;
  end;
  if (length(Trim(Edit_ReceFromBoss.Text)) = 0) then
  begin
    ShowMessage('开班领取币值不能为空，等于0时，请是输入0');
    exit;
  end;
  if (length(Trim(Edit_Have.Text)) = 0) then
  begin
    ShowMessage('结余金额不能为空，等于0时，请是输入0');
    exit;
  end;
  if (length(Trim(Edit_Acount.Text)) = 0) then
  begin
    ShowMessage('结转金额不能为空，等于0时，请是输入0');
    exit;
  end;
  if (Edit_Sendmenber.Text = Edit_Recemenber.Text) then
  begin

    ShowMessage('交班人和接班人不能相同');
    Edit_Recemenber.Text := '';
    exit;
  end;

  SaveData_CardID; //保存交班记录
  ClearText;
end;




//保存当前记录，包括流水号、积分值等信息

procedure Tfrm_IC_Report_Classchange.SaveData_CardID;
var
  ADOQ: TADOQuery;
  strSQL, strTemp: string;
begin

  //SaveData_OK_flag_CardID:=FALSE; //保存操作完成

  strSQL := 'select * from [TClassChangeInfor]';
  strTemp := '';
  ADOQ := TADOQuery.Create(nil);
  with ADOQ do begin
    Connection := DataModule_3F.ADOConnection_Main;
    Active := false;
    SQL.Clear;
    SQL.Add(strSQL);
    Active := true;

    Append;
    FieldByName('SendMenber').AsString := Edit_Sendmenber.Text;
    FieldByName('ReceMenber').AsString := Edit_Recemenber.Text;
    FieldByName('Get_Acount').AsString := Edit_ReceFromBoss.Text;
    FieldByName('Have_Acount').AsString := Edit_Have.Text;
    FieldByName('Send_Acount').AsString := Edit_Acount.Text;
    FieldByName('Send_Rece').AsString := Combo_Send.Text;
    FieldByName('Send_Time').AsString := FormatDateTime('yyyy-MM-dd HH:mm:ss', now);
    Post;
    Active := False;
  end;
  FreeAndNil(ADOQ);
  InitDataBase;
  //SaveData_OK_flag_CardID:=true; //保存操作完成
end;

procedure Tfrm_IC_Report_Classchange.BitBtn7Click(Sender: TObject);
begin
  close;
end;

procedure Tfrm_IC_Report_Classchange.Edit_AcountKeyPress(Sender: TObject;
  var Key: Char);
begin
  if not (key in ['0'..'9', #8, #13]) then
  begin
    key := #0;
    ShowMessage('输入错误，只能输入数字！');
  end;

end;

procedure Tfrm_IC_Report_Classchange.Edit_ReceFromBossKeyPress(
  Sender: TObject; var Key: Char);
begin
  if not (key in ['0'..'9', #8, #13]) then
  begin
    key := #0;
    ShowMessage('输入错误，只能输入数字！');
  end;

end;

procedure Tfrm_IC_Report_Classchange.Edit_HaveKeyPress(Sender: TObject;
  var Key: Char);
begin
  if not (key in ['0'..'9', #8, #13]) then
  begin
    key := #0;
    ShowMessage('输入错误，只能输入数字！');
  end;

end;

procedure Tfrm_IC_Report_Classchange.FormShow(Sender: TObject);
begin

  comReader.StartComm();
  orderLst := TStringList.Create;
  recDataLst := tStringList.Create;
  recData_fromICLst := tStringList.Create;


  DateTimePicker_Start_Menberinfo.Date := StrToDate(copy(FormatDateTime('yyyy-MM-dd HH:mm:ss', now), 1, 10));
  DateTimePicker_End_Menberinfo.Date := StrToDate(copy(FormatDateTime('yyyy-MM-dd HH:mm:ss', now), 1, 10));
  TimePicker_Start_Menberinfo.Time := StrToTime(copy(FormatDateTime('yyyy-MM-dd HH:mm:ss', now), 12, 8));
  TimePicker_End_Menberinfo.Time := StrToTime(copy(FormatDateTime('yyyy-MM-dd HH:mm:ss', now), 12, 8));

  InitDataBase;
  InitCombo_OP;
  ClearText;
end;

procedure Tfrm_IC_Report_Classchange.ClearText;
begin
  Edit_Sendmenber.Text := '';
  Edit_Recemenber.Text := '';
  Edit_ReceFromBoss.Text := '0';
  Edit_Have.Text := '0';
  Edit_Acount.Text := '0';
end;

procedure Tfrm_IC_Report_Classchange.comReaderReceiveData(Sender: TObject;
  Buffer: Pointer; BufferLength: Word);
var
  ii: integer;
  recStr: string;
  tmpStr: string;
  tmpStrend: string;
begin
   //接收----------------
  tmpStrend := 'STR';
  recStr := '';
  SetLength(tmpStr, BufferLength);
  move(buffer^, pchar(tmpStr)^, BufferLength);
  for ii := 1 to BufferLength do
  begin
    recStr := recStr + intTohex(ord(tmpStr[ii]), 2); //将获得数据转换为16进制数
       // if  (intTohex(ord(tmpStr[ii]),2)='4A') then
    if ii = BufferLength then
    begin
      tmpStrend := 'END';
    end;
  end;
     // Edit1.Text:=recStr;
  recData_fromICLst.Clear;
  recData_fromICLst.Add(recStr);
    //接收---------------
     //if  (tmpStrend='END') then
  begin
    CheckCMD(); //首先根据接收到的数据进行判断，确认此卡是否属于为正确的卡
         //AnswerOper();//其次确认是否有需要回复IC的指令
  end;
    //发送---------------
  //  if curOrderNo<orderLst.Count then    // 判断指令是否已经都发送完毕，如果指令序号小于指令总数则继续发送
  //      sendData()
  //  else begin
  //      checkOper();
  //  end;
end;
 //根据接收到的数据判断此卡是否为合法卡

procedure Tfrm_IC_Report_Classchange.CheckCMD();
var
  tmpStr: string;
  ID_INIT: string;
  ID_3F: string;
  Password_3F: string;
  Password_USER: string;
  RevComd: string;
  ID_type: string;
begin
   //首先截取接收的信息
  tmpStr := recData_fromICLst.Strings[0];
  Receive_CMD_ID_Infor.ID_CheckNum := copy(tmpStr, 39, 4); //校验和
      // if (CheckSUMData(copy(tmpStr, 1, 38))=copy(tmpStr, 41, 2)+copy(tmpStr, 39, 2)) then//校验和
  begin
    CMD_CheckSum_OK := true;
    RevComd := copy(recData_fromICLst.Strings[0], 1, 2); //帧头43
  end;
                 //1、判断此卡是否为已经完成初始化
  if RevComd = CMD_COUMUNICATION.CMD_READ then
  begin

    ID_INIT := copy(recData_fromICLst.Strings[0], 3, 8); //卡片ID
    ID_3F := copy(recData_fromICLst.Strings[0], 11, 6); //卡厂ID
    Password_3F := copy(recData_fromICLst.Strings[0], 17, 6); //卡密
    Password_USER := copy(recData_fromICLst.Strings[0], 23, 6); //用户密码
    ID_type := copy(recData_fromICLst.Strings[0], 37, 2); //卡功能

                 //1、判断是否曾经初始化过，只有3F初始化过的卡且类型为万能卡AA 或 老板卡BB或管理人员的才能操作
                 //if ICFunction.CHECK_3F_ID(ID_INIT,ID_3F,Password_3F) and ( (ID_type=copy(INit_Wright.Produecer_3F,8,2))or (ID_type=copy(INit_Wright.BOSS,8,2)) or (ID_type=copy(INit_Wright.MANEGER,8,2)) ) then
                 //20130116修改
    if ((ID_type = copy(INit_Wright.Produecer_3F, 8, 2)) or (ID_type = copy(INit_Wright.BOSS, 8, 2)) or (ID_type = copy(INit_Wright.MANEGER, 8, 2))) then

    begin
      Edit_ID.Text := '';
      Edit_ID.Text := ID_INIT;
      Label11.Caption := '注意：点击读取前请将工作卡放在卡头上方                   ';
    end
    else //不是万能卡AA，也不是老板卡BB ，也不是管理人员
    begin
      Label11.Caption := '对不起！当前卡无交班操作权限';
      Edit_ID.Text := '';
      exit;
    end;
  end;

end;

procedure Tfrm_IC_Report_Classchange.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  orderLst.Free();
  recDataLst.Free();
  recData_fromICLst.Free();
  comReader.StopComm();
end;

procedure Tfrm_IC_Report_Classchange.BitBtn2Click(Sender: TObject);
begin
  Edit_Sendmenber.Text := '';
  Edit_Sendmenber.Text := Edit_ID.Text;

end;

procedure Tfrm_IC_Report_Classchange.BitBtn6Click(Sender: TObject);
begin
  close;
end;

procedure Tfrm_IC_Report_Classchange.BitBtn3Click(Sender: TObject);
var
  strSQL: string;
  LastRecord: string;
  strWhere: string;

  strStartDate, strEndDate, strIsable, strcUserNo: string;
begin
  LastRecord := '1'; //最新记录标志位

  strWhere := '';

  strWhere := strWhere + 'select *';
  strWhere := strWhere + 'from TClassChangeInfor ';
  strWhere := strWhere + 'where  ';

        //条件一
  strStartDate := FormatDateTime('yyyy-MM-dd', DateTimePicker_Start_Menberinfo.Date) + ' ' + FormatDateTime('hh:mm:ss', TimePicker_Start_Menberinfo.Time);
  strEndDate := FormatDateTime('yyyy-MM-dd', DateTimePicker_End_Menberinfo.Date) + ' ' + FormatDateTime('hh:mm:ss', TimePicker_End_Menberinfo.Time);


  strWhere := strWhere + ' (Send_Time>=''' + strStartDate + ''' and Send_Time<=''' + strEndDate + ''')';

      //条件二
  if Combo_OP.Text <> '全部' then
  begin
      //strcUserNo:=Query_Operater('''+TrimRight(ComboBox_Operator_Menberinfo.Text)+''');
    strcUserNo := Query_UserNo(TrimRight(Combo_OP.Text));
    Edit1.Text := strcUserNo;
    strWhere := strWhere + ' and SendMenber=''' + strcUserNo + '''';
  end;

     //条件三
  if ComboBox4.Text <> '全部' then
  begin
      //strIsable:=Query_Cardstate('''+TrimRight(ComboBox_Cardstate_Menberinfo.Text)+''');

    strWhere := strWhere + ' and Send_Rece=''' + ComboBox4.Text + '''';
  end;

  strSQL := '' + strWhere + '';

  with ADOQuery_QueryRecord do begin
    Connection := DataModule_3F.ADOConnection_Main;
    Active := false;
    SQL.Clear;
    SQL.Add(strSQL);
    Active := True;

  end;
end;


function Tfrm_IC_Report_Classchange.Query_UserNo(StrUserNo: string): string;
var
  ADOQTemp: TADOQuery;
  strSQL: string;
  reTmpStr: string;
  strWhere: string;

begin
  ADOQTemp := TADOQuery.Create(nil);
  strWhere := 'select UserID from[3F_SysUser] where UserNo=''' + StrUserNo + '''';

  strSQL := '' + strWhere + '';
  Result := '';
  with ADOQTemp do
  begin
    Connection := DataModule_3F.ADOConnection_Main;
    SQL.Clear;
    SQL.Add(strSQL);
    Active := True;
    Result := ADOQTemp.Fields[0].AsString;
  end;
  FreeAndNil(ADOQTemp);

end;

procedure Tfrm_IC_Report_Classchange.BitBtn4Click(Sender: TObject);
begin
  RvProject1.Execute; //或者 RvPro_MenberinfoPrint.ExecuteReport('Report1');
end;

end.
