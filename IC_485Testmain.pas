unit IC_485Testmain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DB, ADODB, ExtCtrls, StdCtrls, OleCtrls, MSCommLib_TLB,
  Buttons, ComCtrls, SPComm;
type
  Tfrm_IC_485Testmain = class(TForm)
    comReader: TComm;
    DataSource_Newmenber: TDataSource;
    ADOQuery_newmenber: TADOQuery;
    pgcReader: TPageControl;
    tbsConfig: TTabSheet;
    TabSheet1: TTabSheet;
    GroupBox1: TGroupBox;
    Memo_485: TMemo;
    GroupBox2: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Bit_Uptest: TBitBtn;
    Bit_SSRtest: TBitBtn;
    Bit_Downtest: TBitBtn;
    Bit_NetNotest: TBitBtn;
    ComboBox_NetNotest: TComboBox;
    ComboBox_Uptest: TComboBox;
    ComboBox_SSRtest: TComboBox;
    ComboBox_Downtest: TComboBox;
    ComboBox_StationNo: TComboBox;
    Bit_StationNoset: TBitBtn;
    MSComm1: TMSComm;
    tbsSeRe: TTabSheet;
    gbComSendRec: TGroupBox;
    lblExplain: TLabel;
    memComSeRe: TMemo;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    GroupBox3: TGroupBox;
    Label7: TLabel;
    BitBtn1: TBitBtn;
    Edit_Pwd: TEdit;
    ComboBox_ComNo: TComboBox;
    Label6: TLabel;
    BitBtn2: TBitBtn;
    Edit5: TEdit;
    ADOQuery_MacUpdown: TADOQuery;
    Label8: TLabel;
    Label9: TLabel;
    Edit6: TEdit;
    BitBtn3: TBitBtn;
    Edit7: TEdit;
    Edit8: TEdit;
    Edit9: TEdit;
    Edit10: TEdit;
    BitBtn4: TBitBtn;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure comReaderReceiveData(Sender: TObject; Buffer: Pointer;
      BufferLength: Word);
    procedure BitBtn1Click(Sender: TObject);
    procedure Bit_StationNosetClick(Sender: TObject);
    procedure ComboBox_ComNoChange(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure BitBtn4Click(Sender: TObject);
  private
    { Private declarations }
    function exchData(orderStr: string): string;
    procedure sendData();
    procedure checkOper();
    procedure AnswerOper(); //响应接收上分、下分操作的事件
    procedure InitDataBase;
    function Query_TMemberInfo_CardAmount(S1: string): string;
    procedure SendCardAmount(S1: string); //发送余额值
    function tranfertoHex(S1: string): string; // 将逐个字符之间转为16进制的字符
    procedure Send_StationNo(S1: string); //发送站号
    procedure Send_Pwd(S1: string); //发送卡确认密码
    procedure InitStationNo;
    procedure QueryStationNo(ComNumStr: string);
    procedure UpdateMacStatic_up(S1: string; S2: string); //更新记录
    procedure UpdateMacStatic_down(S1: string; S2: string);
    function Query_MacStatic_init_downvalue(S1: string): string;
    function Query_MacStatic_init_upvalue(S1: string): string;

  //  procedure  AddTOMacStatic_up(S1:String;S2:String;S3:String);//写入上分记录到数据表MacStatic
    procedure AddTOTMembeDetail_up(S1: string; S2: string; S3: string); //写入上分记录到数据表TMembeDetail
  //  procedure  AddTOMacStatic_down(S1:String;S2:String;S3:String);//写入下分记录到数据表MacStatic
    procedure AddTOTMembeDetail_down(S1: string; S2: string; S3: string); //写入下分记录到数据表TMembeDetail

    function Query_MacStatic_init_updownvalue(S1: string): string; //查询该机台对应是上分、下分单值;
    function QueryUserNo(S: string): string; //根据卡ID号查询此卡当前持有者的相关信息
    procedure Update_LastRecord(S: string); //更新充值、上分、下分的最新记录标识字段 LastRecord
    function Query_TotalMoneyLastrecord(S: string): string;
  public
    { Public declarations }
  end;

var
  frm_IC_485Testmain: Tfrm_IC_485Testmain;
  curOrderNo: integer = 0;
  curOperNo: integer = 0;
  curScanNo: integer = 0;
  orderLst, recDataLst, recData_fromICLst: Tstrings;
  buffer: array[0..2048] of byte;
implementation
uses SetParameterUnit, ICDataModule, ICCommunalVarUnit, ICEventTypeUnit, ICFunctionUnit;
{$R *.dfm}

//初始化数据表

procedure Tfrm_IC_485Testmain.InitDataBase;
var
  strSQL: string;
begin
  with ADOQuery_newmenber do begin
    Connection := DataModule_3F.ADOConnection_Main;
    Active := false;
    SQL.Clear;
    strSQL := 'select * from [TMemberInfo]';
    SQL.Add(strSQL);
    Active := True;
  end;

  with ADOQuery_MacUpdown do begin
    Connection := DataModule_3F.ADOConnection_Main;
    Active := false;
    SQL.Clear;
    strSQL := 'select * from [TMembeDetail]';
    SQL.Add(strSQL);
    Active := True;
  end;
end;

 //初始化型号站号地址

procedure Tfrm_IC_485Testmain.InitStationNo;
var
  ADOQTemp: TADOQuery;
  strSQL: string;
  nameStr: string;
  i: integer;
begin

  ADOQTemp := TADOQuery.Create(nil);
  strSQL := 'select distinct [ComNum] from [TChargMacSet]';
  with ADOQTemp do
  begin
    Connection := DataModule_3F.ADOConnection_Main;
    SQL.Clear;
    SQL.Add(strSQL);
    Active := True;
    ComboBox_ComNo.Items.Clear;
    while not Eof do
    begin
      ComboBox_ComNo.Items.Add(FieldByName('ComNum').AsString);
      Next;
    end;
  end;
  FreeAndNil(ADOQTemp);

end;
//查询该网络的站号地址响应动作

procedure Tfrm_IC_485Testmain.QueryStationNo(ComNumStr: string); //查询该网络的站号地址
var
  ADOQTemp: TADOQuery;
  strSQL: string;
  nameStr: string;
  valueStr: string;
  i: integer;
begin

  ADOQTemp := TADOQuery.Create(nil);
  strSQL := 'select distinct [MacID] from [TChargMacSet] where [State]=0 and ComNum=''' + ComNumStr + ''' ';
  with ADOQTemp do
  begin
    Connection := DataModule_3F.ADOConnection_Main;
    SQL.Clear;
    SQL.Add(strSQL);
    Active := True;
    ComboBox_StationNo.Items.Clear;
    while not Eof do
    begin
      ComboBox_StationNo.Items.Add(TrimRight(FieldByName('MacID').AsString));
      Next;
    end;
  end;
  FreeAndNil(ADOQTemp);
end;

//查询该网络的站号地址

procedure Tfrm_IC_485Testmain.ComboBox_ComNoChange(Sender: TObject);
begin
  ComboBox_StationNo.Items.Clear;
  QueryStationNo(ComboBox_ComNo.Text);
end;


procedure Tfrm_IC_485Testmain.FormCreate(Sender: TObject);
begin
  EventObj := EventUnitObj.Create;
  EventObj.LoadEventIni;
  InitDataBase; //数据库操作

end;



//转找发送数据格式

function Tfrm_IC_485Testmain.exchData(orderStr: string): string;
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

procedure Tfrm_IC_485Testmain.sendData();
var
  orderStr: string;
begin
  if orderLst.Count > curOrderNo then
  begin
    orderStr := orderLst.Strings[curOrderNo];
    memComSeRe.Lines.Add('==>> ' + orderStr);
    orderStr := exchData(orderStr); //将字符转换为下位机能够识别的16进制数值
    comReader.WriteCommData(pchar(orderStr), length(orderStr));
    inc(curOrderNo); //根据指令总数，每发一条指令就自动加一，直到与指令总数相同
  end;
end;

//检查返回的数据，执行相应的事件，这些数据都来自485网络的IC卡站

procedure Tfrm_IC_485Testmain.checkOper();
var
  i: integer;
  tmpStr: string;
begin
  case curOperNo of
    20: begin //反馈卡余额总值操作
        for i := 0 to recData_fromICLst.Count - 1 do
          if copy(recData_fromICLst.Strings[i], 9, 2) <> '01' then // 写操作成功返回命令
          begin
            memComSeRe.Lines.Add('机台''' + copy(recData_fromICLst.Strings[0], 5, 4) + '''已经接收到PC反馈数据');
            memComSeRe.Lines.Add('');
            recData_fromICLst.Clear;
            exit;
          end;
      end;
    21: begin //反馈站号设定操作
        for i := 0 to recData_fromICLst.Count - 1 do
          if copy(recData_fromICLst.Strings[i], 9, 2) <> 'A2' then // 写操作成功返回命令
          begin
            memComSeRe.Lines.Add('机台''' + copy(recData_fromICLst.Strings[0], 5, 4) + '''已经接收到PC反馈数据');
            memComSeRe.Lines.Add('');
            recData_fromICLst.Clear;
            exit;
          end;
      end;
    22: begin //反馈密码确认设定操作
        for i := 0 to recDataLst.Count - 1 do
          if copy(recDataLst.Strings[i], 9, 2) <> 'A4' then // 写操作成功返回命令
          begin
            memComSeRe.Lines.Add('机台''' + copy(recData_fromICLst.Strings[0], 5, 4) + '''已经接收到PC反馈数据');
            memComSeRe.Lines.Add('');
            recData_fromICLst.Clear;
            exit;
          end;
      end;



  end;
end;


//检查返回的数据

procedure Tfrm_IC_485Testmain.AnswerOper();
var
  i: integer;
  tmpStr: string;
  stationNoStr: string;
  stationNo_ValueStr: string;
  tmpStr_Hex: string;
  tmpStr_Hex_length: string;
  Send_value: string;
  RevComd: integer;
  ID_No: string;
  length_Data: integer;
  Dingwei: array[0..8] of string; //用于转存截取的帧信息
begin
  RevComd := 0;
   //首先截取接收的信息

  Dingwei[1] := copy(recData_fromICLst.Strings[0], 1, 4); //帧头AA8A
  Dingwei[2] := copy(recData_fromICLst.Strings[0], 5, 4); //站号地址
  Dingwei[3] := copy(recData_fromICLst.Strings[0], 9, 2); //命令地址
  Dingwei[4] := copy(recData_fromICLst.Strings[0], 11, 2); //数据长度地址
       //根据数据长度Dingwei[4]截取数据 Dingwei[5]
  length_Data := 2 * ICFunction.Str_HexToInt(Dingwei[4]);
  Dingwei[5] := copy(recData_fromICLst.Strings[0], 13, length_Data); //数据-ID卡号

  Dingwei[6] := copy(recData_fromICLst.Strings[0], 13 + length_Data, 2); //结束符1
  Dingwei[7] := copy(recData_fromICLst.Strings[0], 13 + length_Data + 2, 2); //结束符2

  if Dingwei[3] = 'A1' then //A1表示IC取得了卡ID,或PC要读取IC的卡ID
  begin
    RevComd := 1;
  end;
  if Dingwei[3] = 'A2' then // 站号设定操作
  begin
    RevComd := 2;
  end;
  if Dingwei[3] = 'A4' then // 确认密码设定操作
  begin
    RevComd := 4;
  end;
  if Dingwei[3] = 'A5' then //上分操作
  begin
    RevComd := 5;
  end;
  if Dingwei[3] = 'A6' then //下分操作
  begin
    RevComd := 6;
  end;
  if Dingwei[3] = 'A7' then //退币信号
  begin
    RevComd := 7;
  end;
   //判断相关指令后进行对应操作
  case RevComd of
    1: begin //请求反馈该卡余额
                //根据取得卡ID查询对应卡的积分余额 ,并且反馈给IC，根据Dingwei[4]

        Edit2.Text := Dingwei[5];
                //查询得到的余额值
              //  tmpStr:=Query_TMemberInfo_CardAmount(Dingwei[5]);//查询得到的余额值
                 //将查询得到的余额值 逐个字符转换为16进制字符
        tmpStr := '500';
               // tmpStr_Hex_length:='0'+IntToStr(length(tmpStr));//数据长度
        tmpStr_Hex_length := '06'; //数据长度
        Edit3.Text := tmpStr_Hex_length;

        tmpStr_Hex := tranfertoHex(tmpStr); //数据
        Edit1.Text := tmpStr_Hex;

        Send_value := 'AA8A' + Dingwei[2] + 'A1' + tmpStr_Hex_length + tmpStr_Hex + '4A';

        Edit4.Text := Send_value;
        SendCardAmount(Send_value); //发送A1指令
        recData_fromICLst.Clear;
        RevComd := 0;
                //系统软件记录对应机台操作日志  根据Dingwei[2]
                //Record_MC_Operate
      end;
    2: begin //站号设定操作

        ; //更新数据表TChargMacSet
        recData_fromICLst.Clear;
        RevComd := 0;
      end;

    4: begin //确认密码设定操作
        ;
        recData_fromICLst.Clear;
        RevComd := 0;
      end;

    5: begin //上分操作
              // ;  //保存上分记录
        stationNoStr := '';
        stationNoStr := '00' + Dingwei[2]; //机台站号
        ID_No := Dingwei[5]; //ID卡号
            //查询表MacStatic中值
            //stationNo_ValueStr:=Query_MacStatic_init_upvalue(stationNoStr);//查询得到的余额值;
            //stationNo_ValueStr:=IntToStr(StrToInt(stationNo_ValueStr)+10);  //注意是否需要转换为浮点，同时10应该考虑用变量
            //UpdateMacStatic_up(stationNoStr,stationNo_ValueStr);

        stationNo_ValueStr := Query_MacStatic_init_updownvalue(stationNoStr); //查询该机台对应是上分、下分单值;
           // AddTOMacStatic_up(ID_No,stationNo_Value,StrstationNoStr);//写入上分记录到数据表MacStatic
        AddTOTMembeDetail_up(ID_No, stationNo_ValueStr, stationNoStr); //写入上分记录到数据表TMembeDetail

        recData_fromICLst.Clear;
        RevComd := 0;
      end;

    6: begin //下分操作(使用退币光眼信号)
             //  ;   //保存下分记录
        stationNoStr := '';
        stationNoStr := '00' + Dingwei[2]; //IC卡站号，也是机台编号
        ID_No := Dingwei[5]; //ID卡号

            //查询表MacStatic中值
            //stationNo_ValueStr:=Query_MacStatic_init_downvalue(stationNoStr);//查询得到的余额值;
            //stationNo_ValueStr:=IntToStr(StrToInt(stationNo_ValueStr)+10);  //注意是否需要转换为浮点，同时10应该考虑用变量
            //UpdateMacStatic_down(stationNoStr,stationNo_ValueStr);

        stationNo_ValueStr := Query_MacStatic_init_updownvalue(stationNoStr); //查询该机台对应是上分、下分单值;
            //AddTOMacStatic_down(ID_No,stationNo_Value,StrstationNoStr);//写入上分记录到数据表MacStatic
        AddTOTMembeDetail_down(ID_No, stationNo_ValueStr, stationNoStr); //写入上分记录到数据表TMembeDetail

        recData_fromICLst.Clear;
        RevComd := 0;
      end;
    7: begin //退币信号
        ; //保存退币信号记录
      end;

  end;
end;
//上分测试

procedure Tfrm_IC_485Testmain.BitBtn2Click(Sender: TObject);
var
  stationNoStr: string;
  stationNoStr1: string;
  ID_NO: string;
begin
  stationNoStr := '000301'; //机台编号
  ID_NO := 'F9923A3C'; //卡ID号
  stationNoStr1 := Query_MacStatic_init_updownvalue(stationNoStr); //机台对应的倍率值

     //Update_LastRecord(stationNoStr);//更新最新记录标识字段
  AddTOTMembeDetail_up(ID_NO, stationNoStr1, stationNoStr); //上分测试 ，从PC取走分数

    // Edit5.Text:=QueryUserNo(stationNoStr);
end;
//下分测试

procedure Tfrm_IC_485Testmain.BitBtn3Click(Sender: TObject);
var
  stationNoStr: string;
  stationNoStr1: string;
  ID_NO: string;
begin
  stationNoStr := '000301'; //机台编号
  ID_NO := 'F9923A3C'; //卡ID号
  stationNoStr1 := Query_MacStatic_init_updownvalue(stationNoStr); //机台对应的倍率值

     //Update_LastRecord(stationNoStr);//更新最新记录标识字段
  AddTOTMembeDetail_down(ID_NO, stationNoStr1, stationNoStr); //下分测试,从IC赢取分数
    // Edit5.Text:=QueryUserNo(stationNoStr);
end;

 //查询对应站号设定的上分、下分倍率值 Edt1

function Tfrm_IC_485Testmain.Query_MacStatic_init_updownvalue(S1: string): string;
var
  ADOQTemp: TADOQuery;
  strSQL: string;
  reTmpStr: string;
  strIsable: string;
  i: integer;
begin

  ADOQTemp := TADOQuery.Create(nil);
  strSQL := 'select distinct [Edt1] from [TChargMacSet],[TGameSet] where (TChargMacSet.GameNo=TGameSet.GameNo) and (TChargMacSet.MacID=''' + S1 + ''')';
  with ADOQTemp do
  begin
    Connection := DataModule_3F.ADOConnection_Main;
    SQL.Clear;
    SQL.Add(strSQL);
    Active := True;
    if (RecordCount > 0) then
    begin
                         //将查询得到的值发送给IC
      reTmpStr := TrimRight(ADOQTemp.Fields[0].AsString);
    end
    else
      close;
  end;
  FreeAndNil(ADOQTemp);
  result := reTmpStr;
end;

//根据当前机台上传的卡ID号检索此卡持有者的相关信息 S1为ID卡号ID_No，S2为上分、下分倍率值stationNo_ValueStr

procedure Tfrm_IC_485Testmain.AddTOTMembeDetail_up(S1: string; S2: string; S3: string);
var
  strIDNo, strName, strUserNo, strIncvalue, strGivecore, strOperator, strhavemoney, strinputdatetime: string;

begin
  strUserNo := QueryUserNo(S1); //根据ID_No查询此卡的当前用户编号,用于填充相关字段
  Update_LastRecord(strUserNo); //更新记录，将该用户过往充值记录设定最新记录标志位设为‘0’
  strhavemoney := Query_TotalMoneyLastrecord(strUserNo); //根据查询得到卡的ID，查询此卡的当前持有者的最新充值、消分、上分、下分操作记录中的TotalMoney字段
 // if StrToInt(strhavemoney)>= StrToInt(S2) then  此判断在下位IC处理
  strhavemoney := IntToStr(StrToInt(strhavemoney) - StrToInt(S2)); //账户余额   //查询此卡持有者的最新充值、消分、上分、下分记录的TotalMoney  strIncvalue:=S2;             //上分值，从PC数据库中写给IC，押分操作
  strGivecore := '0'; //送分值
  strOperator := '000'; //操作员=机台IC卡站号值
  strinputdatetime := DateTimetostr((now())); //录入时间，读取系统时间
  with ADOQuery_MacUpdown do begin
    Append;

    FieldByName('CostMoney').AsString := S2; //充值、上分、下分
    FieldByName('TickCount').AsString := strGivecore;
    FieldByName('cUserNo').AsString := strOperator; //操作员
    FieldByName('GetTime').AsString := strinputdatetime; //交易时间
    FieldByName('TotalMoney').AsString := strhavemoney; //帐户总额

    FieldByName('IDCardNo').AsString := S1; //ID卡号
    FieldByName('MemberName').AsString := strUserNo; //用户名
    FieldByName('MemCardNo').AsString := strUserNo; //用户编号

    FieldByName('PayType').AsString := '2'; //上分操作类型（包括充值0、消分1、上分2、下分3）
    FieldByName('MacNo').AsString := 'A' + COPY(S3, 3, 4); //S2机台编号 也就是机台IC卡的站号
    FieldByName('ExitCoin').AsInteger := 0;
    FieldByName('Compter').AsString := '1';
    FieldByName('LastRecord').AsString := '1';
    try
      Post;
    except
      on e: Exception do ShowMessage(e.Message);
    end;
  end;
  Edit5.Text := IntToStr(StrToInt(Edit5.Text) + 1);
end;

//根据当前机台上传的卡ID号检索此卡持有者的相关信息 S1为ID卡号ID_No，S2为上分、下分倍率值stationNo_ValueStr

procedure Tfrm_IC_485Testmain.AddTOTMembeDetail_down(S1: string; S2: string; S3: string);
var
  strIDNo, strName, strUserNo, strIncvalue, strGivecore, strOperator, strhavemoney, strinputdatetime: string;

begin
  strUserNo := QueryUserNo(S1); //根据ID_No查询此卡的当前用户编号,用于填充相关字段
  Update_LastRecord(strUserNo); //更新记录，将该用户过往充值记录设定最新记录标志位设为‘0’
  strhavemoney := Query_TotalMoneyLastrecord(strUserNo); //根据查询得到卡的ID，查询此卡的当前持有者的最新充值、消分、上分、下分操作记录中的TotalMoney字段


  strhavemoney := IntToStr(StrToInt(strhavemoney) + StrToInt(S2)); //账户余额   //查询此卡持有者的最新充值、消分、上分、下分记录的TotalMoney  strIncvalue:=S2;             //上分值，从PC数据库中写给IC，押分操作

  strGivecore := '0'; //送分值
  strOperator := '000'; //操作员=机台IC卡站号值
  strinputdatetime := DateTimetostr((now())); //录入时间，读取系统时间
  with ADOQuery_MacUpdown do begin
    Append;

    FieldByName('CostMoney').AsString := S2; //充值、上分、下分
    FieldByName('TickCount').AsString := strGivecore;
    FieldByName('cUserNo').AsString := strOperator; //操作员
    FieldByName('GetTime').AsString := strinputdatetime; //交易时间
    FieldByName('TotalMoney').AsString := strhavemoney; //帐户总额

    FieldByName('IDCardNo').AsString := S1; //ID卡号
    FieldByName('MemberName').AsString := strUserNo; //用户名
    FieldByName('MemCardNo').AsString := strUserNo; //用户编号

    FieldByName('PayType').AsString := '3'; //上分操作类型（包括充值0、消分1、上分2、下分3）
    FieldByName('MacNo').AsString := 'A' + COPY(S3, 3, 4); //S2机台编号 也就是机台IC卡的站号
    FieldByName('ExitCoin').AsInteger := 0;
    FieldByName('Compter').AsString := '1';
    FieldByName('LastRecord').AsString := '1';
    try
      Post;
    except
      on e: Exception do ShowMessage(e.Message);
    end;
  end;
  Edit6.Text := IntToStr(StrToInt(Edit6.Text) + 1);
end;

 //根据查询得到卡的ID，查询此卡的当前持有者个人信息

function Tfrm_IC_485Testmain.QueryUserNo(S: string): string;
var
  ADOQ: TADOQuery;
  strSQL, strRet: string;
  strsexOrg: string;
  strCompter: string;
begin
  strCompter := '1'; //Compter='1'表示此卡的当前持有者
  ADOQ := TADOQuery.Create(nil);
  strSQL := ' select MemberName from TMemberInfo where (IDCardNo=''' + S + ''') and (Compter=''' + strCompter + ''')';
  with ADOQ do begin
    Connection := DataModule_3F.ADOConnection_Main;
    SQL.Clear;
    SQL.Add(strSQL);
    Open;
    if (RecordCount > 0) then
    begin
      strRet := ADOQ.Fields[0].AsString;
      Close;
    end
    else
    begin
      ShowMessage('系统中无此卡开户记录，请确认此人是否会员！！！');
      exit;
    end;
  end;
  FreeAndNil(ADOQ);

  Result := strRet;
end;

//更新此卡充值、上分、下分的最新记录标识字段 LastRecord

procedure Tfrm_IC_485Testmain.Update_LastRecord(S: string);
var
  ADOQ: TADOQuery;
  strSQL, strRet: string;
  MaxID: string;
  setvalue: string;
begin

//根据查询得到的记录MD_ID,更新标识字段
  // MaxID:='110';
  setvalue := '0';
  strSQL := 'Update TMembeDetail set LastRecord=''' + setvalue + ''' where MD_ID in(select max(MD_ID) from TMembeDetail where MemCardNo=''' + S + ''')';
  ADOQ := TADOQuery.Create(nil);
  with ADOQ do begin
    Connection := DataModule_3F.ADOConnection_Main;
    SQL.Clear;
    SQL.Add(strSQL);
    ADOQ.ExecSQL;
  end;
  FreeAndNil(ADOQ);

end;
 //根据查询得到卡的ID，查询此卡的当前持有者的最新充值、消分、上分、下分操作记录中的TotalMoney字段

function Tfrm_IC_485Testmain.Query_TotalMoneyLastrecord(S: string): string;
var
  ADOQ: TADOQuery;
  strSQL, strRet: string;
  strsexOrg: string;
  strCompter: string;
begin
  ADOQ := TADOQuery.Create(nil);
  strSQL := ' select TotalMoney from TMembeDetail where MD_ID in(select max(MD_ID) from TMembeDetail where MemCardNo=''' + S + ''')';
  with ADOQ do begin
    Connection := DataModule_3F.ADOConnection_Main;
    SQL.Clear;
    SQL.Add(strSQL);
    Open;
    if (RecordCount > 0) then
    begin
      strRet := ADOQ.Fields[0].AsString;
      Close;
    end
    else
    begin
      ShowMessage('系统中无此卡开户记录，请确认此人是否会员！！！');
      exit;
    end;
  end;
  FreeAndNil(ADOQ);

  Result := strRet;
end;
 //查询对应站号下分的初始值

function Tfrm_IC_485Testmain.Query_MacStatic_init_downvalue(S1: string): string;
var
  ADOQTemp: TADOQuery;
  strSQL: string;
  reTmpStr: string;
  strIsable: string;
  i: integer;
begin

  ADOQTemp := TADOQuery.Create(nil);
  strSQL := 'select distinct [DOWN] from [MacStatic] where MacID=''' + S1 + '''';
  with ADOQTemp do
  begin
    Connection := DataModule_3F.ADOConnection_Main;
    SQL.Clear;
    SQL.Add(strSQL);
    Active := True;
    if (RecordCount > 0) then
    begin
                         //将查询得到的值发送给IC
      reTmpStr := TrimRight(ADOQTemp.Fields[0].AsString);
    end
    else
      close;
  end;
  FreeAndNil(ADOQTemp);
  result := reTmpStr;
end;
 //查询对应站号下分的初始值

function Tfrm_IC_485Testmain.Query_MacStatic_init_upvalue(S1: string): string;
var
  ADOQTemp: TADOQuery;
  strSQL: string;
  reTmpStr: string;
  strIsable: string;
  i: integer;
begin

  ADOQTemp := TADOQuery.Create(nil);
  strSQL := 'select distinct [UP] from [MacStatic] where MacID=''' + S1 + '''';
  with ADOQTemp do
  begin
    Connection := DataModule_3F.ADOConnection_Main;
    SQL.Clear;
    SQL.Add(strSQL);
    Active := True;
    if (RecordCount > 0) then
    begin
                         //将查询得到的值发送给IC
      reTmpStr := TrimRight(ADOQTemp.Fields[0].AsString);
    end
    else
      close;
  end;
  FreeAndNil(ADOQTemp);
  result := reTmpStr;
end;
//更新机台上、下分记录表

procedure Tfrm_IC_485Testmain.UpdateMacStatic_up(S1: string; S2: string);
var
  ADOQ: TADOQuery;
  strSQL: string;
begin

  strSQL := 'Update MacStatic set UP=''' + S2 + ''' where MacID=''' + S1 + '''';
  ADOQ := TADOQuery.Create(nil);
  with ADOQ do begin
    Connection := DataModule_3F.ADOConnection_Main;
    SQL.Clear;
    SQL.Add(strSQL);
    ADOQ.ExecSQL;
  end;
  FreeAndNil(ADOQ);

end;
//更新机台上、下分记录表

procedure Tfrm_IC_485Testmain.UpdateMacStatic_down(S1: string; S2: string);
var
  ADOQ: TADOQuery;
  strSQL: string;
begin

  strSQL := 'Update MacStatic set DOWN=''' + S2 + ''' where MacID=''' + S1 + '''';
  ADOQ := TADOQuery.Create(nil);
  with ADOQ do begin
    Connection := DataModule_3F.ADOConnection_Main;
    SQL.Clear;
    SQL.Add(strSQL);
    ADOQ.ExecSQL;
  end;
  FreeAndNil(ADOQ);

end;
 //查询对应卡的总余额

function Tfrm_IC_485Testmain.Query_TMemberInfo_CardAmount(S1: string): string;
var
  ADOQTemp: TADOQuery;
  strSQL: string;
  reTmpStr: string;
  strIsable: string;
  i: integer;
begin
  strIsable := '1'; //卡状态为"正常"
  ADOQTemp := TADOQuery.Create(nil);
  strSQL := 'select distinct [CardAmount] from [TMemberInfo] where IDCardNo=''' + S1 + ''' and IsAble=''' + strIsable + ''''; //卡状态为“正常”，即值为1
  with ADOQTemp do
  begin
    Connection := DataModule_3F.ADOConnection_Main;
    SQL.Clear;
    SQL.Add(strSQL);
    Active := True;
    if (RecordCount > 0) then
    begin
                         //将查询得到的值发送给IC
      memComSeRe.Lines.Add(ADOQTemp.Fields[0].AsString);
      reTmpStr := TrimRight(ADOQTemp.Fields[0].AsString);
    end
    else
      close;
  end;
  FreeAndNil(ADOQTemp);
  result := reTmpStr;
end;


function Tfrm_IC_485Testmain.tranfertoHex(S1: string): string; //
var
  i: integer;
  restrtemp: string;
begin
  restrtemp := '';
  for i := 1 to length(S1) do
  begin
    restrtemp := restrtemp + '0' + copy(S1, i, 1);
  end;
  if length(S1) = 5 then
    restrtemp := '00' + restrtemp;
  if length(S1) = 4 then
    restrtemp := '00' + '00' + restrtemp;
  if length(S1) = 3 then
    restrtemp := '00' + '00' + '00' + restrtemp;
  if length(S1) = 2 then
    restrtemp := '00' + '00' + '00' + '00' + restrtemp;
  if length(S1) = 1 then
    restrtemp := '00' + '00' + '00' + '00' + '00' + restrtemp;
  result := restrtemp;
end;


procedure Tfrm_IC_485Testmain.FormShow(Sender: TObject);
begin
  comReader.StartComm();
  orderLst := TStringList.Create;
  recDataLst := tStringList.Create;
  recData_fromICLst := tStringList.Create;
  memComSeRe.Clear;
  InitStationNo;
  Edit5.Text := '0';
  Edit6.Text := '0';
end;

procedure Tfrm_IC_485Testmain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  orderLst.Free();
  recDataLst.Free();
  recData_fromICLst.Free();
  comReader.StopComm();
end;

//处理从串口接收的数据

procedure Tfrm_IC_485Testmain.comReaderReceiveData(Sender: TObject; Buffer: Pointer;
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
    if (intTohex(ord(tmpStr[ii]), 2) = '4A') then
    begin
        //    recData_fromICLst.Add(recStr);             //接收一帧的信息转存，用于判断指令类别
                //响应接收到的指令（比如上分下分操作）----------
      //   break;
      tmpStrend := 'END';
    end;

  end;
  memComSeRe.Lines.Add('<<== ' + recStr); //将接收的信息显示出来
  recData_fromICLst.Add(recStr);
     // Dingwei[6] := copy(recData_fromICLst.Strings[0], 13+length_Data, 2);

  if (tmpStrend = 'END') then
  begin
    AnswerOper();
  end;
    //  Dingwei[6] := copy(recData_fromICLst.Strings[0], 13+length_Data, 2);


    //发送---------------
  if curOrderNo < orderLst.Count then // 判断指令是否已经都发送完毕，如果指令序号小于指令总数则继续发送
    sendData()
  else begin
    checkOper();
    memComSeRe.Lines.Append('');
  end;
end;


 //发送余额值A1

procedure Tfrm_IC_485Testmain.SendCardAmount(S1: string); //发送余额值
begin
  orderLst.Clear();
  recDataLst.Clear();
  curOrderNo := 0;
  curOperNo := 20;
  memComSeRe.Lines.Add('回复金额值给IC');
  orderLst.Add(S1);
   // orderLst.Add('020B0F');
  sendData();
end;



 //设置站号 A2

procedure Tfrm_IC_485Testmain.Bit_StationNosetClick(Sender: TObject);
var
  tmpStr: string;
begin
  tmpStr := ComboBox_StationNo.Text;
  if length(tmpStr) = 6 then
  begin
    tmpStr := 'AA8A' + '3F3F' + 'A2' + '04' + copy(tmpStr, 3, 4) + '4A';
    Send_StationNo(tmpStr);
  end;
end;

procedure Tfrm_IC_485Testmain.Send_StationNo(S1: string); //发送站号
begin
  orderLst.Clear();
  recDataLst.Clear();
  curOrderNo := 0;
  curOperNo := 21;
  memComSeRe.Lines.Add('设定站号');
  orderLst.Add(S1);
  sendData();
end;

 //设置确认密码 A4

procedure Tfrm_IC_485Testmain.BitBtn1Click(Sender: TObject);
var
  tmpStr: string;
begin
  tmpStr := Edit_Pwd.Text;
  if length(tmpStr) = 6 then
  begin
    tmpStr := 'AA8A' + '3F3F' + 'A4' + '06' + TrimRight(tmpStr) + '4A';
    Send_Pwd(tmpStr);
  end;
end;

procedure Tfrm_IC_485Testmain.Send_Pwd(S1: string); //发送卡确认密码
begin
  orderLst.Clear();
  recDataLst.Clear();
  curOrderNo := 0;
  curOperNo := 22;
  memComSeRe.Lines.Add('设定密码');
  orderLst.Add(S1);
  sendData();
end;




procedure Tfrm_IC_485Testmain.BitBtn4Click(Sender: TObject);
begin
  Close;
end;

end.
