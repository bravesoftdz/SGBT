{*
1.RequestFDJType
  功能：实现PLC需要机型时，向内容写入机型.
  实现：D6000=1:PLC需要机型
        向PLC写入机型后,置D6100=1
        判断D6000=2(是不是为2),如果D6000=2,则置D6100=0(只置一次)
        机型存放区域:D6021-D6045
2.RequestClearBoard
  功能：请求清除托盘信息
  实现：D6002=1:PLC判断托盘到位后，要求清除
        清除后置成功D6102=1，失败D6102=2.
        D6002=0后，置D6102=0(只置一次).
3.ClearBoard
  功能：清除托盘信息
4.RequestWriteBoard
  功能：请求向托盘写入信息
  实现：D6004=1:PLC需要向托盘写入信息.
        写入后置成功D6104=1,失败D6104=2.
        D6004=0后，置D6104=0(只置一次).
5.WriteBoard
  功能：写入托盘信息.
6.WriteFDJType
  功能: 写入托盘信息. 
*}
unit ICWorkThreadUnit;

interface
uses  Classes,SysUtils,Dialogs,Controls,ADODB,Forms,StrUtils;
type
  TWorkThread=Class(TThread)
  ADOQ:TADOQuery;

  private
    FDJTypeState:integer;
    ClearState:integer;
    WriteState:integer;
    WriteErrGTFlag:integer;
    GetFDJType:Boolean;//是不是请求发动机
    GetClearBoard:Boolean;//是不是清托盘
    GetWriteBoard:Boolean;//是不是写入托盘
    bExistsErrGT:Boolean;       //量不是存在错误缸体

    FDJLS:String;//当前发动机的流水号
    SaveDXH,SaveRQ:String;//存入数据库的短型号

    bHaveJH:Boolean;   //有计划


    procedure RequestFDJType;    //发动机请求  ，源自PLC
    procedure RequestClearBoard;  // 清除ID卡请求 ，源自PLC
    function ClearBoard:Boolean;   //答复“清除ID卡请求”，回复PLC
    procedure RequestWriteBoard;  //写ID卡请求 ，源自PLC
    function WriteBoard:Boolean;  //答复“写ID卡请求”，回复PLC
    function WriteFDJType:Boolean;  //答复“发动机请求”，回复PLC
    procedure ReadFDJType;        //读取发动机型号，读取的内容是在条码扫描完成后的数据，供写ID用
    procedure WriteData(AddressName,strValue:String); //写ID卡
    function WriteErrorFDJType: Boolean;  //写发动机错误

  protected
    procedure Execute; override;          //执行

  public
    Constructor Create(Owner:TComponent);   //新建线程
    Destructor Destroy; override;           //关闭释放线程
    
  private
    Function UpdateData:Boolean;          //更新数据
    procedure FindErrorFDJ;//查询是不是有报废发动机,有就存入数据库
    Function SendToShangLiao:Boolean;//插入打刻错误的发动机,True是插入,PLC接收后再置Faslse
    procedure WriteNoJiHua;   //通知PLC无计划
    procedure WriteHaveJiHua;   //通知PLC有计划
    function GetWeek:String;
    Function ChangeAreaToStr(arr:Array of integer;Len:integer):String;
  end;

var
  WorkThread:TWorkThread;

implementation

  uses  PS_mainUnit,ICPLCCommunicationUnit,ICDataModule,ICCommunalVarUnit,
  ICFunctionUnit;

  { TWorkThread }

//新建线程
constructor TWorkThread.Create(Owner: TComponent);
begin
  inherited Create(True);
  ADOQ:=TADOQuery.Create(nil);
end;

//关闭释放线程
destructor TWorkThread.Destroy;
begin
  FreeAndNil(ADOQ);
  inherited;
end;

//线程开始
procedure TWorkThread.Execute;
//var
//  aa:array of integer;
begin
  inherited;
  FDJTypeState:=0;
  ClearState:=0;
  WriteState:=0;
  WriteErrGTFlag:=0;
  bHaveJH:=True;
  
  ReadFDJType;    //读取发动机型号 ，读取的是扫描完成后的数据，用于写入ID卡
  {
  SetLength(aa,4);
  aa[0]:=19786;
  aa[1]:=12345;
  aa[2]:=120;
  aa[3]:=100;
  SaveDXH:=ChangeAreaToStr(aa,4);
  }//测试是好的

  while( (not Terminated) and (not IsExit) )do begin
    if(Frm_PS_Main.IsWorkState) then begin       //调用主界面中读取PLC的运行状态函数
      //此段内加上流程
      {
      if(DataModule_Main.GetJHCount='') then
        RequestFDJType
      else begin

        end;
      }
      RequestFDJType;     //如果PLC在自动运行状态，则读取PLC的“发动机型号请求”信号
      if(Terminated) then break;
      RequestClearBoard;   //如果PLC在自动运行状态，则读取PLC的“清除ID卡请求”信号
      if(Terminated) then break;
      RequestWriteBoard;     //如果PLC在自动运行状态，则读取PLC的“写ID卡请求”信号
      if(Terminated) then break;
      FindErrorFDJ;     //如果PLC在自动运行状态，则读取PLC的“发动机报废请求”信号
      if(Terminated) then break;
      //此段内加上流程
      Sleep(100);
      end
    else begin
      Sleep(800);
      end;

    end;
  if(ADOQ.Active) then
    ADOQ.Active := False;
  Frm_PS_Main.EndThread;   //调用主界面中把PC机运行状态 通知PLC
  FreeAndNil(WorkThread);  //释放线程
end;

//--------------------以上是工作流程操作


//清除ID卡
function TWorkThread.ClearBoard:Boolean;
Var
  Ret:Boolean;
  strTemp:String;
  iCount:Integer;
begin
  Ret:=True;
  strTemp:=SystemWorkground.ClearStr;
  Frm_PS_Main.WriteID(strTemp,'r');   //调用主界面中写ID卡函数
  //判断到*结束
  iCount:=0;
  while(Pos('*',SystemWorkground.ReadidValue)<1) do begin
    Application.ProcessMessages;
    Sleep(300);
    Inc(iCount);
    if(iCount>SystemWorkground.ClearTPCS) then begin
      Ret:=False;
      Break;
      end;
    end;
  if(Ret) then begin
    ICFunction.DeleteChr(SystemWorkground.ReadidValue);    //清除字符串中的#0（换行符号？Cr）
    //判断到*结束

    if(Pos('WT00',SystemWorkground.ReadidValue)>0) then//'RD0010'
      Ret:=True
    else
      Ret:=False;
    end;

  SystemWorkground.ReadidValue:='';
  {
  Frm_PS_Main.ReadID('');     //调用主界面中读ID卡函数

  //判断到*结束
  while(Pos('*',SystemWorkground.ReadIDValue)<1) do begin
    Application.ProcessMessages;
    Sleep(300);
    end;
  ICFunction.DeleteChr(SystemWorkground.ReadIDValue);
  //判断到*结束
  iLen:=Length(SystemWorkground.ReadIDValue);
  strV:=Copy(SystemWorkground.ReadIDValue,7,iLen-8);
  if(strV=strTemp) then
    Ret:=true
  else
    Ret:=False;
  }

  Result:=Ret;
end;

procedure TWorkThread.RequestClearBoard;
var
  UnitName,UnitWriteName:String;
  PLCData,PLCWriteData:Array of integer;
begin
  UnitName:=SystemWorkground.PLCRequestClearTP ;//'D6002'; PLC请求清托盘
  UnitWriteName:=SystemWorkground.PCReCallClearTP;//'D6102'; PC回应清托盘
  SetLength(PLCData,1);
  SetLength(PLCWriteData,1);
  if (not ICPLCCommunication.ReadDataFromPLC(UnitName,PLCData)) then begin
    if(MessageDlg('读取失败，请结束本次工作，手工退出程序?',mtInformation,[mbYes,mbNo],0)=mrYes) then begin
      Terminate;
      end;
    end;
  if( (PLCData[0]=1) and (ClearState<>1) ) then begin  //(ClearState=0)
    Frm_PS_Main.AddState('->收到清空发动机请求');
    GetClearBoard:=false;
    ClearState:=1;

    if(ClearBoard)then begin     //变量 ClearBoard  在哪里定义
      Frm_PS_Main.AddState('<-清空发动机请求成功');
      PLCWriteData[0]:=1;
      end
    else begin
      Frm_PS_Main.AddState('<-清空发动机请求失败');
      PLCWriteData[0]:=2;
      end;

    ICPLCCommunication.WriteDataToPLC(UnitWriteName,PLCWriteData);  //PC回应清托盘
    end
  //else if( (PLCData[0]=0) and (ClearState<>0)) then begin   //
  //  ClearState:=0;
  //  PLCWriteData[0]:=0;
  //  ICPLCCommunication.WriteDataToPLC(UnitWriteName,PLCWriteData);
  //  end
  else if (PLCData[0]<>1) then begin
    ClearState:=PLCData[0];
    ClearState:=0;
    end;
  if( (PLCData[0]=0) and (not GetClearBoard) ) then begin
    GetClearBoard:=true;
    Frm_PS_Main.AddState('等待清托盘');

    ClearState:=0;
    PLCWriteData[0]:=0;
    ICPLCCommunication.WriteDataToPLC(UnitWriteName,PLCWriteData);
    end;
end;

//读取PLC发动机型号请求
procedure TWorkThread.RequestFDJType;
var
  UnitName,UnitWriteName:String;
  PLCData,PLCWriteData:Array of integer;
  bSucceed:Boolean;
  
begin
  UnitName:=SystemWorkground.PLCRequestFDJ;//'D6000'; PLC请求发动机
  UnitWriteName:=SystemWorkground.PCReCallRequestFDJ;//'D6100';  PC回应请求发动机
  SetLength(PLCData,1);
  SetLength(PLCWriteData,1);
  if (not ICPLCCommunication.ReadDataFromPLC(UnitName,PLCData)) then begin
    if(MessageDlg('读取失败，请结束本次工作，手工退出程序?',mtInformation,[mbYes,mbNo],0)=mrYes) then begin
      Terminate;
      Exit;
      end;
    end;
  if( (PLCData[0]=1) and (FDJTypeState<>1) ) then begin  //(FDJTypeState=0)
    Frm_PS_Main.AddState('->收到写入发动机请求');

    if(SendToShangLiao) then begin//SendToShangLiao函数用来查询是否有异常数据表中是否有“等待”的记录
      bSucceed:=WriteErrorFDJType;
      Frm_PS_Main.AddState('--准备写入打废机体');
      end
    else begin
      Frm_PS_Main.AddState('--准备写入计划机体');
      bSucceed:=WriteFDJType;
      end;

    if(bSucceed) then begin//写入发动机型号
    //if(WriteFDJType)then begin//写入发动机型号,不管错误型号时用的
      FDJTypeState:=1;
      PLCWriteData[0]:=1;
      if( ICPLCCommunication.WriteDataToPLC(UnitWriteName,PLCWriteData) ) then begin //写入成功置1否则置2
        Frm_PS_Main.AddState('<-写入发动机请求成功');
        end
      else begin
        FDJTypeState:=0;
        Frm_PS_Main.AddState('<-写入发动机到PLC失败');
        end;

      end
    else begin////WriteFDJType的Else
      PLCWriteData[0]:=2;
      ICPLCCommunication.WriteDataToPLC(UnitWriteName,PLCWriteData);
      Frm_PS_Main.AddState('<-写入发动机到PLC失败');
      end;
    end
  else if(  (PLCData[0]=2) and (FDJTypeState<>2) ) then begin  //and (FDJTypeState=1)
    FDJTypeState:=2;//0
    GetFDJType:=false;
    end
  else if ( (PLCData[0]=0)  ) then begin //更新数据库  //and (FDJTypeState<>1)
    //if( (FDJTypeState=2)  ) then//只有从2变为零时才保存数据并且更新显示//or (FDJTypeState=1)
    if( (not bExistsErrGT) and ((FDJTypeState=2)) ) then//错误的缸体不再存盘
      bHaveJH:=UpdateData;
    if(bExistsErrGT) then begin
      DataModule_3F.UpdateErrorGT;
      bExistsErrGT:=False;
      end;
    //////////判断是不是有计划或打废缸体
    if( (DataModule_3F.GetErrorGT ='') and (not bHaveJH) ) then begin
      WriteNoJiHua;
      //Frm_GQMain.EndThread;//如果计划为空也不能结束，因为最后一个要完成工作
      end;

    FDJTypeState:=0;
    PLCWriteData[0]:=0;
    ICPLCCommunication.WriteDataToPLC(UnitWriteName,PLCWriteData);
    end
  else begin//不能满足上面的条件时，则遇到什么值写什么值
    //PLCWriteData:=PLCData[0];
    //ICPLCCommunication.WriteDataToPLC(UnitWriteName,PLCWriteData);
    //FDJTypeState:=PLCData[0];
    end;
  if( ((PLCData[0]=0) or (PLCData[0]=2)) and (not GetFDJType) ) then begin
    Frm_PS_Main.AddState('等待请求发动机型号');
    GetFDJType:=True;
    end;

end;

//读取PLC写托盘ID请求  （扫描完毕后）
procedure TWorkThread.RequestWriteBoard;
var
  UnitName,UnitWriteName:String;
  PLCData,PLCWriteData:Array of integer;
begin
  UnitName:=SystemWorkground.PLCRequestWriteTP;//'D6004';
  UnitWriteName:=SystemWorkground.PCReCallWriteTP;//'D6104';
  SetLength(PLCData,1);
  SetLength(PLCWriteData,1);
  
  if (not ICPLCCommunication.ReadDataFromPLC(UnitName,PLCData)) then begin
    if(MessageDlg('读取失败，请结束本次工作，手工退出程序?',mtInformation,[mbYes,mbNo],0)=mrYes) then begin
      Terminate;
      Exit;
      end;
    end;
  if( (PLCData[0]=1) and (WriteState<>1) ) then begin//(WriteState=0)
    Frm_PS_Main.AddState('->收到写托盘指令');
    WriteState:=1;
    GetWriteBoard:=False;
    if(WriteBoard)then begin  //判断写托盘ID是否成功完成
      Frm_PS_Main.AddState('<-写托盘成功');
      PLCWriteData[0]:=1;
      //保存结果
      //DataModule_3F.SaveWriteDI(SaveDxh,FDJLS,SaveRQ);
      DataModule_3F.SaveCurRecord(SaveDXH,FDJLS);//写入流水线生产以备查询使用
      //保存结果
      end
    else begin
      Frm_PS_Main.AddState('<-写托盘失败');
      PLCWriteData[0]:=2;
      end;
    ICPLCCommunication.WriteDataToPLC(UnitWriteName,PLCWriteData);
    end
  //else if( (PLCData[0]=0) and (WriteState<>0) ) then begin
  //  WriteState:=0;
  //  PLCWriteData[0]:=0;
  //  ICPLCCommunication.WriteDataToPLC(UnitWriteName,PLCWriteData);
    //原来在此下移记录
  //  end
  else if( PLCData[0]<>1 ) then begin
    WriteState:=PLCData[0];
    WriteState:=0;
    end;
  if( (PLCData[0]=0) and (not GetWriteBoard) ) then begin
    GetWriteBoard:=True;
    Frm_PS_Main.AddState('等待写托盘');

    WriteState:=0;
    PLCWriteData[0]:=0;
    ICPLCCommunication.WriteDataToPLC(UnitWriteName,PLCWriteData);
    end;
end;

//根据读取PLC的写托盘ID请求，将扫描完毕的工件相关信息，写入ID卡
function TWorkThread.WriteBoard:Boolean;
Var
  Ret:Boolean;
  UnitWriteName:String;
  PLCWriteData:Array of integer;
  strFDJ_DXH,strFDJ_XH,strFDJ_XH2,strFDJ_LS,strDate:String;
  i,iFor,iCount:integer; //iRet,
  strTemp:String;
  strV:String;
Label ExitSub;
begin
  Ret:=True;
  
  SetLength(PLCWriteData,1);
  UnitWriteName:=SystemWorkground.PCReadFanHao;
  PLCWriteData[0]:=0;
  strV:=IntToStr(0)+IntToStr(0);
  if(Trim(ADOQ.FieldByName('状态').AsString)='完成') then begin
    Ret:=False;
    goto ExitSub;
    end;

  //读出短型号
  strFDJ_DXH:='';
  SetLength(PLCWriteData,2);
  iFor:=2;
  strV:=IntToStr(0)+IntToStr(0);
  ICPLCCommunication.ReadDataFromPLC(UnitWriteName,PLCWriteData);
  strFDJ_DXH := ChangeAreaToStr(PLCWriteData,iFor);
  {
  for i:=1 to iFor do begin
    if(PLCWriteData[i-1]=0)then continue;
    strTemp:=IntToHex(PLCWriteData[i-1],2);
    iRet:=HexToBin(PChar(strTemp),PChar(strV),2);
    if(iRet>1) then
      strFDJ_DXH:=strFDJ_DXH+strV[2]+strV[1]
    else
      strFDJ_DXH:=strFDJ_DXH+strV[1];
    end;
  }


  SaveDXH:=strFDJ_DXH;
  //读出机型
  UnitWriteName:=SystemWorkground.PCReadFDJ;
  strFDJ_XH:='';
  iFor:=4;
  SetLength(PLCWriteData,(iFor));
  strV:=IntToStr(0)+IntToStr(0);
  ICPLCCommunication.ReadDataFromPLC(UnitWriteName,PLCWriteData);
  strFDJ_XH:= ChangeAreaToStr(PLCWriteData,iFor);
  {
  for i:=1 to iFor do begin
    if(PLCWriteData[i-1]=0)then continue;
    strTemp:=IntToHex(PLCWriteData[i-1],2);
    iRet:=HexToBin(PChar(strTemp),PChar(strV),2);
    if(iRet>1) then
      strFDJ_XH:=strFDJ_XH+strV[2]+strV[1]
    else
      strFDJ_XH:=strFDJ_XH+strV[1];
    end;
  }
  //读出特征码型号
  UnitWriteName:=SystemWorkground.PCReadTZ;
  strFDJ_XH2:='';
  iFor:=4;
  SetLength(PLCWriteData,(iFor));
  ICPLCCommunication.ReadDataFromPLC(UnitWriteName,PLCWriteData);
  strFDJ_XH2:= ChangeAreaToStr(PLCWriteData,iFor);
  {
  for i:=1 to iFor do begin
    if(PLCWriteData[i-1]=0)then continue;
    strTemp:=IntToHex(PLCWriteData[i-1],2);
    iRet:=HexToBin(PChar(strTemp),PChar(strV),2);
    if(iRet>1) then
      strFDJ_XH2:=strFDJ_XH2+strV[2]+strV[1]
    else
      strFDJ_XH2:=strFDJ_XH2+strV[1];
    end;
  }
  //读出流水号
  UnitWriteName:=SystemWorkground.PCReadLS;
  strFDJ_LS:='';
  iFor:=4;
  SetLength(PLCWriteData,(iFor));
  ICPLCCommunication.ReadDataFromPLC(UnitWriteName,PLCWriteData);
  strFDJ_LS:= ChangeAreaToStr(PLCWriteData,iFor);
  {
  for i:=1 to iFor do begin
    strTemp:=IntToHex(PLCWriteData[i-1],2);
    iRet:=HexToBin(PChar(strTemp),PChar(strV),2);
    if(iRet>1) then
      strFDJ_LS:=strFDJ_LS+strV[2]+strV[1]
    else
      strFDJ_LS:=strFDJ_LS+strV[1];
    end;
  }
  if(Length(strFDJ_LS)>7) then
    strFDJ_LS:=LeftStr(strFDJ_LS,7);
  //FDJLS:=strFDJ_LS;//取出发动机流水，以备存入JNYH_流水线生产  表中
  strFDJ_LS:=Trim(strFDJ_LS);
  FDJLS:=CurYear+strFDJ_LS;
  //读出年月日
  UnitWriteName:=SystemWorkground.PCReadYear;
  strDate:='';
  iFor:=6;
  SetLength(PLCWriteData,(iFor));
  ICPLCCommunication.ReadDataFromPLC(UnitWriteName,PLCWriteData);
  for i:=1 to iFor do begin
    strTemp:=IntToStr(PLCWriteData[i-1]);
    if(i>1) then begin
      if(Length(strTemp)<2) then begin
        strTemp:= '00'+strTemp;
        strTemp:=RightStr(strTemp,2);
        end;
      end;
    strDate:=strDate+strTemp;
    end;
  SaveRQ:=strDate;
  //strV:=strDate+strFDJ_XH+strFDJ_LS;//091130前
  //strV:=strDate+GetWeek+strFDJ_XH+' '+strFDJ_LS; //20100304前
  strV:=strDate+GetWeek+strFDJ_XH+' '+CurYear+strFDJ_LS; //
  Frm_PS_Main.WriteID(strV,'w');

  //判断到*结束
  iCount:=0;
  while(Pos('*',SystemWorkground.WriteidValue)<1) do begin
    Application.ProcessMessages;
    Sleep(300);
    Inc(iCount);
    if(iCount>SystemWorkground.WriteTPCS) then begin
      Ret:=False;
      Break;
      end;
    end;
  if(Ret) then begin
    ICFunction.DeleteChr(SystemWorkground.WriteidValue);
    //判断到*结束

    if(Pos('WT00',SystemWorkground.WriteidValue)>0) then
      Ret:=True
    else
      Ret:=False;
    end;
  SystemWorkground.WriteidValue:='';
ExitSub:
  Result:=Ret;
end;


//根据PLC的发动机请求，PC向PLC写入当前生产计划的相关信息、番号、料道号等
function TWorkThread.WriteFDJType: Boolean;
Var
  Ret:Boolean;
  UnitWriteName:String;
  PLCWriteData:Array of integer;
  strFDJ_DXH,strFDJ_XH,strFDJ_LD,strFDJ_XH2:String;  
Label ExitSub;
begin
  UnitWriteName:=SystemWorkground.PCWriteLD;//'D6021';  PC写入番号
  if(ADOQ.RecordCount=0) then begin
    Ret:=False;
    goto ExitSub;
    end;
  if(Trim(ADOQ.FieldByName('状态').AsString)='完成') then begin
    Ret:=False;
    goto ExitSub;
    end;

  strFDJ_DXH:= ADOQ.FieldByName('短型号').AsString;
  strFDJ_XH:= ADOQ.FieldByName('型号').AsString;
  strFDJ_XH2:= ADOQ.FieldByName('型号2').AsString;
  strFDJ_LD:= ADOQ.FieldByName('料道号').AsString;

  //strFDJ_LD:='4';//测试用
  //写入料道号
  SetLength(PLCWriteData,1);
  try
    PLCWriteData[0]:=StrToInt(Trim(strFDJ_LD));
  Except
    ShowMessage('料道设置错误');
    end;
  ICPLCCommunication.WriteDataToPLC(UnitWriteName,PLCWriteData);

  //写入短型号
  UnitWriteName:=SystemWorkground.PCWriteFanHao;
  WriteData(UnitWriteName,strFDJ_DXH);

  //写入型号
  UnitWriteName:=SystemWorkground.PCWriteType;
  WriteData(UnitWriteName,strFDJ_XH);

  //写入特征匹配码型号
  UnitWriteName:=SystemWorkground.PCWriteTZ;
  WriteData(UnitWriteName,strFDJ_XH2);

  Ret:=True;
ExitSub:
  Result:=Ret;
end;



//查询数据库中生产计划表里面的当前计划信息 ,在主界面中显示
procedure TWorkThread.ReadFDJType;
var
  strSQL:String;
  PLCWriteData:Array of integer;
begin
  ProType:='';
  with ADOQ do begin
    Close;
    strSQL:='select [短型号],[型号],[型号2],[料道号],[状态],[生产次序号] '
      +' from [JNYH_生产] where ( ([状态] is null) or ([状态]<>''完成'') ) order by [生产次序号]';
    ADOQ.Connection := DataModule_3F.ADOConnection_Main;
    SQL.Clear;
    SQL.Add(strSQL);
    Open;
    First;
    if(not Eof) then begin
      Frm_PS_Main.Panel_Cur.Caption := '当前型号:'+FieldByName('短型号').AsString;
      Frm_PS_Main.Panel_CurNum.Caption:= '当前计划:'+FieldByName('生产次序号').AsString;
      Frm_PS_Main.SetXH(FieldByName('型号').AsString);
      Frm_PS_Main.SetXH2(FieldByName('型号2').AsString);

      //Frm_PS_Main.Panel_Cur.Caption := '当前型号:'+ProType;
      //ProType:= FieldByName('短型号').AsString;

      SetLength(PLCWriteData,1);
      PLCWriteData[0]:=1;
      ICPLCCommunication.WriteDataToPLC(SystemWorkground.HaveJH,PLCWriteData);

      Next;
      if(not Eof) then begin
        Frm_PS_Main.Panel_Next.Caption := '下一型号:'+FieldByName('短型号').AsString;
        Prior;
        end
      else
        Frm_PS_Main.Panel_Next.Caption := '下一型号:无计划';
      end
    else begin
      Frm_PS_Main.Panel_Cur.Caption := '当前型号:无计划';
      bHaveJH:=False;
      SetLength(PLCWriteData,1);
      PLCWriteData[0]:=2;
      ICPLCCommunication.WriteDataToPLC(SystemWorkground.HaveJH,PLCWriteData);
      Frm_PS_Main.Panel_Next.Caption := '下一型号:无计划';
      Frm_PS_Main.EndThread;
      end;
    end;
end;

// 写数据到PLC的函数
procedure TWorkThread.WriteData(AddressName,strValue:String);
Var
  PLCWriteData:Array of Integer;
  strTemp:String;
  iFor,i:integer;
begin
  SetLength(PLCWriteData,Length(strValue));
  iFor:= (Length(strValue)+1) Div 2;
  For i:=0 to iFor-1 do begin
    strTemp:=IntToHex(Ord(strValue[i*2+2]),2)+IntToHex(Ord(strValue[i*2+1]),2);
    PLCWriteData[i]:=StrToInt('$'+strTemp);
    end;
  ICPLCCommunication.WriteDataToPLC(AddressName,PLCWriteData);
end;

//更新数据库中的内容
Function TWorkThread.UpdateData:Boolean;
var
  //PLCWriteData:array of integer;
  bRet:Boolean;
begin
  bRet:=True;
  ADOQ.Edit;
  ADOQ.FieldByName('状态').AsString := '完成';
  ADOQ.Post;
  DataModule_3F.SaveCurJHSL(ADOQ.FieldByName('短型号').AsString);
  if(not ADOQ.Eof) then begin//写入当前计划是什么
    ADOQ.Next;
    if(not ADOQ.Eof) then begin
      ProType:= ADOQ.FieldByName('短型号').AsString;
     Frm_PS_Main.Panel_Cur.Caption := '当前型号:'+ProType;
     Frm_PS_Main.Panel_CurNum.Caption:= '当前计划:'+ADOQ.FieldByName('生产次序号').AsString;
     Frm_PS_Main.SetXH(ADOQ.FieldByName('型号').AsString);
     Frm_PS_Main.SetXH2(ADOQ.FieldByName('型号2').AsString);
      end
    else begin
      ProType:='无计划';
      Frm_PS_Main.Panel_Cur.Caption:='当前型号:'+ProType;
      bRet:=False;
      //SetLength(PLCWriteData,1);
      //PLCWriteData[0]:=2;
      //ICPLCCommunication.WriteDataToPLC(SystemWorkground.HaveJH,PLCWriteData);
      //Frm_PS_Main.EndThread;

      Frm_PS_Main.AddState('<-当前计划用完');
      end;
    end
  else begin
    ProType:='无计划';
    Frm_PS_Main.Panel_Cur.Caption:='当前型号:'+ProType;
    bRet:=False;
    //SetLength(PLCWriteData,1);
    //PLCWriteData[0]:=2;
    //ICPLCCommunication.WriteDataToPLC(SystemWorkground.HaveJH,PLCWriteData);
    //Frm_PS_Main.EndThread;
      
    Frm_PS_Main.AddState('<-当前计划用完');
    end;

  //写入下一条记录
  if(not ADOQ.Eof) then begin
    ADOQ.Next;
    if(not ADOQ.Eof) then begin
      Frm_PS_Main.Panel_Next.Caption := '下一型号:'+ADOQ.FieldByName('短型号').AsString;
      ADOQ.Prior;
      end
    else begin
      Frm_PS_Main.Panel_Next.Caption := '下一型号:无计划';
      end;

    end
  else begin
    Frm_PS_Main.Panel_Next.Caption := '下一型号:无计划';
    end;
  Result:=bRet;
end;



//读取PLC中打刻异常标志位的信息 及相对应的发动机型号
procedure TWorkThread.FindErrorFDJ;
var
  PLCWriteData:Array of integer;
  strDXH:String;
begin
  SetLength(PLCWriteData,1);
  PLCWriteData[0]:=0;
      // ErrorGTState:String;            //打废缸体的标志 D6010
  ICPLCCommunication.ReadDataFromPLC(SystemWorkground.ErrorGTState,PLCWriteData);

  if( (PLCWriteData[0]=1) and (WriteErrGTFlag=0) ) then begin//表示有异常缸体
    WriteErrGTFlag:=1;
    SetLength(PLCWriteData,2);


    // ErrorGT     :String;            //打废缸体的番号D6301

    ICPLCCommunication.ReadDataFromPLC(SystemWorkground.ErrorGT,PLCWriteData);

    strDXH:=ChangeAreaToStr(PLCWriteData,2);//读出番号
    DataModule_3F.SaveErrorGT(strDXH);  //保存打刻异常的发动机型号进异常数据表中

    PLCWriteData[0]:=1;
    ICPLCCommunication.WriteDataToPLC(SystemWorkground.PCErrorGTFlag,PLCWriteData);
    Frm_PS_Main.AddState('->收到打废机体');
    WriteHaveJiHua;//收到打费缸体后，要置上有计划内容
    end
  else if ( (PLCWriteData[0]=0) and (WriteErrGTFlag=1) ) then begin 
    PLCWriteData[0]:=0;
    WriteErrGTFlag:=0;
        // PCErrorGTFlag:String;           //打废缸体接收标志 D6110
    ICPLCCommunication.WriteDataToPLC(SystemWorkground.PCErrorGTFlag,PLCWriteData);
    end;

end;

function TWorkThread.ChangeAreaToStr(arr: array of integer;Len:integer): String;
var
  strTemp,strV,strV2:String;
  i,iRet:integer;
begin
  strV2:=IntToStr(0)+IntToStr(0);
  for i:=1 to Len do begin
    if(arr[i-1]=0)then continue;
    strTemp:=IntToHex(arr[i-1],2);
    iRet:=HexToBin(PChar(strTemp),PChar(strV2),2);
    if(iRet>1) then
      strV:=strV+strV2[2]+strV2[1]
    else
      strV:=strV+strV2[1];
    end;
  Result := strV;
end;


//检查打刻异常表中是否有“等待”的记录
Function TWorkThread.SendToShangLiao:Boolean;
var
  bRet:Boolean;
begin
  bRet:=False;
  bExistsErrGT:=False;
  if(DataModule_3F.GetErrorGT <>'') then begin  //从异常数据表中查询“等待”的记录
    bRet:=True;
    bExistsErrGT:=True;
    end;
  Result := bRet;
end;

//将异常数据表中的“等待”记录信息写入PLC，包括其对应的料道号等
function TWorkThread.WriteErrorFDJType: Boolean;
Var
  Ret:Boolean;
  UnitWriteName,strSQL:String;
  PLCWriteData:Array of integer;
  strFDJ_DXH,strFDJ_XH,strFDJ_LD,strFDJ_XH2:String;
  ADOQErr:TADOQuery;
Label ExitSub;
begin
  ADOQErr:=TADOQuery.Create(nil);
  ADOQErr.Connection := DataModule_3F.ADOConnection_Main;
  strSQL:='select [短型号],[完成状态],[日期] from '
    +' JNYH_异常缸体 where 完成状态=''等待''  order by id asc';

  ADOQErr.SQL.Add(strSQL );
  ADOQErr.Active := True;
  
  //取出错误发动机型号

  UnitWriteName:=SystemWorkground.PCWriteLD;//'D6021';
  if(ADOQErr.RecordCount=0) then begin
    Ret:=False;
    goto ExitSub;
    end;
  if(Trim(ADOQErr.FieldByName('完成状态').AsString)='完成') then begin
    Ret:=False;
    goto ExitSub;
    end;
  strFDJ_DXH:= ADOQErr.FieldByName('短型号').AsString;
  strSQL:='select [短型号],[型号],[型号2],[料道号] from '
    +' JNYH_型号对照 where [短型号]='''+strFDJ_DXH+'''  order by id asc';

  ADOQErr.SQL.Clear;
  ADOQErr.Active := False;
  ADOQErr.SQL.Add(strSQL );
  ADOQErr.Active := True;


  strFDJ_XH:= ADOQErr.FieldByName('型号').AsString;
  strFDJ_XH2:= ADOQErr.FieldByName('型号2').AsString;
  strFDJ_LD:= ADOQErr.FieldByName('料道号').AsString;

  //strFDJ_LD:='4';//测试用
  //写入料道号
  SetLength(PLCWriteData,1);
  try
    PLCWriteData[0]:=StrToInt(Trim(strFDJ_LD));
  Except
    ShowMessage('料道设置错误');
    end;
  ICPLCCommunication.WriteDataToPLC(UnitWriteName,PLCWriteData);

  //写入短型号
  UnitWriteName:=SystemWorkground.PCWriteFanHao;
  WriteData(UnitWriteName,strFDJ_DXH);

  //写入型号
  UnitWriteName:=SystemWorkground.PCWriteType;
  WriteData(UnitWriteName,strFDJ_XH);

  //写入特征匹配码型号
  UnitWriteName:=SystemWorkground.PCWriteTZ;
  WriteData(UnitWriteName,strFDJ_XH2);

  Ret:=True;
ExitSub:
  FreeAndNil(ADOQErr);
  Result:=Ret;
end;


procedure TWorkThread.WriteNoJiHua;
var
  PLCWriteData:Array of Integer;
begin
  SetLength(PLCWriteData,1);
  PLCWriteData[0]:=2;
  ICPLCCommunication.WriteDataToPLC(SystemWorkground.HaveJH,PLCWriteData);
end;

procedure TWorkThread.WriteHaveJiHua;
var
  PLCWriteData:Array of Integer;
begin
  SetLength(PLCWriteData,1);
  PLCWriteData[0]:=1;
  ICPLCCommunication.WriteDataToPLC(SystemWorkground.HaveJH,PLCWriteData);
end;

function TWorkThread.GetWeek: String;
var
  days: array[1..7] of string;
begin
  days[1] := '00';
  days[2] := '01';
  days[3] := '02';
  days[4] := '03';
  days[5] := '04';
  days[6] := '05';
  days[7] := '06';
  Result:=days[DayOfWeek(Now)];
end;
end.
 