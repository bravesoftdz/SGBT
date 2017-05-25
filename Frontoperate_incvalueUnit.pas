unit Frontoperate_incvalueUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, DBGrids, DB, ADODB, ExtCtrls, StdCtrls, Buttons, SPComm, DateUtils;

type
  Tfrm_Frontoperate_incvalue = class(TForm)
  //Panel��

  //edit��

  //button��

  //groupbox��

  //radiobox��

  //DB��


    Panel1: TPanel;
    DataSource_Incvalue: TDataSource;
    ADOQuery_Incvalue: TADOQuery;
    DBGrid2: TDBGrid;
    Panel2: TPanel;
    ADOQuery_newmenber: TADOQuery;
    DataSource_Newmenber: TDataSource;
    Panel3: TPanel;
    Panel4: TPanel;
    GroupBox5: TGroupBox;
    Label3: TLabel;
    Label4: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Edit_ID: TEdit;
    Edit_PrintNO: TEdit;
    Edit_Username: TEdit;
    Edit_Certify: TEdit;
    Edit_SaveMoney: TEdit;
    Edit_Prepassword: TEdit;
    Comb_menberlevel: TComboBox;
    Edit_Mobile: TEdit;
    GroupBox4: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label15: TLabel;
    Edit_Givecore: TEdit;
    edtIncrValue: TEdit;
    Edit_Totalvale: TEdit;
    Edit_Pwdcomfir: TEdit;
    Bitn_Close: TBitBtn;
    Image1: TImage;
    btnOffLineRecharge: TBitBtn;
    Label20: TLabel;
    Panel_Message: TPanel;
    Edit_TotalbuyValue: TEdit;
    Label5: TLabel;
    Label10: TLabel;
    Edit_TotalChangeValue: TEdit;
    Label16: TLabel;
    Label17: TLabel;
    cbBatchRecharge: TCheckBox;
    Panel_infor: TPanel;
    Labnumber: TLabel;
    edit_number: TEdit;
    Label18: TLabel;
    Label19: TLabel;
    Label21: TLabel;
    Edit_money: TEdit;
    Lab_money: TLabel;
    Label6: TLabel;
    edtIDType: TEdit;
    edtOldValue: TEdit;
    comReader: TComm;

  //�¼�
    procedure FormCreate(Sender: TObject);
    procedure comReaderReceiveData(Sender: TObject; Buffer: Pointer; BufferLength: Word);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Bitn_CloseClick(Sender: TObject);
    procedure btnOffLineRechargeClick(Sender: TObject);
    procedure edtIncrValueKeyPress(Sender: TObject; var Key: Char);
    procedure Edit_PwdcomfirKeyPress(Sender: TObject; var Key: Char);

  private
    { Private declarations }



    //���ݿ⴦����
    procedure initShowDataBaseInfo();
    procedure querMemberInfo(StrID: string);
    procedure queryMemberLevelInfo(StrLevNum: string);
    function queryMemberInfo(StrID: string): boolean;
    procedure queryIncrValueInfo(StrID: string); //�ܳ�ֵֵ
    procedure queryChangeValueInfo(StrID: string); //�ܶһ�ֵ
    procedure prcDBSaveIncrValue; //�����ֵ��¼
    procedure updateLastestRecord(S: string); //�������¼�¼��־
    procedure updateLastestRecordValue(S: string); //���³�ֵ��
    function checkLastestRecord(S: string): boolean;
    function checkIDCardExpire(S: string): boolean;

    //��ͷ������
    procedure checkCMDInfo();
    procedure initIncrOperation(); //��ֵ������д���ݸ���
    function caluSendCMD(StrCMD: string; StrIncValue: string): string;
    procedure generateIncrValueCMD(S: string);
    procedure prcSendDataToCard();

    function checkSUMData(orderStr: string): string;
    procedure getExpireTime();
    function transferCheckSumByte(StrCheckSum: string): string;
    procedure prcUserCardOperation();
    procedure prcCardIncrValueReturn();
    procedure prcCardReadValueReturn();

    procedure clearComponetText();

  public
    { Public declarations }

  end;

var
  frm_Frontoperate_incvalue: Tfrm_Frontoperate_incvalue;
  curOrderNo: integer = 0; //???
  curOperNo: integer = 0;
  Operate_No: integer = 0; //ʲô����?������ڳ�ֵ��
  orderLst, recDataLst: Tstrings; //����ȫ�ֱ����������ݣ���������
  ID_UserCard_Text: string;
  IncValue_Enable: boolean; //�Ƿ������ֵ�ı�־,��Ա����֤ͨ������ΪTrue
  buffer: array[0..2048] of byte;

implementation
uses ICDataModule, ICtest_Main, ICCommunalVarUnit, ICmain, ICEventTypeUnit, ICFunctionUnit, dateProcess;
{$R *.dfm}


//����չʾ��Ա��Ϣ

procedure Tfrm_Frontoperate_incvalue.initShowDataBaseInfo;
var
  strSQL: string;
begin
  with ADOQuery_newmenber do begin
    Connection := DataModule_3F.ADOConnection_Main;
    Active := false;
    SQL.Clear;
    strSQL := 'select * from [TMemberInfo]';
    SQL.Add(strSQL);
    Active := True;
  end;
  with ADOQuery_Incvalue do begin
    Connection := DataModule_3F.ADOConnection_Main;
    Active := false;
    SQL.Clear;
    strSQL := 'select top 5 * from [TMembeDetail] order by GetTime desc';
    SQL.Add(strSQL);
    Active := True;
  end;
end;




procedure Tfrm_Frontoperate_incvalue.prcSendDataToCard();
var
  orderStr: string;
begin
  if orderLst.Count > curOrderNo then
  begin
    orderStr := orderLst.Strings[curOrderNo];
    orderStr := ICFunction.funcTransferExchData(orderStr);
    comReader.WriteCommData(pchar(orderStr), length(orderStr)); //����д����ͷ
    inc(curOrderNo); //�ۼ�
  end;
end;

//���崴���¼�

procedure Tfrm_Frontoperate_incvalue.FormCreate(Sender: TObject);
begin
  EventObj := EventUnitObj.Create;
  EventObj.LoadEventIni;
end;

//���ڽ��ܴ������ݴ��������¼�

procedure Tfrm_Frontoperate_incvalue.comReaderReceiveData(Sender: TObject;
  Buffer: Pointer; BufferLength: Word);
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

//���ݽ��յ��������жϴ˿��Ƿ�Ϊ�Ϸ�����������Ϣ�˲�

procedure Tfrm_Frontoperate_incvalue.checkCMDInfo();
var
  tmpStr: string;
  tmpStr_Hex_length: string;
  Send_value: string;
  RevComd: integer;
  ID_No: string;
  length_Data: integer;
begin
   //���Ƚ�ȡ���յ���Ϣ

  tmpStr := recDataLst.Strings[0];
  ICCommunalVarUnit.Receive_CMD_ID_Infor.ID_CheckNum := copy(tmpStr, 39, 4); //У���
  ICCommunalVarUnit.CMD_CheckSum_OK := true;
  ICCommunalVarUnit.Receive_CMD_ID_Infor.CMD := copy(recDataLst.Strings[0], 1, 2); //֡ͷ43

  if ICCommunalVarUnit.Receive_CMD_ID_Infor.CMD = ICCommunalVarUnit.CMD_COUMUNICATION.CMD_INCValue_RE then //�յ���ͷд����ӱҳ�ֵ�ɹ��ķ��� 53
  begin
    prcCardIncrValueReturn();
  end
  else if Receive_CMD_ID_Infor.CMD = CMD_COUMUNICATION.CMD_READ then //��ָ��
  begin
    prcCardReadValueReturn();
  end;

end;



//��ͷ���س�ֵ�ɹ�ָ��

procedure Tfrm_Frontoperate_incvalue.prcCardIncrValueReturn();
begin
  if (Operate_No = 1) then //���浱ǰ���ĳ�ʼ����¼
  begin
    if Receive_CMD_ID_Infor.ID_type = copy(INit_Wright.User, 8, 2) then
    begin
      prcDBSaveIncrValue; //�����ֵ��¼
    end;
    Panel_Message.Caption := '��ֵ�����������ֵ��¼�ɹ�';
    initShowDataBaseInfo();
  end;
end;


//��ͷ������Ϣ��ȡָ��

procedure Tfrm_Frontoperate_incvalue.prcCardReadValueReturn();
begin
  Receive_CMD_ID_Infor.ID_INIT := copy(recDataLst.Strings[0], 3, 8); //��ƬID
  Receive_CMD_ID_Infor.ID_3F := copy(recDataLst.Strings[0], 11, 6); //����ID
  Receive_CMD_ID_Infor.Password_3F := copy(recDataLst.Strings[0], 17, 6); //����
  Receive_CMD_ID_Infor.Password_USER := copy(recDataLst.Strings[0], 23, 6); //�û�����
  Receive_CMD_ID_Infor.ID_value := copy(recDataLst.Strings[0], 29, 8); //��������
  Receive_CMD_ID_Infor.ID_type := copy(recDataLst.Strings[0], 37, 2); //������

  edtIDType.Text := Receive_CMD_ID_Infor.ID_type;
  begin //�����ؿ���� -----��ʼ
    if (Receive_CMD_ID_Infor.Password_USER = INit_Wright.BossPassword) //    INit_Wright.BossPassword := MyIni.ReadString('PLC��������', 'PC����������', '������');
      and ((Receive_CMD_ID_Infor.ID_type = copy(INit_Wright.RECV_CASE, 8, 2)) //    INit_Wright.RECV_CASE := '������,CA'; ���������ֽڴӵڣ���ʼȡ����
      or (Receive_CMD_ID_Infor.ID_type = copy(INit_Wright.User, 8, 2))
      or (Receive_CMD_ID_Infor.ID_type = copy(INit_Wright.OPERN, 8, 2))) then //����������Ϊ��Ա��
    begin //���س�ʼ����� -----��ʼ
      if DataModule_3F.Query_User_INIT_OK(Receive_CMD_ID_Infor.ID_INIT) then //�м�¼
      begin

        if Receive_CMD_ID_Infor.ID_type = copy(INit_Wright.RECV_CASE, 8, 2) then
        begin //����������Ա���� -----��ʼ
          if queryMemberInfo(Receive_CMD_ID_Infor.ID_INIT) then
          begin
            querMemberInfo(Receive_CMD_ID_Infor.ID_INIT); //չʾ��Ա����Ϣ
            edtIncrValue.Enabled := true;
            edtIncrValue.SetFocus;
            cbBatchRecharge.Enabled := False;
            cbBatchRecharge.Checked := false;
            Panel_Message.Caption := '�˻�Ա���Ϸ����뽫���ӱҰ����ڳ�ֵ��ͷ�Ϸ���'; //��ID
            IncValue_Enable := true; //�����ֵ����
            Edit_ID.Text := Receive_CMD_ID_Infor.ID_INIT;
          end //end ��Ա��¼
          else
          begin
            clearComponetText;
            Panel_Message.Caption := '��Ա���ݱ����޼�¼����ȷ���Ƿ�Ϊ�����ػ�Ա��'; //��ID
          end;
        end //����������Ա���� -----����
        else if Receive_CMD_ID_Infor.ID_type = copy(INit_Wright.User, 8, 2) then
        begin //�û��� -----��ʼ
          prcUserCardOperation();
        end //�û�������
        else if Receive_CMD_ID_Infor.ID_type = copy(INit_Wright.OPERN, 8, 2) then
        begin //������ -----��ʼ
          if IncValue_Enable then
          begin
            Panel_Message.Caption := '���û��ҺϷ������������������������'; //��ID
          end
          else
          begin
            Panel_Message.Caption := '��ˢ��Ա����Ȼ���ٽ����ӱҰ����ڳ�ֵ��ͷ�Ϸ���'; //��ID
          end;
        end; //������ -----����
      end
      else
      begin
        clearComponetText;
        Panel_Message.Caption := '�ڴ�ϵͳ�޼�¼����ȷ���Ƿ��Ѿ���ɳ��س�ʼ����'; //��ID
        exit;
      end;
    end
    else
    begin
      clearComponetText;
      Panel_Message.Caption := '�˿��Ƿ����������'; //��ID
      exit;
    end;
                           //�����ؿ���� -----����
  end;


end;





//�û�������(��Ա����֤�������־�򿪺�ſ��Գ�ֵ)

procedure Tfrm_Frontoperate_incvalue.prcUserCardOperation();
begin

  if IncValue_Enable then
  begin //������ֵ����ѡ��---��ʼ
    if (cbBatchRecharge.Checked) then
    begin
      if (edtIncrValue.Text = '') then
      begin
        Panel_Message.Caption := '������������ֵ�ֻ���������֣�';
        exit;
      end
      else
      begin
        initIncrOperation; //����������ֵд��ID����
      end;
    end; //����������ֵ

    Panel_Message.Caption := '���û��ҺϷ��������������'; //��ID
    ID_UserCard_Text := Receive_CMD_ID_Infor.ID_INIT; //�û���ID
    edtOldValue.Text := ICFunction.transferHEXByteToDECValue(Receive_CMD_ID_Infor.ID_value);
                                              //������ֵ����ѡ��(���γ�ֵʹ��ȷ�ϰ�ť)---����
  end //
  else
  begin
    Panel_Message.Caption := '��ˢ��Ա����Ȼ���ٽ����ӱҰ����ڳ�ֵ��ͷ�Ϸ���'; //��ID
  end; //end IncValue_Enable

end; //end prc_user_card_operation


//�����ʼ������
//д��ֵ��¼

procedure Tfrm_Frontoperate_incvalue.prcDBSaveIncrValue;
var
  strIDNo, strName, strUserNo, strIncvalue, strGivecore, strOperator, strhavemoney, strinputdatetime, strexpiretime, strsql: string;
  i: integer;
label ExitSub;
begin
  //����û����ϵ�ֵ��Ϊ0����ֻ��ˢ�´˱ҵı�ֵ�ͳ�ֵʱ��
  if edtOldValue.Text <> '0' then
  begin
      //1��ѯ��ǰ���ڳ�ֵ�����Ƿ������µĳ�ֵ��¼����
    if checkLastestRecord(ID_UserCard_Text) and checkIDCardExpire(ID_UserCard_Text) then
    begin
      updateLastestRecordValue(ID_UserCard_Text); //ID_UserCard_TextΪ���ӱ�ID�����ݴ˸��µ��ӱҳ�ֵ��¼
      exit;
    end

  end;

  strUserNo := Edit_PrintNO.Text; //�û����
  updateLastestRecord(ID_UserCard_Text); //ID_UserCard_TextΪ���ӱ�ID�����ݴ˸��µ��ӱҳ�ֵ��¼
  strName := Edit_Username.Text; //�û�����
  strIncvalue := edtIncrValue.Text; //��ֵ
  strGivecore := Edit_Givecore.Text; //�ͷ�ֵ
  strOperator := G_User.UserNO; //����Ա
  strhavemoney := edtIncrValue.Text; //
  strinputdatetime := FormatDateTime('yyyy-MM-dd HH:mm:ss', now); //¼��ʱ�䣬��ȡϵͳʱ��
  strexpiretime := FormatDateTime('yyyy-MM-dd HH:mm:ss', addhrs(now, iHHSet));
  strIDNo := TrimRight(Edit_ID.Text); //��ID

  if Edit_Pwdcomfir.Text <> Edit_Prepassword.Text then
    ShowMessage('�ͻ�����ȷ�������������������')
  else begin
    with ADOQuery_Incvalue do begin
      Connection := DataModule_3F.ADOConnection_Main;
      Active := false;
      SQL.Clear;
      strSQL := 'select * from [TMembeDetail] order by GetTime desc';
      SQL.Add(strSQL);
      Active := True;
      btnOffLineRecharge.Enabled := False; //�ر��������
      Append;
      FieldByName('MemCardNo').AsString := strUserNo;
      FieldByName('CostMoney').AsString := strIncvalue; //��ֵ
      FieldByName('TickCount').AsString := strGivecore;
      FieldByName('cUserNo').AsString := strOperator; //����Ա
      FieldByName('GetTime').AsString := strinputdatetime; //����ʱ��
      FieldByName('TotalMoney').AsString := strhavemoney; //�ʻ��ܶ�
      FieldByName('IDCardNo').AsString := strIDNo; //��ֵ����
      FieldByName('MemberName').AsString := strName; //�û���
      FieldByName('PayType').AsString := '0'; //��ֵ����
      FieldByName('MacNo').AsString := 'A0100'; //��̨���
      FieldByName('ExitCoin').AsInteger := 0;
      FieldByName('Compter').AsString := '1';
      FieldByName('LastRecord').AsString := '1';
      FieldByName('TickCount').AsString := '0';
      FieldByName('ID_UserCard_TuiBi_Flag').AsString := '0'; //�˱ұ�ʶ
      FieldByName('ID_UserCard').AsString := ID_UserCard_Text; //���ӱ�ID
      FieldByName('expiretime').AsString := strexpiretime; //ʧЧʱ��
      try
        Post;
      except
        on e: Exception do ShowMessage(e.Message);
      end;
      //added by linlf ����ͳ��ÿһ�γ�ֵ����ÿһ�δ򿪳�ֵ����Ϊͳ�ƿھ�
      edit_number.Text := inttostr(strtoint(edit_number.Text) + 1);
      edit_money.Text := inttostr(strtoint(edit_money.Text) + strtoint(edtIncrValue.Text));

    end;


    ExitSub:
   //������ֵ�����
    if not (cbBatchRecharge.Checked) then
    begin
      clearComponetText;
      IncValue_Enable := false; //�����¼��Ϻ󣬹رճ�ֵ�������
      btnOffLineRecharge.Enabled := false;

    end
    else
    begin
          //ClearText_ContiueIncValue;
      btnOffLineRecharge.Enabled := true;
      queryIncrValueInfo(strIDNo); //�ܳ�ֵֵ����Դ���ݱ�[TMembeDetail]��
      queryChangeValueInfo(strIDNo); //�ܶһ�ֵ����Դ���ݱ�[3F_BARFLOW]��
      IncValue_Enable := true; //�����¼��Ϻ󣬹رճ�ֵ�������
    end;

    edtIncrValue.Enabled := false;
    Edit_Pwdcomfir.Enabled := false;
    Operate_No := 0;

    ID_UserCard_Text := '';

  end;



end;


 //���´��û������³�ֵ�����ֲ����ļ�¼��־λ

procedure Tfrm_Frontoperate_incvalue.updateLastestRecord(S: string);
var
  ADOQ: TADOQuery;
  strSQL, strRet: string;
  MaxID: string;
  setvalue: string;
begin
  strSQL := 'select max(MD_ID) from TMembeDetail where ID_UserCard=''' + S + '''';
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

  setvalue := '0';
  strSQL := 'Update TMembeDetail set LastRecord=''' + setvalue + ''' where MD_ID=''' + MaxID + '''';
  ADOQ := TADOQuery.Create(nil);
  with ADOQ do begin
    Connection := DataModule_3F.ADOConnection_Main;
    SQL.Clear;
    SQL.Add(strSQL);
    ADOQ.ExecSQL;
  end;
  FreeAndNil(ADOQ);

end;

//��ѯ��ǰ���Ƿ������µĳ�ֵ��¼�����û��������Ǽٱң���ʾ�Ƿ����Ҫ������ֵ

function Tfrm_Frontoperate_incvalue.checkLastestRecord(S: string): boolean;
var
  ADOQ: TADOQuery;
  strSQL, strRet: string;
  MaxID: integer;
  setvalue, settime: string;
begin


  Result := false;

  strSQL := 'select count(MD_ID) from TMembeDetail where (ID_UserCard=''' + S + ''') and LastRecord=''1''   ';
  ADOQ := TADOQuery.Create(nil);
  with ADOQ do begin
    Connection := DataModule_3F.ADOConnection_Main;
    SQL.Clear;
    SQL.Add(strSQL);
    Open;
    if (not eof) then
      MaxID := StrToInt(TrimRight(ADOQ.Fields[0].AsString)); ;

    Close;
  end;
  FreeAndNil(ADOQ);

  if MaxID = 0 then
    Result := false
  else
    Result := true;


end;

//���IDCard�Ƿ����

function Tfrm_Frontoperate_incvalue.checkIDCardExpire(S: string): boolean;
var
  ADOQ: TADOQuery;
  strSQL, strRet: string;
  MaxID: integer;
  setvalue, settime: string;
  strdatetime: string;
begin


  Result := false;
  strdatetime := formatdatetime('yyyy-mm-dd hh:mm:ss', now());
  strSQL := ' select count(MD_ID) from TMembeDetail where (ID_UserCard= '''
    + S + ''') and LastRecord=''1''  and expiretime > '''
    + strdatetime + '''';
  //showmessage(strSQL);
  ADOQ := TADOQuery.Create(nil);
  with ADOQ do begin
    Connection := DataModule_3F.ADOConnection_Main;
    SQL.Clear;
    SQL.Add(strSQL);
    Open;
    if (not eof) then
      MaxID := StrToInt(TrimRight(ADOQ.Fields[0].AsString)); ;

    Close;
  end;
  FreeAndNil(ADOQ);

  if MaxID = 0 then
    Result := false
  else
    Result := true;


end;

 //���´��û������³�ֵ�����ֲ����ļ�¼��־λ

procedure Tfrm_Frontoperate_incvalue.updateLastestRecordValue(S: string);
var
  ADOQ: TADOQuery;
  strSQL, strRet: string;
  MaxID: string;
  setvalue, settime, setflag, strexpiretime: string;
begin
  strSQL := 'select max(MD_ID) from TMembeDetail where (ID_UserCard=''' + S + ''') ';
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
  setflag := '0';
  settime := FormatDateTime('yyyy-MM-dd HH:mm:ss', now);
  strexpiretime := FormatDateTime('yyyy-MM-dd HH:mm:ss', addhrs(now, iHHSet));

  setvalue := TrimRight(edtIncrValue.text);
  strSQL := 'Update TMembeDetail set TotalMoney=''' + setvalue
    + ''',GetTime=''' + settime + ''',CostMoney='''
    + setvalue + ''' ,expiretime=''' + strexpiretime + ''' where (MD_ID=''' + MaxID + ''') and (ID_UserCard_TuiBi_Flag=''' + setflag + ''')';
  ADOQ := TADOQuery.Create(nil);
  with ADOQ do begin
    Connection := DataModule_3F.ADOConnection_Main;
    SQL.Clear;
    SQL.Add(strSQL);
    ADOQ.ExecSQL;
  end;
  FreeAndNil(ADOQ);

end;

procedure Tfrm_Frontoperate_incvalue.clearComponetText;
begin
  Edit_ID.Text := ''; //��ID
  Edit_PrintNO.Text := '';
  Edit_Username.Text := '';
  Edit_Prepassword.Text := '';
  Edit_Certify.Text := '';
  Edit_TotalbuyValue.Text := '';
  Edit_TotalChangeValue.Text := '';
  Edit_Mobile.Text := '';
  Comb_menberlevel.Text := '';
  Edit_SaveMoney.Enabled := false;
  edtIncrValue.Enabled := false;
  edtIncrValue.Text := '';
  Edit_Pwdcomfir.Enabled := false;
  Edit_Pwdcomfir.Text := '';
  btnOffLineRecharge.Enabled := false;
end;

// �Ƿ���ڻ�Ա��Ϣ

function Tfrm_Frontoperate_incvalue.queryMemberInfo(StrID: string): boolean;
var
  ADOQTemp: TADOQuery;
  strSQL: string;
  reTmpStr: boolean;
begin
  reTmpStr := false;
  ADOQTemp := TADOQuery.Create(nil);
  strSQL := 'select Count([MemCardNo]) from [TMemberInfo] where IDCardNo=''' + StrID + ''' ';

  with ADOQTemp do
  begin
    Connection := DataModule_3F.ADOConnection_Main;
    SQL.Clear;
    SQL.Add(strSQL);
    Active := True;

    if StrToInt(TrimRight(ADOQTemp.Fields[0].AsString)) > 0 then
      reTmpStr := true;

  end;
  FreeAndNil(ADOQTemp);

  Result := reTmpStr;
end;

//���ػ�Ա��Ϣ

procedure Tfrm_Frontoperate_incvalue.querMemberInfo(StrID: string);
var
  ADOQTemp: TADOQuery;
  strSQL: string;
  reTmpStr: string;
  strsexOrg: string;
begin
  ADOQTemp := TADOQuery.Create(nil);
  strSQL := 'select * from [TMemberInfo] where IDCardNo=''' + StrID + '''';

  with ADOQTemp do
  begin
    Connection := DataModule_3F.ADOConnection_Main;
    SQL.Clear;
    SQL.Add(strSQL);
    Active := True;

    Edit_PrintNO.text := FieldByName('MemCardNo').AsString;
    Edit_Username.text := FieldByName('MemberName').AsString;
    Edit_ID.text := FieldByName('IDCardNo').AsString;
    Edit_Prepassword.text := FieldByName('InfoKey').AsString;
    Edit_Mobile.text := FieldByName('Mobile').AsString;
    Edit_Certify.text := FieldByName('DocNumber').AsString;
    Edit_SaveMoney.text := FieldByName('Deposit').AsString;
    strsexOrg := FieldByName('Sex').AsString;

    queryMemberLevelInfo(TrimRight(FieldByName('LevNum').AsString));
    queryIncrValueInfo(StrID); //�ܳ�ֵֵ����Դ���ݱ�[TMembeDetail]��
    queryChangeValueInfo(StrID); //�ܶһ�ֵ����Դ���ݱ�[3F_BARFLOW]��
  end;
  FreeAndNil(ADOQTemp);
end;
 //��ѯ�ȼ�����

procedure Tfrm_Frontoperate_incvalue.queryMemberLevelInfo(StrLevNum: string); //��ѯ�ȼ�����
var
  ADOQTemp: TADOQuery;
  strSQL: string;
  reTmpStr: string;
begin
  ADOQTemp := TADOQuery.Create(nil);
  strSQL := 'select LevName from [TLevel] where LevNo=''' + StrLevNum + '''';

  with ADOQTemp do
  begin
    Connection := DataModule_3F.ADOConnection_Main;
    SQL.Clear;
    SQL.Add(strSQL);
    Active := True;
    Comb_menberlevel.text := FieldByName('LevName').AsString;
  end;
  FreeAndNil(ADOQTemp);
end;

 //��ѯ������ֵ�������

procedure Tfrm_Frontoperate_incvalue.queryIncrValueInfo(StrID: string);
var
  ADOQTemp: TADOQuery;
  strSQL: string;
  reTmpStr: string;
  strMaxMD_ID: string;
begin
                 //ȡ�����µ��ּܷ�¼ID
  ADOQTemp := TADOQuery.Create(nil);
  strSQL := 'select Max([MD_ID]) from [TMembeDetail] where IDCardNo=''' + StrID + '''';

  with ADOQTemp do
  begin
    Connection := DataModule_3F.ADOConnection_Main;
    SQL.Clear;
    SQL.Add(strSQL);
    Active := True;
    strMaxMD_ID := ADOQTemp.Fields[0].AsString;
  end;
  FreeAndNil(ADOQTemp);


                 //ȡ�����µ��ܷ�
  ADOQTemp := TADOQuery.Create(nil);
                 //strSQL:= 'select TotalMoney from [TMembeDetail] where (IDCardNo='''+StrID+''') and (MD_ID='''+strMaxMD_ID+''')';

  strSQL := 'select sum(TotalMoney) from [TMembeDetail] where (IDCardNo=''' + StrID + ''')';

  with ADOQTemp do
  begin
    Connection := DataModule_3F.ADOConnection_Main;
    SQL.Clear;
    SQL.Add(strSQL);
    Active := True;
    Edit_TotalbuyValue.text := ADOQTemp.Fields[0].AsString;
  end;
  FreeAndNil(ADOQTemp);
end;

 //��ѯ�����ҽ��������

procedure Tfrm_Frontoperate_incvalue.queryChangeValueInfo(StrID: string);
var
  ADOQTemp: TADOQuery;
  strSQL: string;
  reTmpStr: string;
  strMaxMD_ID: string;
begin

                 //ȡ�öһ���ֵ
  ADOQTemp := TADOQuery.Create(nil);
  strSQL := 'select Sum([COREVALU_Bili]) from [3F_BARFLOW] where (IDCardNo=''' + StrID + ''') ';

  with ADOQTemp do
  begin
    Connection := DataModule_3F.ADOConnection_Main;
    SQL.Clear;
    SQL.Add(strSQL);
    Active := True;
    Edit_TotalChangeValue.text := ADOQTemp.Fields[0].AsString;
  end;
  FreeAndNil(ADOQTemp);
end;

procedure Tfrm_Frontoperate_incvalue.FormShow(Sender: TObject);
begin
  ICFunction.InitSystemWorkPath; //��ʼ���ļ�·��
  ICFunction.InitSystemWorkground; //��ʼ����������
  initShowDataBaseInfo();

  comReader.StartComm(); //�򿪴���

  IncValue_Enable := false;
  orderLst := TStringList.Create;
  recDataLst := tStringList.Create;
  edtOldValue.Text := '0';
  edit_number.Text := '0';
  edit_money.Text := '0';

  Panel_infor.Caption := '�����趨�Ĵ��ұ���Ϊ1 ��' + SystemWorkground.ErrorGTState + ',����ֻ������С��' + IntToStr(StrToInt(INit_Wright.MaxValue) div StrToInt(SystemWorkground.ErrorGTState)) + '����ֵ��';
  btnOffLineRecharge.Enabled := false;
  cbBatchRecharge.Checked := false;
 //�γǰ汾Ҫ��ر�
  Label10.Visible := false;
  Edit_TotalChangeValue.Visible := false;
  Edit_TotalbuyValue.Visible := false;
  Label7.Visible := false;
  edit_number.Visible := false;
  Labnumber.Visible := false;
  edtIncrValue.Enabled := false;
  edit_pwdcomfir.Enabled := false;

end;

procedure Tfrm_Frontoperate_incvalue.FormClose(Sender: TObject; var Action: TCloseAction);
var
  i: integer;
begin
  orderLst.Free();
  recDataLst.Free();
  comReader.StopComm();
  for i := 0 to ComponentCount - 1 do
  begin
    if components[i] is TEdit then
    begin
      (components[i] as TEdit).Clear;
    end
  end;
end;



procedure Tfrm_Frontoperate_incvalue.Bitn_CloseClick(Sender: TObject);
begin
  Close;
end;


//�ֶ���ֵ����ȷ�� //Bitn_IncvalueComfir

procedure Tfrm_Frontoperate_incvalue.btnOffLineRechargeClick(
  Sender: TObject);

var
  INC_value: string;
  strValue: string;
  i: integer;
begin
  if edtIncrValue.Text = '' then
  begin
    MessageBox(handle, '��ֵ���Ϊ0!', '����', MB_ICONERROR + MB_OK);
    exit;
  end
  else
  begin
    Operate_No := 1;
    INC_value := TrimRight(edtIncrValue.Text); //��ֵ��ֵ
    strValue := caluSendCMD(CMD_COUMUNICATION.CMD_INCValue, INC_value); //�����ֵָ��
    generateIncrValueCMD(strValue); //д����ӱ�,ʲôʱ��д�����ݿ�? �յ���ͷ���ص���ȷд����ӱҺ�
  end;

end;

//edit��ֵ���У��

procedure Tfrm_Frontoperate_incvalue.edtIncrValueKeyPress(Sender: TObject;
  var Key: Char);
var
  strtemp: string;
  strvalue: Double;
begin

  if not (key in ['0'..'9', #8, #13]) then
  begin
    key := #0;
    ShowMessage('�������ֻ���������֣�');
  end
  else if key = #13 then
  begin
    if (StrToInt(edtIncrValue.Text) * StrToInt(SystemWorkground.ErrorGTState)) > (StrToInt(INit_Wright.MaxValue)) then
    begin
      strtemp := IntToStr(StrToInt(INit_Wright.MaxValue) div StrToInt(SystemWorkground.ErrorGTState));
      ShowMessage('���������Ϊ���趨���û��ұ�������ֵΪ' + INit_Wright.MaxValue + ',ֻ������С��' + strtemp + '����ֵ��');
      exit;
    end;

    if (edtIncrValue.Text = '') or ((StrToInt(edtIncrValue.Text) mod 10) <> 0) then
    begin
      ShowMessage('�������������10�ı�����ֵ��');
      exit;
    end
    else
    begin
      if (length(TrimRight(Edit_TotalbuyValue.Text)) <> 0) and (length(TrimRight(Edit_TotalChangeValue.Text)) <> 0) then
      begin
        strvalue := (StrToFloat(Edit_TotalbuyValue.Text) - StrToFloat(Edit_TotalChangeValue.Text));
      end
      else if (length(TrimRight(Edit_TotalbuyValue.Text)) <> 0) and (length(TrimRight(Edit_TotalChangeValue.Text)) = 0) then
      begin
        strvalue := (StrToFloat(Edit_TotalbuyValue.Text));
      end
      else if (length(TrimRight(Edit_TotalbuyValue.Text)) = 0) and (length(TrimRight(Edit_TotalChangeValue.Text)) <> 0) then
      begin
        strvalue := 0;
      end
      else if (length(TrimRight(Edit_TotalbuyValue.Text)) = 0) and (length(TrimRight(Edit_TotalChangeValue.Text)) = 0) then
      begin
        strvalue := 0;
      end;
      if Edit_TotalbuyValue.Text = '' then
        Edit_Totalvale.Text := FloatToStr(StrToFloat(edtIncrValue.Text))
      else
        Edit_Totalvale.Text := FloatToStr(StrToFloat(edtIncrValue.Text) + StrToFloat(Edit_TotalbuyValue.Text));

      Edit_Pwdcomfir.Enabled := True;
      Edit_Pwdcomfir.SetFocus;
    end;
  end;

end;

 //��ֵ����������ʽУ��

procedure Tfrm_Frontoperate_incvalue.Edit_PwdcomfirKeyPress(
  Sender: TObject; var Key: Char);
var
  strtemp: string;
  strvalue: Double;
begin

  if not (key in ['0'..'9', #8, #13]) then
  begin
    key := #0;
    ShowMessage('�������ֻ���������֣�');
  end
  else if key = #13 then
  begin
    if (Edit_Pwdcomfir.Text <> '') and (TrimRight(Edit_Pwdcomfir.Text) = TrimRight(Edit_Prepassword.Text)) then
    begin
      btnOffLineRecharge.Enabled := True;
      cbBatchRecharge.Enabled := True;
    end
    else
    begin
      ShowMessage('������������볤��Ϊ6λ�����룡');
      exit;
    end;
  end;

end;


//��ʼ����ֵд������

procedure Tfrm_Frontoperate_incvalue.initIncrOperation;
var
  INC_value: string;
  strValue: string;
begin
  begin
    Operate_No := 1;
    INC_value := edtIncrValue.Text; //��ֵ��ֵ
    strValue := caluSendCMD(CMD_COUMUNICATION.CMD_INCValue, INC_value); //�����ֵָ��
    generateIncrValueCMD(strValue); //�ѳ�ֵָ��д��ID��
  end;
end;
//��ֵ����

//���ɳ�ֵ�Ĳ���ָ��

procedure Tfrm_Frontoperate_incvalue.generateIncrValueCMD(S: string);
begin
  orderLst.Clear();
  recDataLst.Clear();
  curOrderNo := 0;
  curOperNo := 2;
  orderLst.Add(S); //����ֵָ��д�뻺��
  prcSendDataToCard(); //д�뿨ͷ��
end;

//�����ֵָ��

function Tfrm_Frontoperate_incvalue.caluSendCMD(StrCMD: string; StrIncValue: string): string;
var
  TmpStr_IncValue: string; //��ֵ����
  TmpStr_CheckSum: string; //У���
  TmpStr_SendCMD: string; //ָ������
  reTmpStr: string;
begin
  Send_CMD_ID_Infor.CMD := StrCMD; //֡����ͷ��51
  Send_CMD_ID_Infor.ID_INIT := Receive_CMD_ID_Infor.ID_INIT;

  if iHHSet = 0 then //ʱ������������Ч
  begin
    Send_CMD_ID_Infor.ID_3F := IntToHex(0, 2) + IntToHex(0, 2) + IntToHex(0, 2);
    Send_CMD_ID_Infor.Password_3F := IntToHex(0, 2) + IntToHex(0, 2) + IntToHex(0, 2);
  end
  else //����ʱ������
  begin
    getExpireTime;
  end;

    //------------20120320׷��д����Ч�� ����-----------
  Send_CMD_ID_Infor.Password_USER := Receive_CMD_ID_Infor.Password_USER;
//  SystemWorkground.ErrorGTState���ұ���
  TmpStr_IncValue := IntToStr(StrToInt(StrIncValue) * StrToInt(SystemWorkground.ErrorGTState));
  Send_CMD_ID_Infor.ID_value := ICFunction.transferDECValueToHEXByte(TmpStr_IncValue);
    //����������
  Send_CMD_ID_Infor.ID_type := Receive_CMD_ID_Infor.ID_type;
    //���ܷ�������
  TmpStr_SendCMD := Send_CMD_ID_Infor.CMD + Send_CMD_ID_Infor.ID_INIT + Send_CMD_ID_Infor.ID_3F + Send_CMD_ID_Infor.Password_3F
    + Send_CMD_ID_Infor.Password_USER + Send_CMD_ID_Infor.ID_value + Send_CMD_ID_Infor.ID_type;
    //���������ݽ���У�˼���
  TmpStr_CheckSum := CheckSUMData(TmpStr_SendCMD);
    //TmpStr_CheckSum�ֽ���Ҫ�����Ų� �����ֽ���ǰ�����ֽ��ں�
  Send_CMD_ID_Infor.ID_CheckNum := transferCheckSumByte(TmpStr_CheckSum);
  Send_CMD_ID_Infor.ID_Settime := Receive_CMD_ID_Infor.ID_Settime;
  //ID_settimeû�з���

  reTmpStr := TmpStr_SendCMD + Send_CMD_ID_Infor.ID_CheckNum;

  result := reTmpStr;

end;

//ȡ�õ��ӱҵĵ���ʱ�� expiretime

procedure Tfrm_Frontoperate_incvalue.getExpireTime;
var
  strtemp: string;
  iYear, iMonth, iDate, iHH, iMin: integer;
begin
  strtemp := FormatDateTime('yyyy-MM-dd HH:mm:ss', now);
  iYear := strToint(Copy(strtemp, 1, 4)); //��
  iMonth := strToint(Copy(strtemp, 6, 2)); //��
  iDate := strToint(Copy(strtemp, 9, 2)); //��
  iHH := strToint(Copy(strtemp, 12, 2)); //Сʱ
  iMin := strToint(Copy(strtemp, 15, 2)); //����

  if (iHHSet > 47) then
  begin
    showmessage('Ϊ�˱������������氲ȫ�����趨����Чʱ��С��48');
    exit;
  end;
   //��ΪiHH��0~24����iHHSetҲ����0~24Сʱ ������ (iHH+iHHSet)��Ϊ0~48Сʱ
   //������� (iHH+iHHSet)��Ϊ24~48Сʱ ��Ϊ1����Ч
  if ((iHH + iHHSet) >= 24) and ((iHH + iHHSet) < 48) then
  begin
    iHH := (iHH + iHHSet) - 24; //ȡ���µ�Сʱ
    if (iYear < 1930) then
    begin
      showmessage('ϵͳʱ�������趨�������뿨ͷ��ʱͬ��');
      exit;
    end;
    if (iMonth = 2) then
    begin
      if ((iYear mod 4) = 0) or ((iYear mod 100) = 0) then //���� 2��Ϊ28��
      begin
        if (iDate = 28) then
        begin
          iDate := 1;
          iMonth := iMonth + 1;
        end
        else
        begin
          iDate := iDate + 1;
        end;
      end
      else //��������  2��Ϊ29��
      begin
        if (iDate = 29) then
        begin
          iDate := 1;
          iMonth := iMonth + 1;
        end
        else
        begin
          iDate := iDate + 1;
        end;
      end;
    end
    else if (iMonth = 1) or (iMonth = 3) or (iMonth = 5) or (iMonth = 7) or (iMonth = 8) or (iMonth = 10) then
    begin
      if (iDate = 31) then
      begin
        iDate := 1;
        iMonth := iMonth + 1;
      end
      else
      begin
        iDate := iDate + 1;
      end;
    end
    else if (iMonth = 12) then
    begin
      if (iDate = 31) then
      begin
        iDate := 1;
        iMonth := 1;
        iYear := iYear + 1;
      end
      else
      begin
        iDate := iDate + 1;
      end;
    end
    else if (iMonth = 4) or (iMonth = 6) or (iMonth = 9) or (iMonth = 11) then
    begin
      if (iDate = 30) then
      begin
        iDate := 1;
        iMonth := iMonth + 1;
      end
      else
      begin
        iDate := iDate + 1;
      end;
    end;
  end
   //��Σ���� (iHH+iHHSet)��Ϊ0~24Сʱ ��ΪС��1����Ч
  else if ((iHH + iHHSet) < 24) then
  begin
    iHH := (iHH + iHHSet); //ȡ���µ�Сʱ
  end;

     //ת��Ϊ16���ƺ�
     //strtemp=now   Copy(strtemp, 3, 2)=

  Send_CMD_ID_Infor.ID_3F := IntToHex(iMonth, 2) + IntToHex(iHH, 2) + IntToHex(strtoint(Copy(strtemp, 3, 2)), 2);
  Send_CMD_ID_Infor.Password_3F := IntToHex(iDate, 2) + IntToHex(iMin, 2) + IntToHex(strtoint(Copy(strtemp, 1, 2)), 2);
end;




//У��ͣ�ȷ���Ƿ���ȷ

function Tfrm_Frontoperate_incvalue.checkSUMData(orderStr: string): string;
var
  i, j, k: integer;
  TmpStr: string;
  reTmpStr: string;
begin
  if (length(orderStr) mod 2) <> 0 then
  begin
    MessageBox(handle, '����������ȴ���!', '����', MB_ICONERROR + MB_OK);
    result := '';
    exit;
  end;
  k := 0;
  for i := 1 to (length(orderStr) div 2) do
  begin
    tmpStr := copy(orderStr, i * 2 - 1, 2);
    j := strToint('$' + tmpStr);
    k := k + j;

  end;
  reTmpStr := IntToHex(k, 2);
  result := reTmpStr;
end;


//У���ת����16���Ʋ����� �ֽ�LL���ֽ�LH

function Tfrm_Frontoperate_incvalue.transferCheckSumByte(StrCheckSum: string): string;
var
  j: integer;
  tempLH, tempLL: integer; //2147483648 ���Χ

begin
  j := strToint('$' + StrCheckSum); //���ַ�תת��Ϊ16��������Ȼ��ת��λ10����
  tempLH := (j mod 65536) div 256; //�ֽ�LH
  tempLL := j mod 256; //�ֽ�LL

  result := IntToHex(tempLL, 2) + IntToHex(tempLH, 2);
end;

end.
