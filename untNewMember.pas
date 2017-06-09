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

        //���ݿ����
    function initRechargeRecord(): string;
    procedure saveRechargeRecord(); //�����ֵ��¼
        //��ͷ������
    procedure checkCMDInfo();
    procedure initIncrOperation(strRechargeCoin: string); //��ֵ������д���ݸ���
    function caluSendCMD(strCMD: string; strIncrValue: string): string;
    procedure generateIncrValueCMD(S: string);
    procedure prcSendDataToCard();
    procedure showCardInformation();
    procedure returnFromIncrCMD();
    procedure returnFromReadCMD();
    function checkCoinLimit(strWriteValue: string): boolean;

    //���³�ֵ����ӿ�
    //function offlineRechargeApplyInterface() :TlkJSONbase;
    function generateOfflineRechargeApplyURL(): string;
    function getOfflineRechargeApplySignature(appId: string; bandId: string; coin: string; money: string; restCoin: string; shopId: string; timeStamp: string): string;

    //���³�ֵȷ�Ͻӿ�
  //  function offlineRechargeAckInterface() :TlkJSONbase;
    function generateOfflineRechargeAckURL(haokuTrxId: string; trxId: string): string;
    function getOfflineRechargeAckSignature(appId: string; bandId: string; haokuTrxId: string; shopId: string; timeStamp: string; trxId: string): string;



    //���ϳ�ֵ����ӿ�

    function generateOnlineRechargeApplyURL(): string;
    function getOnlineRechargeApplySignature(appId: string; bandId: string; restCoin: string; shopId: string; timeStamp: string): string;

    //���ϳ�ֵȷ�Ͻӿ�
    function generateOnlineRechargeAckURL(haokuTrxId: string; trxId: string): string;
    function getOnlineRechargeAckSignature(appId: string; bandId: string; haokuTrxId: string; shopId: string; timeStamp: string; trxId: string): string;

  end;

var
  frmNewMember: TfrmNewMember;
  curOrderNo: integer = 0; //???
  curOperNo: integer = 0;
  Operate_No: integer = 0; //ʲô����?������ڳ�ֵ��
  orderLst, recDataLst: Tstrings; //����ȫ�ֱ����������ݣ���������
  ID_UserCard_Text: string;
  IncValue_Enable: boolean; //�Ƿ������ֵ�ı�־,��Ա����֤ͨ������ΪTrue
  buffer: array[0..2048] of byte;

  //ȫ�ֱ�����������SG3Fƽ̨����ID;
  GLOBALsg3ftrxID: string; //
  GLOBALstrPayID: string; //֧����ʽ������01/�ֽ�02


implementation
uses ICDataModule, ICCommunalVarUnit, ICmain, ICEventTypeUnit, ICFunctionUnit, dateProcess, strprocess, IdHashMessageDigest, IdHTTP;
{$R *.dfm}


//-----------------------���ϳ�ֵ-----------------------------------------------------------------


 //���ϳ�ֵ����ӿ�URL

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



//���ϳ�ֵ����ǩ���㷨

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
    + 'timestamp' + timeStamp; //���ַ�˳������

  strTempD := strTempC + SGBTCONFIGURE.secret_key; //����secret_key
  result := LowerCase(myMD5.AsHex(myMD5.HashValue(strTempD))); //�����ַ�����MD5,������Сд
  myMD5.Free;

end;





 //���ϳ�ֵȷ�Ͻӿ�URL

function TfrmNewMember.generateOnlineRechargeAckURL(haokuTrxId: string; trxId: string): string;
var
  strURL, appId, bandId, shopId, timestamp, strSignature, strActiveURL, strhkscURL: string;
begin
  appId := SGBTCONFIGURE.appid;
  bandId := edtBandID.Text;
  //haokuTrxId := edtLeftCoin.Text; // ��Ҫ����Ӧ�з���
  shopId := SGBTCONFIGURE.shopid;
  timestamp := getTimestamp();
  strSignature := getOnlineRechargeAckSignature(appId, bandId, haokuTrxId, shopId, timestamp, trxId); //�ַ�˳��
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



//���ϳ�ֵȷ��ǩ���㷨

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
    + 'trxId' + trxId; //���ַ�˳������

  strTempD := strTempC + SGBTCONFIGURE.secret_key; //����secret_key
  result := LowerCase(myMD5.AsHex(myMD5.HashValue(strTempD))); //�����ַ�����MD5,������Сд
  myMD5.Free;

end;



//-----------------------���³�ֵ-----------------------------------------------------------------



 //ƴ�����³�ֵ����ӿ�URL

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



//���³�ֵ����ǩ���㷨

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
    + 'timestamp' + timeStamp; //���ַ�˳������

  strTempD := strTempC + SGBTCONFIGURE.secret_key; //����secret_key
  result := LowerCase(myMD5.AsHex(myMD5.HashValue(strTempD))); //�����ַ�����MD5,������Сд
  myMD5.Free;

end;




 //ƴ�����³�ֵȷ�Ͻӿ�URL

function TfrmNewMember.generateOfflineRechargeAckURL(haokuTrxId: string; trxId: string): string;
var
  strURL, appId, bandId, shopId, timestamp, strSignature, strActiveURL, strhkscURL: string;
begin
  appId := SGBTCONFIGURE.appid;
  bandId := edtBandID.Text;
  //  haokuTrxId  := edtLeftCoin.Text; // ��Ҫ����Ӧ�з���
  shopId := SGBTCONFIGURE.shopid;
  timestamp := getTimestamp();
  //  trxId      :=  edtRechargeCoin.Text; // ��Ҫ����Ӧ�з���

  strSignature := getOfflineRechargeAckSignature(appId, bandId, haokuTrxId, shopId, timestamp, trxId); //�ַ�˳��
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



//���³�ֵȷ��ǩ���㷨

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
    + 'trxId' + trxId; //���ַ�˳������

  strTempD := strTempC + SGBTCONFIGURE.secret_key; //����secret_key
  result := LowerCase(myMD5.AsHex(myMD5.HashValue(strTempD))); //�����ַ�����MD5,������Сд
  myMD5.Free;

end;

//-----------------------���³�ֵ-----------------------------------------------------------------



procedure TfrmNewMember.FormShow(Sender: TObject);
begin


  //��ʼ��
  initRechargeRecord();

  //��ʼ������
  orderLst := TStringList.Create;
  recDataLst := tStringList.Create;

  edtAPPID.Text := SGBTCONFIGURE.appid;
  edtShopID.Text := SGBTCONFIGURE.shopid;

  //�򿪴���
//  commRecharge.StartComm();
  try
    commRecharge.StartComm();
  except on E: Exception do //���������쳣
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
   //����----------------
  recStr := '';

  SetLength(tmpStr, BufferLength);
  move(buffer^, pchar(tmpStr)^, BufferLength);
  for i := 1 to BufferLength do
  begin
    recStr := recStr + intTohex(ord(tmpStr[i]), 2); //���������ת��Ϊ16������
    if i = BufferLength then
    begin
      tmpStrend := 'END';
    end;
  end;
  recDataLst.Clear;
  recDataLst.Add(recStr);
  ICFunction.loginfo('recharge return from card recStr: ' + recStr);
  begin
    checkCMDInfo(); //���ȸ��ݽ��յ������ݽ����жϣ�ȷ�ϴ˿��Ƿ�����Ϊ��ȷ�Ŀ�
  end;
end;


procedure TfrmNewMember.checkCMDInfo();
var
  tmpStr: string;
begin
   //���Ƚ�ȡ���յ���Ϣ

  tmpStr := recDataLst.Strings[0];
  ICCommunalVarUnit.Receive_CMD_ID_Infor.ID_CheckNum := copy(tmpStr, 39, 4); //У���
  ICCommunalVarUnit.CMD_CheckSum_OK := true;
  ICCommunalVarUnit.Receive_CMD_ID_Infor.CMD := copy(recDataLst.Strings[0], 1, 2); //֡ͷ43
 
  ICFunction.loginfo('data return from recharge : ' + tmpStr);
  if ICCommunalVarUnit.Receive_CMD_ID_Infor.CMD = CMD_COUMUNICATION.CMD_READ then //�յ���ͷд����ӱҳ�ֵ�ɹ��ķ��� 53
  begin
    returnFromReadCMD();
  end
  else if Receive_CMD_ID_Infor.CMD = ICCommunalVarUnit.CMD_COUMUNICATION.CMD_INCValue_RE then //��ָ��
  begin
    returnFromIncrCMD();
  end;

end;


//��ͷ���س�ֵ�ɹ�ָ��

procedure TfrmNewMember.returnFromIncrCMD();
begin

  if (Receive_CMD_ID_Infor.ID_type = copy(INit_Wright.User, 8, 2)) then
  begin
    saveRechargeRecord(); //�����ֵ��¼
    initRechargeRecord();
  end;
end;


//��ͷ������Ϣ��ȡָ��

procedure TfrmNewMember.returnFromReadCMD();
begin
  Receive_CMD_ID_Infor.ID_INIT := copy(recDataLst.Strings[0], 3, 8); //��ƬID
  Receive_CMD_ID_Infor.ID_3F := copy(recDataLst.Strings[0], 11, 6); //����ID
  Receive_CMD_ID_Infor.Password_3F := copy(recDataLst.Strings[0], 17, 6); //appid
  Receive_CMD_ID_Infor.Password_USER := copy(recDataLst.Strings[0], 23, 6); //shopid
  Receive_CMD_ID_Infor.ID_value := copy(recDataLst.Strings[0], 29, 8); //��������
  Receive_CMD_ID_Infor.ID_type := copy(recDataLst.Strings[0], 37, 2); //������

    //�����ؿ���� -----��ʼ  �ӵ��ӱ��϶�ȡ�ĳ���������������ļ����ȡ�Ĳ�һ��
  if (Receive_CMD_ID_Infor.Password_3F <> SGBTCONFIGURE.appid) then //    INit_Wright.BossPassword := MyIni.ReadString('PLC��������', 'PC����������', '������');
  begin
    lblMessage.Caption := '�Ǳ����ش˿����������';
    exit;
  end
  else
  begin //���س�ʼ����� -----��ʼ
    if DataModule_3F.queryExistInitialRecord(Receive_CMD_ID_Infor.ID_INIT) = false then //�û����Ѿ���ʼ�� �м�¼
    begin
      lblMessage.Caption := '���ȳ�ʼ����';
      exit;
    end
    else
    begin
      showCardInformation();
    end;
  end;

end;




//�û�����Ϣչʾ

procedure TfrmNewMember.showCardInformation();
begin
  //  edtAPPID.Text  := Receive_CMD_ID_Infor.Password_3F;   //appid
  //  edtShopID.Text := Receive_CMD_ID_Infor.Password_USER; //shopid
  edtBandID.Text := Receive_CMD_ID_Infor.ID_INIT; //�û���ID
  edtLeftCoin.Text := ICFunction.transferHEXByteToDECValue(Receive_CMD_ID_Infor.ID_value);
  edtTypeName.Text := ICFunction.transferTypeIDToTypeName(Receive_CMD_ID_Infor.ID_type);

end; //end prc_user_card_operation










//�����ʼ������,������ȫ�ֱ���
//д��ֵ��¼

procedure TfrmNewMember.saveRechargeRecord();
var
  strTrxid, strAppID, strBandid, strShopid, strPayid, strOperateTime, strOperatorNO, strPayState, strNote, strExpireTime, strsql: string;
  intCoin, intLeftCoin, intTotalCoin: Integer;

begin

  strAppID := trim(edtAppID.Text);
  strBandid := trim(edtBandID.Text);
  strShopid := trim(edtShopID.Text);
  intCoin := strToInt(trim(edtRechargeCoin.Text)); //������ò�Ҫ��edit���ֵ������������λreset��
  intLeftCoin := strToInt(trim(edtLeftCoin.Text));
  intTotalCoin := intLeftCoin + intCoin;
  strTrxid := GLOBALsg3ftrxID;

  strPayid := GLOBALstrPayID; //01��ʾ����,02��ʾ�ֽ�

    //ָ�����ڸ�ʽ ��Ҫ
  ShortDateFormat := 'yyyy-MM-dd'; //ָ����ʽ����
  DateSeparator := '-';
    //ָ�����ڸ�ʽ ����ᱨis not an valid date and time;

  strOperateTime := FormatDateTime('yyyy-MM-dd HH:mm:ss', now);
  strOperatorNO := '001';
  strPayState := '0'; //0��ʾ�ɹ�
  strNote := '��ֵ';
  strExpireTime := FormatDateTime('yyyy-MM-dd HH:mm:ss', now);

  with ADOQRecharge do begin
    Connection := DataModule_3F.ADOConnection_Main;
    Active := false;
    SQL.Clear;
    strSQL := 'select * from t_recharge_record order by operatetime desc'; //ΪʲôҪ��ȫ����
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
    FieldByName('operatetime').AsString := strOperateTime; //�û���
    FieldByName('operatorno').AsString := strOperatorNO; //��ֵ����
    FieldByName('paystate').AsString := strPayState; //
    FieldByName('note').AsString := strNote;
  //  FieldByName('expiretime').AsString := strExpireTime; //ʧЧʱ��
    post;
  end;
  GLOBALsg3ftrxID := strTrxid;

end;


procedure TfrmNewMember.initIncrOperation(strRechargeCoin: string);
var
  strValue: string;
begin
  strValue := caluSendCMD(CMD_COUMUNICATION.CMD_INCValue, strRechargeCoin); //�����ֵָ��
  generateIncrValueCMD(strValue); //�ѳ�ֵָ��д��ID��
  ICFunction.loginfo('recharge data send to card: ' + strValue);
end;
//��ֵ����
//�����ֵָ��

function TfrmNewMember.caluSendCMD(strCMD: string; strIncrValue: string): string;
var
  TmpStr_CheckSum: string; //У���
  TmpStr_SendCMD: string; //ָ������
  reTmpStr: string;
begin
  Send_CMD_ID_Infor.CMD := StrCMD; //֡����ͷ��51
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


//���ɳ�ֵ�Ĳ���ָ��

procedure TfrmNewMember.generateIncrValueCMD(S: string);
begin
  orderLst.Clear();
  recDataLst.Clear();
  curOrderNo := 0;
  curOperNo := 2;
  orderLst.Add(S); //����ֵָ��д�뻺��
  prcSendDataToCard(); //д�뿨ͷ��
end;

procedure TfrmNewMember.prcSendDataToCard();
var
  orderStr: string;
begin
  if orderLst.Count > curOrderNo then
  begin
    orderStr := orderLst.Strings[curOrderNo];
    orderStr := ICFunction.funcTransferExchData(orderStr);
    commRecharge.WriteCommData(pchar(orderStr), length(orderStr)); //����д����ͷ
    inc(curOrderNo); //�ۼ�
  end;
end;


procedure TfrmNewMember.btnOfflineRechargeClick(Sender: TObject);
var
  strRechargeCoin, strLeftCoin: string;
  strURL, strResponseStr: string;
  intWriteValue: Integer;
  jsonApplyResult, jsonAckResult: TlkJSONbase;
  ResponseStream: TStringStream; //������Ϣ
  activeIdHTTP: TIdHTTP;

begin
  //��ʼ��֧����ʽ
  GLOBALstrPayID := '02';
  //��ʼ������ID
  GLOBALsg3ftrxID := trim(edtAPPID.Text) + trim(edtShopID.Text) + trim(edtBandID.Text) + FormatDateTime('HHmmss', now);

  strRechargeCoin := trim(edtRechargeCoin.Text);
  strLeftCoin := trim(edtLeftCoin.Text);
  intWriteValue := strToInt(strRechargeCoin) + strToInt(strLeftCoin);

  //��ֵ����������ʽУ�鼰����޶�
  //�������ж�
  if ((ICFunction.transferTypeNameToTypeID(edtTypeName.text) <> copy(INit_Wright.User, 8, 2))) then //�û���
  begin
    lblMessage.Caption := edtTypeName.text + '�������ڳ�ֵ';
    exit;
  end;
  if IsNumberic(strRechargeCoin) = false then
  begin
    MessageBox(handle, '��������ȷ�Ľ��', '����', MB_ICONERROR + MB_OK);
    exit;
  end;
  if checkCoinLimit(intToStr(intWriteValue)) then
  begin
    MessageBox(handle, '��ֵ�ܶ���޶�!', '����', MB_ICONERROR + MB_OK);
    exit;
  end;

  //{�ر�HK�ӿ�
//{  //���³�ֵ����
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
    //��ȡ��ҳ���ص���Ϣ   ��ҳ�еĴ�������ʱ����Ҫ����UTF8����
    strResponseStr := UTF8Decode(ResponseStream.DataString);


    ICFunction.loginfo('Offline Recharge Response: ' + strResponseStr);

    jsonApplyResult := TlkJSON.ParseText(UTF8Encode(strResponseStr)) as TlkJSONobject; //UTF8����
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
  //����Ȧ��/���
  initIncrOperation(IntToStr(intWriteValue)); //������εõ�ƽ̨����ID ������һ��ȫ�ֱ��� strGlobalSGtrxID


  //{  //{�ر�HK�ӿ�
  //���³�ֵȷ��,����ͨ��jsonApplyResult���ܻ������ֵ
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
    //��ȡ��ҳ���ص���Ϣ   ��ҳ�еĴ�������ʱ����Ҫ����UTF8����
    strResponseStr := UTF8Decode(ResponseStream.DataString);

    ICFunction.loginfo('Offline Recharge Ack Response: ' + strResponseStr);

    jsonApplyResult := TlkJSON.ParseText(UTF8Encode(strResponseStr)) as TlkJSONobject; //UTF8����
    if jsonApplyResult = nil then
    begin
      Showmessage(SG3FERRORINFO.networkerror);
      exit;
    end;
    if vartostr(jsonApplyResult.Field['code'].Value) <> '0' then
    begin
      Showmessage('error code:' + vartostr(jsonApplyResult.Field['code'].Value) + ',' + vartostr(jsonApplyResult.Field['message'].Value) + ',����ϵ������Ա');
      exit;
    end;
  end;
  // }
  lblMessage.Caption := '���³�ֵ�����������ֵ��¼�ɹ�';

end;


//����޶�

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

//���߳�ֵ����

procedure TfrmNewMember.btnOnlineRechargeClick(Sender: TObject);

var
  strRechargeCoin, strLeftCoin, haokuTrxId: string;
  strURL, strResponseStr: string;
  intWriteValue: Integer;
  jsonApplyResult, jsonAckResult: TlkJSONbase;
  ResponseStream: TStringStream; //������Ϣ
  activeIdHTTP: TIdHTTP;

begin
   //׷�ӿ������ж�,��������û������߿��������ܳ�ֵ? ������Ҳ����Ҫ���ͽӿڰɣ�


 //��ʼ������ID
  GLOBALsg3ftrxID := trim(edtAPPID.Text) + trim(edtShopID.Text) + trim(edtBandID.Text) + FormatDateTime('HHmmss', now);
  GLOBALstrPayID := '01';

  strLeftCoin := trim(edtLeftCoin.Text);

  //�������ж�
  if ((ICFunction.transferTypeNameToTypeID(edtTypeName.text) <> copy(INit_Wright.User, 8, 2))) then //�û���
  begin
    lblMessage.Caption := edtTypeName.text + '�������ڳ�ֵ';
    exit;
  end;



  //���ϳ�ֵ����
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
    //��ȡ��ҳ���ص���Ϣ   ��ҳ�еĴ�������ʱ����Ҫ����UTF8����
  strResponseStr := UTF8Decode(ResponseStream.DataString);
  ICFunction.loginfo('Recharge: Online Recharge ACK Response: ' + strResponseStr);
  jsonApplyResult := TlkJSON.ParseText(UTF8Encode(strResponseStr)) as TlkJSONobject; //UTF8����
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


  //�����ֵ��û�а���leftCoin
  strRechargeCoin := trim(vartostr(jsonApplyResult.Field['coin'].Value));
  edtRechargeCoin.Text := strRechargeCoin; //���ʹ�õ�����
  haokuTrxId := trim(vartostr(jsonApplyResult.Field['haokuTrxId'].Value));
  intWriteValue := strToInt(strRechargeCoin) + strToInt(strLeftCoin);
  //����޶�
  if checkCoinLimit(intToStr(intWriteValue)) then
  begin
    MessageBox(handle, '��ֵ�ܶ���޶�!', '����', MB_ICONERROR + MB_OK);
    exit;
  end;
  //Ȧ��,���
  initIncrOperation(IntToStr(intWriteValue));

  //���ϳ�ֵȷ��
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
    //��ȡ��ҳ���ص���Ϣ   ��ҳ�еĴ�������ʱ����Ҫ����UTF8����
  strResponseStr := UTF8Decode(ResponseStream.DataString);

  ICFunction.loginfo('Recharge: Online Recharge ack response :' + strResponseStr);

  jsonApplyResult := TlkJSON.ParseText(UTF8Encode(strResponseStr)) as TlkJSONobject; //UTF8����
  if jsonApplyResult = nil then
  begin
    Showmessage(SG3FERRORINFO.networkerror);
    exit;
  end;
  if vartostr(jsonApplyResult.Field['code'].Value) <> '0' then
  begin
    Showmessage('error code :' + vartostr(jsonApplyResult.Field['code'].Value) + ',' + vartostr(jsonApplyResult.Field['message'].Value) + ',����ϵ������Ա');
    exit;
  end;

  lblMessage.Caption := '���ϳ�ֵ�����������ֵ��¼�ɹ�';

end;



end.

