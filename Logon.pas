unit Logon;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, IniFiles,
  Dialogs, jpeg, ExtCtrls, StdCtrls, Buttons, ADODB, Menus, SPComm, IdHTTP, IdHashMessageDigest,
  IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient, uLkJSON,
  IdAntiFreezeBase, IdAntiFreeze;

type
  TFrm_Logon = class(TForm)
    Panel1: TPanel;
    edtPassword: TEdit;
   // comReader: TComm;
   // Comm_Check: TComm;
    Timer1: TTimer;
    Timer2: TTimer;
    Timer_HAND: TTimer;
    Timer_USERPASSWORD: TTimer;
    Timer_3FPASSWORD: TTimer;
    lblMessage: TLabel;
    Timer_3FLOADDATE: TTimer;
    Timer_3FLOADDATE_WRITE: TTimer;
    Label3: TLabel;
    Image1: TImage;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    loginIdHTTP: TIdHTTP;
    btnLogin: TButton;
    comReader: TComm;
    Comm_Check: TComm;
    IdAntiFreeze1: TIdAntiFreeze;


    //�����¼�
    procedure FormActivate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure SetCursorRect(rect: TRect);

    //�����¼�
    procedure comReaderReceiveData(Sender: TObject; Buffer: Pointer; BufferLength: Word);
    procedure Comm_CheckReceiveData(Sender: TObject; Buffer: Pointer; BufferLength: Word);

    //�ؼ��¼�
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn_ExitClick(Sender: TObject);
    procedure BitBtn_OKClick(Sender: TObject);
    procedure Panel1DblClick(Sender: TObject);
    procedure Label5Click(Sender: TObject);
    procedure edtPasswordKeyPress(Sender: TObject; var Key: Char);

    //��ʱ���¼�
    procedure Timer1Timer(Sender: TObject);
    procedure Timer2Timer(Sender: TObject);
    procedure Timer_3FPASSWORDTimer(Sender: TObject);
    procedure Timer_USERPASSWORDTimer(Sender: TObject);
    procedure Timer_HANDTimer(Sender: TObject);
    procedure Timer_3FLOADDATETimer(Sender: TObject);
    procedure Timer_3FLOADDATE_WRITETimer(Sender: TObject);


    procedure btnLoginClick(Sender: TObject);


  private


    { Private declarations }
  public
    procedure checkLogin();

    { Public declarations }
    procedure CheckCMD();
    procedure checkEncodeDogCMD(); //ϵͳ����Ȩ���жϣ�ȷ���Ƿ�����ܹ�Ψһ��Ӧ
    function INit_Send_CMD(StrCMD: string; StrIncValue: string): string;
    procedure INIT_Operation;
    procedure INcrevalue(S: string); //��ֵ����
    procedure sendData();
    function exchData(orderStr: string): string;


    function Date_Time_Modify(strinputdatetime: string): string;
    function CheckPassword(strtemp_Password: string): boolean;
    //procedure CheckRight(UserNO: string); //��ȡȨ�޿���
    //function MaxRight: string;
    //procedure ClearArr_Wright_3F;
    //procedure EnableMenu; //��ȡȨ�޿���
    function Query_Customer(Customer_No1: string): string;

        //������������ָ��
    procedure sendHANDCMD;
    //���Ͷ�ȡ������������ָ��
    procedure SendCMD_USERPASSWORD;
    //����3F�������루ϵͳ��ţ�ȷ������ָ��
    procedure SendCMD_3FPASSWORD;
    //����д��½����
    procedure SendCMD_3FLOADDATE;
    //���Ͷ���½����
    procedure SendCMD_3FLOADDATE_READ;

    function CheckSUMData_PasswordIC(orderStr: string): string;
    function Check_CustomerNO(str1: string; str2: string): Boolean;
    function Check_CustomerPassword(str1: string; str2: string): Boolean;
    function Check_LOADDATE(str1: string; str2: string): Boolean;
    function Make_Send_CMD_PasswordIC(StrCMD: string; StrIncValue: string): string;
    procedure WriteCustomerNameToIniFile;
    function WriteUseTimeToIniFile: boolean;
    function checkLicense(): boolean; overload;

    procedure loginSuccess();


 //ƴ��ǩ���ӿ�URL
    function generateLoginURL(): string;
    function generateSigeLoginURL(): string;

  //��������ǩ���㷨
    function getLoginSignature(strAppID: string; strCoinlimit: string; strShopID: string; strTimeStamp: string): string;
    function getSigeLoginSignature(appId: string; coinCost: string; coinLimit: string; secretKey: string; shopId: string; timeStamp: string): string;


  end;

var
  Frm_Logon: TFrm_Logon;
  Longon_OK: BOOLEAN; //���ܹ���֤�Ƿ�ͨ��
 // Longon_NG: BOOLEAN;
  curOrderNo: integer = 0;
  curOperNo: integer = 0;
  Operate_No: integer = 0;

  LOAD_SEND_DATA, LOAD_Rec_DATA: string;
  orderLst, recDataLst, recData_fromICLst, recData_fromICLst_Check: Tstrings;


  Check_Count, Check_Count_3FPASSWORD, Check_Count_USERPASSWORD, Check_Count_3FLOADDATE, Check_Count_3FLOADDATE_WRITE: integer;
  LOAD_CHECK_OK_RE, LOAD_3FPASSWORD_OK_RE, LOAD_USERPASSWORD_OK_RE, LOAD_3FLOADDATE_OK_RE, LOAD_3FLOADDATE_WRITE_OK_RE: BOOLEAN;


  Arr_Wright_3F_length: integer;
  strtime: string;
  WriteToFile_OK, WriteToFlase_OK: BOOLEAN;


implementation
uses ICDataModule, ICCommunalVarUnit, ICFunctionUnit, ICmain,
  DateProcess, untApplicationHardWareInfo, StandardDES,untRegister;
//Frontoperate_EBincvalueUnit, ICEventTypeUnit, RegUnit,
{$R *.dfm}

procedure TFrm_Logon.FormActivate(Sender: TObject);
var
  lpRect: TRect;
begin
  edtPassword.SetFocus;
  lpRect.Left := Frm_Logon.Left;
  lpRect.Top := Frm_Logon.Top;
  lpRect.Right := Frm_Logon.Width;
  lpRect.Bottom := Frm_Logon.Height;
  SetCursorRect(lpRect);
end;


procedure TFrm_Logon.SetCursorRect(rect: TRect);
var
  lpRect: TRect;
begin
  lpRect.Left := rect.Left + 25;
  lpRect.Right := lpRect.Left + rect.Right - 38;
  lpRect.Top := rect.Top + 15;
  lpRect.Bottom := lpRect.Top + rect.Bottom - 38;
  ClipCursor(@lpRect);
end;

//ע������֤


function TFrm_Logon.checkLicense(): boolean;
var
  CPUIDInfo: TCPUIDInfo;
  strCPUID: string;
begin
  result := false; //��һ��
  CPUIDInfo := TCPUIDInfo.Create;
  strCPUID := CPUIDInfo.GetCPUIDstr;
  if strCPUID = SGBTCONFIGURE.registerCode then //�Ƚ�����
    result := true //һ��
  else
    frmRegister.ShowModal;
    
    
end;





//����ȷ��

function TFrm_Logon.CheckPassword(strtemp_Password: string): boolean;
var
  strtemp_Input, strtemp1, strtemp2: string;

begin
  strtemp_Input := ICFunction.ChangeAreaStrToHEX(TrimRight(edtPassword.Text));
  strtemp1 := copy(strtemp_Password, 19, 2) + copy(strtemp_Password, 11, 2) + copy(strtemp_Password, 23, 2);
  strtemp2 := copy(strtemp_Password, 7, 2) + copy(strtemp_Password, 15, 2) + copy(strtemp_Password, 3, 2);


  if (strtemp1 + strtemp2) = strtemp_Input then
  begin
    result := true; //һ��
  end
  else
  begin
    result := false; //��һ��
  end;
end;

//��ֵ��ͷComm1����

procedure TFrm_Logon.comReaderReceiveData(Sender: TObject; Buffer: Pointer;
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

  recData_fromICLst.Clear;
  recData_fromICLst.Add(recStr);
  begin
    CheckCMD(); //���ȸ��ݽ��յ������ݽ����жϣ�ȷ�ϴ˿��Ƿ�����Ϊ��ȷ�Ŀ�
  end;
end;

procedure TFrm_Logon.FormShow(Sender: TObject);
begin

  ICFunction.InitSystemWorkPath; //��ʼ���ļ�·��
  ICFunction.InitSystemWorkground; //��ʼ����������
  //����configureExist ��unit ICFunctionUnit;�м�⸳ֵ������ȷ���Ƿ���ϵͳ�����ļ�
  //��֤���̨��֤
  if configureExist and checkLicense() then
  begin
    Longon_OK := false;
    //���ܹ����ڽ����ַ���
    recData_fromICLst_Check := tStringList.Create;
    orderLst := TStringList.Create;

    // add linlf 20170218 ����û�м��ܹ�����µĵ�¼


    try
      comReader.StartComm();
    except on E: Exception do //���������쳣
      begin
        showmessage( SG3FERRORINFO.commerror + e.message);
        exit;
      end;
    end;

    recDataLst := tStringList.Create;
    recData_fromICLst := tStringList.Create;

   //Debug Close    ���ܹ��ϲ�����ֵ��һ����ͬһ������
   //�������ܹ�����ȷ��  Com4
   { try
      Comm_Check.StartComm();
    except on E: Exception do //���������쳣
      begin
        showmessage(SG3FERRORINFO.commerror + e.message);
        exit;
      end;
    end;
    }


    LOAD_CHECK_OK_RE := false;
    Timer_HAND.Enabled := true; //��ʼ�����ܹ����ֶ�ʱ�� 
    edtPassword.SetFocus;

  end
  else
  begin
    Frm_Logon.Caption := '��Ȩ��˼�����ܿƼ����У�';
    //lblMessage.Caption := '�����ļ�����ȷ,�����µ�¼';
    lblMessage.Caption := SG3FERRORINFO.error_register_code;
  end;

end;


procedure TFrm_Logon.BitBtn_ExitClick(Sender: TObject);
begin
  Close;
end;

//���ݽ��յ��������жϴ˿��Ƿ�Ϊ�Ϸ���

procedure TFrm_Logon.CheckCMD();
var
  tmpStr: string;
begin
   //���Ƚ�ȡ���յ���Ϣ
  lblMessage.Caption := '';
  tmpStr := recData_fromICLst.Strings[0];
  LOAD_USER.ID_CheckNum := copy(tmpStr, 39, 4); //У���

  begin

    LOAD_USER.CMD := copy(recData_fromICLst.Strings[0], 1, 2); //֡ͷ43
    LOAD_USER.ID_INIT := copy(recData_fromICLst.Strings[0], 3, 8); //��ƬID
    LOAD_USER.ID_3F := copy(recData_fromICLst.Strings[0], 11, 6); //����ID
    LOAD_USER.Password_3F := copy(recData_fromICLst.Strings[0], 17, 6); //appid
    LOAD_USER.Password_USER := copy(recData_fromICLst.Strings[0], 23, 6); //shopid
    LOAD_USER.ID_value := copy(recData_fromICLst.Strings[0], 29, 8); //��������
    LOAD_USER.ID_type := copy(recData_fromICLst.Strings[0], 37, 2); //������


    if (LOAD_USER.ID_type = copy(INit_Wright.OPERN, 8, 2))  //������ȷ
      //and (DataModule_3F.queryExistInitialRecord(LOAD_USER.ID_INIT)) //��ʼ��
      and (LOAD_USER.Password_USER = SGBTCONFIGURE.shopid) then //��̨����ȷ
    begin
      Longon_OK := TRUE;
      lblMessage.caption := '������֤ͨ��,�������̨�ţ�';
    end
    else
    begin
      Longon_OK := false;
      lblMessage.caption := '��ǰ���Ƿ���';
      exit;
    end;


  end;


end;


//��ʼ������

procedure TFrm_Logon.INIT_Operation;
var
  INC_value: string;
  strValue: string;
begin
  begin
    INC_value := '0'; //��ֵ��ֵ
    strValue := INit_Send_CMD('AB', INC_value); //�����ֵָ��
    INcrevalue(strValue); //д��ID��
  end;
end;


//��ʼ��������ָ��

function TFrm_Logon.INit_Send_CMD(StrCMD: string; StrIncValue: string): string;
var
  TmpStr: string; //�淶������ں�ʱ��
  TmpStr_CheckSum: string; //У���
  TmpStr_SendCMD: string; //ָ������
  reTmpStr: string;
  myIni: TiniFile;
  strinputdatetime: string;

  i: integer;
  Strsent: array[0..21] of string; //���ͷ����Ӧ����
begin
  strinputdatetime := DateTimetostr((now()));
  TmpStr := Date_Time_Modify(strinputdatetime); //�淶���ں�ʱ���ʽ
  Strsent[0] := StrCMD; //֡����

  Strsent[5] := IntToHex(Strtoint(Copy(TmpStr, 1, 2)), 2); //���ǰ2λ
  Strsent[18] := IntToHex(Strtoint(Copy(TmpStr, 3, 2)), 2); //��ݺ�2λ
  Strsent[8] := IntToHex(Strtoint(Copy(TmpStr, 6, 2)), 2); //�·�ǰ2λ
  Strsent[10] := IntToHex(Strtoint(Copy(TmpStr, 9, 2)), 2); //����ǰ2λ
  Strsent[14] := IntToHex(Strtoint(Copy(TmpStr, 12, 2)), 2); //Сʱǰ2λ
  Strsent[6] := IntToHex(Strtoint(Copy(TmpStr, 15, 2)), 2); //����ǰ2λ
  Strsent[1] := IntToHex(Strtoint(Copy(TmpStr, 18, 2)), 2); //��ǰ2λ

  Strsent[2] := IntToHex((Strtoint('$' + Strsent[10]) + Strtoint('$' + Strsent[8])), 2);

  Strsent[3] := IntToHex((Strtoint('$' + Strsent[1]) + Strtoint('$' + Strsent[6])), 2);
  Strsent[7] := IntToHex((Strtoint('$' + Strsent[2]) + Strtoint('$' + Strsent[8])), 2);
  Strsent[16] := IntToHex((Strtoint('$' + Strsent[5]) + Strtoint('$' + Strsent[6])), 2);
  Strsent[13] := IntToHex((Strtoint('$' + Strsent[14]) + Strtoint('$' + Strsent[5])), 2);


  Strsent[4] := IntToHex(((Strtoint('$' + Strsent[7]) * Strtoint('$' + Strsent[16])) div 256), 2);
  Strsent[9] := IntToHex(((Strtoint('$' + Strsent[7]) * Strtoint('$' + Strsent[16])) mod 256), 2);
  Strsent[11] := IntToHex(((Strtoint('$' + Strsent[3]) * Strtoint('$' + Strsent[13])) mod 256), 2);
  Strsent[15] := IntToHex(((Strtoint('$' + Strsent[3]) * Strtoint('$' + Strsent[13])) div 256), 2);


  Strsent[17] := IntToHex((Strtoint('$' + Strsent[6]) + Strtoint('$' + Strsent[1])), 2);
  Strsent[12] := IntToHex((Strtoint('$' + Strsent[14]) + Strtoint('$' + Strsent[8])), 2);

  //����ȡ���ĵ��еĳ�������
  if FileExists(SystemWorkGroundFile) then
  begin
    myIni := TIniFile.Create(SystemWorkGroundFile);
    INit_Wright.BossPassword := MyIni.ReadString('PLC��������', 'PC����������', 'D6077');
    FreeAndNil(myIni);
  end;

    //���������ݽ���У�˼���
  for i := 0 to 18 do
  begin
    TmpStr_SendCMD := TmpStr_SendCMD + Strsent[i];
  end;
  TmpStr_CheckSum := ICFunction.checkSUMData(TmpStr_SendCMD); //���У���
  reTmpStr := TmpStr_SendCMD + ICFunction.transferCheckSumByte(TmpStr_CheckSum); //��ȡ���з��͸�IC������
  result := reTmpStr;
end;
//У��ͣ�ȷ���Ƿ���ȷ




procedure TFrm_Logon.INcrevalue(S: string);
begin
  orderLst.Clear();
  curOrderNo := 0;
  curOperNo := 2;
  orderLst.Add(S); //����ֵд�����
  sendData();
end;
//�������ݹ���

procedure TFrm_Logon.sendData();
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

function TFrm_Logon.exchData(orderStr: string): string;
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




//��ʱ��ɨ��ͳ�ƽ������ϸ��¼

function TFrm_Logon.Date_Time_Modify(strinputdatetime: string): string;
var
  strEnd: string;
  Strtemp: string;
begin

  Strtemp := Copy(strinputdatetime, length(strinputdatetime) - 8, 9);
  strinputdatetime := Copy(strinputdatetime, 1, length(strinputdatetime) - 9);
  if Copy(strinputdatetime, 7, 1) = '-' then //�·�С��10
  begin
    if length(strinputdatetime) = 8 then //�·�С��10,������С��10
    begin
      strEnd := Copy(strinputdatetime, 1, 5) + '0' + Copy(strinputdatetime, 6, 2) + '0' + Copy(strinputdatetime, 8, 1);
    end
    else
    begin
      strEnd := Copy(strinputdatetime, 1, 5) + '0' + Copy(strinputdatetime, 6, length(strinputdatetime) - 5);
    end;
  end
  else
  begin //�·ݴ���9
    if length(strinputdatetime) = 9 then //�·ݴ���9,������С��10
    begin
      strEnd := Copy(strinputdatetime, 1, 8) + '0' + Copy(strinputdatetime, 9, 1);
    end
    else
    begin
      strEnd := strinputdatetime;
    end;
  end;
  result := strEnd + Strtemp;
end;

procedure TFrm_Logon.BitBtn1Click(Sender: TObject);
begin
  strtime := FormatDateTime('HH:mm:ss', now);
  Timer_3FLOADDATE_WRITE.Enabled := true;
end;

procedure TFrm_Logon.Timer1Timer(Sender: TObject);
begin
  LOAD_CHECK_Time_Over := true; //��ʱ���ռ��ܹ��ķ�����Ϣ
  Timer2.Enabled := true; //������ʱ��2
  Timer1.Enabled := FALSE; //�رն�ʱ��1
end;

procedure TFrm_Logon.Timer2Timer(Sender: TObject);
begin

 // if not LOAD_CHECK_OK then //����ϵͳʱ����3����û�н��յ����ܹ��ķ�������ϵͳ�����ɱ
 // begin
  //  BitBtn_OK.Enabled := false;
  //end;
  LOAD_CHECK_Time_Over := false; //
  Timer2.Enabled := FALSE; //�رն�ʱ��2
end;

//----------------------------------------����Ϊ���ܹ���� ��ʼ---------


//���ܿ�������

procedure TFrm_Logon.Comm_CheckReceiveData(Sender: TObject;
  Buffer: Pointer; BufferLength: Word);
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
  checkEncodeDogCMD(); //ϵͳ����ʱ�жϼ��ܹ�

end;

//���ݽ��յ��ļ��ܹ������жϴ˿��Ƿ�Ϊ�Ϸ��� ,������߼���ʲô���е���

procedure TFrm_Logon.checkEncodeDogCMD();
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


  if (content1 = '43') then //֡ͷ43
  begin
    if (content2 = CMD_COUMUNICATION.CMD_HAND) then //�յ�������������Ϣ0x61
    begin
      for i := 1 to length(tmpStr) do
      begin
        if copy(tmpStr, i, 2) = '03' then
        begin
          content3 := copy(tmpStr, i - 2, 2); //ָ��У���
          content5 := copy(tmpStr, 1, i - 3) + '63' + copy(tmpStr, i, 2);
          if (CheckSUMData_PasswordIC(content5) = content3) then
          begin
            LOAD_CHECK_OK_RE := true; //���ֳɹ�
            Timer_HAND.Enabled := FALSE; //�رռ�ⶨʱ��
            Timer_USERPASSWORD.Enabled := true; //�����������붨ʱ�����
            tmpStr := '';
            break;
          end; //if
        end; //if
      end; //for
    end //if CMD_COUMUNICATION.CMD_HAND

     // tmpStr=43 64 01 30 30 30 30 30 33 46 32 30 31 33 30 30 30 30 30 33 03
    else if (content2 = CMD_COUMUNICATION.CMD_USERPASSWORD) then //�յ�ϵͳ������鷴����Ϣ 0x64
    begin
      if Check_CustomerNO(tmpStr, INit_Wright.CustomerNO) then //�Ƚ�ϵͳ����Ƿ�һ��"3F2013000001"
      begin
        LOAD_3FPASSWORD_OK_RE := false;
        LOAD_USERPASSWORD_OK_RE := true;
        Timer_3FPASSWORD.Enabled := true; //���Ͷ�ȡ3F�������루ϵͳ��ţ�ȷ������ָ��
      end;
    end
    else if (content2 = CMD_COUMUNICATION.CMD_3FPASSWORD) then // ��������0x62
    begin
      if Check_CustomerPassword(tmpStr, INit_Wright.BossPassword) then //�Ƚϳ�������
      begin
        LOAD_3FPASSWORD_OK_RE := true;
        Timer_3FPASSWORD.Enabled := false;
        Timer_3FLOADDATE.Enabled := true;
      end;
    end
    else if (content2 = CMD_COUMUNICATION.CMD_3FLODADATE) then // ���һ�ε�½����ʱ��0x65
    begin
      if Check_LOADDATE(tmpStr, INit_3F.ID_Settime) then //�Ƚϵ�½����ʱ��
      begin
        LOAD_3FLOADDATE_OK_RE := true;
        Timer_3FLOADDATE.Enabled := false;
        lblMessage.Caption := 'ϵͳ��ʼ����ϣ���ˢ��½����Ȼ�������½����        ';
        //comReader.StartComm(); //
        try
          comReader.StartComm;
        except on E: Exception do //���������쳣
          begin
            showmessage(SG3FERRORINFO.commerror + e.message);
            exit;
          end;
        end;

        recDataLst := tStringList.Create;
        recData_fromICLst := tStringList.Create;
     //   BitBtn_OK.Enabled := true;
      end;

    end

//--------------------------�����Ǵ���д��½���ڵķ�����Ϣ�����¼�--------------
    else if (content2 = CMD_COUMUNICATION.CMD_WRITETOFLASH_Sub_RE) then // //д�������������ĵڶ��ֽ�Ϊ7A
    begin
      for i := 1 to length(tmpStr) do
      begin
        if (copy(tmpStr, i, 2) = '03') and (i mod 2 = 1) then
        begin
          content6 := copy(tmpStr, 5, 2);
          content3 := copy(tmpStr, i - 2, 2); //ָ��У���
          if (content6 = CMD_COUMUNICATION.CMD_3FLODADATE_RE) then //0x69
          begin
            content5 := copy(tmpStr, 1, i - 3) + '63' + copy(tmpStr, i, 2);
            if (CheckSUMData_PasswordIC(content5) = content3) then
            begin
              LOAD_3FLOADDATE_WRITE_OK_RE := true;
              WriteToFlase_OK := true;
              lblMessage.Caption := 'д���½ʱ������ɹ�';


              if WriteToFlase_OK then
              begin
                lblMessage.Caption := '���¼��ܿ��е����ݲ����ɹ�';
                //CheckRight(G_User.UserNO); //��ȡȨ�޿���
                orderLst.Free();
                recDataLst.Free();
                recData_fromICLst.Free();
                recData_fromICLst_Check.Free();
                comReader.StopComm();
                Comm_Check.StopComm();
                Longon_OK := false;
                Frm_Logon.Hide;
                Frm_IC_Main.show; //����������
                Login := True;
              end
              else
              begin
                lblMessage.Caption := '���ü��ܿ����ݳ�������ϵ����';
                WriteToFile_OK := false;
                WriteToFlase_OK := false;
                exit;
              end;
            end
            else
            begin
              lblMessage.Caption := '��ܰ��ʾ����ʼ��ʧ�ܣ�����ϵ����֧�֣�����������ϵͳ                  '

            end;
            tmpStr := '';
            break;
          end;

        end;
      end; //------for ����
    end;

  end;


end;


//���������ļ���д������ͻ���š���������������ļ�

procedure TFrm_Logon.WriteCustomerNameToIniFile;
var
  myIni: TiniFile;

  LOADDATE: string; //�û���������
begin

   //�жϼ���õ��������Ƿ���ԭ��������һ��
  LOADDATE := COPY(strtime, 1, 1) + COPY(strtime, 5, 1) + COPY(strtime, 2, 1) + COPY(strtime, 4, 1); //�趨ʱ��
  if FileExists(SystemWorkGroundFile) then
  begin
    myIni := TIniFile.Create(SystemWorkGroundFile);

    myIni.WriteString('����������', '�趨ʱ��', LOADDATE); //д��������
    INit_3F.ID_Settime := MyIni.ReadString('����������', '�趨ʱ��', '2721'); //
    FreeAndNil(myIni);

    if LOADDATE = INit_3F.ID_Settime then
    begin
      WriteToFile_OK := true;
      lblMessage.Caption := '�����ĵ��еĵ�½�������óɹ�';
    end;

  end;

end;
//���ݶ�ȡ������ֵ��ˮ����ѯ���ݿ����Ƿ��Ѿ�����ͬ��¼�����������ʾ

function TFrm_Logon.Query_Customer(Customer_No1: string): string;
var
  ADOQTemp: TADOQuery;
  strSQL: string;
  reTmpStr: string;
  Str1: string;
begin
  Str1 := copy(Customer_No1, 1, length(Customer_No1) - 1);
  ADOQTemp := TADOQuery.Create(nil);
  strSQL := 'select [Customer_NO]  FROM [t_customer_info] where [Customer_NO]=''' + Str1 + '''';

  with ADOQTemp do
  begin
    Connection := DataModule_3F.ADOConnection_Main;
    SQL.Clear;
    SQL.Add(strSQL);
    Active := True;
    if (RecordCount > 0) then
    begin
      reTmpStr := ADOQTemp.Fields[0].AsString;
    end;
  end;
  FreeAndNil(ADOQTemp);
  RESULT := reTmpStr + '@';

end;

 //ÿ��100ms����һ������ָ��

procedure TFrm_Logon.Timer_HANDTimer(Sender: TObject);
begin
  Check_Count := Check_Count + 1;
  if not LOAD_CHECK_OK_RE then //����δ�ɹ�
  begin
    sendHANDCMD; //��������ָ��
    if Check_Count = 4 then //��ʱ4��,�����Բ��ɹ�
    begin
     // BitBtn_OK.Enabled := false; //��ֹ��½����
      LOAD_CHECK_OK_RE := false;
      Timer_HAND.Enabled := FALSE; //�رն�ʱ��
    end;
  end
  else
  begin
    Timer_HAND.Enabled := FALSE; //�رն�ʱ��
  end;

end;

//������������ָ��

procedure TFrm_Logon.sendHANDCMD;
var
  INC_value: string;
  strValue: string;
begin
  begin
    INC_value := '0'; //��ֵ��ֵ
    strValue := '50613C6D03'; //��������ָ��50  61  3C  6D  03
    INcrevalue(strValue); //д��ID��
  end;
end;




 //��ʱ����3F����

procedure TFrm_Logon.Timer_3FPASSWORDTimer(Sender: TObject);
begin
  Check_Count_3FPASSWORD := Check_Count_3FPASSWORD + 1;
  if not LOAD_3FPASSWORD_OK_RE then //����δ�ɹ�
  begin
    SendCMD_3FPASSWORD; //��������ָ��
    if Check_Count_3FPASSWORD = 4 then //��ʱ��
    begin
     // BitBtn_OK.Enabled := false; //��ֹ��½����
      LOAD_3FPASSWORD_OK_RE := false;
      Timer_3FPASSWORD.Enabled := FALSE; //�رն�ʱ��
    end;
  end
  else
  begin
    Timer_3FPASSWORD.Enabled := FALSE; //�رն�ʱ��
  end;

end;

//���Ͷ�ȡ3F��������ָ��

procedure TFrm_Logon.SendCMD_3FPASSWORD;
var
  strValue: string;
begin
  begin
    strValue := '50625203'; //��������������ָ��50  62  52  03   ��X66ָ���Ӧ
    INcrevalue(strValue); //���͸����ܿ�
  end;
end;



//���󳡵�����

procedure TFrm_Logon.Timer_USERPASSWORDTimer(Sender: TObject);
begin
  Check_Count_USERPASSWORD := Check_Count_USERPASSWORD + 1;
  if not LOAD_USERPASSWORD_OK_RE then //����δ�ɹ�
  begin
    SendCMD_USERPASSWORD; //���Ͷ�ȡ������������ָ��
    if Check_Count_USERPASSWORD = 4 then //��ʱ��
    begin
      LOAD_USERPASSWORD_OK_RE := false;
      Timer_USERPASSWORD.Enabled := FALSE; //�رն�ʱ��
    end;
  end
  else
  begin
    Timer_USERPASSWORD.Enabled := FALSE; //�رն�ʱ��
  end;
end;

//���Ͷ�ȡ3F��ϵͳ��ţ�����ָ��

procedure TFrm_Logon.SendCMD_USERPASSWORD;
var
  strValue: string;
begin
  begin
    strValue := '5064015503'; //��ϵͳ��������ָ��       //��x68ָ���Ӧ
    INcrevalue(strValue); //���͸����ܿ�
  end;
end;

//�����¼����

procedure TFrm_Logon.Timer_3FLOADDATETimer(Sender: TObject);
begin
  Check_Count_3FLOADDATE := Check_Count_3FLOADDATE + 1;

  if not LOAD_3FLOADDATE_OK_RE then //����δ�ɹ�
  begin
    SendCMD_3FLOADDATE_READ; //���Ͷ�ȡ������������ָ��
    if Check_Count_3FLOADDATE = 4 then //��ʱ��
    begin
      LOAD_3FLOADDATE_OK_RE := false;
      Timer_3FLOADDATE.Enabled := FALSE; //�رն�ʱ��
    end;
  end
  else
  begin
           //BitBtn_OK.Enabled:=true;//��ɵ�½����
    Timer_3FLOADDATE.Enabled := FALSE; //�رն�ʱ��
  end;
end;

//����//����½����

procedure TFrm_Logon.SendCMD_3FLOADDATE_READ;
var
  strValue: string;
begin
  begin
    strValue := '50655503'; //��ϵͳ��½����ʱ������ָ��       //��x69ָ���Ӧ
    INcrevalue(strValue); //���͸����ܿ�
  end;
end;




 //д��ʱ��

procedure TFrm_Logon.Timer_3FLOADDATE_WRITETimer(
  Sender: TObject);
begin
  Check_Count_3FLOADDATE_WRITE := Check_Count_3FLOADDATE_WRITE + 1;
  if not LOAD_3FLOADDATE_WRITE_OK_RE then //����δ�ɹ�
  begin
    SendCMD_3FLOADDATE; //���͸��µ�½����
    if Check_Count_3FLOADDATE_WRITE = 4 then //��ʱ��
    begin
      LOAD_3FLOADDATE_WRITE_OK_RE := false;
      Timer_3FLOADDATE_WRITE.Enabled := FALSE; //�رն�ʱ��
      Check_Count_3FLOADDATE_WRITE := 0;
    end;
  end
  else
  begin
    Timer_3FLOADDATE_WRITE.Enabled := FALSE; //�رն�ʱ��
    Check_Count_3FLOADDATE_WRITE := 0;
  end;

end;


//����//д���½����

procedure TFrm_Logon.SendCMD_3FLOADDATE;
var
  strValue, INC_value: string;
begin
  strtime := FormatDateTime('HH:mm:ss', now);
  INC_value := COPY(strtime, 1, 1) + COPY(strtime, 5, 1) + COPY(strtime, 2, 1) + COPY(strtime, 4, 1) + COPY(strtime, 7, 1);
  //INit_3F.ID_Settime,4���ֽڣ�Сʱ+���ӣ�д���һ�ε�½ϵͳʱ��50 69 00 00 00 00 59 03
  Operate_No := 1;
  strValue := Make_Send_CMD_PasswordIC('5069', INC_value); //�����ֵָ��
  INcrevalue(strValue);

end;



//�����ֵָ��

function TFrm_Logon.Make_Send_CMD_PasswordIC(StrCMD: string; StrIncValue: string): string;
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
    //Edit1.Text:= StrIncValue;
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

function TFrm_Logon.CheckSUMData_PasswordIC(orderStr: string): string;
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
//���ݽ��յ��������ж���Ӧ���
//  str1 Ϊ�Ӵ��ڶ�ȡ��ֵ ��
//43 64 01 30 30 30 30 30 33 46 32 30 31 33 30 30 30 30 30 33 03
//43 64 01 30 30 30 30 33 46 32 30 31 33 30 30 30 30 30 31 32 03

//  str2�ĵ���ȡ��ֵ��3F2013000001

function TFrm_Logon.Check_CustomerNO(str1: string; str2: string): Boolean;
var
  strtemp: string;
begin
  strtemp := ICFunction.ChangeAreaHEXToStr(Copy(str1, 15, 24));
  if (strtemp = str2) then
  begin
    result := true;

  end
  else
  begin
    result := false;
  end
end;
 //���ݽ��յ��������ж���Ӧ���
 //  str1 Ϊ�Ӵ��ڶ�ȡ��ֵ ��
 //43 62 31 46 45 33 34 41 46 42 44 33 46 30 30 30 30 30 31 55 54 03
 // str2�ĵ���ȡ��ֵ����������000 001

function TFrm_Logon.Check_CustomerPassword(str1: string; str2: string): Boolean;
var
  strtemp: string;
begin
  strtemp := ICFunction.ChangeAreaHEXToStr(Copy(str1, 27, 12));

  if (strtemp = str2) then
  begin
    result := true;
  end
  else
  begin
    result := false;
  end
end;

  //���ݽ��յ��������ж���Ӧ���
 //  str1 Ϊ�Ӵ��ڶ�ȡ��ֵ ��
 //43  65  32  37  32  31  40  03
 // str2�ĵ���ȡ��ֵ����������2721

function TFrm_Logon.Check_LOADDATE(str1: string; str2: string): Boolean;
var
  strtemp: string;
begin
  strtemp := ICFunction.ChangeAreaHEXToStr(Copy(str1, 5, 8));

  if (strtemp = str2) then
  begin
    result := true;
  end
  else
  begin
    result := false;
  end
end;


//���������ļ���д��ʹ��ϵͳ�����������ļ�

function TFrm_Logon.WriteUseTimeToIniFile: boolean;
var
  myIni: TiniFile;
  UseTimes: string; //ϵͳʹ�ô���
begin
  Result := false;
  if (SystemWorkground.PCReCallClearTP = 'D6102') then //δע�ᣬΪԭ�ĵ�
  begin
       //��һ��ʹ��
    if (SystemWorkground.PLCRequestWriteTP = 'D6004') or (length(SystemWorkground.PLCRequestWriteTP) = 0) then
    begin
      SystemWorkground.PLCRequestWriteTP := '1';
      UseTimes := SystemWorkground.PLCRequestWriteTP;
      if FileExists(SystemWorkGroundFile) then
      begin
        myIni := TIniFile.Create(SystemWorkGroundFile);
        myIni.WriteString('PLC��������', 'PLC����д����', UseTimes); //д���µĵ�½����
        SystemWorkground.PLCRequestWriteTP := MyIni.ReadString('PLC��������', 'PLC����д����', ''); //

        FreeAndNil(myIni);
        if SystemWorkground.PLCRequestWriteTP = UseTimes then
        begin
          Result := true;
        end
        else
        begin
          Result := false;
        end;
      end;
    end
    else //���ǵ�һ��ʹ��
    begin

      UseTimes := IntToStr(StrToInt(SystemWorkground.PLCRequestWriteTP) + 1);
             //������ô���Ϊ50��
      if StrToInt(SystemWorkground.PLCRequestWriteTP) > 50 then
      begin
        Result := false;
      end
      else
      begin
        SystemWorkground.PLCRequestWriteTP := UseTimes;
        if FileExists(SystemWorkGroundFile) then
        begin
          myIni := TIniFile.Create(SystemWorkGroundFile);
          myIni.WriteString('PLC��������', 'PLC����д����', SystemWorkground.PLCRequestWriteTP); //д���µĵ�½����
          UseTimes := MyIni.ReadString('PLC��������', 'PLC����д����', ''); //

          FreeAndNil(myIni);
          if SystemWorkground.PLCRequestWriteTP = UseTimes then
          begin
            Result := true;
          end
          else
          begin
            Result := false;
          end;
        end;
      end; //�ж��Ƿ�ʹ�ô���<50 ����
    end; //�ж��Ƿ��һ��ʹ�ý���
  end
  else // ע���жϵ����ݱ��޸ģ�������ע�ᡢ�������ļ�����Ϊ�޸ģ�
  begin //SystemWorkground.PCReCallClearTP<>'D6102'
    if (StrToInt(Copy(TrimRight(SystemWorkground.PCReCallClearTP), 1, 1)) = 2 * StrToInt(Copy(TrimRight(SystemWorkground.PCReCallClearTP), 4, 1))) and (StrToInt(Copy(TrimRight(SystemWorkground.PCReCallClearTP), 2, 1)) = 3 * StrToInt(Copy(TrimRight(SystemWorkground.PCReCallClearTP), 6, 1))) then
    begin //��ע��
      if (Copy(INit_Wright.CustomerNO, 12, 1) = Copy(TrimRight(SystemWorkground.PCReCallClearTP), 7, 1)) and (Copy(INit_Wright.CustomerNO, 11, 1) = Copy(TrimRight(SystemWorkground.PCReCallClearTP), 11, 1)) then
      begin
        if (Copy(INit_Wright.CustomerNO, 6, 1) = Copy(TrimRight(SystemWorkground.PCReCallClearTP), 3, 1)) and (Copy(INit_Wright.CustomerNO, 2, 1) = Copy(TrimRight(SystemWorkground.PCReCallClearTP), 5, 1)) then
        begin
          if (Copy(INit_Wright.CustomerNO, 10, 1) = Copy(TrimRight(SystemWorkground.PCReCallClearTP), 8, 1)) then
          begin
            if (Copy(INit_Wright.CustomerNO, 12, 1) = '1') and (Copy(TrimRight(SystemWorkground.PCReCallClearTP), 9, 1) = 'A') and (Copy(INit_Wright.CustomerNO, 11, 1) = '1') and (Copy(TrimRight(SystemWorkground.PCReCallClearTP), 12, 1) = 'A') then
            begin
              Result := TRUE;
            end
            else if (Copy(INit_Wright.CustomerNO, 12, 1) = '2') and (Copy(TrimRight(SystemWorkground.PCReCallClearTP), 9, 1) = 'Z') and (Copy(INit_Wright.CustomerNO, 11, 1) = '2') and (Copy(TrimRight(SystemWorkground.PCReCallClearTP), 12, 1) = 'J') then
            begin
              Result := TRUE;
            end
            else if (Copy(INit_Wright.CustomerNO, 12, 1) = '3') and (Copy(TrimRight(SystemWorkground.PCReCallClearTP), 9, 1) = 'K') and (Copy(INit_Wright.CustomerNO, 11, 1) = '3') and (Copy(TrimRight(SystemWorkground.PCReCallClearTP), 12, 1) = 'B') then
            begin
              Result := TRUE;
            end
            else if (Copy(INit_Wright.CustomerNO, 12, 1) = '4') and (Copy(TrimRight(SystemWorkground.PCReCallClearTP), 9, 1) = 'F') and (Copy(INit_Wright.CustomerNO, 11, 1) = '4') and (Copy(TrimRight(SystemWorkground.PCReCallClearTP), 12, 1) = 'N') then
            begin
              Result := TRUE;
            end
            else if (Copy(INit_Wright.CustomerNO, 12, 1) = '5') and (Copy(TrimRight(SystemWorkground.PCReCallClearTP), 9, 1) = 'H') and (Copy(INit_Wright.CustomerNO, 11, 1) = '5') and (Copy(TrimRight(SystemWorkground.PCReCallClearTP), 12, 1) = 'D') then
            begin
              Result := TRUE;
            end
            else if (Copy(INit_Wright.CustomerNO, 12, 1) = '6') and (Copy(TrimRight(SystemWorkground.PCReCallClearTP), 9, 1) = 'M') and (Copy(INit_Wright.CustomerNO, 11, 1) = '6') and (Copy(TrimRight(SystemWorkground.PCReCallClearTP), 12, 1) = 'S') then
            begin
              Result := TRUE;
            end
            else if (Copy(INit_Wright.CustomerNO, 12, 1) = '7') and (Copy(TrimRight(SystemWorkground.PCReCallClearTP), 9, 1) = 'Y') and (Copy(INit_Wright.CustomerNO, 11, 1) = '7') and (Copy(TrimRight(SystemWorkground.PCReCallClearTP), 12, 1) = 'P') then
            begin
              Result := TRUE;
            end
            else if (Copy(INit_Wright.CustomerNO, 12, 1) = '8') and (Copy(TrimRight(SystemWorkground.PCReCallClearTP), 9, 1) = 'X') and (Copy(INit_Wright.CustomerNO, 11, 1) = '8') and (Copy(TrimRight(SystemWorkground.PCReCallClearTP), 12, 1) = 'X') then
            begin
              Result := TRUE;
            end
            else if (Copy(INit_Wright.CustomerNO, 12, 1) = '9') and (Copy(TrimRight(SystemWorkground.PCReCallClearTP), 9, 1) = 'Q') and (Copy(INit_Wright.CustomerNO, 11, 1) = '9') and (Copy(TrimRight(SystemWorkground.PCReCallClearTP), 12, 1) = 'T') then
            begin
              Result := TRUE; ;
            end
            else if (Copy(INit_Wright.CustomerNO, 12, 1) = '0') and (Copy(TrimRight(SystemWorkground.PCReCallClearTP), 9, 1) = 'G') and (Copy(INit_Wright.CustomerNO, 11, 1) = '0') and (Copy(TrimRight(SystemWorkground.PCReCallClearTP), 12, 1) = 'U') then
            begin
              Result := TRUE;
            end
            else
            begin
              Result := false;
            end;
          end
          else
          begin
            Result := false;
          end;
        end
        else
        begin
          Result := false;
        end;
      end
      else
      begin
        Result := false;
      end;
      Result := true;
    end
    else
    begin //�����ļ�����Ϊ�޸�
      Result := false;
    end;

  end;


end;


//�����¼ȷ��

procedure TFrm_Logon.edtPasswordKeyPress(Sender: TObject; var Key: Char);
var
  High_right_Pass: string;
begin
{
  if key = #13 then
  begin

  // if not WriteUseTimeToIniFile then //���Ϊ�����������ʾ����Ҫע��
  //   exit;
    High_right_Pass := 'sg3F@2011';

    //��������Ա ��У����ܹ�Ҳ��У�����
    // comReader.StopComm();
    // Comm_Check.StopComm();
    if edtPassword.Text = High_right_Pass then
    begin
      rootEnable := true; //�������Ȩ��
      LOAD_USER.ID_type := 'AA'; //������
      G_User.UserNO := '3F';
      G_User.UserName := '3F';
      G_User.UserPassword := '3F';
      G_User.UserOpration := '3F';
      orderLst.Free();
      recDataLst.Free();
      recData_fromICLst.Free();
      recData_fromICLst_Check.Free();
      comReader.StopComm();
      Comm_Check.StopComm();
      Longon_OK := false;
      Frm_Logon.Hide;

      Frm_IC_Main.show; //����������
      Login := True;

    end
    else
    begin
      loginCheck(); //���ǳ�������Ա
    end;
  end;
 }
end;
 //----------------------------------------����Ϊ���ܹ���� ����---------



procedure TFrm_Logon.checkLogin();
var
  ADOQ: TADOQuery;
  strUser_ID: string;
  strSQL, strResultCode, strURL, strResponseStr: string;
  jsonApplyResult, jsonSigeLoginResult: TlkJSONbase;
  ResponseStream: TStringStream; //������Ϣ
  activeIdHTTP: TIdHTTP;
begin
  begin
       //���ܿ���֤�Ƿ�ͨ��
    if not Longon_OK then
    begin
      MessageBox(handle, '��ˢ���ĵ�½��!', '����', MB_ICONERROR + MB_OK);
      exit;
    end;
    //��̨����֤
    if (edtPassword.Text <> load_user.Password_USER) or (edtPassword.Text <> SGBTCONFIGURE.shopid) then
    begin
      MessageBox(handle, '��������ȷ�İ�̨��', '����', MB_ICONERROR + MB_OK);
      exit;
    end;


   //{�ر�HK�ӿ�
    if SGBTCONFIGURE.enableInterface = '0' then
    begin
      {
      //�Ǽ�SG3F��Ӫ����ϵͳ
      jsonSigeLoginResult := TlkJSONbase.Create();
      strURL := generateSigeLoginURL();
      ICFunction.loginfo('SG3F Login Request URL: ' + strURL);
      activeIdHTTP := TIdHTTP.Create(nil);
      activeIdHTTP.ReadTimeout :=2000;
//      activeIdHTTP.ConnectTimeout :=2000;
      ResponseStream := TStringStream.Create('');
      try
        activeIdHTTP.HandleRedirects := true;
        activeIdHTTP.Get(strURL, ResponseStream);
        Application.ProcessMessages;
      except
        on e: Exception do
        begin
          showmessage(SG3FERRORINFO.networkerror + e.message);
         // exit;
        end;
      end;
    //��ȡ��ҳ���ص���Ϣ   ��ҳ�еĴ�������ʱ����Ҫ����UTF8����
      strResponseStr := UTF8Decode(ResponseStream.DataString);
      ICFunction.loginfo('SG3F Login Response :' + strResponseStr);
    }


            //�ÿ��¼��֤
      jsonApplyResult := TlkJSONbase.Create();
      strURL := generateLoginURL();
      ICFunction.loginfo('Login Request URL: ' + strURL);
      activeIdHTTP := TIdHTTP.Create(nil);
      ResponseStream := TStringStream.Create('');
      try
        activeIdHTTP.HandleRedirects := true;
        activeIdHTTP.Get(strURL, ResponseStream);
        Application.ProcessMessages;
      except
        on e: Exception do
        begin
          showmessage(SG3FERRORINFO.networkerror + e.message);
          exit;
        end;
      end;
    //��ȡ��ҳ���ص���Ϣ   ��ҳ�еĴ�������ʱ����Ҫ����UTF8����
      strResponseStr := UTF8Decode(ResponseStream.DataString);

      ICFunction.loginfo('Login Response :' + strResponseStr);
      jsonApplyResult := TlkJSON.ParseText(UTF8Encode(strResponseStr)) as TlkJSONobject; //UTF8����
      if jsonApplyResult = nil then
      begin
        Showmessage(SG3FERRORINFO.commerror);
        exit;
      end;
      if vartostr(jsonApplyResult.Field['code'].Value) <> '0' then
      begin
        Showmessage('error:' + vartostr(jsonApplyResult.Field['code'].Value) + ',' + vartostr(jsonApplyResult.Field['message'].Value) + '');
        exit;
      end;

    end;
//}

    lblMessage.Caption := '��¼�ɹ�';
   // jsonResult.Free; //����free����Ҫ���ڴ�Ĺ�����
    loginSuccess();
    Frm_IC_Main.show; //����������

  end;
end;



 //ƴ��ǩ���ӿ�URL

function TFrm_Logon.generateLoginURL(): string;
var
  strURL, strAppID, strCoinLimit, strShopID, strTimeStamp, strSignature, strSignURL, strhkscURL: string;
begin
  strAppID := SGBTCONFIGURE.appid;
  strCoinLimit := SGBTCONFIGURE.coinlimit;
  strShopID := SGBTCONFIGURE.shopid;
  strTimeStamp := getTimestamp();
  strSignature := getLoginSignature(strAppID, strCoinLimit, strShopID, strTimeStamp);
  strSignURL := SGBTCONFIGURE.signurl;
  strhkscURL := SGBTCONFIGURE.hkscurl;

  strURL := strhkscURL + strSignURL + '?shopId=' + strShopID
    + '&appId=' + strAppID + '&coinLimit=' + strCoinLimit + '&timestamp=' + strTimeStamp
    + '&sign=' + strSignature;
  result := strURL;
end;



//��������ǩ���㷨

function TFrm_Logon.getLoginSignature(strAppID: string; strCoinlimit: string; strShopID: string; strTimeStamp: string): string;
var
  strTempC, strTempD: string;
  myMD5: TIdHashMessageDigest5;
begin
  myMD5 := TIdHashMessageDigest5.Create;
  strTempC := 'appId' + strAppID + 'coinLimit' + strCoinlimit + 'shopId' + strShopID + 'timestamp' + strTimeStamp; //���ַ�˳������
  strTempD := strTempC + SGBTCONFIGURE.secret_key; //����secret_key
  result := LowerCase(myMD5.AsHex(myMD5.HashValue(strTempD))); //�����ַ�����MD5,������Сд
  myMD5.Free;

end;


//Sige��̨�Ǽǽӿ�

function TFrm_Logon.generateSigeLoginURL(): string;
var
  strURL, appId, coinCost, coinLimit, secretKey, shopId, timeStamp, strSignature, sg3floginurl, sg3furl: string;
begin
  appId := SGBTCONFIGURE.appid;
  coinCost := '1';
  coinLimit := SGBTCONFIGURE.coinlimit;
  secretKey := SGBTCONFIGURE.secret_key;
  shopId := SGBTCONFIGURE.shopid;
  timeStamp := getTimestamp();
  strSignature := getSigeLoginSignature(appId, coinCost, coinLimit, secretKey, shopId, timeStamp);
  sg3floginurl := SG3FCONFIGURE.sg3floginurl;
  sg3furl := SG3FCONFIGURE.sg3furl;

  strURL := sg3furl + sg3floginurl + '?appId=' + appId
    + '&coinCost=' + coinCost + '&coinLimit=' + coinLimit + '&secretKey=' + secretKey + '&shopId=' + shopId + '&timeStamp=' + timeStamp
    + '&sign=' + strSignature;
  result := strURL;
end;

 //Sige��̨�Ǽǽӿ�ǩ���㷨

function TFrm_Logon.getSigeLoginSignature(appId: string; coinCost: string; coinLimit: string; secretKey: string; shopId: string; timeStamp: string): string;
var
  strTempC, strTempD: string;
  myMD5: TIdHashMessageDigest5;
begin
  myMD5 := TIdHashMessageDigest5.Create;
  strTempC := 'appId' + appId + 'coinCost' + coinCost + 'coinLimit' + coinLimit + 'secretKey' + secretKey + 'shopId' + shopId + 'timeStamp' + timestamp; //���ַ�˳������
  strTempD := strTempC + SG3FCONFIGURE.sg3fkey; //����secret_key
  result := LowerCase(myMD5.AsHex(myMD5.HashValue(strTempD))); //�����ַ�����MD5,������Сд
  myMD5.Free;

end;




procedure TFrm_Logon.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  orderLst.Free();
  recDataLst.Free();
  recData_fromICLst.Free();

  recData_fromICLst_Check.Free();
  comReader.StopComm();
 // Comm_Check.StopComm();
  Application.Terminate;
end;

procedure TFrm_Logon.BitBtn_OKClick(Sender: TObject);
begin
  checkLogin();
end;

{
procedure TFrm_Logon.Image1Click(Sender: TObject);
begin
  Close;
end;

procedure TFrm_Logon.Image3Click(Sender: TObject);
begin
  Load_Check;
end;
}

procedure TFrm_Logon.Panel1DblClick(Sender: TObject);
begin
  close;
end;

procedure TFrm_Logon.Label5Click(Sender: TObject);
begin
  Frm_Logon.Hide;
  //frm_Reg.Show;
end;

procedure TFrm_Logon.loginSuccess();
begin
  orderLst.Free();
  recDataLst.Free();
  recData_fromICLst.Free();
  recData_fromICLst_Check.Free();
  loginIdHTTP.Free;
  comReader.StopComm();
 // Comm_Check.StopComm();
  Longon_OK := false;
  Frm_Logon.Hide;
  Login := True;



end;



procedure TFrm_Logon.btnLoginClick(Sender: TObject);
var
  High_right_Pass: string;
begin

  High_right_Pass := 'linsf620@';
  //if (SGBTCONFIGURE.enableHigh = '00')
    //and (edtPassword.Text = High_right_Pass) then //�Ƿ��������Ȩ�޽���
  if   (edtPassword.Text = High_right_Pass) then
  begin
    LOAD_USER.ID_type := 'AA'; //������
    G_User.UserNO := '3F';
    G_User.UserName := '3F';
    G_User.UserPassword := '3F';
    G_User.UserOpration := '3F';
    orderLst.Free();
    recDataLst.Free();
    recData_fromICLst.Free();
    recData_fromICLst_Check.Free();
    comReader.StopComm();
   // Comm_Check.StopComm();
    Longon_OK := false;
    rootEnable := true;
    Frm_Logon.Hide;
    Frm_IC_Main.show; //����������
    Login := True;
  end
  else
  begin
    checkLogin(); //���ǳ�������Ա
  end;
end;



end.

