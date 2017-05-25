{-----------------------------------------------------------------------------
作者：sushengmiyan 2013.01.26
备注：
功能：硬件信息获取单元
-----------------------------------------------------------------------------}

unit untApplicationHardWareInfo;

interface
uses
  Windows, SysUtils, Classes, Registry, Nb30, WinSock;

type
  TCPUID = array[1..4] of Longint;
  function GetCPUID: TCPUID; assembler; register;
type

 //CPUID信息类
 TCPUIDInfo = class
 private
   FCPUID: TCPUID;
   FCPUIDStr: string;
   procedure SetCPU(AHandle: THandle; CpuNo: Integer);
   function CPUIDTostr(ACPUID: TCPUID): string;
   function GetComputerBasicFrequency: string;
   function GetCPUType: string;
 public
   function GetCPUIDstr: string;
   property CPUFrequency: string read GetComputerBasicFrequency;
   property ProcessorType: string read GetCPUType;
   constructor Create;
 end;

 //mac地址信息类
 TMacAdressInfo = class
 private
   FMacAdress: string;
   function GetMacPhysicalAddress(Alana: Integer = 0): string;
   function GetMacAddress: string;
 public
   property MacAdrress: string read GetMacAddress;
   constructor Create;
 end;
 
 //用户信息类
 TPCUserInfo = class
 private
   function GetUserName: string;
   function GetHostIP: string;
   function GetWindowsVertion: string;
 public
   property UserName: string read GetUserName;
   property HostIP: string read GetHostIP;
   property WindowsVertion: string read GetWindowsVertion;
   constructor Create;
 end;

implementation

{ TCPUIDInfo }
{----------------------------------------------------------------------------\-
作者：sushengmiyan 2013.01.26
参数：None
返回：TCPUID
功能：汇编方式获取CPUID
\-----------------------------------------------------------------------------}

function GetCPUID: TCPUID;
asm
  PUSH    EBX         {Save affected register}
  PUSH    EDI
  MOV     EDI,EAX     {@Resukt}
  MOV     EAX,1
  DW      $A20F       {CPUID Command}
  STOSD                {CPUID[1]}
  MOV     EAX,EBX
  STOSD               {CPUID[2]}
  MOV     EAX,ECX
  STOSD               {CPUID[3]}
  MOV     EAX,EDX
  STOSD               {CPUID[4]}
  POP     EDI         {Restore registers}
  POP     EBX
end;

{----------------------------------------------------------------------------\-
作者：sushengmiyan 2013.01.26
参数：ACPUID: TCPUID
返回：string
功能：将十六进制的CPUID转换为字符串
\-----------------------------------------------------------------------------}

function TCPUIDInfo.CPUIDTostr(ACPUID: TCPUID): string;
begin
  Result := '';
  Result := IntToHex(ACPUID[1] , 8) + IntToHex(ACPUID[2] , 8) + IntToHex(ACPUID[3]
  , 8) + IntToHex(ACPUID[4] , 8);
end;

{----------------------------------------------------------------------------\-
作者：sushengmiyan 2013.01.26
参数：None
返回：string
功能：处理器类型
\-----------------------------------------------------------------------------}

function TCPUIDInfo.GetCPUType: string;
var
  systeminfo: SYSTEM_INFO;
begin
  //获得CPU型号
  GetSystemInfo(systeminfo);
  Result := IntToStr(systeminfo.dwProcessorType)
end;

{----------------------------------------------------------------------------\-
作者：sushengmiyan 2013.01.26
参数：None
返回：string
功能：CPU频率
\-----------------------------------------------------------------------------}

function TCPUIDInfo.GetComputerBasicFrequency: string;
const
  DelayTime = 500;
var
  TimerHi, TimerLo: DWORD;
  PriorityClass, Priority: Integer;
  dSpeed: Double;
begin
  PriorityClass := GetPriorityClass(GetCurrentProcess);
  Priority := GetThreadPriority(GetCurrentThread);
  SetPriorityClass(GetCurrentProcess, REALTIME_PRIORITY_CLASS);
  SetThreadPriority(GetCurrentThread, THREAD_PRIORITY_TIME_CRITICAL);
  Sleep(10);
  asm
    dw 310Fh // RDTSC指令
    mov TimerLo, eax
    mov TimerHi, edx
  end;
  Sleep(DelayTime);
  asm
    dw 310Fh // rdtsc
    sub eax, TimerLo
    sbb edx, TimerHi
    mov TimerLo, eax
    mov TimerHi, edx
  end;
  SetThreadPriority(GetCurrentThread, Priority);
  SetPriorityClass(GetCurrentProcess, PriorityClass);
  dSpeed := TimerLo / (1000.0 * DelayTime);
  Result := FormatFloat('0.00' , dSpeed / 1024) + ' GHz';
end;

{----------------------------------------------------------------------------\-
作者：sushengmiyan 2013.01.26
参数：AOwner: TComponent
返回：None
功能：初始化
\-----------------------------------------------------------------------------}

constructor TCPUIDInfo.Create;
begin
  FCPUID := GetCPUID;
  FCPUIDStr := CPUIDTostr(FCPUID);
end;

{----------------------------------------------------------------------------\-
作者：sushengmiyan 2013.01.26
参数：None
返回：string    CPUID字符串
功能：对外函数，调用这个方法就能得到CPUID
\-----------------------------------------------------------------------------}

function TCPUIDInfo.GetCPUIDstr: string;
begin
  SetCPU(GetCurrentProcess , 1);
  Result := CPUIDTostr(GetCPUID);
end;

{----------------------------------------------------------------------------\-
作者：sushengmiyan 2013.01.26
参数：AHandle: THandle; CpuNo: Integer
返回：None
功能：设置使用哪个cpu默认是第一个（推荐）
\-----------------------------------------------------------------------------}

procedure TCPUIDInfo.SetCPU(AHandle: THandle; CpuNo: Integer);
var
  ProcessAffinity: Cardinal;
  _SystemAffinity: Cardinal;
begin
  //通过设置进程或线程的亲缘性（affinity），使进程或线程在指定的CPU（核）上运行
  GetProcessAffinityMask(AHandle , ProcessAffinity, _SystemAffinity) ;
  ProcessAffinity := CpuNo;
  SetProcessAffinityMask(AHandle , ProcessAffinity);
end;

{ TMacAdressInfo }
{----------------------------------------------------------------------------\-
作者：sushengmiyan 2013.01.26
参数：None
返回：None
功能：初始化
\-----------------------------------------------------------------------------}

constructor TMacAdressInfo.Create;
begin
  FMacAdress := GetMacPhysicalAddress;
end;

{----------------------------------------------------------------------------\-
作者：sushengmiyan 2013.01.26
参数：None
返回：string
功能：返回Mac地址
\-----------------------------------------------------------------------------}

function TMacAdressInfo.GetMacAddress: string;
begin
  Result := FMacAdress;
end;

{----------------------------------------------------------------------------\-
作者：sushengmiyan 2013.01.26
参数：Alana: Integer = 0
返回：string
功能：通过LANA号获取Mac物理地址 （内存方式获取），整体步骤如下：
    一、枚举系统上可用的所有LANA编号
    二、重置计划使用的每个LANA编号
    三、适配器命令获取网卡地址
\-----------------------------------------------------------------------------}

function TMacAdressInfo.GetMacPhysicalAddress(Alana: Integer = 0): string;
var
  NCB: TNCB;//Netbios控制块
  AdapterStatus: TAdapterStatus;//取网卡状态
  LanaEnum: TLanaEnum; //LANA枚举值
  I: Integer;
begin
  Result := '';
  Try
  { http://blog.csdn.net/sushengmiyan/article/details/8543811
    一、枚举LANA值
      ①.申请分配一个TNCB结构           NCB: TNCB；
      ②.将TNCB结构变量初始化成O        ZeroMemory(@NCB , SizeOf(NCB));
      ③.置命令为NCBENUM                NCB.ncb_Command := chr(NCBENUM);
      ④.为ncb_buffer分配LANA_ENUM      NCB.ncb_buffer := @LANAENUM;
      ⑤.为NCB_length制定长度           NCB.NCB_length := Sizeof(LANAENUM);
      ⑥.调用Netbios函数获取Netbios     CRC := NetBios(@NCB);
      ⑦.返回值NRC_GOODRET表示成功      NCB.ncb_retcode = Chr(NRC_GOODRET)
    }
    ZeroMemory(@NCB , SizeOf(NCB));
    NCB.ncb_Command := Chr(NCBENUM);
    NCB.ncb_buffer := @LANAENUM;
    NCB.NCB_length := Sizeof(LANAENUM);
    NetBios(@NCB);
    if not (NCB.ncb_retcode = Chr(NRC_GOODRET)) then Exit;


  { http://blog.csdn.net/sushengmiyan/article/details/8543811
    二、重置计划使用的每个LANA编号
      ①.申请分配一个TNCB结构           NCB: TNCB；
      ②.将TNCB结构变量初始化成O        ZeroMemory(@NCB , SizeOf(NCB));
      ③.置命令为NCBRESET               NCB.ncb_Command := chr(NCBRESET);
      ④.给命令设置LANA编号             NCB.ncb_lana_num := LanaEnum.lana[Alana];
      ⑤.调用Netbios函数获取Netbios     CRC := NetBios(@NCB);
      ⑥.返回值NRC_GOODRET表示成功      NCB.ncb_retcode = Chr(NRC_GOODRET)
    }
    ZeroMemory(@NCB , SizeOf(NCB));
    NCb.ncb_Command := Chr(NCBRESET);
    NCB.ncb_lana_num := LanaEnum.lana[Alana];
    Netbios(@NCB);
    if not (NCB.ncb_retcode = Chr(NRC_GOODRET)) then Exit;

   { http://blog.csdn.net/sushengmiyan/article/details/8543811
    三、使用TAdapterStatus结构获取网卡地址
      ①.申请分配一个TNCB结构           NCB: TNCB；
      ②.将TNCB结构变量初始化成O        ZeroMemory(@NCB , SizeOf(NCB));
      ③.置命令为NCBASTAT               NCB.ncb_Command := chr(NCBASTAT);
      ④.为ncb_buffer分配LANA_ENUM      NCB.ncb_buffer := @LANAENUM;
      ⑤.设置ncb_callname               NCB.ncb_callname := '* ' + #0;
      ⑥.为ncb_buffer分配AdapterStatus  NCB.ncb_buffer := @AdapterStatus;
      ⑦.为NCB_length制定长度           NCB.NCB_length := Sizeof(AdapterStatus);
      ⑧.调用Netbios函数获取Netbios     CRC := NetBios(@NCB);
    }
    ZeroMemory(@NCB , SizeOf(NCB));
    NCb.ncb_Command := chr(NCBASTAT);
    NCB.ncb_lana_num := LANAENUM.lana[Alana];
    NCB.ncb_callname[0] := '*';
    //不明白为何如此设置，*代表啥子？
    //有懂的可以邮件分享 429119108@qq.com   O(∩_∩)O谢谢
    NCB.ncb_buffer := @AdapterStatus;
    NCB.ncb_length := SizeOf(AdapterStatus);
    NetBios(@NCB);

    //获取形如AA-BB-CC-DD-EE-FF形式的mac物理地址字符串
    Result := '';
    for I := 0 to 5 do
   // if SameStr(Result , '') then
   //   Result := Result + IntToHex(Integer(AdapterStatus.adapter_address[I]) , 2)
  //  else
      Result := Result + '-' + IntToHex(Integer(AdapterStatus.adapter_address[I]) , 2);
  Finally

  End;
end;

{ TPCUserInfo }


{----------------------------------------------------------------------------\-
作者：sushengmiyan 2013.01.26
参数：None
返回：None
功能：创建
\-----------------------------------------------------------------------------}

constructor TPCUserInfo.Create;
begin

end;

{----------------------------------------------------------------------------\-
作者：sushengmiyan 2013.01.26
参数：None
返回：string
功能：得到主机IP
\-----------------------------------------------------------------------------}
//这个有问题，编译不通过
function TPCUserInfo.GetHostIP: string;
var
  sHostName: string;
  WSAData: TWSAData;
  HostEnt: PHostEnt;
begin
 {
  sHostName := UserName;
  Result := '';
  WSAStartup(2 , WSAData);
  HostEnt := GetHostByName(PChar(sHostName));
  if HostEnt <> nil then
  begin
    with HostEnt^ do
      Result:= Format('%d.%d.%d.%d', [Byte(h_addr^[0]) , Byte(h_addr^[1]), Byte(h_addr^[2]) , Byte(h_addr^[3])]);
　  end;
　WSACleanup;
}
end;

{----------------------------------------------------------------------------\-
作者：sushengmiyan 2013.01.26
参数：None
返回：None
功能：获取用户名
\-----------------------------------------------------------------------------}

function TPCUserInfo.GetUserName;
var
  Name: PChar;
  Size: DWORD;
begin
  GetMem(Name , 255);//申请内存
  Size := 255;
  GetComputerName(Name , Size);
  Result := Name;
  FreeMem(Name); //记得释放内存
end;

{----------------------------------------------------------------------------\-
作者：sushengmiyan 2013.01.26
参数：None
返回：string
功能：返回操作系统类型
\-----------------------------------------------------------------------------}

function TPCUserInfo.GetWindowsVertion: string;
  function GetWindowsVersionString: string;
  var
    oSVersion: TOSVersionInfoA;
  begin
    Result := '';
    oSversion.dwOSVersionInfoSize := SizeOf(TOSVersionInfoA);
    if GetVersionExA(oSVersion) then
      with oSVersion do
        Result := Trim(Format('%s', [szCSDVersion]));
  end;
var
  AWin32Version: Extended;
  sWin: string;
begin
  sWin := 'Windows';
  AWin32Version := StrToFloat(Format('%d.%d', [Win32MajorVersion, Win32MinorVersion]));
  case Win32Platform of
    VER_PLATFORM_WIN32s:
      Result := sWin + '32';
    VER_PLATFORM_WIN32_WINDOWS:
    begin
      if AWin32Version = 4.0 then
        Result := sWin + '95'
      else if AWin32Version = 4.1 then
        Result := sWin + '98'
      else if AWin32Version = 4.9 then
        Result := sWin + 'Me'
      else
        Result := sWin + '9x';
    end;
    VER_PLATFORM_WIN32_NT:
    begin
      if AWin32Version = 3.51 then
        Result := sWin + 'NT 3.51'
      else if AWin32Version = 4.0 then
        Result := sWin + 'NT 4.0'
      else if AWin32Version = 5.0 then
        Result := sWin + '2000'
      else if AWin32Version = 5.1 then
        Result := sWin + 'XP'
      else if AWin32Version = 5.2 then
        Result := sWin + '2003'
      else if AWin32Version = 6.0 then
        Result := sWin + 'Vista'
      else if AWin32Version = 6.1 then
        Result := sWin + '7'
      else
        Result := sWin;
    end
    else
      Result := sWin;
  end;
  Result := Result + '  ' + GetWindowsVersionString;
end;

end.
