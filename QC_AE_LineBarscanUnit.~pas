unit QC_AE_LineBarscanUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, SPComm, DB, ADODB, ExtCtrls, StdCtrls, OleCtrls, 
  Buttons, Grids, DBGrids, ComCtrls;

type
  Tfrm_QC_AE_LineBarscan = class(TForm)
    DataSource_Bar: TDataSource;
    ADOQuery_Bar: TADOQuery;
    comReader: TComm;
    Panel1: TPanel;
    Panel2: TPanel;
    GroupBox4: TGroupBox;
    Edit_UserPwd: TEdit;
    Label6: TLabel;
    Label9: TLabel;
    Label8: TLabel;
    Edit_ID: TEdit;
    GroupBox1: TGroupBox;
    pgcMachinerecord: TPageControl;
    TabSheet2: TTabSheet;
    Panel7: TPanel;
    Panel3: TPanel;
    GroupBox6: TGroupBox;
    Label3: TLabel;
    Label2: TLabel;
    Label1: TLabel;
    Label4: TLabel;
    Label15: TLabel;
    Label5: TLabel;
    Label7: TLabel;
    Image1: TImage;
    Label10: TLabel;
    Edit_BarScan: TEdit;
    Edit_Core: TEdit;
    Edit_CARDID: TEdit;
    Edit_DateTime: TEdit;
    RadioGroup1: TRadioGroup;
    BitBtn2: TBitBtn;
    Barflow1: TEdit;
    BitBtn1: TBitBtn;
    Edit_LastCardID: TEdit;
    Edit_BiLi: TEdit;
    Edit_Total: TEdit;
    GroupBox2: TGroupBox;
    DBGrid2: TDBGrid;
    Edit_Password: TEdit;
    Tab_Gamenameinput: TTabSheet;
    GroupBox3: TGroupBox;
    Label14: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    Image2: TImage;
    Label22: TLabel;
    Edit4: TEdit;
    BitBtn3: TBitBtn;
    Edit_EBID: TEdit;
    Edit_EBValue: TEdit;
    Edit_Tuibi_Total: TEdit;
    GroupBox5: TGroupBox;
    DBGrid1: TDBGrid;
    Edit11: TEdit;
    Panel_Infor: TPanel;
    DataSource_Tuibi: TDataSource;
    ADOQuery_Tuibi: TADOQuery;
    CheckBox_Update: TCheckBox;
    BitBtn4: TBitBtn;
    CheckBox_Menber: TCheckBox;
    BarCodeCOM2: TComm;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit5: TEdit;
    Edit6: TEdit;
    Barflow2: TEdit;
    Label11: TLabel;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure comReaderReceiveData(Sender: TObject; Buffer: Pointer;
      BufferLength: Word);
    procedure Edit_UserPwdKeyPress(Sender: TObject; var Key: Char);
    procedure BitBtn4Click(Sender: TObject);
    procedure BarCodeCOM2ReceiveData(Sender: TObject; Buffer: Pointer;
      BufferLength: Word);
  private
    { Private declarations }
    procedure InitDataBase_barflow;//条码
    procedure InitDataBase_Tuibi;//退币
    procedure SaveData_Bar(StrFlowBar:string; StrCoreBar : string);
    procedure ClearText;
    function  Query_GameName(Strs:String):String;
    function  Query_MacNo(Strs:String):String;
    function  Query_GameNo(Strs:String):String;//查询机台名称
    procedure Query_MenberInfor(StrID:String);
    function  Query_Menber_IncRecord(StrID:String):boolean;//检查此会员是否有充值记录
    procedure CheckCMD();
    function  Query_Menber_IncRecord_by_EBid(StrID:String):boolean;
    procedure Query_EBINCinformation_by_EBid(StrID:String);
    procedure Query_Tuibi_Total(StrID:String);
    procedure Update_Tuibi_Record(S: string);
    procedure ClearTuibiText;
    procedure ClearValue;

    procedure GetInvalidDate;
    function  Select_IncValue_Byte(StrIncValue : string):string;
    function  Select_CheckSum_Byte(StrCheckSum: string):string;
    function  CheckSUMData(orderStr : string):string;

    function  Check_CARDID_INPUT(Strs:String):boolean;
    
    procedure sendData();
    procedure sendData_Barcode();
    function  exchData(orderStr : string):string;
    function  exchData_Barcode(orderStr : string):string;
    
    function  Make_Send_CMD(StrCMD : string;StrIncValue : string):string;
    procedure INcrevalue(S: string);
    procedure INcrevalue_Barcode(S: string);
    
    procedure CheckCMD_BarCodeCom2();


  public
    { Public declarations }
  end;

var
  frm_QC_AE_LineBarscan: Tfrm_QC_AE_LineBarscan;
  curOrderNo : integer=0;
  curOperNo : integer=0;
  curScanNo : integer=0;
  TotalCore : integer=0;
  Operate_No: integer=0;

  curOrderNo_Barcode : integer=0;
  curOperNo_Barcode : integer=0;
  curScanNo_Barcode : integer=0;
  TotalCore_Barcode : integer=0;
  Operate_No_Barcode: integer=0;

  BAR1_CARDNO,BAR2_CARDNO :STRING;
  Tuibi_Operate_Enable :STRING;
  buffer : array [0..2048] of byte;
  BAR_Type1,BAR_Type2:string;
  orderLst,recDataLst,recData_fromICLst : Tstrings;


  orderLst_Barcode,recDataLst_Barcode,recData_fromICLst_Barcode : Tstrings;

  User_Pwd_Comfir:boolean;
  strInvalidresult :string ='1111';

implementation
 uses SetParameterUnit,ICDataModule,ICCommunalVarUnit,ICEventTypeUnit,ICFunctionUnit;
{$R *.dfm}


 procedure Tfrm_QC_AE_LineBarscan.InitDataBase_barflow;
var
  strSQL:String;
begin
  with ADOQuery_Bar do begin
    Connection := DataModule_3F.ADOConnection_Main;
    Active:=false;
    SQL.Clear;
    strSQL:='select top 5 * from [3F_BARFLOW] order by datetime_scan desc';
    SQL.Add(strSQL);
    Active:=True;
    end;

end;

 procedure Tfrm_QC_AE_LineBarscan.InitDataBase_Tuibi;
var
  strSQL:String;
begin
  with ADOQuery_Tuibi do begin
    Connection := DataModule_3F.ADOConnection_Main;
    Active:=false;
    SQL.Clear;
    strSQL:='select top 5 * from [TMembeDetail] where ID_UserCard_TuiBi_Flag=''1''  order by tuibi_time desc ';

    SQL.Add(strSQL);
    Active:=True;
    end;

end;



procedure Tfrm_QC_AE_LineBarscan.FormClose(Sender: TObject;
  var Action: TCloseAction);
var
    i: integer;
begin
    //清理表格
    for i:=0 to ComponentCount-1 do
         begin
                 if components[i] is TEdit then
                 begin
                    (components[i] as TEdit).Clear;
                  end
         end;

    orderLst.Free();
    recDataLst.Free();
    recData_fromICLst.Free();
    comReader.StopComm();
    BarCodeCOM2.StopComm();
    ICFunction.ClearIDinfor;//清除从ID读取的所有信息

end;



procedure Tfrm_QC_AE_LineBarscan.FormCreate(Sender: TObject);
begin
   //  EventObj:=EventUnitObj.Create;
  //   EventObj.LoadEventIni;




end;


function  Tfrm_QC_AE_LineBarscan.Query_GameName(Strs:String):String;//查询机台名称
var
  ADOQTemp:TADOQuery;
  strSQL:String;
  reTmpStr:String;
begin
                 ADOQTemp:=TADOQuery.Create(nil);
                 strSQL:= 'select distinct [GameName] from [TGameSet] where GameNo='''+Strs+'''';
                 with ADOQTemp do
                 begin
                        Connection := DataModule_3F.ADOConnection_Main;
                        SQL.Clear;
                        SQL.Add(strSQL);
                        Active:=True;
                        if(RecordCount>0) then
                             reTmpStr:=TrimRight(ADOQTemp.Fields[0].AsString)
                        else
                        exit;
                  end;
                  FreeAndNil(ADOQTemp);
    Result := reTmpStr;
end;

//确认当前条码上的卡头ID是否已经存在
function  Tfrm_QC_AE_LineBarscan.Check_CARDID_INPUT(Strs:String):boolean;//查询机台名称
var
  ADOQTemp:TADOQuery;
  strSQL:String;
  reTmpStr:boolean;
begin
      reTmpStr:=false;
                 ADOQTemp:=TADOQuery.Create(nil);
                 strSQL:= 'select count([MID]) from [TChargMacSet] where Card_ID_MC='''+Strs+'''';
                 with ADOQTemp do
                 begin
                        Connection := DataModule_3F.ADOConnection_Main;
                        SQL.Clear;
                        SQL.Add(strSQL);
                        Active:=True;
                        if (ADOQTemp.Fields[0].AsInteger) >0 THEN
                          begin
                             reTmpStr:=true;
                          end;

                  end;
                  FreeAndNil(ADOQTemp);


     Result := reTmpStr;
end;

//保存当前记录，包括流水号、积分值等信息
procedure  Tfrm_QC_AE_LineBarscan.SaveData_Bar(StrFlowBar:string; StrCoreBar : string);
var
  strSQL:String;
  str1:String;
  strOperatetime : string;
  tmptotalcore : integer;
begin
 SaveData_OK_flag:=false;
    str1:=Query_GameNo(TrimRight(Edit_CARDID.Text));
    //确认是否已经录入的卡头ID号
    if not Check_CARDID_INPUT(TrimRight(Edit_CARDID.Text)) THEN
     begin
        ShowMessage('当前条码的卡头ID号，在此系统未注册登陆！');
        exit;
     end;

    if(strtoint(TrimRight(Edit_BiLi.Text))>20000) then
      begin
           Edit_BiLi.Text := '';
           Edit_core.Text := '';  
           MessageDlg('扫描异常，请重新扫描',mtConfirmation,[mbYes,mbNo],0);

           exit;
    end;

    strSQL:='select * from [3F_BARFLOW] order by datetime_operate desc';

    with ADOQuery_Bar do begin
    Connection := DataModule_3F.ADOConnection_Main;
    Active:=false;
    SQL.Clear;
    SQL.Add(strSQL);
    Active:=true;
    Append;
    FieldByName('FLOWbar').AsString:=StrFlowBar;
    FieldByName('COREbar').AsString:=StrCoreBar;
    FieldByName('GameNo').AsString:=str1;
    FieldByName('MacNo').AsString:=Query_MacNo(Edit_CARDID.Text);
    FieldByName('GameName').AsString:=Query_GameName(str1);
    FieldByName('CARDID').AsString:=Edit_CARDID.Text; //卡头ID
    FieldByName('Scaner').AsString:=G_User.UserName; //操作员
    FieldByName('CORE').AsString:=TrimRight(Edit_BiLi.Text);//Edit_Core.text;
    tmptotalcore := strtoint(TrimRight(Edit_BiLi.Text)) * strtoint(SystemWorkground.exchangerate);//Edit_Core.text;

    if length(TrimRight(Edit_BiLi.Text))<>0 then
      begin
          TotalCore:=TotalCore+StrToInt(TrimRight(Edit_BiLi.Text));
          Edit_Total.Text:=IntToStr(TotalCore);
      end
    else
      begin
          Edit_Total.Text:=IntToStr(TotalCore);
      end;
      
    strOperatetime :=copy(formatdatetime('yyyy-MM-dd HH:mm:ss',now),1,4)+'-'+copy(edit_datetime.text,1,5)+copy(edit_datetime.text,8,6)+':00';
    FieldByName('DATETIME_OPERATE').AsString:=strOperatetime;//出票时间 (需要处理)
    FieldByName('DATETIME_SCAN').AsString:=FormatDateTime('yyyy-MM-dd HH:mm:ss',now); //扫描时间
    FieldByName('COREVALU_Bili').AsString:=TrimRight(Edit_BiLi.Text);


      			   if not (CheckBox_Menber.Checked) then //没有选择取消检测
        			begin
         					FieldByName('IDCardNo').AsString:=TrimRight(Edit_ID.Text);//会员卡ID
        			end
    					else
        			begin
         					FieldByName('IDCardNo').AsString:=G_User.UserName;//操作管理员卡ID
        			end;
            	FieldByName('Query_Enable').AsString:='1';//默认为允许查询
            	Post;
            	Active:=False;

      
     end;//with

        if not (CheckBox_Update.Checked) then //没有选择连续操作
        begin
          if(MessageDlg('需要继续吗?',mtConfirmation,[mbYes,mbNo],0)=mrYes) then
              begin
                CheckBox_Update.Checked:=true;
              end
          else
              begin
                User_Pwd_Comfir:=false;//复位密码确认标识
                Edit_UserPwd.Text:='';
                Edit_Password.Text:='';
                Edit_ID.Text:='';
                ClearText;
                Close;
              end;//if
        end;
        SaveData_OK_flag:=true; //保存操作完成              



    
end;




function  Tfrm_QC_AE_LineBarscan.Query_MacNo(Strs:String):String;//查询机台位
var
  ADOQTemp:TADOQuery;
  strSQL:String;
  reTmpStr:String;
begin
                 ADOQTemp:=TADOQuery.Create(nil);
                 strSQL:= 'select distinct [MacNo] from [TChargMacSet] where Card_ID_MC='''+Strs+'''';
                 with ADOQTemp do
                 begin
                        Connection := DataModule_3F.ADOConnection_Main;
                        SQL.Clear;
                        SQL.Add(strSQL);
                        Active:=True;
                        if(RecordCount>0) then
                             reTmpStr:=TrimRight(ADOQTemp.Fields[0].AsString)
                        else
                        exit;
                  end;
                  FreeAndNil(ADOQTemp);
    Result := reTmpStr;
end;

function  Tfrm_QC_AE_LineBarscan.Query_GameNo(Strs:String):String;//查询机台位
var
  ADOQTemp:TADOQuery;
  strSQL:String;
  reTmpStr:String;
begin
                 ADOQTemp:=TADOQuery.Create(nil);
                 strSQL:= 'select distinct [GameNo] from [TChargMacSet] where Card_ID_MC='''+Strs+'''';
                 with ADOQTemp do
                 begin
                        Connection := DataModule_3F.ADOConnection_Main;
                        SQL.Clear;
                        SQL.Add(strSQL);
                        Active:=True;
                        if(RecordCount>0) then
                             reTmpStr:=TrimRight(ADOQTemp.Fields[0].AsString)
                        else
                        exit;
                  end;
                  FreeAndNil(ADOQTemp);
    Result := reTmpStr;
end;



procedure  Tfrm_QC_AE_LineBarscan.ClearText;
begin
Edit_BarScan.text:='';
Edit_Core.text:='';
Edit_CARDID.text:='';
Edit_DateTime.text:='';
Barflow1.text:='';
Barflow2.text:='';
end;

procedure Tfrm_QC_AE_LineBarscan.FormShow(Sender: TObject);
begin
    //Edit1.Text:=FormatDateTime('yyyy-MM-dd HH:mm:ss',now);

   // pgcMachinerecord.Pages[1].TabVisible := false;
    
    InitDataBase_barflow;
    InitDataBase_Tuibi;
    //加载配置文件
    ICFunction.InitSystemWorkground;
    
 //   MSCbarcode.PortOpen := true;//打开端口   ,此语句需要处理，与IC卡系统的SPCOM冲突，强壮端口号
    Edit_ID.Text:='';
    Edit_BarScan.Text:='';
    Edit_UserPwd.Text:='';
    Edit_Core.Text:='';
    Edit_BiLi.Text:='';
    Edit_CARDID.Text:='';
    Edit_DateTime.Text:='';
    Edit_LastCardID.Text:='';
    Barflow1.text:='';
    Barflow2.text:='';
    Edit_Total.Text:='';
    TotalCore:=0;
    Tuibi_Operate_Enable:='0';
    Edit_Total.Text:=IntToStr(TotalCore);

    //Edit_BarScan.SetFocus;
 
     CheckBox_Update.Checked:=false;
     CheckBox_Update.Enabled:=false;//允许进行选择连续操作
     CheckBox_Menber.Checked:=false;

  
    if INit_Wright.MenberControl_short='1' then
       begin
          Panel_Infor.Caption :='操作前务必刷会员卡，并输入会员卡密码';
     {
          comReader.StartComm();
          orderLst:=TStringList.Create;
          recDataLst:=tStringList.Create;
          recData_fromICLst:=tStringList.Create;
       }
          Edit_UserPwd.Enabled:=false;
          User_Pwd_Comfir:=false;//密码确认
       end
    else
       begin
          Panel_Infor.Caption :='当前系统未实行会员制管理，请扫描奖券';
          Edit_UserPwd.Enabled:=false;
       end;

          comReader.StartComm();
          orderLst:=TStringList.Create;
          recDataLst:=tStringList.Create;
          recData_fromICLst:=tStringList.Create;
          
          BarCodeCOM2.StartComm();
          orderLst_BarCode:=TStringList.Create;
          recDataLst_BarCode:=tStringList.Create;
          recData_fromICLst_BarCode:=tStringList.Create;

    ClearText;
    ClearTuibiText;
end;



 //更新此用户币最新充值的记录的退币标志位
procedure Tfrm_QC_AE_LineBarscan.Update_Tuibi_Record(S: string);
var
  ADOQ:TADOQuery;
  strSQL,strRet,strLastRecord,strinputdatetime:String;
  MaxID:String;
  setvalue:String;
begin
  strLastRecord:='1';
  //debug info
//  showmessage(G_User.UserNO);
  strSQL:='select MD_ID from TMembeDetail where ID_UserCard='''+S+''' and LastRecord='''+strLastRecord+'''';
  ADOQ:=TADOQuery.Create(nil);
  with ADOQ do begin
    Connection := DataModule_3F.ADOConnection_Main;
    SQL.Clear;
    SQL.Add(strSQL);
    Open;
    if(not eof) then
      MaxID:=TrimRight(ADOQ.Fields[0].AsString);
    Close;
  end;
   FreeAndNil(ADOQ);

  setvalue:='1';
  strinputdatetime:=FormatDateTime('yyyy-MM-dd HH:mm:ss',now);
   strSQL:='Update TMembeDetail set ID_UserCard_TuiBi_Flag='''+setvalue+''',TuiBi_Time='''+strinputdatetime+''' where MD_ID='''+MaxID+'''';
  //strSQL := 'insert into t_refunddetail select * from TMembeDetail  where MD_ID='''+MaxID+'''';

   ADOQ:=TADOQuery.Create(nil);
  with ADOQ do begin
    Connection := DataModule_3F.ADOConnection_Main;
    SQL.Clear;
    SQL.Add(strSQL);
    ADOQ.ExecSQL;
  end;
    FreeAndNil(ADOQ);

  {
  strSQL:='Update t_refunddetail set ID_UserCard_TuiBi_Flag='''+setvalue+''',TuiBi_Time='''+strinputdatetime+''' '
   + ' ,cUserno='''+G_User.UserNO+''' where MD_ID='''+MaxID+'''';

  ADOQ:=TADOQuery.Create(nil);
  with ADOQ do begin
    Connection := DataModule_3F.ADOConnection_Main;
    SQL.Clear;
    SQL.Add(strSQL);
    ADOQ.ExecSQL;
  end;
    FreeAndNil(ADOQ);
 }
end;

//清除币值
procedure Tfrm_QC_AE_LineBarscan.ClearValue;

  var
  INC_value:string;
  strValue:String;
  i:integer;
begin

         INC_value:='0'; //充值数值
         Operate_No:=1;
         strValue:= Make_Send_CMD(CMD_COUMUNICATION.CMD_INCValue,INC_value);//计算充值指令
         INcrevalue(strValue);

end;

procedure Tfrm_QC_AE_LineBarscan.ClearTuibiText;
begin
    Edit_EBID.text:='';
    Edit4.text:='';
    Edit_EBValue.text:='';
    Edit_Tuibi_Total.text:='';
    
end;

procedure Tfrm_QC_AE_LineBarscan.BitBtn3Click(Sender: TObject);
begin
    //debug info
   // showmessage(Edit_EBID.Text);
  //  if ( Edit_EBID.Text<>'' and StrToInt(Edit_EBValue.Text) > 0  ) then
    if ( StrToInt(TrimRight(Edit_EBValue.Text)) > 0 ) then
       begin
         Panel_Infor.Caption:='退币操作、更新充值记录中，请勿移动币';   
         ClearValue; //清除币中的值
       end
    else
       begin
          ShowMessage('请刷会员卡或取消检测刷用户卡,确认币里有钱，并按要求操作！');
       end;

end;




procedure Tfrm_QC_AE_LineBarscan.BitBtn1Click(Sender: TObject);
begin
  close;
end;

procedure Tfrm_QC_AE_LineBarscan.BitBtn2Click(Sender: TObject);
begin
      if BarCodeValue_OnlyCheck=2 then
         begin
           SaveData_Bar(BarCodeValue_FLOW,BarCodeValue_CORE);
           if SaveData_OK_flag  then
             begin
                 BarCodeValue_OnlyCheck:=0;//清除
             end;
         end;
end;

//查询在24小时内有无充值记录
function  Tfrm_QC_AE_LineBarscan.Query_Menber_IncRecord(StrID:String):boolean;
var
  ADOQTemp:TADOQuery;
  strSQL:String;
  reTmpStr:String;
  strtime_OK,strtemp:String;
  strRet:boolean;
begin
                 strtemp:=FormatDateTime('yyyy-MM-dd HH:mm:ss',now);
                 //Edit1.Text:=strtemp; //取得开始日期;
                 //strtime_OK:=Copy(strtemp,1,10);  //查询当天，到目前为止，有无充值记录
                 strtime_OK:=ICFunction.GetInvalidDate(strtemp); //取得开始日期;

                 //Edit2.Text:=strtime_OK; //取得开始日期;
                 ADOQTemp:=TADOQuery.Create(nil);
                 strSQL:= 'select count(IDCardNo) from [TMembeDetail] where (IDCardNo='''+StrID+''') and ((GetTime<'''+strtemp+''') and (GetTime>'''+strtime_OK+'''))';
                

                 Result:=false;
                 with ADOQTemp do
                 begin
                    Connection := DataModule_3F.ADOConnection_Main;
                    SQL.Clear;
                    SQL.Add(strSQL);
                    Open;
                    if(not eof) then
                    begin
                       if (ADOQTemp.Fields[0].AsInteger>0) then
                          begin
                             Result:=true;
                          end
                       else
                          begin
                             Result:=false;
                          end;
                       Close;
                    end;
                  FreeAndNil(ADOQTemp);
                end;
end;



//查询在24小时内有无充值记录
function  Tfrm_QC_AE_LineBarscan.Query_Menber_IncRecord_by_EBid(StrID:String):boolean;
var
  ADOQTemp:TADOQuery;
  strSQL:String;
  reTmpStr:String;
  strtime_OK,strtemp:String;
  strRet:boolean;
begin
                 strtemp:=FormatDateTime('yyyy-MM-dd HH:mm:ss',now);

                 //strtime_OK:=Copy(strtemp,1,10);  //查询当天，到目前为止，有无充值记录
                 strtime_OK:=ICFunction.GetInvalidDate(strtemp); //取得开始日期;
                 ADOQTemp:=TADOQuery.Create(nil);
                 //strSQL:= 'select count(ID_UserCard) from [TMembeDetail] where (ID_UserCard='''+StrID+''') and ((GetTime<'''+strtemp+''') and (GetTime>'''+strtime_OK+'''))';
                 strSQL:= 'select count(ID_UserCard) from [TMembeDetail] where (ID_UserCard='''+StrID+''') ';
                 Result:=false;
                 with ADOQTemp do
                 begin
                    Connection := DataModule_3F.ADOConnection_Main;
                    SQL.Clear;
                    SQL.Add(strSQL);
                    Open;
                    if(not eof) then
                    begin
                       if (ADOQTemp.Fields[0].AsInteger>0) then
                          begin
                             Result:=true;
                          end
                       else
                          begin
                             Result:=false;
                          end;
                       Close;
                    end;
                  FreeAndNil(ADOQTemp);
                end;
end;


//查询在24小时内有无充值记录
procedure Tfrm_QC_AE_LineBarscan.Query_EBINCinformation_by_EBid(StrID:String);
var
  ADOQTemp:TADOQuery;
  strSQL:String;
  reTmpStr:String;
  strtime_OK,strtemp,strLastRecord:String;
  strRet:boolean;
begin
                 strLastRecord:='1';   //当前电子币的最新充值记录标志
                 strtemp:=FormatDateTime('yyyy-MM-dd HH:mm:ss',now);

                 //strtime_OK:=Copy(strtemp,1,10);  //查询当天，到目前为止，有无充值记录
                 strtime_OK:=ICFunction.GetInvalidDate(strtemp); //取得开始日期;
                 ADOQTemp:=TADOQuery.Create(nil);
                 strSQL:= 'select GetTime from [TMembeDetail] where (ID_UserCard='''+StrID+''') and ((GetTime<'''+strtemp+''') and (GetTime>'''+strtime_OK+''')) and (LastRecord='''+strLastRecord+''') ';
                
                 with ADOQTemp do
                 begin
                    Connection := DataModule_3F.ADOConnection_Main;
                    SQL.Clear;
                    SQL.Add(strSQL);
                    Open;
                    if(not eof) then
                    begin
                       Edit4.text:=ADOQTemp.Fields[0].AsString;
                       Close;
                    end;
                  FreeAndNil(ADOQTemp);
                end;
end;

//查询所有的退币记录
procedure Tfrm_QC_AE_LineBarscan.Query_Tuibi_Total(StrID:String);
var
  ADOQTemp:TADOQuery;
  strSQL:String;
  reTmpStr:String;
  strtime_OK,strtemp,strTuibi:String;
  strRet:boolean;
begin
                 strTuibi:='1';   //当前电子币的最新充值记录标志
                 strtemp:=FormatDateTime('yyyy-MM-dd HH:mm:ss',now);

                 //strtime_OK:=Copy(strtemp,1,10);  //查询当天，到目前为止，有无充值记录
                 strtime_OK:=ICFunction.GetInvalidDate(strtemp); //取得开始日期;
                 ADOQTemp:=TADOQuery.Create(nil);
                 strSQL:= 'select sum(TotalMoney) from [TMembeDetail] where (IDCardNo='''+StrID+''') and (ID_UserCard_TuiBi_Flag='''+strTuibi+''') ';
                 //strSQL:= 'select sum(TotalMoney) from [t_refunddetail] where (IDCardNo='''+StrID+''') and (ID_UserCard_TuiBi_Flag='''+strTuibi+''') ';
                
                 with ADOQTemp do
                 begin
                    Connection := DataModule_3F.ADOConnection_Main;
                    SQL.Clear;
                    SQL.Add(strSQL);
                    Open;
                    if(not eof) then
                    begin
                       Edit_Tuibi_Total.text:=ADOQTemp.Fields[0].AsString;
                       Close;
                    end;
                  FreeAndNil(ADOQTemp);
                end;
end;



//计算充值指令
function Tfrm_QC_AE_LineBarscan.Make_Send_CMD(StrCMD : string;StrIncValue : string):string;
var
    ii,jj,KK : integer;
    TmpStr_IncValue : string;//充值数字
    TmpStr_CheckSum : string;//校验和
    TmpStr_SendCMD : string;//指令内容
    reTmpStr : string;
begin
    Send_CMD_ID_Infor.CMD:=StrCMD;//帧命令
    Send_CMD_ID_Infor.ID_INIT:=Receive_CMD_ID_Infor.ID_INIT;

    //------------20120320追加写币有效期 开始-----------
    //FormatDateTime('yyyy-MM-dd HH:mm:ss',now);
    //Send_CMD_ID_Infor.ID_3F:=Receive_CMD_ID_Infor.ID_3F;
    //Send_CMD_ID_Infor.Password_3F:=Receive_CMD_ID_Infor.Password_3F;
    if iHHSet=0 then  //时间限制设置无效
      begin
        Send_CMD_ID_Infor.ID_3F:=IntToHex(0,2)+IntToHex(0,2)+IntToHex(0,2);
        Send_CMD_ID_Infor.Password_3F:=IntToHex(0,2)+IntToHex(0,2)+IntToHex(0,2);
      end
    else             //起用时间设置
      begin
        GetInvalidDate;
      end;

    //------------20120320追加写币有效期 结束-----------



    Send_CMD_ID_Infor.Password_USER:=Receive_CMD_ID_Infor.Password_USER;
    //TmpStr_IncValue字节需要重新排布 ，如果StrIncValue>65535(FFFF)
   // TmpStr_IncValue:=IntToHex(strToint(StrIncValue),2);//将输入的文本数字转换为16进制
    //------------20120220追加代币比例SystemWorkground.ErrorGTState 开始-----------
    //TmpStr_IncValue:= StrIncValue;
    TmpStr_IncValue:= IntToStr(StrToInt(StrIncValue)*StrToInt(SystemWorkground.ErrorGTState));
    //------------20120220追加代币比例 结束-----------
    Send_CMD_ID_Infor.ID_value:=Select_IncValue_Byte(TmpStr_IncValue);
    
    //卡功能类型
    Send_CMD_ID_Infor.ID_type:=Receive_CMD_ID_Infor.ID_type;
    //汇总发送内容
    TmpStr_SendCMD:=Send_CMD_ID_Infor.CMD+ Send_CMD_ID_Infor.ID_INIT+Send_CMD_ID_Infor.ID_3F+Send_CMD_ID_Infor.Password_3F+Send_CMD_ID_Infor.Password_USER+Send_CMD_ID_Infor.ID_value+Send_CMD_ID_Infor.ID_type;
    //将发送内容进行校核计算
    TmpStr_CheckSum:=CheckSUMData(TmpStr_SendCMD);
    //TmpStr_CheckSum字节需要重新排布 ，低字节在前，高字节在后
    Send_CMD_ID_Infor.ID_CheckNum:=Select_CheckSum_Byte(TmpStr_CheckSum);
    Send_CMD_ID_Infor.ID_Settime:=Receive_CMD_ID_Infor.ID_Settime;


    reTmpStr:=TmpStr_SendCMD+Send_CMD_ID_Infor.ID_CheckNum;

    result:=reTmpStr;

end;


//取得有效时间日期
procedure Tfrm_QC_AE_LineBarscan.GetInvalidDate;
var
 strtemp:string;
 iYear,iMonth,iDate,iHH,iMin:integer;
begin


    strtemp:=FormatDateTime('yyyy-MM-dd HH:mm:ss',now);
    //调整前
   // strtemp:=Copy(strtemp,1,2)+Copy(strtemp,3,2)+Copy(strtemp,6,2)+Copy(strtemp,9,2)+Copy(strtemp,12,2)+Copy(strtemp,15,2)+Copy(strtemp,20,2);
     //调整后

    iYear:=strToint( Copy(strtemp,1,4)); //年
    iMonth:=strToint( Copy(strtemp,6,2));//月
    iDate:=strToint( Copy(strtemp,9,2)); //日
    iHH:=strToint( Copy(strtemp,12,2)); //小时
    iMin:=strToint( Copy(strtemp,15,2)); //分钟

    if  (iHHSet>47) then
           begin
              showmessage('为了保护您场地利益安全，请设定币有效时间小于48');
              exit;
           end;
   if ((iHH+iHHSet)>=24) and ((iHH+iHHSet)<48) then
     begin
        iHH:=(iHH+iHHSet)-24;//取得新的小时
        if  (iYear<1930) then
           begin
              showmessage('系统时间的年份设定错误，请与卡头对时同步');
              exit;
           end;
        if  (iMonth=2) then
           begin
             if  ((iYear mod 4)=0) or ((iYear mod 100)=0)then //闰年 2月为28日
                begin
                    if (iDate=28) then
                       begin
                           iDate:=1;
                           iMonth:=iMonth+1;
                       end
                    else
                       begin
                          iDate:=iDate+1;
                       end;
                end
             else      //不是闰年  2月为29日
                begin
                    if (iDate=29) then
                       begin
                           iDate:=1;
                           iMonth:=iMonth+1;
                       end
                    else
                       begin
                           iDate:=iDate+1;
                       end;
                end;
           end
        else if  (iMonth=1) or (iMonth=3) or(iMonth=5) or(iMonth=7) or(iMonth=8) or(iMonth=10) then
           begin
                    if (iDate=31) then
                       begin
                           iDate:=1;
                           iMonth:=iMonth+1;
                       end
                    else
                       begin
                          iDate:=iDate+1;
                       end;
           end
        else if  (iMonth=12) then
           begin
                    if (iDate=31) then
                       begin
                           iDate:=1;
                           iMonth:=1;
                           iYear:=iYear+1;
                       end
                    else
                       begin
                          iDate:=iDate+1;
                       end;
           end
        else if  (iMonth=4) or (iMonth=6) or(iMonth=9) or(iMonth=11) then
           begin
                    if (iDate=30) then
                       begin
                           iDate:=1;
                           iMonth:=iMonth+1;
                       end
                    else
                       begin
                          iDate:=iDate+1;
                       end;
           end;
     end
   else if ((iHH+iHHSet)<24) then
     begin
         iHH:=(iHH+iHHSet);//取得新的小时
     end;

     //转换为16进制后
    Send_CMD_ID_Infor.ID_3F:=IntToHex(iMonth,2)+IntToHex(iHH,2)+IntToHex(strtoint(Copy(strtemp,3,2)),2);
    Send_CMD_ID_Infor.Password_3F:=IntToHex(iDate,2)+IntToHex(iMin,2)+IntToHex(strtoint(Copy(strtemp,1,2)),2);
    //strtemp:=Copy(strtemp,6,2)+Copy(strtemp,12,2)+Copy(strtemp,3,2)+Copy(strtemp,9,2)+Copy(strtemp,15,2)+Copy(strtemp,1,2);


end;

procedure Tfrm_QC_AE_LineBarscan.comReaderReceiveData(Sender: TObject;
  Buffer: Pointer; BufferLength: Word);
var
    ii : integer;
    recStr : string;
    tmpStr : string;
    tmpStrend : string;
begin
   //接收----------------
    tmpStrend:= 'STR';
    recStr:='';
    SetLength(tmpStr, BufferLength);
    move(buffer^,pchar(tmpStr)^,BufferLength);
    for ii:=1 to BufferLength do
    begin
        recStr:=recStr+intTohex(ord(tmpStr[ii]),2); //将获得数据转换为16进制数
    
         if  ii=BufferLength then
        begin
           tmpStrend:= 'END';
        end;
    end;
   
      recData_fromICLst.Clear;
      recData_fromICLst.Add(recStr);
    
     begin
         CheckCMD();//首先根据接收到的数据进行判断，确认此卡是否属于为正确的卡

     end;



end;


 //根据接收到的数据判断此卡是否为合法卡
procedure Tfrm_QC_AE_LineBarscan.CheckCMD();
var
    i : integer;
    tmpStr : string;
    stationNoStr : string;
    tmpStr_Hex: string;
    tmpStr_Hex_length: string;
    Send_value:string;
    RevComd: integer;
    ID_No: string;
    length_Data:integer;
begin
   //首先截取接收的信息
       tmpStr:= recData_fromICLst.Strings[0];

       Receive_CMD_ID_Infor.ID_CheckNum := copy(tmpStr, 39, 4);  //校验和
 
      // if (CheckSUMData(copy(tmpStr, 1, 38))=copy(tmpStr, 41, 2)+copy(tmpStr, 39, 2)) then//校验和
          begin
                 CMD_CheckSum_OK:=true;
                 Receive_CMD_ID_Infor.CMD := copy(recData_fromICLst.Strings[0], 1, 2); //帧头43
          end;
          //1、判断清除卡内数据是否为完成
         if  Receive_CMD_ID_Infor.CMD=CMD_COUMUNICATION.CMD_INCValue_RE then
              begin

                  // if  (Customer_Phone.Text<>'') and (CUSTOMER_NO.Text<>'') and (Edit_ID.Text<>'') then
                    begin
                     if  (Operate_No=1)  then  //保存当前卡的初始化记录
                          begin
                           Update_Tuibi_Record(TrimRight(Edit_EBID.Text));
                           //其实是更新充值记录中对应的电子币的最新充值记录
                           Panel_Infor.Caption:='退币操作、更新充值记录成功';
                           Operate_No:=0 ;
                           ClearTuibiText;
                           InitDataBase_Tuibi;
                          end;
                    end;
              end
         //1、判断此卡是否为已经完成初始化                      
        else if Receive_CMD_ID_Infor.CMD=CMD_COUMUNICATION.CMD_READ then
              begin
                 Receive_CMD_ID_Infor.ID_INIT := copy(recData_fromICLst.Strings[0], 3, 8);  //卡片ID
                 Receive_CMD_ID_Infor.ID_3F := copy(recData_fromICLst.Strings[0], 11, 6);  //卡厂ID
                 Receive_CMD_ID_Infor.Password_3F := copy(recData_fromICLst.Strings[0], 17, 6); //卡密
                 Receive_CMD_ID_Infor.Password_USER := copy(recData_fromICLst.Strings[0], 23, 6);  //用户密码
                 Receive_CMD_ID_Infor.ID_value := copy(recData_fromICLst.Strings[0], 29, 8);  //卡内数据
                 Receive_CMD_ID_Infor.ID_type := copy(recData_fromICLst.Strings[0], 37, 2);  //卡功能

               
                 if (Receive_CMD_ID_Infor.ID_type=copy(INit_Wright.RECV_CASE,8,2))then
                   begin
                       if DataModule_3F.Query_ID_OK(Receive_CMD_ID_Infor.ID_INIT) then
                          begin
                            //查询当前会员卡的设定密码
                             Query_MenberInfor(Receive_CMD_ID_Infor.ID_INIT);
                            //查询当前会员卡在24小时内有无充值记录 ，防止是假的会员卡
                             if Query_Menber_IncRecord(Receive_CMD_ID_Infor.ID_INIT) then
                               begin
                                Edit_UserPwd.Enabled:= true; //许可输入旧密码
                                Panel_Infor.Caption:= '验证成功，请您继续操作！';
                                Edit_ID.Text:=Receive_CMD_ID_Infor.ID_INIT;
                                Edit_UserPwd.SetFocus;
                               end
                             else
                               begin
                                Panel_Infor.Caption:= '此会员今天无充值记录！请确认！';
                               end;
                          end
                       else
                          begin
                            Panel_Infor.Caption:= '操作失败，当前卡不属于本场地！';
                            exit;
                          end;
                   end
                 else if ((Receive_CMD_ID_Infor.ID_type=copy(INit_Wright.Produecer_3F,8,2))or(Receive_CMD_ID_Infor.ID_type=copy(INit_Wright.BOSS,8,2)) )then
                    begin
                        if DataModule_3F.Query_ID_OK(LOAD_USER.ID_INIT) then
                          begin
                            Tuibi_Operate_Enable:='1';
                          end
                        else
                          begin
                            Panel_Infor.Caption:= '操作失败，当前卡不属于本场地！';
                            exit;
                          end;
                    end
                 else if ((Receive_CMD_ID_Infor.ID_type=copy(INit_Wright.User,8,2)))then
                    begin
               
                    if not (CheckBox_Menber.Checked) then //没有选择取消检测
                    //if INit_Wright.MenberControl_short='1' then
                       begin

                        if Tuibi_Operate_Enable='1' then //已经成功刷会员卡
                          begin
                            //1、查询充值记录中是否有此币，防止假的电子币
                              if Query_Menber_IncRecord_by_EBid(Receive_CMD_ID_Infor.ID_INIT) then
                               begin
                                //获得电子币ID
                                Edit_EBID.Text:=Receive_CMD_ID_Infor.ID_INIT;


                                //获得电子币币值
                                Edit_EBValue.Text:=ICFunction.Select_ChangeHEX_DECIncValue(Receive_CMD_ID_Infor.ID_value);


                                //查询当前电子币最后的充值记录，以获得充值时间
                                Query_EBINCinformation_by_EBid(Receive_CMD_ID_Infor.ID_INIT);
                               //查询当前会员总的退币值
                                Query_Tuibi_Total(TrimRight(Edit_ID.Text));

                                Panel_Infor.Caption:= '此电子币有充值记录，验证OK！';
                               end
                             else
                               begin
                                Panel_Infor.Caption:= '此电子币无充值记录！请确认！';
                               end;

                         end
                        else
                          begin
                            Panel_Infor.Caption:= '操作失败，请先刷会员卡或老板卡！';
                            exit;
                          end;
                       end
                      else   //取消会员检测
                       begin
                       //1、查询充值记录中是否有此币，防止假的电子币
                              if Query_Menber_IncRecord_by_EBid(Receive_CMD_ID_Infor.ID_INIT) then
                               begin
                                //获得电子币ID
                                Edit_EBID.Text:=Receive_CMD_ID_Infor.ID_INIT;
                                //获得电子币币值
                                Edit_EBValue.Text:=ICFunction.Select_ChangeHEX_DECIncValue(Receive_CMD_ID_Infor.ID_value);


                                //查询当前电子币最后的充值记录，以获得充值时间
                                Query_EBINCinformation_by_EBid(Receive_CMD_ID_Infor.ID_INIT);
                               //查询当前会员总的退币值
                                Query_Tuibi_Total(TrimRight(Edit_ID.Text));

                                Panel_Infor.Caption:= '此电子币有充值记录，验证OK！';
                               end
                             else
                               begin
                                Panel_Infor.Caption:= '此电子币无充值记录！请确认！';
                               end;
                       end;
                    end
                 else  //不是万能卡AA，也不是会员卡
                   begin
                          Panel_Infor.Caption:= '操作失败，当前卡不属于本场地！';
                          exit;
                   end;
             end;

end;

 //查询当前会员卡的旧密码
procedure Tfrm_QC_AE_LineBarscan.Query_MenberInfor(StrID:String);
var
  ADOQTemp:TADOQuery;
  strSQL:String;
  reTmpStr:String;
    strsexOrg:String;
begin
                 ADOQTemp:=TADOQuery.Create(nil);
                 strSQL:= 'select * from [TMemberInfo] where IDCardNo='''+StrID+'''';

                 with ADOQTemp do
                 begin
                        Connection := DataModule_3F.ADOConnection_Main;
                        SQL.Clear;
                        SQL.Add(strSQL);
                        Active:=True;

                        Edit_Password.text:=TrimRight(FieldByName('InfoKey').AsString);  //查询会员卡密码

                  end;
                  FreeAndNil(ADOQTemp);
end;

procedure Tfrm_QC_AE_LineBarscan.Edit_UserPwdKeyPress(Sender: TObject;
  var Key: Char);
begin

     if not (key in['0'..'9',#8,#13])then
       begin
          key:=#0;
          ShowMessage('输入错误，只能输入数字！');
       end
     else if key=#13 then
     begin
         if (Edit_UserPwd.Text<>'') and (TrimRight(Edit_UserPwd.Text)=TrimRight(Edit_Password.Text)) and (length(TrimRight(Edit_UserPwd.Text))=6) then
                begin

                     User_Pwd_Comfir:=true;//密码确认
                     //Edit_BarScan.SetFocus;
                     Edit_Total.Text:='';
                     CheckBox_Update.Enabled:=true;//允许进行选择连续操作
                     Tuibi_Operate_Enable:='1';
                end
         else
                begin

                     ShowMessage('输入错误，确认密码与当前会员卡不匹配！');
                     Edit_Total.Text:='';
                     Tuibi_Operate_Enable:='0';
                     Edit_UserPwd.SetFocus;

                     exit;                    
                end;
     end;
end;
 {
procedure Tfrm_QC_AE_LineBarscan.BitBtn4Click(Sender: TObject);
var
  ADOQTemp:TADOQuery;
  strSQL:String;
  reTmpStr:String;
  strtime_OK,strtemp:String;
  strRet:boolean;
begin
                 strtemp:=FormatDateTime('yyyy-MM-dd HH:mm:ss',now);

                 //strtime_OK:=Copy(strtemp,1,10);  //查询当天，到目前为止，有无充值记录
                 strtime_OK:=ICFunction.GetInvalidDate(strtemp); //取得开始日期;
                 Edit1.Text:=strtime_OK;
                 Edit2.Text:=strtemp;

end;
 }



 //充值函数
procedure Tfrm_QC_AE_LineBarscan.INcrevalue(S: string);
begin
    orderLst.Clear();
    recDataLst.Clear();
    curOrderNo:=0;
    curOperNo:=2;
    //Edit1.Text:=s;
    orderLst.Add(S); //将币值写入币种
    sendData();
end;

procedure Tfrm_QC_AE_LineBarscan.INcrevalue_Barcode(S: string);
begin
    orderLst_Barcode.Clear();
    recDataLst_Barcode.Clear();
    curOrderNo_Barcode:=0;
    curOperNo_Barcode:=2;
    //Edit1.Text:=s;
    orderLst_Barcode.Add(S); //将币值写入币种
    sendData_Barcode();
end;

//转找发送数据格式
function Tfrm_QC_AE_LineBarscan.exchData(orderStr : string):string;
var
    ii,jj : integer;
    TmpStr : string;
    reTmpStr : string;
begin
    if (length(orderStr)=0) then
    begin
        MessageBox(handle,'传入参数不能为空!','错误',MB_ICONERROR+MB_OK);
        result:='';
        exit;
    end;
    if (length(orderStr) mod 2)<>0 then
    begin
        MessageBox(handle,'传入参数错误!','错误',MB_ICONERROR+MB_OK);
        result:='';
        exit;
    end;
    for ii:=1 to (length(orderStr) div 2) do
    begin
        tmpStr:=copy(orderStr,ii*2-1,2);
        jj:=strToint('$'+tmpStr);
        reTmpStr:=reTmpStr+chr(jj);
    end;
    result:=reTmpStr;
end;

//转找发送数据格式
function Tfrm_QC_AE_LineBarscan.exchData_Barcode(orderStr : string):string;
var
    ii,jj : integer;
    TmpStr : string;
    reTmpStr : string;
begin
    if (length(orderStr)=0) then
    begin
        MessageBox(handle,'传入参数不能为空!','错误',MB_ICONERROR+MB_OK);
        result:='';
        exit;
    end;
    if (length(orderStr) mod 2)<>0 then
    begin
        MessageBox(handle,'传入参数错误!','错误',MB_ICONERROR+MB_OK);
        result:='';
        exit;
    end;
    for ii:=1 to (length(orderStr) div 2) do
    begin
        tmpStr:=copy(orderStr,ii*2-1,2);
        jj:=strToint('$'+tmpStr);
        reTmpStr:=reTmpStr+chr(jj);
    end;
    result:=reTmpStr;
end;
//发送数据过程
procedure Tfrm_QC_AE_LineBarscan.sendData();
var
    orderStr : string;
begin
    if orderLst.Count>curOrderNo then
    begin
        orderStr:=orderLst.Strings[curOrderNo];
        //memComSeRe.Lines.Add('==>> '+orderStr);
        orderStr:=exchData(orderStr);
        comReader.WriteCommData(pchar(orderStr),length(orderStr));
        inc(curOrderNo);
    end;
end;

//发送数据过程
procedure Tfrm_QC_AE_LineBarscan.sendData_Barcode();
var
    orderStr : string;
begin
    if orderLst.Count>curOrderNo then
    begin
        orderStr:=orderLst.Strings[curOrderNo];
        //memComSeRe.Lines.Add('==>> '+orderStr);
        orderStr:=exchData_Barcode(orderStr);
        BarCodeCOM2.WriteCommData(pchar(orderStr),length(orderStr));
        inc(curOrderNo_Barcode);
    end;
end;
//充值数据转换成16进制并排序 字节LL、字节LH、字节HL、字节HH
function Tfrm_QC_AE_LineBarscan.Select_IncValue_Byte(StrIncValue : string):string;
VAR
 tempLH,tempHH,tempHL,tempLL:integer; //2147483648 最大范围
begin
    tempHH:=StrToint(StrIncValue) div 16777216;  //字节HH
    tempHL:=(StrToInt(StrIncValue) MOD 16777216) div 65536;//字节HL
    tempLH:=(StrToInt(StrIncValue) MOD 65536)div 256; //字节LH
    tempLL:=StrToInt(StrIncValue) MOD 256;//字节LL

    result:=IntToHex(tempLL,2)+IntToHex(tempLH,2)+IntToHex(tempHL,2)+IntToHex(tempHH,2);
end;

//校验和转换成16进制并排序 字节LL、字节LH
function Tfrm_QC_AE_LineBarscan.Select_CheckSum_Byte(StrCheckSum: string):string;
VAR
 jj:integer;
 tempLH,tempLL:integer; //2147483648 最大范围

begin
    jj:=strToint('$'+StrCheckSum); //将字符转转换为16进制数，然后转换位10进制
    tempLH:=(jj MOD 65536)div 256; //字节LH
    tempLL:=jj MOD 256;//字节LL

    result:=IntToHex(tempLL,2)+IntToHex(tempLH,2);
end;

//校验和，确认是否正确
function Tfrm_QC_AE_LineBarscan.CheckSUMData(orderStr : string):string;
var
    ii,jj,KK : integer;
    TmpStr : string;
    reTmpStr : string;
begin
    if (length(orderStr) mod 2)<>0 then
    begin
        MessageBox(handle,'传入参数长度错误!','错误',MB_ICONERROR+MB_OK);
        result:='';
        exit;
    end;
   KK:=0;
    for ii:=1 to (length(orderStr) div 2) do
    begin
        tmpStr:=copy(orderStr,ii*2-1,2);
        jj:=strToint('$'+tmpStr);
        KK:=KK+jj;

    end;
        reTmpStr:=IntToHex(KK,2);
    result:=reTmpStr;
end;

procedure Tfrm_QC_AE_LineBarscan.BitBtn4Click(Sender: TObject);
begin
    Query_Menber_IncRecord('');
end;




 //根据接收到的数据判断此卡是否为合法卡
procedure Tfrm_QC_AE_LineBarscan.CheckCMD_BarCodeCom2();
var
    i : integer;
    tmpStr : string;
    tmpStr_Barcode : string;

    stationNoStr : string;
    tmpStr_Hex: string;
    tmpStr_Hex_length: string;
    Send_value:string;
    RevComd: integer;
    ID_No: string;
    length_Data:integer;

    strTemp:String;
    tempStr :String;
    firstbit :String; //确定扫描的是哪一个条码
    Firstframe_hex:string;
begin
    
    if INit_Wright.MenberControl_short='1' then
       begin

        if not (CheckBox_Menber.Checked) then //没有选择取消检测
       // if INit_Wright.MenberControl_short='1' then
        begin
         if not (CheckBox_Update.Checked) then //没有选择连续操作
            begin
             if not User_Pwd_Comfir then   //因为未实行会员制管理，所以可以扫描操作
              begin
                ShowMessage('请先刷会员卡，并输入会员卡密码！验证通过后再扫描兑奖券！');
                BarCodeValue :='';
                exit;
              end;
            end;
        end;
       end;

       
   //首先截取接收的信息
       tmpStr_Barcode:= recData_fromICLst_Barcode.Strings[0];
       Edit1.Text:='';
       Edit1.Text:=tmpStr_Barcode;
       Edit2.Text:=BarCodeFirstFrame[0];
       Edit3.Text:=BarCodeFirstFrame[1];
       
       Firstframe_hex:=copy(tmpStr_Barcode, 1, 2);

       BarCodeValue:=ICFunction.ChangeAreaHEXToStr(copy(tmpStr_Barcode, 3, length(tmpStr_Barcode)-2));
      if (Firstframe_hex='39') then
         begin
            firstbit:='A';
         end
      else if (Firstframe_hex='30') then
         begin
            firstbit:='B';
         end
      else if (Firstframe_hex=BarCodeFirstFrame[0]) then
         begin
            firstbit:='A';
         end
      else if (Firstframe_hex=BarCodeFirstFrame[1]) then
         begin
            firstbit:='B';
         end
      else if (Firstframe_hex=BarCodeFirstFrame[2]) then
         begin
            firstbit:='C';//35
         end
      else if (Firstframe_hex=BarCodeFirstFrame[3]) then
         begin
            firstbit:='D';//36
         end
      else if (Firstframe_hex=BarCodeFirstFrame[4]) then
         begin
            firstbit:='E';//37
         end
      else
         begin
                ShowMessage('非法条码,请确认是否为本场地条码！');
                BarCodeValue :='';
                exit;
         end;

    begin
      tempStr:='0'+BarCodeValue ;
      Edit6.Text:=tempStr;
      Panel_Infor.Caption:='';
      Edit5.Text:=inttostr(length(tempStr));
      
        //流水机台条码，9-A
      if (firstbit='A') and ((length(tempStr)=21) or (length(tempStr)=20) ) then
      //条码1
         begin
             begin
                 BAR_Type1:='A';
                 Edit_BarScan.Text:='';
                 Edit_BarScan.Text :=tempStr;
                 BarCodeValue_FLOW :=tempStr;  //条码1
                 BarCodeValue:='';

                 //出票时间
                 Edit_DateTime.Text:= copy(tempStr, 15,1)+copy(tempStr, 12,1)+'-'+copy(tempStr, 4,1)+copy(tempStr, 7,1)+'   '+copy(tempStr, 2,1)+copy(tempStr, 18,1)+':'+copy(tempStr, 10,1)+copy(tempStr, 5,1);
                 //追加判断月份不能大于12，日期不能大于31、小时不能大于24，分钟不能大于59

                // Edit_CARDID.Text :=copy(tempStr, 11,1)+copy(tempStr, 6,1)+copy(tempStr, 13,1);
                // BAR1_CARDNO:=copy(tempStr, 11,1)+copy(tempStr, 6,1)+copy(tempStr, 13,1);
                //2016年01月08日修正
                if  (length(tempStr)=21) then
                  begin
                    Edit_CARDID.Text :=copy(tempStr, 20,1)+copy(tempStr, 11,1)+copy(tempStr, 6,1)+copy(tempStr, 13,1);
                    BAR1_CARDNO:=copy(tempStr, 20,1)+copy(tempStr, 11,1)+copy(tempStr, 6,1)+copy(tempStr, 13,1);
                  end
                else if (length(tempStr)=20) then
                  begin
                    Edit_CARDID.Text :=copy(tempStr, 11,1)+copy(tempStr, 6,1)+copy(tempStr, 13,1);
                    BAR1_CARDNO:=copy(tempStr, 11,1)+copy(tempStr, 6,1)+copy(tempStr, 13,1);
                  end;
                 //追加查询数据表中是否有此卡头记录，如果无则认为是非法
                 Barflow1.text:= copy(tempStr, 3,1)+copy(tempStr, 9,1)+copy(tempStr, 17,1)+copy(tempStr, 14,1)+copy(tempStr, 19,1)+copy(tempStr, 8,1)+copy(tempStr, 16,1);
               
                 //追加流水号唯一判断

                 //modified by linlf
                 strInvalidresult := copy(tempstr,15,1)+copy(tempstr,12,1)+copy(tempstr,4,1)+copy(tempstr,7,1);

                    
             end;
         end
         //积分条码，0-B
      else if (firstbit='B')  and ((length(tempStr)=23) or (length(tempStr)=22))   then
      //条码2
         begin
             begin
                 BAR_Type2:='B';
                 Edit_BarScan.Text:='';
                 BarCodeValue_CORE :=tempStr;
                 //Edit_BarScan.Text :=copy(tempStr, 2,20);
                 Edit_BarScan.Text :=copy(tempStr, 2,21);
                 BarCodeValue:='';
                 
                 //积分
                 Edit_Core.Text:=IntToStr(StrToInt(copy(tempStr,3,1)+copy(tempStr,5,1)+copy(tempStr,11,1)+copy(tempStr,20,1)+copy(tempStr,17,1)+copy(tempStr,7,1)+copy(tempStr,14,1)) div 1);
                // Edit_BiLi.Text:=IntToStr(StrToInt(Edit_Core.Text) div StrToInt(SystemWorkground.ErrorGTState));

                //added by linlf 解决兑换比例需要重启的问题
                
                 Edit_BiLi.Text:=IntToStr( StrToInt(Edit_Core.Text) div StrToInt(SystemWorkground.ErrorGTState) * StrToInt(SystemWorkground.exchangerate)  );

                 //追加分数上限的判断
                 Edit_LastCardID.Text:=copy(tempStr, 21,1)+copy(tempStr, 12,1)+copy(tempStr, 4,1)+copy(tempStr, 16,1)+copy(tempStr, 6,1)+copy(tempStr, 19,1)+copy(tempStr, 9,1)+copy(tempStr, 15,1)+copy(tempStr, 18,1)+copy(tempStr, 10,1);
                 //Edit7.Text:=copy(tempStr, 21,1)+copy(tempStr, 12,1)+copy(tempStr, 4,1)+copy(tempStr, 16,1)+copy(tempStr, 6,1)+copy(tempStr, 19,1)+copy(tempStr, 9,1);
                 Barflow2.Text:=copy(tempStr, 21,1)+copy(tempStr, 4,1)+copy(tempStr, 19,1)+copy(tempStr, 16,1)+copy(tempStr, 9,1)+copy(tempStr, 12,1)+copy(tempStr, 6,1);

                 //追加在数据库中检索是否有此币ID的记录  ，前提先转换为16进制
                 
                 //2016年01月08日修正
                 //BAR2_CARDNO:=copy(tempStr,2,1)+copy(tempStr,13,1)+copy(tempStr,8,1);
                 if (length(tempStr)=23) then
                    begin
                      BAR2_CARDNO:=copy(tempStr,22,1)+copy(tempStr,2,1)+copy(tempStr,13,1)+copy(tempStr,8,1);
                      Edit_CARDID.Text := BAR2_CARDNO;
                    end
                 else if (length(tempStr)=22) then
                    begin
                      BAR2_CARDNO:=copy(tempStr,2,1)+copy(tempStr,13,1)+copy(tempStr,8,1);
                      Edit_CARDID.Text := BAR2_CARDNO;
                    end
                 //追加与 BAR1_CARDNO 比较
                 //BarCodeValue_OnlyCheck:=BarCodeValue_OnlyCheck+1;//唯一校验OK
             end;
         end

         //查询退币记录条码-流水机台条码，5-C
        else if (firstbit='C') and (length(tempStr)=21) then
         begin
             begin
                 BAR_Type1:='C';
                 Edit_BarScan.Text:='';
                 Edit_BarScan.Text :=tempStr;
                 BarCodeValue_FLOW :=tempStr;
                 BarCodeValue:='';

                 Edit_DateTime.Text:= copy(tempStr, 15,1)+copy(tempStr, 12,1)+'-'+copy(tempStr, 4,1)+copy(tempStr, 7,1)+'   '+copy(tempStr, 2,1)+copy(tempStr, 18,1)+':'+copy(tempStr, 10,1)+copy(tempStr, 5,1);
                 //追加判断月份不能大于12，日期不能大于31、小时不能大于24，分钟不能大于59
                // Edit_CARDID.Text :=copy(tempStr, 11,1)+copy(tempStr, 6,1)+copy(tempStr, 13,1);
                 //BAR1_CARDNO:=copy(tempStr, 11,1)+copy(tempStr, 6,1)+copy(tempStr, 13,1);


                  //2016年01月08日修正
                  Edit_CARDID.Text :=copy(tempStr, 21,1)+copy(tempStr, 11,1)+copy(tempStr, 6,1)+copy(tempStr, 13,1);
                  BAR1_CARDNO:=copy(tempStr, 21,1)+copy(tempStr, 11,1)+copy(tempStr, 6,1)+copy(tempStr, 13,1);

                 //追加查询数据表中是否有此卡头记录，如果无则认为是非法
                 Barflow1.Text:= copy(tempStr, 3,1)+copy(tempStr, 9,1)+copy(tempStr, 17,1)+copy(tempStr, 14,1)+copy(tempStr, 19,1)+copy(tempStr, 8,1)+copy(tempStr, 16,1);
                 //追加流水号唯一判断
                 //BarCodeValue_OnlyCheck:=BarCodeValue_OnlyCheck+1;//唯一校验OK
             end;
         end
         else if (firstbit='C')  and (length(tempStr)=23)   then     //查询退币记录条码 -积分条码
         begin
             begin
                 BAR_Type2:='C';
                 Edit_BarScan.Text:='';
                 BarCodeValue_CORE :=tempStr;
                 Edit_BarScan.Text :=copy(tempStr, 2,20);
                 BarCodeValue:='';
                 Edit_Core.Text:=IntToStr(StrToInt(copy(tempStr,3,1)+copy(tempStr,5,1)+copy(tempStr,11,1)+copy(tempStr,20,1)+copy(tempStr,17,1)+copy(tempStr,7,1)+copy(tempStr,14,1)) div 10);

                 //追加分数上限的判断
                 Edit_LastCardID.Text:=copy(tempStr, 21,1)+copy(tempStr, 12,1)+copy(tempStr, 4,1)+copy(tempStr, 16,1)+copy(tempStr, 6,1)+copy(tempStr, 19,1)+copy(tempStr, 9,1)+copy(tempStr, 15,1)+copy(tempStr, 18,1)+copy(tempStr, 10,1);
                 //追加在数据库中检索是否有此币ID的记录  ，前提先转换为16进制

                 //2016年01月08日修正
                 //BAR2_CARDNO:=copy(tempStr,2,1)+copy(tempStr,13,1)+copy(tempStr,8,1);
                 BAR2_CARDNO:=copy(tempStr,23,1)+copy(tempStr,2,1)+copy(tempStr,13,1)+copy(tempStr,8,1);
                 //追加与 BAR1_CARDNO 比较
                 //BarCodeValue_OnlyCheck:=BarCodeValue_OnlyCheck+1;//唯一校验OK
             end;
         end

         //查询投币记录条码-流水机台条码，6-D
        else if (firstbit='D') and (length(tempStr)=20) then
         begin
             begin
                 BAR_Type1:='D';
                 Edit_BarScan.Text:='';
                 Edit_BarScan.Text :=tempStr;
                 BarCodeValue_FLOW :=tempStr;
                 BarCodeValue:='';
                 //Edit_DateTime.Text:= copy(tempStr, 1,2)+'-'+copy(tempStr, 3,2)+'-'+copy(tempStr, 5,2)+':'+copy(tempStr, 7,2);

                 //Edit_CARDID.Text :=copy(tempStr, 11,3);
                 //Edit_FLOW.Text:= copy(tempStr, 9,2);
                 Edit_DateTime.Text:= copy(tempStr, 15,1)+copy(tempStr, 12,1)+'-'+copy(tempStr, 4,1)+copy(tempStr, 7,1)+'   '+copy(tempStr, 2,1)+copy(tempStr, 18,1)+':'+copy(tempStr, 10,1)+copy(tempStr, 5,1);
                 //追加判断月份不能大于12，日期不能大于31、小时不能大于24，分钟不能大于59
                 Edit_CARDID.Text :=copy(tempStr, 11,1)+copy(tempStr, 6,1)+copy(tempStr, 13,1);
                 BAR1_CARDNO:=copy(tempStr, 11,1)+copy(tempStr, 6,1)+copy(tempStr, 13,1);
                 //追加查询数据表中是否有此卡头记录，如果无则认为是非法
                 Barflow1.Text:= copy(tempStr, 3,1)+copy(tempStr, 9,1)+copy(tempStr, 17,1)+copy(tempStr, 14,1)+copy(tempStr, 19,1)+copy(tempStr, 8,1)+copy(tempStr, 16,1);
                 //追加流水号唯一判断
                 //BarCodeValue_OnlyCheck:=BarCodeValue_OnlyCheck+1;//唯一校验OK
             end;
         end
         else if (firstbit='D')  and (length(tempStr)=22)   then     //查询投币记录条码 -积分条码
         begin
             begin
                 BAR_Type2:='D';
                 Edit_BarScan.Text:='';
                 BarCodeValue_CORE :=tempStr;
                 Edit_BarScan.Text :=copy(tempStr, 2,20);
                 BarCodeValue:='';
                 Edit_Core.Text:=IntToStr(StrToInt(copy(tempStr,3,1)+copy(tempStr,5,1)+copy(tempStr,11,1)+copy(tempStr,20,1)+copy(tempStr,17,1)+copy(tempStr,7,1)+copy(tempStr,14,1)) div 10);

                 //追加分数上限的判断
                 Edit_LastCardID.Text:=copy(tempStr, 21,1)+copy(tempStr, 12,1)+copy(tempStr, 4,1)+copy(tempStr, 16,1)+copy(tempStr, 6,1)+copy(tempStr, 19,1)+copy(tempStr, 9,1)+copy(tempStr, 15,1)+copy(tempStr, 18,1)+copy(tempStr, 10,1);
                 //追加在数据库中检索是否有此币ID的记录  ，前提先转换为16进制
                 BAR2_CARDNO:=copy(tempStr,2,1)+copy(tempStr,13,1)+copy(tempStr,8,1);
                 //追加与 BAR1_CARDNO 比较
                 //BarCodeValue_OnlyCheck:=BarCodeValue_OnlyCheck+1;//唯一校验OK
             end;
         end

         //查询异常发生时投币剩余数据记录条码-流水机台条码，7-E
        else if (firstbit='E') and (length(tempStr)=20) then
         begin
             begin
                 BAR_Type1:='E';
                 Edit_BarScan.Text:='';
                 Edit_BarScan.Text :=tempStr;
                 BarCodeValue_FLOW :=tempStr;
                 BarCodeValue:='';
                 //Edit_DateTime.Text:= copy(tempStr, 1,2)+'-'+copy(tempStr, 3,2)+'-'+copy(tempStr, 5,2)+':'+copy(tempStr, 7,2);

                 //Edit_CARDID.Text :=copy(tempStr, 11,3);
                 //Edit_FLOW.Text:= copy(tempStr, 9,2);
                 Edit_DateTime.Text:= copy(tempStr, 15,1)+copy(tempStr, 12,1)+'-'+copy(tempStr, 4,1)+copy(tempStr, 7,1)+'   '+copy(tempStr, 2,1)+copy(tempStr, 18,1)+':'+copy(tempStr, 10,1)+copy(tempStr, 5,1);
                 //追加判断月份不能大于12，日期不能大于31、小时不能大于24，分钟不能大于59
                 Edit_CARDID.Text :=copy(tempStr, 11,1)+copy(tempStr, 6,1)+copy(tempStr, 13,1);
                 BAR1_CARDNO:=copy(tempStr, 11,1)+copy(tempStr, 6,1)+copy(tempStr, 13,1);
                 //追加查询数据表中是否有此卡头记录，如果无则认为是非法
                 Barflow1.Text:= copy(tempStr, 3,1)+copy(tempStr, 9,1)+copy(tempStr, 17,1)+copy(tempStr, 14,1)+copy(tempStr, 19,1)+copy(tempStr, 8,1)+copy(tempStr, 16,1);
                 //追加流水号唯一判断
                 //BarCodeValue_OnlyCheck:=BarCodeValue_OnlyCheck+1;//唯一校验OK
             end;
         end
         else if (firstbit='E')  and (length(tempStr)=22)   then     //查询异常发生时投币剩余数据记录条码 -积分条码
         begin
             begin
                 BAR_Type2:='E';
                 Edit_BarScan.Text:='';
                 BarCodeValue_CORE :=tempStr;
                 Edit_BarScan.Text :=copy(tempStr, 2,20);
                 BarCodeValue:='';
                 Edit_Core.Text:=IntToStr(StrToInt(copy(tempStr,3,1)+copy(tempStr,5,1)+copy(tempStr,11,1)+copy(tempStr,20,1)+copy(tempStr,17,1)+copy(tempStr,7,1)+copy(tempStr,14,1)) div 10);

                 //追加分数上限的判断
                 Edit_LastCardID.Text:=copy(tempStr, 21,1)+copy(tempStr, 12,1)+copy(tempStr, 4,1)+copy(tempStr, 16,1)+copy(tempStr, 6,1)+copy(tempStr, 19,1)+copy(tempStr, 9,1)+copy(tempStr, 15,1)+copy(tempStr, 18,1)+copy(tempStr, 10,1);
                 //追加在数据库中检索是否有此币ID的记录  ，前提先转换为16进制
                 BAR2_CARDNO:=copy(tempStr,2,1)+copy(tempStr,13,1)+copy(tempStr,8,1);
                 //追加与 BAR1_CARDNO 比较
                 //BarCodeValue_OnlyCheck:=BarCodeValue_OnlyCheck+1;//唯一校验OK
             end;
         end ;
         //保存条码记录

 //-----------------------------------------------------------------------------
    if (Barflow2.Text<>'') and (Barflow1.Text<>'') then
      begin
          if (Barflow2.Text<>Barflow1.Text) then
           begin
            showmessage('前后扫描的流水号不一致！');

            ClearText;
            exit;
            
           end
      end;

     //唯一性判断
    if (Edit_BarScan.text<>'') and (Edit_Core.text<>'') and (Edit_CARDID.text<>'') and (Edit_DateTime.text<>'') and (Barflow1.text<>'') then
      begin
      //判断扫描的前后条码的卡头ID值是否一致
      if not (BAR1_CARDNO=BAR2_CARDNO) then
         begin
                 Panel_Infor.Caption:='前后扫描的机台识别码不一致！';

                 exit;
         end;
         
      //add by linlf 20140413解决查账条码重复入库
      if (strInvalidresult='0000')  then
        begin
                 Panel_Infor.Caption:='条码为查询获取的退币记录！';
                 //strInvalidresult :='1111';
                 exit;
        end;
      

      //条码类型判断并执行相应事件---正常上、下分条码
      if( (BAR_Type1='A') and (BAR_Type2='B') )or ( (BAR_Type1='D') and (BAR_Type2='D')) then
      //if( (BAR_Type1='A') and (BAR_Type2='B') )then
       begin
                           
            if (DataModule_3F.Querystr_Flow_Only(BarCodeValue_FLOW)<>'no_record') and
                (DataModule_3F.Querystr_Flow_Only(BarCodeValue_FLOW)<>'')then //如果有记录
              begin//查询流水号是否唯一
                 ClearText;
                 Panel_Infor.Caption:='此条码重复使用，请确认！';
                 ShowMessage('此条码重复使用，请确认！');
                 exit;
              end
            else
              begin
               //-------增加取消密码确认  开始-----------------
               if not (CheckBox_Menber.Checked) then //没有选择取消检测
               //if INit_Wright.MenberControl_short='1' then
               begin    //1考虑会员检测，检测通过后保存数据
                  if (TrimRight(Edit_UserPwd.Text)<>'')and(TrimRight(Edit_UserPwd.Text)=TrimRight(Edit_Password.Text)) then
                   begin
                      SaveData_Bar(BarCodeValue_FLOW,BarCodeValue_CORE);
                      if SaveData_OK_flag  then
                        begin
                        BarCodeValue_OnlyCheck:=0;//清除
                        InitDataBase_barflow;
                        SaveData_OK_flag:=FALSE;
                        BAR_Type1:='';
                        BAR_Type2:='';
                        Panel_Infor.Caption:='数据保存成功';
                        end;
                   end
                 else
                   begin
                        Panel_Infor.Caption:='会员密码确认错误!';
                        ShowMessage('会员密码确认错误！');
                        exit;
                   end;
              end
              else      //2不考虑会员检测，直接保存数据
              begin
                      SaveData_Bar(BarCodeValue_FLOW,BarCodeValue_CORE);
                      if SaveData_OK_flag  then
                        begin
                        BarCodeValue_OnlyCheck:=0;//清除
                        InitDataBase_barflow;
                        SaveData_OK_flag:=FALSE;
                        BAR_Type1:='';
                        BAR_Type2:='';
                        Panel_Infor.Caption:='数据保存成功';
                        end
                      else
                        begin
                        Panel_Infor.Caption:='当前条码卡头ID在系统中未注册！';
                        end;
              end;
              //-------增加取消密码确认  结束-----------------
             end;//记录唯一判断结束
        end
      //条码类型判断并执行相应事件---查询退币记录条码        
      else if ((BAR_Type1='C') and (BAR_Type2='C'))  then
        begin
                 Panel_Infor.Caption:='条码为查询获取的退币记录！';
        end
      //条码类型判断并执行相应事件---查询投币记录条码
      else if(BAR_Type1='D') and (BAR_Type2='D') then
        begin
                 Panel_Infor.Caption:='条码为查询获取的投币记录！';
        end
      //条码类型判断并执行相应事件---查询异常发生时剩余未上分的记录条码
      else if(BAR_Type1='E') and (BAR_Type2='E') then
        begin
                 Panel_Infor.Caption:='条码为投币异常时剩余的未上分记录！';
        end
      else
        begin
                 Panel_Infor.Caption:='错误条码，请确认！';
        end;

       end;//输入框不能为空判断结束
     end;
end;

procedure Tfrm_QC_AE_LineBarscan.BarCodeCOM2ReceiveData(Sender: TObject;
  Buffer: Pointer; BufferLength: Word);
var
    ii : integer;
    recStr : string;
    tmpStr : string;
    tmpStrend : string;
begin
   //接收----------------
    tmpStrend:= 'STR';
    recStr:='';
    SetLength(tmpStr, BufferLength);
    move(buffer^,pchar(tmpStr)^,BufferLength);
    for ii:=1 to BufferLength do
    begin
        recStr:=recStr+intTohex(ord(tmpStr[ii]),2); //将获得数据转换为16进制数

         if  ii=BufferLength then
        begin
           tmpStrend:= 'END';
        end;
    end;

      recData_fromICLst_Barcode.Clear;
      recData_fromICLst_Barcode.Add(recStr);

     begin
         CheckCMD_BarCodeCom2();//首先根据接收到的数据进行判断，确认此卡是否属于为正确的卡

     end;



end;

end.
