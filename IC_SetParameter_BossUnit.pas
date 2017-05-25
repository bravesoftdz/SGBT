unit IC_SetParameter_BossUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, IniFiles,
  Dialogs, StdCtrls, Buttons, ExtCtrls, SPComm;

type
  Tfrm_SetParameter_Boss = class(TForm)
    Panel1: TPanel;
    comReader: TComm;
    Comm_Check: TComm;
    Timer_3FPASSWORD: TTimer;
    Timer_HAND: TTimer;
    Panel2: TPanel;
    BitBtn3: TBitBtn;
    Image1: TImage;
    Image2: TImage;
    Edit3: TEdit;
    Edit2: TEdit;
    Edit1: TEdit;
    Edit_old_Password_Input: TEdit;
    Edit_old_password: TEdit;
    Edit_newpassword: TEdit;
    Edit_ID: TEdit;
    Edit_Comfir_password: TEdit;
    BitBtn1: TBitBtn;
    BitBtn_ChangBossPassword: TBitBtn;
    Edit_Name: TEdit;
    procedure BitBtn_ChangBossPasswordClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure comReaderReceiveData(Sender: TObject; Buffer: Pointer;
      BufferLength: Word);
    procedure BitBtn3Click(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure Edit_old_Password_InputKeyPress(Sender: TObject;
      var Key: Char);
    procedure Edit_newpasswordKeyPress(Sender: TObject; var Key: Char);
    procedure Edit_Comfir_passwordKeyPress(Sender: TObject; var Key: Char);
    procedure Timer_3FPASSWORDTimer(Sender: TObject);
    procedure Timer_HANDTimer(Sender: TObject);
    procedure Comm_CheckReceiveData(Sender: TObject; Buffer: Pointer;
      BufferLength: Word);
  private
    { Private declarations }
    procedure CheckCMD_Right(); //系统主机权限判断，确认是否与加密狗唯一对应
    procedure INcrevalue(S: string); //充值函数
            //发送握手请求指令
    procedure SendCMD_HAND;
    procedure SendCMD_3FPASSWORD; //发送3F出厂密码（系统编号）确认请求指令
    function Make_Send_CMD_PasswordIC(StrCMD: string; StrIncValue: string): string;
    function CheckSUMData_PasswordIC(orderStr: string): string;

    function updateemanagerpassword(strID: string; strPassword: string): boolean;

  public
    procedure WriteCustomerNameToIniFile; //写入出厂客户编号 、场地密码给配置文件
    procedure WriteCustomerNameToFlash; //写入出厂客户编号 、场地密码给加密卡，通过串口实现

    function exchData(orderStr: string): string;
    procedure sendData();
    procedure checkOper();
    procedure CheckCMD();
    { Public declarations }
  end;

var
  frm_SetParameter_Boss: Tfrm_SetParameter_Boss;
  orderLst, recDataLst, recData_fromICLst: Tstrings;
  Check_Count, Check_Count_3FPASSWORD: integer;

  recData_fromICLst_Check: Tstrings;
  LOAD_CHECK_OK_RE, LOAD_3FPASSWORD_OK_RE, LOAD_USERPASSWORD_OK_RE: BOOLEAN;
  WriteToFile_OK, WriteToFlase_OK: BOOLEAN;
  BossPassword_check: string; //PC托盘特征码
  BossPassword_old_check: string; //PC读出特征码
  BossPassword_3F_check: string; //PC写入特征码
  strGuserid: string;
implementation
uses ICDataModule, ICCommunalVarUnit, ICFunctionUnit, ICmain, Frontoperate_EBincvalueUnit, ICEventTypeUnit;


{$R *.dfm}
//转找发送数据格式 ，将字符转换为16进制

function Tfrm_SetParameter_Boss.exchData(orderStr: string): string;
var
  ii, jj: integer;
  TmpStr: string;
  reTmpStr: string;
begin
  if (length(orderStr) = 0) then
  begin
    MessageBox(handle, '传入参数不能为空!', '错误', MB_ICONERROR + MB_OK);
    result := '';
    exit;
  end;
  if (length(orderStr) mod 2) <> 0 then
  begin
    MessageBox(handle, '传入参数错误!', '错误', MB_ICONERROR + MB_OK);
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


//发送数据过程

procedure Tfrm_SetParameter_Boss.sendData();
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
//检查返回的数据

procedure Tfrm_SetParameter_Boss.checkOper();
var
  i: integer;
begin
  case curOperNo of
    2: begin //反馈卡余额总值操作
        for i := 0 to recData_fromICLst.Count - 1 do
          if copy(recData_fromICLst.Strings[i], 9, 2) <> '01' then // 写操作成功返回命令
          begin
                       // recData_fromICLst.Clear;
            exit;
          end;
      end;
  end;
end;


//保存设定的场地密码

procedure Tfrm_SetParameter_Boss.BitBtn_ChangBossPasswordClick(Sender: TObject);
var
  str_old_password_check: string;

begin



  if Edit_ID.Text = '' then
  begin
    MessageBox(handle, '请刷修改密码权限卡！', '错误', MB_ICONERROR + MB_OK);
    exit;
  end;
  if Edit_old_Password_Input.Text = '' then
  begin
    MessageBox(handle, '请输入旧密码！', '错误', MB_ICONERROR + MB_OK);
    exit;
  end;
  if Edit_newpassword.Text = '' then
  begin
    MessageBox(handle, '请输入新密码！', '错误', MB_ICONERROR + MB_OK);
    exit;
  end;
  if Edit_Comfir_password.Text = '' then
  begin
    MessageBox(handle, '请输入确认密码，务必保证与新密码一致！', '错误', MB_ICONERROR + MB_OK);
    exit;
  end;
  if Edit_Comfir_password.Text <> Edit_newpassword.Text then
  begin
    Edit_Comfir_password.Text := '';
    MessageBox(handle, '重新请输入确认密码，务必保证与新密码一致！', '错误', MB_ICONERROR + MB_OK);
    exit;
  end;
  if Edit_Name.Text <> INit_3F.Name_USER then
  begin
    if (MessageDlg('你修改了场地条码提示信息，确认保存？', mtInformation, [mbYes, mbNo], 0) = mrYes) then
    begin
      INit_3F.Name_USER := Edit_Name.Text;
    end
    else
    begin
      Edit_Name.Text := INit_3F.Name_USER;
      exit;
    end;

  end;



  //str_old_password_check := Edit_old_password.Text;
  str_old_password_check := Edit_old_password_input.Text;
   //判断计算得到的密码是否与原来保留的一致

  if str_old_password_check <> Edit_old_password.Text then //Edit_old_password.Text存的是原密码

  begin
    MessageBox(handle, '输入的原始密码错误，请重新输入！', '错误', MB_ICONERROR + MB_OK);
    Edit_old_Password_Input.Text := '';
    exit;
  end
  else
  begin
    if (MessageDlg('请安装连接加密卡，确认需要进行修改场地密码操作吗？', mtInformation, [mbYes, mbNo], 0) = mrYes) then
    begin
      WriteCustomerNameToIniFile; //写入场地密码给配置文档
      updateemanagerpassword(strGuserid, Edit_Comfir_password.Text);
      if WriteToFile_OK then
      begin
        LOAD_CHECK_OK_RE := false;
        WriteCustomerNameToFlash; //写入出厂客户编号 、场地密码给加密卡，通过串口实现

      end
      else
      begin
        exit;
      end;
    end
    else
    begin
      exit;
    end;
  end;

end;

function Tfrm_SetParameter_Boss.updateemanagerpassword(strID: string; strPassword: string): boolean;
var
  strSQL: string;
  strtemppassword: string;
  strtemp1: string;
  strtemp: string;
begin
  strtemp := ICFunction.ChangeAreaStrToHEX(strPassword);
  strtemp1 := FormatDateTime('yyyy-MM-dd HH:mm:ss', now);
  strtemppassword := copy(strtemp1, 3, 2) + copy(strtemp, 11, 2) + copy(strtemp1, 12, 2) + copy(strtemp, 7, 2) + copy(strtemp1, 15, 2) + copy(strtemp, 3, 2) + copy(strtemp1, 18, 2) + copy(strtemp, 9, 2) + copy(strtemp1, 15, 2) + copy(strtemp, 1, 2) + copy(strtemp1, 1, 2) + copy(strtemp, 5, 2);

  strSQL := 'update [3F_SYSUSER] set userpassword = ''' + strtemppassword + ''' where userid = ''' + strID + '''';
  ICFunction.loginfo('修改场地密码setParameter_BossUnit ' + strSQL);
  DataModule_3F.executesql(strSQL);
  result := true;
end;





procedure Tfrm_SetParameter_Boss.WriteCustomerNameToIniFile;
var
  myIni: TiniFile;
  Edit_new_password_check: string;
  Edit_comfir_password_check: string;
begin



         //20120923修改密码功能，只要修改前刷卡（老板卡或厂家3F卡）就可以直接设置了
              // Edit_new_password_check:=ICFunction.SUANFA_Password_USER(Edit_ID.Text,Edit_Comfir_password.Text);
  Edit_new_password_check := Edit_Comfir_password.Text;
  if FileExists(SystemWorkGroundFile) then
  begin
    myIni := TIniFile.Create(SystemWorkGroundFile);
                    //出厂时AA(新)==BB(旧)
                    // 老板更新时BB(旧)：=AA(新)，写入文件
                    //  更新结果AA(新)：=CC(老板新输入的值),写入文件
    INit_Wright.BossPassword := MyIni.ReadString('PLC工作区域', 'PC托盘特征码', 'D60993');
    INit_Wright.BossPassword_old := INit_Wright.BossPassword; //更新旧密码中转值
    myIni.WriteString('PLC工作区域', 'PC读出特征码', INit_Wright.BossPassword_old); //写入旧密码中转值

    INit_Wright.BossPassword := Edit_new_password_check; //更新密码值
    myIni.WriteString('PLC工作区域', 'PC托盘特征码', INit_Wright.BossPassword); //写入新密码

    Edit_comfir_password_check := MyIni.ReadString('PLC工作区域', 'PC托盘特征码', 'D60993'); //读取更新后的密码（用户场地密码）
    FreeAndNil(myIni);
  end;
  if INit_Wright.BossPassword = Edit_comfir_password_check then
  begin
    BitBtn_ChangBossPassword.Enabled := FALSE;
    Edit_old_Password_Input.Text := '';
    Edit_newpassword.Text := '';
    Edit_ID.Text := ' 修改密码成功第一步！';
    Edit1.Text := '';
    Edit_old_password.Text := '';
    WriteToFile_OK := true; //置位保存到文档操作成功
    exit;
  end
  else
  begin
    BitBtn_ChangBossPassword.Enabled := FALSE;
    Edit_old_Password_Input.Text := '';
    Edit_newpassword.Text := '';
    Edit_Comfir_password.Text := '';
    Edit1.Text := '';
    Edit_ID.Text := ' 修改密码失败！';
    Edit_old_password.Text := '';
    WriteToFile_OK := false; //置位保存到文档操作失败
    exit;
  end;

end;




procedure Tfrm_SetParameter_Boss.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  orderLst.Free();
  recDataLst.Free();
  recData_fromICLst.Free();
  recData_fromICLst_Check.Free();
  comReader.StopComm();
  ICFunction.ClearIDinfor; //清除从ID读取的所有信息

  Comm_Check.StopComm();

  Edit_old_password.Text := '';
  Edit_ID.Text := '';
end;

procedure Tfrm_SetParameter_Boss.FormShow(Sender: TObject);
begin

  BossPassword_check := '';
  BossPassword_old_check := '';
  BossPassword_3F_check := '';

  comReader.StartComm();

  orderLst := TStringList.Create;
  recDataLst := tStringList.Create;

  recData_fromICLst := tStringList.Create;
  recData_fromICLst_Check := TStringList.Create;

  Comm_Check.StartComm(); //开启加密狗串口确认

  LOAD_CHECK_OK_RE := false;
  Edit_old_Password_Input.SetFocus;

  Edit_Name.Enabled := false;
end;

procedure Tfrm_SetParameter_Boss.comReaderReceiveData(Sender: TObject; Buffer: Pointer;
  BufferLength: Word);
var
  ii: integer;
  recStr: string;
  tmpStr: string;
  tmpStrend: string;
begin
   //接收----------------
  tmpStrend := 'STR';
  recStr := '';
  SetLength(tmpStr, BufferLength);
  move(buffer^, pchar(tmpStr)^, BufferLength);
  for ii := 1 to BufferLength do
  begin
    recStr := recStr + intTohex(ord(tmpStr[ii]), 2); //将获得数据转换为16进制数
       // if  (intTohex(ord(tmpStr[ii]),2)='4A') then
    if ii = BufferLength then
    begin
      tmpStrend := 'END';
    end;
  end;
     // Edit1.Text:=recStr;
  recData_fromICLst.Clear;
  recData_fromICLst.Add(recStr);
    //接收---------------
     //if  (tmpStrend='END') then
  begin
    CheckCMD(); //首先根据接收到的数据进行判断，确认此卡是否属于为正确的卡
         //AnswerOper();//其次确认是否有需要回复IC的指令
  end;
    //发送---------------
  if curOrderNo < orderLst.Count then // 判断指令是否已经都发送完毕，如果指令序号小于指令总数则继续发送
    sendData()
  else begin
    checkOper();
  end;

end;
 //根据接收到的数据判断此卡是否为合法卡

procedure Tfrm_SetParameter_Boss.CheckCMD();
var
  tmpStr: string;
begin
   //首先截取接收的信息
  Edit_ID.Text := '';
  Edit1.Text := '';
  tmpStr := recData_fromICLst.Strings[0];

  Receive_CMD_ID_Infor.ID_CheckNum := copy(tmpStr, 39, 4); //校验和

      // if (CheckSUMData(copy(tmpStr, 1, 38))=copy(tmpStr, 41, 2)+copy(tmpStr, 39, 2)) then//校验和
  begin
    CMD_CheckSum_OK := true;
    Receive_CMD_ID_Infor.CMD := copy(recData_fromICLst.Strings[0], 1, 2); //帧头43
  end;
                 //1、判断此卡是否为已经完成初始化
  if Receive_CMD_ID_Infor.CMD = CMD_COUMUNICATION.CMD_READ then
  begin

    Receive_CMD_ID_Infor.ID_INIT := copy(recData_fromICLst.Strings[0], 3, 8); //卡片ID
    Receive_CMD_ID_Infor.ID_3F := copy(recData_fromICLst.Strings[0], 11, 6); //卡厂ID
    Receive_CMD_ID_Infor.Password_3F := copy(recData_fromICLst.Strings[0], 17, 6); //卡密
    Receive_CMD_ID_Infor.Password_USER := copy(recData_fromICLst.Strings[0], 23, 6); //用户密码
    Receive_CMD_ID_Infor.ID_value := copy(recData_fromICLst.Strings[0], 29, 8); //卡内数据
    Receive_CMD_ID_Infor.ID_type := copy(recData_fromICLst.Strings[0], 37, 2); //卡功能

                 //1、判断是否曾经初始化过，只有3F初始化过的卡且类型为万能卡AA 或 老板卡BB的才能操作
    if DataModule_3F.Query_ID_OK(LOAD_USER.ID_INIT) then
    begin

      if (Receive_CMD_ID_Infor.ID_type = copy(INit_Wright.Produecer_3F, 8, 2)) or (Receive_CMD_ID_Infor.ID_type = copy(INit_Wright.BOSS, 8, 2)) then
                 //20130111修改
                 //if ICFunction.CHECK_3F_ID(Receive_CMD_ID_Infor.ID_INIT,Receive_CMD_ID_Infor.ID_3F,Receive_CMD_ID_Infor.Password_3F) and ( (Receive_CMD_ID_Infor.ID_type=copy(INit_Wright.Produecer_3F,8,2))or (Receive_CMD_ID_Infor.ID_type=copy(INit_Wright.BOSS,8,2)) ) then

      begin
        BitBtn_ChangBossPassword.Enabled := true; //许可修改密码操作
        Edit_Name.Enabled := true;
        Edit_Name.Text := INit_3F.Name_USER;
        Edit_old_password.Text := INit_Wright.BossPassword; //将原来的密码显示，是否需要考虑变成*号显示？
        Edit_ID.Text := Receive_CMD_ID_Infor.ID_INIT;

        strGuserid := Receive_CMD_ID_Infor.ID_INIT;

        Edit1.Text := recData_fromICLst.Strings[0];
                          //Panel_Message.Caption:='权限确认正常，请进行操作';
        Edit_newpassword.Text := '';
        Edit_old_Password_Input.SetFocus;
      end
    end
    else //不是万能卡AA，也不是老板卡BB
    begin
      Edit1.Text := '对不起！你无权限进行修改密码操作';
                          //Panel_Message.Caption:='对不起！你无权限进行修改密码操作';
      Edit_newpassword.Text := '';
      exit;
    end;
  end;

end;


procedure Tfrm_SetParameter_Boss.BitBtn3Click(Sender: TObject);
begin
  Close;
end;

procedure Tfrm_SetParameter_Boss.BitBtn1Click(Sender: TObject);
begin
  Edit2.Text := ICFunction.SUANFA_Password_USER(Edit_ID.Text, Edit3.Text)
end;

procedure Tfrm_SetParameter_Boss.Edit_old_Password_InputKeyPress(
  Sender: TObject; var Key: Char);
begin
  if not (key in ['0'..'9', #8, #13]) then
  begin
    key := #0;
    ShowMessage('输入错误，只能输入数字和字符！');
  end
  else if key = #13 then
  begin
    if length(Edit_old_Password_Input.Text) = 6 then
      Edit_newpassword.setfocus;
  end;
end;

procedure Tfrm_SetParameter_Boss.Edit_newpasswordKeyPress(Sender: TObject;
  var Key: Char);
begin
  if not (key in ['0'..'9', #8, #13]) then
  begin
    key := #0;
    ShowMessage('输入错误，只能输入数字和字符！');
  end
  else if key = #13 then
  begin
    if length(Edit_newpassword.Text) = 6 then
      Edit_Comfir_password.setfocus;
  end;
end;

procedure Tfrm_SetParameter_Boss.Edit_Comfir_passwordKeyPress(
  Sender: TObject; var Key: Char);
begin
  if not (key in ['0'..'9', #8, #13]) then
  begin
    key := #0;
    ShowMessage('输入错误，只能输入数字和字符！');
  end
  else if key = #13 then
  begin
    if length(Edit_Comfir_password.Text) = 6 then
      BitBtn_ChangBossPassword.setfocus;
  end;
end;



//----------------以下程序是为了将修改的场地密码保存到FLASH中     开始--------

procedure Tfrm_SetParameter_Boss.Timer_HANDTimer(Sender: TObject);

begin
  Check_Count := Check_Count + 1;
  if not LOAD_CHECK_OK_RE then //握手未成功
  begin
    SendCMD_HAND; //发送握手指令
    if Check_Count = 4 then //定时秒
    begin
      LOAD_CHECK_OK_RE := false;
      Timer_HAND.Enabled := FALSE; //关闭定时器
      Check_Count := 0;
    end;
  end
  else
  begin
    Timer_HAND.Enabled := FALSE; //关闭定时器
    Check_Count := 0
  end;


end;

procedure Tfrm_SetParameter_Boss.Timer_3FPASSWORDTimer(Sender: TObject);
begin

  Check_Count_3FPASSWORD := Check_Count_3FPASSWORD + 1;
  if not LOAD_3FPASSWORD_OK_RE then //握手未成功
  begin
    SendCMD_3FPASSWORD; //发送握手指令
    if Check_Count_3FPASSWORD = 4 then //定时秒
    begin
      LOAD_3FPASSWORD_OK_RE := false;
      Timer_3FPASSWORD.Enabled := FALSE; //关闭定时器
      Check_Count_3FPASSWORD := 0;
    end;
  end
  else
  begin
    Timer_3FPASSWORD.Enabled := FALSE; //关闭定时器
    Check_Count_3FPASSWORD := 0;
  end;

end;


//发送握手请求指令

procedure Tfrm_SetParameter_Boss.SendCMD_HAND;
var
  INC_value: string;
  strValue: string;
begin
  begin
    INC_value := '0'; //充值数值
    strValue := '50613C6D03'; //握手请求指令50  61  3C  6D  03
    INcrevalue(strValue); //写入ID卡
  end;


end;
//发送写入场地密码请求指令

procedure Tfrm_SetParameter_Boss.SendCMD_3FPASSWORD;
var
  strValue, INC_value: string;
begin
  INC_value := '1FE3C4' + 'AFBD3F' + TrimRight(Edit_Comfir_password.Text) + '0'; //场地密码
  Operate_No := 1;
  strValue := Make_Send_CMD_PasswordIC('5066', INC_value); //计算充值指令
  INcrevalue(strValue);
end;

//写入---------------------------------------

procedure Tfrm_SetParameter_Boss.INcrevalue(S: string);
begin
  orderLst.Clear();
  curOrderNo := 0;
  curOperNo := 1;
  orderLst.Add(S); //将币值写入币种
  sendData();
end;



//计算充值指令

function Tfrm_SetParameter_Boss.Make_Send_CMD_PasswordIC(StrCMD: string; StrIncValue: string): string;
var
  i: integer;
  TmpStr_IncValue: string; //转为16进制后的字符串
  TmpStr_CheckSum: string; //校验和
  TmpStr_SendCMD: string; //指令内容
  reTmpStr, StrFramEND, StrConFram: string;
begin

  TmpStr_IncValue := IntToHex(Ord(StrIncValue[1]), 2);

  for i := 2 to length(StrIncValue) - 1 do
  begin
    TmpStr_IncValue := TmpStr_IncValue + IntToHex(Ord(StrIncValue[i]), 2);

  end;

  StrFramEND := '03';
  StrConFram := '63';
    //将发送内容进行校核计算
  TmpStr_SendCMD := StrCMD + TmpStr_IncValue + StrFramEND + StrConFram;
  TmpStr_CheckSum := CheckSUMData_PasswordIC(TmpStr_SendCMD);
    //汇总发送内容

  reTmpStr := StrCMD + TmpStr_IncValue + TmpStr_CheckSum + StrFramEND;

  result := reTmpStr;

end;

//校验和，确认是否正确

function Tfrm_SetParameter_Boss.CheckSUMData_PasswordIC(orderStr: string): string;
var
  ii, jj, KK: integer;
  TmpStr: string;
  reTmpStr: string;
begin
  if (length(orderStr) mod 2) <> 0 then
  begin
    MessageBox(handle, '传入参数长度错误!', '错误', MB_ICONERROR + MB_OK);
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




//更新配置文件，写入出厂客户编号、场地密码给加密卡

procedure Tfrm_SetParameter_Boss.WriteCustomerNameToFlash;
begin
  Timer_HAND.Enabled := true; //开始检测加密狗握手定时器
end;



procedure Tfrm_SetParameter_Boss.Comm_CheckReceiveData(Sender: TObject;
  Buffer: Pointer; BufferLength: Word);
var
  ii: integer;
  recStr: string;
  tmpStr: string;
  tmpStrend: string;
begin
   //接收----------------
  recStr := '';
  SetLength(tmpStr, BufferLength);
  move(buffer^, pchar(tmpStr)^, BufferLength);
  for ii := 1 to BufferLength do
  begin
    recStr := recStr + intTohex(ord(tmpStr[ii]), 2); //将获得数据转换为16进制数
    if ii = BufferLength then
    begin
      tmpStrend := 'END';
    end;
  end;
  recData_fromICLst_Check.Clear;
  recData_fromICLst_Check.Add(recStr);
    //接收---------------
  begin
    CheckCMD_Right(); //系统启动时判断加密狗
  end;
end;


//根据接收到的数据判断此卡是否为合法卡

procedure Tfrm_SetParameter_Boss.CheckCMD_Right();
var
  tmpStr: string;
  i: integer;
  content1, content2, content3, content4, content5, content6: string;
begin
   //首先截取接收的信息
  tmpStr := '';
  tmpStr := recData_fromICLst_Check.Strings[0];
  content1 := copy(tmpStr, 1, 2); //帧头AA
  content2 := copy(tmpStr, 3, 2); //操作指令
  if (content1 = '43') then //帧头
  begin

    if (content2 = CMD_COUMUNICATION.CMD_HAND) then //收到握手请求反馈信息0x61
    begin
      for i := 1 to length(tmpStr) do
      begin
        if (copy(tmpStr, i, 2) = '03') and (i mod 2 = 1) then
        begin
          content3 := copy(tmpStr, i - 2, 2); //指令校验和
          content5 := copy(tmpStr, 1, i - 3) + '63' + copy(tmpStr, i, 2);

          if (CheckSUMData_PasswordIC(content5) = content3) then
          begin

            LOAD_CHECK_OK_RE := true; //握手成功
            Timer_HAND.Enabled := FALSE; //关闭检测定时器
                                //Timer_USERPASSWORD.Enabled:=true;//发送写系统编号指令

            Timer_3FPASSWORD.Enabled := true;
                                //Panel_Message.Caption:='握手操作成功';
            Edit_newpassword.Text := '';
            tmpStr := '';
            break;
          end;
        end;
      end; //for 结束

    end
    else if (content2 = CMD_COUMUNICATION.CMD_WRITETOFLASH_Sub_RE) then //收到写入系统编号反馈信息0x66
    begin
      for i := 1 to length(tmpStr) do
      begin
        if (copy(tmpStr, i, 2) = '03') and (i mod 2 = 1) then
        begin

          content6 := copy(tmpStr, 5, 2);
          content3 := copy(tmpStr, i - 2, 2); //指令校验和
          if (content6 = CMD_COUMUNICATION.CMD_USERPASSWORD_RE) then //0x68
          begin
            content5 := copy(tmpStr, 1, i - 3) + '63' + copy(tmpStr, i, 2);

            if (CheckSUMData_PasswordIC(content5) = content3) then
            begin
              LOAD_USERPASSWORD_OK_RE := true;
                                       //Timer_USERPASSWORD.Enabled:=false;
                                       //Timer_3FPASSWORD.Enabled:=true;
                                       //Panel_Message.Caption:='写入系统编码操作成功';
              Edit_newpassword.Text := '';
            end;
            tmpStr := '';
            break;
          end
          else if (content6 = CMD_COUMUNICATION.CMD_3FPASSWORD_RE) then //0x66
          begin

            content5 := copy(tmpStr, 1, i - 3) + '63' + copy(tmpStr, i, 2);

            if (CheckSUMData_PasswordIC(content5) = content3) then
            begin
              LOAD_3FPASSWORD_OK_RE := false;
              WriteToFlase_OK := true;
                                      //Panel_Message.Caption:='写入场地密码操作成功';
              Edit_newpassword.Text := '';
              if WriteToFile_OK then
              begin
                if WriteToFlase_OK then
                begin

                                                //SaveData_CustomerInfor; //保存、更新出厂记录
                                                //DeleteTestDataFromTable;//删除测试数据
                  Edit_ID.Text := '操作成功';
                  Edit_newpassword.Text := '';
                  WriteToFile_OK := false;
                  WriteToFlase_OK := false;
                end;
              end;
            end;
            tmpStr := '';
            break;


          end;

        end;
      end; //------for 结束
    end;

  end;


end;

end.
