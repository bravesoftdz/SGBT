unit untInitialRecord;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, SPComm, DB, ADODB, Grids, DBGrids,
  IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient, IdHTTP,
  IdAntiFreezeBase, IdAntiFreeze;

type
  TfrmInitial = class(TForm)
    Panel1: TPanel;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    GroupBox3: TGroupBox;
    Label1: TLabel;
    edtShopID: TEdit;
    Label2: TLabel;
    cbCoinType: TComboBox;
    btnInitial: TButton;
    btnBindWeiXin: TButton;
    dgInitial: TDBGrid;
    ADOQueryInitial: TADOQuery;
    dsInitial: TDataSource;
    commInitial: TComm;
    lblMessage: TLabel;
    edtBandID: TEdit;
    Label3: TLabel;
    Label4: TLabel;
    edtAPPID: TEdit;
    activeIdHTTP: TIdHTTP;
    GroupBox4: TGroupBox;
    imgCode: TImage;
    Label5: TLabel;
    edtTypeID: TEdit;
    Label6: TLabel;
    edtCoin: TEdit;
    Label7: TLabel;
    edtCoinCost: TEdit;
    IdAntiFreeze1: TIdAntiFreeze;
  //  memo1: TMemo;
    procedure commInitialReceiveData(Sender: TObject; Buffer: Pointer;
      BufferLength: Word);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnInitialClick(Sender: TObject);
    procedure btnBindWeiXinClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }

        //数据库相关
    function initCoinRecord(): string;
    procedure saveInitialRecord(); //保存充值记录
        //卡头处理函数
    procedure checkCMDInfo();
    procedure initIncrOperation(strRechargeCoin: string); //充值操作，写数据个卡
    function caluSendCMD(strCMD: string; strIncrValue: string): string;
    procedure generateIncrValueCMD(S: string);
    procedure prcSendDataToCard();
    procedure showCardInformation();
    procedure returnFromReadCMD();
    procedure returnFromIncrCMD();
//    function  checkSUMData(orderStr: string): string;
  //  function transferTypeNameToTypeID(StrIDtype: string): string;
   // function transferTypeIDToTypeName(strTypeName: string): string;
    procedure initComboxCardtype;



    //初始化激活BandID接口
    //function bandIDActiveInterface(): string;

    //拼接激活接口URL
    function generateActiveURL(): string;

    //拼接签到接口URL
    function getActiveSignature(bandId: string; appId: string; shopId: string; timeStamp: string): string;

    //绑定微信
    function generateBindWeiWinURL(): string;
    function getBindWeiXinSignature(appId: string; bandId: string; shopId: string; timeStamp: string): string;


  end;

var
  frmInitial: TfrmInitial;
  curOrderNo: integer = 0; //???
  curOperNo: integer = 0;
  Operate_No: integer = 0; //什么作用?标记正在充值？
  orderLst, recDataLst: Tstrings; //定义全局变量发送数据，接收数据
  ID_UserCard_Text: string;
  IncValue_Enable: boolean; //是否允许充值的标志,会员卡认证通过后置为True
  buffer: array[0..2048] of byte;
  ID_System: string;
  Password3F_System: string;

implementation
uses ICDataModule, ICCommunalVarUnit, ICmain, ICEventTypeUnit, ICFunctionUnit, dateProcess, IdHashMessageDigest, uLkJSON, QRCode;
{$R *.dfm}


function TfrmInitial.initCoinRecord(): string;
var
  strSQL: string;
begin
  with ADOQueryInitial do begin
    Connection := DataModule_3F.ADOConnection_Main;
    Active := false;
    SQL.Clear;
    strSQL := 'select bandid,initdate,appid,shopid,id_type,id_typename,coin,operatorno,operatetime from t_id_init order by operatetime desc limit 10';
    ICFunction.loginfo('strSQL: ' + strSQL);
    SQL.Add(strSQL);
    Active := True;
  end;
  result := '1';
end;


procedure TfrmInitial.saveInitialRecord(); //保存充值记录
var
  strID3F, strBandid, strShopID, strTypeID, strOperateTime, strOperatorNO, strAppID, strIDTypeName, strCoin, strsql: string;
begin

  strBandid := trim(edtBandID.Text);
  strID3F := Receive_CMD_ID_Infor.ID_3F;
  strAppID := trim(edtAPPID.Text);

 // strIDTypeName := ICFunction.transferTypeIDToTypeName(edtTypeID.Text);
  strIDTypeName := cbCoinType.Text;
  strShopID := ICFunction.getInitShopIDByTypeName(strIDTypeName);
//  strTypeID := edtTypeID.Text; //这里不能使用Receive_CMD_ID_Infor.?因为这个值一直在变？  应该使用returnfromReadCMD指令里的值?
  strTypeID := ICFunction.transferTypeNameToTypeID(strIDTypeName);
  //strCoin := edtCoin.Text;//这里读取到的还是上一张卡返回来的ID_Value值的数据
   // strCoin := ICFunction.getInitValueByTypeName(strIDTypeName);
   // strCoin := trim(edtCoinCost.Text);

 if (strTypeID = 'A5') then //用户卡
  begin
    strCoin := Trim(edtCoin.Text);
  end
  else if (strTypeID = 'DD') then //开机卡
  begin
   strCoin := SGBTCONFIGURE.coinlimit;

  end
  else if (strTypeID = '72') then //　设置卡
  begin
  strCoin := trim(edtCoinCost.Text);
  end
  else if (strTypeID = '4A') then // 采集卡
  begin
   strCoin := '0';
  end;


    //指定日期格式 重要
  ShortDateFormat := 'yyyy-MM-dd'; //指定格式即可
  DateSeparator := '-';
    //指定日期格式 否则会报is not an valid date and time;
  strOperatorNO := G_User.UserNO;
  strOperateTime := FormatDateTime('yyyy-MM-dd HH:mm:ss', now);

  //这里只是追加数据,不负责显示
  with ADOQueryInitial do begin
    Connection := DataModule_3F.ADOConnection_Main;
    Active := false;
    SQL.Clear;
    strSQL := 'select bandid,initdate,appid,shopid,id_type,id_typename,coin,operatorno,operatetime from t_id_init order by operatetime desc'; //为什么要查全部？
    ICFunction.loginfo('Initial database append　strSQL: ' + strSQL);
    SQL.Add(strSQL);
    Active := True;
    Append;
    FieldByName('bandid').AsString := strBandid;
    FieldByName('initdate').AsString := strID3F;
    FieldByName('appid').AsString := strAppID;
    FieldByName('shopid').AsString := strShopID;
    FieldByName('id_type').AsString := strTypeID;
    FieldByName('id_typename').AsString := strIDTypeName;
    FieldByName('coin').AsString := strCoin;
    FieldByName('operatorno').AsString := strOperatorNo;
    FieldByName('operatetime').AsString := strOperatetime;
    post;
  end;

end;

procedure TfrmInitial.checkCMDInfo();
var
  tmpStr: string;
begin
   //首先截取接收的信息

  tmpStr := recDataLst.Strings[0];


  ICCommunalVarUnit.Receive_CMD_ID_Infor.ID_CheckNum := copy(tmpStr, 39, 4); //校验和
  ICCommunalVarUnit.CMD_CheckSum_OK := true;
  ICCommunalVarUnit.Receive_CMD_ID_Infor.CMD := copy(recDataLst.Strings[0], 1, 2); //帧头43

  ICFunction.loginfo('Initial: return from card : ' + tmpStr);
  if ICCommunalVarUnit.Receive_CMD_ID_Infor.CMD = CMD_COUMUNICATION.CMD_READ then //收到卡头写入电子币充值成功的返回 53
  begin
    returnFromReadCMD();
  end
  else if Receive_CMD_ID_Infor.CMD = ICCommunalVarUnit.CMD_COUMUNICATION.CMD_INCValue_RE then //读指令
  begin
   // returnFromIncrCMD(); //充值
    lblMessage.Caption := '圈存成功';
  end;


end;


//卡头返回充值成功指令

procedure TfrmInitial.returnFromIncrCMD();
var
  strResponseStr, strURL, strResultCode: string;
  jsonApplyResult, jsonAckResult: TlkJSONbase;
begin

  begin
    saveInitialRecord(); //保存充值记录
    initCoinRecord();

  end;
end;


//卡头返回信息读取指令

procedure TfrmInitial.returnFromReadCMD();
begin
  Receive_CMD_ID_Infor.ID_INIT := copy(recDataLst.Strings[0], 3, 8); //卡ID
  Receive_CMD_ID_Infor.ID_3F := copy(recDataLst.Strings[0], 11, 6); //卡厂ID--暂时没用，但需要占位6
  Receive_CMD_ID_Infor.Password_3F := copy(recDataLst.Strings[0], 17, 6); //appid
  Receive_CMD_ID_Infor.Password_USER := copy(recDataLst.Strings[0], 23, 6); //shopid
  Receive_CMD_ID_Infor.ID_value := copy(recDataLst.Strings[0], 29, 8); //卡内数据
  Receive_CMD_ID_Infor.ID_type := copy(recDataLst.Strings[0], 37, 2); //卡功能类型

  showCardInformation();

    //本场地卡检查 -----开始

 // if DataModule_3F.queryExistInitialRecord(Receive_CMD_ID_Infor.ID_INIT) = false then //没记录
 // begin
//    lblMessage.Caption := '请先初始化！';
 //   exit;
  //end



end;


//卡功能下拉列表实始化

procedure TfrmInitial.initComboxCardtype;
begin
  cbCoinType.Items.clear();
  cbCoinType.Items.Add(copy(INit_Wright.User, 1, 6)); //用户卡A5
  cbCoinType.Items.Add(copy(INit_Wright.SETTING, 1, 6)); //设置卡72

  if rootEnable = true then
  begin

    cbCoinType.Items.Add(copy(INit_Wright.MANEGER, 1, 6)); //采集卡4A
    cbCoinType.Items.Add(copy(INit_Wright.OPERN, 1, 6)); //开机卡DD

  end; //进入最高权限

end;



//用户卡信息展示

procedure TfrmInitial.showCardInformation();
begin

  edtBandID.Text := Receive_CMD_ID_Infor.ID_INIT; //用户币ID
  edtTypeID.Text := Receive_CMD_ID_Infor.ID_type;
  edtCoin.Text := ICFunction.transferHEXByteToDECValue(Receive_CMD_ID_Infor.ID_value);
  lblMessage.Caption := '此卡为 ' + ICFunction.transferTypeIDToTypeName(edtTypeID.text);

end; //end


//开始圈存

procedure TfrmInitial.initIncrOperation(strRechargeCoin: string);
var
  strValue: string;
begin
  strValue := caluSendCMD(CMD_COUMUNICATION.CMD_INCValue, strRechargeCoin); //计算充值指令
  generateIncrValueCMD(strValue); //把充值指令写入ID卡
  ICFunction.loginfo('Initial: Data send to card : ' + strValue);
end;
//充值函数

//生成充值的操作指令

procedure TfrmInitial.generateIncrValueCMD(S: string);
begin
  orderLst.Clear();
  recDataLst.Clear();
  curOrderNo := 0;
  curOperNo := 2;
  orderLst.Add(S); //将充值指令写入缓冲
  prcSendDataToCard(); //写入卡头　
end;

//计算充值指令

function TfrmInitial.caluSendCMD(strCMD: string; strIncrValue: string): string;
var
  TmpStr_CheckSum: string; //校验和
  TmpStr_SendCMD: string; //指令内容
  reTmpStr, strTypeID: string;
begin

  INit_3F.CMD := StrCMD; //帧命令
  INit_3F.ID_INIT := edtBandID.Text; //币ID
  INit_3F.ID_3F := FormatDateTime('yyMMdd', now);
  INit_3F.Password_3F := SGBTCONFIGURE.appid;
  INit_3F.ID_type := ICFunction.transferTypeNameToTypeID(cbCoinType.Text); //取得卡类型的值  圈存的是正确的ID
  strTypeID := ICFunction.transferTypeNameToTypeID(cbCoinType.Text);
  if (strTypeID = 'A5') then //用户卡
  begin
    INit_3F.Password_USER := SGBTCONFIGURE.shopid;
    INit_3F.ID_value := '00000000';
  end
  else if (strTypeID = 'DD') then //开机卡
  begin
    INit_3F.Password_USER := SGBTCONFIGURE.shopid;
    //设置的限额来自配置文件
    INit_3F.ID_value := ICFunction.transferDECValueToHEXByte(SGBTCONFIGURE.coinlimit);  

  end
  else if (strTypeID = '72') then //　设置卡
  begin
    INit_3F.ID_3F := FormatDateTime('yyyyMM', now);
    INit_3F.Password_USER := FormatDateTime('ddhhmm', now);
//    INit_3F.ID_value := ICFunction.transferDECValueToHEXByte(SGBTCONFIGURE.coincost);
    INit_3F.ID_value := ICFunction.transferDECValueToHEXByte(trim(edtCoinCost.Text));
  end
  else if (strTypeID = '4A') then // 采集卡
  begin
    INit_3F.Password_USER := SGBTCONFIGURE.shopid;
    INit_3F.ID_value := '00000000';
  end;

  //汇总发送内容
  TmpStr_SendCMD := INit_3F.CMD + INit_3F.ID_INIT + INit_3F.ID_3F + INit_3F.Password_3F + INit_3F.Password_USER + INit_3F.ID_value + INit_3F.ID_type;
  TmpStr_CheckSum := ICFunction.checkSUMData(TmpStr_SendCMD);
  INit_3F.ID_CheckNum := ICFunction.transferCheckSumByte(TmpStr_CheckSum);
  reTmpStr := TmpStr_SendCMD + INit_3F.ID_CheckNum;
  result := reTmpStr;
end;







procedure TfrmInitial.prcSendDataToCard();
var
  orderStr: string;
begin
  if orderLst.Count > curOrderNo then
  begin
    orderStr := orderLst.Strings[curOrderNo];
    orderStr := ICFunction.funcTransferExchData(orderStr);
    commInitial.WriteCommData(pchar(orderStr), length(orderStr)); //真正写到卡头
    inc(curOrderNo); //累加
  end;
end;

procedure TfrmInitial.commInitialReceiveData(Sender: TObject; Buffer: Pointer;
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



procedure TfrmInitial.FormShow(Sender: TObject);
begin

   //初始化卡功能下拉框

  edtAPPID.Text := '';
  edtShopID.Text := '';
  edtBandID.Text := '';
  edtTypeID.Text := '';
  edtCoin.Text := '';

  label5.Visible := false;
  edtTypeID.Visible := false;

  initComboxCardtype();
  initCoinRecord();

  //初始化变量
  orderLst := TStringList.Create;
  recDataLst := tStringList.Create;
  edtAPPID.Text := SGBTCONFIGURE.appid;
  edtShopID.Text := SGBTCONFIGURE.shopid;

  //打开串口
//  commInitial.StartComm();
  try
    commInitial.StartComm();
  except on E: Exception do //拦截所有异常
    begin
      showmessage(SG3FERRORINFO.commerror+ e.message);
      exit;
    end;
  end;



end;

procedure TfrmInitial.formClose(Sender: TObject; var Action: TCloseAction);
begin
  //
  orderLst.Free;
  recDataLst.Free;
  commInitial.StopComm();

end;

procedure TfrmInitial.btnInitialClick(Sender: TObject);
var
  intWriteValue: Integer;
  jsonApplyResult, jsonAckResult: TlkJSONbase;
  strURL, strResponseStr, strTypeID: string;
  ResponseStream: TStringStream; //返回信息
  activeIdHTTP: TIdHTTP;
begin


  if DataModule_3F.queryExistInitialRecord(trim(edtBandID.Text)) = true then
  begin
    if MessageBox(handle, '已经初始化，继续将会清空余额!', '警告', MB_OKCANCEL) = IDCANCEL then
      exit;
  end;
  intWriteValue := 0; //初始化时币值设定为0



 //圈存
  initIncrOperation(intToStr(intWriteValue));

      //入库
  saveInitialRecord();

  //刷新数据展示
  initCoinRecord();

  if SGBTCONFIGURE.enableInterface = '0' then
  begin
    if (cbCoinType.Text = copy(INit_Wright.User, 1, 6)) then //用户卡
    begin
      jsonApplyResult := TlkJSONbase.Create();
      strURL := generateActiveURL();
      ICFunction.loginfo('Active URL:' + strURL);      
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
      ICFunction.loginfo('Active Response:' + strResponseStr);
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

  end;



  lblMessage.Caption := '初始化成功';

end;


procedure TfrmInitial.btnBindWeiXinClick(Sender: TObject);
var
  strURL: string;
  qCode: TQRCode;
begin
    //卡类型判断
  if (edtTypeID.text = copy(INit_Wright.User, 8, 2)) then //用户卡
  begin
    strURL := generateBindWeiWinURL();
    qCode := TQRCode.Create(Self);
    qCode.Clear;
    qCode.Mode := qrPlus; //二维码模式
    qCode.Eclevel := 1; //错误修正:0 ~ 3
    qCode.Pxmag := 1;
    qCode.Version := 10 + 1; //二维码版本:1 ~ 40
    qCode.SymbolPicture := picBMP;
    qCode.Match := True;
    qCode.Usejis := False;
    qCode.Code := strURL; //二维码数据
    qCode.BackColor := clWhite;
    qCode.SymbolColor := clBlack;
    qCode.Angle := 0;
  //将生成的图像数据放入image
    imgCode.Canvas.StretchDraw(Rect(0, 0, 300, 300), qCode.Picture.Bitmap);
    qCode.Free;
  end;


end;

//生成绑定微信URL

function TfrmInitial.generateBindWeiWinURL(): string;
var
  strURL, appId, bandId, shopId, timestamp, strSignature, strActiveURL, strhkscURL: string;
begin
  appId := SGBTCONFIGURE.appid;
  bandId := trim(edtBandID.text);
  shopId := SGBTCONFIGURE.shopid;
  timestamp := getTimestamp();
  strSignature := getBindWeiXinSignature(appId, bandId, shopId, timestamp);
  strActiveURL := SGBTCONFIGURE.bindurl;
  strhkscURL := SGBTCONFIGURE.hkscurl;

  strURL := strhkscURL + strActiveURL
    + '?appId=' + appId
    + '&bandId=' + bandId
    + '&shopId=' + shopId
    + '&timestamp=' + timestamp
    + '&sign=' + strSignature;
  ICFunction.loginfo('Weisin bind URL:' + strURL);
  result := strURL;
end;

//绑定微信签名算法

function TfrmInitial.getBindWeiXinSignature(appId: string; bandId: string; shopId: string; timeStamp: string): string;
var
  strTempC, strTempD: string;
  myMD5: TIdHashMessageDigest5;
begin
  myMD5 := TIdHashMessageDigest5.Create;
  strTempC := 'appId' + appId
    + 'bandId' + bandId
    + 'shopId' + shopId
    + 'timestamp' + timeStamp; //按字符顺序排序

  strTempD := strTempC + SGBTCONFIGURE.secret_key; //加上secret_key
  result := LowerCase(myMD5.AsHex(myMD5.HashValue(strTempD))); //计算字符串的MD5,并返回小写
  myMD5.Free;

end;




 //拼接激活接口URL

function TfrmInitial.generateActiveURL(): string;
var
  strURL, strAppID, strBandID, strShopID, strTimeStamp, strSignature, strActiveURL, strhkscURL: string;
begin
  strAppID := SGBTCONFIGURE.appid;
  strBandID := edtBandID.Text;
  strShopID := SGBTCONFIGURE.shopid;
  strTimeStamp := getTimestamp();
  strSignature := getActiveSignature(strBandID, strAppID, strShopID, strTimeStamp);
  strActiveURL := SGBTCONFIGURE.activeurl;
  strhkscURL := SGBTCONFIGURE.hkscURL;

  strURL := strhkscURL + strActiveURL + '?bandId=' + strBandID
    + '&appId=' + strAppID + '&shopId=' + strShopID + '&timestamp=' + strTimeStamp
    + '&sign=' + strSignature;

  result := strURL;
end;



//激活请求签名算法

function TfrmInitial.getActiveSignature(bandId: string; appId: string; shopId: string; timeStamp: string): string;
var
  strTempC, strTempD: string;
  myMD5: TIdHashMessageDigest5;
begin
  myMD5 := TIdHashMessageDigest5.Create;
  strTempC := 'appId' + appId + 'bandId' + bandId + 'shopId' + shopId + 'timestamp' + timeStamp; //按字符顺序排序
  strTempD := strTempC + SGBTCONFIGURE.secret_key; //加上secret_key
  result := LowerCase(myMD5.AsHex(myMD5.HashValue(strTempD))); //计算字符串的MD5,并返回小写
  myMD5.Free;

end;



end.

