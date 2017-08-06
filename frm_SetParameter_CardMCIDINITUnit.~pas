unit frm_SetParameter_CardMCIDINITUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, IniFiles,
  Dialogs, SPComm, DB, ADODB, StdCtrls, Buttons, ExtCtrls, Grids, DBGrids;

type
  Tfrm_SetParameter_CardMC_IDINIT = class(TForm)
    Panel2: TPanel;
    comReader: TComm;
    Panel4: TPanel;
    Panel1: TPanel;
    GroupBox1: TGroupBox;
    Label4: TLabel;
    MC_ID_Set_Count: TEdit;
    Label5: TLabel;
    Panel3: TPanel;
    Label1: TLabel;
    DataSource_CardID_3FInit: TDataSource;
    ADOQuery_CardID_3FInit: TADOQuery;
    ComboBox_CardMC_ID: TComboBox;
    Label2: TLabel;
    Label3: TLabel;
    Edit_CardHead_Count: TEdit;
    Combo_MCname: TComboBox;
    BitBtn18: TBitBtn;
    GroupBox2: TGroupBox;
    DBGrid_CardID_3FInit: TDBGrid;
    BitBtn1: TBitBtn;
    BitBtn_INIT: TBitBtn;
    BitBtn2: TBitBtn;
    BitBtn3: TBitBtn;
    procedure FormShow(Sender: TObject);
    procedure BitBtn18Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Combo_MCnameClick(Sender: TObject);
    procedure ComboBox_CardMC_IDClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure comReaderReceiveData(Sender: TObject; Buffer: Pointer;
      BufferLength: Word);
    procedure BitBtn_INITClick(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure Label1Click(Sender: TObject);
    procedure MC_ID_Set_CountKeyPress(Sender: TObject; var Key: Char);
    procedure BitBtn3Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
  private
    { Private declarations }
    procedure InitCarMC_ID(Str1: string);
    procedure QueryCarMC_ID(MC_ID: string);
    procedure InitCombo_MCname; //初始化游戏名称下来框
    procedure CountCarMC_ID(str1: string);
    procedure MaxID_NO(str1: string);


    procedure CheckCMD_Right(); //系统主机权限判断，确认是否与加密狗唯一对应
    function INit_Send_CMD(StrCMD: string; StrIncValue: string): string;
    procedure INIT_Operation;
    procedure INcrevalue(S: string); //充值函数
    procedure sendData();
    function exchData(orderStr: string): string;
    function Select_CheckSum_Byte(StrCheckSum: string): string;
    function CheckSUMData(orderStr: string): string;
    function Date_Time_Modify(strinputdatetime: string): string;
    procedure Save_CardID;
    procedure Save_CardID_M(strtemp: string);
    procedure InitDataBase;
    procedure Query_CardID;
  public
    { Public declarations }
  end;

var
  frm_SetParameter_CardMC_IDINIT: Tfrm_SetParameter_CardMC_IDINIT;
  orderLst, recDataLst, recData_fromICLst: Tstrings;
  send_Data: string;
implementation

uses ICDataModule, ICCommunalVarUnit, ICFunctionUnit, ICmain, Frontoperate_EBincvalueUnit, ICEventTypeUnit;


{$R *.dfm}

procedure Tfrm_SetParameter_CardMC_IDINIT.InitDataBase;
var
  strSQL: string;
begin
  with ADOQuery_CardID_3FInit do begin
    Connection := DataModule_3F.ADOConnection_Main;
    Active := false;
    SQL.Clear;
    strSQL := 'select * from [TCardHead_Init] order by ID Desc';
    SQL.Add(strSQL);
    Active := True;
  end;
end;

procedure Tfrm_SetParameter_CardMC_IDINIT.FormShow(Sender: TObject);
begin

  InitCombo_MCname; //初始化客户名称
  recDataLst := tStringList.Create;
  recData_fromICLst := tStringList.Create;
  orderLst := TStringList.Create;
  comReader.StartComm(); //开启加密狗串口确认
  InitDataBase();
end;

procedure Tfrm_SetParameter_CardMC_IDINIT.InitCombo_MCname; //初始化游戏名称下来框
var
  ADOQTemp: TADOQuery;
  strSQL: string;
  nameStr: string;
  i: integer;
begin
  ADOQTemp := TADOQuery.Create(nil);
  strSQL := 'select distinct[Customer_Name] from [3F_Customer_Infor] ';
  with ADOQTemp do
  begin
    Connection := DataModule_3F.ADOConnection_Main;
    SQL.Clear;
    SQL.Add(strSQL);
    Active := True;
    Combo_MCname.Items.Clear;
    while not Eof do
    begin
      Combo_MCname.Items.Add(FieldByName('Customer_Name').AsString);
      Next;
    end;
  end;
  FreeAndNil(ADOQTemp);
end;

procedure Tfrm_SetParameter_CardMC_IDINIT.Combo_MCnameClick(
  Sender: TObject);
var
  ADOQTemp: TADOQuery;
  strSQL: string;
  nameStr: string;
  i: integer;
begin


  if length(Trim(Combo_MCname.Text)) = 0 then
  begin
    ShowMessage('机台游戏名称不能空');
    exit;
  end
  else
  begin
    InitCarMC_ID(Combo_MCname.text); //查询已经设置卡头ID的数量
  end;
end;

 //初始化客户编号

procedure Tfrm_SetParameter_CardMC_IDINIT.InitCarMC_ID(Str1: string);
var
  ADOQTemp: TADOQuery;
  strSQL: string;
  strSET: string;
begin
  ADOQTemp := TADOQuery.Create(nil);
  strSQL := 'select distinct [Customer_NO] from [3F_Customer_Infor] where Customer_Name=''' + Str1 + '''';
  with ADOQTemp do begin
    Connection := DataModule_3F.ADOConnection_Main;
    SQL.Clear;
    SQL.Add(strSQL);
    Active := True;
    ComboBox_CardMC_ID.Items.Clear;
    ComboBox_CardMC_ID.Text := '';
    while not Eof do begin
      ComboBox_CardMC_ID.Items.Add(FieldByName('Customer_NO').AsString);
      Next;
    end;
  end;
  FreeAndNil(ADOQTemp);

end;


//关闭退出

procedure Tfrm_SetParameter_CardMC_IDINIT.BitBtn18Click(Sender: TObject);
begin
  CLOSE;
end;

//查询当前客户的当前场地共有多少台卡头

procedure Tfrm_SetParameter_CardMC_IDINIT.CountCarMC_ID(str1: string);
var
  ADOQTemp: TADOQuery;
  strSQL: string;
  strSET: string;
begin
  ADOQTemp := TADOQuery.Create(nil);
  //strSQL := 'select Count(ID) from [TCardHead_Init] where Customer_NO=''' + str1 + '''';
  strSQL := 'select max(ID) from [TCardHead_Init]';

  with ADOQTemp do begin
    Connection := DataModule_3F.ADOConnection_Main;
    SQL.Clear;
    SQL.Add(strSQL);
    Active := True;
    while not Eof do begin
      Edit_CardHead_Count.Text := IntToStr(ADOQTemp.Fields[0].AsInteger);
      Next;
    end;
  end;
  FreeAndNil(ADOQTemp);
end;


//选择完毕客户名称，点击客户场地编号时的事件

procedure Tfrm_SetParameter_CardMC_IDINIT.ComboBox_CardMC_IDClick(
  Sender: TObject);
begin
  Query_CardID;
end;

procedure Tfrm_SetParameter_CardMC_IDINIT.Query_CardID;
begin

    //根据客户编号查询当前客户已经拥有的卡头数
  CountCarMC_ID(ComboBox_CardMC_ID.text); //ComboBox_CardMC_ID.text客户编号
  MC_ID_Set_Count.Text := inttostr(Strtoint(Edit_CardHead_Count.Text) + 2);

end;



 //查询当前客户当前场地的最大卡头ID号   这里建议使用max而不是count

procedure Tfrm_SetParameter_CardMC_IDINIT.MaxID_NO(str1: string);
var
  ADOQTemp: TADOQuery;
  strSQL: string;
  strSET: string;
begin
  ADOQTemp := TADOQuery.Create(nil);
//  strSQL := 'select Count(ID) from [TCardHead_Init] where Customer_NO=''' + str1 + '''';
  strSQL := 'select max(ID) from [TCardHead_Init] ';

  with ADOQTemp do begin
    Connection := DataModule_3F.ADOConnection_Main;
    SQL.Clear;
    SQL.Add(strSQL);
    Active := True;
    while not Eof do begin
      Edit_CardHead_Count.Text := IntToStr(ADOQTemp.Fields[0].AsInteger);
      Next;
    end;
  end;
  FreeAndNil(ADOQTemp);
end;


procedure Tfrm_SetParameter_CardMC_IDINIT.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  orderLst.Free();
  recDataLst.Free();
  recData_fromICLst.Free();
  comReader.StopComm();
//    ICFunction.ClearIDinfor;//清除从ID读取的所有信息

end;


 //查询当前机台的相关信息   这个函数没用

procedure Tfrm_SetParameter_CardMC_IDINIT.QueryCarMC_ID(MC_ID: string);
var
  ADOQTemp: TADOQuery;
  strSQL: string;

begin
  ADOQTemp := TADOQuery.Create(nil);
  strSQL := 'select [TGameSet].GameName from [TChargMacSet],[TGameSet] where ([TChargMacSet].MacNo=''' + MC_ID + ''' ) AND (TChargMacSet.GameNo=TGameSet.GameNo) And (TChargMacSet.GameNo NOT IN(001,002,003,004,005,006,007,008,009))';
  BitBtn_INIT.Enabled := FALSE;
  with ADOQTemp do begin
    Connection := DataModule_3F.ADOConnection_Main;
    SQL.Clear;
    SQL.Add(strSQL);
    Active := True;
    Combo_MCname.Text := '';
    while not Eof do begin
      Combo_MCname.Text := ADOQTemp.Fields[0].AsString;
      BitBtn_INIT.Enabled := True;
      Next;
    end;
  end;
  FreeAndNil(ADOQTemp);
end;


procedure Tfrm_SetParameter_CardMC_IDINIT.FormCreate(Sender: TObject);
begin
//  EventObj:=EventUnitObj.Create;
//  EventObj.LoadEventIni;

end;


//串口相应事件

procedure Tfrm_SetParameter_CardMC_IDINIT.comReaderReceiveData(
  Sender: TObject; Buffer: Pointer; BufferLength: Word);
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
  recData_fromICLst.Clear;
  recData_fromICLst.Add(recStr);
    //接收---------------
  begin
    CheckCMD_Right(); //系统启动时判断加密狗
  end;

end;


//根据接收到的数据判断此卡是否为合法卡

procedure Tfrm_SetParameter_CardMC_IDINIT.CheckCMD_Right();
var
  i: integer;
  tmpStr: string;
  stationNoStr: string;
  stationNo_ValueStr: string;
  tmpStr_Hex: string;
  tmpStr_Hex_length: string;
  Send_value: string;
  RevComd: integer;
  CMD1, CMD2, CMD3: string; //录入时间，读取系统时间
  ID_No: string;
  length_Data: integer;
  content1, strtemp01, strtemp02, strtemp03, content2, content3, content4, content5, content6, content7, content8, content9, content10: string;
begin
  RevComd := 0;
  CMD1 := '83';
   //首先截取接收的信息
  tmpStr := recData_fromICLst.Strings[0];
  LOAD_USER.ID_CheckNum := copy(tmpStr, 39, 4); //校验和
      // if(frm_Frontoperate_EBincvalue.CheckSUMData(copy(tmpStr, 1, 38))=copy(tmpStr, 41, 2)+copy(tmpStr, 39, 2)) then//校验和
  begin
    content1 := copy(recData_fromICLst.Strings[0], 1, 2); //帧头AA
    content2 := copy(recData_fromICLst.Strings[0], 3, 4); //不包含校验和
    strtemp01 := '0100';
    strtemp02 := '0000';
    strtemp03 := '0001';
          //1、首先判断接收的指令是否符合规定
    if (content1 = CMD1) then //握手83
    begin
     //判断接收的数据在数据表中是否已经存在，如果是则弹出提示框
      if (content2 = strtemp03) or (content2 = strtemp02) or (content2 = strtemp01) then
      begin
        if content2 = send_Data then
        begin

          Save_CardID;

          send_Data := '';
          Panel3.Caption := '写入成功，数据已经保存！';
        end
        else
        begin
          Panel3.Caption := '当前卡头ID未初始化，允许写入！';
          BitBtn_INIT.Enabled := true;
        end;
      end
      else if (content2 = DataModule_3F.Query3F_CardHeadID_Only(content2)) then
      begin

        Panel3.Caption := content2 + '当前卡头ID被' + DataModule_3F.Query3F_CardHeadID_Customer_Name(content2) + '占用，为保证唯一性，禁止重写！';
        BitBtn_INIT.Enabled := false;
        exit;
      end
      else
      begin
        if content2 = send_Data then
        begin

          Save_CardID;
           //linlf@20160702自增
         // MC_ID_Set_Count.Text :=  inttostr(Strtoint(MC_ID_Set_Count.Text) + 1);
          ICFunction.loginfo('send_Data:  ' + send_Data);
          send_Data := '';
          Panel3.Caption := '写入成功，数据已经保存！';
        end
        else
        begin
          Panel3.Caption := '当前卡头ID未初始化，允许写入！';
          BitBtn_INIT.Enabled := true;
        end;
      end;
    end
    else //指令头不是83
    begin
      Panel3.Caption := '当前卡头不是3F出品，请确认！';
    end;
  end;


end;

 //保存并写入卡头ID

procedure Tfrm_SetParameter_CardMC_IDINIT.BitBtn_INITClick(
  Sender: TObject);
begin
  INIT_Operation; //握手成功，可以向加密狗发送更新指令
end;


//初始化操作

procedure Tfrm_SetParameter_CardMC_IDINIT.INIT_Operation;
var
  INC_value: string;
  strValue: string;
begin
  begin
    INC_value := '0'; //充值数值
    strValue := INit_Send_CMD('73', INC_value); //计算充值指令
         //Edit1.Text:= strValue;//7302007500

    INcrevalue(strValue); //写入ID卡
  end;
end;


//初始化卡计算指令

function Tfrm_SetParameter_CardMC_IDINIT.INit_Send_CMD(StrCMD: string; StrIncValue: string): string;
var
  TmpStr: string; //规范后的日期和时间
  TmpStr_CheckSum: string; //校验和
  TmpStr_SendCMD: string; //指令内容
  TmpStr_Password_User: string; //指令内容
  reTmpStr: string;
  myIni: TiniFile;
  strinputdatetime: string;

  i: integer;
  Strsent: array[0..21] of string; //机型分组对应变量
begin
  strinputdatetime := DateTimetostr((now()));
    //TmpStr:=Date_Time_Modify(strinputdatetime);//规范日期和时间格式
  Strsent[0] := StrCMD; //帧命令
  Strsent[2] := IntToHex((Strtoint(MC_ID_Set_Count.Text) div 256), 2);
  Strsent[1] := IntToHex((Strtoint(MC_ID_Set_Count.Text) mod 256), 2);

    //将发送内容进行校核计算

  TmpStr_SendCMD := Strsent[0] + Strsent[1] + Strsent[2]; //求和
  TmpStr_CheckSum := CheckSUMData(TmpStr_SendCMD); //求得校验和

    //TmpStr_CheckSum字节需要重新排布 ，低字节在前，高字节在后
  reTmpStr := TmpStr_SendCMD + Select_CheckSum_Byte(TmpStr_CheckSum); //获取所有发送给IC的数据

  result := reTmpStr;
end;
//校验和，确认是否正确

function Tfrm_SetParameter_CardMC_IDINIT.CheckSUMData(orderStr: string): string;
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
    KK := KK + jj;

  end;
  reTmpStr := IntToHex(KK, 2);
  result := reTmpStr;
end;
//校验和转换成16进制并排序 字节LL、字节LH

function Tfrm_SetParameter_CardMC_IDINIT.Select_CheckSum_Byte(StrCheckSum: string): string;
var
  jj: integer;
  tempLH, tempLL: integer; //2147483648 最大范围

begin
  jj := strToint('$' + StrCheckSum); //将字符转转换为16进制数，然后转换位10进制
  tempLH := (jj mod 65536) div 256; //字节LH
  tempLL := jj mod 256; //字节LL
  result := IntToHex(tempLL, 2) + IntToHex(tempLH, 2);
end;

//写入---------------------------------------

procedure Tfrm_SetParameter_CardMC_IDINIT.INcrevalue(S: string);
begin
  orderLst.Clear();
  recDataLst.Clear();
  curOrderNo := 0;
  curOperNo := 2;
    //Edit1.Text:=s;
  send_Data := Copy(s, 3, 4);
  orderLst.Add(S); //将币值写入币种
  sendData();
end;
//发送数据过程

procedure Tfrm_SetParameter_CardMC_IDINIT.sendData();
var
  orderStr: string;
begin
  if orderLst.Count > curOrderNo then
  begin
    orderStr := orderLst.Strings[curOrderNo];
    orderStr := exchData(orderStr);
    comReader.WriteCommData(pchar(orderStr), length(orderStr));
    inc(curOrderNo);
  end;
end;

//转找发送数据格式 ，将字符转换为16进制

function Tfrm_SetParameter_CardMC_IDINIT.exchData(orderStr: string): string;
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

function Tfrm_SetParameter_CardMC_IDINIT.Date_Time_Modify(strinputdatetime: string): string;
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

procedure Tfrm_SetParameter_CardMC_IDINIT.Save_CardID;
var
  ADOQ: TADOQuery;
  strSQL: string;
begin
  strSQL := 'select * from TCardHead_Init';
  ADOQ := TADOQuery.Create(nil);
  with ADOQ do begin
    Connection := DataModule_3F.ADOConnection_Main;
    Active := false;
    SQL.Clear;
    SQL.Add(strSQL);
    Active := true;
    Append;
    FieldByName('Customer_Name').AsString := Combo_MCname.text;
    FieldByName('Customer_NO').AsString := ComboBox_CardMC_ID.text;
    FieldByName('CardHead_ID').AsString := MC_ID_Set_Count.text;
    FieldByName('Customer_Time').AsString := FormatDateTime('yyyy-MM-dd HH:mm:ss', now);
    FieldByName('CardHead_ID_IC').AsString := send_Data;

    Post;
    Active := False;
  end;
  FreeAndNil(ADOQ);
  InitDataBase; //刷新列表
  Query_CardID; //重新查询相关信息

end;

procedure Tfrm_SetParameter_CardMC_IDINIT.Save_CardID_M(strtemp: string);
var
  ADOQ: TADOQuery;
  strSQL: string;
  i, imax: integer;
  strMCname, strCardMC_ID, strStartID: string;
begin
  strMCname := '请点击选择';
  strCardMC_ID := '请点击选择';
  strStartID := '0';
  if (Combo_MCname.Text = strMCname) or (ComboBox_CardMC_ID.Text = strCardMC_ID) then
  begin
    showmessage('请选择客户名称和编号');
    exit;
  end
  else if strtemp = strStartID then
  begin
    showmessage('将要设置的卡头ID号不能为0,必须>0');
    exit;
  end
  else
  begin

    imax := strtoint(trim(strtemp)) - 1;
    for i := 1 to imax do
    begin
      if i < 10 then
      begin
        send_Data := '000' + inttostr(i);
      end
      else if (i < 100) and (i > 9) then
      begin
        send_Data := '00' + inttostr(i);
      end
      else if (i < 1000) and (i > 99) then
      begin
        send_Data := '0' + inttostr(i);
      end
      else
      begin
        send_Data := inttostr(i);
      end;

      strSQL := 'select * from TCardHead_Init';
      ADOQ := TADOQuery.Create(nil);
      with ADOQ do begin
        Connection := DataModule_3F.ADOConnection_Main;
        Active := false;
        SQL.Clear;
        SQL.Add(strSQL);
        Active := true;
        Append;
        FieldByName('Customer_Name').AsString := Combo_MCname.text;
        FieldByName('Customer_NO').AsString := ComboBox_CardMC_ID.text;
        FieldByName('CardHead_ID').AsString := MC_ID_Set_Count.text;
        FieldByName('Customer_Time').AsString := FormatDateTime('yyyy-MM-dd HH:mm:ss', now);
        FieldByName('CardHead_ID_IC').AsString := send_Data;
        Post;
        Active := False;
      end;
      FreeAndNil(ADOQ);
    end; //for cycle end
  end;
  InitDataBase; //刷新列表
  Query_CardID; //重新查询相关信息

end;

procedure Tfrm_SetParameter_CardMC_IDINIT.BitBtn1Click(Sender: TObject);
begin
  INIT_Operation; //握手成功，可以向加密狗发送更新指令
end;

procedure Tfrm_SetParameter_CardMC_IDINIT.Label1Click(Sender: TObject);
begin
  MC_ID_Set_Count.Enabled := true;
end;

procedure Tfrm_SetParameter_CardMC_IDINIT.MC_ID_Set_CountKeyPress(
  Sender: TObject; var Key: Char);
begin
  if not (key in ['0'..'9', #8, #13]) then
  begin
    key := #0;
    ShowMessage('输入错误，只能输入数字！');
  end;
end;

procedure Tfrm_SetParameter_CardMC_IDINIT.BitBtn3Click(Sender: TObject);
begin
  if (MessageDlg('确认需要填充？', mtInformation, [mbYes, mbNo], 0) = mrYes) then
  begin
    if (MessageDlg('再次确认需要操作？', mtInformation, [mbYes, mbNo], 0) = mrYes) then
    begin
      Save_CardID_M(MC_ID_Set_Count.Text);
    end;
  end;
end;

procedure Tfrm_SetParameter_CardMC_IDINIT.BitBtn2Click(Sender: TObject);
var
  ADOQ: TADOQuery;
  strSQL: string;
begin

  if (MessageDlg('确认需要删除过往记录吗？', mtInformation, [mbYes, mbNo], 0) = mrYes) then
  begin
    if (MessageDlg('再次确认需要删除？', mtInformation, [mbYes, mbNo], 0) = mrYes) then
    begin


      strSQL := 'delete  from '
        + ' [TCardHead_Init] ';

      ADOQ := TADOQuery.Create(nil);
      with ADOQ do begin
        Connection := DataModule_3F.ADOConnection_Main;
        ADOQ.Active := false;
        SQL.Clear;
        SQL.Add(strSQL);
        ADOQ.ExecSQL;
      end;
      FreeAndNil(ADOQ);

      InitDataBase; //刷新列表
      Query_CardID; //重新查询相关信息
    end;
  end;

end;

end.
