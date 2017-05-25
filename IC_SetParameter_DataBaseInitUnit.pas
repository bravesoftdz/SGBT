unit IC_SetParameter_DataBaseInitUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, IniFiles,
  Dialogs, DB, ADODB, StdCtrls, Buttons, ExtCtrls, SPComm;

type
  Tfrm_IC_SetParameter_DataBaseInit = class(TForm)
    Panel1: TPanel;
    GroupBox5: TGroupBox;
    Bit_Add: TBitBtn;
    Bit_Close: TBitBtn;
    ADOQuery_newCustomer: TADOQuery;
    DataSource_Newmenber: TDataSource;
    Label2: TLabel;
    Comb_Customer_Name: TComboBox;
    Label8: TLabel;
    edtCusotmerPasswd: TEdit;
    Comm_Check: TComm;
    Timer_HAND: TTimer;
    Timer_USERPASSWORD: TTimer;
    Timer_3FPASSWORD: TTimer;
    lblMessage: TPanel;
    Timer_3FLOADDATE: TTimer;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    procedure Bit_AddClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Comm_CheckReceiveData(Sender: TObject; Buffer: Pointer;
      BufferLength: Word);
    procedure Timer_HANDTimer(Sender: TObject);
    procedure Timer_USERPASSWORDTimer(Sender: TObject);
    procedure Timer_3FPASSWORDTimer(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Bit_CloseClick(Sender: TObject);
    procedure Comb_Customer_NameClick(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure Timer_3FLOADDATETimer(Sender: TObject);
  private
    { Private declarations }

    procedure CheckCMD_Right(); //系统主机权限判断，确认是否与加密狗唯一对应
    procedure INcrevalue(S: string); //充值函数
    procedure sendData();
        //发送握手请求指令
    procedure SendCMD_HAND;
    function exchData(orderStr: string): string;
    //发送读取场地密码请求指令
    procedure SendCMD_USERPASSWORD;
    procedure SendCMD_3FPASSWORD; //发送3F出厂密码（系统编号）确认请求指令
    procedure SendCMD_3FLOADDATE; //写入登陆日期
    function Check_CustomerName(str1: string; str2: string): Boolean;
    function Check_CustomerNO(str1: string; str2: string): Boolean;
    function Make_Send_CMD_PasswordIC(StrCMD: string; StrIncValue: string): string;
    function CheckSUMData_PasswordIC(orderStr: string): string;
    procedure QueryCustomerNo(str1: string);
  public
    { Public declarations }
    procedure InitCombo_MCname; //初始化客户编号下来框
    procedure DeleteTestDataFromTable; //删除测试数据
    procedure WriteCustomerNameToIniFile; //写入出厂客户编号 、场地密码给配置文件
    procedure WriteCustomerNameToFlash; //写入出厂客户编号 、场地密码给加密卡，通过串口实现

    procedure SaveData_CustomerInfor; //保存、更新出厂记录
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

procedure Tfrm_IC_SetParameter_DataBaseInit.Bit_AddClick(Sender: TObject);

begin
  strtime := FormatDateTime('HH:mm:ss', now);

  if length(edtCusotmerPasswd.Text) = 0 then
  begin
    lblMessage.Caption := '出厂场地密码不能为空！';
    exit;
  end
  else
  begin


    if (MessageDlg('请安装连接加密卡，确认需要出厂数据库、配置文件初始化操作吗？', mtInformation, [mbYes, mbNo], 0) = mrYes) then
    begin

      WriteCustomerNameToIniFile; //写入出厂客户编号、场地密码给配置文档

      if WriteToFile_OK then
      begin

        WriteCustomerNameToFlash; //写入出厂客户编号 、场地密码给加密卡，通过串口实现
                         //DeleteTestDataFromTable;//删除测试数据(在串口处理事件中执行，等待写入加密成功结束)
                         //SaveData_CustomerInfor; //保存、更新出厂记录(在串口处理事件中执行，等待写入加密成功结束)
      end;


    end
    else
    begin
      exit;
    end;
  end;


end;
//删除测试数据

procedure Tfrm_IC_SetParameter_DataBaseInit.DeleteTestDataFromTable;
var
  ADOQ: TADOQuery;
  strSQL: string;
begin
//1、首先清除客户表[3F_Customer_Infor]

  strSQL := 'delete  from '
    + ' [3F_Customer_Infor] where Customer_Name<>''' + TrimRight(Comb_Customer_Name.Text) + '''';

  ADOQ := TADOQuery.Create(nil);
  with ADOQ do begin
    Connection := DataModule_3F.ADOConnection_Main;
    ADOQ.Active := false;
    SQL.Clear;
    SQL.Add(strSQL);
    ADOQ.ExecSQL;
  end;
  FreeAndNil(ADOQ);

//2、首先清除场地初始化表[USER_ID_INIT]
{
  strSQL:='delete  from '
  +' [USER_ID_INIT]';

  ADOQ:=TADOQuery.Create(nil);
  with ADOQ do begin
    Connection := DataModule_3F.ADOConnection_Main;
    ADOQ.Active:=false;
    SQL.Clear;
    SQL.Add(strSQL);
    ADOQ.ExecSQL;
    end;
  FreeAndNil(ADOQ);
}
//3、首先清除游戏名称表[TGameSet]
  strSQL := 'delete  from '
    + ' [TGameSet]';

  ADOQ := TADOQuery.Create(nil);
  with ADOQ do begin
    Connection := DataModule_3F.ADOConnection_Main;
    ADOQ.Active := false;
    SQL.Clear;
    SQL.Add(strSQL);
    ADOQ.ExecSQL;
  end;
  FreeAndNil(ADOQ);


 //4、首先清除游戏名称表[TChargMacSet]
  strSQL := 'delete  from '
    + ' [TChargMacSet]';

  ADOQ := TADOQuery.Create(nil);
  with ADOQ do begin
    Connection := DataModule_3F.ADOConnection_Main;
    ADOQ.Active := false;
    SQL.Clear;
    SQL.Add(strSQL);
    ADOQ.ExecSQL;
  end;
  FreeAndNil(ADOQ);

  //5、首先清除交班记录表[TClassChangeInfor]
  strSQL := 'delete  from '
    + ' [TClassChangeInfor]';

  ADOQ := TADOQuery.Create(nil);
  with ADOQ do begin
    Connection := DataModule_3F.ADOConnection_Main;
    ADOQ.Active := false;
    SQL.Clear;
    SQL.Add(strSQL);
    ADOQ.ExecSQL;
  end;
  FreeAndNil(ADOQ);

    //6、首先清除卡头ID初始化表[TCardHead_Init]
  strSQL := 'delete  from '
    + ' [TCardHead_Init]';

  ADOQ := TADOQuery.Create(nil);
  with ADOQ do begin
    Connection := DataModule_3F.ADOConnection_Main;
    ADOQ.Active := false;
    SQL.Clear;
    SQL.Add(strSQL);
    ADOQ.ExecSQL;
  end;
  FreeAndNil(ADOQ);

  //7、首先清除充值记录表[EBdetail]
  strSQL := 'delete  from '
    + ' [EBdetail]';

  ADOQ := TADOQuery.Create(nil);
  with ADOQ do begin
    Connection := DataModule_3F.ADOConnection_Main;
    ADOQ.Active := false;
    SQL.Clear;
    SQL.Add(strSQL);
    ADOQ.ExecSQL;
  end;
  FreeAndNil(ADOQ);

    //8、首先清除扫描兑换表[3F_BARFLOW]
  strSQL := 'delete  from '
    + ' [3F_BARFLOW]';

  ADOQ := TADOQuery.Create(nil);
  with ADOQ do begin
    Connection := DataModule_3F.ADOConnection_Main;
    ADOQ.Active := false;
    SQL.Clear;
    SQL.Add(strSQL);
    ADOQ.ExecSQL;
  end;
  FreeAndNil(ADOQ);

  //9、首先清除扫描兑换表[3F_ID_INIT]
  strSQL := 'delete  from '
    + ' [3F_ID_INIT]';

  ADOQ := TADOQuery.Create(nil);
  with ADOQ do begin
    Connection := DataModule_3F.ADOConnection_Main;
    ADOQ.Active := false;
    SQL.Clear;
    SQL.Add(strSQL);
    ADOQ.ExecSQL;
  end;
  FreeAndNil(ADOQ);

  //10、首先清除用户表[3F_SysUser]，只保留编号为000001

  strSQL := 'delete  from '
    + ' [3F_SysUser] Where UserNo<>''000001''';

  ADOQ := TADOQuery.Create(nil);
  with ADOQ do begin
    Connection := DataModule_3F.ADOConnection_Main;
    ADOQ.Active := false;
    SQL.Clear;
    SQL.Add(strSQL);
    ADOQ.ExecSQL;
  end;
  FreeAndNil(ADOQ);

    //11、首先清除用户表[3F_RIGHT_SET]，只保留编号为000001

  strSQL := 'delete  from '
    + ' [3F_RIGHT_SET] Where UserNo<>''000001''';

  ADOQ := TADOQuery.Create(nil);
  with ADOQ do begin
    Connection := DataModule_3F.ADOConnection_Main;
    ADOQ.Active := false;
    SQL.Clear;
    SQL.Add(strSQL);
    ADOQ.ExecSQL;
  end;
  FreeAndNil(ADOQ);

      //12、首先清除用户充值表[TMembeDetail]，

  strSQL := 'delete  from '
    + ' [TMembeDetail]';

  ADOQ := TADOQuery.Create(nil);
  with ADOQ do begin
    Connection := DataModule_3F.ADOConnection_Main;
    ADOQ.Active := false;
    SQL.Clear;
    SQL.Add(strSQL);
    ADOQ.ExecSQL;
  end;
  FreeAndNil(ADOQ);

        //13、首先清除用会员表[TMemberInfo]，

  strSQL := 'delete  from '
    + ' [TMemberInfo]';

  ADOQ := TADOQuery.Create(nil);
  with ADOQ do begin
    Connection := DataModule_3F.ADOConnection_Main;
    ADOQ.Active := false;
    SQL.Clear;
    SQL.Add(strSQL);
    ADOQ.ExecSQL;
  end;
  FreeAndNil(ADOQ);




  strSQL := 'delete  from  [T_3F_INITIALRECORD]';
  ICFunction.loginfo('database Initial  ' + strSQL);
  DataModule_3F.executesql(strSQL);



end;

//更新配置文件，写入出厂客户编号、场地密码给配置文件

procedure Tfrm_IC_SetParameter_DataBaseInit.WriteCustomerNameToIniFile;
var
  myIni: TiniFile;

  System_No: string; //系统编号
  BossPassword: string; //用户场地密码
  LOADDATE: string; //用户场地密码
begin

   //判断计算得到的密码是否与原来保留的一致
  System_No := Comb_Customer_Name.Text; //系统编号
  BossPassword := edtCusotmerPasswd.Text; //场地密码
  LOADDATE := COPY(strtime, 1, 1) + COPY(strtime, 5, 1) + COPY(strtime, 2, 1) + COPY(strtime, 4, 1); //设定时间
  if FileExists(SystemWorkGroundFile) then
  begin
    myIni := TIniFile.Create(SystemWorkGroundFile);

    myIni.WriteString('PLC工作区域', 'PC客户编号', System_No); //写入客户编号
    myIni.WriteString('PLC工作区域', 'PC写入特征码', BossPassword); //写入旧密码中转值
    myIni.WriteString('PLC工作区域', 'PC读出特征码', BossPassword); //写入新密码
    myIni.WriteString('PLC工作区域', 'PC托盘特征码', BossPassword); //写入新密码
    myIni.WriteString('卡出厂设置', '设定时间', LOADDATE); //写入新密码

    CustomerName_check := MyIni.ReadString('PLC工作区域', 'PC客户编号', 'D60993'); //
    BossPassword_check := MyIni.ReadString('PLC工作区域', 'PC托盘特征码', 'D60993'); //
    BossPassword_old_check := MyIni.ReadString('PLC工作区域', 'PC读出特征码', 'D60993'); //
    BossPassword_3F_check := MyIni.ReadString('PLC工作区域', 'PC写入特征码', 'D60993'); //读取最后使用的密码（即场地密码）

    INit_Wright.BossPassword := BossPassword_3F_check; //更新系统使用的场地密码

    FreeAndNil(myIni);

    if CustomerName_check = System_No then
    begin
      if (BossPassword = BossPassword_old_check) and (BossPassword_check = BossPassword_old_check) and (BossPassword_old_check = BossPassword_3F_check) then
      begin
        WriteToFile_OK := true;
        lblMessage.Caption := '全部写入配置文档成功';
      end
      else
      begin
        lblMessage.Caption := '场地密码写入配置文档错误';
        exit;
      end;
    end
    else
    begin
      lblMessage.Caption := '系统编号写入配置文档错误';
      exit;

    end;

  end;

end;

//更新配置文件，写入出厂客户编号、场地密码给加密卡

procedure Tfrm_IC_SetParameter_DataBaseInit.WriteCustomerNameToFlash;
var
  System_No: string; //系统编号
  BossPassword: string; //用户场地密码
begin
  Timer_HAND.Enabled := true; //开始检测加密狗握手定时器

          //CustomerName_check:= MyIni.ReadString('PLC工作区域','PC客户编号','D60993');//
          //BossPassword_check:= MyIni.ReadString('PLC工作区域','PC托盘特征码','D60993');//
          //BossPassword_old_check:= MyIni.ReadString('PLC工作区域','PC读出特征码','D60993');//
          //BossPassword_3F_check:= MyIni.ReadString('PLC工作区域','PC写入特征码','D60993');//读取最后使用的密码（即场地密码）

end;

//保存当前记录

procedure Tfrm_IC_SetParameter_DataBaseInit.SaveData_CustomerInfor;
var
  strSQL: string;
  str1: string;
  strTemp: string;
begin
  strTemp := Comb_Customer_Name.Text;
  strSQL := 'select * from [t_customer_info] where Customer_Name=''' + strTemp + '''';
  with ADOQuery_newCustomer do begin
    Connection := DataModule_3F.ADOConnection_Main;
    Active := false;
    SQL.Clear;
    SQL.Add(strSQL);
    Active := true;
    Edit;
    FieldByName('operatetime').AsString := FormatDateTime('yyyy-MM-dd HH:mm:ss', now); //打票时间 (需要处理)
    Post;
    Active := False;
  end;
end;

procedure Tfrm_IC_SetParameter_DataBaseInit.FormShow(Sender: TObject);
begin


  CustomerName_check := '';
  BossPassword_check := '';
  BossPassword_old_check := '';
  BossPassword_3F_check := '';

  recData_fromICLst_Check := TStringList.Create;
  orderLst := TStringList.Create;


  InitCombo_MCname; //初始化下客户编号下拉框

//  Comm_Check.StartComm(); //开启加密狗串口确认

  try
    Comm_Check.StartComm()
  except on E: Exception do //拦截所有异常
    begin
      showmessage(SG3FERRORINFO.commerror + e.message);
      exit;
    end;
  end;


end;


procedure Tfrm_IC_SetParameter_DataBaseInit.InitCombo_MCname; //初始化游戏名称下来框
var
  ADOQTemp: TADOQuery;
  strSQL: string;
  nameStr, strtemp: string;
  i: integer;
begin
  Comb_Customer_Name.Items.Clear;
  strtemp := '0';
  ADOQTemp := TADOQuery.Create(nil);

  strSQL := 'select distinct customer_no from t_customer_info';
  ICFunction.loginfo('strSQL :' + strSQL);
  with ADOQTemp do
  begin
    Connection := DataModule_3F.ADOConnection_Main;
    SQL.Clear;
    SQL.Add(strSQL);
    Active := True;
    Comb_Customer_Name.Items.Clear;
    while not Eof do
    begin
      Comb_Customer_Name.Items.Add(FieldByName('customer_no').AsString);
      Next;
    end;
  end;
  FreeAndNil(ADOQTemp);
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
            Timer_HAND.Enabled := FALSE; //关闭检测定时器
            Timer_USERPASSWORD.Enabled := true; //发送写系统编号指令
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
              Timer_USERPASSWORD.Enabled := false;
              Timer_3FPASSWORD.Enabled := true;
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
              Timer_3FPASSWORD.Enabled := false;
              Timer_3FLOADDATE.Enabled := true;
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

                  SaveData_CustomerInfor; //保存、更新出厂记录
                  DeleteTestDataFromTable; //删除测试数据
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

procedure Tfrm_IC_SetParameter_DataBaseInit.Timer_HANDTimer(Sender: TObject);

begin
  Check_Count := Check_Count + 1;
  if not LOAD_CHECK_OK_RE then //握手未成功
  begin

    SendCMD_HAND; //发送握手指令


    if Check_Count = 4 then //定时秒
    begin
      LOAD_CHECK_OK_RE := false;
      Timer_HAND.Enabled := FALSE; //关闭定时器
      Check_Count := 0;
    end;
  end
  else
  begin

    Timer_HAND.Enabled := FALSE; //关闭定时器
    Check_Count := 0
  end;

end;



procedure Tfrm_IC_SetParameter_DataBaseInit.Timer_USERPASSWORDTimer(Sender: TObject);
begin
  Check_Count_USERPASSWORD := Check_Count_USERPASSWORD + 1;
  if not LOAD_USERPASSWORD_OK_RE then //握手未成功
  begin
    SendCMD_USERPASSWORD; //发送读取场地密码请求指令
    if Check_Count_USERPASSWORD = 4 then //定时秒
    begin
      LOAD_USERPASSWORD_OK_RE := false;
      Timer_USERPASSWORD.Enabled := FALSE; //关闭定时器
      Check_Count_USERPASSWORD := 0;
    end;
  end
  else
  begin
    Timer_USERPASSWORD.Enabled := FALSE; //关闭定时器
    Check_Count_USERPASSWORD := 0;
  end;
end;

procedure Tfrm_IC_SetParameter_DataBaseInit.Timer_3FPASSWORDTimer(Sender: TObject);
begin

  Check_Count_3FPASSWORD := Check_Count_3FPASSWORD + 1;
  if not LOAD_3FPASSWORD_OK_RE then //握手未成功
  begin
    SendCMD_3FPASSWORD; //发送握手指令
    if Check_Count_3FPASSWORD = 4 then //定时秒
    begin
      LOAD_3FPASSWORD_OK_RE := false;
      Timer_3FPASSWORD.Enabled := FALSE; //关闭定时器
      Check_Count_3FPASSWORD := 0;
    end;
  end
  else
  begin
    Timer_3FPASSWORD.Enabled := FALSE; //关闭定时器
    Check_Count_3FPASSWORD := 0;
  end;

end;



procedure Tfrm_IC_SetParameter_DataBaseInit.Timer_3FLOADDATETimer(
  Sender: TObject);
begin
  Check_Count_3FLOADDATE := Check_Count_3FLOADDATE + 1;
  if not LOAD_3FLOADDATE_OK_RE then //握手未成功
  begin

    SendCMD_3FLOADDATE; //发送握手指令
    if Check_Count_3FLOADDATE = 4 then //定时秒
    begin
      LOAD_3FLOADDATE_OK_RE := false;
      Timer_3FLOADDATE.Enabled := FALSE; //关闭定时器
      Check_Count_3FLOADDATE := 0;
    end;
  end
  else
  begin

    Timer_3FLOADDATE.Enabled := FALSE; //关闭定时器
    Check_Count_3FLOADDATE := 0;
  end;

end;



//发送握手请求指令

procedure Tfrm_IC_SetParameter_DataBaseInit.SendCMD_HAND;
var
  INC_value: string;
  strValue: string;
begin
  begin
    INC_value := '0'; //充值数值
    strValue := '50613C6D03'; //握手请求指令50 61 3C 6D 03/回应43 61 3E 7C 03
    INcrevalue(strValue); //写入ID卡

  end;


end;
//发送写入（系统编号）请求指令

procedure Tfrm_IC_SetParameter_DataBaseInit.SendCMD_USERPASSWORD;
var
  strValue, INC_value: string;
begin

  INC_value := '0000' + Comb_Customer_Name.Text + '0'; //系统编号
  Operate_No := 1;
  strValue := Make_Send_CMD_PasswordIC('506801', INC_value); //计算充值指令

  INcrevalue(strValue);
end;

//发送写入场地密码请求指令

procedure Tfrm_IC_SetParameter_DataBaseInit.SendCMD_3FPASSWORD;
var
  strValue, INC_value: string;
begin
  INC_value := '1FE3C4' + 'AFBD3F' + edtCusotmerPasswd.Text + '0'; //场地密码
  Operate_No := 1;
  strValue := Make_Send_CMD_PasswordIC('5066', INC_value); //计算充值指令
  INcrevalue(strValue);
end;

//发送//写入登陆日期

procedure Tfrm_IC_SetParameter_DataBaseInit.SendCMD_3FLOADDATE;
var
  strValue, INC_value: string;
begin


  INC_value := COPY(strtime, 1, 1) + COPY(strtime, 5, 1) + COPY(strtime, 2, 1) + COPY(strtime, 4, 1) + COPY(strtime, 7, 1); //INit_3F.ID_Settime,4个字节（小时+分钟）写最后一次登陆系统时间50 69 00 00 00 00 59 03
         //Edit3.Text:= INC_value;
  Operate_No := 1;
  strValue := Make_Send_CMD_PasswordIC('5069', INC_value); //计算充值指令

  INcrevalue(strValue);
end;



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

function Tfrm_IC_SetParameter_DataBaseInit.Check_CustomerName(str1: string; str2: string): Boolean;
begin

  if (Copy(str1, 5, 6) = str2) then
  begin
    result := true;
  end
  else
  begin
    result := false;
  end
end;
 //根据接收到的数据判断相应情况

function Tfrm_IC_SetParameter_DataBaseInit.Check_CustomerNO(str1: string; str2: string): Boolean;
begin

  if (Copy(str1, 5, 11) = str2) then
  begin
    result := true;
  end
  else
  begin
    result := false;
  end
end;

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

procedure Tfrm_IC_SetParameter_DataBaseInit.Comb_Customer_NameClick(
  Sender: TObject);
begin
  if (Comb_Customer_Name.Text = '请点击选择') then
  begin
    lblMessage.Caption := '请选择场地编号';
    exit;
  end
  else
  begin
    if (length(Comb_Customer_Name.Text) <> 12) then
    begin
      lblMessage.Caption := '请输入正确的场地编号';
      exit;
    end
    else
    begin
      QueryCustomerNo(Comb_Customer_Name.text);
    end;
  end;

end;


 //查询当前客户的当前场地共有多少台卡头

procedure Tfrm_IC_SetParameter_DataBaseInit.QueryCustomerNo(str1: string);
var
  ADOQTemp: TADOQuery;
  strSQL: string;
  strSET: string;
begin
  edtCusotmerPasswd.Text := str1;
{
  ADOQTemp := TADOQuery.Create(nil);
  strSQL := 'select Customer_NO from [3F_Customer_Infor] where Customer_Name=''' + str1 + '''';

  with ADOQTemp do begin
    Connection := DataModule_3F.ADOConnection_Main;
    SQL.Clear;
    SQL.Add(strSQL);
    Active := True;
    while not Eof do begin
      Edit_Customer_NO.Text := TrimRight(ADOQTemp.Fields[0].AsString);
      Next;
    end;
  end;
  FreeAndNil(ADOQTemp);
  }
end;

procedure Tfrm_IC_SetParameter_DataBaseInit.BitBtn1Click(Sender: TObject);
var
  strValue, INC_value: string;
begin
  INC_value := '00000' + '3F2013000001'; //系统编号
  Operate_No := 1;
  strValue := Make_Send_CMD_PasswordIC('506801', INC_value); //计算充值指令

  INcrevalue(strValue);

end;

procedure Tfrm_IC_SetParameter_DataBaseInit.BitBtn2Click(Sender: TObject);
begin
  Timer_3FPASSWORD.Enabled := true; //发送写系统编号指令
end;

procedure Tfrm_IC_SetParameter_DataBaseInit.BitBtn3Click(Sender: TObject);
begin
  Timer_HAND.Enabled := true;
end;




end.

