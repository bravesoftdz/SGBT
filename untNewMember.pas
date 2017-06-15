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
    edtTypeName: TEdit;
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

        //���ݿ����
    function initDBRecord(): string;
    procedure saveDBRecord(); //�����ֵ��¼
        //��ͷ������
    procedure checkCMDInfo();
    procedure initIncrOperation(strRechargeCoin: string); //��ֵ������д���ݸ���
    function caluSendCMD(strCMD: string; strIncrValue: string): string;
    procedure generateIncrValueCMD(S: string);
    procedure prcSendDataToCard();
    procedure displayCardInformation();
    procedure returnFromOperationCMD();
    procedure returnFromReadCMD();
    function checkCoinLimit(strWriteValue: string): boolean;

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


procedure TfrmNewMember.FormShow(Sender: TObject);
begin


  //��ʼ�����ݿ�����
  initDBRecord();

  //��ʼ����������
  edtAPPID.Text := SGBTCONFIGURE.appid;
  edtShopID.Text := SGBTCONFIGURE.shopid;

  //��ʼ������
  orderLst := TStringList.Create;
  recDataLst := tStringList.Create;
  try
    commRecharge.StartComm();
  except on E: Exception do //���������쳣
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
    strSQL := 'select MEMBER_NO,CARD_ID,MOBILE_NO,APPID,SHOPID,CREATED_BY,CREATED_AT ' +
             ' from t_recharge_record ' +
             ' order by CREATED_AT desc limit 10';
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
 
  ICFunction.loginfo('data return from Terminal : ' + tmpStr);
  if ICCommunalVarUnit.Receive_CMD_ID_Infor.CMD = CMD_COUMUNICATION.CMD_READ then //�յ���ͷд����ӱҳ�ֵ�ɹ��ķ��� 53
  begin
    returnFromReadCMD();//������
  end
  else if Receive_CMD_ID_Infor.CMD = ICCommunalVarUnit.CMD_COUMUNICATION.CMD_INCValue_RE then //��ָ��
  begin
    returnFromOperationCMD();  //��������
  end;

end;


//��ͷ���س�ֵ�ɹ�ָ��

procedure TfrmNewMember.returnFromOperationCMD();
begin
   //�޸�״̬
  if (Receive_CMD_ID_Infor.ID_type = copy(INit_Wright.User, 8, 2)) then
  begin
    saveDBRecord(); //�����ֵ��¼
    initDBRecord();
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

  if DataModule_3F.queryExistInitialRecord(Receive_CMD_ID_Infor.ID_INIT) = false then //�û����Ѿ���ʼ�� �м�¼
  begin
      lblMessage.Caption := '���ȳ�ʼ����';
      exit;
  end
  else
  begin
      displayCardInformation();
  end;


end;





procedure TfrmNewMember.displayCardInformation();
begin
  edtBandID.Text := Receive_CMD_ID_Infor.ID_INIT; 
  //read from Database by CardID and display in View todo...
  
end;









//�����ʼ������,������ȫ�ֱ���
//д��ֵ��¼

procedure TfrmNewMember.saveDBRecord();
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


procedure TfrmNewMember.btnCancelClick(Sender: TObject);
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

//��Ա��������

procedure TfrmNewMember.btnSubmitClick(Sender: TObject);

var
  cardid,cardtype,mobileno :string;
begin
  cardid  :=Trim(edtBandID);
  cardtype :=Trim(edtTypeName);
  mobileno :=Trim(edtMobileNO);
  initialMemberInfo(cardid,cardtype,mobileno);
  initailAccountInfo(cardid,cardtype,mobileno);
  initDBRecord();
  lblMessage.Caption := '��Ա�����ɹ�';

end;



end.

