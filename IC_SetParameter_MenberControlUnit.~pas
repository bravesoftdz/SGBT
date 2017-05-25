unit IC_SetParameter_MenberControlUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, IniFiles,
  Dialogs, SPComm, StdCtrls, Buttons, ExtCtrls;

type
  Tfrm_SetParameter_MenberControl_INIT = class(TForm)
    Panel2: TPanel;
    Panel1: TPanel;
    Image2: TImage;
    Panel4: TPanel;
    Image1: TImage;
    BitBtn3: TBitBtn;
    BitBtn_ChangBossPassword: TBitBtn;
    comReader: TComm;
    CheckBox_Update: TCheckBox;
    procedure BitBtn_ChangBossPasswordClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure comReaderReceiveData(Sender: TObject; Buffer: Pointer;
      BufferLength: Word);
  private
    { Private declarations }
  public
    { Public declarations }
    function exchData(orderStr: string): string;
    procedure sendData();
    procedure checkOper();
    procedure CheckCMD();
  end;

var
  frm_SetParameter_MenberControl_INIT: Tfrm_SetParameter_MenberControl_INIT;

  orderLst, recDataLst, recData_fromICLst: Tstrings;
implementation
uses ICDataModule, ICCommunalVarUnit, ICFunctionUnit, ICmain, Frontoperate_EBincvalueUnit, ICEventTypeUnit;
{$R *.dfm}
//转找发送数据格式 ，将字符转换为16进制

function Tfrm_SetParameter_MenberControl_INIT.exchData(orderStr: string): string;
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

procedure Tfrm_SetParameter_MenberControl_INIT.sendData();
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

procedure Tfrm_SetParameter_MenberControl_INIT.checkOper();
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


//保存设定的场地密码

procedure Tfrm_SetParameter_MenberControl_INIT.BitBtn_ChangBossPasswordClick(Sender: TObject);
var
  myIni: TiniFile;
  MenberControl_short_New: string;
  MenberControl_Enable: string;
  strtemp: string;
begin

  if CheckBox_Update.Checked then
  begin
        //实行会员管理制
    MenberControl_Enable := '1';
    INit_Wright.MenberControl_long := Copy(INit_Wright.MenberControl_long, 1, 4) + MenberControl_Enable;
  end
  else
  begin
    MenberControl_Enable := '0';
    INit_Wright.MenberControl_long := Copy(INit_Wright.MenberControl_long, 1, 4) + MenberControl_Enable;
  end;

  if FileExists(SystemWorkGroundFile) then
  begin
    myIni := TIniFile.Create(SystemWorkGroundFile);
    myIni.WriteString('PLC工作区域', 'PC系统管理', INit_Wright.MenberControl_long); //写入文件
    MenberControl_short_New := Copy(INit_Wright.MenberControl_long, 5, 1); //D6021的最后一个字符为设定值，1为采用，0不采用
    FreeAndNil(myIni);
  end;


  if MenberControl_Enable = MenberControl_short_New then
  begin
    INit_Wright.MenberControl_short := MenberControl_short_New;
    if MenberControl_Enable = '1' then
    begin
      MessageBox(handle, ' 当前系统将  会  实行会员制管理！', '成功', MB_OK);
    end
    else
    begin
      MessageBox(handle, ' 当前系统将  不会  实行会员制管理！', '成功', MB_OK);
    end;

    BitBtn_ChangBossPassword.Enabled := false; //许可修改密码操作
    CheckBox_Update.Enabled := false;
    //exit;
  end
  else
  begin
    INit_Wright.MenberControl_long := Copy(INit_Wright.MenberControl_long, 1, 4) + INit_Wright.MenberControl_short;
    myIni.WriteString('PLC工作区域', 'PC系统管理', INit_Wright.MenberControl_long); //写入文件
    MessageBox(handle, '当前系统将  不会 实行会员制管理！', '失败', MB_ICONERROR + MB_OK);
   // exit;
  end;
  close;
end;

procedure Tfrm_SetParameter_MenberControl_INIT.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  orderLst.Free();
  recDataLst.Free();
  recData_fromICLst.Free();
  comReader.StopComm();
  ICFunction.ClearIDinfor; //清除从ID读取的所有信息


end;

procedure Tfrm_SetParameter_MenberControl_INIT.FormShow(Sender: TObject);
begin
  ICFunction.InitSystemWorkPath; //初始化文件路径
  ICFunction.InitSystemWorkground; //初始化参数背景

  comReader.StartComm();
  orderLst := TStringList.Create;
  recDataLst := tStringList.Create;
  recData_fromICLst := tStringList.Create;
    //Edit1.Text:=INit_Wright.MenberControl_long;
  CheckBox_Update.Enabled := false;
  BitBtn_ChangBossPassword.Enabled := false;
  if INit_Wright.MenberControl_short = '1' then

    CheckBox_Update.Checked := true
  else
    CheckBox_Update.Checked := false;
end;

procedure Tfrm_SetParameter_MenberControl_INIT.comReaderReceiveData(Sender: TObject; Buffer: Pointer;
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
       // if  (intTohex(ord(tmpStr[ii]),2)='4A') then
    if ii = BufferLength then
    begin
      tmpStrend := 'END';
    end;
  end;
     // Edit1.Text:=recStr;
  recData_fromICLst.Clear;
  recData_fromICLst.Add(recStr);
    //接收---------------
     //if  (tmpStrend='END') then
  begin
    CheckCMD(); //首先根据接收到的数据进行判断，确认此卡是否属于为正确的卡
         //AnswerOper();//其次确认是否有需要回复IC的指令
  end;
    //发送---------------
  if curOrderNo < orderLst.Count then // 判断指令是否已经都发送完毕，如果指令序号小于指令总数则继续发送
    sendData()
  else begin
    checkOper();
  end;

end;
 //根据接收到的数据判断此卡是否为合法卡

procedure Tfrm_SetParameter_MenberControl_INIT.CheckCMD();
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

  Receive_CMD_ID_Infor.ID_CheckNum := copy(tmpStr, 39, 4); //校验和

      // if (CheckSUMData(copy(tmpStr, 1, 38))=copy(tmpStr, 41, 2)+copy(tmpStr, 39, 2)) then//校验和
  begin
    CMD_CheckSum_OK := true;
    Receive_CMD_ID_Infor.CMD := copy(recData_fromICLst.Strings[0], 1, 2); //帧头43
  end;
                 //1、判断此卡是否为已经完成初始化
  if Receive_CMD_ID_Infor.CMD = CMD_COUMUNICATION.CMD_READ then
  begin

    Receive_CMD_ID_Infor.ID_INIT := copy(recData_fromICLst.Strings[0], 3, 8); //卡片ID
    Receive_CMD_ID_Infor.ID_3F := copy(recData_fromICLst.Strings[0], 11, 6); //卡厂ID
    Receive_CMD_ID_Infor.Password_3F := copy(recData_fromICLst.Strings[0], 17, 6); //卡密
    Receive_CMD_ID_Infor.Password_USER := copy(recData_fromICLst.Strings[0], 23, 6); //用户密码
    Receive_CMD_ID_Infor.ID_value := copy(recData_fromICLst.Strings[0], 29, 8); //卡内数据
    Receive_CMD_ID_Infor.ID_type := copy(recData_fromICLst.Strings[0], 37, 2); //卡功能

                 //1、判断是否曾经初始化过，只有3F初始化过的卡且类型为万能卡AA 或 老板卡BB的才能操作
               //  if ICFunction.CHECK_3F_ID(Receive_CMD_ID_Infor.ID_INIT,Receive_CMD_ID_Infor.ID_3F,Receive_CMD_ID_Infor.Password_3F) and ( (Receive_CMD_ID_Infor.ID_type=copy(INit_Wright.Produecer_3F,8,2))or (Receive_CMD_ID_Infor.ID_type=copy(INit_Wright.BOSS,8,2)) ) then
    if ((Receive_CMD_ID_Infor.ID_type = copy(INit_Wright.Produecer_3F, 8, 2)) or (Receive_CMD_ID_Infor.ID_type = copy(INit_Wright.BOSS, 8, 2))) then

    begin
      BitBtn_ChangBossPassword.Enabled := true; //许可修改密码操作
      CheckBox_Update.Enabled := true;
    end
    else //不是万能卡AA，也不是老板卡BB
    begin
      ShowMessage('操作失败，你无权限！');
      exit;
    end;
  end;

end;


procedure Tfrm_SetParameter_MenberControl_INIT.BitBtn3Click(Sender: TObject);
begin
  Close;
end;




end.
