unit untInitialCoin;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, SPComm, DB, ADODB, Grids, DBGrids;

type
  TfrmInitial = class(TForm)
    Panel1: TPanel;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    GroupBox3: TGroupBox;
    Label1: TLabel;
    edtShopID: TEdit;
    Label2: TLabel;
    cbCoinType: TComboBox;
    btnInitial: TButton;
    btnExit: TButton;
    dgInitial: TDBGrid;
    ADOQueryInitial: TADOQuery;
    dsInitial: TDataSource;
    commInitial: TComm;
    lblMessage: TLabel;
    edtBandID: TEdit;
    Label3: TLabel;
    memo1: TMemo;
    procedure commInitialReceiveData(Sender: TObject; Buffer: Pointer;
      BufferLength: Word);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnInitialClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }

        //数据库相关
    function initCoinRecord():string;
    procedure saveInitialRecord(); //保存充值记录
        //卡头处理函数
    procedure checkCMDInfo();
    procedure initIncrOperation(strRechargeCoin :string ); //充值操作，写数据个卡
    function  caluSendCMD(strCMD: string; strIncrValue: string): string;
    procedure generateIncrValueCMD(S: string);
    procedure prcSendDataToCard();
    procedure showUserCardOperation();
    procedure prcCardIncrValueReturn();
    procedure prcCardReadValueReturn();
    function  checkSUMData(orderStr: string): string;
    function  Display_ID_TYPE_Value(StrIDtype: string): string;
    procedure initComboxCardtype;
  end;

var
  frmInitial: TfrmInitial;
  curOrderNo: integer = 0;  //???
  curOperNo: integer = 0;
  Operate_No: integer = 0;   //什么作用?标记正在充值？
  orderLst, recDataLst: Tstrings;  //定义全局变量发送数据，接收数据
  ID_UserCard_Text: string;
  IncValue_Enable: boolean;  //是否允许充值的标志,会员卡认证通过后置为True
  buffer: array[0..2048] of byte;
  ID_System: string;
  Password3F_System: string;

implementation
uses ICDataModule, ICCommunalVarUnit, ICmain, ICEventTypeUnit, ICFunctionUnit,dateProcess;
{$R *.dfm}


function TfrmInitial.initCoinRecord():string;
var
  strSQL: string;
begin
  with ADOQueryInitial do begin
    Connection := DataModule_3F.ADOConnection_Main;
    Active := false;
    SQL.Clear;
    strSQL := 'select coinid,id_3f,password_3f,password_user,id_type,id_value,operatorno,operatetime from t_id_init';
    SQL.Add(strSQL);
    Active := True;
  end;
  result := '1';
end;


procedure TfrmInitial.saveInitialRecord(); //保存充值记录
var
 strID3F, strBandid, strShopID,  strIDType, strOperateTime, strOperatorNO,strSG3FPassword,strIDTypeName,strCoin,strsql: string;
begin

    strBandid :=trim(edtBandID.Text);
    strID3F := '3f3f3f';
    strSG3FPassword := '3f3f3f';
    strShopID :=trim(edtShopID.Text);
    strIDType :=cbCoinType.Text; //01表示现金,02表示在线
    strIDTypeName := '用户卡';
    strCoin :='0';
    //指定日期格式 重要
    ShortDateFormat := 'yyyy-MM-dd';  //指定格式即可
    DateSeparator := '-';
    //指定日期格式 否则会报is not an valid date and time;
    strOperatorNO :='001';
    strOperateTime := FormatDateTime('yyyy-MM-dd HH:mm:ss', now);


    with ADOQueryInitial do begin
        Connection := DataModule_3F.ADOConnection_Main;
        Active := false;
        SQL.Clear;
        strSQL := 'select coinid,id_3f,password_3f,password_user,id_type,id_typename,id_value,operatorno,operatetime from t_id_init order by operatetime desc'; //为什么要查全部？
        SQL.Add(strSQL);
        Active := True;  
      Append;
      FieldByName('coinid').AsString := strBandid;
      FieldByName('id_3f').AsString := strID3F;
      FieldByName('password_3f').AsString := strSG3FPassword;
      FieldByName('password_user').AsString := strShopID;
      FieldByName('id_type').AsString := strIDType;
      FieldByName('id_typename').AsString := strIDTypeName;
      FieldByName('id_value').AsString := strCoin;
      FieldByName('operatorno').AsString := strOperatorNo;
      FieldByName('operatetime').AsString := strOperatetime;
      post;
      end;
      
end;

procedure TfrmInitial.checkCMDInfo();
var
  tmpStr: string;
begin
   //首先截取接收的信息

  tmpStr := recDataLst.Strings[0];
  ICCommunalVarUnit.Receive_CMD_ID_Infor.ID_CheckNum := copy(tmpStr, 39, 4); //校验和
  ICCommunalVarUnit.CMD_CheckSum_OK := true;
  ICCommunalVarUnit.Receive_CMD_ID_Infor.CMD := copy(recDataLst.Strings[0], 1, 2); //帧头43

  if ICCommunalVarUnit.Receive_CMD_ID_Infor.CMD =CMD_COUMUNICATION.CMD_READ then //收到卡头写入电子币充值成功的返回 53
    begin
      prcCardReadValueReturn();
    end
  else if Receive_CMD_ID_Infor.CMD =  ICCommunalVarUnit.CMD_COUMUNICATION.CMD_INCValue_RE then  //读指令
    begin
       prcCardIncrValueReturn();
    end;
end;


//卡头返回充值成功指令
procedure TfrmInitial.prcCardIncrValueReturn();
begin
      if Receive_CMD_ID_Infor.ID_type = copy(INit_Wright.User, 8, 2) then  //开机卡也可以充值/但不记录
       begin
        saveInitialRecord(); //保存充值记录
        lblMessage.Caption := '用户卡初始化成功';
        initCoinRecord();
      end;
end;


//卡头返回信息读取指令
procedure TfrmInitial.prcCardReadValueReturn();
begin
    Receive_CMD_ID_Infor.ID_INIT := copy(recDataLst.Strings[0], 3, 8); //卡片ID
    Receive_CMD_ID_Infor.ID_3F := copy(recDataLst.Strings[0], 11, 6); //卡厂ID
    Receive_CMD_ID_Infor.Password_3F := copy(recDataLst.Strings[0], 17, 6); //卡密
    Receive_CMD_ID_Infor.Password_USER := copy(recDataLst.Strings[0], 23, 6); //用户密码
    Receive_CMD_ID_Infor.ID_value := copy(recDataLst.Strings[0], 29, 8); //卡内数据
    Receive_CMD_ID_Infor.ID_type := copy(recDataLst.Strings[0], 37, 2); //卡功能

    writeln('ID_INIT'+Receive_CMD_ID_Infor.ID_INIT);
    writeln('ID_3F'+Receive_CMD_ID_Infor.ID_3F);
    writeln('Password_3F'+Receive_CMD_ID_Infor.Password_3F);
    writeln('Password_USER'+Receive_CMD_ID_Infor.Password_USER);
    writeln('ID_value' + Receive_CMD_ID_Infor.ID_value);
    writeln('ID_type '+Receive_CMD_ID_Infor.ID_type);

    //本场地卡检查 -----开始
                                   //场地初始化检查 -----开始
          if DataModule_3F.Query_User_INIT_OK(Receive_CMD_ID_Infor.ID_INIT) = false then //有记录
          begin
            lblMessage.Caption := '请先初始化！';
            exit;
          end
          else
          begin 
              if Receive_CMD_ID_Infor.ID_type = copy(INit_Wright.User, 8, 2) then
              begin //用户卡 -----开始
                    showUserCardOperation();
                    
              end //用户卡结束
              else if Receive_CMD_ID_Infor.ID_type = copy(INit_Wright.OPERN, 8, 2) then
              begin //开机卡 -----开始
                  lblMessage.Caption := '此用户币合法（开机卡），请继续操作！';
              end
          end;

end;


//卡功能下拉列表实始化
procedure TfrmInitial.initComboxCardtype;
begin
  cbCoinType.Items.Add(copy(INit_Wright.User, 1, 6));
  cbCoinType.Items.Add(copy(INit_Wright.OPERN, 1, 6));
end;



//用户卡信息展示
procedure TfrmInitial.showUserCardOperation();
begin
    edtBandID.Text := Receive_CMD_ID_Infor.ID_INIT; //用户币ID
    memo1.Text := Receive_CMD_ID_Infor.Password_USER;//shopid
//    edtShopID.Text := '0';//shopid

    lblMessage.Caption := '此用户币合法，请继续操作！'; //卡ID

end;//end prc_user_card_operation


procedure TfrmInitial.initIncrOperation(strRechargeCoin :string );
var
  strValue: string;
begin
    strValue := caluSendCMD(CMD_COUMUNICATION.CMD_INCValue, strRechargeCoin); //计算充值指令
    generateIncrValueCMD(strValue); //把充值指令写入ID卡
end;
//充值函数

//生成充值的操作指令
procedure TfrmInitial.generateIncrValueCMD(S: string);
begin
  orderLst.Clear();
  recDataLst.Clear();
  curOrderNo := 0;
  curOperNo := 2;
  orderLst.Add(S); //将充值指令写入缓冲
  prcSendDataToCard();//写入卡头　
end;

//计算充值指令
function TfrmInitial.caluSendCMD(strCMD: string; strIncrValue: string): string;
var
  TmpStr_IncValue: string; //充值数字
  TmpStr_CheckSum: string; //校验和
  TmpStr_SendCMD: string; //指令内容
  reTmpStr: string;
begin

  INit_3F.CMD := StrCMD; //帧命令
  INit_3F.ID_INIT := edtBandID.Text; //币ID

    //Password3F_System 、ID_System这两个变量在输入完毕用户编号回车时执行生成的
  ID_System := ICFunction.SUANFA_ID_3F(edtBandID.Text); //调用计算ID_3F算法
  Password3F_System := ICFunction.SUANFA_Password_3F(edtBandID.Text); //调用计算Password_3F算法

  INit_3F.ID_3F := copy(Password3F_System, 5, 2) + copy(ID_System, 1, 2) + copy(Password3F_System, 3, 2);
  //ID_3F.Text := INit_3F.ID_3F;

  INit_3F.Password_3F := INit_Wright.BossPassword; //直接读取配置文件中的场地密码 (PC托盘特征码)
//  ID_Password_3F.Text := INit_3F.Password_3F; //用户场地密码，保存在文档里面

  //ID_Password_USER.Text := INit_Wright.BossPassword; //直接读取配置文件中的场地密码  (PC托盘特征码)
  INit_3F.Password_USER := edtShopID.Text; //用户场地密码，保存在文档里面  (PC托盘特征码)

  TmpStr_IncValue := COPY(INit_3F.ID_3F, 3, 2) + ICFunction.SUANFA_Password_USER_WritetoID(INit_3F.ID_3F, edtBandID.Text);
  INit_3F.ID_value := TmpStr_IncValue;


  INit_3F.ID_type := Display_ID_TYPE_Value(cbCoinType.Text); //取得卡类型的值
//  Edit20.Text := ID_Password_USER.Text;
    //汇总发送内容
  TmpStr_SendCMD := INit_3F.CMD + INit_3F.ID_INIT + INit_3F.ID_3F + INit_3F.Password_3F + INit_3F.Password_USER + INit_3F.ID_value + INit_3F.ID_type;
   //TmpStr_SendCMD:=指令帧头+ 币ID+ 3F出厂ID + 3F出厂密码+   用户场地密码  +   3F出厂初始币值  + 3F出厂初始币类型

    //将发送内容进行校核计算
  TmpStr_CheckSum := CheckSUMData(TmpStr_SendCMD);
    //TmpStr_CheckSum字节需要重新排布 ，低字节在前，高字节在后
  INit_3F.ID_CheckNum := ICFunction.transferCheckSumByte(TmpStr_CheckSum);
  //ID_CheckSum.Text := ICFunction.transferCheckSumByte(TmpStr_CheckSum);
  reTmpStr := TmpStr_SendCMD + INit_3F.ID_CheckNum;

  result := reTmpStr;
end;



function TfrmInitial.Display_ID_TYPE_Value(StrIDtype: string): string;
begin
  if (StrIDtype = copy(INit_Wright.User, 1, 6)) then //卡功能，类型   //用户卡
    result := copy(INit_Wright.User, 8, 2)
  else if (StrIDtype = copy(INit_Wright.OPERN, 1, 6)) then //开机卡
    result := copy(INit_Wright.OPERN, 8, 2);

end;

function TfrmInitial.checkSUMData(orderStr: string): string;
var
  i, j, k: integer;
  TmpStr: string;
  reTmpStr: string;
begin
  if (length(orderStr) mod 2) <> 0 then
  begin
    MessageBox(handle, '传入参数长度错误!', '错误', MB_ICONERROR + MB_OK);
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


procedure TfrmInitial.prcSendDataToCard();
var
  orderStr: string;
begin
  if orderLst.Count > curOrderNo then
  begin
    orderStr := orderLst.Strings[curOrderNo];
    orderStr := ICFunction.funcTransferExchData(orderStr);
    commInitial.WriteCommData(pchar(orderStr), length(orderStr)); //真正写到卡头
    inc(curOrderNo); //累加
  end;
end;
        
procedure TfrmInitial.commInitialReceiveData(Sender: TObject; Buffer: Pointer;
  BufferLength: Word);
 var
  i: integer;
  recStr: string;
  tmpStr: string;
  tmpStrend: string;
begin
   //接收----------------
  recStr := '';
  SetLength(tmpStr, BufferLength);
  move(buffer^, pchar(tmpStr)^, BufferLength);
  for i := 1 to BufferLength do
  begin
    recStr := recStr + intTohex(ord(tmpStr[i]), 2); //将获得数据转换为16进制数
    if i = BufferLength then
    begin
      tmpStrend := 'END';
    end;
  end;
  recDataLst.Clear;
  recDataLst.Add(recStr);
  begin
    checkCMDInfo(); //首先根据接收到的数据进行判断，确认此卡是否属于为正确的卡
  end;
end;



procedure TfrmInitial.FormShow(Sender: TObject);
begin
  //
   //初始化
  initComboxCardtype();
  initCoinRecord();

  //初始化变量
  orderLst := TStringList.Create;
  recDataLst := tStringList.Create;

  //打开串口
 commInitial.StartComm();
 

 
end;

procedure TfrmInitial.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  //
  orderLst.Free;
  recDataLst.Free;
  commInitial.StopComm();
end;

procedure TfrmInitial.btnInitialClick(Sender: TObject);
var
intWriteValue : Integer;
begin
    intWriteValue := 0; //初始化时币值设定为0
    initIncrOperation(intToStr(intWriteValue));
end;

end.
