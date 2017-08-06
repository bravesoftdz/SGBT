unit untMemberRecharge;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Grids, DBGrids, SPComm, DB, ADODB, uLkJSON, StrUtils;

type
  TfrmMemberRecharge = class(TForm)
    Panel1: TPanel;
    GroupBox2: TGroupBox;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    edtBandID: TEdit;
    btnSubmit: TButton;
    btnCancel: TButton;
    GroupBox3: TGroupBox;
    dgRecharge: TDBGrid;
    dsRecharge: TDataSource;
    commRecharge: TComm;
    ADOQ: TADOQuery;
    lblMessage: TLabel;

    lbl1: TLabel;
    edtLeftCoin: TEdit;
    cbRechargeTimes: TComboBox;
    lbl2: TLabel;
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
    procedure updateMemberTotalCoin(cardid:string;totalcoin:string);
    procedure saveMemberRechargeRecord(opercoin:string; totalcoin:string);
    function  getCoinByCoinType(cointype :string):string;
        //��ͷ������
    procedure checkCMDInfo();
    procedure operateCoin(operacoin: string); //������
    function  caluSendCMD(strCMD: string; strIncrValue: string): string;

    procedure generateIncrValueCMD(S: string);
    procedure prcSendDataToCard();
    procedure displayCardInformation();
    procedure returnFromOperationCMD();
    procedure returnFromReadCMD();
    procedure initcbRechargeTimes();
    function  checkCoinLimit(strWriteValue: string): boolean;
    function  checkCoinValue(coinid: string): boolean;    
    function  getCoinLimit(cardtype :string):string;
    function  queryExistInitialMemberRecord(ID_INIT: string): Boolean;
    function  getOperTypeNameByCode(opertype :string ):string;
  end;

var
  frmMemberRecharge: TfrmMemberRecharge;
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
  globalOperCoin : string; //�������
  globalOperType : string; //������ʽ01��ֵ,02����
  operaSuccess : boolean;


implementation
uses ICDataModule, ICCommunalVarUnit, ICmain, ICEventTypeUnit, ICFunctionUnit, dateProcess, strprocess, IdHashMessageDigest, IdHTTP;
{$R *.dfm}


procedure TfrmMemberRecharge.FormShow(Sender: TObject);
begin  
  //��ʼ������
  initcbRechargeTimes();
  //��ʼ�����ݿ�����
  initDBRecord();          
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

function TfrmMemberRecharge.initDBRecord(): string;
var
  strSQL: string;
begin
  with ADOQ do begin
    Connection := DataModule_3F.ADOConnection_Main;
    Active := false;
    SQL.Clear;
    strSQL := ' select ID,CARD_ID,OPER_COIN,TOTAL_COIN,OPER_TYPE,OPER_STATE  ' +
            ' ,OPERATE_TIME, OPERATOR_NO ' +
             ' from T_COIN_LOG ' +         
             ' order by OPERATE_TIME desc limit 10';
    ICFunction.loginfo('strSQL: ' + strSQL);
    SQL.Add(strSQL);
    Active := True;
  end;
  result := '';

end;


procedure TfrmMemberRecharge.commRechargeReceiveData(Sender: TObject; Buffer: Pointer;
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


procedure TfrmMemberRecharge.checkCMDInfo();
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
    returnFromOperationCMD();//��������
  end;

end;


//��ͷ���س�ֵ�ɹ�ָ��

procedure TfrmMemberRecharge.returnFromOperationCMD();
var cardid,operCoin,totalcoin:string;
begin 
   //�����ɹ�
  ICFunction.loginfo('return From OperationCMD Operate Coin Successfully ');
  cardid  :=Trim(edtBandID.Text);

  if globalOperType = '01' then
    begin
          operCoin := cbRechargeTimes.Text;
          totalcoin := IntToStr(strToInt(edtLeftCoin.Text)+strToInt(operCoin));
          updateMemberTotalCoin(cardid,totalcoin );
          saveMemberRechargeRecord(operCoin,totalcoin);
    end
  else  if globalOperType = '02' then
  begin
          operCoin :='1';
          totalcoin := IntToStr(strToInt(edtLeftCoin.Text) - StrToInt(operCoin));
          updateMemberTotalCoin(cardid,totalcoin );
          saveMemberRechargeRecord(operCoin,totalcoin);
  end;

  initDBRecord();

end;


//��ͷ������Ϣ��ȡָ��

procedure TfrmMemberRecharge.returnFromReadCMD();
begin
  Receive_CMD_ID_Infor.ID_INIT := copy(recDataLst.Strings[0], 3, 8); //��ƬID
  Receive_CMD_ID_Infor.ID_3F := copy(recDataLst.Strings[0], 11, 6); //����ID
  Receive_CMD_ID_Infor.Password_3F := copy(recDataLst.Strings[0], 17, 6); //appid
  Receive_CMD_ID_Infor.Password_USER := copy(recDataLst.Strings[0], 23, 6); //shopid
  Receive_CMD_ID_Infor.ID_value := copy(recDataLst.Strings[0], 29, 8); //��������
  Receive_CMD_ID_Infor.ID_type := copy(recDataLst.Strings[0], 37, 2); //������

  if queryExistInitialMemberRecord(Receive_CMD_ID_Infor.ID_INIT) = false then //�û����Ѿ���ʼ�� �м�¼
  begin
      lblMessage.Caption := '���ȳ�ʼ����';
      exit;
  end
  else
  begin
      displayCardInformation();
  end;


end;


function TfrmMemberRecharge.queryExistInitialMemberRecord(ID_INIT: string): Boolean;
var
  ADOQ: TADOQuery;
  strSQL :String;
begin
  ADOQ := TADOQuery.Create(Self);
  ADOQ.Connection := DataModule_3F.ADOConnection_Main;

  with ADOQ do begin
    Close;
    SQL.Clear;

   //20130101�޸�
    strSQL := 'select * from T_MEMBER_INFO where CARD_ID=''' + ID_INIT + '''';
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


procedure TfrmMemberRecharge.displayCardInformation();
begin
  edtBandID.Text := Receive_CMD_ID_Infor.ID_INIT;
  edtLeftCoin.Text := ICFunction.transferHEXByteToDECValue(Receive_CMD_ID_Infor.ID_value);

  
end;



procedure TfrmMemberRecharge.operateCoin(operacoin: string);
var
  coinvalue: string;
begin
  coinvalue := caluSendCMD(CMD_COUMUNICATION.CMD_INCValue, operacoin); //�����ֵָ��
  generateIncrValueCMD(coinvalue); //�ѳ�ֵָ��д��ID��
  ICFunction.loginfo('recharge data send to card: ' + coinvalue);
end;
//��ֵ����
//�����ֵָ��

function TfrmMemberRecharge.caluSendCMD(strCMD: string; strIncrValue: string): string;
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

procedure TfrmMemberRecharge.generateIncrValueCMD(S: string);
begin
  orderLst.Clear();
  recDataLst.Clear();
  curOrderNo := 0;
  curOperNo := 2;
  orderLst.Add(S); //����ֵָ��д�뻺��
  prcSendDataToCard(); //д�뿨ͷ��
end;

procedure TfrmMemberRecharge.prcSendDataToCard();
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




//����޶�

function TfrmMemberRecharge.checkCoinLimit(strWriteValue: string): boolean;
begin                              
  result := false;
  if strToInt(strWriteValue) > strToInt(SGBTCONFIGURE.COINLIMIT) then
    result := true;

end;

function TfrmMemberRecharge.checkCoinValue(coinid: string): boolean;
var
  ADOQ: TADOQuery;
  strSQL,strTotalCoin :String;
  tmpresult :Boolean ;
begin
  tmpresult := False;
  
   strSQL := 'select TOTAL_COIN  '
    + ' from T_MEMBER_INFO '
    +'  where CARD_ID = ''' + coinid + '''';
   ICFunction.loginfo('Exist check  strSQL: ' + strSQL);
  ADOQ := TADOQuery.Create(nil);
  with ADOQ do begin
    Connection := DataModule_3F.ADOConnection_Main;
    Active := false;
    SQL.Clear;
    SQL.Add(strSQL);
    Active := true;
    if ( RecordCount > 0) then
    begin
          strTotalCoin := FieldByName('TOTAL_COIN').AsString;
          if( strTotalCoin >= edtLeftCoin.Text ) then  //���ݿ����ֵ���ڿ����ֵ
              tmpresult := true;
    end;
    Active := False;
    Result := tmpresult;
  end;
  FreeAndNil(ADOQ);
end;


procedure TfrmMemberRecharge.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin

  orderLst.Free();
  recDataLst.Free();
  commRecharge.StopComm;

  edtBandID.Text :='';
  edtLeftCoin.Text :='';
  

end;

//��Ա��������

procedure TfrmMemberRecharge.btnSubmitClick(Sender: TObject);
var
  totalcoin :string;

begin
  globalOperType := '01';    
    //����д���Ľ��
  totalcoin := IntToStr(strToInt(edtLeftCoin.Text)+strToInt(cbRechargeTimes.Text));
  operateCoin( totalcoin ); //��ֵ
  lblMessage.Caption := '��Ա��ֵ�ɹ�';

end;

procedure TfrmMemberRecharge.btnCancelClick(Sender: TObject);
var
  totalcoin :string;

begin
  globalOperType := '02'; //����

  //����д���Ľ��
  totalcoin := IntToStr(strToInt(edtLeftCoin.Text) -1);
  if StrToInt(totalcoin) < 1 then
  begin
     ShowMessage('����,���ȳ�ֵ');
     exit;
  end;

  operateCoin( totalcoin );   
  lblMessage.Caption := '��Ա���ѳɹ�';
end;




function  TfrmMemberRecharge.getCoinByCoinType(cointype :string):string;
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

function  TfrmMemberRecharge.getCoinLimit(cardtype :string):string;
begin
    result := '1000';
end;





//��Ա��Ϣ
procedure TfrmMemberRecharge.updateMemberTotalCoin(cardid:string; totalcoin:string );
var
  ADOQ: TADOQuery;
  strSQL, operationcoin,leftcoin: string;  
begin
  ICFunction.loginfo('Begin updateMemberTotalCoin ');
  strSQL := ' select TOTAL_COIN, operate_time,OPERATORNO from  '
    + ' T_MEMBER_INFO where CARD_ID = ''' + cardid + '''';

  ICFunction.loginfo('strSQL: ' + strSQL );

  //ָ�����ڸ�ʽ ��Ҫ
  ShortDateFormat := 'yyyy-MM-dd'; //ָ����ʽ����
  DateSeparator := '-';
  //ָ�����ڸ�ʽ ����ᱨis not an valid date and time;

  ADOQ := TADOQuery.Create(nil);
  with ADOQ do begin
    Connection := DataModule_3F.ADOConnection_Main;
    Active := false;
    SQL.Clear;
    SQL.Add(strSQL);
    Active := true;

    if (RecordCount > 0) then begin
      Edit;
      FieldByName('TOTAL_COIN').AsInteger := strToInt(totalcoin);
      FieldByName('OPERATE_TIME').AsString := FormatDateTime('yyyy-MM-dd HH:mm:ss',Now);
      FieldByName('OPERATORNO').AsString  := G_User.UserNO;
      Post;
    end;
    Active := False;
  end;
  FreeAndNil(ADOQ);
  initDBRecord();
  lblMessage.Caption := '��Ա����ֵ�����˻�������';
  ICFunction.loginfo('End updateMemberTotalCoin ');
 end;


procedure TfrmMemberRecharge.saveMemberRechargeRecord(opercoin:string; totalcoin:string);
var
  strTrxid, strAppID, strBandid, strShopid, strPayid, strOperateTime, strOperatorNO, strPayState, strNote, strExpireTime, strsql: string;
  intCoin, intLeftCoin, intTotalCoin: Integer;

begin    
  ICFunction.loginfo('Begin saveMemberRechargeRecord ');
  strBandid := trim(edtBandID.Text);

    //ָ�����ڸ�ʽ ��Ҫ
  ShortDateFormat := 'yyyy-MM-dd'; //ָ����ʽ����
  DateSeparator := '-';
    //ָ�����ڸ�ʽ ����ᱨis not an valid date and time;
  strOperateTime := FormatDateTime('yyyy-MM-dd HH:mm:ss', now);
  strOperatorNO :=G_User.UserNO;
  
  with ADOQ do begin
    Connection := DataModule_3F.ADOConnection_Main;
    Active := false;
    SQL.Clear;
    strSQL := 'select * from T_COIN_LOG order by operate_time desc';
    ICFunction.loginfo('strSQL :' + strSQL);
    SQL.Add(strSQL);
    Active := True;
    Append;
    FieldByName('CARD_ID').AsString := strBandid;
    FieldByName('OPER_COIN').AsInteger := StrToInt(opercoin);
    FieldByName('TOTAL_COIN').AsInteger := StrToInt(totalcoin);
    FieldByName('OPER_TYPE').AsString := getOperTypeNameByCode(globalOperType);
    FieldByName('OPER_STATE').AsString := '�ɹ�';
    FieldByName('OPERATE_TIME').AsString := strOperateTime;
    FieldByName('OPERATOR_NO').AsString := strOperatorNO;
    post;
  end;
  ICFunction.loginfo('End saveMemberRechargeRecord ');
end;

procedure TfrmMemberRecharge.initcbRechargeTimes();
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
    cbRechargeTimes.Items.Clear;
    while not Eof do begin
      cbRechargeTimes.Items.Add(FieldByName('coin_type').AsString);
      Next;
      end;
    end;
  FreeAndNil(ADOQTemp);

end;

function TfrmMemberRecharge.getOperTypeNameByCode(opertype :string ):string;
begin
   if opertype='01' then
      Result := '��ֵ'
   else if opertype='02' then
      Result :='����';

end;

end.

