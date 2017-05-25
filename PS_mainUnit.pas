unit PS_mainUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, Buttons, OleCtrls, MSCommLib_TLB,
  ACTCOMLKLib_TLB;

type
  TFrm_PS_Main = class(TForm)
    Panel2: TPanel;
    Panel17: TPanel;
    Panel16: TPanel;
    PageControl1: TPageControl;
    TabSheet2: TTabSheet;
    M_Behindoperate_Startwork: TBitBtn;
    M_Behindoperate_MCtest: TBitBtn;
    M_Behindoperate_SetPara: TBitBtn;
    M_Behindoperate_softexit: TBitBtn;
    Panel1: TPanel;
    Image1: TImage;
    Label_Title3: TLabel;
    Label_Title2: TLabel;
    Label_Title1: TLabel;
    Panel18: TPanel;
    Panel_Client: TPanel;
    Panel_Cur: TPanel;
    Panel_Next: TPanel;
    Panel_JHNum: TPanel;
    Panel_CurNum: TPanel;
    MsComm_Read: TMSComm;
    M_Behindoperate_Recordquery: TBitBtn;
    Timer1: TTimer;
    Timer_Init: TTimer;
    Panel_PCStatus: TPanel;
    Panel_PLCStatus: TPanel;
    Panel_PLCWorkStatus: TPanel;
    Panel_PartName: TPanel;
    Panel_None3: TPanel;
    ListBox_Event: TListBox;
    ActQJ71C241: TActQJ71C24;
    Mscomm_Write: TMSComm;
    Panel_None4: TPanel;
    Panel_None5: TPanel;
    procedure M_Behindoperate_SetParaClick(Sender: TObject);
    procedure M_Behindoperate_softexitClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure M_Behindoperate_RecordqueryClick(Sender: TObject);
    procedure M_Behindoperate_StartworkClick(Sender: TObject);
    procedure M_Behindoperate_MCtestClick(Sender: TObject);
    procedure MsComm_ReadComm(Sender: TObject);
    procedure Mscomm_WriteComm(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure Timer_InitTimer(Sender: TObject);
  private
    { Private declarations }
    procedure InitMsComm; //初始化通信端口，用于RFID读写
    procedure InitPanel;  //初始化相关信息
    procedure WaitSleep(iSleep:integer); //等待
    procedure StartThread;    //开始线程
    procedure SetWorkState(state:String);//设置工作状态

    Procedure StartWork;  //开始工作
    //procedure SetEquipment(bColor:Boolean);
    procedure WriteHaveJiHua;    //写计划
  public
    { Public declarations }
    procedure WriteID(strv:String;r_w:String);  //写ID
    procedure ReadID(strv:String;r_w:String);   //读ID

    procedure AddState(state:String);      //将相关信息写到画面
    procedure SetXH(xh:String);//设置型号
    procedure SetXH2(xh2:String);//设置特征码
    procedure EndThread;           //结束线程
    Function IsWorkState:Boolean;     //读取PLC的运行状态，在线程中会调用
  end;

var
  Frm_PS_Main: TFrm_PS_Main;

implementation

uses IR_EGtypeIncUnit,PS_MCtestUnit,PS_RecordUnit
,ICPLCCommunicationUnit,ICWorkThreadUnit
  ,ICCommunalVarUnit,ICDataModule,Logon;

{$R *.dfm}                
//系统设置
procedure TFrm_PS_Main.M_Behindoperate_SetParaClick(Sender: TObject);
VAR
  iInterval:Cardinal;
  //iCount:integer;
  //strCount:String;
begin
  iInterval:=Timer1.Interval; //记录当前的TIMENER1的定时设定值
  Timer1.Interval := 0;  //临时重新设定定时值为0

  InitPanel;   //初始化
  EndThread;
  frm_PS_SetParame.Top := Panel_Client.Top+32;
  frm_PS_SetParame.Left:=Panel_Client.Left;
  frm_PS_SetParame.Height := Panel_Client.Height;
  frm_PS_SetParame.ShowModal;

  //更新后，要看是不是有计划，这样便于写入PLC，以备PLC检查,在这个时候好，否则写入后，PLC要查的晚些开始不启作用
  WriteHaveJiHua;

  Timer1.Interval := iInterval;
end;

procedure TFrm_PS_Main.M_Behindoperate_softexitClick(Sender: TObject);
begin
   close;
end;

procedure TFrm_PS_Main.FormCreate(Sender: TObject);
begin
  IsExit:=False;
  Timer_init.Enabled := True;
end;

procedure TFrm_PS_Main.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  IsExit:=True;
  While(WorkThread<>nil) do begin
    WorkThread.Terminate;
    Application.ProcessMessages;
    Sleep(100);
    end;
  try
    ICPLCCommunication.ClosePLC;
  Except
    End;
//  Application.Terminate;   会关掉整个线程
end;

procedure TFrm_PS_Main.M_Behindoperate_RecordqueryClick(Sender: TObject);
VAR
  iInterval:Cardinal;
begin
  iInterval:=Timer1.Interval;
  Timer1.Interval := 0;

  EndThread;
  frm_PS_Record.Top := Panel_Client.Top+32;
  frm_PS_Record.Left:=Panel_Client.Left;
  frm_PS_Record.Height := Panel_Client.Height;
  frm_PS_Record.ShowModal;

  Timer1.Interval:=iInterval;
end;

procedure TFrm_PS_Main.M_Behindoperate_StartworkClick(Sender: TObject);
begin
  //Timer1.Enabled := False;
  StartWork;
end;

procedure TFrm_PS_Main.M_Behindoperate_MCtestClick(Sender: TObject);
VAR
  iInterval:Cardinal;
begin
  iInterval:=Timer1.Interval;
  Timer1.Interval := 0;

  EndThread;
  frm_PS_MCtest.Top := Panel_Client.Top+32;
  frm_PS_MCtest.Left:=Panel_Client.Left;
  frm_PS_MCtest.Height := Panel_Client.Height;
  frm_PS_MCtest.ShowModal;

  Timer1.Interval := iInterval;
end;

//打开RFID通信串口
procedure TFrm_PS_Main.InitMsComm;
begin
  if(Mscomm_Read.PortOpen) then
    MsComm_Read.PortOpen := False;
    MsComm_Read.CommPort := SystemWorkground.ReadID.Port;
    MsComm_Read.Settings := SystemWorkground.ReadID.Setting;
  try
    MsComm_Read.PortOpen := True;
  Except
  End;

  if(Mscomm_Write.PortOpen) then
    Mscomm_Write.PortOpen := False;
    Mscomm_Write.CommPort := SystemWorkground.WriteID.Port;
    Mscomm_Write.Settings := SystemWorkground.WriteID.Setting;
  try
    Mscomm_Write.PortOpen := True;
  Except
  End;
end;
//连接读ID卡的串口
procedure TFrm_PS_Main.MsComm_ReadComm(Sender: TObject);
var
  strTemp:String;
begin
  if MSComm_Read.CommEvent = comEvReceive then begin
    strTemp:= MsComm_Read.Input;
    while(strTemp<>'') do begin
      SystemWorkground.ReadIDValue:=SystemWorkground.ReadIDValue+strTemp;
      WaitSleep(300);
      strTemp:=MsComm_Read.Input;
      end;
    //ShowMessage(SystemWorkground.ReadIDValue);    
    end;
end;
//连接写ID卡的串口
procedure TFrm_PS_Main.Mscomm_WriteComm(Sender: TObject);
var
  strTemp:String;
begin
  if MSComm_Write.CommEvent = comEvReceive then begin
    strTemp:= MSComm_Write.Input;
    while(strTemp<>'') do begin
      SystemWorkground.WriteidValue:=SystemWorkground.ReadIDValue+strTemp;
      WaitSleep(300);
      strTemp:=MSComm_Write.Input;
      end;
    //ShowMessage(SystemWorkground.WriteidValue);
    end;
end;


procedure TFrm_PS_Main.WaitSleep(iSleep:integer);
var
  iCount,iStep:integer;
begin
  iCount := 0;
  iStep:=100;
  while (iCount<iSleep) do begin
    Application.ProcessMessages;
    Sleep(iStep);
    iCount:=iCount+iStep;
    end;
end;


procedure TFrm_PS_Main.ReadID(strv: String;r_w:String);
var
  strTemp:String;
  iStart:integer;
begin
  strTemp:='0000'+IntToHex(SystemWorkground.ReadID.IDLength,2);//转换成长度
  iStart:=Length(strTemp);
  strTemp:=Copy(strTemp,iStart-3,4);
  strTemp:='RDSTA1'+SystemWorkground.ReadID.Area+strTemp+'*'+Chr(13);

  //MsComm_Read.Output := strTemp;
  if(LowerCase(r_w)='r') then
    MsComm_read.Output := strTemp
  else
    MsComm_Write.Output := strTemp
end;


procedure TFrm_PS_Main.WriteID(strv: String;r_w:String);
var
  strTemp:String;
begin
  strTemp:='WTSTA1'+SystemWorkground.WriteID.Area+strv+'*'+Chr(13);
  if(LowerCase(r_w)='r') then
    MsComm_read.Output := strTemp
  else
    MsComm_Write.Output := strTemp
end;


procedure TFrm_PS_Main.InitPanel;
begin
  panel_cur.Caption := '当前型号：';
  panel_Next.Caption := '下一型号：';
  panel_curNum.Caption := '';

  ProType:='';
end;

procedure TFrm_PS_Main.StartThread;
begin
  //090720为了保证更新计划后能重新显示
  Panel_JHNum.Caption := '计划总数：'+DataModule_3F.GetJHCount;
  DataModule_3F.DeleteSCWC('');//删除完成的计划
  //090720为了保证更新计划后能重新显示
  
  if(WorkThread<>nil) then begin
    FreeAndNil(WorkThread);
    end;
  WorkThread:=TWorkThread.Create(Owner);
  WorkThread.Priority := tpNormal;
  WorkThread.Resume;
end;


procedure TFrm_PS_Main.AddState(state: String);
begin
  if(ListBox_Event.Items.Count>7) then begin
     ListBox_Event.Items.Delete(0);
    end;
  ListBox_Event.Items.Add(state);
  ListBox_Event.Selected[ListBox_Event.Items.Count-1]:=true;
end;


procedure TFrm_PS_Main.EndThread;
var
  PLCData:Array of Integer;
begin
  SetLength(PLCData,1);
  PLCData[0]:=2;
  ICPLCCommunication.WriteDataToPLC(SystemworkGround.PCRun,PLCData);
  //StartWork//加上会闪
  //以上是刚加
  if(WorkThread<>nil) then
    WorkThread.Terminate;
  M_Behindoperate_Startwork.Caption:='开始工作';
  SetWorkState('停止状态');

  Panel_PCStatus.Color:=clRed;


  M_Behindoperate_SetPara.Enabled := True;
  M_Behindoperate_Recordquery.Enabled := True;
  if(G_User.UserOpration='管理员') then
       M_Behindoperate_MCtest.Enabled := True;
end;


procedure TFrm_PS_Main.SetWorkState(state: String);
begin
  Panel_PLCWorkStatus.Caption:=state;
end;

procedure TFrm_PS_Main.SetXH(xh: String);
begin
  Panel_PartName.Caption := xh;
end;

procedure TFrm_PS_Main.SetXH2(xh2: String);
begin
  Panel_None3.Caption:=xh2;
end;


procedure TFrm_PS_Main.Timer1Timer(Sender: TObject);
var
  bRet:Boolean;
begin
  Timer1.Enabled := False;
  //StartWork;//加上握手后去掉此部分
//{//带握手的
  bRet:=False;
 //加上握手后放开此部分
  if(not bOpen) then begin
    ICPLCCommunication.InitPLC;
    end;
  if(not bOpen) then begin
    Panel_PLCStatus.Color:=clRed;
    M_Behindoperate_Startwork.Enabled := False;
    bRet:=True;
    end
  else begin
    if(IsWorkState) then begin //如果开始工作
      Panel_PLCStatus.Color:=clGreen;
      M_Behindoperate_Startwork.Enabled := True;
      StartWork;
      end
    else begin//如果PLC未开始工作
      EndThread;
      bRet:=True;
      end;
    end;

  Timer1.Enabled := bRet;
//}//带握手的

end;


//开始工作
procedure TFrm_PS_Main.StartWork;
var
  PLCData:Array of integer;
begin
  SetLength(PLCData,1);
  if(M_Behindoperate_Startwork.Caption='开始工作') then begin
    M_Behindoperate_Startwork.Caption:='停止工作';
    SetWorkState('工作状态');
    Panel_PCStatus.Color:=clGreen;

    M_Behindoperate_SetPara.Enabled := False;
    M_Behindoperate_Recordquery.Enabled := false;
    M_Behindoperate_MCtest.Enabled := False;
    PLCData[0]:=0;
    ICPLCCommunication.WriteDataToPLC(SystemworkGround.PCReCallRequestFDJ,PLCData);
    PLCData[0]:=1;
    ICPLCCommunication.WriteDataToPLC(SystemworkGround.PCRun,PLCData);
    if(IsWorkState) then
      StartThread;
    end
  else begin
    EndThread;
    end;
end;



//读取PLC是否在自动运行状态
function TFrm_PS_Main.IsWorkState: Boolean;
var
  bRet:Boolean;
  PLCData:Array of integer;
begin
  SetLength(PLCData,1);
  bRet:=ICPLCCommunication.ReadDataFromPLC(SystemworkGround.PLCRun,PLCData);
  if(bRet) then begin
    if(PLCData[0]=1) then begin
      bRet:=True;
      Panel_PLCStatus.Color:=clGreen;
      end
    else begin
      Panel_PLCStatus.Color:=clRed;
      EndThread;//090807加看是不是影响线程
      bRet:=False;
      end;
    end
  else  begin
    if(MessageDlg('读取失败，请结束本次工作？'+#13+#10+'请确认与PLC连接是否正确！',mtInformation,[mbYes,mbNo],0)=mrYes) then begin
      Close;
      end;
    end;
  Result:=bRet;
end;


{*
procedure TFrm_GQMain.SetEquipment(bColor: Boolean);
begin
  if(bColor) then
    Frame_Right_Main.Panel_PLCStatus.Color:=clGreen
  else
    Frame_Right_Main.Panel_PLCStatus.Color:=clRed;
end;
*}





procedure TFrm_PS_Main.Timer_InitTimer(Sender: TObject);
begin
  if(not Login) then Exit;
  Timer_Init.Enabled:=False;
  Timer_Init.Interval := 0;
  
  Timer1.Enabled := False;
  ICPLCCommunication.InitPLC;
  //InitMsComm;
  if(bOpen) then
    Panel_PLCStatus.Color:=clGreen;
  Panel_JHNum.Caption := '计划总数：'+DataModule_3F.GetJHCount;
  DataModule_3F.DeleteSCWC('');//删除完成的计划
  InitPanel;
  Timer1.Enabled := True;
end;


procedure TFrm_PS_Main.WriteHaveJiHua;
var
  PLCWriteData:Array of Integer;
  iCount:integer;
  strCount:String;
begin
  iCount:=0;
  try
    strCount:= DataModule_3F.GetJHCount; //调用函数获得总的计划数
    if(strCount<>'') then
      iCount:=StrToInt(DataModule_3F.GetJHCount);
  Except
    iCount:=0;
    End;
  SetLength(PLCWriteData,1);
  if(iCount>0) then begin
    PLCWriteData[0]:=1; //有计划发送PLC值为1
    Panel_JHNum.Caption := '计划总数：'+DataModule_3F.GetJHCount;
    end
  else begin
    PLCWriteData[0]:=2;//无计划发送PLC值为2
    Panel_JHNum.Caption:='';
    end;
  ICPLCCommunication.WriteDataToPLC(SystemWorkground.HaveJH,PLCWriteData);
end;

end.
