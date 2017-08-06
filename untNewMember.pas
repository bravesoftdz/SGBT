unit untNewMember;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Grids, DBGrids, SPComm, DB, ADODB, uLkJSON, StrUtils;

type
  TfrmNewMember = class(TForm)
    Panel1: TPanel;
    GroupBox2: TGroupBox;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    edtBandID: TEdit;
    Label2: TLabel;
    edtShopID: TEdit;
    Label3: TLabel;
    edtMobileNO: TEdit;
    Label4: TLabel;
    edtMemberNO: TEdit;
    btnSubmit: TButton;
    btnCancel: TButton;
    GroupBox3: TGroupBox;
    dgRecharge: TDBGrid;
    dsRecharge: TDataSource;
    commRecharge: TComm;
    ADOQ: TADOQuery;
    lblMessage: TLabel;
    Label5: TLabel;
    edtAPPID: TEdit;
    Label6: TLabel;
    cbMemberType: TComboBox;
    procedure commRechargeReceiveData(Sender: TObject; Buffer: Pointer;
      BufferLength: Word);
    procedure FormShow(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnSubmitClick(Sender: TObject);


  private
    { Private declarations }
  public
    { Public declarations }

        //数据库相关
    function initDBRecord(): string;
    procedure saveMemberInfo(cardid:string; cardtype:string;mobileno:string);

    function  getCoinByCoinType(cointype :string):string;
  
    
        //卡头处理函数
    procedure checkCMDInfo();
    procedure operateCoin(operacoin: string); //卡处理
    function caluSendCMD(strCMD: string; strIncrValue: string): string;
    procedure generateIncrValueCMD(S: string);
    procedure prcSendDataToCard();
    procedure displayCardInformation();
    procedure returnFromOperationCMD();
    procedure returnFromReadCMD();
    function  checkCoinLimit(strWriteValue: string): boolean;
    function  checkUniqueCoin(coinid: string): boolean;
    procedure initComboxCardtype();

    function  getCoinCodeByCoinType(cardtype:string):string;
    function  getCoinLimit(cardtype :string):string;
    function  getExpireTimeByCoinType(cardtype :string):string;

  end;

var
  frmNewMember: TfrmNewMember;
  curOrderNo: integer = 0; //???
  curOperNo: integer = 0;
  Operate_No: integer = 0; //什么作用?标记正在充值？
  orderLst, recDataLst: Tstrings; //定义全局变量发送数据，接收数据
  ID_UserCard_Text: string;
  IncValue_Enable: boolean; //是否允许充值的标志,会员卡认证通过后置为True
  buffer: array[0..2048] of byte;

  //全局变量用来共享SG3F平台事务ID;
  GLOBALsg3ftrxID: string; //
  GLOBALstrPayID: string; //支付方式　在线01/现金02
  operaSuccess : boolean;


implementation
uses ICDataModule, ICCommunalVarUnit, ICmain, ICEventTypeUnit, ICFunctionUnit, dateProcess, strprocess, IdHashMessageDigest, IdHTTP;
{$R *.dfm}


procedure TfrmNewMember.FormShow(Sender: TObject);
begin  
  //初始化界面
  initComboxCardtype();
  
  //初始化数据库数据
  initDBRecord();

  //初始化公共变量
  edtAPPID.Text := SGBTCONFIGURE.appid;
  edtShopID.Text := SGBTCONFIGURE.shopid;


  //初始化串口
  orderLst := TStringList.Create;
  recDataLst := tStringList.Create;
  try
    commRecharge.StartComm();
  except on E: Exception do //拦截所有异常
    begin
      showmessage(SG3FERRORINFO.commerror + e.message);
      exit;
    end;
  end;
end;

function TfrmNewMember.initDBRecord(): string;
var
  strSQL: string;
begin
  with ADOQ do begin
    Connection := DataModule_3F.ADOConnection_Main;
    Active := false;
    SQL.Clear;
    strSQL := 'select CARD_ID,MOBILE_NO,COIN_TYPE,TOTAL_COIN,STATE,EXPIRETIME,APPID,SHOPID ' +
            ' ,OPERATE_TIME, OPERATORNO ' +
             ' from T_MEMBER_INFO ' +
             '  order by OPERATE_TIME desc limit 10';
    ICFunction.loginfo('strSQL: ' + strSQL);
    SQL.Add(strSQL);
    Active := True;
  end;
  result := '';

end;


procedure TfrmNewMember.commRechargeReceiveData(Sender: TObject; Buffer: Pointer;
  BufferLength: Word);
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


procedure TfrmNewMember.checkCMDInfo();
var
  tmpStr: string;
begin
   //首先截取接收的信息

  tmpStr := recDataLst.Strings[0];
  ICCommunalVarUnit.Receive_CMD_ID_Infor.ID_CheckNum := copy(tmpStr, 39, 4); //校验和
  ICCommunalVarUnit.CMD_CheckSum_OK := true;
  ICCommunalVarUnit.Receive_CMD_ID_Infor.CMD := copy(recDataLst.Strings[0], 1, 2); //帧头43
 
  ICFunction.loginfo('Read data return from Terminal : ' + tmpStr);
  if ICCommunalVarUnit.Receive_CMD_ID_Infor.CMD = CMD_COUMUNICATION.CMD_READ then //收到卡头写入电子币充值成功的返回 53
  begin
    returnFromReadCMD();//读返回
  end
  else if Receive_CMD_ID_Infor.CMD = ICCommunalVarUnit.CMD_COUMUNICATION.CMD_INCValue_RE then //读指令
  begin
    returnFromOperationCMD();  //操作返回
  end;

end;


//卡头返回充值成功指令

procedure TfrmNewMember.returnFromOperationCMD();
var cardid,cardtype,mobileno:string;
begin 
   //操作成功      
  ICFunction.loginfo('return From OperationCMD Operate Coin Successfully ');
  cardid  :=Trim(edtBandID.Text);
  cardtype :=Trim(cbMemberType.Text);
  mobileno :=Trim(edtMobileNO.Text);
  saveMemberInfo(cardid,cardtype,mobileno);

  initDBRecord();

end;


//卡头返回信息读取指令

procedure TfrmNewMember.returnFromReadCMD();
begin
  Receive_CMD_ID_Infor.ID_INIT := copy(recDataLst.Strings[0], 3, 8); //卡片ID
  Receive_CMD_ID_Infor.ID_3F := copy(recDataLst.Strings[0], 11, 6); //卡厂ID
  Receive_CMD_ID_Infor.Password_3F := copy(recDataLst.Strings[0], 17, 6); //appid
  Receive_CMD_ID_Infor.Password_USER := copy(recDataLst.Strings[0], 23, 6); //shopid
  Receive_CMD_ID_Infor.ID_value := copy(recDataLst.Strings[0], 29, 8); //卡内数据
  Receive_CMD_ID_Infor.ID_type := copy(recDataLst.Strings[0], 37, 2); //卡功能

//  if DataModule_3F.queryExistInitialRecord(Receive_CMD_ID_Infor.ID_INIT) = false then //用户卡已经初始化 有记录
//  begin
//      lblMessage.Caption := '请先初始化！';
//      exit;
//  end
//  else
//  begin
      displayCardInformation();
 //end;


end;   


procedure TfrmNewMember.displayCardInformation();
begin
  edtBandID.Text := Receive_CMD_ID_Infor.ID_INIT;
  edtMemberNO.Text := Receive_CMD_ID_Infor.ID_INIT;
  //edtMobileNO.Text := 
  //read from Database by CardID and display in View todo...
  
end;



procedure TfrmNewMember.operateCoin(operacoin: string);
var
  coinvalue: string;
begin
  coinvalue := caluSendCMD(CMD_COUMUNICATION.CMD_INCValue, operacoin); //计算充值指令
  generateIncrValueCMD(coinvalue); //把充值指令写入ID卡
  ICFunction.loginfo('recharge data send to card: ' + coinvalue);
end;
//充值函数
//计算充值指令

function TfrmNewMember.caluSendCMD(strCMD: string; strIncrValue: string): string;
var
  TmpStr_CheckSum: string; //校验和
  TmpStr_SendCMD: string; //指令内容
  reTmpStr: string;
begin
  Send_CMD_ID_Infor.CMD := StrCMD; //帧命令头部51
  Send_CMD_ID_Infor.ID_INIT := Receive_CMD_ID_Infor.ID_INIT;
  Send_CMD_ID_Infor.ID_3F := FormatDateTime('yyMMdd', now);
  Send_CMD_ID_Infor.Password_3F := Receive_CMD_ID_Infor.Password_3F; ;
  Send_CMD_ID_Infor.Password_USER := SGBTCONFIGURE.shopid;
  Send_CMD_ID_Infor.ID_value := ICFunction.transferDECValueToHEXByte(strIncrValue);
  Send_CMD_ID_Infor.ID_type := Receive_CMD_ID_Infor.ID_type;
  TmpStr_SendCMD := Send_CMD_ID_Infor.CMD + Send_CMD_ID_Infor.ID_INIT + Send_CMD_ID_Infor.ID_3F + Send_CMD_ID_Infor.Password_3F
    + Send_CMD_ID_Infor.Password_USER + Send_CMD_ID_Infor.ID_value + Send_CMD_ID_Infor.ID_type;

  TmpStr_CheckSum := ICFunction.checkSUMData(TmpStr_SendCMD);
  Send_CMD_ID_Infor.ID_CheckNum := ICFunction.transferCheckSumByte(TmpStr_CheckSum);
  reTmpStr := TmpStr_SendCMD + Send_CMD_ID_Infor.ID_CheckNum;
  result := reTmpStr;

end;


//生成充值的操作指令

procedure TfrmNewMember.generateIncrValueCMD(S: string);
begin
  orderLst.Clear();
  recDataLst.Clear();
  curOrderNo := 0;
  curOperNo := 2;
  orderLst.Add(S); //将充值指令写入缓冲
  prcSendDataToCard(); //写入卡头　
end;

procedure TfrmNewMember.prcSendDataToCard();
var
  orderStr: string;
begin
  if orderLst.Count > curOrderNo then
  begin
    orderStr := orderLst.Strings[curOrderNo];
    orderStr := ICFunction.funcTransferExchData(orderStr);
    commRecharge.WriteCommData(pchar(orderStr), length(orderStr)); //真正写到卡头
    inc(curOrderNo); //累加
  end;
end;


procedure TfrmNewMember.btnCancelClick(Sender: TObject);
var
  ADOQ: TADOQuery;
  strSQL, strTemp: string;
begin
  strSQL := 'select state,operate_time,OPERATORNO from  '
    + ' t_member_info where card_id = ''' + edtBandID.Text + '''';
  strTemp := '';
  ADOQ := TADOQuery.Create(nil);
  with ADOQ do begin
    Connection := DataModule_3F.ADOConnection_Main;
    Active := false;
    SQL.Clear;
    SQL.Add(strSQL);
    Active := true;

    if (RecordCount > 0) then begin
      Edit;
      FieldByName('STATE').AsString := '销户';  
      FieldByName('OPERATE_TIME').AsString := FormatDateTime('yyyy-MM-dd HH:mm:ss',Now);
      FieldByName('OPERATORNO').AsString  := SGBTCONFIGURE.shopid;      
      Post;
    end;
    Active := False;
  end;
  FreeAndNil(ADOQ);
  initDBRecord();
  lblMessage.Caption := '会员卡销户完成';

end;


//风控限额

function TfrmNewMember.checkCoinLimit(strWriteValue: string): boolean;
begin
  result := false;
  if strToInt(strWriteValue) > strToInt(SGBTCONFIGURE.COINLIMIT) then
    result := true;

end;

function TfrmNewMember.checkUniqueCoin(coinid: string): boolean;
var
  ADOQ: TADOQuery;
  strSQL :String;
begin
  ADOQ := TADOQuery.Create(Self);
  ADOQ.Connection := DataModule_3F.ADOConnection_Main;

  with ADOQ do begin
    Close;
    SQL.Clear;
    strSQL := 'select 1 from t_member_info where CARD_ID=''' + coinid + '''';
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


procedure TfrmNewMember.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin

  orderLst.Free();
  recDataLst.Free();
  commRecharge.StopComm;

end;

//会员开户操作

procedure TfrmNewMember.btnSubmitClick(Sender: TObject); 
var
  operationcoin:string;

begin
  //Coin层操作
  if checkUniqueCoin(Trim(edtBandID.Text)) = true then
  begin
         lblMessage.Caption := '会员已存在';
         exit;
  end;
  if( (IsNumberic(edtMobileNO.Text) = False) or (Length(edtMobileNO.Text)<> 11) ) then
  begin
      ShowMessage('请输入正确的数字');
      exit
  end;
//  operationcoin := getCoinByCoinType(Trim(cbMemberType.Text));
  operationcoin := Trim(cbMemberType.Text);
  operateCoin(operationcoin);
  
  lblMessage.Caption := '会员开户成功';

end;


function  TfrmNewMember.getCoinCodeByCoinType(cardtype:string):string;
begin
    if cardtype = '年卡' then
      result := '01'
    else if cardtype = '季卡' then
      result:='02'
    else if cardtype = '月卡' then
      result:='03'
   else if cardtype = '普通卡' then
      result:='04' ;
end;

function  TfrmNewMember.getCoinByCoinType(cointype :string):string;
var
  ADOQTemp: TADOQuery;
  strSQL: string;
  strWhere: string;

begin
  ADOQTemp := TADOQuery.Create(nil);

  strSQL := 'select COIN_VALUE from T_MEMBER_CARD_CONFIGURATION where COIN_TYPE=''' + cointype + '''';
  ICFunction.loginfo('strSQL: ' + strSQL );
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

function  TfrmNewMember.getCoinLimit(cardtype :string):string;
begin
    result := '1000';
end;


function  TfrmNewMember.getExpireTimeByCoinType(cardtype :string):string;
begin
    if cardtype = '年卡' then
      result :=FormatDateTime('yyyy-MM-dd HH:mm:ss', AddMonths(now,12))
    else if cardtype = '季卡' then
      result:=FormatDateTime('yyyy-MM-dd HH:mm:ss', AddMonths(now,3))
    else if cardtype = '月卡' then
      result:=FormatDateTime('yyyy-MM-dd HH:mm:ss', AddMonths(now,1))
    else if cardtype = '普通卡' then
      result:=FormatDateTime('yyyy-MM-dd HH:mm:ss', AddMonths(now,36)) ;
end;


//会员信息
procedure TfrmNewMember.saveMemberInfo(cardid:string; cardtype:string;mobileno:string);
var
  strAppID, strBandid, strShopid, strPayid, strOperateTime, strOperatorNO, strPayState, strNote, strExpireTime, strsql: string;
  intCoin, intLeftCoin, intTotalCoin: Integer;
begin
   strAppID := trim(edtAppID.Text);
   strShopid := trim(edtShopID.Text);
   strOperatorNO := SGBTCONFIGURE.shopid;
     with ADOQ do begin
    Connection := DataModule_3F.ADOConnection_Main;
    Active := false;
    SQL.Clear;
    ShortDateFormat := 'yyyy-MM-dd'; //指定格式即可
    DateSeparator := '-';
    strOperateTime:=FormatDateTime('yyyy-MM-dd HH:mm:ss', now);
    strSQL := 'select * from t_member_info order by OPERATE_TIME desc limit 10 '; //为什么要查全部？
    ICFunction.loginfo('strSQL :' + strSQL);
    SQL.Add(strSQL);
    Active := True;
    Append;
    FieldByName('CARD_ID').AsString := cardid;
    FieldByName('PASSWORD').AsString := cardid;
    FieldByName('MOBILE_NO').AsString := mobileno;
    FieldByName('COIN_TYPE').AsString := cbMemberType.Text;
    FieldByName('PAY_TYPE').AsString := '01';
    FieldByName('TOTAL_COIN').AsString := getCoinByCoinType(cbMemberType.Text);
    FieldByName('COIN_LIMIT').AsString := getCoinLimit(cbMemberType.Text);
    FieldByName('STATE').AsString := '正常';
    FieldByName('EXPIRETIME').AsString := getExpireTimeByCoinType(cbMemberType.Text);
    FieldByName('APPID').AsString := strAppID;
    FieldByName('SHOPID').AsString := strShopid;
    FieldByName('OPERATE_TIME').AsString := strOperateTime;
    FieldByName('OPERATORNO').AsString := strOperatorNO;
    post;
  end;
     
end;

procedure TfrmNewMember.initComboxCardtype;
var
  ADOQTemp: TADOQuery;
  strSQL: string;
begin   
  ADOQTemp:=TADOQuery.Create(nil);
  strSQL:= 'select coin_type from t_member_card_configuration';
  with ADOQTemp do begin
    Connection := DataModule_3F.ADOConnection_Main;
    SQL.Clear;
    SQL.Add(strSQL);
    Active:=True;
    cbMemberType.Items.Clear;
    while not Eof do begin
      cbMemberType.Items.Add(FieldByName('coin_type').AsString);
      Next;
      end;
    end;
  FreeAndNil(ADOQTemp);

  
end;




end.

