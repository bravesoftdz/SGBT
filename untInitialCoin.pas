unit untInitialCoin;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, SPComm, DB, ADODB, Grids, DBGrids;

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
    btnExit: TButton;
    dgInitial: TDBGrid;
    ADOQueryInitial: TADOQuery;
    dsInitial: TDataSource;
    commInitial: TComm;
    lblMessage: TLabel;
    edtBandID: TEdit;
    Label3: TLabel;
    memo1: TMemo;
    procedure commInitialReceiveData(Sender: TObject; Buffer: Pointer;
      BufferLength: Word);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnInitialClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }

        //���ݿ����
    function initCoinRecord():string;
    procedure saveInitialRecord(); //�����ֵ��¼
        //��ͷ������
    procedure checkCMDInfo();
    procedure initIncrOperation(strRechargeCoin :string ); //��ֵ������д���ݸ���
    function  caluSendCMD(strCMD: string; strIncrValue: string): string;
    procedure generateIncrValueCMD(S: string);
    procedure prcSendDataToCard();
    procedure showUserCardOperation();
    procedure prcCardIncrValueReturn();
    procedure prcCardReadValueReturn();
    function  checkSUMData(orderStr: string): string;
    function  Display_ID_TYPE_Value(StrIDtype: string): string;
    procedure initComboxCardtype;
  end;

var
  frmInitial: TfrmInitial;
  curOrderNo: integer = 0;  //???
  curOperNo: integer = 0;
  Operate_No: integer = 0;   //ʲô����?������ڳ�ֵ��
  orderLst, recDataLst: Tstrings;  //����ȫ�ֱ����������ݣ���������
  ID_UserCard_Text: string;
  IncValue_Enable: boolean;  //�Ƿ������ֵ�ı�־,��Ա����֤ͨ������ΪTrue
  buffer: array[0..2048] of byte;
  ID_System: string;
  Password3F_System: string;

implementation
uses ICDataModule, ICCommunalVarUnit, ICmain, ICEventTypeUnit, ICFunctionUnit,dateProcess;
{$R *.dfm}


function TfrmInitial.initCoinRecord():string;
var
  strSQL: string;
begin
  with ADOQueryInitial do begin
    Connection := DataModule_3F.ADOConnection_Main;
    Active := false;
    SQL.Clear;
    strSQL := 'select coinid,id_3f,password_3f,password_user,id_type,id_value,operatorno,operatetime from t_id_init';
    SQL.Add(strSQL);
    Active := True;
  end;
  result := '1';
end;


procedure TfrmInitial.saveInitialRecord(); //�����ֵ��¼
var
 strID3F, strBandid, strShopID,  strIDType, strOperateTime, strOperatorNO,strSG3FPassword,strIDTypeName,strCoin,strsql: string;
begin

    strBandid :=trim(edtBandID.Text);
    strID3F := '3f3f3f';
    strSG3FPassword := '3f3f3f';
    strShopID :=trim(edtShopID.Text);
    strIDType :=cbCoinType.Text; //01��ʾ�ֽ�,02��ʾ����
    strIDTypeName := '�û���';
    strCoin :='0';
    //ָ�����ڸ�ʽ ��Ҫ
    ShortDateFormat := 'yyyy-MM-dd';  //ָ����ʽ����
    DateSeparator := '-';
    //ָ�����ڸ�ʽ ����ᱨis not an valid date and time;
    strOperatorNO :='001';
    strOperateTime := FormatDateTime('yyyy-MM-dd HH:mm:ss', now);


    with ADOQueryInitial do begin
        Connection := DataModule_3F.ADOConnection_Main;
        Active := false;
        SQL.Clear;
        strSQL := 'select coinid,id_3f,password_3f,password_user,id_type,id_typename,id_value,operatorno,operatetime from t_id_init order by operatetime desc'; //ΪʲôҪ��ȫ����
        SQL.Add(strSQL);
        Active := True;  
      Append;
      FieldByName('coinid').AsString := strBandid;
      FieldByName('id_3f').AsString := strID3F;
      FieldByName('password_3f').AsString := strSG3FPassword;
      FieldByName('password_user').AsString := strShopID;
      FieldByName('id_type').AsString := strIDType;
      FieldByName('id_typename').AsString := strIDTypeName;
      FieldByName('id_value').AsString := strCoin;
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

  if ICCommunalVarUnit.Receive_CMD_ID_Infor.CMD =CMD_COUMUNICATION.CMD_READ then //�յ���ͷд����ӱҳ�ֵ�ɹ��ķ��� 53
    begin
      prcCardReadValueReturn();
    end
  else if Receive_CMD_ID_Infor.CMD =  ICCommunalVarUnit.CMD_COUMUNICATION.CMD_INCValue_RE then  //��ָ��
    begin
       prcCardIncrValueReturn();
    end;
end;


//��ͷ���س�ֵ�ɹ�ָ��
procedure TfrmInitial.prcCardIncrValueReturn();
begin
      if Receive_CMD_ID_Infor.ID_type = copy(INit_Wright.User, 8, 2) then  //������Ҳ���Գ�ֵ/������¼
       begin
        saveInitialRecord(); //�����ֵ��¼
        lblMessage.Caption := '�û�����ʼ���ɹ�';
        initCoinRecord();
      end;
end;


//��ͷ������Ϣ��ȡָ��
procedure TfrmInitial.prcCardReadValueReturn();
begin
    Receive_CMD_ID_Infor.ID_INIT := copy(recDataLst.Strings[0], 3, 8); //��ƬID
    Receive_CMD_ID_Infor.ID_3F := copy(recDataLst.Strings[0], 11, 6); //����ID
    Receive_CMD_ID_Infor.Password_3F := copy(recDataLst.Strings[0], 17, 6); //����
    Receive_CMD_ID_Infor.Password_USER := copy(recDataLst.Strings[0], 23, 6); //�û�����
    Receive_CMD_ID_Infor.ID_value := copy(recDataLst.Strings[0], 29, 8); //��������
    Receive_CMD_ID_Infor.ID_type := copy(recDataLst.Strings[0], 37, 2); //������

    writeln('ID_INIT'+Receive_CMD_ID_Infor.ID_INIT);
    writeln('ID_3F'+Receive_CMD_ID_Infor.ID_3F);
    writeln('Password_3F'+Receive_CMD_ID_Infor.Password_3F);
    writeln('Password_USER'+Receive_CMD_ID_Infor.Password_USER);
    writeln('ID_value' + Receive_CMD_ID_Infor.ID_value);
    writeln('ID_type '+Receive_CMD_ID_Infor.ID_type);

    //�����ؿ���� -----��ʼ
                                   //���س�ʼ����� -----��ʼ
          if DataModule_3F.Query_User_INIT_OK(Receive_CMD_ID_Infor.ID_INIT) = false then //�м�¼
          begin
            lblMessage.Caption := '���ȳ�ʼ����';
            exit;
          end
          else
          begin 
              if Receive_CMD_ID_Infor.ID_type = copy(INit_Wright.User, 8, 2) then
              begin //�û��� -----��ʼ
                    showUserCardOperation();
                    
              end //�û�������
              else if Receive_CMD_ID_Infor.ID_type = copy(INit_Wright.OPERN, 8, 2) then
              begin //������ -----��ʼ
                  lblMessage.Caption := '���û��ҺϷ������������������������';
              end
          end;

end;


//�����������б�ʵʼ��
procedure TfrmInitial.initComboxCardtype;
begin
  cbCoinType.Items.Add(copy(INit_Wright.User, 1, 6));
  cbCoinType.Items.Add(copy(INit_Wright.OPERN, 1, 6));
end;



//�û�����Ϣչʾ
procedure TfrmInitial.showUserCardOperation();
begin
    edtBandID.Text := Receive_CMD_ID_Infor.ID_INIT; //�û���ID
    memo1.Text := Receive_CMD_ID_Infor.Password_USER;//shopid
//    edtShopID.Text := '0';//shopid

    lblMessage.Caption := '���û��ҺϷ��������������'; //��ID

end;//end prc_user_card_operation


procedure TfrmInitial.initIncrOperation(strRechargeCoin :string );
var
  strValue: string;
begin
    strValue := caluSendCMD(CMD_COUMUNICATION.CMD_INCValue, strRechargeCoin); //�����ֵָ��
    generateIncrValueCMD(strValue); //�ѳ�ֵָ��д��ID��
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
  prcSendDataToCard();//д�뿨ͷ��
end;

//�����ֵָ��
function TfrmInitial.caluSendCMD(strCMD: string; strIncrValue: string): string;
var
  TmpStr_IncValue: string; //��ֵ����
  TmpStr_CheckSum: string; //У���
  TmpStr_SendCMD: string; //ָ������
  reTmpStr: string;
begin

  INit_3F.CMD := StrCMD; //֡����
  INit_3F.ID_INIT := edtBandID.Text; //��ID

    //Password3F_System ��ID_System��������������������û���Żس�ʱִ�����ɵ�
  ID_System := ICFunction.SUANFA_ID_3F(edtBandID.Text); //���ü���ID_3F�㷨
  Password3F_System := ICFunction.SUANFA_Password_3F(edtBandID.Text); //���ü���Password_3F�㷨

  INit_3F.ID_3F := copy(Password3F_System, 5, 2) + copy(ID_System, 1, 2) + copy(Password3F_System, 3, 2);
  //ID_3F.Text := INit_3F.ID_3F;

  INit_3F.Password_3F := INit_Wright.BossPassword; //ֱ�Ӷ�ȡ�����ļ��еĳ������� (PC����������)
//  ID_Password_3F.Text := INit_3F.Password_3F; //�û��������룬�������ĵ�����

  //ID_Password_USER.Text := INit_Wright.BossPassword; //ֱ�Ӷ�ȡ�����ļ��еĳ�������  (PC����������)
  INit_3F.Password_USER := edtShopID.Text; //�û��������룬�������ĵ�����  (PC����������)

  TmpStr_IncValue := COPY(INit_3F.ID_3F, 3, 2) + ICFunction.SUANFA_Password_USER_WritetoID(INit_3F.ID_3F, edtBandID.Text);
  INit_3F.ID_value := TmpStr_IncValue;


  INit_3F.ID_type := Display_ID_TYPE_Value(cbCoinType.Text); //ȡ�ÿ����͵�ֵ
//  Edit20.Text := ID_Password_USER.Text;
    //���ܷ�������
  TmpStr_SendCMD := INit_3F.CMD + INit_3F.ID_INIT + INit_3F.ID_3F + INit_3F.Password_3F + INit_3F.Password_USER + INit_3F.ID_value + INit_3F.ID_type;
   //TmpStr_SendCMD:=ָ��֡ͷ+ ��ID+ 3F����ID + 3F��������+   �û���������  +   3F������ʼ��ֵ  + 3F������ʼ������

    //���������ݽ���У�˼���
  TmpStr_CheckSum := CheckSUMData(TmpStr_SendCMD);
    //TmpStr_CheckSum�ֽ���Ҫ�����Ų� �����ֽ���ǰ�����ֽ��ں�
  INit_3F.ID_CheckNum := ICFunction.transferCheckSumByte(TmpStr_CheckSum);
  //ID_CheckSum.Text := ICFunction.transferCheckSumByte(TmpStr_CheckSum);
  reTmpStr := TmpStr_SendCMD + INit_3F.ID_CheckNum;

  result := reTmpStr;
end;



function TfrmInitial.Display_ID_TYPE_Value(StrIDtype: string): string;
begin
  if (StrIDtype = copy(INit_Wright.User, 1, 6)) then //�����ܣ�����   //�û���
    result := copy(INit_Wright.User, 8, 2)
  else if (StrIDtype = copy(INit_Wright.OPERN, 1, 6)) then //������
    result := copy(INit_Wright.OPERN, 8, 2);

end;

function TfrmInitial.checkSUMData(orderStr: string): string;
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
  //
   //��ʼ��
  initComboxCardtype();
  initCoinRecord();

  //��ʼ������
  orderLst := TStringList.Create;
  recDataLst := tStringList.Create;

  //�򿪴���
 commInitial.StartComm();
 

 
end;

procedure TfrmInitial.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  //
  orderLst.Free;
  recDataLst.Free;
  commInitial.StopComm();
end;

procedure TfrmInitial.btnInitialClick(Sender: TObject);
var
intWriteValue : Integer;
begin
    intWriteValue := 0; //��ʼ��ʱ��ֵ�趨Ϊ0
    initIncrOperation(intToStr(intWriteValue));
end;

end.
