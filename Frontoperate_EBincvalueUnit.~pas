//读取卡指定块值指令：AA 8A 3F 3F B1 01 YY 4A  此处YY为欲读取的块地址
//写入卡指定块值指令：
//AA 8A 3F 3F B2 0N YY XX XX XX XX XX XX XX XX XX XX XX XX XX XX XX XX 4A
// 此处0N为共有多少个字节（包括YY+XX）,YY为欲写入的块地址 XX为写入的值
unit Frontoperate_EBincvalueUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, DBGrids, ExtCtrls, StdCtrls, Buttons, DB, ADODB, SPComm, Math;

type
  Tfrm_Frontoperate_EBincvalue = class(TForm)
    Panel2: TPanel;
    Panel1: TPanel;
    DBGrid2: TDBGrid;
    DataSource_Incvalue: TDataSource;
    ADOQuery_Incvalue: TADOQuery;
    DataSource_Newmenber: TDataSource;
    ADOQuery_newmenber: TADOQuery;
    comReader: TComm;
    GroupBox5: TGroupBox;
    BitBtn1: TBitBtn;
    BitBtn12: TBitBtn;
    BitBtn13: TBitBtn;
    BitBtn14: TBitBtn;
    BitBtn15: TBitBtn;
    BitBtn16: TBitBtn;
    BitBtn17: TBitBtn;
    BitBtn18: TBitBtn;
    BitBtn19: TBitBtn;
    Button1: TButton;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    Edit5: TEdit;
    Edit6: TEdit;
    Edit1: TEdit;
    GroupBox2: TGroupBox;
    Label9: TLabel;
    Label3: TLabel;
    Label2: TLabel;
    Edit_ID: TEdit;
    Edit_Old_Value: TEdit;
    Edit14: TEdit;
    GroupBox1: TGroupBox;
    Label4: TLabel;
    Label5: TLabel;
    CheckBox_Update: TCheckBox;
    Edit7: TEdit;
    BitBtn_500: TBitBtn;
    BitBtn_400: TBitBtn;
    BitBtn_300: TBitBtn;
    BitBtn_200: TBitBtn;
    BitBtn_100: TBitBtn;
    BitBtn_50: TBitBtn;
    BitBtn_40: TBitBtn;
    BitBtn_30: TBitBtn;
    BitBtn_20: TBitBtn;
    BitBtn_10: TBitBtn;
    Label1: TLabel;
    Edit_OPResult: TEdit;
    Panel_infor: TPanel;
    Edit_info: TEdit;
    Label6: TLabel;
    Label7: TLabel;
    totalvalue: TEdit;
    procedure BitBtn18Click(Sender: TObject);
    procedure comReaderReceiveData(Sender: TObject; Buffer: Pointer;
      BufferLength: Word);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BitBtn_500Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure BitBtn_400Click(Sender: TObject);
    procedure BitBtn_300Click(Sender: TObject);
    procedure BitBtn_200Click(Sender: TObject);
    procedure BitBtn_100Click(Sender: TObject);
    procedure BitBtn_50Click(Sender: TObject);
    procedure BitBtn_40Click(Sender: TObject);
    procedure BitBtn_30Click(Sender: TObject);
    procedure BitBtn_20Click(Sender: TObject);
    procedure BitBtn_10Click(Sender: TObject);
    procedure BitBtn16Click(Sender: TObject);
    procedure BitBtn15Click(Sender: TObject);
    procedure BitBtn14Click(Sender: TObject);
    procedure BitBtn13Click(Sender: TObject);
    procedure BitBtn12Click(Sender: TObject);
    procedure BitBtn17Click(Sender: TObject);
    procedure BitBtn19Click(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure Edit7KeyPress(Sender: TObject; var Key: Char);
    procedure BitBtn2Click(Sender: TObject);
    function Query_idusercard_valid(S: string): boolean;
    Function Query_totalvalue() : String;
  private
    { Private declarations }
  
    //procedure Send_B1();
   // procedure Send_A1();
  public
    { Public declarations }
    function exchData(orderStr: string): string;

    procedure IncvalueComfir(S: string; S1: string);
    procedure sendData();
    procedure checkOper();
    procedure InitDataBase;
    procedure CheckCMD();
    procedure INcrevalue(S: string); //充值函数
    function CheckSUMData(orderStr: string): string; //校验和
    function Make_Send_CMD(StrCMD: string; StrIncValue: string): string;
    function Select_IncValue_Byte(StrIncValue: string): string;
    function Select_CheckSum_Byte(StrCheckSum: string): string;
    //保存初始化数据
    procedure Save_INCValue_Data;
    procedure Update_LastRecord_Value(S: string);
    procedure Update_LastRecord_usercard(S: string);
    function Query_LastRecord(S: string): boolean;
    procedure new_recharge_record;
    procedure cleartext;

    procedure INIT_Operation;
    procedure Init_Key_Enabled(bili: string; maxvalue: string);

    procedure GetInvalidDate;
  end;

var
  frm_Frontoperate_EBincvalue: Tfrm_Frontoperate_EBincvalue;
  curOrderNo: integer = 0;
  curOperNo: integer = 0;
  Operate_No: integer = 0;
  INC_value: string;
  orderLst, recDataLst, recData_fromICLst: Tstrings;
  strhavemoney: string;
  buffer: array[0..2048] of byte;
  ID_UserCard_Text : string;

implementation
uses ICDataModule, ICtest_Main, ICCommunalVarUnit, ICmain, ICEventTypeUnit, ICFunctionUnit,dateProcess;
{$R *.dfm}

procedure Tfrm_Frontoperate_EBincvalue.BitBtn18Click(Sender: TObject);
begin
  Close;
end;


procedure Tfrm_Frontoperate_EBincvalue.InitDataBase;
var
  strSQL: string;
begin
  with ADOQuery_Incvalue do begin
    Connection := DataModule_3F.ADOConnection_Main;
    Active := false;
    SQL.Clear;
   // strSQL := 'select * from [TMembeDetail]';
   strSQL := 'select * from [TMembeDetail] order by GetTime desc';
    SQL.Add(strSQL);
    Active := True;
  end;
end;


//转找发送数据格式 ，将字符转换为16进制

function Tfrm_Frontoperate_EBincvalue.exchData(orderStr: string): string;
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

procedure Tfrm_Frontoperate_EBincvalue.sendData();
var
  orderStr: string;
begin
  if orderLst.Count > curOrderNo then
  begin
    orderStr := orderLst.Strings[curOrderNo];
        //memComSeRe.Lines.Add('==>> '+orderStr);
    orderStr := exchData(orderStr);
    comReader.WriteCommData(pchar(orderStr), length(orderStr));
    inc(curOrderNo);
  end;
end;

//检查返回的数据

procedure Tfrm_Frontoperate_EBincvalue.checkOper();
var
  i: integer;
  tmpStr: string;
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



procedure Tfrm_Frontoperate_EBincvalue.comReaderReceiveData(Sender: TObject;
  Buffer: Pointer; BufferLength: Word);
var
  ii: integer;
  recStr: string;
  tmpStr: string;
  tmpStrend: string;
begin
  //---------------------------------
     //接收----------------
    //tmpStrend:= 'STR';
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
  recData_fromICLst.Clear;
  recData_fromICLst.Add(recStr);
   
  begin
    CheckCMD(); //首先根据接收到的数据进行判断，确认此卡是否属于为正确的卡
        
  end;
    //发送---------------
  if curOrderNo < orderLst.Count then // 判断指令是否已经都发送完毕，如果指令序号小于指令总数则继续发送
    sendData()
  else begin
    checkOper();
  end;

end;

 //根据接收到的数据判断此卡是否为合法卡

procedure Tfrm_Frontoperate_EBincvalue.CheckCMD();
var
  i: integer;
  tmpStr: string;
  stationNoStr: string;
  tmpStr_Hex: string;
  tmpStr_Hex_length: string;
  Send_value: string;
  RevComd: integer;
  ID_No: string;
  length_Data: integer;
begin
   //首先截取接收的信息

  tmpStr := recData_fromICLst.Strings[0];
  Edit1.Text := recData_fromICLst.Strings[0];
  Receive_CMD_ID_Infor.ID_CheckNum := copy(tmpStr, 39, 4); //校验和

      // if (CheckSUMData(copy(tmpStr, 1, 38))=copy(tmpStr, 41, 2)+copy(tmpStr, 39, 2)) then//校验和
  begin
    CMD_CheckSum_OK := true;
    Receive_CMD_ID_Infor.CMD := copy(recData_fromICLst.Strings[0], 1, 2); //帧头43
  end;
                 //1、判断此卡是否为已经完成初始化
  if Receive_CMD_ID_Infor.CMD = CMD_COUMUNICATION.CMD_INCValue_RE then
  begin

                  
    begin
      if (Operate_No = 1) then //保存当前卡的初始化记录
      begin
      if Receive_CMD_ID_Infor.ID_type = copy(INit_Wright.User, 8, 2) then
       begin
        Save_INCValue_Data; //保存充值记录
       end;

        //Save_INCValue_Data; //保存充值记录
        Edit_OPResult.Text := '初始化操作、保存成功';
        cleartext; //充值完成后重置
        initdatabase;
        totalvalue.Text := query_totalvalue();
      end;
    end;
  end
  else if Receive_CMD_ID_Infor.CMD = CMD_COUMUNICATION.CMD_READ then
  begin

    Receive_CMD_ID_Infor.ID_INIT := copy(recData_fromICLst.Strings[0], 3, 8); //卡片ID
    Receive_CMD_ID_Infor.ID_3F := copy(recData_fromICLst.Strings[0], 11, 6); //卡厂ID
    Receive_CMD_ID_Infor.Password_3F := copy(recData_fromICLst.Strings[0], 17, 6); //卡密
    Receive_CMD_ID_Infor.Password_USER := copy(recData_fromICLst.Strings[0], 23, 6); //用户密码
    Receive_CMD_ID_Infor.ID_value := copy(recData_fromICLst.Strings[0], 29, 8); //卡内数据
    Receive_CMD_ID_Infor.ID_type := copy(recData_fromICLst.Strings[0], 37, 2); //卡功能

              
    begin


      if (Receive_CMD_ID_Infor.Password_USER = INit_Wright.BossPassword_old) and ((Receive_CMD_ID_Infor.ID_type = copy(INit_Wright.User, 8, 2)) or (Receive_CMD_ID_Infor.ID_type = copy(INit_Wright.OPERN, 8, 2))) then

      begin
        if DataModule_3F.Query_User_INIT_OK(Receive_CMD_ID_Infor.ID_INIT) then //有记录
        begin
          Edit_ID.Text := Receive_CMD_ID_Infor.ID_INIT; //卡ID
          
          ID_UserCard_Text := Receive_CMD_ID_Infor.ID_INIT; //用户币ID
          Edit_Old_Value.Text := ICFunction.Select_ChangeHEX_DECIncValue(Receive_CMD_ID_Infor.ID_value);

          Edit14.Text := '此卡合法，已完成场地初始化,可以进行充值！'; //卡ID
          edit_info.Text := '此卡合法，已完成场地初始化,可以进行充值！';
                                   //连续充值操作选择
          if (CheckBox_Update.Checked) then
          begin
            if (Edit7.Text = '') then
            begin
              Edit14.Text := '请输入连续充值额，只能输入数字！';
              edit_info.Text := '请输入连续充值额，只能输入数字！';
              exit;
            end
            else
            begin
              Operate_No := 1;
              INIT_Operation; //调用写入ID函数
            end;
          end;
        end
        else
        begin
                                 
          Edit14.Text := '在此系统无记录，请通知老板！'; //卡ID
          edit_info.Text  := '在此系统无记录，请通知老板！';
          exit;
        end;
      end

      else if (Receive_CMD_ID_Infor.Password_USER = INit_Wright.BossPassword_3F) and ((Receive_CMD_ID_Infor.ID_type = copy(INit_Wright.User, 8, 2)) or (Receive_CMD_ID_Infor.ID_type = copy(INit_Wright.OPERN, 8, 2))) then

      begin
        Edit_ID.Text := Receive_CMD_ID_Infor.ID_INIT; //卡ID

        Edit14.Text := '此卡合法，已经完成出厂初始化，请进行先场地初始化！'; //卡ID
        edit_info.Text := '此卡合法，已经完成出厂初始化，请进行先场地初始化！'; 
        exit;
      end
      else
      begin
        Edit_ID.Text := '';
        Edit14.Text := '此卡合法，但不是游戏币，请更换！'; //卡ID
        edit_info.Text := '此卡合法，但不是游戏币，请更换！'; //卡ID
        exit;
      end;
    end;

  end;

end;

//初始化操作

procedure Tfrm_Frontoperate_EBincvalue.INIT_Operation;
var
  INC_value: string;
  strValue: string;
begin
  begin
    INC_value := Edit7.Text; //充值数值
    strhavemoney := Edit7.Text; //充值数值
    strValue := Make_Send_CMD(CMD_COUMUNICATION.CMD_INCValue, INC_value); //计算充值指令
    INcrevalue(strValue); //写入ID卡
  end;
end;

//计算充值指令

function Tfrm_Frontoperate_EBincvalue.Make_Send_CMD(StrCMD: string; StrIncValue: string): string;
var
  ii, jj, KK: integer;
  TmpStr_IncValue: string; //充值数字
  TmpStr_CheckSum: string; //校验和
  TmpStr_SendCMD: string; //指令内容
  reTmpStr: string;
begin
  Send_CMD_ID_Infor.CMD := StrCMD; //帧命令
  Send_CMD_ID_Infor.ID_INIT := Receive_CMD_ID_Infor.ID_INIT;

    //------------20120320追加写币有效期 开始-----------
    //FormatDateTime('yyyy-MM-dd HH:mm:ss',now);
    //Send_CMD_ID_Infor.ID_3F:=Receive_CMD_ID_Infor.ID_3F;
    //Send_CMD_ID_Infor.Password_3F:=Receive_CMD_ID_Infor.Password_3F;

  if iHHSet = 0 then //时间限制设置无效
  begin
    Send_CMD_ID_Infor.ID_3F := IntToHex(0, 2) + IntToHex(0, 2) + IntToHex(0, 2);
    Send_CMD_ID_Infor.Password_3F := IntToHex(0, 2) + IntToHex(0, 2) + IntToHex(0, 2);
  end
  else //起用时间设置
  begin
    GetInvalidDate;
  end;

    //------------20120320追加写币有效期 结束-----------



  Send_CMD_ID_Infor.Password_USER := Receive_CMD_ID_Infor.Password_USER;
    //TmpStr_IncValue字节需要重新排布 ，如果StrIncValue>65535(FFFF)
   // TmpStr_IncValue:=IntToHex(strToint(StrIncValue),2);//将输入的文本数字转换为16进制
    //------------20120220追加代币比例SystemWorkground.ErrorGTState 开始-----------
    //TmpStr_IncValue:= StrIncValue;
  TmpStr_IncValue := IntToStr(StrToInt(StrIncValue) * StrToInt(SystemWorkground.ErrorGTState));
    //------------20120220追加代币比例 结束-----------
  Send_CMD_ID_Infor.ID_value := Select_IncValue_Byte(TmpStr_IncValue);

    //卡功能类型
  Send_CMD_ID_Infor.ID_type := Receive_CMD_ID_Infor.ID_type;
    //汇总发送内容
  TmpStr_SendCMD := Send_CMD_ID_Infor.CMD + Send_CMD_ID_Infor.ID_INIT + Send_CMD_ID_Infor.ID_3F + Send_CMD_ID_Infor.Password_3F + Send_CMD_ID_Infor.Password_USER + Send_CMD_ID_Infor.ID_value + Send_CMD_ID_Infor.ID_type;
    //将发送内容进行校核计算
  TmpStr_CheckSum := CheckSUMData(TmpStr_SendCMD);
    //TmpStr_CheckSum字节需要重新排布 ，低字节在前，高字节在后
  Send_CMD_ID_Infor.ID_CheckNum := Select_CheckSum_Byte(TmpStr_CheckSum);
  Send_CMD_ID_Infor.ID_Settime := Receive_CMD_ID_Infor.ID_Settime;


  reTmpStr := TmpStr_SendCMD + Send_CMD_ID_Infor.ID_CheckNum;

  result := reTmpStr;

end;

//取得有效时间日期

procedure Tfrm_Frontoperate_EBincvalue.GetInvalidDate;
var
  strtemp: string;
  iYear, iMonth, iDate, iHH, iMin: integer;
begin


  strtemp := FormatDateTime('yyyy-MM-dd HH:mm:ss', now);
    //调整前
   // strtemp:=Copy(strtemp,1,2)+Copy(strtemp,3,2)+Copy(strtemp,6,2)+Copy(strtemp,9,2)+Copy(strtemp,12,2)+Copy(strtemp,15,2)+Copy(strtemp,20,2);
     //调整后

  iYear := strToint(Copy(strtemp, 1, 4)); //年
  iMonth := strToint(Copy(strtemp, 6, 2)); //月
  iDate := strToint(Copy(strtemp, 9, 2)); //日
  iHH := strToint(Copy(strtemp, 12, 2)); //小时
  iMin := strToint(Copy(strtemp, 15, 2)); //分钟

  if (iHHSet > 47) then
  begin
    showmessage('为了保护您场地利益安全，请设定币有效时间小于48');
    exit;
  end;
  if ((iHH + iHHSet) >= 24) and ((iHH + iHHSet) < 48) then
  begin
    iHH := (iHH + iHHSet) - 24; //取得新的小时
    if (iYear < 1930) then
    begin
      showmessage('系统时间的年份设定错误，请与卡头对时同步');
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
  else if ((iHH + iHHSet) < 24) then
  begin
    iHH := (iHH + iHHSet); //取得新的小时
  end;

     //转换为16进制后
  Send_CMD_ID_Infor.ID_3F := IntToHex(iMonth, 2) + IntToHex(iHH, 2) + IntToHex(strtoint(Copy(strtemp, 3, 2)), 2);
  Send_CMD_ID_Infor.Password_3F := IntToHex(iDate, 2) + IntToHex(iMin, 2) + IntToHex(strtoint(Copy(strtemp, 1, 2)), 2);
    //strtemp:=Copy(strtemp,6,2)+Copy(strtemp,12,2)+Copy(strtemp,3,2)+Copy(strtemp,9,2)+Copy(strtemp,15,2)+Copy(strtemp,1,2);

    //Edit9.Text:=strtemp;
    //Edit8.Text:=Send_CMD_ID_Infor.ID_3F+',,,'+Send_CMD_ID_Infor.Password_3F;
    //
end;

//校验和，确认是否正确

function Tfrm_Frontoperate_EBincvalue.CheckSUMData(orderStr: string): string;
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

//充值数据转换成16进制并排序 字节LL、字节LH、字节HL、字节HH

function Tfrm_Frontoperate_EBincvalue.Select_IncValue_Byte(StrIncValue: string): string;
var
  tempLH, tempHH, tempHL, tempLL: integer; //2147483648 最大范围
begin
  tempHH := StrToint(StrIncValue) div 16777216; //字节HH
  tempHL := (StrToInt(StrIncValue) mod 16777216) div 65536; //字节HL
  tempLH := (StrToInt(StrIncValue) mod 65536) div 256; //字节LH
  tempLL := StrToInt(StrIncValue) mod 256; //字节LL

  result := IntToHex(tempLL, 2) + IntToHex(tempLH, 2) + IntToHex(tempHL, 2) + IntToHex(tempHH, 2);
end;

//校验和转换成16进制并排序 字节LL、字节LH

function Tfrm_Frontoperate_EBincvalue.Select_CheckSum_Byte(StrCheckSum: string): string;
var
  jj: integer;
  tempLH, tempLL: integer; //2147483648 最大范围

begin
  jj := strToint('$' + StrCheckSum); //将字符转转换为16进制数，然后转换位10进制
  tempLH := (jj mod 65536) div 256; //字节LH
  tempLL := jj mod 256; //字节LL

  result := IntToHex(tempLL, 2) + IntToHex(tempLH, 2);
end;


procedure Tfrm_Frontoperate_EBincvalue.FormShow(Sender: TObject);
begin
  ICFunction.InitSystemWorkPath; //初始化文件路径
  ICFunction.InitSystemWorkground; //初始化参数背景
  comReader.StartComm();
  orderLst := TStringList.Create;
  recDataLst := tStringList.Create;
  recData_fromICLst := tStringList.Create;
  //InitDataBase; //显示出型号
  strhavemoney := '0'; //充值数值
  Edit_Old_Value.Text := '0';
  
  Init_Key_Enabled(SystemWorkground.ErrorGTState, INit_Wright.MaxValue);
  Panel_infor.Caption := '因您设定的代币比例为1 ：' + SystemWorkground.ErrorGTState + ',所以只能输入小于' + IntToStr(StrToInt(INit_Wright.MaxValue) div StrToInt(SystemWorkground.ErrorGTState)) + '的数值！';
  //初始化充值记录
  initdatabase;
  totalvalue.Text := query_totalvalue();
end;

procedure Tfrm_Frontoperate_EBincvalue.Init_Key_Enabled(bili: string; maxvalue: string);
var
  strValue: string;
  i: integer;
begin

  if (500 * StrToInt(bili)) > StrToInt(maxvalue) then
  begin
    BitBtn_500.Enabled := false;
  end
  else
  begin
    BitBtn_500.Enabled := true;
  end;
  if (400 * StrToInt(bili)) > StrToInt(maxvalue) then
  begin
    BitBtn_400.Enabled := false;
  end
  else
  begin
    BitBtn_400.Enabled := true;
  end;
  if (300 * StrToInt(bili)) > StrToInt(maxvalue) then
  begin
    BitBtn_300.Enabled := false;
  end
  else
  begin
    BitBtn_300.Enabled := true;
  end;
  if (200 * StrToInt(bili)) > StrToInt(maxvalue) then
  begin
    BitBtn_200.Enabled := false;
  end
  else
  begin
    BitBtn_200.Enabled := true;
  end;
  if (100 * StrToInt(bili)) > StrToInt(maxvalue) then
  begin
    BitBtn_100.Enabled := false;
  end
  else
  begin
    BitBtn_100.Enabled := true;
  end;
  if (50 * StrToInt(bili)) > StrToInt(maxvalue) then
  begin
    BitBtn_50.Enabled := false;
  end
  else
  begin
    BitBtn_50.Enabled := true;
  end;
  if (40 * StrToInt(bili)) > StrToInt(maxvalue) then
  begin
    BitBtn_40.Enabled := false;
  end
  else
  begin
    BitBtn_40.Enabled := true;
  end;
  if (30 * StrToInt(bili)) > StrToInt(maxvalue) then
  begin
    BitBtn_30.Enabled := false;
  end
  else
  begin
    BitBtn_30.Enabled := true;
  end;
  if (20 * StrToInt(bili)) > StrToInt(maxvalue) then
  begin
    BitBtn_20.Enabled := false;
  end
  else
  begin
    BitBtn_20.Enabled := true;
  end;
  if (10 * StrToInt(bili)) > StrToInt(maxvalue) then
  begin
    BitBtn_10.Enabled := false;
  end
  else
  begin
    BitBtn_10.Enabled := true;
  end;
end;

procedure Tfrm_Frontoperate_EBincvalue.FormClose(Sender: TObject; var Action: TCloseAction);
var
  i: integer;
begin
  orderLst.Free();
  recDataLst.Free();
  recData_fromICLst.Free();
  comReader.StopComm();
  for i := 0 to ComponentCount - 1 do
  begin
    if components[i] is TEdit then
    begin
      (components[i] as TEdit).Clear;
    end
  end;
end;


//充值保存确认

procedure Tfrm_Frontoperate_EBincvalue.IncvalueComfir(S: string; S1: string);

var
  strIDNo, strName, strUserNo, strIncvalue, strGivecore, strOperator, strhavemoney, strinputdatetime: string;
  i: integer;
label ExitSub;
begin

  strIDNo := Edit_ID.Text;
  strOperator := G_User.UserNO; //操作员
  strinputdatetime := DateTimetostr((now())); //录入时间，读取系统时间

  with ADOQuery_Incvalue do begin
    Append;
         // FieldByName('CostMoney').AsString :=strIncvalue;  //充值
         // FieldByName('cUserNo').AsString:=strOperator;    //操作员
         // FieldByName('GetTime').AsString := strinputdatetime; //交易时间
         // FieldByName('IDCardNo').AsString := strIDNo;//卡ID
    try
      Post;
    except
      on e: Exception do ShowMessage(e.Message);
    end;
  end;


  ExitSub:
   //情况输入框
  for i := 0 to ComponentCount - 1 do
  begin
    if components[i] is TEdit then
    begin
      (components[i] as TEdit).Clear;
    end
  end;
end;




procedure Tfrm_Frontoperate_EBincvalue.FormCreate(Sender: TObject);
begin

  EventObj := EventUnitObj.Create;
  EventObj.LoadEventIni;

end;
//回复IC已经收到寻卡成功的信息A1指令
 {
procedure Tfrm_Frontoperate_EBincvalue.Send_A1();
var
  strValue: string;
  i: integer;
begin
  orderLst.Clear();
  recDataLst.Clear();
  curOrderNo := 0;
  curOperNo := 17;
  orderLst.Add('AA8A5F5FA10000BB4A');
  sendData();
end;
//验证卡  AA 8A 5F 5F A1 01 00 BB 4A
}

procedure Tfrm_Frontoperate_EBincvalue.BitBtn17Click(Sender: TObject);
begin
  orderLst.Clear();
  recDataLst.Clear();
  curOrderNo := 0;
  curOperNo := 17;
  orderLst.Add('AA8A5F5FA10100BB4A');
  sendData();
end;
//读卡值

procedure Tfrm_Frontoperate_EBincvalue.BitBtn19Click(Sender: TObject);
begin
  orderLst.Clear();
  recDataLst.Clear();
  curOrderNo := 0;
  curOperNo := 17;
  orderLst.Add('AA8A5F5FB101014A');
  sendData();
end;
//充值函数

procedure Tfrm_Frontoperate_EBincvalue.INcrevalue(S: string);
begin
  orderLst.Clear();
  recDataLst.Clear();
  curOrderNo := 0;
  curOperNo := 2;
  Edit1.Text := s;
  orderLst.Add(S); //将币值写入币种
  sendData();
end;

//清卡值

procedure Tfrm_Frontoperate_EBincvalue.BitBtn1Click(Sender: TObject);
var
  INC_value: string;
  strValue: string;
  i: integer;
begin
  if Edit_ID.Text = '' then
  begin
    MessageBox(handle, '无卡!请勿乱操作', '错误', MB_ICONERROR + MB_OK);
    exit;
  end
  else
  begin
    INC_value := '000'; //充值数值
    Operate_No := 1;
    strValue := Make_Send_CMD(CMD_COUMUNICATION.CMD_INCValue, INC_value); //计算充值指令
    INcrevalue(strValue);
  end;

end;
//回复IC已经收到剩余币值的信息B1指令
{
procedure Tfrm_Frontoperate_EBincvalue.Send_B1();
var
  strValue: string;
  i: integer;
begin
  orderLst.Clear();
  recDataLst.Clear();
  curOrderNo := 0;
  curOperNo := 2;
  orderLst.Add('AA8A5F5FB10100BB4A');
  sendData();
end;
}


//充值500== 0E

procedure Tfrm_Frontoperate_EBincvalue.BitBtn_500Click(Sender: TObject);
var
  INC_value: string;
  strValue: string;
  i: integer;
begin

  if Edit_ID.Text = '' then
  begin
    MessageBox(handle, '无卡!请勿乱操作', '错误', MB_ICONERROR + MB_OK);
    exit;
  end
  else
  begin
    INC_value := '500'; //充值数值
    strhavemoney := '500'; //充值数值
    Operate_No := 1;
    strValue := Make_Send_CMD(CMD_COUMUNICATION.CMD_INCValue, INC_value); //计算充值指令

    INcrevalue(strValue);
  end;


end;
//充值400== 0D

procedure Tfrm_Frontoperate_EBincvalue.BitBtn_400Click(Sender: TObject);
var
  INC_value: string;
  strValue: string;
begin

  if Edit_ID.Text = '' then
  begin
    MessageBox(handle, '无卡!请勿乱操作', '错误', MB_ICONERROR + MB_OK);
    exit;
  end
  else
  begin
    INC_value := '400'; //充值数值
    strhavemoney := '400'; //充值数值
    Operate_No := 1;
    strValue := Make_Send_CMD(CMD_COUMUNICATION.CMD_INCValue, INC_value); //计算充值指令
    INcrevalue(strValue);
  end;

end;
//充值300== 0C

procedure Tfrm_Frontoperate_EBincvalue.BitBtn_300Click(Sender: TObject);
var
  INC_value: string;
  strValue: string;
begin
  if Edit_ID.Text = '' then
  begin
    MessageBox(handle, '无卡!请勿乱操作', '错误', MB_ICONERROR + MB_OK);
    exit;
  end
  else
  begin
    INC_value := '300'; //充值数值
    strhavemoney := '300'; //充值数值
    Operate_No := 1;
    strValue := Make_Send_CMD(CMD_COUMUNICATION.CMD_INCValue, INC_value); //计算充值指令
    INcrevalue(strValue);
  end;

end;
//充值200== 0B

procedure Tfrm_Frontoperate_EBincvalue.BitBtn_200Click(Sender: TObject);
var
  INC_value: string;
  strValue: string;
begin

  if Edit_ID.Text = '' then
  begin
    MessageBox(handle, '无卡!请勿乱操作', '错误', MB_ICONERROR + MB_OK);
    exit;
  end
  else
  begin
    INC_value := '200'; //充值数值
    strhavemoney := '200'; //充值数值
    Operate_No := 1;
    strValue := Make_Send_CMD(CMD_COUMUNICATION.CMD_INCValue, INC_value); //计算充值指令
    INcrevalue(strValue);
  end;

end;
//充值100== 0A

procedure Tfrm_Frontoperate_EBincvalue.BitBtn_100Click(Sender: TObject);
var
  INC_value: string;
  strValue: string;
begin

  if Edit_ID.Text = '' then
  begin
    MessageBox(handle, '无卡!请勿乱操作', '错误', MB_ICONERROR + MB_OK);
    exit;
  end
  else
  begin
    INC_value := '100'; //充值数值
    strhavemoney := '100'; //充值数值
    Operate_No := 1;
    strValue := Make_Send_CMD(CMD_COUMUNICATION.CMD_INCValue, INC_value); //计算充值指令

    INcrevalue(strValue);
  end;

end;
//充值50== 06

procedure Tfrm_Frontoperate_EBincvalue.BitBtn_50Click(Sender: TObject);
var
  INC_value: string;
  strValue: string;
  i: integer;
begin

  if Edit_ID.Text = '' then
  begin
    MessageBox(handle, '无卡!请勿乱操作', '错误', MB_ICONERROR + MB_OK);
    exit;
  end
  else
  begin
    INC_value := '50'; //充值数值
    strhavemoney := '50'; //充值数值
    Operate_No := 1;
    strValue := Make_Send_CMD(CMD_COUMUNICATION.CMD_INCValue, INC_value); //计算充值指令
    INcrevalue(strValue);
  end;

end;
 //充值40== 05

procedure Tfrm_Frontoperate_EBincvalue.BitBtn_40Click(Sender: TObject);
var
  INC_value: string;
  strValue: string;
  i: integer;
begin
  if Edit_ID.Text = '' then
  begin
    MessageBox(handle, '无卡!请勿乱操作', '错误', MB_ICONERROR + MB_OK);
    exit;
  end
  else
  begin
    INC_value := '40'; //充值数值
    strhavemoney := '40'; //充值数值
    Operate_No := 1;
    strValue := Make_Send_CMD(CMD_COUMUNICATION.CMD_INCValue, INC_value); //计算充值指令
    INcrevalue(strValue);
  end;
end;
 //充值30== 04

procedure Tfrm_Frontoperate_EBincvalue.BitBtn_30Click(Sender: TObject);
var
  INC_value: string;
  strValue: string;
  i: integer;
begin

  if Edit_ID.Text = '' then
  begin
    MessageBox(handle, '无卡!请勿乱操作', '错误', MB_ICONERROR + MB_OK);
    exit;
  end
  else
  begin
    INC_value := '30'; //充值数值
    strhavemoney := '30'; //充值数值
    Operate_No := 1;
    strValue := Make_Send_CMD(CMD_COUMUNICATION.CMD_INCValue, INC_value); //计算充值指令
    INcrevalue(strValue);
  end;
end;
 //充值20== 03

procedure Tfrm_Frontoperate_EBincvalue.BitBtn_20Click(Sender: TObject);
var
  INC_value: string;
  strValue: string;
  i: integer;
begin

  if Edit_ID.Text = '' then
  begin
    MessageBox(handle, '无卡!请勿乱操作', '错误', MB_ICONERROR + MB_OK);
    exit;
  end
  else
  begin
    INC_value := '20'; //充值数值
    strhavemoney := '20'; //充值数值
    Operate_No := 1;
    strValue := Make_Send_CMD(CMD_COUMUNICATION.CMD_INCValue, INC_value); //计算充值指令
    INcrevalue(strValue);
  end;
end;
 //充值10== 02

procedure Tfrm_Frontoperate_EBincvalue.BitBtn_10Click(Sender: TObject);
var
  INC_value: string;
  strValue: string;
  i: integer;
begin
  if Edit_ID.Text = '' then
  begin
    MessageBox(handle, '无卡!请勿乱操作', '错误', MB_ICONERROR + MB_OK);
    exit;
  end
  else
  begin
    INC_value := '10'; //充值数值
    strhavemoney := '10'; //充值数值
    Operate_No := 1;
    strValue := Make_Send_CMD(CMD_COUMUNICATION.CMD_INCValue, INC_value); //计算充值指令
    INcrevalue(strValue);

  end;
end;
  //充值1== 1

procedure Tfrm_Frontoperate_EBincvalue.BitBtn16Click(Sender: TObject);
var
  INC_value: string;
  strValue: string;
begin
  if Edit_ID.Text = '' then
  begin
    MessageBox(handle, '无卡!请勿乱操作', '错误', MB_ICONERROR + MB_OK);
    exit;
  end
  else
  begin
    INC_value := '10'; //充值数值
    strValue := Make_Send_CMD(CMD_COUMUNICATION.CMD_INCValue, INC_value); //计算充值指令
    INcrevalue(strValue);
  end;
end;
    //充值2== 2

procedure Tfrm_Frontoperate_EBincvalue.BitBtn15Click(Sender: TObject);
var
  INC_value: string;
  strValue: string;
  i: integer;
begin

  if Edit_ID.Text = '' then
  begin
    MessageBox(handle, '无卡!请勿乱操作', '错误', MB_ICONERROR + MB_OK);
    exit;
  end
  else
  begin
    INC_value := '10'; //充值数值
    strValue := Make_Send_CMD(CMD_COUMUNICATION.CMD_INCValue, INC_value); //计算充值指令
    INcrevalue(strValue);
  end;
end;
    //充值3== 3

procedure Tfrm_Frontoperate_EBincvalue.BitBtn14Click(Sender: TObject);
var
  INC_value: string;
  strValue: string;
  i: integer;
begin

  if Edit_ID.Text = '' then
  begin
    MessageBox(handle, '无卡!请勿乱操作', '错误', MB_ICONERROR + MB_OK);
    exit;
  end
  else
  begin
    INC_value := '10'; //充值数值
    strValue := Make_Send_CMD(CMD_COUMUNICATION.CMD_INCValue, INC_value); //计算充值指令
    INcrevalue(strValue);
  end;
end;
    //充值4== 4

procedure Tfrm_Frontoperate_EBincvalue.BitBtn13Click(Sender: TObject);
var
  INC_value: string;
  strValue: string;
  i: integer;
begin

  if Edit_ID.Text = '' then
  begin
    MessageBox(handle, '无卡!请勿乱操作', '错误', MB_ICONERROR + MB_OK);
    exit;
  end
  else
  begin
    INC_value := '10'; //充值数值
    strValue := Make_Send_CMD(CMD_COUMUNICATION.CMD_INCValue, INC_value); //计算充值指令
    INcrevalue(strValue);
  end;
end;
    //充值5== 5

procedure Tfrm_Frontoperate_EBincvalue.BitBtn12Click(Sender: TObject);
var
  INC_value: string;
  strValue: string;
  i: integer;
begin

  if Edit_ID.Text = '' then
  begin
    MessageBox(handle, '无卡!请勿乱操作', '错误', MB_ICONERROR + MB_OK);
    exit;
  end
  else
  begin
    INC_value := '10'; //充值数值
    strValue := Make_Send_CMD(CMD_COUMUNICATION.CMD_INCValue, INC_value); //计算充值指令
    INcrevalue(strValue);
  end;
end;
{
//保存初始化数据
procedure Tfrm_Frontoperate_EBincvalue.Save_INCValue_Data;
var
  strOperator,strinputdatetime:string;
  label ExitSub;
begin

  strOperator:=G_User.UserNO;
  strinputdatetime:=DateTimetostr((now()));     //录入时间，读取系统时间
               With ADOQuery_Incvalue do
               begin
                  Append;
                  FieldByName('ID_INC').AsString :=Send_CMD_ID_Infor.ID_INIT;
                  FieldByName('cUserNo').AsString :=LOAD_USER.ID_INIT;
                  FieldByName('ID_value').AsString :=IntToHex(strToint('$'+Copy(Send_CMD_ID_Infor.ID_value,1,3))*strToint('$'+Copy(Send_CMD_ID_Infor.ID_INIT,3,4)),2)+IntToHex(strToint('$'+Copy(Send_CMD_ID_Infor.ID_value,4,3))*strToint('$'+Copy(Send_CMD_ID_Infor.ID_INIT,3,2)),2)+IntToHex(strToint('$'+Copy(Send_CMD_ID_Infor.ID_value,7,2))*strToint('$'+Copy(Send_CMD_ID_Infor.ID_INIT,1,3)),2);
                  FieldByName('ID_INCttime').AsString :=FormatDateTime('yyyy-MM-dd HH:mm:ss',now);
                  try
                     Post;
                  Except
                  on e:Exception do ShowMessage(e.Message);
                   end;
               end;

               ExitSub:
               Send_CMD_ID_Infor.ID_INIT:='';
               Send_CMD_ID_Infor.ID_3F:='';
               Send_CMD_ID_Infor.Password_3F:='';
               Send_CMD_ID_Infor.Password_USER:='';
               Send_CMD_ID_Infor.ID_value:='';
               Send_CMD_ID_Infor.ID_type:='';
               Send_CMD_ID_Infor.ID_CheckNum:='';
               Send_CMD_ID_Infor.ID_Settime:='';
               Operate_No:=0;
end;

}
//保存初始化数据

procedure Tfrm_Frontoperate_EBincvalue.Save_INCValue_Data;
 
begin
 
  if (Edit_Old_Value.Text <> '0') and Query_LastRecord(ID_UserCard_Text) and query_idusercard_valid(ID_UserCard_Text)  then
    begin
      Update_LastRecord_Value(ID_UserCard_Text); //ID_UserCard_Text为电子币ID，根据此更新电子币充值记录
    end
  else
    begin
         Update_LastRecord_usercard(ID_UserCard_Text);//更新最新充值记录
         new_recharge_record;
    end;
  
end;

procedure Tfrm_Frontoperate_EBincvalue.cleartext;
begin


  Edit_ID.Text := '';
  Send_CMD_ID_Infor.ID_INIT := '';
  Send_CMD_ID_Infor.ID_3F := '';
  Send_CMD_ID_Infor.Password_3F := '';
  Send_CMD_ID_Infor.Password_USER := '';
  Send_CMD_ID_Infor.ID_value := '';
  Send_CMD_ID_Infor.ID_type := '';
  Send_CMD_ID_Infor.ID_CheckNum := '';
  Send_CMD_ID_Infor.ID_Settime := '';
  Operate_No := 0;
  strhavemoney := '0';
  ID_UserCard_Text := '';
  
end;

procedure Tfrm_Frontoperate_EBincvalue.new_recharge_record;
var
  strOperator, strinputdatetime,strexpiretime: string;

begin
  
  strOperator := G_User.UserNO;
  strinputdatetime := DateTimetostr((now())); //录入时间，读取系统时间
  strexpiretime :=  FormatDateTime('yyyy-MM-dd HH:mm:ss', addhrs(now,iHHSet));
  
  with ADOQuery_Incvalue do
  begin
    Append;


    FieldByName('MemCardNo').AsString := G_User.UserNO;
    FieldByName('CostMoney').AsString := strhavemoney; //充值
    FieldByName('TickCount').AsString := '0';
    FieldByName('cUserNo').AsString := strOperator; //操作员
    FieldByName('GetTime').AsString := FormatDateTime('yyyy-MM-dd HH:mm:ss', now); ; //交易时间
    FieldByName('TotalMoney').AsString := strhavemoney; //帐户总额

    FieldByName('IDCardNo').AsString := LOAD_USER.ID_INIT; //充值操作
    FieldByName('MemberName').AsString := LOAD_USER.ID_INIT; //用户名

    FieldByName('PayType').AsString := '0'; //充值操作
    FieldByName('MacNo').AsString := 'A0100'; //机台编号
    FieldByName('ExitCoin').AsInteger := 0;
    FieldByName('Compter').AsString := '1';
    FieldByName('LastRecord').AsString := '1';
    FieldByName('TickCount').AsString := '0';
    FieldByName('ID_UserCard_TuiBi_Flag').AsString := '0'; //退币标识
    FieldByName('ID_UserCard').AsString := ID_UserCard_Text; //电子币ID
    //add by linlf 20140330   
    FieldByName('expiretime').AsString := strexpiretime; //失效时间
    try
      Post;
    except
      on e: Exception do ShowMessage(e.Message);
    end;
  end;

end;

function Tfrm_Frontoperate_EBincvalue.Query_LastRecord(S: string): boolean;
var
  ADOQ: TADOQuery;
  strSQL, strRet: string;
  MaxID: integer;
  setvalue, settime: string;
begin


  Result := false;

  strSQL := 'select count(MD_ID) from TMembeDetail where (ID_UserCard=''' + S + ''') and LastRecord=''1'' and id_usercard_tuibi_flag=''0'' ';
  ADOQ := TADOQuery.Create(nil);
  with ADOQ do begin
    Connection := DataModule_3F.ADOConnection_Main;
    SQL.Clear;
    SQL.Add(strSQL);
    Open;
    if (not eof) then
      MaxID := StrToInt(TrimRight(ADOQ.Fields[0].AsString)); ;

    Close;
  end;
  FreeAndNil(ADOQ);

  if MaxID = 0 then
    Result := false
  else
    Result := true;


end;

//更新此用户币最新充值、消分操作的记录标志位

procedure Tfrm_Frontoperate_EBincvalue.Update_LastRecord_Value(S: string);
var
  ADOQ: TADOQuery;
  strSQL, strRet: string;
  MaxID: string;
  setvalue, settime, setflag,strexpiretime: string;
begin
  strSQL := 'select max(MD_ID) from TMembeDetail where (ID_UserCard=''' + S + ''') ';
  ADOQ := TADOQuery.Create(nil);
  with ADOQ do begin
    Connection := DataModule_3F.ADOConnection_Main;
    SQL.Clear;
    SQL.Add(strSQL);
    Open;
    if (not eof) then
      MaxID := TrimRight(ADOQ.Fields[0].AsString);
    Close;
  end;
  FreeAndNil(ADOQ);
  setflag := '0';
  settime := FormatDateTime('yyyy-MM-dd HH:mm:ss', now);
  strexpiretime :=  FormatDateTime('yyyy-MM-dd HH:mm:ss', addhrs(now,iHHSet));
  setvalue := TrimRight(strhavemoney);
  strSQL := 'Update TMembeDetail set TotalMoney=''' + setvalue + ''',GetTime=''' + settime + ''',CostMoney='''
  + setvalue + ''' ,expiretime=''' + strexpiretime + ''' where (MD_ID=''' + MaxID + ''') and (ID_UserCard_TuiBi_Flag=''' + setflag + ''')';
  ADOQ := TADOQuery.Create(nil);
  with ADOQ do begin
    Connection := DataModule_3F.ADOConnection_Main;
    SQL.Clear;
    SQL.Add(strSQL);
    ADOQ.ExecSQL;
  end;
  FreeAndNil(ADOQ);

end;


procedure Tfrm_Frontoperate_EBincvalue.Update_LastRecord_UserCard(S: string);
var
  ADOQ: TADOQuery;
  strSQL, strRet: string;
  MaxID: string;
  setvalue: string;
begin
  strSQL := 'select max(MD_ID) from TMembeDetail where ID_UserCard=''' + S + '''';
  ADOQ := TADOQuery.Create(nil);
  with ADOQ do begin
    Connection := DataModule_3F.ADOConnection_Main;
    SQL.Clear;
    SQL.Add(strSQL);
    Open;
    if (not eof) then
      MaxID := TrimRight(ADOQ.Fields[0].AsString);
    Close;
  end;
  FreeAndNil(ADOQ);

  setvalue := '0';
  strSQL := 'Update TMembeDetail set LastRecord=''' + setvalue + ''' where MD_ID=''' + MaxID + '''';
  ADOQ := TADOQuery.Create(nil);
  with ADOQ do begin
    Connection := DataModule_3F.ADOConnection_Main;
    SQL.Clear;
    SQL.Add(strSQL);
    ADOQ.ExecSQL;
  end;
  FreeAndNil(ADOQ);

end;


procedure Tfrm_Frontoperate_EBincvalue.Edit7KeyPress(Sender: TObject;
  var Key: Char);
var
  strtemp: string;
begin

  if not (key in ['0'..'9', #8, #13]) then
  begin
    key := #0;
    ShowMessage('输入错误，只能输入数字！');
  end
  else if key = #13 then
  begin
    if (StrToInt(Edit7.Text) * StrToInt(SystemWorkground.ErrorGTState)) < (StrToInt(INit_Wright.MaxValue) + 1) then
    begin
      CheckBox_Update.Enabled := true;
    end
    else
    begin
      strtemp := IntToStr(StrToInt(INit_Wright.MaxValue) div StrToInt(SystemWorkground.ErrorGTState));
      ShowMessage('输入错误，因为您设定的用户币保护上限值为' + INit_Wright.MaxValue + ',只能输入小于' + strtemp + '的数值！');
      CheckBox_Update.Enabled := false;
    end;
  end;

end;

procedure Tfrm_Frontoperate_EBincvalue.BitBtn2Click(Sender: TObject);
var
  INC_value: string;
  strValue: string;
  i: integer;
begin
  INC_value := '100'; //充值数值
  Operate_No := 1;
  strValue := Make_Send_CMD(CMD_COUMUNICATION.CMD_INCValue, INC_value); //计算充值指令

         //INcrevalue(strValue);
end;

function Tfrm_Frontoperate_EBincvalue.Query_idusercard_valid(S: string): boolean;
var
  ADOQ: TADOQuery;
  strSQL, strRet: string;
  MaxID: integer;
  setvalue, settime: string;
  strdatetime :string;
begin


  Result := false;
  strdatetime := formatdatetime('yyyy-mm-dd hh:mm:ss', now() ) ;
  strSQL := ' select count(MD_ID) from TMembeDetail where (ID_UserCard= '''
         + S + ''') and LastRecord=''1''  and expiretime > '''
         + strdatetime + '''';
  //showmessage(strSQL);
  ADOQ := TADOQuery.Create(nil);
  with ADOQ do begin
    Connection := DataModule_3F.ADOConnection_Main;
    SQL.Clear;
    SQL.Add(strSQL);
    Open;
    if (not eof) then
      MaxID := StrToInt(TrimRight(ADOQ.Fields[0].AsString)); ;

    Close;
  end;
  FreeAndNil(ADOQ);

  if MaxID = 0 then
    Result := false
  else
    Result := true;


end;

Function Tfrm_Frontoperate_EBincvalue.Query_totalvalue() : string;
var
  ADOQTemp: TADOQuery;
  strSQL: string;
  reTmpStr: string;
  strMaxMD_ID: string;
begin
                   //取得最新的总分
  ADOQTemp := TADOQuery.Create(nil);               

  strSQL := 'select sum(TotalMoney) from [TMembeDetail] ';

  with ADOQTemp do
  begin
    Connection := DataModule_3F.ADOConnection_Main;
    SQL.Clear;
    SQL.Add(strSQL);
    Active := True;
    result := ADOQTemp.Fields[0].AsString;
  end;
  FreeAndNil(ADOQTemp);
end;


end.
