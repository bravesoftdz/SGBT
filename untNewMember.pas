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

        //���ݿ����
    function initDBRecord(): string;
    procedure saveDBRecord(); //�����ֵ��¼
    procedure saveMemberInfo(cardid:string; cardtype:string;mobileno:string);
    procedure saveAccountInfo(cardid:string; cardtype:string;mobileno:string);
    function  getCoinByCoinType(cointype :string):string;
  
    
        //��ͷ������
    procedure checkCMDInfo();
    procedure operateCoin(operacoin: string); //������
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
  Operate_No: integer = 0; //ʲô����?������ڳ�ֵ��
  orderLst, recDataLst: Tstrings; //����ȫ�ֱ����������ݣ���������
  ID_UserCard_Text: string;
  IncValue_Enable: boolean; //�Ƿ������ֵ�ı�־,��Ա����֤ͨ������ΪTrue
  buffer: array[0..2048] of byte;

  //ȫ�ֱ�����������SG3Fƽ̨����ID;
  GLOBALsg3ftrxID: string; //
  GLOBALstrPayID: string; //֧����ʽ������01/�ֽ�02
  operaSuccess : boolean;


implementation
uses ICDataModule, ICCommunalVarUnit, ICmain, ICEventTypeUnit, ICFunctionUnit, dateProcess, strprocess, IdHashMessageDigest, IdHTTP;
{$R *.dfm}


procedure TfrmNewMember.FormShow(Sender: TObject);
begin  
  //��ʼ������
  initComboxCardtype();
  
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
    strSQL := 'select A.CARD_ID,A.MOBILE_NO,A.APPID,A.SHOPID ' +
            ' , B.COIN_TYPE,B.TOTAL_COIN,B.EXPIRETIME,B.OPERATE_TIME,B.OPERATORNO ' +
             ' from T_MEMBER_INFO A,T_MEMBER_COIN B ' +
             ' WHERE A.COIN_CODE = B.COIN_CODE ' +
             ' order by OPERATE_TIME desc limit 10';
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
 
  ICFunction.loginfo('Read data return from Terminal : ' + tmpStr);
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
var cardid,cardtype,mobileno:string;
begin 
   //�����ɹ�      
  ICFunction.loginfo('return From OperationCMD Operate Coin Successfully ');
  cardid  :=Trim(edtBandID.Text);
  cardtype :=Trim(cbMemberType.Text);
  mobileno :=Trim(edtMobileNO.Text);
  saveMemberInfo(cardid,cardtype,mobileno);
  saveAccountInfo(cardid,cardtype,mobileno);
  initDBRecord();

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
  edtMemberNO.Text := Receive_CMD_ID_Infor.ID_INIT;
  //edtMobileNO.Text := 
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
  intCoin := strToInt(trim(edtMemberNO.Text)); //������ò�Ҫ��edit���ֵ������������λreset��
  intLeftCoin := strToInt(trim(edtMobileNO.Text));
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

  with ADOQ do begin
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


procedure TfrmNewMember.operateCoin(operacoin: string);
var
  coinvalue: string;
begin
  coinvalue := caluSendCMD(CMD_COUMUNICATION.CMD_INCValue, operacoin); //�����ֵָ��
  generateIncrValueCMD(coinvalue); //�ѳ�ֵָ��д��ID��
  ICFunction.loginfo('recharge data send to card: ' + coinvalue);
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

  lblMessage.Caption := '���³�ֵ�����������ֵ��¼�ɹ�';

end;


//����޶�

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

//��Ա��������

procedure TfrmNewMember.btnSubmitClick(Sender: TObject); 
var
  operationcoin:string;

begin
  //Coin�����
  if checkUniqueCoin(Trim(edtBandID.Text)) = true then
  begin
         lblMessage.Caption := '��Ա�Ѵ���';
         exit;
  end;
  operationcoin := getCoinByCoinType(Trim(cbMemberType.Text));
  operateCoin(operationcoin);
  
  lblMessage.Caption := '��Ա�����ɹ�';

end;



procedure TfrmNewMember.saveAccountInfo(cardid:string; cardtype:string;mobileno:string);
var
  strOperateTime, strOperatorNO, strPayState, strNote, strExpireTime, strsql: string;
  intCoin, intLeftCoin, intTotalCoin: Integer;

begin

  ShortDateFormat := 'yyyy-MM-dd'; //ָ����ʽ����
  DateSeparator := '-';
  strOperateTime := FormatDateTime('yyyy-MM-dd HH:mm:ss', now);
  strOperatorNO := SGBTCONFIGURE.shopid;
  
  with ADOQ do begin
    Connection := DataModule_3F.ADOConnection_Main;
    Active := false;
    SQL.Clear;
    strSQL := 'select * from  T_MEMBER_COIN order by OPERATE_TIME desc limit 10 '; //ΪʲôҪ��ȫ����
    ICFunction.loginfo('strSQL :' + strSQL);
    SQL.Add(strSQL);
    Active := True;
    Append;
    FieldByName('COIN_CODE').AsString := cardid;
    FieldByName('COIN_TYPE').AsString := getCoinCodeByCoinType(cbMemberType.Text);
    FieldByName('PAY_TYPE').AsString := '01';
    FieldByName('TOTAL_COIN').AsString := getCoinByCoinType(cbMemberType.Text);;
    FieldByName('COIN').AsString := getCoinByCoinType(cbMemberType.Text);;;
    FieldByName('COIN_LIMIT').AsString := getCoinLimit(cbMemberType.Text);
    FieldByName('STATE').AsString := 'S0C';
    FieldByName('EXPIRETIME').AsString := getExpireTimeByCoinType(cbMemberType.Text);
    FieldByName('OPERATE_TIME').AsString := strOperateTime; //
    FieldByName('OPERATORNO').AsString := strOperatorNO;
    post;
  end;


end;

function  TfrmNewMember.getCoinCodeByCoinType(cardtype:string):string;
begin
    if cardtype = '�꿨' then
      result := '01'
    else if cardtype = '����' then
      result:='02'
    else if cardtype = '�¿�' then
      result:='03'
   else if cardtype = '��ͨ��' then
      result:='04' ;
end;

function  TfrmNewMember.getCoinByCoinType(cointype :string):string;
begin

      result := '20';
      //�����ݿ�ȡ
end;

function  TfrmNewMember.getCoinLimit(cardtype :string):string;
begin
    result := '1000';
end;


function  TfrmNewMember.getExpireTimeByCoinType(cardtype :string):string;
begin
    if cardtype = '�꿨' then
      result :=FormatDateTime('yyyy-MM-dd HH:mm:ss', AddMonths(now,12))
    else if cardtype = '����' then
      result:=FormatDateTime('yyyy-MM-dd HH:mm:ss', AddMonths(now,3))
    else if cardtype = '�¿�' then
      result:=FormatDateTime('yyyy-MM-dd HH:mm:ss', AddMonths(now,1))
    else if cardtype = '��ͨ��' then
      result:=FormatDateTime('yyyy-MM-dd HH:mm:ss', AddMonths(now,36)) ;
end;



procedure TfrmNewMember.saveMemberInfo(cardid:string; cardtype:string;mobileno:string);
var
  strAppID, strBandid, strShopid, strPayid, strOperateTime, strOperatorNO, strPayState, strNote, strExpireTime, strsql: string;
  intCoin, intLeftCoin, intTotalCoin: Integer;
begin
   strAppID := trim(edtAppID.Text);
   strShopid := trim(edtShopID.Text);
     with ADOQ do begin
    Connection := DataModule_3F.ADOConnection_Main;
    Active := false;
    SQL.Clear;
    strSQL := 'select * from t_member_info order by OPERATE_TIME desc limit 10 '; //ΪʲôҪ��ȫ����
    ICFunction.loginfo('strSQL :' + strSQL);
    SQL.Add(strSQL);
    Active := True;
    Append;
    FieldByName('CARD_ID').AsString := cardid;
    FieldByName('MOBILE_NO').AsString := mobileno;
    FieldByName('COIN_CODE').AsString := cardid;
    FieldByName('APPID').AsString := strAppID;
    FieldByName('SHOPID').AsString := strShopid;
    FieldByName('PASSWORD').AsString := cardid;
    FieldByName('OPERATE_TIME').AsString := strOperateTime;
    FieldByName('OPERATORNO').AsString := strOperatorNO;
    post;
  end;
     
end;

procedure TfrmNewMember.initComboxCardtype;
begin
  cbMemberType.Items.clear();
  cbMemberType.Items.Add('�¿�');
  cbMemberType.Items.Add('����');
  cbMemberType.Items.Add('�꿨');
  cbMemberType.Items.Add('��ͨ��');
  
end;




end.

