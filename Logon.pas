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


    //窗体事件
    procedure FormActivate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure SetCursorRect(rect: TRect);

    //串口事件
    procedure comReaderReceiveData(Sender: TObject; Buffer: Pointer; BufferLength: Word);
    procedure Comm_CheckReceiveData(Sender: TObject; Buffer: Pointer; BufferLength: Word);

    //控件事件
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn_ExitClick(Sender: TObject);
    procedure BitBtn_OKClick(Sender: TObject);
    procedure Panel1DblClick(Sender: TObject);
    procedure Label5Click(Sender: TObject);
    procedure edtPasswordKeyPress(Sender: TObject; var Key: Char);

    //定时器事件
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
    procedure checkEncodeDogCMD(); //系统主机权限判断，确认是否与加密狗唯一对应
    function INit_Send_CMD(StrCMD: string; StrIncValue: string): string;
    procedure INIT_Operation;
    procedure INcrevalue(S: string); //充值函数
    procedure sendData();
    function exchData(orderStr: string): string;


    function Date_Time_Modify(strinputdatetime: string): string;
    function CheckPassword(strtemp_Password: string): boolean;
    //procedure CheckRight(UserNO: string); //读取权限控制
    //function MaxRight: string;
    //procedure ClearArr_Wright_3F;
    //procedure EnableMenu; //读取权限控制
    function Query_Customer(Customer_No1: string): string;

        //发送握手请求指令
    procedure sendHANDCMD;
    //发送读取场地密码请求指令
    procedure SendCMD_USERPASSWORD;
    //发送3F出厂密码（系统编号）确认请求指令
    procedure SendCMD_3FPASSWORD;
    //发送写登陆日期
    procedure SendCMD_3FLOADDATE;
    //发送读登陆日期
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


 //拼接签到接口URL
    function generateLoginURL(): string;
    function generateSigeLoginURL(): string;

  //激活请求签名算法
    function getLoginSignature(strAppID: string; strCoinlimit: string; strShopID: string; strTimeStamp: string): string;
    function getSigeLoginSignature(appId: string; coinCost: string; coinLimit: string; secretKey: string; shopId: string; timeStamp: string): string;


  end;

var
  Frm_Logon: TFrm_Logon;
  Longon_OK: BOOLEAN; //加密狗认证是否通过
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

//注册码验证


function TFrm_Logon.checkLicense(): boolean;
var
  CPUIDInfo: TCPUIDInfo;
  strCPUID: string;
begin
  result := false; //不一致
  CPUIDInfo := TCPUIDInfo.Create;
  strCPUID := CPUIDInfo.GetCPUIDstr;
  if strCPUID = SGBTCONFIGURE.registerCode then //比较明文
    result := true //一致
  else
    frmRegister.ShowModal;
    
    
end;





//密码确认

function TFrm_Logon.CheckPassword(strtemp_Password: string): boolean;
var
  strtemp_Input, strtemp1, strtemp2: string;

begin
  strtemp_Input := ICFunction.ChangeAreaStrToHEX(TrimRight(edtPassword.Text));
  strtemp1 := copy(strtemp_Password, 19, 2) + copy(strtemp_Password, 11, 2) + copy(strtemp_Password, 23, 2);
  strtemp2 := copy(strtemp_Password, 7, 2) + copy(strtemp_Password, 15, 2) + copy(strtemp_Password, 3, 2);


  if (strtemp1 + strtemp2) = strtemp_Input then
  begin
    result := true; //一致
  end
  else
  begin
    result := false; //不一致
  end;
end;

//充值卡头Comm1操作

procedure TFrm_Logon.comReaderReceiveData(Sender: TObject; Buffer: Pointer;
  BufferLength: Word);
var
  i: integer;
  recStr: string;
  tmpStr: string;
  tmpStrend: string;
begin
   //接收----------------
  recStr := '';
  SetLength(tmpStr, BufferLength);
  move(buffer^, pchar(tmpStr)^, BufferLength);
  for i := 1 to BufferLength do
  begin
    recStr := recStr + intTohex(ord(tmpStr[i]), 2); //将获得数据转换为16进制数
    if i = BufferLength then
    begin
      tmpStrend := 'END';
    end;
  end;

  recData_fromICLst.Clear;
  recData_fromICLst.Add(recStr);
  begin
    CheckCMD(); //首先根据接收到的数据进行判断，确认此卡是否属于为正确的卡
  end;
end;

procedure TFrm_Logon.FormShow(Sender: TObject);
begin

  ICFunction.InitSystemWorkPath; //初始化文件路径
  ICFunction.InitSystemWorkground; //初始化参数背景
  //变量configureExist 在unit ICFunctionUnit;中检测赋值，用于确认是否有系统配置文件
  //认证码后台认证
  if configureExist and checkLicense() then
  begin
    Longon_OK := false;
    //加密狗串口接收字符串
    recData_fromICLst_Check := tStringList.Create;
    orderLst := TStringList.Create;

    // add linlf 20170218 调试没有加密狗情况下的登录


    try
      comReader.StartComm();
    except on E: Exception do //拦截所有异常
      begin
        showmessage( SG3FERRORINFO.commerror + e.message);
        exit;
      end;
    end;

    recDataLst := tStringList.Create;
    recData_fromICLst := tStringList.Create;

   //Debug Close    加密狗合并到充值器一起用同一个串口
   //开启加密狗串口确认  Com4
   { try
      Comm_Check.StartComm();
    except on E: Exception do //拦截所有异常
      begin
        showmessage(SG3FERRORINFO.commerror + e.message);
        exit;
      end;
    end;
    }


    LOAD_CHECK_OK_RE := false;
    Timer_HAND.Enabled := true; //开始检测加密狗握手定时器 
    edtPassword.SetFocus;

  end
  else
  begin
    Frm_Logon.Caption := '版权归思歌智能科技所有！';
    //lblMessage.Caption := '配置文件不正确,请重新登录';
    lblMessage.Caption := SG3FERRORINFO.error_register_code;
  end;

end;


procedure TFrm_Logon.BitBtn_ExitClick(Sender: TObject);
begin
  Close;
end;

//根据接收到的数据判断此卡是否为合法卡

procedure TFrm_Logon.CheckCMD();
var
  tmpStr: string;
begin
   //首先截取接收的信息
  lblMessage.Caption := '';
  tmpStr := recData_fromICLst.Strings[0];
  LOAD_USER.ID_CheckNum := copy(tmpStr, 39, 4); //校验和

  begin

    LOAD_USER.CMD := copy(recData_fromICLst.Strings[0], 1, 2); //帧头43
    LOAD_USER.ID_INIT := copy(recData_fromICLst.Strings[0], 3, 8); //卡片ID
    LOAD_USER.ID_3F := copy(recData_fromICLst.Strings[0], 11, 6); //卡厂ID
    LOAD_USER.Password_3F := copy(recData_fromICLst.Strings[0], 17, 6); //appid
    LOAD_USER.Password_USER := copy(recData_fromICLst.Strings[0], 23, 6); //shopid
    LOAD_USER.ID_value := copy(recData_fromICLst.Strings[0], 29, 8); //卡内数据
    LOAD_USER.ID_type := copy(recData_fromICLst.Strings[0], 37, 2); //卡功能


    if (LOAD_USER.ID_type = copy(INit_Wright.OPERN, 8, 2))  //类型正确
      //and (DataModule_3F.queryExistInitialRecord(LOAD_USER.ID_INIT)) //初始化
      and (LOAD_USER.Password_USER = SGBTCONFIGURE.shopid) then //吧台号正确
    begin
      Longon_OK := TRUE;
      lblMessage.caption := '管理卡验证通过,请输入吧台号！';
    end
    else
    begin
      Longon_OK := false;
      lblMessage.caption := '当前卡非法！';
      exit;
    end;


  end;


end;


//初始化操作

procedure TFrm_Logon.INIT_Operation;
var
  INC_value: string;
  strValue: string;
begin
  begin
    INC_value := '0'; //充值数值
    strValue := INit_Send_CMD('AB', INC_value); //计算充值指令
    INcrevalue(strValue); //写入ID卡
  end;
end;


//初始化卡计算指令

function TFrm_Logon.INit_Send_CMD(StrCMD: string; StrIncValue: string): string;
var
  TmpStr: string; //规范后的日期和时间
  TmpStr_CheckSum: string; //校验和
  TmpStr_SendCMD: string; //指令内容
  reTmpStr: string;
  myIni: TiniFile;
  strinputdatetime: string;

  i: integer;
  Strsent: array[0..21] of string; //机型分组对应变量
begin
  strinputdatetime := DateTimetostr((now()));
  TmpStr := Date_Time_Modify(strinputdatetime); //规范日期和时间格式
  Strsent[0] := StrCMD; //帧命令

  Strsent[5] := IntToHex(Strtoint(Copy(TmpStr, 1, 2)), 2); //年份前2位
  Strsent[18] := IntToHex(Strtoint(Copy(TmpStr, 3, 2)), 2); //年份后2位
  Strsent[8] := IntToHex(Strtoint(Copy(TmpStr, 6, 2)), 2); //月份前2位
  Strsent[10] := IntToHex(Strtoint(Copy(TmpStr, 9, 2)), 2); //日期前2位
  Strsent[14] := IntToHex(Strtoint(Copy(TmpStr, 12, 2)), 2); //小时前2位
  Strsent[6] := IntToHex(Strtoint(Copy(TmpStr, 15, 2)), 2); //分钟前2位
  Strsent[1] := IntToHex(Strtoint(Copy(TmpStr, 18, 2)), 2); //秒前2位

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

  //将读取的文档中的场地密码
  if FileExists(SystemWorkGroundFile) then
  begin
    myIni := TIniFile.Create(SystemWorkGroundFile);
    INit_Wright.BossPassword := MyIni.ReadString('PLC工作区域', 'PC托盘特征码', 'D6077');
    FreeAndNil(myIni);
  end;

    //将发送内容进行校核计算
  for i := 0 to 18 do
  begin
    TmpStr_SendCMD := TmpStr_SendCMD + Strsent[i];
  end;
  TmpStr_CheckSum := ICFunction.checkSUMData(TmpStr_SendCMD); //求得校验和
  reTmpStr := TmpStr_SendCMD + ICFunction.transferCheckSumByte(TmpStr_CheckSum); //获取所有发送给IC的数据
  result := reTmpStr;
end;
//校验和，确认是否正确




procedure TFrm_Logon.INcrevalue(S: string);
begin
  orderLst.Clear();
  curOrderNo := 0;
  curOperNo := 2;
  orderLst.Add(S); //将币值写入币种
  sendData();
end;
//发送数据过程

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

//转找发送数据格式 ，将字符转换为16进制

function TFrm_Logon.exchData(orderStr: string): string;
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




//定时器扫描统计结果和详细记录

function TFrm_Logon.Date_Time_Modify(strinputdatetime: string): string;
var
  strEnd: string;
  Strtemp: string;
begin

  Strtemp := Copy(strinputdatetime, length(strinputdatetime) - 8, 9);
  strinputdatetime := Copy(strinputdatetime, 1, length(strinputdatetime) - 9);
  if Copy(strinputdatetime, 7, 1) = '-' then //月份小于10
  begin
    if length(strinputdatetime) = 8 then //月份小于10,且日期小于10
    begin
      strEnd := Copy(strinputdatetime, 1, 5) + '0' + Copy(strinputdatetime, 6, 2) + '0' + Copy(strinputdatetime, 8, 1);
    end
    else
    begin
      strEnd := Copy(strinputdatetime, 1, 5) + '0' + Copy(strinputdatetime, 6, length(strinputdatetime) - 5);
    end;
  end
  else
  begin //月份大于9
    if length(strinputdatetime) = 9 then //月份大于9,但日期小于10
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
  LOAD_CHECK_Time_Over := true; //定时接收加密狗的反馈信息
  Timer2.Enabled := true; //开启定时器2
  Timer1.Enabled := FALSE; //关闭定时器1
end;

procedure TFrm_Logon.Timer2Timer(Sender: TObject);
begin

 // if not LOAD_CHECK_OK then //开启系统时，在3秒内没有接收到加密狗的反馈，则系统软件自杀
 // begin
  //  BitBtn_OK.Enabled := false;
  //end;
  LOAD_CHECK_Time_Over := false; //
  Timer2.Enabled := FALSE; //关闭定时器2
end;

//----------------------------------------以下为加密狗相关 开始---------


//加密卡检测程序

procedure TFrm_Logon.Comm_CheckReceiveData(Sender: TObject;
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
  checkEncodeDogCMD(); //系统启动时判断加密狗

end;

//根据接收到的加密狗数据判断此卡是否为合法卡 ,这里的逻辑是什么？有点乱

procedure TFrm_Logon.checkEncodeDogCMD();
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


  if (content1 = '43') then //帧头43
  begin
    if (content2 = CMD_COUMUNICATION.CMD_HAND) then //收到握手请求反馈信息0x61
    begin
      for i := 1 to length(tmpStr) do
      begin
        if copy(tmpStr, i, 2) = '03' then
        begin
          content3 := copy(tmpStr, i - 2, 2); //指令校验和
          content5 := copy(tmpStr, 1, i - 3) + '63' + copy(tmpStr, i, 2);
          if (CheckSUMData_PasswordIC(content5) = content3) then
          begin
            LOAD_CHECK_OK_RE := true; //握手成功
            Timer_HAND.Enabled := FALSE; //关闭检测定时器
            Timer_USERPASSWORD.Enabled := true; //开启场地密码定时器检测
            tmpStr := '';
            break;
          end; //if
        end; //if
      end; //for
    end //if CMD_COUMUNICATION.CMD_HAND

     // tmpStr=43 64 01 30 30 30 30 30 33 46 32 30 31 33 30 30 30 30 30 33 03
    else if (content2 = CMD_COUMUNICATION.CMD_USERPASSWORD) then //收到系统编码检验反馈信息 0x64
    begin
      if Check_CustomerNO(tmpStr, INit_Wright.CustomerNO) then //比较系统编号是否一如"3F2013000001"
      begin
        LOAD_3FPASSWORD_OK_RE := false;
        LOAD_USERPASSWORD_OK_RE := true;
        Timer_3FPASSWORD.Enabled := true; //发送读取3F出厂密码（系统编号）确认请求指令
      end;
    end
    else if (content2 = CMD_COUMUNICATION.CMD_3FPASSWORD) then // 场地密码0x62
    begin
      if Check_CustomerPassword(tmpStr, INit_Wright.BossPassword) then //比较场地密码
      begin
        LOAD_3FPASSWORD_OK_RE := true;
        Timer_3FPASSWORD.Enabled := false;
        Timer_3FLOADDATE.Enabled := true;
      end;
    end
    else if (content2 = CMD_COUMUNICATION.CMD_3FLODADATE) then // 最后一次登陆日期时间0x65
    begin
      if Check_LOADDATE(tmpStr, INit_3F.ID_Settime) then //比较登陆日期时间
      begin
        LOAD_3FLOADDATE_OK_RE := true;
        Timer_3FLOADDATE.Enabled := false;
        lblMessage.Caption := '系统初始化完毕，请刷登陆卡，然后输入登陆密码        ';
        //comReader.StartComm(); //
        try
          comReader.StartComm;
        except on E: Exception do //拦截所有异常
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

//--------------------------以下是处理写登陆日期的反馈信息处理事件--------------
    else if (content2 = CMD_COUMUNICATION.CMD_WRITETOFLASH_Sub_RE) then // //写操作反馈回来的第二字节为7A
    begin
      for i := 1 to length(tmpStr) do
      begin
        if (copy(tmpStr, i, 2) = '03') and (i mod 2 = 1) then
        begin
          content6 := copy(tmpStr, 5, 2);
          content3 := copy(tmpStr, i - 2, 2); //指令校验和
          if (content6 = CMD_COUMUNICATION.CMD_3FLODADATE_RE) then //0x69
          begin
            content5 := copy(tmpStr, 1, i - 3) + '63' + copy(tmpStr, i, 2);
            if (CheckSUMData_PasswordIC(content5) = content3) then
            begin
              LOAD_3FLOADDATE_WRITE_OK_RE := true;
              WriteToFlase_OK := true;
              lblMessage.Caption := '写入登陆时间操作成功';


              if WriteToFlase_OK then
              begin
                lblMessage.Caption := '更新加密卡中的数据操作成功';
                //CheckRight(G_User.UserNO); //读取权限控制
                orderLst.Free();
                recDataLst.Free();
                recData_fromICLst.Free();
                recData_fromICLst_Check.Free();
                comReader.StopComm();
                Comm_Check.StopComm();
                Longon_OK := false;
                Frm_Logon.Hide;
                Frm_IC_Main.show; //进入主界面
                Login := True;
              end
              else
              begin
                lblMessage.Caption := '配置加密卡数据出错，请联系厂家';
                WriteToFile_OK := false;
                WriteToFlase_OK := false;
                exit;
              end;
            end
            else
            begin
              lblMessage.Caption := '温馨提示：初始化失败，请联系技术支持，或重新启动系统                  '

            end;
            tmpStr := '';
            break;
          end;

        end;
      end; //------for 结束
    end;

  end;


end;


//更新配置文件，写入出厂客户编号、场地密码给配置文件

procedure TFrm_Logon.WriteCustomerNameToIniFile;
var
  myIni: TiniFile;

  LOADDATE: string; //用户场地密码
begin

   //判断计算得到的密码是否与原来保留的一致
  LOADDATE := COPY(strtime, 1, 1) + COPY(strtime, 5, 1) + COPY(strtime, 2, 1) + COPY(strtime, 4, 1); //设定时间
  if FileExists(SystemWorkGroundFile) then
  begin
    myIni := TIniFile.Create(SystemWorkGroundFile);

    myIni.WriteString('卡出厂设置', '设定时间', LOADDATE); //写入新密码
    INit_3F.ID_Settime := MyIni.ReadString('卡出厂设置', '设定时间', '2721'); //
    FreeAndNil(myIni);

    if LOADDATE = INit_3F.ID_Settime then
    begin
      WriteToFile_OK := true;
      lblMessage.Caption := '更新文档中的登陆日期配置成功';
    end;

  end;

end;
//根据读取的条码值流水，查询数据库中是否已经有相同记录，如果有则提示

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

 //每隔100ms请求一次握手指令

procedure TFrm_Logon.Timer_HANDTimer(Sender: TObject);
begin
  Check_Count := Check_Count + 1;
  if not LOAD_CHECK_OK_RE then //握手未成功
  begin
    sendHANDCMD; //发送握手指令
    if Check_Count = 4 then //定时4秒,握手仍不成功
    begin
     // BitBtn_OK.Enabled := false; //禁止登陆操作
      LOAD_CHECK_OK_RE := false;
      Timer_HAND.Enabled := FALSE; //关闭定时器
    end;
  end
  else
  begin
    Timer_HAND.Enabled := FALSE; //关闭定时器
  end;

end;

//发送握手请求指令

procedure TFrm_Logon.sendHANDCMD;
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




 //定时请求3F密码

procedure TFrm_Logon.Timer_3FPASSWORDTimer(Sender: TObject);
begin
  Check_Count_3FPASSWORD := Check_Count_3FPASSWORD + 1;
  if not LOAD_3FPASSWORD_OK_RE then //握手未成功
  begin
    SendCMD_3FPASSWORD; //发送握手指令
    if Check_Count_3FPASSWORD = 4 then //定时秒
    begin
     // BitBtn_OK.Enabled := false; //禁止登陆操作
      LOAD_3FPASSWORD_OK_RE := false;
      Timer_3FPASSWORD.Enabled := FALSE; //关闭定时器
    end;
  end
  else
  begin
    Timer_3FPASSWORD.Enabled := FALSE; //关闭定时器
  end;

end;

//发送读取3F密码请求指令

procedure TFrm_Logon.SendCMD_3FPASSWORD;
var
  strValue: string;
begin
  begin
    strValue := '50625203'; //读场地密码请求指令50  62  52  03   与X66指令对应
    INcrevalue(strValue); //发送给加密卡
  end;
end;



//请求场地密码

procedure TFrm_Logon.Timer_USERPASSWORDTimer(Sender: TObject);
begin
  Check_Count_USERPASSWORD := Check_Count_USERPASSWORD + 1;
  if not LOAD_USERPASSWORD_OK_RE then //握手未成功
  begin
    SendCMD_USERPASSWORD; //发送读取场地密码请求指令
    if Check_Count_USERPASSWORD = 4 then //定时秒
    begin
      LOAD_USERPASSWORD_OK_RE := false;
      Timer_USERPASSWORD.Enabled := FALSE; //关闭定时器
    end;
  end
  else
  begin
    Timer_USERPASSWORD.Enabled := FALSE; //关闭定时器
  end;
end;

//发送读取3F（系统编号）请求指令

procedure TFrm_Logon.SendCMD_USERPASSWORD;
var
  strValue: string;
begin
  begin
    strValue := '5064015503'; //读系统编码请求指令       //与x68指令对应
    INcrevalue(strValue); //发送给加密卡
  end;
end;

//请求登录日期

procedure TFrm_Logon.Timer_3FLOADDATETimer(Sender: TObject);
begin
  Check_Count_3FLOADDATE := Check_Count_3FLOADDATE + 1;

  if not LOAD_3FLOADDATE_OK_RE then //握手未成功
  begin
    SendCMD_3FLOADDATE_READ; //发送读取场地密码请求指令
    if Check_Count_3FLOADDATE = 4 then //定时秒
    begin
      LOAD_3FLOADDATE_OK_RE := false;
      Timer_3FLOADDATE.Enabled := FALSE; //关闭定时器
    end;
  end
  else
  begin
           //BitBtn_OK.Enabled:=true;//许可登陆操作
    Timer_3FLOADDATE.Enabled := FALSE; //关闭定时器
  end;
end;

//发送//读登陆日期

procedure TFrm_Logon.SendCMD_3FLOADDATE_READ;
var
  strValue: string;
begin
  begin
    strValue := '50655503'; //读系统登陆日期时间请求指令       //与x69指令对应
    INcrevalue(strValue); //发送给加密卡
  end;
end;




 //写入时间

procedure TFrm_Logon.Timer_3FLOADDATE_WRITETimer(
  Sender: TObject);
begin
  Check_Count_3FLOADDATE_WRITE := Check_Count_3FLOADDATE_WRITE + 1;
  if not LOAD_3FLOADDATE_WRITE_OK_RE then //握手未成功
  begin
    SendCMD_3FLOADDATE; //发送更新登陆日期
    if Check_Count_3FLOADDATE_WRITE = 4 then //定时秒
    begin
      LOAD_3FLOADDATE_WRITE_OK_RE := false;
      Timer_3FLOADDATE_WRITE.Enabled := FALSE; //关闭定时器
      Check_Count_3FLOADDATE_WRITE := 0;
    end;
  end
  else
  begin
    Timer_3FLOADDATE_WRITE.Enabled := FALSE; //关闭定时器
    Check_Count_3FLOADDATE_WRITE := 0;
  end;

end;


//发送//写入登陆日期

procedure TFrm_Logon.SendCMD_3FLOADDATE;
var
  strValue, INC_value: string;
begin
  strtime := FormatDateTime('HH:mm:ss', now);
  INC_value := COPY(strtime, 1, 1) + COPY(strtime, 5, 1) + COPY(strtime, 2, 1) + COPY(strtime, 4, 1) + COPY(strtime, 7, 1);
  //INit_3F.ID_Settime,4个字节（小时+分钟）写最后一次登陆系统时间50 69 00 00 00 00 59 03
  Operate_No := 1;
  strValue := Make_Send_CMD_PasswordIC('5069', INC_value); //计算充值指令
  INcrevalue(strValue);

end;



//计算充值指令

function TFrm_Logon.Make_Send_CMD_PasswordIC(StrCMD: string; StrIncValue: string): string;
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
    //Edit1.Text:= StrIncValue;
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

function TFrm_Logon.CheckSUMData_PasswordIC(orderStr: string): string;
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
//根据接收到的数据判断相应情况
//  str1 为从串口读取的值 如
//43 64 01 30 30 30 30 30 33 46 32 30 31 33 30 30 30 30 30 33 03
//43 64 01 30 30 30 30 33 46 32 30 31 33 30 30 30 30 30 31 32 03

//  str2文档读取的值如3F2013000001

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
 //根据接收到的数据判断相应情况
 //  str1 为从串口读取的值 如
 //43 62 31 46 45 33 34 41 46 42 44 33 46 30 30 30 30 30 31 55 54 03
 // str2文档读取的值场地密码如000 001

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

  //根据接收到的数据判断相应情况
 //  str1 为从串口读取的值 如
 //43  65  32  37  32  31  40  03
 // str2文档读取的值场地密码如2721

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


//更新配置文件，写入使用系统次数给配置文件

function TFrm_Logon.WriteUseTimeToIniFile: boolean;
var
  myIni: TiniFile;
  UseTimes: string; //系统使用次数
begin
  Result := false;
  if (SystemWorkground.PCReCallClearTP = 'D6102') then //未注册，为原文档
  begin
       //第一次使用
    if (SystemWorkground.PLCRequestWriteTP = 'D6004') or (length(SystemWorkground.PLCRequestWriteTP) = 0) then
    begin
      SystemWorkground.PLCRequestWriteTP := '1';
      UseTimes := SystemWorkground.PLCRequestWriteTP;
      if FileExists(SystemWorkGroundFile) then
      begin
        myIni := TIniFile.Create(SystemWorkGroundFile);
        myIni.WriteString('PLC工作区域', 'PLC请求写托盘', UseTimes); //写入新的登陆次数
        SystemWorkground.PLCRequestWriteTP := MyIni.ReadString('PLC工作区域', 'PLC请求写托盘', ''); //

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
    else //不是第一次使用
    begin

      UseTimes := IntToStr(StrToInt(SystemWorkground.PLCRequestWriteTP) + 1);
             //最高试用次数为50次
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
          myIni.WriteString('PLC工作区域', 'PLC请求写托盘', SystemWorkground.PLCRequestWriteTP); //写入新的登陆次数
          UseTimes := MyIni.ReadString('PLC工作区域', 'PLC请求写托盘', ''); //

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
      end; //判断是否使用次数<50 结束
    end; //判断是否第一次使用结束
  end
  else // 注册判断的内容被修改（包括已注册、或配置文件被人为修改）
  begin //SystemWorkground.PCReCallClearTP<>'D6102'
    if (StrToInt(Copy(TrimRight(SystemWorkground.PCReCallClearTP), 1, 1)) = 2 * StrToInt(Copy(TrimRight(SystemWorkground.PCReCallClearTP), 4, 1))) and (StrToInt(Copy(TrimRight(SystemWorkground.PCReCallClearTP), 2, 1)) = 3 * StrToInt(Copy(TrimRight(SystemWorkground.PCReCallClearTP), 6, 1))) then
    begin //已注册
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
    begin //配置文件被人为修改
      Result := false;
    end;

  end;


end;


//输入登录确认

procedure TFrm_Logon.edtPasswordKeyPress(Sender: TObject; var Key: Char);
var
  High_right_Pass: string;
begin
{
  if key = #13 then
  begin

  // if not WriteUseTimeToIniFile then //如果为试用软件则提示并需要注册
  //   exit;
    High_right_Pass := 'sg3F@2011';

    //超级管理员 不校验加密狗也不校验管理卡
    // comReader.StopComm();
    // Comm_Check.StopComm();
    if edtPassword.Text = High_right_Pass then
    begin
      rootEnable := true; //进入最高权限
      LOAD_USER.ID_type := 'AA'; //卡功能
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

      Frm_IC_Main.show; //进入主界面
      Login := True;

    end
    else
    begin
      loginCheck(); //不是超级管理员
    end;
  end;
 }
end;
 //----------------------------------------以下为加密狗相关 结束---------



procedure TFrm_Logon.checkLogin();
var
  ADOQ: TADOQuery;
  strUser_ID: string;
  strSQL, strResultCode, strURL, strResponseStr: string;
  jsonApplyResult, jsonSigeLoginResult: TlkJSONbase;
  ResponseStream: TStringStream; //返回信息
  activeIdHTTP: TIdHTTP;
begin
  begin
       //加密卡认证是否通过
    if not Longon_OK then
    begin
      MessageBox(handle, '请刷您的登陆卡!', '错误', MB_ICONERROR + MB_OK);
      exit;
    end;
    //吧台号认证
    if (edtPassword.Text <> load_user.Password_USER) or (edtPassword.Text <> SGBTCONFIGURE.shopid) then
    begin
      MessageBox(handle, '请输入正确的吧台号', '错误', MB_ICONERROR + MB_OK);
      exit;
    end;


   //{关闭HK接口
    if SGBTCONFIGURE.enableInterface = '0' then
    begin
      {
      //登记SG3F运营管理系统
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
    //获取网页返回的信息   网页中的存在中文时，需要进行UTF8解码
      strResponseStr := UTF8Decode(ResponseStream.DataString);
      ICFunction.loginfo('SG3F Login Response :' + strResponseStr);
    }


            //好酷登录认证
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
    //获取网页返回的信息   网页中的存在中文时，需要进行UTF8解码
      strResponseStr := UTF8Decode(ResponseStream.DataString);

      ICFunction.loginfo('Login Response :' + strResponseStr);
      jsonApplyResult := TlkJSON.ParseText(UTF8Encode(strResponseStr)) as TlkJSONobject; //UTF8编码
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

    lblMessage.Caption := '登录成功';
   // jsonResult.Free; //这里free不需要，内存的管理不理
    loginSuccess();
    Frm_IC_Main.show; //进入主界面

  end;
end;



 //拼接签到接口URL

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



//激活请求签名算法

function TFrm_Logon.getLoginSignature(strAppID: string; strCoinlimit: string; strShopID: string; strTimeStamp: string): string;
var
  strTempC, strTempD: string;
  myMD5: TIdHashMessageDigest5;
begin
  myMD5 := TIdHashMessageDigest5.Create;
  strTempC := 'appId' + strAppID + 'coinLimit' + strCoinlimit + 'shopId' + strShopID + 'timestamp' + strTimeStamp; //按字符顺序排序
  strTempD := strTempC + SGBTCONFIGURE.secret_key; //加上secret_key
  result := LowerCase(myMD5.AsHex(myMD5.HashValue(strTempD))); //计算字符串的MD5,并返回小写
  myMD5.Free;

end;


//Sige后台登记接口

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

 //Sige后台登记接口签名算法

function TFrm_Logon.getSigeLoginSignature(appId: string; coinCost: string; coinLimit: string; secretKey: string; shopId: string; timeStamp: string): string;
var
  strTempC, strTempD: string;
  myMD5: TIdHashMessageDigest5;
begin
  myMD5 := TIdHashMessageDigest5.Create;
  strTempC := 'appId' + appId + 'coinCost' + coinCost + 'coinLimit' + coinLimit + 'secretKey' + secretKey + 'shopId' + shopId + 'timeStamp' + timestamp; //按字符顺序排序
  strTempD := strTempC + SG3FCONFIGURE.sg3fkey; //加上secret_key
  result := LowerCase(myMD5.AsHex(myMD5.HashValue(strTempD))); //计算字符串的MD5,并返回小写
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
    //and (edtPassword.Text = High_right_Pass) then //是否允许最高权限进入
  if   (edtPassword.Text = High_right_Pass) then
  begin
    LOAD_USER.ID_type := 'AA'; //卡功能
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
    Frm_IC_Main.show; //进入主界面
    Login := True;
  end
  else
  begin
    checkLogin(); //不是超级管理员
  end;
end;



end.

