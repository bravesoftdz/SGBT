unit untSumAccount;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DB, ADODB, Grids, DBGrids, SPComm, StdCtrls, ExtCtrls;

type
  TfrmAccountSum = class(TForm)
    Panel1: TPanel;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    GroupBox3: TGroupBox;
    commAccountSum: TComm;
    dsAccountSum: TDataSource;
    dgAccountSum: TDBGrid;
    ADOQAccountSum: TADOQuery;
    Label1: TLabel;
    edtAPPID: TEdit;
    edtShopID: TEdit;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    edtAccountSum: TEdit;
    edtBandID: TEdit;
    Label5: TLabel;
    edtGatherID: TEdit;
    btnCollect: TButton;
    btnUpload: TButton;
    lblMessage: TLabel;
    Label6: TLabel;
    edtTypeName: TEdit;
    procedure commAccountSumReceiveData(Sender: TObject; Buffer: Pointer; BufferLength: Word);
    procedure btnCollectClick(Sender: TObject);
    procedure btnUploadClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }

    function initDatabaseRecord(): string;
    procedure saveDatabaseRecord(); overload;
    procedure saveDatabaseRecord(strAccountSum: string); overload;
    procedure checkCMDInfo();
    procedure returnFromReadCMD();
    procedure returnFromIncrCMD();
    procedure showCardInformation();

    procedure initIncrOperation(strRechargeCoin: string);
    procedure sendDataToCard();
    function caluSendCMD(strCMD: string; strIncrValue: string): string;
    procedure generateIncrValueCMD(S: string);

    function generateUploadURL(): string; overload;
    function generateUploadURL(appId: string; coin: string; collectId: string; shopId: string): string; overload;

    function getUploadSignature(appId: string; coin: string; collectId: string; shopId: string; timeStamp: string): string;
  end;

var
  frmAccountSum: TfrmAccountSum;

  orderLst, recDataLst: Tstrings; //定义全局变量发送数据，接收数据
  curOrderNo: integer = 0; //???
  curOperNo: integer = 0;
  Operate_No: integer = 0; //什么作用?标记正在充值？

  ID_UserCard_Text: string;
  IncValue_Enable: boolean; //是否允许充值的标志,会员卡认证通过后置为True
  buffer: array[0..2048] of byte;

  //全局变量用来共享SG3F平台事务ID;
  globalCollectID: string; //
  globalUploadState: string;


implementation
uses ICDataModule, ICCommunalVarUnit, ICmain, ICEventTypeUnit, ICFunctionUnit, dateProcess, strprocess, IdHashMessageDigest, IdHTTP, uLkJSON;
{$R *.dfm}




//总账采集上传申请接口URL

function TfrmAccountSum.generateUploadURL(appId: string; coin: string; collectId: string; shopId: string): string;
var
  strURL, timestamp, strSignature, strActiveURL, strhkscURL: string;
begin
  timestamp := getTimestamp();
  strSignature := getUploadSignature(appId, coin, collectId, shopId, timestamp);
  strActiveURL := SGBTCONFIGURE.coindatauploadurl;
  strhkscURL := SGBTCONFIGURE.hkscURL;

  strURL := strhkscURL + strActiveURL
    + '?appId=' + appId
    + '&coin=' + coin
    + '&collectId=' + collectId
    + '&shopId=' + shopId
    + '&timestamp=' + timestamp
    + '&sign=' + strSignature;

  result := strURL;
end;



function TfrmAccountSum.generateUploadURL(): string;
var
  strURL, appId, collectId, coin, shopId, timestamp, strSignature, strActiveURL, strhkscURL: string;
begin
  appId := SGBTCONFIGURE.appid;
  coin := edtAccountSum.Text;
  collectId := globalCollectID;
  shopId := SGBTCONFIGURE.shopid;
  timestamp := getTimestamp();
  strSignature := getUploadSignature(appId, coin, collectId, shopId, timestamp);
  strActiveURL := SGBTCONFIGURE.coindatauploadurl;
  strhkscURL := SGBTCONFIGURE.hkscURL;

  strURL := strhkscURL + strActiveURL
    + '?appId=' + appId
    + '&coin=' + coin
    + '&collectId=' + collectId
    + '&shopId=' + shopId
    + '&timestamp=' + timestamp
    + '&sign=' + strSignature;

  result := strURL;
end;



//总账上传申请签名算法

function TfrmAccountSum.getUploadSignature(appId: string; coin: string; collectId: string; shopId: string; timeStamp: string): string;
var
  strTempC, strTempD: string;
  myMD5: TIdHashMessageDigest5;
begin
  myMD5 := TIdHashMessageDigest5.Create;
  strTempC := 'appId' + appId
    + 'coin' + coin
    + 'collectId' + collectId
    + 'shopId' + shopId
    + 'timestamp' + timeStamp; //按字符顺序排序

  strTempD := strTempC + SGBTCONFIGURE.secret_key; //加上secret_key
  result := LowerCase(myMD5.AsHex(myMD5.HashValue(strTempD))); //计算字符串的MD5,并返回小写
  myMD5.Free;

end;


procedure TfrmAccountSum.commAccountSumReceiveData(Sender: TObject;
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

procedure TfrmAccountSum.btnCollectClick(Sender: TObject);
begin

    //卡类型判断
  if ((ICFunction.transferTypeNameToTypeID(edtTypeName.text) <> copy(INit_Wright.MANEGER, 8, 2))) then //采集卡
  begin
    lblMessage.Caption := edtTypeName.text + '不能采集总账';
    exit;
  end;

  globalUploadState := '0'; //采集完成
  globalCollectID := trim(edtGatherID.Text) + formatDatetime('hhmmss', now);

  //总账入库
  saveDatabaseRecord(edtAccountSum.Text);

  //圈存归零
  initIncrOperation(IntToStr(0));

  initDatabaseRecord();

  lblMessage.Caption := '总账记录采集完成,请点击上传';



end;

procedure TfrmAccountSum.btnUploadClick(Sender: TObject);
var
  strURL, strResponseStr, strSQL, reTmpStr: string;
  jsonApplyResult: TlkJSONbase;
  appId, collectId, coin, shopId: string;
  ADOQ: TADOQuery;
  ResponseStream: TStringStream; //返回信息
  activeIdHTTP: TIdHTTP;

begin

    //卡类型判断
  if ((ICFunction.transferTypeNameToTypeID(edtTypeName.text) <> copy(INit_Wright.MANEGER, 8, 2))) then //采集卡
  begin
    lblMessage.Caption := edtTypeName.text + '不能采集总账';
    exit;
  end;

  //从数据里找到状态为未上传的 ,一次只能取一条
  //这里取appid/shopid有问题，有可能在000023的shopid里取到000024，造成签名不正确。这在测试环境下会有问题生产环境不会发生
  strSQL := 'select appid,coin,collectId,shopid from t_collect_account where state=' + '0' +' and shopid = '+SGBTCONFIGURE.shopid   + ' order by collectId limit 1';
  ICFunction.loginfo('strSQL :' + strSQL);
  ADOQ := TADOQuery.Create(nil);
  with ADOQ do
  begin
    Connection := DataModule_3F.ADOConnection_Main;
    SQL.Clear;
    SQL.Add(strSQL);
    Active := True;
    if (RecordCount > 0) then
    begin
      appId := ADOQ.Fields[0].AsString;
      coin := ADOQ.Fields[1].AsString;
      collectId := ADOQ.Fields[2].AsString;
      shopId := ADOQ.Fields[3].AsString;
    end
    else
    begin
      lblMessage.Caption := '没有需要上传的账目';
      exit; //没有需要上传的账目
    end;
    FreeAndNil(ADOQ);
  end;


  //总账上传申请
  if SGBTCONFIGURE.enableInterface = '0' then
  begin
    strURL := generateUploadURL(appId, coin, collectId, shopId);
    ICFunction.loginfo('SumAccount Data Upload request URL: ' + strURL);

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

    ICFunction.loginfo('SumAccount: Data Upload respones : ' + strResponseStr);
    jsonApplyResult := TlkJSON.ParseText(UTF8Encode(strResponseStr)) as TlkJSONobject; //UTF8编码
    if jsonApplyResult = nil then
    begin
      Showmessage(SG3FERRORINFO.networkerror);
      exit;
    end;
    if vartostr(jsonApplyResult.Field['code'].Value) <> '0' then
    begin
      Showmessage('error code ' + vartostr(jsonApplyResult.Field['code'].Value) + ',' + vartostr(jsonApplyResult.Field['message'].Value) + ',请联系技术人员');
      lblMessage.Caption := '总账记录上传失败,请重试';
      exit;
    end;
  end;
  //更新状态
  strSQL := 'update t_collect_account set state=1 where collectId= ''' + collectId + '''';
  ADOQ := TADOQuery.Create(nil);

  with ADOQ do begin
    Connection := DataModule_3F.ADOConnection_Main;
    SQL.Clear;
    SQL.Add(strSQL);
    ADOQ.ExecSQL;
  end;
  FreeAndNil(ADOQ);

  initDatabaseRecord();


  lblMessage.Caption := '总账记录上传完成';
  //btnCollect.Enabled := true;


end;







procedure TfrmAccountSum.checkCMDInfo();
var
  tmpStr: string;
begin
   //首先截取接收的信息

  tmpStr := recDataLst.Strings[0];
  ICCommunalVarUnit.Receive_CMD_ID_Infor.ID_CheckNum := copy(tmpStr, 39, 4); //校验和
  ICCommunalVarUnit.CMD_CheckSum_OK := true;
  ICCommunalVarUnit.Receive_CMD_ID_Infor.CMD := copy(recDataLst.Strings[0], 1, 2); //帧头43
  ICFunction.loginfo('SumAccount: Data Read from Card : ' + tmpStr);
  if ICCommunalVarUnit.Receive_CMD_ID_Infor.CMD = CMD_COUMUNICATION.CMD_READ then //收到卡头写入电子币充值成功的返回 53
  begin
    returnFromReadCMD();
  end
  else if Receive_CMD_ID_Infor.CMD = ICCommunalVarUnit.CMD_COUMUNICATION.CMD_INCValue_RE then //读指令
  begin
//    returnFromIncrCMD();
    lblMessage.Caption := '圈存完成！';
  end;

end;


//卡头返回充值成功指令

procedure TfrmAccountSum.returnFromIncrCMD();
begin

  if (Receive_CMD_ID_Infor.ID_type = copy(INit_Wright.MANEGER, 8, 2)) then
  begin
    saveDatabaseRecord(); //保存充值记录
    initDatabaseRecord();
   //
  end;
end;


//卡头返回信息读取指令

procedure TfrmAccountSum.returnFromReadCMD();
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
   // if DataModule_3F.queryExistInitialRecord(Receive_CMD_ID_Infor.ID_INIT) = false then //采集卡初始化有记录
  //  begin
     // lblMessage.Caption := '请先初始化！';
     // exit;
  //  end
   // else
    //begin
      showCardInformation();
   // end;
  end;

end;




//用户卡信息展示

procedure TfrmAccountSum.showCardInformation();
begin
  edtBandID.Text := Receive_CMD_ID_Infor.ID_INIT; //用户币ID
  edtGatherID.Text := Receive_CMD_ID_Infor.ID_3F; //collectid
  edtAPPID.Text := Receive_CMD_ID_Infor.Password_3F; //appid
  edtShopID.Text := Receive_CMD_ID_Infor.Password_USER; //shopid
  edtAccountSum.Text := ICFunction.transferHEXByteToDECValue(Receive_CMD_ID_Infor.ID_value); //coin总账
  edtTypeName.text := ICFunction.transferTypeIDToTypeName(Receive_CMD_ID_Infor.ID_type);


end; //end prc_user_card_operation






procedure TfrmAccountSum.sendDataToCard();
var
  orderStr: string;
begin
  if orderLst.Count > curOrderNo then
  begin
    orderStr := orderLst.Strings[curOrderNo];
    orderStr := ICFunction.funcTransferExchData(orderStr);
    commAccountSum.WriteCommData(pchar(orderStr), length(orderStr)); //真正写到卡头
    inc(curOrderNo); //累加
  end;
end;




//保存初始化数据,并设置全局变量
//写充值记录

procedure TfrmAccountSum.saveDatabaseRecord();
var
  strAppID, strCollectID, strShopid, strOperateTime, strOperatorNO, strState, strsql: string;
  intCoin: Integer;

begin

  strAppID := trim(edtAppID.Text);
  strShopid := trim(edtShopID.Text);
  intCoin := strToInt(trim(edtAccountSum.Text)); //这里最好不要用edit里的值，会在其它地位reset掉
  strCollectID := globalCollectID;
  strState := '0'; //0表示采集成功 1表示上传成功
  strOperatorNO :=G_User.UserNO;

    //指定日期格式 重要
  ShortDateFormat := 'yyyy-MM-dd'; //指定格式即可
  DateSeparator := '-';
    //指定日期格式 否则会报is not an valid date and time;
  strOperateTime := FormatDateTime('yyyy-MM-dd HH:mm:ss', now);

  with ADOQAccountSum do begin
    Connection := DataModule_3F.ADOConnection_Main;
    Active := false;
    SQL.Clear;
    strSQL := 'select * from t_collect_account order by operatetime desc'; //为什么要查全部？
    SQL.Add(strSQL);
    Active := True;
    Append;
    FieldByName('collectid').AsString := strCollectID;
    FieldByName('appid').AsString := strAppID;
    FieldByName('shopid').AsString := strShopid;
    FieldByName('coin').AsInteger := intCoin;
    FieldByName('state').AsString := strState; //
    FieldByName('operatetime').AsString := strOperateTime; //用户名
    FieldByName('operatorno').AsString := strOperatorNO; //充值操作
    post;
  end;

end;



procedure TfrmAccountSum.saveDatabaseRecord(strAccountSum: string);
var
  strAppID, strCollectID, strShopid, strOperateTime, strOperatorNO, strState, strCoin, strsql: string;
begin

  strAppID := trim(edtAppID.Text);
  strShopid := trim(edtShopID.Text);
  strCoin := strAccountSum; //这里最好不要用edit里的值，会在其它地位reset掉
  strCollectID := globalCollectID;
  strState := globalUploadState; //0表示成功
  strOperatorNO := G_User.UserNO;

    //指定日期格式 重要
  ShortDateFormat := 'yyyy-MM-dd'; //指定格式即可
  DateSeparator := '-';
    //指定日期格式 否则会报is not an valid date and time;
  strOperateTime := FormatDateTime('yyyy-MM-dd HH:mm:ss', now);

  with ADOQAccountSum do begin
    Connection := DataModule_3F.ADOConnection_Main;
    Active := false;
    SQL.Clear;
    strSQL := 'select * from t_collect_account order by operatetime desc '; //为什么要查全部？
    SQL.Add(strSQL);
    Active := True;
    Append;
    FieldByName('collectid').AsString := strCollectID;
    FieldByName('appid').AsString := strAppID;
    FieldByName('shopid').AsString := strShopid;
    FieldByName('coin').AsString := strCoin;
    FieldByName('state').AsString := strState; //
    FieldByName('operatetime').AsString := strOperateTime; //用户名
    FieldByName('operatorno').AsString := strOperatorNO; //充值操作
    post;
  end;

end;



//计算充值指令

function TfrmAccountSum.caluSendCMD(strCMD: string; strIncrValue: string): string;
var
  TmpStr_CheckSum: string; //校验和
  TmpStr_SendCMD: string; //指令内容
  reTmpStr: string;
begin

  INit_3F.CMD := StrCMD; //帧命令
  INit_3F.ID_INIT := edtBandID.Text; //币ID

    //Password3F_System 、ID_System这两个变量在输入完毕用户编号回车时执行生成的
 // ID_System := ICFunction.SUANFA_ID_3F(INit_3F.ID_INIT); //调用计算ID_3F算法
  //Password3F_System := ICFunction.SUANFA_Password_3F(INit_3F.ID_INIT); //调用计算Password_3F算法
//  INit_3F.ID_3F := copy(Password3F_System, 5, 2) + copy(ID_System, 1, 2) + copy(Password3F_System, 3, 2);
  INit_3F.ID_3F := FormatDateTime('yyMMdd', now);
  INit_3F.Password_3F := SGBTCONFIGURE.appid; //直接读取配置文件中的场地密码 (PC托盘特征码)
  INit_3F.Password_USER := SGBTCONFIGURE.shopid; //用户场地密码，保存在文档里面  (PC托盘特征码)
  INit_3F.ID_value := '00000000'; //卡内数据初始化为0 一定要8位
  INit_3F.ID_type := ICFunction.transferTypeNameToTypeID(edtTypeName.Text); //取得卡类型的值

  //汇总发送内容
  TmpStr_SendCMD := INit_3F.CMD + INit_3F.ID_INIT + INit_3F.ID_3F + INit_3F.Password_3F + INit_3F.Password_USER + INit_3F.ID_value + INit_3F.ID_type;
   //TmpStr_SendCMD:=指令帧头+    币ID+             3F出厂ID +      3F出厂密码+           用户场地密码  +         3F出厂初始币值  +  3F出厂初始币类型

  ICFunction.loginfo('INit_3F.ID_INIT ' + INit_3F.ID_INIT);
  ICFunction.loginfo('INit_3F.ID_3F ' + INit_3F.ID_3F);
  ICFunction.loginfo('INit_3F.Password_3F ' + INit_3F.Password_3F);
  ICFunction.loginfo('INit_3F.Password_USER ' + INit_3F.Password_USER);
  ICFunction.loginfo('INit_3F.ID_value ' + INit_3F.ID_value);
  ICFunction.loginfo('INit_3F.ID_type ' + INit_3F.ID_type);

    //将发送内容进行校核计算
  TmpStr_CheckSum := ICFunction.checkSUMData(TmpStr_SendCMD);
  INit_3F.ID_CheckNum := ICFunction.transferCheckSumByte(TmpStr_CheckSum);
  reTmpStr := TmpStr_SendCMD + INit_3F.ID_CheckNum;
  result := reTmpStr;
end;


procedure TfrmAccountSum.initIncrOperation(strRechargeCoin: string);
var
  strValue: string;
begin
  strValue := caluSendCMD(CMD_COUMUNICATION.CMD_INCValue, strRechargeCoin); //计算充值指令
  generateIncrValueCMD(strValue); //把充值指令写入ID卡
  ICFunction.loginfo('SumAccount: Data Send to Card : ' + strValue);
end;
//充值函数

//生成充值的操作指令

procedure TfrmAccountSum.generateIncrValueCMD(S: string);
begin
  orderLst.Clear();
  recDataLst.Clear();
  curOrderNo := 0;
  curOperNo := 2;
  orderLst.Add(S); //将充值指令写入缓冲
  sendDataToCard(); //写入卡头　
end;


procedure TfrmAccountSum.FormShow(Sender: TObject);
begin
      //初始化
  initDatabaseRecord();

  //初始化变量
  orderLst := TStringList.Create;
  recDataLst := tStringList.Create;

//  edtAPPID.Text := SGBTCONFIGURE.appid;
 // edtShopID.Text := SGBTCONFIGURE.shopid;

  //打开串口
//  commAccountSum.StartComm();
  try
    commAccountSum.StartComm();
  except on E: Exception do //拦截所有异常
    begin

      exit;
    end;
  end;

end;

function TfrmAccountSum.initDatabaseRecord(): string;
var
  strSQL: string;
begin
  with ADOQAccountSum do begin
    Connection := DataModule_3F.ADOConnection_Main;
    Active := false;
    SQL.Clear;
    strSQL := 'select collectid,appid,shopid,coin,state,operatetime from t_collect_account order by operatetime desc limit 10';
    SQL.Add(strSQL);
    Active := True;
  end;
  result := '1';
end;



procedure TfrmAccountSum.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  orderLst.Free();
  recDataLst.Free();
  commAccountSum.StopComm;

end;

end.

