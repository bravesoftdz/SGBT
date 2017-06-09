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
    edtLeftCoin: TEdit;
    Label4: TLabel;
    edtRechargeCoin: TEdit;
    btnOnlineRecharge: TButton;
    btnOfflineRecharge: TButton;
    GroupBox3: TGroupBox;
    dgRecharge: TDBGrid;
    dsRecharge: TDataSource;
    commRecharge: TComm;
    ADOQRecharge: TADOQuery;
    lblMessage: TLabel;
    Label5: TLabel;
    edtAPPID: TEdit;
    Label6: TLabel;
    edtTypeName: TEdit;
    procedure commRechargeReceiveData(Sender: TObject; Buffer: Pointer;
      BufferLength: Word);
    procedure FormShow(Sender: TObject);
    procedure btnOfflineRechargeClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnOnlineRechargeClick(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }

        //数据库相关
    function initRechargeRecord(): string;
    procedure saveRechargeRecord(); //保存充值记录
        //卡头处理函数
    procedure checkCMDInfo();
    procedure initIncrOperation(strRechargeCoin: string); //充值操作，写数据个卡
    function caluSendCMD(strCMD: string; strIncrValue: string): string;
    procedure generateIncrValueCMD(S: string);
    procedure prcSendDataToCard();
    procedure showCardInformation();
    procedure returnFromIncrCMD();
    procedure returnFromReadCMD();
    function checkCoinLimit(strWriteValue: string): boolean;

    //线下充值请求接口
    //function offlineRechargeApplyInterface() :TlkJSONbase;
    function generateOfflineRechargeApplyURL(): string;
    function getOfflineRechargeApplySignature(appId: string; bandId: string; coin: string; money: string; restCoin: string; shopId: string; timeStamp: string): string;

    //线下充值确认接口
  //  function offlineRechargeAckInterface() :TlkJSONbase;
    function generateOfflineRechargeAckURL(haokuTrxId: string; trxId: string): string;
    function getOfflineRechargeAckSignature(appId: string; bandId: string; haokuTrxId: string; shopId: string; timeStamp: string; trxId: string): string;



    //线上充值请求接口

    function generateOnlineRechargeApplyURL(): string;
    function getOnlineRechargeApplySignature(appId: string; bandId: string; restCoin: string; shopId: string; timeStamp: string): string;

    //线上充值确认接口
    function generateOnlineRechargeAckURL(haokuTrxId: string; trxId: string): string;
    function getOnlineRechargeAckSignature(appId: string; bandId: string; haokuTrxId: string; shopId: string; timeStamp: string; trxId: string): string;

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


implementation
uses ICDataModule, ICCommunalVarUnit, ICmain, ICEventTypeUnit, ICFunctionUnit, dateProcess, strprocess, IdHashMessageDigest, IdHTTP;
{$R *.dfm}


//-----------------------线上充值-----------------------------------------------------------------


 //线上充值申请接口URL

function TfrmNewMember.generateOnlineRechargeApplyURL(): string;
var
  strURL, appId, bandId, restCoin, shopId, timestamp, strSignature, strActiveURL, strhkscURL: string;
begin
  appId := SGBTCONFIGURE.appid;
  bandId := edtBandID.Text;
  restCoin := edtLeftCoin.Text;
  shopId := SGBTCONFIGURE.shopid;
  timestamp := getTimestamp();
  strSignature := getOnlineRechargeApplySignature(appId, bandId, restCoin, shopId, timestamp);
  strActiveURL := SGBTCONFIGURE.onlinepayapplyurl;
  strhkscURL := SGBTCONFIGURE.hkscURL;

  strURL := strhkscURL + strActiveURL
    + '?appId=' + appId
    + '&bandId=' + bandId
    + '&restCoin=' + restCoin
    + '&shopId=' + shopId
    + '&timestamp=' + timestamp
    + '&sign=' + strSignature;

  result := strURL;
end;



//线上充值申请签名算法

function TfrmNewMember.getOnlineRechargeApplySignature(appId: string; bandId: string; restCoin: string; shopId: string; timeStamp: string): string;
var
  strTempC, strTempD: string;
  myMD5: TIdHashMessageDigest5;
begin
  myMD5 := TIdHashMessageDigest5.Create;
  strTempC := 'appId' + appId
    + 'bandId' + bandId
    + 'restCoin' + restCoin
    + 'shopId' + shopId
    + 'timestamp' + timeStamp; //按字符顺序排序

  strTempD := strTempC + SGBTCONFIGURE.secret_key; //加上secret_key
  result := LowerCase(myMD5.AsHex(myMD5.HashValue(strTempD))); //计算字符串的MD5,并返回小写
  myMD5.Free;

end;





 //线上充值确认接口URL

function TfrmNewMember.generateOnlineRechargeAckURL(haokuTrxId: string; trxId: string): string;
var
  strURL, appId, bandId, shopId, timestamp, strSignature, strActiveURL, strhkscURL: string;
begin
  appId := SGBTCONFIGURE.appid;
  bandId := edtBandID.Text;
  //haokuTrxId := edtLeftCoin.Text; // 需要从响应中返回
  shopId := SGBTCONFIGURE.shopid;
  timestamp := getTimestamp();
  strSignature := getOnlineRechargeAckSignature(appId, bandId, haokuTrxId, shopId, timestamp, trxId); //字符顺序
  strActiveURL := SGBTCONFIGURE.onlinepayackurl;
  strhkscURL := SGBTCONFIGURE.hkscURL;

  strURL := strhkscURL + strActiveURL
    + '?appId=' + appId
    + '&bandId=' + bandId
    + '&haokuTrxId=' + haokuTrxId
    + '&shopId=' + shopId
    + '&trxId=' + trxId
    + '&timestamp=' + timestamp
    + '&sign=' + strSignature;
  result := strURL;
end;



//线上充值确认签名算法

function TfrmNewMember.getOnlineRechargeAckSignature(appId: string; bandId: string; haokuTrxId: string; shopId: string; timeStamp: string; trxId: string): string;
var
  strTempC, strTempD: string;
  myMD5: TIdHashMessageDigest5;
begin
  myMD5 := TIdHashMessageDigest5.Create;
  strTempC := 'appId' + appId
    + 'bandId' + bandId
    + 'haokuTrxId' + haokuTrxId
    + 'shopId' + shopId
    + 'timestamp' + timeStamp
    + 'trxId' + trxId; //按字符顺序排序

  strTempD := strTempC + SGBTCONFIGURE.secret_key; //加上secret_key
  result := LowerCase(myMD5.AsHex(myMD5.HashValue(strTempD))); //计算字符串的MD5,并返回小写
  myMD5.Free;

end;



//-----------------------线下充值-----------------------------------------------------------------



 //拼接线下充值申请接口URL

function TfrmNewMember.generateOfflineRechargeApplyURL(): string;
var
  strURL, strAppID, strShopID, strBandID, strCoin, strRestCoin, strMoney, strTimeStamp, strSignature, strActiveURL, strhkscURL: string;
begin
  strAppID := SGBTCONFIGURE.appid;
  strShopID := SGBTCONFIGURE.shopid;
  strBandID := edtBandID.Text;
  strCoin := edtRechargeCoin.Text;
  strRestCoin := edtLeftCoin.Text;
  strMoney := strCoin;
  strTimeStamp := getTimestamp();
  strSignature := getOfflineRechargeApplySignature(strAppID, strBandID, strCoin, strMoney, strRestCoin, strShopID, strTimeStamp);
  strActiveURL := SGBTCONFIGURE.offlinepayapplyurl;
  strhkscURL := SGBTCONFIGURE.hkscURL;

  strURL := strhkscURL + strActiveURL + '?appId=' + strAppID
    + '&bandId=' + strBandID
    + '&coin=' + strCoin
    + '&money=' + strMoney
    + '&restCoin=' + strRestCoin
    + '&shopId=' + strShopID
    + '&timestamp=' + strTimeStamp
    + '&sign=' + strSignature;

  result := strURL;
end;



//线下充值申请签名算法

function TfrmNewMember.getOfflineRechargeApplySignature(appId: string; bandId: string; coin: string; money: string; restCoin: string; shopId: string; timeStamp: string): string;
var
  strTempC, strTempD: string;
  myMD5: TIdHashMessageDigest5;
begin
  myMD5 := TIdHashMessageDigest5.Create;
  strTempC := 'appId' + appId
    + 'bandId' + bandId
    + 'coin' + coin
    + 'money' + money
    + 'restCoin' + restCoin
    + 'shopId' + shopId
    + 'timestamp' + timeStamp; //按字符顺序排序

  strTempD := strTempC + SGBTCONFIGURE.secret_key; //加上secret_key
  result := LowerCase(myMD5.AsHex(myMD5.HashValue(strTempD))); //计算字符串的MD5,并返回小写
  myMD5.Free;

end;




 //拼接线下充值确认接口URL

function TfrmNewMember.generateOfflineRechargeAckURL(haokuTrxId: string; trxId: string): string;
var
  strURL, appId, bandId, shopId, timestamp, strSignature, strActiveURL, strhkscURL: string;
begin
  appId := SGBTCONFIGURE.appid;
  bandId := edtBandID.Text;
  //  haokuTrxId  := edtLeftCoin.Text; // 需要从响应中返回
  shopId := SGBTCONFIGURE.shopid;
  timestamp := getTimestamp();
  //  trxId      :=  edtRechargeCoin.Text; // 需要从响应中返回

  strSignature := getOfflineRechargeAckSignature(appId, bandId, haokuTrxId, shopId, timestamp, trxId); //字符顺序
  strActiveURL := SGBTCONFIGURE.offlinepayackurl;
  strhkscURL := SGBTCONFIGURE.hkscURL;

  strURL := strhkscURL + strActiveURL
    + '?appId=' + appId
    + '&bandId=' + bandId
    + '&haokuTrxId=' + haokuTrxId
    + '&shopId=' + shopId
    + '&trxId=' + trxId
    + '&timestamp=' + timestamp
    + '&sign=' + strSignature;
  result := strURL;
end;



//线下充值确认签名算法

function TfrmNewMember.getOfflineRechargeAckSignature(appId: string; bandId: string; haokuTrxId: string; shopId: string; timeStamp: string; trxId: string): string;
var
  strTempC, strTempD: string;
  myMD5: TIdHashMessageDigest5;
begin
  myMD5 := TIdHashMessageDigest5.Create;
  strTempC := 'appId' + appId
    + 'bandId' + bandId
    + 'haokuTrxId' + haokuTrxId
    + 'shopId' + shopId
    + 'timestamp' + timeStamp
    + 'trxId' + trxId; //按字符顺序排序

  strTempD := strTempC + SGBTCONFIGURE.secret_key; //加上secret_key
  result := LowerCase(myMD5.AsHex(myMD5.HashValue(strTempD))); //计算字符串的MD5,并返回小写
  myMD5.Free;

end;

//-----------------------线下充值-----------------------------------------------------------------



procedure TfrmNewMember.FormShow(Sender: TObject);
begin


  //初始化
  initRechargeRecord();

  //初始化变量
  orderLst := TStringList.Create;
  recDataLst := tStringList.Create;

  edtAPPID.Text := SGBTCONFIGURE.appid;
  edtShopID.Text := SGBTCONFIGURE.shopid;

  //打开串口
//  commRecharge.StartComm();
  try
    commRecharge.StartComm();
  except on E: Exception do //拦截所有异常
    begin
      showmessage(SG3FERRORINFO.commerror + e.message);
      exit;
    end;
  end;
end;

function TfrmNewMember.initRechargeRecord(): string;
var
  strSQL: string;
begin
  with ADOQRecharge do begin
    Connection := DataModule_3F.ADOConnection_Main;
    Active := false;
    SQL.Clear;
    strSQL := 'select trxid,appid,bandid,coin,leftcoin,totalcoin,shopid,operatorno,payid,operatetime from t_recharge_record order by operatetime desc limit 10';
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
  ICFunction.loginfo('recharge return from card recStr: ' + recStr);
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
 
  ICFunction.loginfo('data return from recharge : ' + tmpStr);
  if ICCommunalVarUnit.Receive_CMD_ID_Infor.CMD = CMD_COUMUNICATION.CMD_READ then //收到卡头写入电子币充值成功的返回 53
  begin
    returnFromReadCMD();
  end
  else if Receive_CMD_ID_Infor.CMD = ICCommunalVarUnit.CMD_COUMUNICATION.CMD_INCValue_RE then //读指令
  begin
    returnFromIncrCMD();
  end;

end;


//卡头返回充值成功指令

procedure TfrmNewMember.returnFromIncrCMD();
begin

  if (Receive_CMD_ID_Infor.ID_type = copy(INit_Wright.User, 8, 2)) then
  begin
    saveRechargeRecord(); //保存充值记录
    initRechargeRecord();
  end;
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

    //本场地卡检查 -----开始  从电子币上读取的场地密码与从配置文件里读取的不一样
  if (Receive_CMD_ID_Infor.Password_3F <> SGBTCONFIGURE.appid) then //    INit_Wright.BossPassword := MyIni.ReadString('PLC工作区域', 'PC托盘特征码', '新密码');
  begin
    lblMessage.Caption := '非本场地此卡，请更换！';
    exit;
  end
  else
  begin //场地初始化检查 -----开始
    if DataModule_3F.queryExistInitialRecord(Receive_CMD_ID_Infor.ID_INIT) = false then //用户卡已经初始化 有记录
    begin
      lblMessage.Caption := '请先初始化！';
      exit;
    end
    else
    begin
      showCardInformation();
    end;
  end;

end;




//用户卡信息展示

procedure TfrmNewMember.showCardInformation();
begin
  //  edtAPPID.Text  := Receive_CMD_ID_Infor.Password_3F;   //appid
  //  edtShopID.Text := Receive_CMD_ID_Infor.Password_USER; //shopid
  edtBandID.Text := Receive_CMD_ID_Infor.ID_INIT; //用户币ID
  edtLeftCoin.Text := ICFunction.transferHEXByteToDECValue(Receive_CMD_ID_Infor.ID_value);
  edtTypeName.Text := ICFunction.transferTypeIDToTypeName(Receive_CMD_ID_Infor.ID_type);

end; //end prc_user_card_operation










//保存初始化数据,并设置全局变量
//写充值记录

procedure TfrmNewMember.saveRechargeRecord();
var
  strTrxid, strAppID, strBandid, strShopid, strPayid, strOperateTime, strOperatorNO, strPayState, strNote, strExpireTime, strsql: string;
  intCoin, intLeftCoin, intTotalCoin: Integer;

begin

  strAppID := trim(edtAppID.Text);
  strBandid := trim(edtBandID.Text);
  strShopid := trim(edtShopID.Text);
  intCoin := strToInt(trim(edtRechargeCoin.Text)); //这里最好不要用edit里的值，会在其它地位reset掉
  intLeftCoin := strToInt(trim(edtLeftCoin.Text));
  intTotalCoin := intLeftCoin + intCoin;
  strTrxid := GLOBALsg3ftrxID;

  strPayid := GLOBALstrPayID; //01表示在线,02表示现金

    //指定日期格式 重要
  ShortDateFormat := 'yyyy-MM-dd'; //指定格式即可
  DateSeparator := '-';
    //指定日期格式 否则会报is not an valid date and time;

  strOperateTime := FormatDateTime('yyyy-MM-dd HH:mm:ss', now);
  strOperatorNO := '001';
  strPayState := '0'; //0表示成功
  strNote := '充值';
  strExpireTime := FormatDateTime('yyyy-MM-dd HH:mm:ss', now);

  with ADOQRecharge do begin
    Connection := DataModule_3F.ADOConnection_Main;
    Active := false;
    SQL.Clear;
    strSQL := 'select * from t_recharge_record order by operatetime desc'; //为什么要查全部？
    ICFunction.loginfo('strSQL :' + strSQL);
    SQL.Add(strSQL);
    Active := True;
    Append;
    FieldByName('trxid').AsString := strTrxid;
    FieldByName('appid').AsString := strAppID;
    FieldByName('bandid').AsString := strBandid;
    FieldByName('shopid').AsString := strShopid;
    FieldByName('coin').AsInteger := intCoin;
    FieldByName('leftcoin').AsInteger := intLeftCoin;
    FieldByName('totalcoin').AsInteger := intTotalCoin;
    FieldByName('payid').AsString := strPayid;
    FieldByName('operatetime').AsString := strOperateTime; //用户名
    FieldByName('operatorno').AsString := strOperatorNO; //充值操作
    FieldByName('paystate').AsString := strPayState; //
    FieldByName('note').AsString := strNote;
  //  FieldByName('expiretime').AsString := strExpireTime; //失效时间
    post;
  end;
  GLOBALsg3ftrxID := strTrxid;

end;


procedure TfrmNewMember.initIncrOperation(strRechargeCoin: string);
var
  strValue: string;
begin
  strValue := caluSendCMD(CMD_COUMUNICATION.CMD_INCValue, strRechargeCoin); //计算充值指令
  generateIncrValueCMD(strValue); //把充值指令写入ID卡
  ICFunction.loginfo('recharge data send to card: ' + strValue);
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


procedure TfrmNewMember.btnOfflineRechargeClick(Sender: TObject);
var
  strRechargeCoin, strLeftCoin: string;
  strURL, strResponseStr: string;
  intWriteValue: Integer;
  jsonApplyResult, jsonAckResult: TlkJSONbase;
  ResponseStream: TStringStream; //返回信息
  activeIdHTTP: TIdHTTP;

begin
  //初始化支付方式
  GLOBALstrPayID := '02';
  //初始化事务ID
  GLOBALsg3ftrxID := trim(edtAPPID.Text) + trim(edtShopID.Text) + trim(edtBandID.Text) + FormatDateTime('HHmmss', now);

  strRechargeCoin := trim(edtRechargeCoin.Text);
  strLeftCoin := trim(edtLeftCoin.Text);
  intWriteValue := strToInt(strRechargeCoin) + strToInt(strLeftCoin);

  //充值输入正则表达式校验及风控限额
  //卡类型判断
  if ((ICFunction.transferTypeNameToTypeID(edtTypeName.text) <> copy(INit_Wright.User, 8, 2))) then //用户卡
  begin
    lblMessage.Caption := edtTypeName.text + '不能用于充值';
    exit;
  end;
  if IsNumberic(strRechargeCoin) = false then
  begin
    MessageBox(handle, '请输入正确的金额', '错误', MB_ICONERROR + MB_OK);
    exit;
  end;
  if checkCoinLimit(intToStr(intWriteValue)) then
  begin
    MessageBox(handle, '充值总额超过限额!', '错误', MB_ICONERROR + MB_OK);
    exit;
  end;

  //{关闭HK接口
//{  //线下充值申请
  if SGBTCONFIGURE.enableInterface = '0' then
  begin
    strURL := generateOfflineRechargeApplyURL();
    ICFunction.loginfo('Offline Recharge Apply URL: ' + strURL);

    activeIdHTTP := TIdHTTP.Create(nil);
    ResponseStream := TStringStream.Create('');
    try
      activeIdHTTP.HandleRedirects := true;
      activeIdHTTP.Get(strURL, ResponseStream);
    except
      on e: Exception do
      begin
        showmessage(SG3FERRORINFO.networkerror + e.message);
        exit;
      end;
    end;
    //获取网页返回的信息   网页中的存在中文时，需要进行UTF8解码
    strResponseStr := UTF8Decode(ResponseStream.DataString);


    ICFunction.loginfo('Offline Recharge Response: ' + strResponseStr);

    jsonApplyResult := TlkJSON.ParseText(UTF8Encode(strResponseStr)) as TlkJSONobject; //UTF8编码
    if jsonApplyResult = nil then
    begin
      Showmessage(SG3FERRORINFO.networkerror);
      exit;
    end;
    if vartostr(jsonApplyResult.Field['code'].Value) <> '0' then
    begin
      Showmessage('error code :' + vartostr(jsonApplyResult.Field['code'].Value) + ',' + vartostr(jsonApplyResult.Field['message'].Value) );
      exit;
    end;

  end;
//}
  //线下圈存/入库
  initIncrOperation(IntToStr(intWriteValue)); //这里如何得到平台事务ID 引入了一个全局变量 strGlobalSGtrxID


  //{  //{关闭HK接口
  //线下充值确认,这里通过jsonApplyResult可能会读不到值
  if SGBTCONFIGURE.enableInterface = '0' then
  begin
    ICFunction.loginfo('GLOBALsg3ftrxID' + GLOBALsg3ftrxID);
    strURL := generateOfflineRechargeAckURL(vartostr(jsonApplyResult.Field['haokuTrxId'].Value), GLOBALsg3ftrxID);
    ICFunction.loginfo('Offline Recharge Ack URL: ' + strURL);

    activeIdHTTP := TIdHTTP.Create(nil);
    ResponseStream := TStringStream.Create('');
    try
      activeIdHTTP.HandleRedirects := true;
      activeIdHTTP.Get(strURL, ResponseStream);
    except
      on e: Exception do
      begin
        showmessage(SG3FERRORINFO.networkerror + e.message);
        exit;
      end;
    end;
    //获取网页返回的信息   网页中的存在中文时，需要进行UTF8解码
    strResponseStr := UTF8Decode(ResponseStream.DataString);

    ICFunction.loginfo('Offline Recharge Ack Response: ' + strResponseStr);

    jsonApplyResult := TlkJSON.ParseText(UTF8Encode(strResponseStr)) as TlkJSONobject; //UTF8编码
    if jsonApplyResult = nil then
    begin
      Showmessage(SG3FERRORINFO.networkerror);
      exit;
    end;
    if vartostr(jsonApplyResult.Field['code'].Value) <> '0' then
    begin
      Showmessage('error code:' + vartostr(jsonApplyResult.Field['code'].Value) + ',' + vartostr(jsonApplyResult.Field['message'].Value) + ',请联系技术人员');
      exit;
    end;
  end;
  // }
  lblMessage.Caption := '线下充值操作、保存充值记录成功';

end;


//风控限额

function TfrmNewMember.checkCoinLimit(strWriteValue: string): boolean;
begin
  result := false;
  if strToInt(strWriteValue) > strToInt(SGBTCONFIGURE.COINLIMIT) then
    result := true;

end;



procedure TfrmNewMember.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin

  orderLst.Free();
  recDataLst.Free();
  commRecharge.StopComm;

end;

//在线充值操作

procedure TfrmNewMember.btnOnlineRechargeClick(Sender: TObject);

var
  strRechargeCoin, strLeftCoin, haokuTrxId: string;
  strURL, strResponseStr: string;
  intWriteValue: Integer;
  jsonApplyResult, jsonAckResult: TlkJSONbase;
  ResponseStream: TStringStream; //返回信息
  activeIdHTTP: TIdHTTP;

begin
   //追加卡类型判断,如果不是用户卡或者开机卡不能充值? 开机卡也不需要发送接口吧？


 //初始化事务ID
  GLOBALsg3ftrxID := trim(edtAPPID.Text) + trim(edtShopID.Text) + trim(edtBandID.Text) + FormatDateTime('HHmmss', now);
  GLOBALstrPayID := '01';

  strLeftCoin := trim(edtLeftCoin.Text);

  //卡类型判断
  if ((ICFunction.transferTypeNameToTypeID(edtTypeName.text) <> copy(INit_Wright.User, 8, 2))) then //用户卡
  begin
    lblMessage.Caption := edtTypeName.text + '不能用于充值';
    exit;
  end;



  //线上充值申请
  strURL := generateOnlineRechargeApplyURL();
  ICFunction.loginfo('Recharge: Online Recharge Apply URL : ' + strURL);
  activeIdHTTP := TIdHTTP.Create(nil);
  ResponseStream := TStringStream.Create('');
  try
    activeIdHTTP.HandleRedirects := true;
    activeIdHTTP.Get(strURL, ResponseStream);
  except
    on e: Exception do
    begin
      showmessage(SG3FERRORINFO.networkerror + e.message);
      exit;
    end;
  end;
    //获取网页返回的信息   网页中的存在中文时，需要进行UTF8解码
  strResponseStr := UTF8Decode(ResponseStream.DataString);
  ICFunction.loginfo('Recharge: Online Recharge ACK Response: ' + strResponseStr);
  jsonApplyResult := TlkJSON.ParseText(UTF8Encode(strResponseStr)) as TlkJSONobject; //UTF8编码
  if jsonApplyResult = nil then
  begin
    Showmessage(SG3FERRORINFO.networkerror);
    exit;
  end;
  if vartostr(jsonApplyResult.Field['code'].Value) <> '0' then
  begin
    Showmessage('error code :' + vartostr(jsonApplyResult.Field['code'].Value) + ',' + vartostr(jsonApplyResult.Field['message'].Value) );
    exit;
  end;


  //这里的值有没有包括leftCoin
  strRechargeCoin := trim(vartostr(jsonApplyResult.Field['coin'].Value));
  edtRechargeCoin.Text := strRechargeCoin; //入库使用的输入
  haokuTrxId := trim(vartostr(jsonApplyResult.Field['haokuTrxId'].Value));
  intWriteValue := strToInt(strRechargeCoin) + strToInt(strLeftCoin);
  //风控限额
  if checkCoinLimit(intToStr(intWriteValue)) then
  begin
    MessageBox(handle, '充值总额超过限额!', '错误', MB_ICONERROR + MB_OK);
    exit;
  end;
  //圈存,入库
  initIncrOperation(IntToStr(intWriteValue));

  //线上充值确认
  strURL := generateOnlineRechargeAckURL(vartostr(jsonApplyResult.Field['haokuTrxId'].Value), GLOBALsg3ftrxID);
  ICFunction.loginfo('Recharge: Online Recharge Request ACK URL: ' + strURL);

  activeIdHTTP := TIdHTTP.Create(nil);
  ResponseStream := TStringStream.Create('');
  try
    activeIdHTTP.HandleRedirects := true;
    activeIdHTTP.Get(strURL, ResponseStream);
  except
    on e: Exception do
    begin
      showmessage(SG3FERRORINFO.networkerror + e.message);
      exit;
    end;
  end;
    //获取网页返回的信息   网页中的存在中文时，需要进行UTF8解码
  strResponseStr := UTF8Decode(ResponseStream.DataString);

  ICFunction.loginfo('Recharge: Online Recharge ack response :' + strResponseStr);

  jsonApplyResult := TlkJSON.ParseText(UTF8Encode(strResponseStr)) as TlkJSONobject; //UTF8编码
  if jsonApplyResult = nil then
  begin
    Showmessage(SG3FERRORINFO.networkerror);
    exit;
  end;
  if vartostr(jsonApplyResult.Field['code'].Value) <> '0' then
  begin
    Showmessage('error code :' + vartostr(jsonApplyResult.Field['code'].Value) + ',' + vartostr(jsonApplyResult.Field['message'].Value) + ',请联系技术人员');
    exit;
  end;

  lblMessage.Caption := '线上充值操作、保存充值记录成功';

end;



end.

