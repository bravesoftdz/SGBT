unit IC_SetParameter_DataBaseInitUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, IniFiles,
  Dialogs, DB, ADODB, StdCtrls, Buttons, ExtCtrls, SPComm;

type
  Tfrm_IC_SetParameter_DataBaseInit = class(TForm)
    Panel1: TPanel;
    GroupBox5: TGroupBox;
    btnFactoryInitial: TBitBtn;
    Comm_Check: TComm;
    lblMessage: TPanel;
    GroupBox2: TGroupBox;
    btnClearCoinRecharge: TButton;
    btnClearBarFlow: TButton;
    btnClearCoinRefund: TButton;
    procedure btnFactoryInitialClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Comm_CheckReceiveData(Sender: TObject; Buffer: Pointer;
      BufferLength: Word);

    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Bit_CloseClick(Sender: TObject);
    procedure btnClearCoinRechargeClick(Sender: TObject);
    procedure btnClearBarFlowClick(Sender: TObject);
    procedure btnClearCoinRefundClick(Sender: TObject);

    private
    { Private declarations }

    procedure CheckCMD_Right(); //系统主机权限判断，确认是否与加密狗唯一对应
    procedure INcrevalue(S: string); //充值函数
    procedure sendData();
        //发送握手请求指令

    function exchData(orderStr: string): string;
    //发送读取场地密码请求指令

    function Make_Send_CMD_PasswordIC(StrCMD: string; StrIncValue: string): string;
    function CheckSUMData_PasswordIC(orderStr: string): string;

  public
    { Public declarations }

    procedure DeleteDataFromTable; //删除测试数据
    function Select_IncValue_Byte(StrIncValue: string): string;
    function Select_CheckSum_Byte(StrCheckSum: string): string;
  end;

var
  frm_IC_SetParameter_DataBaseInit: Tfrm_IC_SetParameter_DataBaseInit;
  CustomerName_check: string; //系统编号
  BossPassword_check: string; //PC托盘特征码
  BossPassword_old_check: string; //PC读出特征码
  BossPassword_3F_check: string; //PC写入特征码
  strtime: string; //设定时间

  Check_Count, Check_Count_3FPASSWORD, Check_Count_USERPASSWORD, Check_Count_3FLOADDATE: integer;
  orderLst, recDataLst, recData_fromICLst, recData_fromICLst_Check: Tstrings;
  LOAD_CHECK_OK_RE, LOAD_3FPASSWORD_OK_RE, LOAD_USERPASSWORD_OK_RE, LOAD_3FLOADDATE_OK_RE: BOOLEAN;
  WriteToFile_OK, WriteToFlase_OK: BOOLEAN;
implementation

uses ICDataModule, ICCommunalVarUnit, ICmain, ICEventTypeUnit, ICFunctionUnit,
  Logon;

{$R *.dfm}

procedure Tfrm_IC_SetParameter_DataBaseInit.btnFactoryInitialClick(Sender: TObject); 
begin
  lblMessage.Caption := '开始出厂初始化';
  DeleteDataFromTable();
  lblMessage.Caption := '出厂初始化完成！';

end;



//删除测试数据

procedure Tfrm_IC_SetParameter_DataBaseInit.DeleteDataFromTable;
var
  ADOQ: TADOQuery;
  strSQL: string;
begin
  lblMessage.Caption := '出厂初始化中...请等待...';
  strSQL := 'delete from TMACHINESET';
  ICFunction.loginfo('strSQL :' + strSQL);
  DataModule_3F.executesql(strSQL);

  strSQL := 'delete from TPOSITIONSET';
  ICFunction.loginfo('strSQL :' + strSQL);
  DataModule_3F.executesql(strSQL);

  strSQL := 'delete from T_BIND_CARDHEADID';
  ICFunction.loginfo('strSQL :' + strSQL);
  DataModule_3F.executesql(strSQL);

  strSQL := 'delete from T_COIN_INITIAL';
  ICFunction.loginfo('strSQL :' + strSQL);
  DataModule_3F.executesql(strSQL);



  strSQL := 'delete from T_COIN_RECHARGE';
  ICFunction.loginfo('strSQL :' + strSQL);
  DataModule_3F.executesql(strSQL);


  strSQL := 'delete from T_COIN_REFUND';
  ICFunction.loginfo('strSQL :' + strSQL);
  DataModule_3F.executesql(strSQL);



  strSQL := 'delete from T_BAR_FLOW';
  ICFunction.loginfo('strSQL :' + strSQL);
  DataModule_3F.executesql(strSQL);


  strSQL := 'delete from T_ACCOUNT_LOG';
  ICFunction.loginfo('strSQL :' + strSQL);
  DataModule_3F.executesql(strSQL);


  strSQL := 'delete from T_COIN_LOG';
  ICFunction.loginfo('strSQL :' + strSQL);
  DataModule_3F.executesql(strSQL);


  strSQL := 'delete from T_MEMBER_ACCOUNT';
  ICFunction.loginfo('strSQL :' + strSQL);
  DataModule_3F.executesql(strSQL);


  strSQL := 'delete from T_MEMBER_CARD_CONFIGURATION';
  ICFunction.loginfo('strSQL :' + strSQL);
  DataModule_3F.executesql(strSQL);


  strSQL := 'delete from T_MEMBER_INFO';
  ICFunction.loginfo('strSQL :' + strSQL);
  DataModule_3F.executesql(strSQL);


  strSQL := 'delete from T_PRESENT_LOG';
  ICFunction.loginfo('strSQL :' + strSQL);
  DataModule_3F.executesql(strSQL);


end;

procedure Tfrm_IC_SetParameter_DataBaseInit.FormShow(Sender: TObject);
begin


  CustomerName_check := '';
  BossPassword_check := '';
  BossPassword_old_check := '';
  BossPassword_3F_check := '';

  recData_fromICLst_Check := TStringList.Create;
  orderLst := TStringList.Create;

  try
    Comm_Check.StartComm()
  except on E: Exception do //拦截所有异常
    begin
      showmessage(SG3FERRORINFO.commerror + e.message);
      exit;
    end;
  end;


end;


procedure Tfrm_IC_SetParameter_DataBaseInit.Comm_CheckReceiveData(
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
  recData_fromICLst_Check.Clear;
  recData_fromICLst_Check.Add(recStr);
    //接收---------------
  begin
    CheckCMD_Right(); //系统启动时判断加密狗
  end;
end;
//根据接收到的数据判断此卡是否为合法卡

procedure Tfrm_IC_SetParameter_DataBaseInit.CheckCMD_Right();
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
//            Timer_HAND.Enabled := FALSE; //关闭检测定时器
//            Timer_USERPASSWORD.Enabled := true; //发送写系统编号指令
            lblMessage.Caption := '握手操作成功';

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
//              Timer_USERPASSWORD.Enabled := false;
//              Timer_3FPASSWORD.Enabled := true;
              lblMessage.Caption := '写入系统编码操作成功';
            end;
            tmpStr := '';
            break;
          end
          else if (content6 = CMD_COUMUNICATION.CMD_3FPASSWORD_RE) then //0x66
          begin

            content5 := copy(tmpStr, 1, i - 3) + '63' + copy(tmpStr, i, 2);

            if (CheckSUMData_PasswordIC(content5) = content3) then
            begin
              LOAD_3FPASSWORD_OK_RE := true;
//              Timer_3FPASSWORD.Enabled := false;
//              Timer_3FLOADDATE.Enabled := true;
              lblMessage.Caption := '写入场地密码操作成功';

            end;
            tmpStr := '';
            break;
          end
          else if (content6 = CMD_COUMUNICATION.CMD_3FLODADATE_RE) then //0x69
          begin


            content5 := copy(tmpStr, 1, i - 3) + '63' + copy(tmpStr, i, 2);
            if (CheckSUMData_PasswordIC(content5) = content3) then
            begin
              LOAD_3FLOADDATE_OK_RE := true;
              WriteToFlase_OK := true;
              lblMessage.Caption := '写入登陆时间操作成功';

              if WriteToFile_OK then
              begin
                if WriteToFlase_OK then
                begin


                  DeleteDataFromTable; //删除所有数据
                  lblMessage.Caption := '出厂数据配置、数据库清除操作成功';
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




//发送握手请求指令

//计算充值指令

function Tfrm_IC_SetParameter_DataBaseInit.Make_Send_CMD_PasswordIC(StrCMD: string; StrIncValue: string): string;
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
    //Edit4.Text:= TmpStr_IncValue;
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

function Tfrm_IC_SetParameter_DataBaseInit.CheckSUMData_PasswordIC(orderStr: string): string;
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
//写入---------------------------------------

procedure Tfrm_IC_SetParameter_DataBaseInit.INcrevalue(S: string);
begin
  orderLst.Clear();
  curOrderNo := 0;
  curOperNo := 1;
  orderLst.Add(S); //将币值写入币种
  sendData();
end;
//发送数据过程

procedure Tfrm_IC_SetParameter_DataBaseInit.sendData();
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

function Tfrm_IC_SetParameter_DataBaseInit.exchData(orderStr: string): string;
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


//充值数据转换成16进制并排序 字节LL、字节LH、字节HL、字节HH

function Tfrm_IC_SetParameter_DataBaseInit.Select_IncValue_Byte(StrIncValue: string): string;
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

function Tfrm_IC_SetParameter_DataBaseInit.Select_CheckSum_Byte(StrCheckSum: string): string;
var
  jj: integer;
  tempLH, tempLL: integer; //2147483648 最大范围

begin
  jj := strToint('$' + StrCheckSum); //将字符转转换为16进制数，然后转换位10进制
  tempLH := (jj mod 65536) div 256; //字节LH
  tempLL := jj mod 256; //字节LL

  result := IntToHex(tempLL, 2) + IntToHex(tempLH, 2);
end;


 //根据接收到的数据判断相应情况
procedure Tfrm_IC_SetParameter_DataBaseInit.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  orderLst.Free();
  recData_fromICLst_Check.Free();
  Comm_Check.StopComm();
end;

procedure Tfrm_IC_SetParameter_DataBaseInit.Bit_CloseClick(
  Sender: TObject);
begin
  close;
end;



procedure Tfrm_IC_SetParameter_DataBaseInit.btnClearCoinRechargeClick(
  Sender: TObject);
var
  strSQL : string;
begin
 lblMessage.Caption := '开始清除充值记录';

  strSQL := 'delete from T_COIN_RECHARGE';
  ICFunction.loginfo('strSQL :' + strSQL);
  DataModule_3F.executesql(strSQL);

  lblMessage.Caption := '清除充值记录完成！';
end;

procedure Tfrm_IC_SetParameter_DataBaseInit.btnClearBarFlowClick(
  Sender: TObject);
var
  strSQL : string;
begin
    lblMessage.Caption := '开始清除兑换记录！';
  strSQL := 'delete from T_BAR_FLOW ';
  ICFunction.loginfo('strSQL :' + strSQL);
  DataModule_3F.executesql(strSQL);
    lblMessage.Caption := '完成清除兑换记录！';
end;

procedure Tfrm_IC_SetParameter_DataBaseInit.btnClearCoinRefundClick(
  Sender: TObject);
var
  strSQL : string;
begin
  lblMessage.Caption := '完成清除退币记录！';
  strSQL := 'delete from T_COIN_REFUND';
  ICFunction.loginfo('strSQL :' + strSQL);
  DataModule_3F.executesql(strSQL);
  lblMessage.Caption := '完成清除退币记录！';
end;

end.

