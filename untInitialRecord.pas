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

        //���ݿ����
    function initCoinRecord(): string;
    procedure saveInitialRecord(); //�����ֵ��¼
        //��ͷ������
    procedure checkCMDInfo();
    procedure initIncrOperation(strRechargeCoin: string); //��ֵ������д���ݸ���
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



    //��ʼ������BandID�ӿ�
    //function bandIDActiveInterface(): string;

    //ƴ�Ӽ���ӿ�URL
    function generateActiveURL(): string;

    //ƴ��ǩ���ӿ�URL
    function getActiveSignature(bandId: string; appId: string; shopId: string; timeStamp: string): string;

    //��΢��
    function generateBindWeiWinURL(): string;
    function getBindWeiXinSignature(appId: string; bandId: string; shopId: string; timeStamp: string): string;


  end;

var
  frmInitial: TfrmInitial;
  curOrderNo: integer = 0; //???
  curOperNo: integer = 0;
  Operate_No: integer = 0; //ʲô����?������ڳ�ֵ��
  orderLst, recDataLst: Tstrings; //����ȫ�ֱ����������ݣ���������
  ID_UserCard_Text: string;
  IncValue_Enable: boolean; //�Ƿ������ֵ�ı�־,��Ա����֤ͨ������ΪTrue
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


procedure TfrmInitial.saveInitialRecord(); //�����ֵ��¼
var
  strID3F, strBandid, strShopID, strTypeID, strOperateTime, strOperatorNO, strAppID, strIDTypeName, strCoin, strsql: string;
begin

  strBandid := trim(edtBandID.Text);
  strID3F := Receive_CMD_ID_Infor.ID_3F;
  strAppID := trim(edtAPPID.Text);

 // strIDTypeName := ICFunction.transferTypeIDToTypeName(edtTypeID.Text);
  strIDTypeName := cbCoinType.Text;
  strShopID := ICFunction.getInitShopIDByTypeName(strIDTypeName);
//  strTypeID := edtTypeID.Text; //���ﲻ��ʹ��Receive_CMD_ID_Infor.?��Ϊ���ֵһֱ�ڱ䣿  Ӧ��ʹ��returnfromReadCMDָ�����ֵ?
  strTypeID := ICFunction.transferTypeNameToTypeID(strIDTypeName);
  //strCoin := edtCoin.Text;//�����ȡ���Ļ�����һ�ſ���������ID_Valueֵ������
   // strCoin := ICFunction.getInitValueByTypeName(strIDTypeName);
   // strCoin := trim(edtCoinCost.Text);

 if (strTypeID = 'A5') then //�û���
  begin
    strCoin := Trim(edtCoin.Text);
  end
  else if (strTypeID = 'DD') then //������
  begin
   strCoin := SGBTCONFIGURE.coinlimit;

  end
  else if (strTypeID = '72') then //�����ÿ�
  begin
  strCoin := trim(edtCoinCost.Text);
  end
  else if (strTypeID = '4A') then // �ɼ���
  begin
   strCoin := '0';
  end;


    //ָ�����ڸ�ʽ ��Ҫ
  ShortDateFormat := 'yyyy-MM-dd'; //ָ����ʽ����
  DateSeparator := '-';
    //ָ�����ڸ�ʽ ����ᱨis not an valid date and time;
  strOperatorNO := G_User.UserNO;
  strOperateTime := FormatDateTime('yyyy-MM-dd HH:mm:ss', now);

  //����ֻ��׷������,��������ʾ
  with ADOQueryInitial do begin
    Connection := DataModule_3F.ADOConnection_Main;
    Active := false;
    SQL.Clear;
    strSQL := 'select bandid,initdate,appid,shopid,id_type,id_typename,coin,operatorno,operatetime from t_id_init order by operatetime desc'; //ΪʲôҪ��ȫ����
    ICFunction.loginfo('Initial database append��strSQL: ' + strSQL);
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
   //���Ƚ�ȡ���յ���Ϣ

  tmpStr := recDataLst.Strings[0];


  ICCommunalVarUnit.Receive_CMD_ID_Infor.ID_CheckNum := copy(tmpStr, 39, 4); //У���
  ICCommunalVarUnit.CMD_CheckSum_OK := true;
  ICCommunalVarUnit.Receive_CMD_ID_Infor.CMD := copy(recDataLst.Strings[0], 1, 2); //֡ͷ43

  ICFunction.loginfo('Initial: return from card : ' + tmpStr);
  if ICCommunalVarUnit.Receive_CMD_ID_Infor.CMD = CMD_COUMUNICATION.CMD_READ then //�յ���ͷд����ӱҳ�ֵ�ɹ��ķ��� 53
  begin
    returnFromReadCMD();
  end
  else if Receive_CMD_ID_Infor.CMD = ICCommunalVarUnit.CMD_COUMUNICATION.CMD_INCValue_RE then //��ָ��
  begin
   // returnFromIncrCMD(); //��ֵ
    lblMessage.Caption := 'Ȧ��ɹ�';
  end;


end;


//��ͷ���س�ֵ�ɹ�ָ��

procedure TfrmInitial.returnFromIncrCMD();
var
  strResponseStr, strURL, strResultCode: string;
  jsonApplyResult, jsonAckResult: TlkJSONbase;
begin

  begin
    saveInitialRecord(); //�����ֵ��¼
    initCoinRecord();

  end;
end;


//��ͷ������Ϣ��ȡָ��

procedure TfrmInitial.returnFromReadCMD();
begin
  Receive_CMD_ID_Infor.ID_INIT := copy(recDataLst.Strings[0], 3, 8); //��ID
  Receive_CMD_ID_Infor.ID_3F := copy(recDataLst.Strings[0], 11, 6); //����ID--��ʱû�ã�����Ҫռλ6
  Receive_CMD_ID_Infor.Password_3F := copy(recDataLst.Strings[0], 17, 6); //appid
  Receive_CMD_ID_Infor.Password_USER := copy(recDataLst.Strings[0], 23, 6); //shopid
  Receive_CMD_ID_Infor.ID_value := copy(recDataLst.Strings[0], 29, 8); //��������
  Receive_CMD_ID_Infor.ID_type := copy(recDataLst.Strings[0], 37, 2); //����������

  showCardInformation();

    //�����ؿ���� -----��ʼ

 // if DataModule_3F.queryExistInitialRecord(Receive_CMD_ID_Infor.ID_INIT) = false then //û��¼
 // begin
//    lblMessage.Caption := '���ȳ�ʼ����';
 //   exit;
  //end



end;


//�����������б�ʵʼ��

procedure TfrmInitial.initComboxCardtype;
begin
  cbCoinType.Items.clear();
  cbCoinType.Items.Add(copy(INit_Wright.User, 1, 6)); //�û���A5
  cbCoinType.Items.Add(copy(INit_Wright.SETTING, 1, 6)); //���ÿ�72

  if rootEnable = true then
  begin

    cbCoinType.Items.Add(copy(INit_Wright.MANEGER, 1, 6)); //�ɼ���4A
    cbCoinType.Items.Add(copy(INit_Wright.OPERN, 1, 6)); //������DD

  end; //�������Ȩ��

end;



//�û�����Ϣչʾ

procedure TfrmInitial.showCardInformation();
begin

  edtBandID.Text := Receive_CMD_ID_Infor.ID_INIT; //�û���ID
  edtTypeID.Text := Receive_CMD_ID_Infor.ID_type;
  edtCoin.Text := ICFunction.transferHEXByteToDECValue(Receive_CMD_ID_Infor.ID_value);
  lblMessage.Caption := '�˿�Ϊ ' + ICFunction.transferTypeIDToTypeName(edtTypeID.text);

end; //end


//��ʼȦ��

procedure TfrmInitial.initIncrOperation(strRechargeCoin: string);
var
  strValue: string;
begin
  strValue := caluSendCMD(CMD_COUMUNICATION.CMD_INCValue, strRechargeCoin); //�����ֵָ��
  generateIncrValueCMD(strValue); //�ѳ�ֵָ��д��ID��
  ICFunction.loginfo('Initial: Data send to card : ' + strValue);
end;
//��ֵ����

//���ɳ�ֵ�Ĳ���ָ��

procedure TfrmInitial.generateIncrValueCMD(S: string);
begin
  orderLst.Clear();
  recDataLst.Clear();
  curOrderNo := 0;
  curOperNo := 2;
  orderLst.Add(S); //����ֵָ��д�뻺��
  prcSendDataToCard(); //д�뿨ͷ��
end;

//�����ֵָ��

function TfrmInitial.caluSendCMD(strCMD: string; strIncrValue: string): string;
var
  TmpStr_CheckSum: string; //У���
  TmpStr_SendCMD: string; //ָ������
  reTmpStr, strTypeID: string;
begin

  INit_3F.CMD := StrCMD; //֡����
  INit_3F.ID_INIT := edtBandID.Text; //��ID
  INit_3F.ID_3F := FormatDateTime('yyMMdd', now);
  INit_3F.Password_3F := SGBTCONFIGURE.appid;
  INit_3F.ID_type := ICFunction.transferTypeNameToTypeID(cbCoinType.Text); //ȡ�ÿ����͵�ֵ  Ȧ�������ȷ��ID
  strTypeID := ICFunction.transferTypeNameToTypeID(cbCoinType.Text);
  if (strTypeID = 'A5') then //�û���
  begin
    INit_3F.Password_USER := SGBTCONFIGURE.shopid;
    INit_3F.ID_value := '00000000';
  end
  else if (strTypeID = 'DD') then //������
  begin
    INit_3F.Password_USER := SGBTCONFIGURE.shopid;
    //���õ��޶����������ļ�
    INit_3F.ID_value := ICFunction.transferDECValueToHEXByte(SGBTCONFIGURE.coinlimit);  

  end
  else if (strTypeID = '72') then //�����ÿ�
  begin
    INit_3F.ID_3F := FormatDateTime('yyyyMM', now);
    INit_3F.Password_USER := FormatDateTime('ddhhmm', now);
//    INit_3F.ID_value := ICFunction.transferDECValueToHEXByte(SGBTCONFIGURE.coincost);
    INit_3F.ID_value := ICFunction.transferDECValueToHEXByte(trim(edtCoinCost.Text));
  end
  else if (strTypeID = '4A') then // �ɼ���
  begin
    INit_3F.Password_USER := SGBTCONFIGURE.shopid;
    INit_3F.ID_value := '00000000';
  end;

  //���ܷ�������
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
    commInitial.WriteCommData(pchar(orderStr), length(orderStr)); //����д����ͷ
    inc(curOrderNo); //�ۼ�
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



procedure TfrmInitial.FormShow(Sender: TObject);
begin

   //��ʼ��������������

  edtAPPID.Text := '';
  edtShopID.Text := '';
  edtBandID.Text := '';
  edtTypeID.Text := '';
  edtCoin.Text := '';

  label5.Visible := false;
  edtTypeID.Visible := false;

  initComboxCardtype();
  initCoinRecord();

  //��ʼ������
  orderLst := TStringList.Create;
  recDataLst := tStringList.Create;
  edtAPPID.Text := SGBTCONFIGURE.appid;
  edtShopID.Text := SGBTCONFIGURE.shopid;

  //�򿪴���
//  commInitial.StartComm();
  try
    commInitial.StartComm();
  except on E: Exception do //���������쳣
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
  ResponseStream: TStringStream; //������Ϣ
  activeIdHTTP: TIdHTTP;
begin


  if DataModule_3F.queryExistInitialRecord(trim(edtBandID.Text)) = true then
  begin
    if MessageBox(handle, '�Ѿ���ʼ������������������!', '����', MB_OKCANCEL) = IDCANCEL then
      exit;
  end;
  intWriteValue := 0; //��ʼ��ʱ��ֵ�趨Ϊ0



 //Ȧ��
  initIncrOperation(intToStr(intWriteValue));

      //���
  saveInitialRecord();

  //ˢ������չʾ
  initCoinRecord();

  if SGBTCONFIGURE.enableInterface = '0' then
  begin
    if (cbCoinType.Text = copy(INit_Wright.User, 1, 6)) then //�û���
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
    //��ȡ��ҳ���ص���Ϣ   ��ҳ�еĴ�������ʱ����Ҫ����UTF8����
      strResponseStr := UTF8Decode(ResponseStream.DataString);
      ICFunction.loginfo('Active Response:' + strResponseStr);
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

  end;



  lblMessage.Caption := '��ʼ���ɹ�';

end;


procedure TfrmInitial.btnBindWeiXinClick(Sender: TObject);
var
  strURL: string;
  qCode: TQRCode;
begin
    //�������ж�
  if (edtTypeID.text = copy(INit_Wright.User, 8, 2)) then //�û���
  begin
    strURL := generateBindWeiWinURL();
    qCode := TQRCode.Create(Self);
    qCode.Clear;
    qCode.Mode := qrPlus; //��ά��ģʽ
    qCode.Eclevel := 1; //��������:0 ~ 3
    qCode.Pxmag := 1;
    qCode.Version := 10 + 1; //��ά��汾:1 ~ 40
    qCode.SymbolPicture := picBMP;
    qCode.Match := True;
    qCode.Usejis := False;
    qCode.Code := strURL; //��ά������
    qCode.BackColor := clWhite;
    qCode.SymbolColor := clBlack;
    qCode.Angle := 0;
  //�����ɵ�ͼ�����ݷ���image
    imgCode.Canvas.StretchDraw(Rect(0, 0, 300, 300), qCode.Picture.Bitmap);
    qCode.Free;
  end;


end;

//���ɰ�΢��URL

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

//��΢��ǩ���㷨

function TfrmInitial.getBindWeiXinSignature(appId: string; bandId: string; shopId: string; timeStamp: string): string;
var
  strTempC, strTempD: string;
  myMD5: TIdHashMessageDigest5;
begin
  myMD5 := TIdHashMessageDigest5.Create;
  strTempC := 'appId' + appId
    + 'bandId' + bandId
    + 'shopId' + shopId
    + 'timestamp' + timeStamp; //���ַ�˳������

  strTempD := strTempC + SGBTCONFIGURE.secret_key; //����secret_key
  result := LowerCase(myMD5.AsHex(myMD5.HashValue(strTempD))); //�����ַ�����MD5,������Сд
  myMD5.Free;

end;




 //ƴ�Ӽ���ӿ�URL

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



//��������ǩ���㷨

function TfrmInitial.getActiveSignature(bandId: string; appId: string; shopId: string; timeStamp: string): string;
var
  strTempC, strTempD: string;
  myMD5: TIdHashMessageDigest5;
begin
  myMD5 := TIdHashMessageDigest5.Create;
  strTempC := 'appId' + appId + 'bandId' + bandId + 'shopId' + shopId + 'timestamp' + timeStamp; //���ַ�˳������
  strTempD := strTempC + SGBTCONFIGURE.secret_key; //����secret_key
  result := LowerCase(myMD5.AsHex(myMD5.HashValue(strTempD))); //�����ַ�����MD5,������Сд
  myMD5.Free;

end;



end.

