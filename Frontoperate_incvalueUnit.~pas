unit Frontoperate_incvalueUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, DBGrids, DB, ADODB, ExtCtrls, StdCtrls, Buttons, SPComm, DateUtils;

type
  Tfrm_Frontoperate_incvalue = class(TForm)
  //Panel类

  //edit类

  //button类

  //groupbox类

  //radiobox类

  //DB类


    Panel1: TPanel;
    DataSource_Incvalue: TDataSource;
    ADOQuery_Incvalue: TADOQuery;
    DBGrid2: TDBGrid;
    Panel2: TPanel;
    ADOQuery_newmenber: TADOQuery;
    DataSource_Newmenber: TDataSource;
    Panel3: TPanel;
    Panel4: TPanel;
    GroupBox5: TGroupBox;
    Label3: TLabel;
    Label4: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Edit_ID: TEdit;
    Edit_PrintNO: TEdit;
    Edit_Username: TEdit;
    Edit_Certify: TEdit;
    Edit_SaveMoney: TEdit;
    Edit_Prepassword: TEdit;
    Comb_menberlevel: TComboBox;
    Edit_Mobile: TEdit;
    GroupBox4: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label15: TLabel;
    Edit_Givecore: TEdit;
    edtIncrValue: TEdit;
    Edit_Totalvale: TEdit;
    Edit_Pwdcomfir: TEdit;
    Bitn_Close: TBitBtn;
    Image1: TImage;
    btnOffLineRecharge: TBitBtn;
    Label20: TLabel;
    Panel_Message: TPanel;
    Edit_TotalbuyValue: TEdit;
    Label5: TLabel;
    Label10: TLabel;
    Edit_TotalChangeValue: TEdit;
    Label16: TLabel;
    Label17: TLabel;
    cbBatchRecharge: TCheckBox;
    Panel_infor: TPanel;
    Labnumber: TLabel;
    edit_number: TEdit;
    Label18: TLabel;
    Label19: TLabel;
    Label21: TLabel;
    Edit_money: TEdit;
    Lab_money: TLabel;
    Label6: TLabel;
    edtIDType: TEdit;
    edtOldValue: TEdit;
    comReader: TComm;

  //事件
    procedure FormCreate(Sender: TObject);
    procedure comReaderReceiveData(Sender: TObject; Buffer: Pointer; BufferLength: Word);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Bitn_CloseClick(Sender: TObject);
    procedure btnOffLineRechargeClick(Sender: TObject);
    procedure edtIncrValueKeyPress(Sender: TObject; var Key: Char);
    procedure Edit_PwdcomfirKeyPress(Sender: TObject; var Key: Char);

  private
    { Private declarations }



    //数据库处理函数
    procedure initShowDataBaseInfo();
    procedure querMemberInfo(StrID: string);
    procedure queryMemberLevelInfo(StrLevNum: string);
    function queryMemberInfo(StrID: string): boolean;
    procedure queryIncrValueInfo(StrID: string); //总充值值
    procedure queryChangeValueInfo(StrID: string); //总兑换值
    procedure prcDBSaveIncrValue; //保存充值记录
    procedure updateLastestRecord(S: string); //更新最新记录标志
    procedure updateLastestRecordValue(S: string); //更新充值额
    function checkLastestRecord(S: string): boolean;
    function checkIDCardExpire(S: string): boolean;

    //卡头处理函数
    procedure checkCMDInfo();
    procedure initIncrOperation(); //充值操作，写数据个卡
    function caluSendCMD(StrCMD: string; StrIncValue: string): string;
    procedure generateIncrValueCMD(S: string);
    procedure prcSendDataToCard();

    function checkSUMData(orderStr: string): string;
    procedure getExpireTime();
    function transferCheckSumByte(StrCheckSum: string): string;
    procedure prcUserCardOperation();
    procedure prcCardIncrValueReturn();
    procedure prcCardReadValueReturn();

    procedure clearComponetText();

  public
    { Public declarations }

  end;

var
  frm_Frontoperate_incvalue: Tfrm_Frontoperate_incvalue;
  curOrderNo: integer = 0; //???
  curOperNo: integer = 0;
  Operate_No: integer = 0; //什么作用?标记正在充值？
  orderLst, recDataLst: Tstrings; //定义全局变量发送数据，接收数据
  ID_UserCard_Text: string;
  IncValue_Enable: boolean; //是否允许充值的标志,会员卡认证通过后置为True
  buffer: array[0..2048] of byte;

implementation
uses ICDataModule, ICtest_Main, ICCommunalVarUnit, ICmain, ICEventTypeUnit, ICFunctionUnit, dateProcess;
{$R *.dfm}


//数据展示会员信息

procedure Tfrm_Frontoperate_incvalue.initShowDataBaseInfo;
var
  strSQL: string;
begin
  with ADOQuery_newmenber do begin
    Connection := DataModule_3F.ADOConnection_Main;
    Active := false;
    SQL.Clear;
    strSQL := 'select * from [TMemberInfo]';
    SQL.Add(strSQL);
    Active := True;
  end;
  with ADOQuery_Incvalue do begin
    Connection := DataModule_3F.ADOConnection_Main;
    Active := false;
    SQL.Clear;
    strSQL := 'select top 5 * from [TMembeDetail] order by GetTime desc';
    SQL.Add(strSQL);
    Active := True;
  end;
end;




procedure Tfrm_Frontoperate_incvalue.prcSendDataToCard();
var
  orderStr: string;
begin
  if orderLst.Count > curOrderNo then
  begin
    orderStr := orderLst.Strings[curOrderNo];
    orderStr := ICFunction.funcTransferExchData(orderStr);
    comReader.WriteCommData(pchar(orderStr), length(orderStr)); //真正写到卡头
    inc(curOrderNo); //累加
  end;
end;

//窗体创建事件

procedure Tfrm_Frontoperate_incvalue.FormCreate(Sender: TObject);
begin
  EventObj := EventUnitObj.Create;
  EventObj.LoadEventIni;
end;

//串口接受处理数据处理数据事件

procedure Tfrm_Frontoperate_incvalue.comReaderReceiveData(Sender: TObject;
  Buffer: Pointer; BufferLength: Word);
var
  i: integer;
  recStr: string;
  tmpStr: string;
  tmpStrend: string;
begin
   //接收----------------
  recStr := '';
  SetLength(tmpStr, BufferLength);
  move(buffer^, pchar(tmpStr)^, BufferLength);
  for i := 1 to BufferLength do
  begin
    recStr := recStr + intTohex(ord(tmpStr[i]), 2); //将获得数据转换为16进制数
    if i = BufferLength then
    begin
      tmpStrend := 'END';
    end;
  end;
  recDataLst.Clear;
  recDataLst.Add(recStr);
  begin
    checkCMDInfo(); //首先根据接收到的数据进行判断，确认此卡是否属于为正确的卡
  end;

end;

//根据接收到的数据判断此卡是否为合法卡，　卡信息核查

procedure Tfrm_Frontoperate_incvalue.checkCMDInfo();
var
  tmpStr: string;
  tmpStr_Hex_length: string;
  Send_value: string;
  RevComd: integer;
  ID_No: string;
  length_Data: integer;
begin
   //首先截取接收的信息

  tmpStr := recDataLst.Strings[0];
  ICCommunalVarUnit.Receive_CMD_ID_Infor.ID_CheckNum := copy(tmpStr, 39, 4); //校验和
  ICCommunalVarUnit.CMD_CheckSum_OK := true;
  ICCommunalVarUnit.Receive_CMD_ID_Infor.CMD := copy(recDataLst.Strings[0], 1, 2); //帧头43

  if ICCommunalVarUnit.Receive_CMD_ID_Infor.CMD = ICCommunalVarUnit.CMD_COUMUNICATION.CMD_INCValue_RE then //收到卡头写入电子币充值成功的返回 53
  begin
    prcCardIncrValueReturn();
  end
  else if Receive_CMD_ID_Infor.CMD = CMD_COUMUNICATION.CMD_READ then //读指令
  begin
    prcCardReadValueReturn();
  end;

end;



//卡头返回充值成功指令

procedure Tfrm_Frontoperate_incvalue.prcCardIncrValueReturn();
begin
  if (Operate_No = 1) then //保存当前卡的初始化记录
  begin
    if Receive_CMD_ID_Infor.ID_type = copy(INit_Wright.User, 8, 2) then
    begin
      prcDBSaveIncrValue; //保存充值记录
    end;
    Panel_Message.Caption := '充值操作、保存充值记录成功';
    initShowDataBaseInfo();
  end;
end;


//卡头返回信息读取指令

procedure Tfrm_Frontoperate_incvalue.prcCardReadValueReturn();
begin
  Receive_CMD_ID_Infor.ID_INIT := copy(recDataLst.Strings[0], 3, 8); //卡片ID
  Receive_CMD_ID_Infor.ID_3F := copy(recDataLst.Strings[0], 11, 6); //卡厂ID
  Receive_CMD_ID_Infor.Password_3F := copy(recDataLst.Strings[0], 17, 6); //卡密
  Receive_CMD_ID_Infor.Password_USER := copy(recDataLst.Strings[0], 23, 6); //用户密码
  Receive_CMD_ID_Infor.ID_value := copy(recDataLst.Strings[0], 29, 8); //卡内数据
  Receive_CMD_ID_Infor.ID_type := copy(recDataLst.Strings[0], 37, 2); //卡功能

  edtIDType.Text := Receive_CMD_ID_Infor.ID_type;
  begin //本场地卡检查 -----开始
    if (Receive_CMD_ID_Infor.Password_USER = INit_Wright.BossPassword) //    INit_Wright.BossPassword := MyIni.ReadString('PLC工作区域', 'PC托盘特征码', '新密码');
      and ((Receive_CMD_ID_Infor.ID_type = copy(INit_Wright.RECV_CASE, 8, 2)) //    INit_Wright.RECV_CASE := '收银卡,CA'; 中文两个字节从第８开始取两个
      or (Receive_CMD_ID_Infor.ID_type = copy(INit_Wright.User, 8, 2))
      or (Receive_CMD_ID_Infor.ID_type = copy(INit_Wright.OPERN, 8, 2))) then //用收银卡作为会员卡
    begin //场地初始化检查 -----开始
      if DataModule_3F.Query_User_INIT_OK(Receive_CMD_ID_Infor.ID_INIT) then //有记录
      begin

        if Receive_CMD_ID_Infor.ID_type = copy(INit_Wright.RECV_CASE, 8, 2) then
        begin //收银卡（会员卡） -----开始
          if queryMemberInfo(Receive_CMD_ID_Infor.ID_INIT) then
          begin
            querMemberInfo(Receive_CMD_ID_Infor.ID_INIT); //展示会员卡信息
            edtIncrValue.Enabled := true;
            edtIncrValue.SetFocus;
            cbBatchRecharge.Enabled := False;
            cbBatchRecharge.Checked := false;
            Panel_Message.Caption := '此会员卡合法，请将电子币安放于充值卡头上方！'; //卡ID
            IncValue_Enable := true; //允许充值操作
            Edit_ID.Text := Receive_CMD_ID_Infor.ID_INIT;
          end //end 会员记录
          else
          begin
            clearComponetText;
            Panel_Message.Caption := '会员数据表中无记录，请确认是否为本场地会员！'; //卡ID
          end;
        end //收银卡（会员卡） -----结束
        else if Receive_CMD_ID_Infor.ID_type = copy(INit_Wright.User, 8, 2) then
        begin //用户卡 -----开始
          prcUserCardOperation();
        end //用户卡结束
        else if Receive_CMD_ID_Infor.ID_type = copy(INit_Wright.OPERN, 8, 2) then
        begin //开机卡 -----开始
          if IncValue_Enable then
          begin
            Panel_Message.Caption := '此用户币合法（开机卡），请继续操作！'; //卡ID
          end
          else
          begin
            Panel_Message.Caption := '请刷会员卡，然后再将电子币安放于充值卡头上方！'; //卡ID
          end;
        end; //开机卡 -----结束
      end
      else
      begin
        clearComponetText;
        Panel_Message.Caption := '在此系统无记录，请确认是否已经完成场地初始化！'; //卡ID
        exit;
      end;
    end
    else
    begin
      clearComponetText;
      Panel_Message.Caption := '此卡非法，请更换！'; //卡ID
      exit;
    end;
                           //本场地卡检查 -----结束
  end;


end;





//用户卡操作(会员卡认证及批充标志打开后才可以充值)

procedure Tfrm_Frontoperate_incvalue.prcUserCardOperation();
begin

  if IncValue_Enable then
  begin //连续充值操作选择---开始
    if (cbBatchRecharge.Checked) then
    begin
      if (edtIncrValue.Text = '') then
      begin
        Panel_Message.Caption := '请输入连续充值额，只能输入数字！';
        exit;
      end
      else
      begin
        initIncrOperation; //调用连续充值写入ID函数
      end;
    end; //结束批量充值

    Panel_Message.Caption := '此用户币合法，请继续操作！'; //卡ID
    ID_UserCard_Text := Receive_CMD_ID_Infor.ID_INIT; //用户币ID
    edtOldValue.Text := ICFunction.transferHEXByteToDECValue(Receive_CMD_ID_Infor.ID_value);
                                              //连续充值操作选择(单次充值使用确认按钮)---结束
  end //
  else
  begin
    Panel_Message.Caption := '请刷会员卡，然后再将电子币安放于充值卡头上方！'; //卡ID
  end; //end IncValue_Enable

end; //end prc_user_card_operation


//保存初始化数据
//写充值记录

procedure Tfrm_Frontoperate_incvalue.prcDBSaveIncrValue;
var
  strIDNo, strName, strUserNo, strIncvalue, strGivecore, strOperator, strhavemoney, strinputdatetime, strexpiretime, strsql: string;
  i: integer;
label ExitSub;
begin
  //如果用户币上的值不为0，则只是刷新此币的币值和充值时间
  if edtOldValue.Text <> '0' then
  begin
      //1查询当前币在充值表中是否有最新的充值记录，即
    if checkLastestRecord(ID_UserCard_Text) and checkIDCardExpire(ID_UserCard_Text) then
    begin
      updateLastestRecordValue(ID_UserCard_Text); //ID_UserCard_Text为电子币ID，根据此更新电子币充值记录
      exit;
    end

  end;

  strUserNo := Edit_PrintNO.Text; //用户编号
  updateLastestRecord(ID_UserCard_Text); //ID_UserCard_Text为电子币ID，根据此更新电子币充值记录
  strName := Edit_Username.Text; //用户名称
  strIncvalue := edtIncrValue.Text; //充值
  strGivecore := Edit_Givecore.Text; //送分值
  strOperator := G_User.UserNO; //操作员
  strhavemoney := edtIncrValue.Text; //
  strinputdatetime := FormatDateTime('yyyy-MM-dd HH:mm:ss', now); //录入时间，读取系统时间
  strexpiretime := FormatDateTime('yyyy-MM-dd HH:mm:ss', addhrs(now, iHHSet));
  strIDNo := TrimRight(Edit_ID.Text); //卡ID

  if Edit_Pwdcomfir.Text <> Edit_Prepassword.Text then
    ShowMessage('客户输入确认密码错误，请重新输入')
  else begin
    with ADOQuery_Incvalue do begin
      Connection := DataModule_3F.ADOConnection_Main;
      Active := false;
      SQL.Clear;
      strSQL := 'select * from [TMembeDetail] order by GetTime desc';
      SQL.Add(strSQL);
      Active := True;
      btnOffLineRecharge.Enabled := False; //关闭输入许可
      Append;
      FieldByName('MemCardNo').AsString := strUserNo;
      FieldByName('CostMoney').AsString := strIncvalue; //充值
      FieldByName('TickCount').AsString := strGivecore;
      FieldByName('cUserNo').AsString := strOperator; //操作员
      FieldByName('GetTime').AsString := strinputdatetime; //交易时间
      FieldByName('TotalMoney').AsString := strhavemoney; //帐户总额
      FieldByName('IDCardNo').AsString := strIDNo; //充值操作
      FieldByName('MemberName').AsString := strName; //用户名
      FieldByName('PayType').AsString := '0'; //充值操作
      FieldByName('MacNo').AsString := 'A0100'; //机台编号
      FieldByName('ExitCoin').AsInteger := 0;
      FieldByName('Compter').AsString := '1';
      FieldByName('LastRecord').AsString := '1';
      FieldByName('TickCount').AsString := '0';
      FieldByName('ID_UserCard_TuiBi_Flag').AsString := '0'; //退币标识
      FieldByName('ID_UserCard').AsString := ID_UserCard_Text; //电子币ID
      FieldByName('expiretime').AsString := strexpiretime; //失效时间
      try
        Post;
      except
        on e: Exception do ShowMessage(e.Message);
      end;
      //added by linlf 用于统计每一次充值，以每一次打开充值窗口为统计口径
      edit_number.Text := inttostr(strtoint(edit_number.Text) + 1);
      edit_money.Text := inttostr(strtoint(edit_money.Text) + strtoint(edtIncrValue.Text));

    end;


    ExitSub:
   //连续充值输入框
    if not (cbBatchRecharge.Checked) then
    begin
      clearComponetText;
      IncValue_Enable := false; //保存记录完毕后，关闭充值操作许可
      btnOffLineRecharge.Enabled := false;

    end
    else
    begin
          //ClearText_ContiueIncValue;
      btnOffLineRecharge.Enabled := true;
      queryIncrValueInfo(strIDNo); //总充值值（来源数据表[TMembeDetail]）
      queryChangeValueInfo(strIDNo); //总兑换值（来源数据表[3F_BARFLOW]）
      IncValue_Enable := true; //保存记录完毕后，关闭充值操作许可
    end;

    edtIncrValue.Enabled := false;
    Edit_Pwdcomfir.Enabled := false;
    Operate_No := 0;

    ID_UserCard_Text := '';

  end;



end;


 //更新此用户币最新充值、消分操作的记录标志位

procedure Tfrm_Frontoperate_incvalue.updateLastestRecord(S: string);
var
  ADOQ: TADOQuery;
  strSQL, strRet: string;
  MaxID: string;
  setvalue: string;
begin
  strSQL := 'select max(MD_ID) from TMembeDetail where ID_UserCard=''' + S + '''';
  ADOQ := TADOQuery.Create(nil);
  with ADOQ do begin
    Connection := DataModule_3F.ADOConnection_Main;
    SQL.Clear;
    SQL.Add(strSQL);
    Open;
    if (not eof) then
      MaxID := TrimRight(ADOQ.Fields[0].AsString);
    Close;
  end;
  FreeAndNil(ADOQ);

  setvalue := '0';
  strSQL := 'Update TMembeDetail set LastRecord=''' + setvalue + ''' where MD_ID=''' + MaxID + '''';
  ADOQ := TADOQuery.Create(nil);
  with ADOQ do begin
    Connection := DataModule_3F.ADOConnection_Main;
    SQL.Clear;
    SQL.Add(strSQL);
    ADOQ.ExecSQL;
  end;
  FreeAndNil(ADOQ);

end;

//查询当前币是否有最新的充值记录，如果没有则可能是假币，提示是否真的要继续充值

function Tfrm_Frontoperate_incvalue.checkLastestRecord(S: string): boolean;
var
  ADOQ: TADOQuery;
  strSQL, strRet: string;
  MaxID: integer;
  setvalue, settime: string;
begin


  Result := false;

  strSQL := 'select count(MD_ID) from TMembeDetail where (ID_UserCard=''' + S + ''') and LastRecord=''1''   ';
  ADOQ := TADOQuery.Create(nil);
  with ADOQ do begin
    Connection := DataModule_3F.ADOConnection_Main;
    SQL.Clear;
    SQL.Add(strSQL);
    Open;
    if (not eof) then
      MaxID := StrToInt(TrimRight(ADOQ.Fields[0].AsString)); ;

    Close;
  end;
  FreeAndNil(ADOQ);

  if MaxID = 0 then
    Result := false
  else
    Result := true;


end;

//检查IDCard是否过期

function Tfrm_Frontoperate_incvalue.checkIDCardExpire(S: string): boolean;
var
  ADOQ: TADOQuery;
  strSQL, strRet: string;
  MaxID: integer;
  setvalue, settime: string;
  strdatetime: string;
begin


  Result := false;
  strdatetime := formatdatetime('yyyy-mm-dd hh:mm:ss', now());
  strSQL := ' select count(MD_ID) from TMembeDetail where (ID_UserCard= '''
    + S + ''') and LastRecord=''1''  and expiretime > '''
    + strdatetime + '''';
  //showmessage(strSQL);
  ADOQ := TADOQuery.Create(nil);
  with ADOQ do begin
    Connection := DataModule_3F.ADOConnection_Main;
    SQL.Clear;
    SQL.Add(strSQL);
    Open;
    if (not eof) then
      MaxID := StrToInt(TrimRight(ADOQ.Fields[0].AsString)); ;

    Close;
  end;
  FreeAndNil(ADOQ);

  if MaxID = 0 then
    Result := false
  else
    Result := true;


end;

 //更新此用户币最新充值、消分操作的记录标志位

procedure Tfrm_Frontoperate_incvalue.updateLastestRecordValue(S: string);
var
  ADOQ: TADOQuery;
  strSQL, strRet: string;
  MaxID: string;
  setvalue, settime, setflag, strexpiretime: string;
begin
  strSQL := 'select max(MD_ID) from TMembeDetail where (ID_UserCard=''' + S + ''') ';
  ADOQ := TADOQuery.Create(nil);
  with ADOQ do begin
    Connection := DataModule_3F.ADOConnection_Main;
    SQL.Clear;
    SQL.Add(strSQL);
    Open;
    if (not eof) then
      MaxID := TrimRight(ADOQ.Fields[0].AsString);
    Close;
  end;
  FreeAndNil(ADOQ);
  setflag := '0';
  settime := FormatDateTime('yyyy-MM-dd HH:mm:ss', now);
  strexpiretime := FormatDateTime('yyyy-MM-dd HH:mm:ss', addhrs(now, iHHSet));

  setvalue := TrimRight(edtIncrValue.text);
  strSQL := 'Update TMembeDetail set TotalMoney=''' + setvalue
    + ''',GetTime=''' + settime + ''',CostMoney='''
    + setvalue + ''' ,expiretime=''' + strexpiretime + ''' where (MD_ID=''' + MaxID + ''') and (ID_UserCard_TuiBi_Flag=''' + setflag + ''')';
  ADOQ := TADOQuery.Create(nil);
  with ADOQ do begin
    Connection := DataModule_3F.ADOConnection_Main;
    SQL.Clear;
    SQL.Add(strSQL);
    ADOQ.ExecSQL;
  end;
  FreeAndNil(ADOQ);

end;

procedure Tfrm_Frontoperate_incvalue.clearComponetText;
begin
  Edit_ID.Text := ''; //卡ID
  Edit_PrintNO.Text := '';
  Edit_Username.Text := '';
  Edit_Prepassword.Text := '';
  Edit_Certify.Text := '';
  Edit_TotalbuyValue.Text := '';
  Edit_TotalChangeValue.Text := '';
  Edit_Mobile.Text := '';
  Comb_menberlevel.Text := '';
  Edit_SaveMoney.Enabled := false;
  edtIncrValue.Enabled := false;
  edtIncrValue.Text := '';
  Edit_Pwdcomfir.Enabled := false;
  Edit_Pwdcomfir.Text := '';
  btnOffLineRecharge.Enabled := false;
end;

// 是否存在会员信息

function Tfrm_Frontoperate_incvalue.queryMemberInfo(StrID: string): boolean;
var
  ADOQTemp: TADOQuery;
  strSQL: string;
  reTmpStr: boolean;
begin
  reTmpStr := false;
  ADOQTemp := TADOQuery.Create(nil);
  strSQL := 'select Count([MemCardNo]) from [TMemberInfo] where IDCardNo=''' + StrID + ''' ';

  with ADOQTemp do
  begin
    Connection := DataModule_3F.ADOConnection_Main;
    SQL.Clear;
    SQL.Add(strSQL);
    Active := True;

    if StrToInt(TrimRight(ADOQTemp.Fields[0].AsString)) > 0 then
      reTmpStr := true;

  end;
  FreeAndNil(ADOQTemp);

  Result := reTmpStr;
end;

//返回会员信息

procedure Tfrm_Frontoperate_incvalue.querMemberInfo(StrID: string);
var
  ADOQTemp: TADOQuery;
  strSQL: string;
  reTmpStr: string;
  strsexOrg: string;
begin
  ADOQTemp := TADOQuery.Create(nil);
  strSQL := 'select * from [TMemberInfo] where IDCardNo=''' + StrID + '''';

  with ADOQTemp do
  begin
    Connection := DataModule_3F.ADOConnection_Main;
    SQL.Clear;
    SQL.Add(strSQL);
    Active := True;

    Edit_PrintNO.text := FieldByName('MemCardNo').AsString;
    Edit_Username.text := FieldByName('MemberName').AsString;
    Edit_ID.text := FieldByName('IDCardNo').AsString;
    Edit_Prepassword.text := FieldByName('InfoKey').AsString;
    Edit_Mobile.text := FieldByName('Mobile').AsString;
    Edit_Certify.text := FieldByName('DocNumber').AsString;
    Edit_SaveMoney.text := FieldByName('Deposit').AsString;
    strsexOrg := FieldByName('Sex').AsString;

    queryMemberLevelInfo(TrimRight(FieldByName('LevNum').AsString));
    queryIncrValueInfo(StrID); //总充值值（来源数据表[TMembeDetail]）
    queryChangeValueInfo(StrID); //总兑换值（来源数据表[3F_BARFLOW]）
  end;
  FreeAndNil(ADOQTemp);
end;
 //查询等级资料

procedure Tfrm_Frontoperate_incvalue.queryMemberLevelInfo(StrLevNum: string); //查询等级资料
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
    Comb_menberlevel.text := FieldByName('LevName').AsString;
  end;
  FreeAndNil(ADOQTemp);
end;

 //查询过往充值交易情况

procedure Tfrm_Frontoperate_incvalue.queryIncrValueInfo(StrID: string);
var
  ADOQTemp: TADOQuery;
  strSQL: string;
  reTmpStr: string;
  strMaxMD_ID: string;
begin
                 //取得最新的总分记录ID
  ADOQTemp := TADOQuery.Create(nil);
  strSQL := 'select Max([MD_ID]) from [TMembeDetail] where IDCardNo=''' + StrID + '''';

  with ADOQTemp do
  begin
    Connection := DataModule_3F.ADOConnection_Main;
    SQL.Clear;
    SQL.Add(strSQL);
    Active := True;
    strMaxMD_ID := ADOQTemp.Fields[0].AsString;
  end;
  FreeAndNil(ADOQTemp);


                 //取得最新的总分
  ADOQTemp := TADOQuery.Create(nil);
                 //strSQL:= 'select TotalMoney from [TMembeDetail] where (IDCardNo='''+StrID+''') and (MD_ID='''+strMaxMD_ID+''')';

  strSQL := 'select sum(TotalMoney) from [TMembeDetail] where (IDCardNo=''' + StrID + ''')';

  with ADOQTemp do
  begin
    Connection := DataModule_3F.ADOConnection_Main;
    SQL.Clear;
    SQL.Add(strSQL);
    Active := True;
    Edit_TotalbuyValue.text := ADOQTemp.Fields[0].AsString;
  end;
  FreeAndNil(ADOQTemp);
end;

 //查询过往兑奖交易情况

procedure Tfrm_Frontoperate_incvalue.queryChangeValueInfo(StrID: string);
var
  ADOQTemp: TADOQuery;
  strSQL: string;
  reTmpStr: string;
  strMaxMD_ID: string;
begin

                 //取得兑换总值
  ADOQTemp := TADOQuery.Create(nil);
  strSQL := 'select Sum([COREVALU_Bili]) from [3F_BARFLOW] where (IDCardNo=''' + StrID + ''') ';

  with ADOQTemp do
  begin
    Connection := DataModule_3F.ADOConnection_Main;
    SQL.Clear;
    SQL.Add(strSQL);
    Active := True;
    Edit_TotalChangeValue.text := ADOQTemp.Fields[0].AsString;
  end;
  FreeAndNil(ADOQTemp);
end;

procedure Tfrm_Frontoperate_incvalue.FormShow(Sender: TObject);
begin
  ICFunction.InitSystemWorkPath; //初始化文件路径
  ICFunction.InitSystemWorkground; //初始化参数背景
  initShowDataBaseInfo();

  comReader.StartComm(); //打开串口

  IncValue_Enable := false;
  orderLst := TStringList.Create;
  recDataLst := tStringList.Create;
  edtOldValue.Text := '0';
  edit_number.Text := '0';
  edit_money.Text := '0';

  Panel_infor.Caption := '因您设定的代币比例为1 ：' + SystemWorkground.ErrorGTState + ',所以只能输入小于' + IntToStr(StrToInt(INit_Wright.MaxValue) div StrToInt(SystemWorkground.ErrorGTState)) + '的数值！';
  btnOffLineRecharge.Enabled := false;
  cbBatchRecharge.Checked := false;
 //盐城版本要求关闭
  Label10.Visible := false;
  Edit_TotalChangeValue.Visible := false;
  Edit_TotalbuyValue.Visible := false;
  Label7.Visible := false;
  edit_number.Visible := false;
  Labnumber.Visible := false;
  edtIncrValue.Enabled := false;
  edit_pwdcomfir.Enabled := false;

end;

procedure Tfrm_Frontoperate_incvalue.FormClose(Sender: TObject; var Action: TCloseAction);
var
  i: integer;
begin
  orderLst.Free();
  recDataLst.Free();
  comReader.StopComm();
  for i := 0 to ComponentCount - 1 do
  begin
    if components[i] is TEdit then
    begin
      (components[i] as TEdit).Clear;
    end
  end;
end;



procedure Tfrm_Frontoperate_incvalue.Bitn_CloseClick(Sender: TObject);
begin
  Close;
end;


//手动充值保存确认 //Bitn_IncvalueComfir

procedure Tfrm_Frontoperate_incvalue.btnOffLineRechargeClick(
  Sender: TObject);

var
  INC_value: string;
  strValue: string;
  i: integer;
begin
  if edtIncrValue.Text = '' then
  begin
    MessageBox(handle, '充值额不能为0!', '错误', MB_ICONERROR + MB_OK);
    exit;
  end
  else
  begin
    Operate_No := 1;
    INC_value := TrimRight(edtIncrValue.Text); //充值数值
    strValue := caluSendCMD(CMD_COUMUNICATION.CMD_INCValue, INC_value); //计算充值指令
    generateIncrValueCMD(strValue); //写入电子币,什么时候写入数据库? 收到卡头返回的正确写入电子币后
  end;

end;

//edit充值金额校验

procedure Tfrm_Frontoperate_incvalue.edtIncrValueKeyPress(Sender: TObject;
  var Key: Char);
var
  strtemp: string;
  strvalue: Double;
begin

  if not (key in ['0'..'9', #8, #13]) then
  begin
    key := #0;
    ShowMessage('输入错误，只能输入数字！');
  end
  else if key = #13 then
  begin
    if (StrToInt(edtIncrValue.Text) * StrToInt(SystemWorkground.ErrorGTState)) > (StrToInt(INit_Wright.MaxValue)) then
    begin
      strtemp := IntToStr(StrToInt(INit_Wright.MaxValue) div StrToInt(SystemWorkground.ErrorGTState));
      ShowMessage('输入错误，因为您设定的用户币保护上限值为' + INit_Wright.MaxValue + ',只能输入小于' + strtemp + '的数值！');
      exit;
    end;

    if (edtIncrValue.Text = '') or ((StrToInt(edtIncrValue.Text) mod 10) <> 0) then
    begin
      ShowMessage('输入错误，请输入10的倍数数值！');
      exit;
    end
    else
    begin
      if (length(TrimRight(Edit_TotalbuyValue.Text)) <> 0) and (length(TrimRight(Edit_TotalChangeValue.Text)) <> 0) then
      begin
        strvalue := (StrToFloat(Edit_TotalbuyValue.Text) - StrToFloat(Edit_TotalChangeValue.Text));
      end
      else if (length(TrimRight(Edit_TotalbuyValue.Text)) <> 0) and (length(TrimRight(Edit_TotalChangeValue.Text)) = 0) then
      begin
        strvalue := (StrToFloat(Edit_TotalbuyValue.Text));
      end
      else if (length(TrimRight(Edit_TotalbuyValue.Text)) = 0) and (length(TrimRight(Edit_TotalChangeValue.Text)) <> 0) then
      begin
        strvalue := 0;
      end
      else if (length(TrimRight(Edit_TotalbuyValue.Text)) = 0) and (length(TrimRight(Edit_TotalChangeValue.Text)) = 0) then
      begin
        strvalue := 0;
      end;
      if Edit_TotalbuyValue.Text = '' then
        Edit_Totalvale.Text := FloatToStr(StrToFloat(edtIncrValue.Text))
      else
        Edit_Totalvale.Text := FloatToStr(StrToFloat(edtIncrValue.Text) + StrToFloat(Edit_TotalbuyValue.Text));

      Edit_Pwdcomfir.Enabled := True;
      Edit_Pwdcomfir.SetFocus;
    end;
  end;

end;

 //充值密码正则表达式校验

procedure Tfrm_Frontoperate_incvalue.Edit_PwdcomfirKeyPress(
  Sender: TObject; var Key: Char);
var
  strtemp: string;
  strvalue: Double;
begin

  if not (key in ['0'..'9', #8, #13]) then
  begin
    key := #0;
    ShowMessage('输入错误，只能输入数字！');
  end
  else if key = #13 then
  begin
    if (Edit_Pwdcomfir.Text <> '') and (TrimRight(Edit_Pwdcomfir.Text) = TrimRight(Edit_Prepassword.Text)) then
    begin
      btnOffLineRecharge.Enabled := True;
      cbBatchRecharge.Enabled := True;
    end
    else
    begin
      ShowMessage('输入错误，请输入长度为6位的密码！');
      exit;
    end;
  end;

end;


//初始化充值写卡操作

procedure Tfrm_Frontoperate_incvalue.initIncrOperation;
var
  INC_value: string;
  strValue: string;
begin
  begin
    Operate_No := 1;
    INC_value := edtIncrValue.Text; //充值数值
    strValue := caluSendCMD(CMD_COUMUNICATION.CMD_INCValue, INC_value); //计算充值指令
    generateIncrValueCMD(strValue); //把充值指令写入ID卡
  end;
end;
//充值函数

//生成充值的操作指令

procedure Tfrm_Frontoperate_incvalue.generateIncrValueCMD(S: string);
begin
  orderLst.Clear();
  recDataLst.Clear();
  curOrderNo := 0;
  curOperNo := 2;
  orderLst.Add(S); //将充值指令写入缓冲
  prcSendDataToCard(); //写入卡头　
end;

//计算充值指令

function Tfrm_Frontoperate_incvalue.caluSendCMD(StrCMD: string; StrIncValue: string): string;
var
  TmpStr_IncValue: string; //充值数字
  TmpStr_CheckSum: string; //校验和
  TmpStr_SendCMD: string; //指令内容
  reTmpStr: string;
begin
  Send_CMD_ID_Infor.CMD := StrCMD; //帧命令头部51
  Send_CMD_ID_Infor.ID_INIT := Receive_CMD_ID_Infor.ID_INIT;

  if iHHSet = 0 then //时间限制设置无效
  begin
    Send_CMD_ID_Infor.ID_3F := IntToHex(0, 2) + IntToHex(0, 2) + IntToHex(0, 2);
    Send_CMD_ID_Infor.Password_3F := IntToHex(0, 2) + IntToHex(0, 2) + IntToHex(0, 2);
  end
  else //起用时间设置
  begin
    getExpireTime;
  end;

    //------------20120320追加写币有效期 结束-----------
  Send_CMD_ID_Infor.Password_USER := Receive_CMD_ID_Infor.Password_USER;
//  SystemWorkground.ErrorGTState代币比例
  TmpStr_IncValue := IntToStr(StrToInt(StrIncValue) * StrToInt(SystemWorkground.ErrorGTState));
  Send_CMD_ID_Infor.ID_value := ICFunction.transferDECValueToHEXByte(TmpStr_IncValue);
    //卡功能类型
  Send_CMD_ID_Infor.ID_type := Receive_CMD_ID_Infor.ID_type;
    //汇总发送内容
  TmpStr_SendCMD := Send_CMD_ID_Infor.CMD + Send_CMD_ID_Infor.ID_INIT + Send_CMD_ID_Infor.ID_3F + Send_CMD_ID_Infor.Password_3F
    + Send_CMD_ID_Infor.Password_USER + Send_CMD_ID_Infor.ID_value + Send_CMD_ID_Infor.ID_type;
    //将发送内容进行校核计算
  TmpStr_CheckSum := CheckSUMData(TmpStr_SendCMD);
    //TmpStr_CheckSum字节需要重新排布 ，低字节在前，高字节在后
  Send_CMD_ID_Infor.ID_CheckNum := transferCheckSumByte(TmpStr_CheckSum);
  Send_CMD_ID_Infor.ID_Settime := Receive_CMD_ID_Infor.ID_Settime;
  //ID_settime没有发送

  reTmpStr := TmpStr_SendCMD + Send_CMD_ID_Infor.ID_CheckNum;

  result := reTmpStr;

end;

//取得电子币的到期时间 expiretime

procedure Tfrm_Frontoperate_incvalue.getExpireTime;
var
  strtemp: string;
  iYear, iMonth, iDate, iHH, iMin: integer;
begin
  strtemp := FormatDateTime('yyyy-MM-dd HH:mm:ss', now);
  iYear := strToint(Copy(strtemp, 1, 4)); //年
  iMonth := strToint(Copy(strtemp, 6, 2)); //月
  iDate := strToint(Copy(strtemp, 9, 2)); //日
  iHH := strToint(Copy(strtemp, 12, 2)); //小时
  iMin := strToint(Copy(strtemp, 15, 2)); //分钟

  if (iHHSet > 47) then
  begin
    showmessage('为了保护您场地利益安全，请设定币有效时间小于48');
    exit;
  end;
   //因为iHH：0~24，故iHHSet也就是0~24小时 ，所以 (iHH+iHHSet)就为0~48小时
   //首先其分 (iHH+iHHSet)就为24~48小时 即为1天有效
  if ((iHH + iHHSet) >= 24) and ((iHH + iHHSet) < 48) then
  begin
    iHH := (iHH + iHHSet) - 24; //取得新的小时
    if (iYear < 1930) then
    begin
      showmessage('系统时间的年份设定错误，请与卡头对时同步');
      exit;
    end;
    if (iMonth = 2) then
    begin
      if ((iYear mod 4) = 0) or ((iYear mod 100) = 0) then //闰年 2月为28日
      begin
        if (iDate = 28) then
        begin
          iDate := 1;
          iMonth := iMonth + 1;
        end
        else
        begin
          iDate := iDate + 1;
        end;
      end
      else //不是闰年  2月为29日
      begin
        if (iDate = 29) then
        begin
          iDate := 1;
          iMonth := iMonth + 1;
        end
        else
        begin
          iDate := iDate + 1;
        end;
      end;
    end
    else if (iMonth = 1) or (iMonth = 3) or (iMonth = 5) or (iMonth = 7) or (iMonth = 8) or (iMonth = 10) then
    begin
      if (iDate = 31) then
      begin
        iDate := 1;
        iMonth := iMonth + 1;
      end
      else
      begin
        iDate := iDate + 1;
      end;
    end
    else if (iMonth = 12) then
    begin
      if (iDate = 31) then
      begin
        iDate := 1;
        iMonth := 1;
        iYear := iYear + 1;
      end
      else
      begin
        iDate := iDate + 1;
      end;
    end
    else if (iMonth = 4) or (iMonth = 6) or (iMonth = 9) or (iMonth = 11) then
    begin
      if (iDate = 30) then
      begin
        iDate := 1;
        iMonth := iMonth + 1;
      end
      else
      begin
        iDate := iDate + 1;
      end;
    end;
  end
   //其次，其分 (iHH+iHHSet)就为0~24小时 即为小于1天有效
  else if ((iHH + iHHSet) < 24) then
  begin
    iHH := (iHH + iHHSet); //取得新的小时
  end;

     //转换为16进制后
     //strtemp=now   Copy(strtemp, 3, 2)=

  Send_CMD_ID_Infor.ID_3F := IntToHex(iMonth, 2) + IntToHex(iHH, 2) + IntToHex(strtoint(Copy(strtemp, 3, 2)), 2);
  Send_CMD_ID_Infor.Password_3F := IntToHex(iDate, 2) + IntToHex(iMin, 2) + IntToHex(strtoint(Copy(strtemp, 1, 2)), 2);
end;




//校验和，确认是否正确

function Tfrm_Frontoperate_incvalue.checkSUMData(orderStr: string): string;
var
  i, j, k: integer;
  TmpStr: string;
  reTmpStr: string;
begin
  if (length(orderStr) mod 2) <> 0 then
  begin
    MessageBox(handle, '传入参数长度错误!', '错误', MB_ICONERROR + MB_OK);
    result := '';
    exit;
  end;
  k := 0;
  for i := 1 to (length(orderStr) div 2) do
  begin
    tmpStr := copy(orderStr, i * 2 - 1, 2);
    j := strToint('$' + tmpStr);
    k := k + j;

  end;
  reTmpStr := IntToHex(k, 2);
  result := reTmpStr;
end;


//校验和转换成16进制并排序 字节LL、字节LH

function Tfrm_Frontoperate_incvalue.transferCheckSumByte(StrCheckSum: string): string;
var
  j: integer;
  tempLH, tempLL: integer; //2147483648 最大范围

begin
  j := strToint('$' + StrCheckSum); //将字符转转换为16进制数，然后转换位10进制
  tempLH := (j mod 65536) div 256; //字节LH
  tempLL := j mod 256; //字节LL

  result := IntToHex(tempLL, 2) + IntToHex(tempLH, 2);
end;

end.
