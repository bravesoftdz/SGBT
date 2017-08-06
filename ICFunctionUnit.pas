unit ICFunctionUnit;

interface
uses Forms, Windows, SysUtils, Registry, Classes, Math, IniFiles, StdCtrls, StrUtils, Dialogs, StandardDES;

type
  TICFunction = class
    procedure InitSystemWorkPath;
    procedure InitSystemWorkground;

    function TransStringToFloat(S: string): Real;
    function TransStringToInteger(S: string): Integer;
    function TranslateMeasureDataToValue(Chal: TPoint; V: Real): Real;

    procedure SaveSystemGroundMessageTerm(TermName, FieldName, Value: string);
    function IsCheckOverTime(ST: TLargeInteger; CK: integer): Boolean;
    procedure DelayForHeighFreq(WT: integer);
    function CheckTextIsNumber(S: string): Boolean;
    //procedure GetUnitMessageForName(var Eu:PLC_UnitType; UName: string);
    function ValIsNumber(Strv: string): Boolean;
    procedure SaveSystemParameterTerm(Term, SubTerm, Value: string);
    procedure AddShowItemToMemo(Memo: TMemo; strItem: string);
    procedure DeleteChr(strv: string);
    function BintoInt(Value: string): LongInt;
  //  function AscToDec(strValue: String): Array of integer ;
    function IntToBin(Value: LongInt; Size: Integer): string;
    function Str_IntToBin(Int: LongInt; Size: Integer): string;
    function Str_HexToInt(Hex: string): integer;
    function Str_StrToChar(Str: string): Char;
    procedure ClearIDinfor;
    function SUANFA_ID_3F(StrCheckSum: string): string;
    function SUANFA_Password_3F(StrCheckSum: string): string;
    procedure INITCONT;
    function CHECK_3F_ID(StrCheckSum: string; ID_3F: string; Password_3F: string): boolean;
    function SUANFA_Password_USER(StrCheckSum: string; Str_Boss: string): string;
    function SUANFA_Password_USER_WritetoID(StrCheckSum: string; Str_Boss: string): string;
    function CHECK_Customer_ID_USERINIT(StrCheckSum: string; BossPassword_3F: string): boolean;
    function CHECK_Customer_ID_3FINIT(StrCheckSum: string; BossPassword_3F: string): boolean;
    function CHECK_3F_ID_BossInit(StrCheckSum: string; ID_3F: string; Password_3F: string): boolean;
    function ChangeAreaStrToHEX(arr: string): string;
    function ChangeAreaToStr(arr: array of integer; Len: integer): string;
    function ChangeAreaHEXToStr(orderStr: string): string;
    function GetInvalidDate(StrDate: string): string;
    function GetInvalidDate_after(strDate: string): string;


    function transferCheckSumByte(StrCheckSum: string): string;
    function funcTransferExchData(orderStr: string): string;
    function checkSUMData(orderStr: string): string; //计算校验和

    function transferDECValueToHEXByte(StrIncValue: string): string;
    function transferHEXByteToDECValue(StrIncValue: string): string;
    procedure loginfo(strTemp: string);
    function transferTypeNameToTypeID(StrIDtype: string): string;
    function transferTypeIDToTypeName(strTypeName: string): string;
    function getInitValueByTypeName(strTypeName: string): string;
    function getInitShopIDByTypeName(strTypeName: string): string;

  private
    //function GetUnitMessage(UMsg: string): PLC_UnitType;
    function GetSysPath(var PathStr: string): Boolean;

    { Private declarations }
  public
    { Public declarations }

  end;

var
  ICFunction: TICFunction;


implementation

uses ICCommunalConstUnit, ICCommunalVarUnit, Frontoperate_InitIDUnit;



procedure TICFunction.InitSystemWorkPath;
var
  a: array[0..100] of char;
begin
  if not GetSysPath(SystemPath) then
    GetDir(0, SystemPath); { 0 = Current drive }
  if SystemPath[Length(SystemPath)] = '\' then
    SystemPath := Copy(SystemPath, 1, Length(SystemPath) - 1);

  SystemMainPath := SystemPath;
  if SystemPath[Length(SystemPath)] <> '\' then
    SystemMainPath := SystemMainPath + '\';
    //工作路径设置
  //SystemWorkGroundFile := 'C:\WINDOWS\system32\wbem\System64.Ini';

  SystemWorkGroundFile := 'D:\SGBT.ini';
  ProgramPath := SystemMainPath + 'Program\';
  ProgramIsTestFile := SystemMainPath + 'LLC.JNYH';
  GetSystemDirectory(a, sizeof(a));
  PasswordFile := StrPas(a) + '\WindowsLLC.sys';
end;

procedure TICFunction.SaveSystemGroundMessageTerm(TermName, FieldName: string; Value: string);
var
  MyIni: TIniFile;
begin
  MyIni := TiniFile.Create(SystemWorkGroundFile);
  MyIni.WriteString(TermName, FieldName, Value);

  MyIni.UpdateFile;
  MyIni.Free;
end;

function TICFunction.GetSysPath(var PathStr: string): Boolean;
var
  RegFile: TRegIniFile;
begin
  Result := false;
  RegFile := TRegIniFile.Create;
  Regfile.RootKey := HKEY_LOCAL_MACHINE;
  if RegFile.KeyExists('\Software\JNYH_LPT') then begin
    PathStr := RegFile.ReadString('\Software\JNYH_LPT', 'InstallPath', 'c:\JNYH_LPT');
    ChDir(PathStr);
    Result := true;
  end;
end;

procedure TICFunction.InitSystemWorkground;
var
  MyIni: TIniFile;
  iStart, i: Integer;
  strTemp: string;
  strCopyone: string;
begin
  strTemp := '';
  if FileExists(SystemWorkGroundFile) then begin
    MyIni := TiniFile.Create(SystemWorkGroundFile);
    SystemWorkground.DB_Provider := MyIni.ReadString('DB设置', '驱动', '');
    SystemWorkground.DB_DatabaseName := MyIni.ReadString('DB设置', '数据库', '');
    SystemWorkground.DB_Path := MyIni.ReadString('DB设置', '存放位置', '');
    SystemWorkground.DatabaseConnectType := MyIni.ReadString('DB设置', '数据连接', ''); //1为本地连接 0为远程连接
    SystemWorkground.IPAddress := MyIni.ReadString('DB设置', 'IP地址', ''); //后台IP
    if SystemWorkground.DB_Path = '' then SystemWorkground.DB_Path := SystemMainPath + 'System';
    SystemWorkground.DB_StoreTime := MyIni.ReadInteger('DB设置', '数据保留时间', 30);
    SystemWorkground.DB_UpdateTime := MyIni.ReadString('DB设置', '数据清理时间', '2006-1-1');

    SystemWorkground.PLC_CommSet.Port := MyIni.ReadInteger('PLC串口设置', '端口', 1);

    SystemWorkground.PLC_CommSet.Setting := MyIni.ReadString('PLC串口设置', '参数', '9600,N,8,1');

    SystemWorkground.ReadID.Port := MyIni.ReadInteger('读卡设置', '端口', 2);
    SystemWorkground.ReadID.Setting := MyIni.ReadString('读卡设置', '参数', '9600,N,8,1');
    SystemWorkground.ReadID.Area := '0000' + MyIni.ReadString('读卡设置', '区域', '0000');
    iStart := Length(SystemWorkground.ReadID.Area);
    SystemWorkground.ReadID.Area := Copy(SystemWorkground.ReadID.Area, iStart - 3, 4);
    SystemWorkground.ReadID.IDLength := MyIni.ReadInteger('读卡设置', '长度', 60);
    SystemWorkground.ClearTPCS := MyIni.ReadInteger('读卡设置', '读次数', 1);
    SystemWorkground.WriteTPCS := MyIni.ReadInteger('读卡设置', '写次数', 1);

    SystemWorkground.WriteID.Port := MyIni.ReadInteger('写卡设置', '端口', 2);
    SystemWorkground.WriteID.Setting := MyIni.ReadString('写卡设置', '参数', '9600,N,8,1');
    SystemWorkground.WriteID.Area := MyIni.ReadString('写卡设置', '区域', '0000');
    iStart := Length(SystemWorkground.WriteID.Area);
    SystemWorkground.WriteID.Area := Copy(SystemWorkground.WriteID.Area, iStart - 3, 4);
    SystemWorkground.WriteID.IDLength := MyIni.ReadInteger('写卡设置', '长度', 60);

    //读出PLC的交互区域

    SystemWorkground.PLCRequestFDJ := MyIni.ReadString('PLC工作区域', 'PLC请求发动机', 'D6000');
    SystemWorkground.PCReCallRequestFDJ := MyIni.ReadString('PLC工作区域', 'PC回应请求发动机', 'D6100');
    SystemWorkground.PLCRequestClearTP := MyIni.ReadString('PLC工作区域', 'PLC请求清托盘', 'D6002');
    SystemWorkground.PCReCallClearTP := MyIni.ReadString('PLC工作区域', 'PC回应清托盘', 'D6102');
    SystemWorkground.PLCRequestWriteTP := MyIni.ReadString('PLC工作区域', 'PLC请求写托盘', 'D6004');
    SystemWorkground.PCReCallWriteTP := MyIni.ReadString('PLC工作区域', 'PC回应写托盘', 'D6104');

    SystemWorkground.PCWriteLD := MyIni.ReadString('PLC工作区域', 'PC写入料道号', 'D6020');
    SystemWorkground.PCReadFanHao := MyIni.ReadString('PLC工作区域', 'PC读出番号', 'D6250');
    SystemWorkground.PCWriteFanHao := MyIni.ReadString('PLC工作区域', 'PC写入番号', 'D6021');
    SystemWorkground.PCWriteType := MyIni.ReadString('PLC工作区域', 'PC写入机型', 'D6025');
    SystemWorkground.PCWriteTZ := MyIni.ReadString('PLC工作区域', 'PC写入特征码', 'D6040');
    SystemWorkground.PCReadFDJ := MyIni.ReadString('PLC工作区域', 'PC读出机型', 'D6254');
    SystemWorkground.PCReadTZ := MyIni.ReadString('PLC工作区域', 'PC读出特征码', 'D6270');
    SystemWorkground.PCReadLS := MyIni.ReadString('PLC工作区域', 'PC读出流水', 'D6276');
    SystemWorkground.PCReadYear := MyIni.ReadString('PLC工作区域', 'PC读出年', 'D6283');

    SystemWorkground.PCRun := MyIni.ReadString('PLC工作区域', 'PC运行', 'D6106');
    SystemWorkground.PLCRun := MyIni.ReadString('PLC工作区域', 'PLC运行', 'D6006');
    SystemWorkground.HaveJH := MyIni.ReadString('PLC工作区域', '有计划', 'D6108'); //2无计划，1有计划
    SystemWorkground.LOAD_Check_time := MyIni.ReadString('卡出厂设置', '通信设定测试', 'aaaa');


    SystemWorkground.ErrorGTState := MyIni.ReadString('PLC工作区域', 'PLC缸体报废标志', 'D6010');


    SystemWorkground.PCErrorGTFlag := MyIni.ReadString('PLC工作区域', 'PC接收报废标志', 'D6110');
    SystemWorkground.exchangerate := MyIni.ReadString('PLC工作区域', 'exchangerate', '1');
    //---------增加年----------
    strTemp := FormatDateTime('YYYY', Now);
    CurYear := MyIni.ReadString('YearStyle', strTemp, 'A');


    //---------3F出厂前设置----------
    INit_3F.ID_INIT := MyIni.ReadString('卡出厂设置', '卡片ID', '');
    INit_3F.ID_3F := MyIni.ReadString('卡出厂设置', '卡厂ID', '');
    INit_3F.Password_3F := MyIni.ReadString('卡出厂设置', '场地卡密', '');
    INit_3F.Password_USER := MyIni.ReadString('卡出厂设置', '用户密码', '');
    INit_3F.ID_value := MyIni.ReadString('卡出厂设置', '卡内数据', '');
    INit_3F.ID_type := MyIni.ReadString('卡出厂设置', '卡功能', '');
    INit_3F.ID_CheckNum := MyIni.ReadString('卡出厂设置', '校验和', '');
    INit_3F.ID_Settime := MyIni.ReadString('卡出厂设置', '设定时间', '');
    INit_3F.Name_USER := MyIni.ReadString('PLC串口设置', '参数', 'SG3F');


     //--------------RFID 卡类型开始------------

    INit_Wright.Produecer_3F := '万能卡,AA';
//    INit_Wright.BOSS := '老板卡,BB';
    INit_Wright.MANEGER := '管理卡,4A';
    INit_Wright.QUERY := '查帐卡,5E';
//    INit_Wright.RECV_CASE := '会员卡,CA';
    INit_Wright.SETTING := '设置卡,72';
//    INit_Wright.OPERN := '开机卡,DD';
    INit_Wright.OPERN := '老板卡,DD'; //老板开机卡
    INit_Wright.User := '用户卡,A5';

    //--------------RFID 卡类型结束------------


    INit_Wright.MenberControl_long := MyIni.ReadString('PLC工作区域', 'PC系统管理', '系统会员制管理设定'); //D6021的最后一个字符为设定值，1为采用，0不采用
    INit_Wright.MenberControl_short := Copy(INit_Wright.MenberControl_long, 5, 1); //D6021的最后一个字符为设定值，1为采用，0不采用

    INit_Wright.CustomerNO := MyIni.ReadString('PLC工作区域', 'PC客户编号', '客户编号');
    INit_Wright.BossPassword := MyIni.ReadString('PLC工作区域', 'PC托盘特征码', '新密码');
    INit_Wright.BossPassword_old := MyIni.ReadString('PLC工作区域', 'PC读出特征码', '旧密码');
    INit_Wright.BossPassword_3F := MyIni.ReadString('PLC工作区域', 'PC写入特征码', '根据客户编号计算3F出厂初始化');

    INit_Wright.MaxValue := MyIni.ReadString('PLC工作区域', 'PC运行', '500');
    iHHSet := StrToInt(Copy(MyIni.ReadString('卡出厂设置', '设定期限', '152419'), 3, 2));
    strCopyone := Copy(INit_Wright.BossPassword, 1, 1);

    BarCodeFirstFrame[0] := Copy(INit_Wright.BossPassword, 1, 2);
    BarCodeFirstFrame[1] := Copy(INit_Wright.BossPassword, 3, 2);
    BarCodeFirstFrame[2] := '35';
    BarCodeFirstFrame[3] := '36';
    BarCodeFirstFrame[4] := '37';


     //--------------RFID 开始------------
     //写指令的头
    CMD_COUMUNICATION.CMD_INCValue := '51';
    CMD_COUMUNICATION.CMD_INCValue_RE := '53';
    CMD_COUMUNICATION.CMD_READ := '43';

  //--------------RFID 开始------------


  //--------------加密卡 登陆开始------------
    CMD_COUMUNICATION.CMD_HAND := '61'; //握手
    CMD_COUMUNICATION.CMD_USERPASSWORD := '64'; //读场地密码
    CMD_COUMUNICATION.CMD_3FPASSWORD := '62'; //读系统编号
    CMD_COUMUNICATION.CMD_3FLODADATE := '65'; //读最后一次登陆时间
  //--------------加密卡 登陆结束------------
  //--------------加密卡 出厂初始化开始------------
    CMD_COUMUNICATION.CMD_HAND_RE := '61'; //握手
    CMD_COUMUNICATION.CMD_USERPASSWORD_RE := '68'; // 写系统编号
    CMD_COUMUNICATION.CMD_3FPASSWORD_RE := '66'; //   写场地密码
    CMD_COUMUNICATION.CMD_WRITETOFLASH_Sub_RE := '7A'; //写反馈辅助
    CMD_COUMUNICATION.CMD_3FLODADATE_RE := '69'; //写最后一次登陆时间
  //--------------加密卡 出厂初始化结束------------





  //----------SGBT智能手环20170210----------------------//
    SGBTCONFIGURE.appid := DecryStrHex(MyIni.ReadString('SGBTCONFIGURE', 'appid', '000001'), 'master@sg3f');
    SGBTCONFIGURE.shopid := DecryStrHex(MyIni.ReadString('SGBTCONFIGURE', 'shopid', '888888'), 'master@sg3f');
    SGBTCONFIGURE.coinlimit := DecryStrHex(MyIni.ReadString('SGBTCONFIGURE', 'coinLimit', '1000'), 'master@sg3f');
//    SGBTCONFIGURE.coincost :=  DecryStrHex(MyIni.ReadString('SGBTCONFIGURE', 'coincost', '10'), 'master@sg3f');
    SGBTCONFIGURE.secret_key := DecryStrHex(MyIni.ReadString('SGBTCONFIGURE', 'secret_key', 'hksc'), 'master@sg3f');
    SGBTCONFIGURE.enableInterface := DecryStrHex(MyIni.ReadString('SGBTCONFIGURE', 'enableInterface', '0'), 'master@sg3f');
    SGBTCONFIGURE.enableHigh := DecryStrHex(MyIni.ReadString('SGBTCONFIGURE', 'enableHigh', '0'), 'master@sg3f');
    SGBTCONFIGURE.registerCode := DecryStrHex(MyIni.ReadString('SGBTCONFIGURE', 'registerCode', '0'), 'master@sg3f');
        
    SGBTCONFIGURE.hkscurl := MyIni.ReadString('SGBTCONFIGURE', 'hkscurl', '');
    SGBTCONFIGURE.bindurl := MyIni.ReadString('SGBTCONFIGURE', 'bindurl', '');
    SGBTCONFIGURE.signurl := MyIni.ReadString('SGBTCONFIGURE', 'signurl', '');
    SGBTCONFIGURE.activeurl := MyIni.ReadString('SGBTCONFIGURE', 'activeurl', '');
    SGBTCONFIGURE.offlinepayapplyurl := MyIni.ReadString('SGBTCONFIGURE', 'offlinepayapplyurl', '');
    SGBTCONFIGURE.offlinepayackurl := MyIni.ReadString('SGBTCONFIGURE', 'offlinepayackurl', '');
    SGBTCONFIGURE.onlinepayapplyurl := MyIni.ReadString('SGBTCONFIGURE', 'onlinepayapplyurl', '');
    SGBTCONFIGURE.onlinepayackurl := MyIni.ReadString('SGBTCONFIGURE', 'onlinepayackurl', '');
    SGBTCONFIGURE.coindatauploadurl := MyIni.ReadString('SGBTCONFIGURE', 'coindatauploadurl', '');



  //----------SGBT智能手环20170210----------------------//
    SG3FCONFIGURE.sg3fenable := DecryStrHex(MyIni.ReadString('SG3FCONFIGURE', 'sg3fenable', '0'), 'master@sg3f');
    SG3FCONFIGURE.sg3fkey := DecryStrHex(MyIni.ReadString('SG3FCONFIGURE', 'sg3fkey', '0'), 'master@sg3f');
    SG3FCONFIGURE.sg3furl := DecryStrHex(MyIni.ReadString('SG3FCONFIGURE', 'sg3furl', '0'), 'master@sg3f');
    SG3FCONFIGURE.sg3floginurl := DecryStrHex(MyIni.ReadString('SG3FCONFIGURE', 'sg3floginurl', '0'), 'master@sg3f');

  //----------SG3F ERROR INFO 20170327----------------------//
     SG3FERRORINFO.networkerror :=MyIni.ReadString('SG3FERRORINFO', 'networkerror', '0');
     SG3FERRORINFO.commerror := MyIni.ReadString('SG3FERRORINFO', 'commerror', '0');
     SG3FERRORINFO.error_register_code := MyIni.ReadString('SG3FERRORINFO', 'error_register_code', '0');

   //SGBT电子币配置
   SGBTCOININFO.coinproportion:=MyIni.ReadString('SGBTCOININFO','coinproportion','1');

    rootEnable := false;  //进入最高权限



   //----------SGBT智能手环20170210----------------------//


    configureExist := TRUE;
  end
  else
  begin
    configureExist := FALSE;
    loginfo('配置文件不存在');
    exit;
  end;

  SystemWorkGround.ClearStr := '';
  for i := 1 to SystemWorkground.ReadID.IDLength do begin
    SystemWorkGround.ClearStr := SystemWorkGround.ClearStr + '0';
  end;
end;

//将字符串转化为串口能够发送的16进制字符串（如要发送“123”，分解为“1”“2”“3”，
//对应16进制转换为“31”“32”“33”，综合为“313233”）

function TICFunction.ChangeAreaStrToHEX(arr: string): string;
var
  strTemp: string;
  reTmpStr: string;
  i: integer;
begin
  for i := 1 to Length(arr) do
  begin
    strTemp := IntToHex(Ord(arr[i]), 2);
    reTmpStr := reTmpStr + strTemp;
  end;
  Result := reTmpStr;
end;

function TICFunction.TransStringToFloat(S: string): Real;
var
  rtn: Real;
begin
  if S = '' then
    rtn := 0
  else begin
    try
      rtn := StrToFloat(S);
    except
      rtn := 0;
    end;
  end;

  Result := rtn;
end;

function TICFunction.TranslateMeasureDataToValue(Chal: TPoint; V: Real): Real;
var
  rtn: Real;
begin
  rtn := 0;
{
  case Chal.X of
    1 : rtn := (V * SystemWorkground.OMeasure[Chal.Y].TransValue - SystemWorkground.OMeasure[Chal.Y].WorkBase) + SystemWorkground.OMeasure[Chal.Y].StandardValue;
    2 : rtn := (V * SystemWorkground.IMeasure_Second[Chal.Y].TransValue - SystemWorkground.IMeasure_Second[Chal.Y].WorkBase) + SystemWorkground.IMeasure_Second[Chal.Y].StandardValue;
    3 : rtn := (V * SystemWorkground.IMeasure_First[Chal.Y].TransValue - SystemWorkground.IMeasure_First[Chal.Y].WorkBase) + SystemWorkground.IMeasure_First[Chal.Y].StandardValue;
    end;
}
  Result := rtn;
end;

function TICFunction.TransStringToInteger(S: string): Integer;
var
  rtn: Integer;
begin
  if S = '' then
    rtn := 0
  else begin
    try
      rtn := StrToInt(S);
    except
      rtn := 0;
    end;
  end;

  Result := rtn;
end;

function TICFunction.CheckTextIsNumber(S: string): Boolean;
var
  i: integer;
  rtn: Boolean;
begin
  rtn := True;
  for i := 1 to Length(S) do begin
    if ((S[i] < '0') or (S[i] > '9')) and (S[i] <> '.') and (S[i] <> '-') then begin
      rtn := False;
      break;
    end;
  end;

  Result := rtn;
end;

//CK=等待时间 毫秒

function TICFunction.IsCheckOverTime(ST: TLargeInteger; CK: integer): Boolean;
var
  CurrentTime: TLargeInteger;
  Counter: Real;
begin
  QueryPerFormanceCounter(CurrentTime);
  Counter := (CurrentTime - ST) / WorkTimeFreq * 1000;

  Result := (Counter > CK);
end;

procedure TICFunction.DelayForHeighFreq(WT: integer);
var
  TrigStopWorkTimeStart: TLargeInteger;
  WorkTimeCurrent: TLargeInteger;
  WorkTaskValue: Real;
begin
  //启动任务高精度计数器
  WorkTimeFreq := 100;
  QueryPerFormanceCounter(TrigStopWorkTimeStart);
  QueryPerFormanceCounter(WorkTimeCurrent);
  WorkTaskValue := (WorkTimeCurrent - TrigStopWorkTimeStart) / WorkTimeFreq;

  while WorkTaskValue <= WT do begin
    if (EndApplication) then break;
    QueryPerFormanceCounter(WorkTimeCurrent);
    WorkTaskValue := (WorkTimeCurrent - TrigStopWorkTimeStart) / WorkTimeFreq * 1000;
    Application.ProcessMessages;
  end;
end;





function TICFunction.ValIsNumber(Strv: string): Boolean;
var
  i, iAddPos, iDecPos, iDotCount, iAddCount, iDecCount: integer;
  BRet: Boolean;
begin
  BRet := True;
  iAddPos := 0;
  iDecPos := 0;
  iDotCount := 0;
  iAddCount := 0;
  iDecCount := 0;
  for i := 1 to Length(Strv) do begin
    if not (Strv[i] in ['0'..'9', '-', '+', '.']) then begin
      BRet := False;
      break;
    end;
    if (Strv[i] = '-') then begin
      iDecCount := iDecCount + 1;
      iDecPos := i;
    end;
    if (Strv[i] = '+') then begin
      iAddCount := iAddCount + 1;
      iAddPos := i;
    end;
    if (Strv[i] = '.') then begin
      iDotCount := iDotCount + 1;
    end;
  end;
  if ((iAddCount > 1) or (iDecCount > 1) or (iDotCount > 1) or (iAddPos > 1) or (iDecPos > 1)) then begin
    BRet := False;
  end;
  Result := BRet;
end;

procedure TICFunction.SaveSystemParameterTerm(Term, SubTerm, Value: string);
var
  MyIni: TIniFile;
begin
  MyIni := TiniFile.Create(SystemWorkGroundFile);
  MyIni.WriteString(Term, SubTerm, Value);

  MyIni.UpdateFile;
  MyIni.Free;
end;



procedure TICFunction.AddShowItemToMemo(Memo: TMemo; strItem: string);
begin
  if (Memo.Lines.Count > 7) then begin
    Memo.Lines.Delete(0);
  end;
  Memo.Lines.Add(strItem + '  检测');
end;

//清除字符串中的#0

procedure TICFunction.DeleteChr(strv: string);
var
  iStart: integer;

begin
  iStart := Pos(Chr(0), strv);
  while (iStart > 0) do begin
    Delete(strv, iStart, 1);
    iStart := Pos(Chr(0), strv);
  end;
end;


function TICFunction.BintoInt(Value: string): LongInt;
var
  i, Size: Integer;
begin
  Result := 0;
  Size := Length(Value);
  for i := Size downto 1 do
  begin
    if Copy(Value, i, 1) = '1' then
      Result := Result + (1 shl (Size - i));
  end;
end;


//十进制 to 二进制

function TICFunction.IntToBin(Value: LongInt; Size: Integer): string;
var
  i: Integer;
begin
  Result := '';
  for i := Size - 1 downto 0 do begin
    if Value and (1 shl i) <> 0 then begin
      Result := Result + '0';
    end else begin
      Result := Result + '1';
    end;
  end;
end;

//将一个十进制整型转换成二进制值 参数说明：Int:被转换的整型值
//Size:转换后的宽度：4位 8位 或更大

function TICFunction.Str_IntToBin(Int: LongInt; Size: Integer): string;
var
  i: Integer;
begin
  if Size < 1 then Exit;
  for i := Size downto 1 do
  begin
    if Int and (1 shl (Size - i)) <> 0 then
      Result := '1' + Result
    else
      Result := '0' + Result;
  end;
end;

//将一个十六进制的值转换成整型 参数说明：Hex:被转换的十六进制值

function TICFunction.Str_HexToInt(Hex: string): integer;
var
  HexDigital: set of char;
  i: integer;
  Digital: string;
begin
  Result := 0;
  HexDigital := ['1', '2', '3', '4', '5', '6', '7', '8', '9', '0', 'A', 'B',
    'C', 'D', 'E', 'F', 'a', 'b', 'c', 'd', 'e', 'f'];
  if Length(Hex) = 0 then Exit;
  for i := 1 to Length(Hex) do
  begin
    Digital := Copy(Hex, i, 1);
    if (i = 1) and (digital = '$') then Continue;
    if not (Str_StrToChar(Digital) in HexDigital) then Exit;
  end;
  Digital := Copy(Hex, 1, 1);
  if Digital <> '$' then Hex := '$' + Hex;
  Result := StrToInt(Hex);
end;

//将单个字符的串转换成字符 参数说明：Str:被转换的串

function TICFunction.Str_StrToChar(Str: string): Char;
begin
  Result := #0;
  if Length(Str) = 0 then exit;
  if Length(Str) > 1 then exit;
  Result := Str[1];
end;


//清除从ID卡读取的相关信息

procedure TICFunction.ClearIDinfor;
begin

  Receive_CMD_ID_Infor.CMD := '';
  Receive_CMD_ID_Infor.ID_INIT := '';
  Receive_CMD_ID_Infor.ID_3F := '';
  Receive_CMD_ID_Infor.Password_3F := '';
  Receive_CMD_ID_Infor.Password_USER := '';
  Receive_CMD_ID_Infor.ID_value := '';
  Receive_CMD_ID_Infor.ID_type := '';
  Receive_CMD_ID_Infor.ID_CheckNum := '';
  Receive_CMD_ID_Infor.ID_Settime := '';
end;



//卡厂ID算法

function TICFunction.SUANFA_ID_3F(StrCheckSum: string): string;
var
  Byte1, Byte2, Byte3: integer;
  temp, tempTOTAL1, tempTOTAL2, tempTOTAL3: integer; //2147483648 最大范围

begin

  tempTOTAL1 := strToint('$' + Copy(StrCheckSum, 1, 2)) + strToint('$' + Copy(StrCheckSum, 3, 2)) + strToint('$' + Copy(StrCheckSum, 5, 2)) * strToint('$' + Copy(StrCheckSum, 7, 2));

  Byte1 := (tempTOTAL1 * tempTOTAL1) mod 16; // 第二字节
  Byte2 := (tempTOTAL1 * tempTOTAL1) div 16; //第二字节
  Byte3 := tempTOTAL1; //第一字节
  result := copy(IntToHex(Byte2, 2), length(IntToHex(Byte2, 2)) - 1, 2) + copy(IntToHex(Byte3, 2), length(IntToHex(Byte3, 2)) - 1, 2) + copy(IntToHex(Byte1, 2), length(IntToHex(Byte1, 2)) - 1, 2);

end;

//场地密码算法 StrCheckSum卡厂ID，strCUSTOMER_NO卡密

function TICFunction.SUANFA_Password_3F(StrCheckSum: string): string;
var
  Byte1, Byte2, Byte3: integer;
  temp, tempTOTAL1, tempTOTAL2, tempTOTAL3: integer; //2147483648 最大范围

begin



  tempTOTAL1 := strToint('$' + Copy(StrCheckSum, 1, 2)) * strToint('$' + Copy(StrCheckSum, 3, 2)) + strToint('$' + Copy(StrCheckSum, 5, 2)); //ID_3F输入

  Byte1 := (tempTOTAL1 * tempTOTAL1) mod 16; ; //第一字节
  Byte2 := (tempTOTAL1 * tempTOTAL1) div 16; //第二字节
  Byte3 := tempTOTAL1; //第二字节
  result := copy(IntToHex(Byte1, 2), length(IntToHex(Byte1, 2)) - 1, 2) + copy(IntToHex(Byte2, 2), length(IntToHex(Byte2, 2)) - 1, 2) + copy(IntToHex(Byte3, 2), length(IntToHex(Byte3, 2)) - 1, 2);

end;


  //ID卡身份识别

function TICFunction.CHECK_3F_ID(StrCheckSum: string; ID_3F: string; Password_3F: string): boolean;
var
  ID_3F_1: string;
  ID_3F_2: string;
  ID_3F_3: string;
  PWD_3F_1: string;
  PWD_3F_2: string;
  PWD_3F_3: string;
  tempTOTAL1: integer;
  tempTOTAL2: integer;

  Byte1, Byte2, Byte3, Byte4, Byte5, Byte6: integer;
begin

       //StrCheckSum:='2A2542CB';
  ID_3F_1 := copy(ID_3F, 3, 2);
  ID_3F_2 := copy(Password_3F, 3, 2);
  ID_3F_3 := copy(Password_3F, 1, 2);


  PWD_3F_1 := copy(Password_3F, 5, 2);
  PWD_3F_2 := copy(ID_3F, 5, 2);
  PWD_3F_3 := copy(ID_3F, 1, 2);


    //卡厂ID
  tempTOTAL1 := strToint('$' + Copy(StrCheckSum, 1, 2)) + strToint('$' + Copy(StrCheckSum, 3, 2)) + strToint('$' + Copy(StrCheckSum, 5, 2)) * strToint('$' + Copy(StrCheckSum, 7, 2));
  Byte1 := (tempTOTAL1 * tempTOTAL1) mod 16;
  Byte2 := (tempTOTAL1 * tempTOTAL1) div 16;
  Byte3 := tempTOTAL1;

    //Byte2  Byte3  Byte1

  Result := true;
//    if (ID_3F_1<>copy(IntToHex(Byte2,2),length(IntToHex(Byte2,2))-2,2))then
//20121103修改
  if (ID_3F_1 <> copy(IntToHex(Byte2, 2), length(IntToHex(Byte2, 2)) - 1, 2)) then
    Result := false; //第一字节
  if (ID_3F_2 <> copy(IntToHex(Byte3, 2), length(IntToHex(Byte3, 2)) - 1, 2)) then
    Result := false; //第二字节
  if (ID_3F_3 <> copy(IntToHex(Byte1, 2), length(IntToHex(Byte1, 2)) - 1, 2)) then
    Result := false; //第三字节


         //卡厂密码
  tempTOTAL2 := strToint('$' + Copy(StrCheckSum, 1, 2)) * strToint('$' + Copy(StrCheckSum, 3, 2)) + strToint('$' + Copy(StrCheckSum, 5, 2));
  Byte4 := (tempTOTAL2 * tempTOTAL2) mod 16;
  Byte5 := (tempTOTAL2 * tempTOTAL2) div 16;
  Byte6 := tempTOTAL2;


end;


  //在场地初始化功能时调用，主要是验证 卡厂ID，卡厂密码

function TICFunction.CHECK_3F_ID_BossInit(StrCheckSum: string; ID_3F: string; Password_3F: string): boolean;
var
  ID_3F_1: string;
  ID_3F_2: string;
  ID_3F_3: string;
  PWD_3F_1: string;
  PWD_3F_2: string;
  PWD_3F_3: string;
  tempTOTAL1: integer;
  tempTOTAL2: integer;

  Byte1, Byte2, Byte3, Byte4, Byte5, Byte6: integer;
begin

       //StrCheckSum:='2A2542CB';
  ID_3F_1 := copy(ID_3F, 3, 2);
  ID_3F_2 := copy(Password_3F, 3, 2);
  ID_3F_3 := copy(Password_3F, 1, 2);


  PWD_3F_1 := copy(Password_3F, 5, 2);
  PWD_3F_2 := copy(ID_3F, 5, 2);
  PWD_3F_3 := copy(ID_3F, 1, 2);


    //卡厂ID
  tempTOTAL1 := strToint('$' + Copy(StrCheckSum, 1, 2)) + strToint('$' + Copy(StrCheckSum, 3, 2)) + strToint('$' + Copy(StrCheckSum, 5, 2)) * strToint('$' + Copy(StrCheckSum, 7, 2));
  Byte1 := (tempTOTAL1 * tempTOTAL1) mod 16;
  Byte2 := (tempTOTAL1 * tempTOTAL1) div 16;
  Byte3 := tempTOTAL1;

    //Byte2  Byte3  Byte1

  Result := true;
 //   if (ID_3F_1<>copy(IntToHex(Byte2,2),length(IntToHex(Byte2,2))-2,2))then
//20121103修改
  if (ID_3F_1 <> copy(IntToHex(Byte2, 2), length(IntToHex(Byte2, 2)) - 1, 2)) then
    Result := false; //第一字节
  if (ID_3F_2 <> copy(IntToHex(Byte3, 2), length(IntToHex(Byte3, 2)) - 1, 2)) then
    Result := false; //第二字节
  if (ID_3F_3 <> copy(IntToHex(Byte1, 2), length(IntToHex(Byte1, 2)) - 1, 2)) then
    Result := false; //第三字节


         //卡厂密码
  tempTOTAL2 := strToint('$' + Copy(StrCheckSum, 1, 2)) * strToint('$' + Copy(StrCheckSum, 3, 2)) + strToint('$' + Copy(StrCheckSum, 5, 2));
  Byte4 := (tempTOTAL2 * tempTOTAL2) mod 16;
  Byte5 := (tempTOTAL2 * tempTOTAL2) div 16;
  Byte6 := tempTOTAL2;


//    if (PWD_3F_1<>copy(IntToHex(Byte4,2),length(IntToHex(Byte4,2))-2,2))then
//         Result := false; //第一字节
//    if (PWD_3F_2<>copy(IntToHex(Byte5,2),length(IntToHex(Byte5,2))-2,2))then
//         Result := false; //第二字节
//    if (PWD_3F_3<>copy(IntToHex(Byte6,2),length(IntToHex(Byte6,2))-2,2))then
//         Result := false;//第三字节
//20121103修改
  if (PWD_3F_1 <> copy(IntToHex(Byte4, 2), length(IntToHex(Byte4, 2)) - 1, 2)) then
    Result := false; //第一字节
  if (PWD_3F_2 <> copy(IntToHex(Byte5, 2), length(IntToHex(Byte5, 2)) - 1, 2)) then
    Result := false; //第二字节
  if (PWD_3F_3 <> copy(IntToHex(Byte6, 2), length(IntToHex(Byte6, 2)) - 1, 2)) then
    Result := false; //第三字节
end;

  //ID卡身份识别

procedure TICFunction.INITCONT;
begin
  strtemp1 := '3F';
  strtemp2 := 'F3';
  strtemp3 := '0A';
  strtemp4 := '0D';
  strtemp5 := '07';
end;
//以下此函数在3F出厂初始化时调用，生成场地初始秘密
// 在此生出的场地密码，在老板拿到3F卡后进行场地初始化前需要识别此身份，也就是解码
//（解码函数为function TICFunction.CHECK_Customer_ID_3FINIT(StrCheckSum: string;BossPassword_3F: string):boolean;）
// INit_Wright.BossPassword:= MyIni.ReadString('PLC工作区域','PC托盘特征码','D60993');
//场地密码算法(根据老板在场地密码设定画面输入的密码，
//转换为存储在myIni.WriteString('PLC工作区域','PC托盘特征码',INit_Wright.BossPassword);)

function TICFunction.SUANFA_Password_USER(StrCheckSum: string; Str_Boss: string): string;
var
  Byte1, Byte2, Byte3: integer;
  temp, tempTOTAL1, tempTOTAL2, tempTOTAL3: integer; //2147483648 最大范围
begin
    //tempTOTAL1:=strToint('$'+Copy(Str_Boss,3,2))*strToint('$'+Copy(StrCheckSum,5,2))+strToint('$'+Copy(Str_Boss,5,2))*strToint('$'+Copy(StrCheckSum,1,2))+strToint('$'+Copy(Str_Boss,1,2))*strToint('$'+Copy(StrCheckSum,7,2));
  tempTOTAL1 := strToint('$' + Copy(Str_Boss, 3, 2)) + strToint('$' + Copy(Str_Boss, 1, 2)) * strToint('$' + Copy(StrCheckSum, 1, 2)) + strToint('$' + Copy(Str_Boss, 1, 2)) * strToint('$' + Copy(StrCheckSum, 5, 2));

  Byte1 := (tempTOTAL1 * tempTOTAL1) mod 16; // 第二字节
  Byte2 := (tempTOTAL1 * tempTOTAL1) div 16; //第二字节
  Byte3 := tempTOTAL1; //第一字节
    //Byte2  Byte3  Byte1
  result := copy(IntToHex(Byte3, 2), length(IntToHex(Byte3, 2)) - 2, 2) + copy(IntToHex(Byte1, 2), length(IntToHex(Byte1, 2)) - 1, 2) + copy(IntToHex(Byte2, 2), length(IntToHex(Byte2, 2)) - 1, 2);

end;

//以下此函数在老板进行场地密码初始化时调用，
//解码函数function TICFunction.CHECK_Customer_ID_USERINIT(StrCheckSum: string;BossPassword_3F: string):boolean;
//ICFunction.SUANFA_Password_USER(INit_3F.ID_3F,CUSTOMER_NO);
// INit_Wright.BossPassword_3F:= MyIni.ReadString('PLC工作区域','PC写入特征码','312014');
//其中 PC写入特征码=312014是人工写入文件的

//场地密码算法(老板根据上面的SUANFA_Password_USER()函数生成的场地密码，生成写入ID卡的场地密码)

function TICFunction.SUANFA_Password_USER_WritetoID(StrCheckSum: string; Str_Boss: string): string;
var
  Byte1, Byte2, Byte3: integer;
  temp, tempTOTAL1, tempTOTAL2, tempTOTAL3: integer; //2147483648 最大范围
begin
  //  tempTOTAL1:=strToint('$'+Copy(Str_Boss,5,2))*strToint('$'+Copy(StrCheckSum,3,2))+strToint('$'+Copy(Str_Boss,3,2))*strToint('$'+Copy(StrCheckSum,1,2))+strToint('$'+Copy(Str_Boss,1,2))*strToint('$'+Copy(StrCheckSum,7,2));
  tempTOTAL1 := strToint('$' + Copy(Str_Boss, 1, 2)) + strToint('$' + Copy(Str_Boss, 3, 2)) * strToint('$' + Copy(StrCheckSum, 1, 2)) + strToint('$' + Copy(Str_Boss, 1, 2)) * strToint('$' + Copy(StrCheckSum, 3, 2));

  Byte1 := (tempTOTAL1 * tempTOTAL1) mod 16; // 第二字节
  Byte2 := (tempTOTAL1 * tempTOTAL1) div 16; //第二字节
  Byte3 := tempTOTAL1; //第一字节
    //Byte2  Byte3  Byte1
  result := copy(IntToHex(Byte3, 2), length(IntToHex(Byte3, 2)) - 2, 2) + copy(IntToHex(Byte1, 2), length(IntToHex(Byte1, 2)) - 1, 2) + copy(IntToHex(Byte2, 2), length(IntToHex(Byte2, 2)) - 1, 2);
end;

//CHECK_Customer_ID(Receive_CMD_ID_Infor.ID_INIT,INit_Wright.BossPassword)
//老板拿到新的3F出厂初始化完毕的卡，首次进行ID卡场地密码识别,与3F输入初始化的场地密码比较

function TICFunction.CHECK_Customer_ID_3FINIT(StrCheckSum: string; BossPassword_3F: string): boolean;
var
  BossPassword_3F_1: string;
  BossPassword_3F_2: string;
  BossPassword_3F_3: string;
  tempTOTAL1: integer;
  CUSTOMER_NO: string;

  Byte1, Byte2, Byte3, Byte4, Byte5, Byte6: integer;
begin
    //BossPassword_3F是3F出厂初始化时设定的BossPassword_USER场地密码
  BossPassword_3F_1 := copy(BossPassword_3F, 1, 2);
  BossPassword_3F_2 := copy(BossPassword_3F, 3, 2);
  BossPassword_3F_3 := copy(BossPassword_3F, 5, 2);

    //根据 INit_Wright.BossPassword_3F:= MyIni.ReadString('PLC工作区域','PC写入特征码','312014');
    //此值是在文档SystemWorkGround.ini中人工输入的客户编号
  CUSTOMER_NO := INit_Wright.BossPassword_3F;

    //卡厂ID
  tempTOTAL1 := strToint('$' + Copy(CUSTOMER_NO, 3, 2)) + strToint('$' + Copy(CUSTOMER_NO, 1, 2)) * strToint('$' + Copy(StrCheckSum, 1, 2)) + strToint('$' + Copy(CUSTOMER_NO, 1, 2)) * strToint('$' + Copy(StrCheckSum, 5, 2));
  Byte1 := (tempTOTAL1 * tempTOTAL1) mod 16; // 第二字节
  Byte2 := (tempTOTAL1 * tempTOTAL1) div 16; //第二字节
  Byte3 := tempTOTAL1; //第一字节

    //Byte2  Byte3  Byte1
  Result := true;
  if (BossPassword_3F_1 <> copy(IntToHex(Byte3, 2), length(IntToHex(Byte3, 2)) - 2, 2)) then
    Result := false; //第一字节
  if (BossPassword_3F_2 <> copy(IntToHex(Byte1, 2), length(IntToHex(Byte1, 2)) - 1, 2)) then
    Result := false; //第二字节
  if (BossPassword_3F_3 <> copy(IntToHex(Byte2, 2), length(IntToHex(Byte2, 2)) - 1, 2)) then
    Result := false; //第三字节
end;

//老板拿到新的3F出厂初始化完毕的卡，首次进行ID卡场地密码识别,与3F输入初始化的场地密码比较

function TICFunction.CHECK_Customer_ID_USERINIT(StrCheckSum: string; BossPassword_3F: string): boolean;
var
  BossPassword_3F_1: string;
  BossPassword_3F_2: string;
  BossPassword_3F_3: string;
  tempTOTAL1: integer;
  CUSTOMER_NO: string;

  Byte1, Byte2, Byte3, Byte4, Byte5, Byte6: integer;
begin
    //BossPassword_3F是3F出厂初始化时设定的BossPassword_USER场地密码
  BossPassword_3F_1 := copy(BossPassword_3F, 1, 2);
  BossPassword_3F_2 := copy(BossPassword_3F, 3, 2);
  BossPassword_3F_3 := copy(BossPassword_3F, 5, 2);

    //根据 INit_Wright.BossPassword_3F:= MyIni.ReadString('PLC工作区域','PC读出特征码','312014');
    //此值是在文档SystemWorkGround.ini中人工输入的客户编号
  CUSTOMER_NO := INit_Wright.BossPassword_old;

    //卡厂ID
  tempTOTAL1 := strToint('$' + Copy(CUSTOMER_NO, 1, 2)) + strToint('$' + Copy(CUSTOMER_NO, 3, 2)) * strToint('$' + Copy(StrCheckSum, 1, 2)) + strToint('$' + Copy(CUSTOMER_NO, 1, 2)) * strToint('$' + Copy(StrCheckSum, 3, 2));

  Byte1 := (tempTOTAL1 * tempTOTAL1) mod 16; // 第二字节
  Byte2 := (tempTOTAL1 * tempTOTAL1) div 16; //第二字节
  Byte3 := tempTOTAL1; //第一字节

    //Byte2  Byte3  Byte1
  Result := true;
  if (BossPassword_3F_1 <> copy(IntToHex(Byte3, 2), length(IntToHex(Byte3, 2)) - 2, 2)) then
    Result := false; //第一字节
  if (BossPassword_3F_2 <> copy(IntToHex(Byte1, 2), length(IntToHex(Byte1, 2)) - 1, 2)) then
    Result := false; //第二字节
  if (BossPassword_3F_3 <> copy(IntToHex(Byte2, 2), length(IntToHex(Byte2, 2)) - 1, 2)) then
    Result := false; //第三字节
end;

//将从串口获取的16进制形式字符串转换为ASII码字符串

function TICFunction.ChangeAreaHEXToStr(orderStr: string): string;
var
  ii, jj: integer;
  reTmpStr, tmpStr: string;
  arr: array of integer;
begin
  //要两个两个字符串截取（如从串口获取的‘3031’，则截取为‘30’‘31’）

  reTmpStr := '';
  SetLength(arr, 1); //设定数组长度为1
  for ii := 1 to (length(orderStr) div 2) do
  begin
    tmpStr := copy(orderStr, ii * 2 - 1, 2);
    jj := strToint('$' + tmpStr);
    arr[0] := jj;
    reTmpStr := reTmpStr + ChangeAreaToStr(arr, 1); //调用10进制数组转化为ASII码字符串函数
  end;

  result := reTmpStr;
end;

//将数字数组中的内容转化为ASII码

function TICFunction.ChangeAreaToStr(arr: array of integer; Len: integer): string;
var
  strTemp, strV, strV2: string;
  i, iRet: integer;
begin
  strV2 := IntToStr(0) + IntToStr(0);
  for i := 1 to Len do begin
    if (arr[i - 1] = 0) then continue;
    strTemp := IntToHex(arr[i - 1], 2);
    iRet := HexToBin(PChar(strTemp), PChar(strV2), 2);
    if (iRet > 1) then
      strV := strV + strV2[2] + strV2[1]
    else
      strV := strV + strV2[1];
  end;
  Result := strV;
end;


//取得现在时间的前一天日期

function TICFunction.GetInvalidDate(StrDate: string): string;
var
  strtemp: string;
  iYear, iMonth, iDate, iHH, iMin, iSecond, iHHSet_temp: integer;
  jYear, jMonth, jDate, jHH, jMin, jSecond, jHHSet_temp: string;
begin

  iHHSet_temp := 24;
  strtemp := StrDate;
  iYear := strToint(Copy(strtemp, 1, 4)); //年
  iMonth := strToint(Copy(strtemp, 6, 2)); //月
  iDate := strToint(Copy(strtemp, 9, 2)); //日
  iHH := strToint(Copy(strtemp, 12, 2)); //小时
  iMin := strToint(Copy(strtemp, 15, 2)); //分钟
  iSecond := strToint(Copy(strtemp, 18, 2)); //秒

  if (iHHSet_temp > 47) then
  begin

    exit;
  end;
  if ((iHH + iHHSet_temp) >= 24) and ((iHH + iHHSet_temp) < 48) then
  begin
        //iHH:=(iHH+iHHSet_temp)-24;//取得新的小时
    if (iYear < 1930) then
    begin

      exit;
    end;
    if (iMonth = 3) then
    begin
      if ((iYear mod 4) = 0) or ((iYear mod 100) = 0) then //闰年 2月为28日
      begin
        if (iDate = 1) then
        begin
          iDate := 28;
          iMonth := iMonth - 1;
        end
        else
        begin
          iDate := iDate - 1;
        end;
      end
      else //不是闰年  2月为29日
      begin
        if (iDate = 1) then
        begin
          iDate := 29;
          iMonth := iMonth - 1;
        end
        else
        begin
          iDate := iDate - 1;
        end;
      end;
    end
    else if (iMonth = 12) or (iMonth = 5) or (iMonth = 7) or (iMonth = 8) or (iMonth = 10) then
    begin
      if (iDate = 1) then
      begin
        iDate := 30;
        iMonth := iMonth - 1;
      end
      else
      begin
        iDate := iDate - 1;
      end;
    end

    else if (iMonth = 1) then
    begin
      if (iDate = 1) then
      begin
        iDate := 31;
        iMonth := 12;
        iYear := iYear - 1;
      end
      else
      begin
        iDate := iDate - 1;
      end;
    end
    else if (iMonth = 2) then
    begin
      if (iDate = 1) then
      begin
        iDate := 31;
        iMonth := 1;
      end
      else
      begin
        iDate := iDate - 1;
      end;
    end
    else if (iMonth = 4) or (iMonth = 6) or (iMonth = 9) or (iMonth = 11) then
    begin
      if (iDate = 1) then
      begin
        iDate := 31;
        iMonth := iMonth - 1;
      end
      else
      begin
        iDate := iDate - 1;
      end;
    end;
  end;

  if iMonth < 10 then
    jMonth := '0' + inttostr(iMonth)
  else
    jMonth := inttostr(iMonth);

  if iDate < 10 then
    jDate := '0' + inttostr(iDate)
  else
    jDate := inttostr(iDate);

  if iHH < 10 then
    jHH := '0' + inttostr(iHH)
  else
    jHH := inttostr(iHH);


  if iMin < 10 then
    jMin := '0' + inttostr(iMin)
  else
    jMin := inttostr(iMin);

  if iSecond < 10 then
    jSecond := '0' + inttostr(iSecond)
  else
    jSecond := inttostr(iSecond);

  Result := inttostr(iYear) + '-' + jMonth + '-' + jDate + ' ' + jHH + ':' + jMin + ':' + jSecond;

end;

//944->4409 高低位互换
//112-->1201 高低位互换
//1234 -->3412

function TICFunction.transferCheckSumByte(StrCheckSum: string): string;
var
  j: integer;
  tempLH, tempLL: integer; //2147483648 最大范围

begin

  j := strToint('$' + StrCheckSum); //将字符转转换为16进制数，然后转换位10进制

  tempLH := (j mod 65536) div 256; //字节LH

  tempLL := j mod 256; //字节LL


  result := IntToHex(tempLL, 2) + IntToHex(tempLH, 2);

end;


//计算校验和，长度必须是偶数位，否则报传入参数长度错误(38)

function TICFunction.checkSUMData(orderStr: string): string;
var
  i, j, k: integer;
  TmpStr: string;
  reTmpStr: string;
begin
  if (length(orderStr) mod 2) <> 0 then
  begin
    Loginfo('Parameter error !');
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



//充值10进制数据转换成16进制并排序 字节LL、字节LH、字节HL、字节HH
//100 -->64000000 200-->2C010000

function TICFunction.transferDECValueToHEXByte(StrIncValue: string): string;
var
  tempLH, tempHH, tempHL, tempLL: integer; //2147483648 最大范围
begin
  tempHH := StrToint(StrIncValue) div 16777216; //字节HH
  tempHL := (StrToInt(StrIncValue) mod 16777216) div 65536; //字节HL
  tempLH := (StrToInt(StrIncValue) mod 65536) div 256; //字节LH
  tempLL := StrToInt(StrIncValue) mod 256; //字节LL

  result := IntToHex(tempLL, 2) + IntToHex(tempLH, 2) + IntToHex(tempHL, 2) + IntToHex(tempHH, 2);
end;


//将16进制并排序 字节LL、字节LH、字节HL、字节HH好的字符串转还原为充值数据
//跟 transferIncrValueByte 函数相反

function TICFunction.transferHEXByteToDECValue(StrIncValue: string): string;
var
  tempLH, tempHH, tempHL, tempLL, tempTotal: integer; //2147483648 最大范围
begin
  tempHH := strToint('$' + Copy(StrIncValue, 7, 2)); //字节HH
  tempHL := strToint('$' + Copy(StrIncValue, 5, 2)); //字节HL
  tempLH := strToint('$' + Copy(StrIncValue, 3, 2)); //字节LH
  tempLL := strToint('$' + Copy(StrIncValue, 1, 2)); //字节LL

  tempTotal := tempHH * 16777216 + tempHL * 65536 + tempLH * 256 + tempLL;
  result := IntToStr(tempTotal);
end;


//转换发送数据格式 ??

function TICFunction.funcTransferExchData(orderStr: string): string;
var
  i, j: integer;
  TmpStr: string;
  reTmpStr: string;
begin
  if (length(orderStr) = 0) then
  begin
    //MessageBox(handle, '传入参数不能为空!', '错误', MB_ICONERROR + MB_OK);
    result := '';
    exit;
  end;
  if (length(orderStr) mod 2) <> 0 then
  begin
    //MessageBox(handle, '传入参数错误!', '错误', MB_ICONERROR + MB_OK);
    result := '';
    exit;
  end;
  for i := 1 to (length(orderStr) div 2) do
  begin
    tmpStr := copy(orderStr, i * 2 - 1, 2);
    j := strToint('$' + tmpStr);
    reTmpStr := reTmpStr + chr(j);
  end;
  result := reTmpStr;
end;



//取得有效时间日期 后一天或几天

function TICFunction.GetInvalidDate_after(strDate: string): string;
var
  strtemp: string;
  iYear, iMonth, iDate, iHH, iMin, iSecond: integer;
  iHHSet_temp: integer;
begin


  strtemp := strDate;
  iYear := strToint(Copy(strtemp, 1, 4)); //年
  iMonth := strToint(Copy(strtemp, 6, 2)); //月
  iDate := strToint(Copy(strtemp, 9, 2)); //日
  iHH := strToint(Copy(strtemp, 12, 2)); //小时
  iMin := strToint(Copy(strtemp, 15, 2)); //分钟
  iSecond := strToint(Copy(strtemp, 18, 2)); //秒
  iHHSet_temp := 24;

  if ((iHH + iHHSet_temp) >= 24) and ((iHH + iHHSet_temp) < 48) then
  begin
    iHH := (iHH + iHHSet_temp) - 24; //取得新的小时
    if (iYear < 1930) then
    begin
      exit;
    end;
    if (iMonth = 2) then
    begin
      if ((iYear mod 4) = 0) or ((iYear mod 100) = 0) then //闰年 2月为28日
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
      else //不是闰年  2月为29日
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
  else if ((iHH + iHHSet_temp) < 24) then
  begin
    iHH := (iHH + iHHSet_temp); //取得新的小时
  end;

  Result := inttostr(iYear) + '-' + inttostr(iMonth) + '-' + inttostr(iDate) + ' ' + inttostr(iHH) + ':' + inttostr(iMin) + ':' + inttostr(iSecond);

end;


function TICFunction.transferTypeNameToTypeID(StrIDtype: string): string;
begin
  if (StrIDtype = copy(INit_Wright.User, 1, 6)) then //用户卡
    result := copy(INit_Wright.User, 8, 2) //返回A5
  else if (StrIDtype = copy(INit_Wright.OPERN, 1, 6)) then //老板开机卡
    result := copy(INit_Wright.OPERN, 8, 2) //返回DD
  else if (StrIDtype = copy(INit_Wright.SETTING, 1, 6)) then //设置卡
    result := copy(INit_Wright.SETTING, 8, 2) //返回72
  else if (StrIDtype = copy(INit_Wright.MANEGER, 1, 6)) then
    result := copy(INit_Wright.MANEGER, 8, 2);

end;


function TICFunction.transferTypeIDToTypeName(strTypeName: string): string;
begin
  if (strTypeName = copy(INit_Wright.User, 8, 2)) then //用户卡
    result := copy(INit_Wright.User, 1, 6) //返回A5
  else if (strTypeName = copy(INit_Wright.OPERN, 8, 2)) then //老板开机卡
    result := copy(INit_Wright.OPERN, 1, 6) //返回DD
  else if (strTypeName = copy(INit_Wright.SETTING, 8, 2)) then //设置卡
    result := copy(INit_Wright.SETTING, 1, 6) //返回72
  else if (strTypeName = copy(INit_Wright.MANEGER, 8, 2)) then //采集卡
    result := copy(INit_Wright.MANEGER, 1, 6); //返回4A


end;

//根据TypeName返回初始化的ID_Value
function TICFunction.getInitValueByTypeName(strTypeName: string): string;
begin
  if (strTypeName = copy(INit_Wright.User, 1, 6)) then //用户卡
    result :=  '0'//返回A5
  else if (strTypeName = copy(INit_Wright.OPERN, 1, 6)) then //老板开机卡
    result :=SGBTCONFIGURE.coinlimit //返回DD
//  else if (strTypeName = copy(INit_Wright.SETTING, 1, 6)) then //设置卡
  //  result := SGBTCONFIGURE.coincost
  else if (strTypeName = copy(INit_Wright.MANEGER, 1, 6)) then //采集卡
    result := '0'; //返回4A


end;

//根据TypeName返回初始化的ID_Value
function TICFunction.getInitShopIDByTypeName(strTypeName: string): string;
begin
  if (strTypeName = copy(INit_Wright.User, 1, 6)) then //用户卡
    result :=  SGBTCONFIGURE.shopid//返回A5
  else if (strTypeName = copy(INit_Wright.OPERN, 1, 6)) then //老板开机卡
    result :=SGBTCONFIGURE.shopid //返回DD
  else if (strTypeName = copy(INit_Wright.SETTING, 1, 6)) then //设置卡
//    result := FormatDateTime('ddhhmm', now)
      result :=SGBTCONFIGURE.shopid //返回DD
  else if (strTypeName = copy(INit_Wright.MANEGER, 1, 6)) then //采集卡
    result := SGBTCONFIGURE.shopid; //返回4A


end;







procedure TICFunction.loginfo(strTemp: string);
var
  F: Textfile;
  strmessage, FileName: string;
begin

 //发布版需要注释掉日志函数
  //	{
  FileName := 'C:\sgbt.log';
  if fileExists(FileName) then
  begin
    AssignFile(F, FileName);
    Append(F);
  end
  else
  begin
    AssignFile(F, FileName);
    ReWrite(F);
  end;
  strmessage := formatdatetime('yyyy-mm-dd hh:nn:ss', now()) + '  ' + strTemp;
  Writeln(F, strmessage);
  Closefile(F);
//}

end;



end.

