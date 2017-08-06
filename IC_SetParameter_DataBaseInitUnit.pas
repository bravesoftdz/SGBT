unit IC_SetParameter_DataBaseInitUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, IniFiles,
  Dialogs, DB, ADODB, StdCtrls, Buttons, ExtCtrls, SPComm;

type
  Tfrm_IC_SetParameter_DataBaseInit = class(TForm)
    Panel1: TPanel;
    GroupBox5: TGroupBox;
    btnFactoryInitial: TBitBtn;
    Comm_Check: TComm;
    lblMessage: TPanel;
    GroupBox2: TGroupBox;
    btnClearCoinRecharge: TButton;
    btnClearBarFlow: TButton;
    btnClearCoinRefund: TButton;
    procedure btnFactoryInitialClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Comm_CheckReceiveData(Sender: TObject; Buffer: Pointer;
      BufferLength: Word);

    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Bit_CloseClick(Sender: TObject);
    procedure btnClearCoinRechargeClick(Sender: TObject);
    procedure btnClearBarFlowClick(Sender: TObject);
    procedure btnClearCoinRefundClick(Sender: TObject);

    private
    { Private declarations }

    procedure CheckCMD_Right(); //ϵͳ����Ȩ���жϣ�ȷ���Ƿ�����ܹ�Ψһ��Ӧ
    procedure INcrevalue(S: string); //��ֵ����
    procedure sendData();
        //������������ָ��

    function exchData(orderStr: string): string;
    //���Ͷ�ȡ������������ָ��

    function Make_Send_CMD_PasswordIC(StrCMD: string; StrIncValue: string): string;
    function CheckSUMData_PasswordIC(orderStr: string): string;

  public
    { Public declarations }

    procedure DeleteDataFromTable; //ɾ����������
    function Select_IncValue_Byte(StrIncValue: string): string;
    function Select_CheckSum_Byte(StrCheckSum: string): string;
  end;

var
  frm_IC_SetParameter_DataBaseInit: Tfrm_IC_SetParameter_DataBaseInit;
  CustomerName_check: string; //ϵͳ���
  BossPassword_check: string; //PC����������
  BossPassword_old_check: string; //PC����������
  BossPassword_3F_check: string; //PCд��������
  strtime: string; //�趨ʱ��

  Check_Count, Check_Count_3FPASSWORD, Check_Count_USERPASSWORD, Check_Count_3FLOADDATE: integer;
  orderLst, recDataLst, recData_fromICLst, recData_fromICLst_Check: Tstrings;
  LOAD_CHECK_OK_RE, LOAD_3FPASSWORD_OK_RE, LOAD_USERPASSWORD_OK_RE, LOAD_3FLOADDATE_OK_RE: BOOLEAN;
  WriteToFile_OK, WriteToFlase_OK: BOOLEAN;
implementation

uses ICDataModule, ICCommunalVarUnit, ICmain, ICEventTypeUnit, ICFunctionUnit,
  Logon;

{$R *.dfm}

procedure Tfrm_IC_SetParameter_DataBaseInit.btnFactoryInitialClick(Sender: TObject); 
begin
  lblMessage.Caption := '��ʼ������ʼ��';
  DeleteDataFromTable();
  lblMessage.Caption := '������ʼ����ɣ�';

end;



//ɾ����������

procedure Tfrm_IC_SetParameter_DataBaseInit.DeleteDataFromTable;
var
  ADOQ: TADOQuery;
  strSQL: string;
begin
  lblMessage.Caption := '������ʼ����...��ȴ�...';
  strSQL := 'delete from TMACHINESET';
  ICFunction.loginfo('strSQL :' + strSQL);
  DataModule_3F.executesql(strSQL);

  strSQL := 'delete from TPOSITIONSET';
  ICFunction.loginfo('strSQL :' + strSQL);
  DataModule_3F.executesql(strSQL);

  strSQL := 'delete from T_BIND_CARDHEADID';
  ICFunction.loginfo('strSQL :' + strSQL);
  DataModule_3F.executesql(strSQL);

  strSQL := 'delete from T_COIN_INITIAL';
  ICFunction.loginfo('strSQL :' + strSQL);
  DataModule_3F.executesql(strSQL);



  strSQL := 'delete from T_COIN_RECHARGE';
  ICFunction.loginfo('strSQL :' + strSQL);
  DataModule_3F.executesql(strSQL);


  strSQL := 'delete from T_COIN_REFUND';
  ICFunction.loginfo('strSQL :' + strSQL);
  DataModule_3F.executesql(strSQL);



  strSQL := 'delete from T_BAR_FLOW';
  ICFunction.loginfo('strSQL :' + strSQL);
  DataModule_3F.executesql(strSQL);


  strSQL := 'delete from T_ACCOUNT_LOG';
  ICFunction.loginfo('strSQL :' + strSQL);
  DataModule_3F.executesql(strSQL);


  strSQL := 'delete from T_COIN_LOG';
  ICFunction.loginfo('strSQL :' + strSQL);
  DataModule_3F.executesql(strSQL);


  strSQL := 'delete from T_MEMBER_ACCOUNT';
  ICFunction.loginfo('strSQL :' + strSQL);
  DataModule_3F.executesql(strSQL);


  strSQL := 'delete from T_MEMBER_CARD_CONFIGURATION';
  ICFunction.loginfo('strSQL :' + strSQL);
  DataModule_3F.executesql(strSQL);


  strSQL := 'delete from T_MEMBER_INFO';
  ICFunction.loginfo('strSQL :' + strSQL);
  DataModule_3F.executesql(strSQL);


  strSQL := 'delete from T_PRESENT_LOG';
  ICFunction.loginfo('strSQL :' + strSQL);
  DataModule_3F.executesql(strSQL);


end;

procedure Tfrm_IC_SetParameter_DataBaseInit.FormShow(Sender: TObject);
begin


  CustomerName_check := '';
  BossPassword_check := '';
  BossPassword_old_check := '';
  BossPassword_3F_check := '';

  recData_fromICLst_Check := TStringList.Create;
  orderLst := TStringList.Create;

  try
    Comm_Check.StartComm()
  except on E: Exception do //���������쳣
    begin
      showmessage(SG3FERRORINFO.commerror + e.message);
      exit;
    end;
  end;


end;


procedure Tfrm_IC_SetParameter_DataBaseInit.Comm_CheckReceiveData(
  Sender: TObject; Buffer: Pointer; BufferLength: Word);
var
  ii: integer;
  recStr: string;
  tmpStr: string;
  tmpStrend: string;
begin
   //����----------------
  recStr := '';
  SetLength(tmpStr, BufferLength);
  move(buffer^, pchar(tmpStr)^, BufferLength);
  for ii := 1 to BufferLength do
  begin
    recStr := recStr + intTohex(ord(tmpStr[ii]), 2); //���������ת��Ϊ16������
    if ii = BufferLength then
    begin
      tmpStrend := 'END';
    end;
  end;
  recData_fromICLst_Check.Clear;
  recData_fromICLst_Check.Add(recStr);
    //����---------------
  begin
    CheckCMD_Right(); //ϵͳ����ʱ�жϼ��ܹ�
  end;
end;
//���ݽ��յ��������жϴ˿��Ƿ�Ϊ�Ϸ���

procedure Tfrm_IC_SetParameter_DataBaseInit.CheckCMD_Right();
var
  tmpStr: string;
  i: integer;
  content1, content2, content3, content4, content5, content6: string;
begin
   //���Ƚ�ȡ���յ���Ϣ
  tmpStr := '';
  tmpStr := recData_fromICLst_Check.Strings[0];

  content1 := copy(tmpStr, 1, 2); //֡ͷAA
  content2 := copy(tmpStr, 3, 2); //����ָ��
  if (content1 = '43') then //֡ͷ
  begin


    if (content2 = CMD_COUMUNICATION.CMD_HAND) then //�յ�������������Ϣ0x61
    begin
      for i := 1 to length(tmpStr) do
      begin
        if (copy(tmpStr, i, 2) = '03') and (i mod 2 = 1) then
        begin
          content3 := copy(tmpStr, i - 2, 2); //ָ��У���
          content5 := copy(tmpStr, 1, i - 3) + '63' + copy(tmpStr, i, 2);

          if (CheckSUMData_PasswordIC(content5) = content3) then
          begin

            LOAD_CHECK_OK_RE := true; //���ֳɹ�
//            Timer_HAND.Enabled := FALSE; //�رռ�ⶨʱ��
//            Timer_USERPASSWORD.Enabled := true; //����дϵͳ���ָ��
            lblMessage.Caption := '���ֲ����ɹ�';

            tmpStr := '';
            break;
          end;
        end;
      end; //for ����

    end
    else if (content2 = CMD_COUMUNICATION.CMD_WRITETOFLASH_Sub_RE) then //�յ�д��ϵͳ��ŷ�����Ϣ0x66
    begin
      for i := 1 to length(tmpStr) do
      begin
        if (copy(tmpStr, i, 2) = '03') and (i mod 2 = 1) then
        begin

          content6 := copy(tmpStr, 5, 2);
          content3 := copy(tmpStr, i - 2, 2); //ָ��У���
          if (content6 = CMD_COUMUNICATION.CMD_USERPASSWORD_RE) then //0x68
          begin
            content5 := copy(tmpStr, 1, i - 3) + '63' + copy(tmpStr, i, 2);

            if (CheckSUMData_PasswordIC(content5) = content3) then
            begin
              LOAD_USERPASSWORD_OK_RE := true;
//              Timer_USERPASSWORD.Enabled := false;
//              Timer_3FPASSWORD.Enabled := true;
              lblMessage.Caption := 'д��ϵͳ��������ɹ�';
            end;
            tmpStr := '';
            break;
          end
          else if (content6 = CMD_COUMUNICATION.CMD_3FPASSWORD_RE) then //0x66
          begin

            content5 := copy(tmpStr, 1, i - 3) + '63' + copy(tmpStr, i, 2);

            if (CheckSUMData_PasswordIC(content5) = content3) then
            begin
              LOAD_3FPASSWORD_OK_RE := true;
//              Timer_3FPASSWORD.Enabled := false;
//              Timer_3FLOADDATE.Enabled := true;
              lblMessage.Caption := 'д�볡����������ɹ�';

            end;
            tmpStr := '';
            break;
          end
          else if (content6 = CMD_COUMUNICATION.CMD_3FLODADATE_RE) then //0x69
          begin


            content5 := copy(tmpStr, 1, i - 3) + '63' + copy(tmpStr, i, 2);
            if (CheckSUMData_PasswordIC(content5) = content3) then
            begin
              LOAD_3FLOADDATE_OK_RE := true;
              WriteToFlase_OK := true;
              lblMessage.Caption := 'д���½ʱ������ɹ�';

              if WriteToFile_OK then
              begin
                if WriteToFlase_OK then
                begin


                  DeleteDataFromTable; //ɾ����������
                  lblMessage.Caption := '�����������á����ݿ���������ɹ�';
                  WriteToFile_OK := false;
                  WriteToFlase_OK := false;
                end;
              end;

            end;


            tmpStr := '';
            break;


          end;

        end;
      end; //------for ����
    end;

  end;


end;




//������������ָ��

//�����ֵָ��

function Tfrm_IC_SetParameter_DataBaseInit.Make_Send_CMD_PasswordIC(StrCMD: string; StrIncValue: string): string;
var
  i: integer;
  TmpStr_IncValue: string; //תΪ16���ƺ���ַ���
  TmpStr_CheckSum: string; //У���
  TmpStr_SendCMD: string; //ָ������
  reTmpStr, StrFramEND, StrConFram: string;
begin

  TmpStr_IncValue := IntToHex(Ord(StrIncValue[1]), 2);

  for i := 2 to length(StrIncValue) - 1 do
  begin
    TmpStr_IncValue := TmpStr_IncValue + IntToHex(Ord(StrIncValue[i]), 2);

  end;
    //Edit4.Text:= TmpStr_IncValue;
  StrFramEND := '03';
  StrConFram := '63';
    //���������ݽ���У�˼���
  TmpStr_SendCMD := StrCMD + TmpStr_IncValue + StrFramEND + StrConFram;

  TmpStr_CheckSum := CheckSUMData_PasswordIC(TmpStr_SendCMD);
    //���ܷ�������

  reTmpStr := StrCMD + TmpStr_IncValue + TmpStr_CheckSum + StrFramEND;

  result := reTmpStr;

end;

//У��ͣ�ȷ���Ƿ���ȷ

function Tfrm_IC_SetParameter_DataBaseInit.CheckSUMData_PasswordIC(orderStr: string): string;
var
  ii, jj, KK: integer;
  TmpStr: string;
  reTmpStr: string;
begin
  if (length(orderStr) mod 2) <> 0 then
  begin
    MessageBox(handle, '����������ȴ���!', '����', MB_ICONERROR + MB_OK);
    result := '';
    exit;
  end;
  KK := 0;
  for ii := 1 to (length(orderStr) div 2) do
  begin
    tmpStr := copy(orderStr, ii * 2 - 1, 2);
    jj := strToint('$' + tmpStr);
    KK := KK xor jj;

  end;
  reTmpStr := IntToHex(KK, 2);
  result := reTmpStr;
end;
//д��---------------------------------------

procedure Tfrm_IC_SetParameter_DataBaseInit.INcrevalue(S: string);
begin
  orderLst.Clear();
  curOrderNo := 0;
  curOperNo := 1;
  orderLst.Add(S); //����ֵд�����
  sendData();
end;
//�������ݹ���

procedure Tfrm_IC_SetParameter_DataBaseInit.sendData();
var
  orderStr: string;
begin
  if orderLst.Count > curOrderNo then
  begin
    orderStr := orderLst.Strings[curOrderNo];
    orderStr := exchData(orderStr);
    Comm_Check.WriteCommData(pchar(orderStr), length(orderStr));
    inc(curOrderNo);
  end;
end;



//ת�ҷ������ݸ�ʽ �����ַ�ת��Ϊ16����

function Tfrm_IC_SetParameter_DataBaseInit.exchData(orderStr: string): string;
var
  ii, jj: integer;
  TmpStr: string;
  reTmpStr: string;
begin
  if (length(orderStr) = 0) then
  begin
    MessageBox(handle, '�����������Ϊ��!', '����', MB_ICONERROR + MB_OK);
    result := '';
    exit;
  end;
  if (length(orderStr) mod 2) <> 0 then
  begin
    MessageBox(handle, '�����������!', '����', MB_ICONERROR + MB_OK);
    result := '';
    exit;
  end;
  for ii := 1 to (length(orderStr) div 2) do
  begin
    tmpStr := copy(orderStr, ii * 2 - 1, 2);
    jj := strToint('$' + tmpStr);
    reTmpStr := reTmpStr + chr(jj);
  end;
  result := reTmpStr;
end;


//��ֵ����ת����16���Ʋ����� �ֽ�LL���ֽ�LH���ֽ�HL���ֽ�HH

function Tfrm_IC_SetParameter_DataBaseInit.Select_IncValue_Byte(StrIncValue: string): string;
var
  tempLH, tempHH, tempHL, tempLL: integer; //2147483648 ���Χ
begin
  tempHH := StrToint(StrIncValue) div 16777216; //�ֽ�HH
  tempHL := (StrToInt(StrIncValue) mod 16777216) div 65536; //�ֽ�HL
  tempLH := (StrToInt(StrIncValue) mod 65536) div 256; //�ֽ�LH
  tempLL := StrToInt(StrIncValue) mod 256; //�ֽ�LL

  result := IntToHex(tempLL, 2) + IntToHex(tempLH, 2) + IntToHex(tempHL, 2) + IntToHex(tempHH, 2);
end;

//У���ת����16���Ʋ����� �ֽ�LL���ֽ�LH

function Tfrm_IC_SetParameter_DataBaseInit.Select_CheckSum_Byte(StrCheckSum: string): string;
var
  jj: integer;
  tempLH, tempLL: integer; //2147483648 ���Χ

begin
  jj := strToint('$' + StrCheckSum); //���ַ�תת��Ϊ16��������Ȼ��ת��λ10����
  tempLH := (jj mod 65536) div 256; //�ֽ�LH
  tempLL := jj mod 256; //�ֽ�LL

  result := IntToHex(tempLL, 2) + IntToHex(tempLH, 2);
end;


 //���ݽ��յ��������ж���Ӧ���
procedure Tfrm_IC_SetParameter_DataBaseInit.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  orderLst.Free();
  recData_fromICLst_Check.Free();
  Comm_Check.StopComm();
end;

procedure Tfrm_IC_SetParameter_DataBaseInit.Bit_CloseClick(
  Sender: TObject);
begin
  close;
end;



procedure Tfrm_IC_SetParameter_DataBaseInit.btnClearCoinRechargeClick(
  Sender: TObject);
var
  strSQL : string;
begin
 lblMessage.Caption := '��ʼ�����ֵ��¼';

  strSQL := 'delete from T_COIN_RECHARGE';
  ICFunction.loginfo('strSQL :' + strSQL);
  DataModule_3F.executesql(strSQL);

  lblMessage.Caption := '�����ֵ��¼��ɣ�';
end;

procedure Tfrm_IC_SetParameter_DataBaseInit.btnClearBarFlowClick(
  Sender: TObject);
var
  strSQL : string;
begin
    lblMessage.Caption := '��ʼ����һ���¼��';
  strSQL := 'delete from T_BAR_FLOW ';
  ICFunction.loginfo('strSQL :' + strSQL);
  DataModule_3F.executesql(strSQL);
    lblMessage.Caption := '�������һ���¼��';
end;

procedure Tfrm_IC_SetParameter_DataBaseInit.btnClearCoinRefundClick(
  Sender: TObject);
var
  strSQL : string;
begin
  lblMessage.Caption := '�������˱Ҽ�¼��';
  strSQL := 'delete from T_COIN_REFUND';
  ICFunction.loginfo('strSQL :' + strSQL);
  DataModule_3F.executesql(strSQL);
  lblMessage.Caption := '�������˱Ҽ�¼��';
end;

end.

