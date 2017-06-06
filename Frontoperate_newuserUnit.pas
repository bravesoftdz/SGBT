unit Frontoperate_newuserUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, Grids, DBGrids, ExtCtrls, Buttons, DB, ADODB,
  SPComm, DateUtils;
type
  Tfrm_Frontoperate_newuser = class(TForm)
    comReader: TComm;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Bit_Close: TBitBtn;
    Panel4: TPanel;
    GroupBox5: TGroupBox;
    Label7: TLabel;
    Label8: TLabel;
    Label13: TLabel;
    Label9: TLabel;
    Label11: TLabel;
    edtMemberNO: TEdit;
    edtLeftMoney: TEdit;
    edtPassword: TEdit;
    cbbMemberType: TComboBox;
    edtMobileNO: TEdit;
    dsMember: TDataSource;
    ADOQueryMemberRecord: TADOQuery;
    dbgrdMember: TDBGrid;
    Image1: TImage;
    Panel_Message: TPanel;
    Label20: TLabel;
    Bit_Add: TBitBtn;
    lbl1: TLabel;
    edtID: TEdit;
    procedure comReaderReceiveData(Sender: TObject; Buffer: Pointer;
      BufferLength: Word);
    procedure FormCreate(Sender: TObject);
    procedure Bit_QueryClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Bit_AddClick(Sender: TObject);
    procedure Bit_CloseClick(Sender: TObject);
    procedure edtLeftMoneyKeyPress(Sender: TObject; var Key: Char);
    procedure Edit_PrintNOKeyPress(Sender: TObject; var Key: Char);
    procedure edtMobileNOKeyPress(Sender: TObject; var Key: Char);
    procedure Comb_MonthKeyPress(Sender: TObject; var Key: Char);
    procedure Comb_DayKeyPress(Sender: TObject; var Key: Char);

  private
    { Private declarations }
    procedure Initmenberlevel;
    procedure Initmenbertype;
    function exchData(orderStr: string): string;
    procedure sendData();

    procedure CheckCMD();
    procedure InitDataBase;

    function OnlyCheck(StrID: string): boolean;
    procedure Query_MenberLevInfor(StrLevNum: string);
    procedure Getmenberinfo(S1, S2: string);
    procedure Mobile_Onlycheck(StrMobile: string);

  public
    { Public declarations }
  end;

var
  frm_Frontoperate_newuser: Tfrm_Frontoperate_newuser;
  curOrderNo: integer = 0;
  curOperNo: integer = 0;
  orderLst, recDataLst, recData_fromICLst: Tstrings;
  Check_OK: BOOLEAN;
  buffer: array[0..2048] of byte;
implementation

uses ICDataModule, ICtest_Main, ICCommunalVarUnit, ICmain, ICEventTypeUnit, ICFunctionUnit, Frontoperate_EBincvalueUnit;

{$R *.dfm}
//初始化用户类型

procedure Tfrm_Frontoperate_newuser.Initmenberlevel;
var
  ADOQTemp: TADOQuery;
  strSQL: string;
begin
  ADOQTemp := TADOQuery.Create(nil);
  strSQL := 'select distinct [LevName] from [TLevel]';
  with ADOQTemp do begin
    Connection := DataModule_3F.ADOConnection_Main;
    SQL.Clear;
    SQL.Add(strSQL);
    Active := True;
    cbbMemberType.Items.Clear;
    while not Eof do begin
      cbbMemberType.Items.Add(FieldByName('LevName').AsString);
      Next;
    end;
  end;
  FreeAndNil(ADOQTemp);
end;

//初始化帐户类型

procedure Tfrm_Frontoperate_newuser.Initmenbertype;
var
  ADOQTemp: TADOQuery;
  strSQL: string;
begin

    cbbMemberType.Items.Add('年卡');  //年卡
    cbbMemberType.Items.Add('季度卡');//季度卡
    cbbMemberType.Items.Add('月卡');//月卡
    cbbMemberType.Items.Add('普通卡');//普通卡     

end;


procedure Tfrm_Frontoperate_newuser.FormCreate(Sender: TObject);
begin

  EventObj := EventUnitObj.Create;
  EventObj.LoadEventIni;

end;

procedure Tfrm_Frontoperate_newuser.InitDataBase;
var
  strSQL: string;
begin
  with ADOQueryMemberRecord do begin
    Connection := DataModule_3F.ADOConnection_Main;
    Active := false;
    SQL.Clear;
    strSQL := 'select * from [TMemberInfo]';
    SQL.Add(strSQL);
    Active := True;
  end;

end;


//转找发送数据格式

function Tfrm_Frontoperate_newuser.exchData(orderStr: string): string;
var
  ii, jj: integer;
  TmpStr: string;
  reTmpStr: string;
begin
  if (length(orderStr) = 0) then
  begin
    MessageBox(handle, '传入参数不能为空!', '错误', MB_ICONERROR + MB_OK);
    result := '';
    exit;
  end;
  if (length(orderStr) mod 2) <> 0 then
  begin
    MessageBox(handle, '传入参数错误!', '错误', MB_ICONERROR + MB_OK);
    result := '';
    exit;
  end;
  for ii := 1 to (length(orderStr) div 2) do
  begin
    tmpStr := copy(orderStr, ii * 2 - 1, 2);
    jj := strToint('$' + tmpStr);
    reTmpStr := reTmpStr + chr(jj);
  end;
  result := reTmpStr;
end;

//发送数据过程

procedure Tfrm_Frontoperate_newuser.sendData();
var
  orderStr: string;
begin
  if orderLst.Count > curOrderNo then
  begin
    orderStr := orderLst.Strings[curOrderNo];
        //memComSeRe.Lines.Add('==>> '+orderStr);
    orderStr := exchData(orderStr);
    comReader.WriteCommData(pchar(orderStr), length(orderStr));
    inc(curOrderNo);
  end;
end;



//读取ID卡号

procedure Tfrm_Frontoperate_newuser.Bit_QueryClick(Sender: TObject);
begin
  orderLst.Clear();
  recDataLst.Clear();
  curOrderNo := 0;
  curOperNo := 2;
  orderLst.Add('AA8A5F5FA101004A');
  sendData();
end;
//接收串口返回的数据

procedure Tfrm_Frontoperate_newuser.comReaderReceiveData(Sender: TObject; Buffer: Pointer;
  BufferLength: Word);
var
  ii: integer;
  recStr: string;
  tmpStr: string;
  tmpStrend: string;
begin
   //接收----------------
  recStr := '';
  SetLength(tmpStr, BufferLength);
  move(buffer^, pchar(tmpStr)^, BufferLength);
  for ii := 1 to BufferLength do
  begin
    recStr := recStr + intTohex(ord(tmpStr[ii]), 2); //将获得数据转换为16进制数
   
    if ii = BufferLength then
    begin
      tmpStrend := 'END';
    end;
  end;
   
  recDataLst.Clear;
  recDataLst.Add(recStr);

  begin
    CheckCMD(); //首先根据接收到的数据进行判断，确认此卡是否属于为正确的卡
  end;

end;

//根据接收到的数据判断此卡是否为合法卡

procedure Tfrm_Frontoperate_newuser.CheckCMD();
var
  i: integer;
  tmpStr: string;
  stationNoStr: string;
  tmpStr_Hex: string;
  tmpStr_Hex_length: string;
  Send_value: string;
  RevComd: integer;
  ID_No: string;
  length_Data: integer;
begin
   //首先截取接收的信息

  tmpStr := recDataLst.Strings[0];

  Receive_CMD_ID_Infor.ID_CheckNum := copy(tmpStr, 39, 4); //校验和

   
  begin
    CMD_CheckSum_OK := true;
    Receive_CMD_ID_Infor.CMD := copy(recDataLst.Strings[0], 1, 2); //帧头43
  end;

  if Receive_CMD_ID_Infor.CMD = CMD_COUMUNICATION.CMD_READ then
  begin

    Receive_CMD_ID_Infor.ID_INIT := copy(recDataLst.Strings[0], 3, 8); //卡片ID
    Receive_CMD_ID_Infor.ID_3F := copy(recDataLst.Strings[0], 11, 6); //卡厂ID
    Receive_CMD_ID_Infor.Password_3F := copy(recDataLst.Strings[0], 17, 6); //卡密
    Receive_CMD_ID_Infor.Password_USER := copy(recDataLst.Strings[0], 23, 6); //用户密码
    Receive_CMD_ID_Infor.ID_value := copy(recDataLst.Strings[0], 29, 8); //卡内数据
    Receive_CMD_ID_Infor.ID_type := copy(recDataLst.Strings[0], 37, 2); //卡功能
    begin

        if DataModule_3F.Query_User_INIT_OK(Receive_CMD_ID_Infor.ID_INIT) then //有记录
        begin

          if OnlyCheck(Receive_CMD_ID_Infor.ID_INIT) then
          begin
            Panel_Message.Caption := '此卡ID已经存在，请确认卡来源！'; //卡ID
          end
          else

          begin

            edtID.Text := Receive_CMD_ID_Infor.ID_INIT; //卡ID
            Panel_Message.Caption := '此卡合法，请继续操作！'; //卡ID

          end;
    end;

  end;

end;
end;



function Tfrm_Frontoperate_newuser.OnlyCheck(StrID: string): boolean;
var
  ADOQTemp: TADOQuery;
  strSQL: string;
  reTmpStr: boolean;
begin
  reTmpStr := false;


  ADOQTemp := TADOQuery.Create(nil);
  //strSQL := 'select Count([MemCardNo]) from [TMemberInfo] where IDCardNo=''' + StrID + '''';
  strSQL := 'select Count([MemCardNo]) from [TMemberInfo] where IDCardNo=''11''';

  with ADOQTemp do
  begin
  {
    Connection := DataModule_3F.ADOConnection_main;
    SQL.Clear;
    SQL.Add(strSQL);
    Active := True;

    if StrToInt(TrimRight(ADOQTemp.Fields[0].AsString)) > 0 then
      reTmpStr := true;
   }
  end;


  FreeAndNil(ADOQTemp);

  Result := reTmpStr;

end;


procedure Tfrm_Frontoperate_newuser.FormShow(Sender: TObject);
begin
  InitDataBase; //显示出型号
  Initmenberlevel;
  comReader.StartComm();
  orderLst := TStringList.Create;
  recDataLst := tStringList.Create;
  Check_OK := false;
end;

procedure Tfrm_Frontoperate_newuser.FormClose(Sender: TObject; var Action: TCloseAction);
var
  i: integer;
begin


  orderLst.Free();
  recDataLst.Free();
  comReader.StopComm();
  ICFunction.ClearIDinfor; //清除从ID读取的所有信息
  Check_OK := false;
    //清理表格
  for i := 0 to ComponentCount - 1 do
  begin
    if components[i] is TEdit then
    begin
      (components[i] as TEdit).Clear;
    end
  end;
end;


  //查询等级代码



//新建用户

procedure Tfrm_Frontoperate_newuser.Bit_AddClick(Sender: TObject);
var
  operatorNO,id, memberNO, strID, leftMoney, mobileNO, userPassword, memberType: string;
  i, j: integer;
  EditOKStr, pwdStr: string;
  strsexOrg: Boolean;
  strSaveMoney: Currency;
  Strtest: string;
label ExitSub;
begin
  operatorNO := G_User.UserNO;
  
  memberNO := edtMemberNO.Text;
  id := edtID.Text;
  memberType :=cbbMemberType.Text;
  leftMoney  := edtLeftMoney.Text;
  mobileNO := edtMobileNO.Text;
  userPassword := edtPassword.text;

  if (edtID.Text = '') then //卡ID
  begin
    ShowMessage('请确认是否已经成功刷卡'); 
    exit;
  end;

    with ADOQueryMemberRecord do begin
      Append;
      FieldByName('MemCardNo').AsString := memberNO;
      FieldByName('MemType').AsString := memberType;
      FieldByName('IDCardNo').AsString := id;
      FieldByName('Mobile').AsString := mobileNO;
      FieldByName('Deposit').AsString := leftMoney;
      FieldByName('OpenCardDT').AsString := FormatDateTime('yyyy-MM-dd HH:mm:ss', now); //开卡时间

      //开卡时间加上卡类型时长
      FieldByName('EffectiveDT').AsString := FormatDateTime('yyyy-MM-dd HH:mm:ss',IncDay(now,30));

      FieldByName('cUserNo').AsString := operatorNO;

      try
        Post;
      except
        on e: Exception do ShowMessage(e.Message);
      end;
    end;

end;

procedure Tfrm_Frontoperate_newuser.Bit_CloseClick(Sender: TObject);
begin
  Close;
end;

procedure Tfrm_Frontoperate_newuser.edtLeftMoneyKeyPress(Sender: TObject;
  var Key: Char);
begin
  if not (key in ['0'..'9', #8]) then
  begin
    key := #0;
  end

end;

procedure Tfrm_Frontoperate_newuser.Edit_PrintNOKeyPress(Sender: TObject;
  var Key: Char);
begin
  if not (key in ['0'..'9', #8]) then
  begin
    key := #0;
  end
end;


procedure Tfrm_Frontoperate_newuser.Comb_MonthKeyPress(Sender: TObject;
  var Key: Char);
begin
  if not (key in ['0'..'9', #8]) then
  begin
    key := #0;
  end
end;

procedure Tfrm_Frontoperate_newuser.Comb_DayKeyPress(Sender: TObject;
  var Key: Char);
begin
  if not (key in ['0'..'9', #8]) then
  begin
    key := #0;
  end
end;

procedure Tfrm_Frontoperate_newuser.edtMobileNOKeyPress(Sender: TObject;
  var Key: Char);
begin
  if not (key in ['0'..'9', #8]) then
  begin
    key := #0;
  end;
  if (length(trimright(edtMobileNO.Text)) = 11) and (key = #13) then
  begin
    Mobile_Onlycheck(trimright(edtMobileNO.Text));
  end;
end;



procedure Tfrm_Frontoperate_newuser.Mobile_Onlycheck(StrMobile: string);
begin
  Getmenberinfo('根据用户手机号', StrMobile);
end;


procedure Tfrm_Frontoperate_newuser.Getmenberinfo(S1, S2: string);
var
  ADOQTemp: TADOQuery;
  strSQL: string;
  reTmpStr: string;
  strsexOrg: string;
begin

  if S1 = '根据用户手机号' then
    strSQL := 'select * from [TMemberInfo] where  [Mobile]=''' + S2 + ''''
  else if S1 = '根据用户身份证' then
    strSQL := 'select * from [TMemberInfo] where  [DocNumber]=''' + S2 + ''''
  else
  begin
    exit;
  end;
  ADOQTemp := TADOQuery.Create(nil);

  with ADOQTemp do
  begin
    Connection := DataModule_3F.ADOConnection_Main;
    SQL.Clear;
    SQL.Add(strSQL);
    Active := True;
    while not Eof do
    begin
      edtMemberNO.text := FieldByName('MemCardNo').AsString;
      edtID.text := FieldByName('IDCardNo').AsString;
      edtMobileNO.text := FieldByName('Mobile').AsString;
      edtLeftMoney.text := FieldByName('Deposit').AsString;


    end;
  end;
  FreeAndNil(ADOQTemp);
end;

 //查询等级资料

procedure Tfrm_Frontoperate_newuser.Query_MenberLevInfor(StrLevNum: string); //查询等级资料
var
  ADOQTemp: TADOQuery;
  strSQL: string;
  reTmpStr: string;
begin
  ADOQTemp := TADOQuery.Create(nil);
  strSQL := 'select LevName from [TLevel] where LevNo=''' + StrLevNum + '''';

  with ADOQTemp do
  begin
    Connection := DataModule_3F.ADOConnection_Main;
    SQL.Clear;
    SQL.Add(strSQL);
    Active := True;
    cbbMemberType.text := FieldByName('LevName').AsString;
  end;
  FreeAndNil(ADOQTemp);
end;



end.
