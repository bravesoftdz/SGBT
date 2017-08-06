unit untCoinRecharge;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Grids, DBGrids, SPComm, DB, ADODB, uLkJSON, StrUtils;

type
  TfrmCoinRecharge = class(TForm)
    Panel1: TPanel;
    GroupBox2: TGroupBox;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    edtCoinID: TEdit;
    btnSubmit: TButton;
    btnCancel: TButton;
    GroupBox3: TGroupBox;
    dbgrdCoinRecharge: TDBGrid;
    dsCoinRecharge: TDataSource;
    commRecharge: TComm;
    ADOQCoinRecharge: TADOQuery;
    lblMessage: TLabel;

    lbl1: TLabel;
    edtLeftCoin: TEdit;
    cbRechargeCoin: TComboBox;
    lbl2: TLabel;
    chkAutoRecharge: TCheckBox;
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
    procedure saveCoinRechargeRecord(opercoin:string);
    procedure updateCoinRechargeRecord(coinid:string;opercoin :string);
    function checkUniqueRechargeRecord(coinid: string): Boolean;
        //卡头处理函数
    procedure checkCMDInfo();
    procedure operateCoin(operacoin: string); //卡处理
    function  caluSendCMD(strCMD: string; strIncrValue: string): string;
    procedure generateIncrValueCMD(S: string);
    procedure prcSendDataToCard();
    procedure displayCardInformation();
    procedure returnFromOperationCMD();
    procedure returnFromReadCMD();
    procedure initcbRechargeCoin();
  end;

var
  frmCoinRecharge: TfrmCoinRecharge;
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
  globalOperCoin : string; //操作金额
  globalOperType : string; //操作方式01充值,02消费
  operaSuccess : boolean;


implementation
uses ICDataModule, ICCommunalVarUnit, ICmain, ICEventTypeUnit, ICFunctionUnit, dateProcess, strprocess,
IdHashMessageDigest, IdHTTP
,untCoinInitialRecord;
{$R *.dfm}


procedure TfrmCoinRecharge.FormShow(Sender: TObject);
begin  
  //初始化界面
  initcbRechargeCoin();
  //初始化数据库数据
  initDBRecord();
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

function TfrmCoinRecharge.initDBRecord(): string;
var
  strSQL: string;
begin
  with ADOQCoinRecharge do begin
    Connection := DataModule_3F.ADOConnection_Main;
    Active := false;
    SQL.Clear;
    strSQL := ' select ID,COIN_ID,OPER_COIN,OPERATE_TIME, OPERATOR_NO ' +
             ' from T_COIN_RECHARGE ' +
             ' order by OPERATE_TIME desc limit 10';
    ICFunction.loginfo('strSQL: ' + strSQL);
    SQL.Add(strSQL);
    Active := True;
  end;
  result := '';

end;


procedure TfrmCoinRecharge.commRechargeReceiveData(Sender: TObject; Buffer: Pointer;
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


procedure TfrmCoinRecharge.checkCMDInfo();
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
    returnFromOperationCMD();//操作返回
  end;

end;


//卡头返回充值成功指令

procedure TfrmCoinRecharge.returnFromOperationCMD();
var coinid,operCoin:string;
begin 
   //操作成功
  ICFunction.loginfo('return From OperationCMD Operate Coin Successfully ');
  coinid  :=Trim(edtCoinID.Text);
  operCoin := cbRechargeCoin.Text;
  
  if (edtLeftCoin.Text <> '0')  and (checkUniqueRechargeRecord(coinid) = True )then
    updateCoinRechargeRecord(coinid,operCoin)
  else
    saveCoinRechargeRecord(operCoin);
    
  initDBRecord();
  lblMessage.Caption := '电子币充值成功';
end;


function TfrmCoinRecharge.checkUniqueRechargeRecord(coinid: string): Boolean;
var
  ADOQ: TADOQuery;
  strSQL :String;
begin
  ADOQ := TADOQuery.Create(Self);
  ADOQ.Connection := DataModule_3F.ADOConnection_Main;

  with ADOQ do begin
    Close;
    SQL.Clear;
    strSQL := 'select 1 from T_COIN_RECHARGE where COIN_ID=''' + coinid + '''';
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


//卡头返回信息读取指令

procedure TfrmCoinRecharge.returnFromReadCMD();
begin
  Receive_CMD_ID_Infor.ID_INIT := copy(recDataLst.Strings[0], 3, 8); //卡片ID
  Receive_CMD_ID_Infor.ID_3F := copy(recDataLst.Strings[0], 11, 6); //卡厂ID
  Receive_CMD_ID_Infor.Password_3F := copy(recDataLst.Strings[0], 17, 6); //appid
  Receive_CMD_ID_Infor.Password_USER := copy(recDataLst.Strings[0], 23, 6); //shopid
  Receive_CMD_ID_Infor.ID_value := copy(recDataLst.Strings[0], 29, 8); //卡内数据
  Receive_CMD_ID_Infor.ID_type := copy(recDataLst.Strings[0], 37, 2); //卡功能

  displayCardInformation();
  if frmCoinInitial.checkUniqueCoinID(Receive_CMD_ID_Infor.ID_INIT) = false then //用户卡已经初始化 有记录
   begin
      lblMessage.Caption := '请先初始化！';
      exit;
  end;  
  //自动充值
  if chkAutoRecharge.Checked then
    operateCoin( cbRechargeCoin.Text);

end;



procedure TfrmCoinRecharge.displayCardInformation();
begin
  edtCoinID.Text := Receive_CMD_ID_Infor.ID_INIT;
  edtLeftCoin.Text := ICFunction.transferHEXByteToDECValue(Receive_CMD_ID_Infor.ID_value);

  
end;



procedure TfrmCoinRecharge.operateCoin(operacoin: string);
var
  coinvalue: string;
begin
  coinvalue := caluSendCMD(CMD_COUMUNICATION.CMD_INCValue, operacoin); //计算充值指令
  generateIncrValueCMD(coinvalue); //把充值指令写入ID卡
  ICFunction.loginfo('recharge data send to card: ' + coinvalue);
end;
//充值函数
//计算充值指令

function TfrmCoinRecharge.caluSendCMD(strCMD: string; strIncrValue: string): string;
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

procedure TfrmCoinRecharge.generateIncrValueCMD(S: string);
begin
  orderLst.Clear();
  recDataLst.Clear();
  curOrderNo := 0;
  curOperNo := 2;
  orderLst.Add(S); //将充值指令写入缓冲
  prcSendDataToCard(); //写入卡头　
end;

procedure TfrmCoinRecharge.prcSendDataToCard();
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







procedure TfrmCoinRecharge.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin

  orderLst.Free();
  recDataLst.Free();
  commRecharge.StopComm;

  edtCoinID.Text :='';
  edtLeftCoin.Text :='';
  

end;

//会员开户操作

procedure TfrmCoinRecharge.btnSubmitClick(Sender: TObject);
begin
  if frmCoinInitial.checkUniqueCoinID(Receive_CMD_ID_Infor.ID_INIT) = false then //用户卡已经初始化 有记录
   begin
      lblMessage.Caption := '请先初始化！';
      exit;
  end;
    //计算写卡的金额
  operateCoin( cbRechargeCoin.Text); //充值
  

end;

procedure TfrmCoinRecharge.btnCancelClick(Sender: TObject);
var
  totalcoin :string;

begin
  globalOperType := '02'; //消费

  //计算写卡的金额
  totalcoin := IntToStr(strToInt(edtLeftCoin.Text) -1);
  if StrToInt(totalcoin) < 1 then
  begin
     ShowMessage('余额不足,请先充值');
     exit;
  end;

  operateCoin( totalcoin );   
  lblMessage.Caption := '会员消费成功';
end;




procedure TfrmCoinRecharge.saveCoinRechargeRecord(opercoin:string);
var
   coinid, strOperateTime, strOperatorNO, strsql: string;

begin    
  ICFunction.loginfo('Begin save Coin RechargeRecord ');
  coinid := trim(edtCoinID.Text);

    //指定日期格式 重要
  ShortDateFormat := 'yyyy-MM-dd'; //指定格式即可
  DateSeparator := '-';
    //指定日期格式 否则会报is not an valid date and time;
  strOperateTime := FormatDateTime('yyyy-MM-dd HH:mm:ss', now);
  strOperatorNO := G_User.UserNO;
  
  with ADOQCoinRecharge do begin
    Connection := DataModule_3F.ADOConnection_Main;
    Active := false;
    SQL.Clear;
    strSQL := 'select * from T_COIN_RECHARGE order by operate_time desc';
    ICFunction.loginfo('strSQL :' + strSQL);
    SQL.Add(strSQL);
    Active := True;
    Append;
    FieldByName('COIN_ID').AsString := coinid;
    FieldByName('OPER_COIN').AsInteger := StrToInt(opercoin);
    FieldByName('OPERATE_TIME').AsString := strOperateTime;
    FieldByName('OPERATOR_NO').AsString := strOperatorNO;
    post;
  end;
  ICFunction.loginfo('End saveMemberRechargeRecord ');
end;



procedure TfrmCoinRecharge.updateCoinRechargeRecord(coinid:string;opercoin :string);
var
  ADOQ: TADOQuery;
  strSQL, MaxID,operationcoin,leftcoin: string;  
begin
  ICFunction.loginfo('Begin update Coin Recharge Record ');

  //找到最新那条记录
  strSQL := 'select max(ID) from T_COIN_RECHARGE where COIN_ID=''' + coinid + '''';
  ICFunction.loginfo('strSQL: ' + strSQL );

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


  strSQL := ' select OPER_COIN, operate_time,OPERATOR_NO from  '
    + ' T_COIN_RECHARGE where  ID = ''' + MaxID + '''';
  ICFunction.loginfo('strSQL: ' + strSQL );

  //指定日期格式 重要
  ShortDateFormat := 'yyyy-MM-dd'; //指定格式即可
  DateSeparator := '-';
  //指定日期格式 否则会报is not an valid date and time;

  ADOQ := TADOQuery.Create(nil);
  with ADOQ do begin
    Connection := DataModule_3F.ADOConnection_Main;
    Active := false;
    SQL.Clear;
    SQL.Add(strSQL);
    Active := true;
    if (RecordCount > 0) then begin
      Edit;
      FieldByName('OPER_COIN').AsInteger := strToInt(opercoin);
      FieldByName('OPERATE_TIME').AsString := FormatDateTime('yyyy-MM-dd HH:mm:ss',Now);
      FieldByName('OPERATOR_NO').AsString  := G_User.UserNO;      
      Post;
    end;
    Active := False;
  end;
  FreeAndNil(ADOQ);

  ICFunction.loginfo('End updateCoinRechargeRecord ');
 end;


 
procedure TfrmCoinRecharge.initcbRechargeCoin();
begin
  cbRechargeCoin.Items.Clear;
  cbRechargeCoin.Items.Add('1');
  cbRechargeCoin.Items.Add('2');
  cbRechargeCoin.Items.Add('5');  
  cbRechargeCoin.Items.Add('10');
  cbRechargeCoin.Items.Add('20');
  cbRechargeCoin.Items.Add('50');
  cbRechargeCoin.Items.Add('100');
  cbRechargeCoin.Items.Add('200');
  cbRechargeCoin.Items.Add('500');
  cbRechargeCoin.Items.Add('1000');
  cbRechargeCoin.Items.Add('2000');
    
end;



end.

