unit IC_SetParameter_MaxDateUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, IniFiles,
  Dialogs, StdCtrls, Buttons, ExtCtrls, SPComm;

type
  Tfrm_SetParameter_MaxDate = class(TForm)
    comReader: TComm;
    Panel1: TPanel;
    Panel3: TPanel;
    Panel2: TPanel;
    BitBtn3: TBitBtn;
    Image1: TImage;
    Image2: TImage;
    Edit_old_Password_Input: TEdit;
    Edit_old_password: TEdit;
    BitBtn_ChangBossPassword: TBitBtn;
    procedure BitBtn3Click(Sender: TObject);
    procedure BitBtn_ChangBossPasswordClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure comReaderReceiveData(Sender: TObject; Buffer: Pointer;
      BufferLength: Word);
    procedure Edit_old_Password_InputKeyPress(Sender: TObject;
      var Key: Char);

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
  frm_SetParameter_MaxDate: Tfrm_SetParameter_MaxDate;
  orderLst, recDataLst, recData_fromICLst: Tstrings;
implementation
uses ICDataModule, ICCommunalVarUnit, ICFunctionUnit, ICmain, Frontoperate_EBincvalueUnit, ICEventTypeUnit, strprocess;
{$R *.dfm}
//转找发送数据格式 ，将字符转换为16进制

function Tfrm_SetParameter_MaxDate.exchData(orderStr: string): string;
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

procedure Tfrm_SetParameter_MaxDate.sendData();
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

procedure Tfrm_SetParameter_MaxDate.checkOper();
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

procedure Tfrm_SetParameter_MaxDate.BitBtn_ChangBossPasswordClick(Sender: TObject);
var
  myIni: TiniFile;
  Edit_old_password_check: string;
  Edit_new_password_check: string;
  Edit_comfir_password_check: string;
  MaxDate: string;
  strtemp: string;
begin
  strtemp := FormatDateTime('yyyy-MM-dd HH:mm:ss', now);
   //调用算法，将输入的旧密码计算得到算法值 Edit_old_password_check
  if Edit_old_Password_Input.Text = '' then
  begin
    MessageBox(handle, '请输入新的卡有效期！', '错误', MB_ICONERROR + MB_OK);
    exit;
  end;
  if StrToInt(Edit_old_Password_Input.Text) > 47 then
  begin
    ShowMessage('输入的值不能大于47，且必须为整数');
    exit;
  end;
  if FileExists(SystemWorkGroundFile) then
  begin
    myIni := TIniFile.Create(SystemWorkGroundFile);
    MaxDate := Copy(strtemp, 12, 2)
      + inttostrpad0(strtoint(TrimRight(Edit_old_Password_Input.Text)), 2, true) //左填充
      + Copy(strtemp, 15, 2); //等于新输入的值
    myIni.WriteString('卡出厂设置', '设定期限', MaxDate); //写入文件

    iHHSet := StrToInt(Copy(MyIni.ReadString('卡出厂设置', '设定期限', '152419'), 3, 2));

    FreeAndNil(myIni);
  end;
  if iHHSet = StrToInt(TrimRight(Edit_old_Password_Input.Text)) then
  begin
    Edit_old_Password_Input.Text := '';
    MessageBox(handle, ' 修改卡有效期成功！', '成功', MB_OK);
    Edit_old_password.Text := TrimRight(Edit_old_Password_Input.Text);
    exit;
  end
  else
  begin
    Edit_old_Password_Input.Text := '';
    Edit_old_password.Text := TrimRight(Edit_old_Password_Input.Text);
    MessageBox(handle, '修改卡有效期失败！', '失败', MB_ICONERROR + MB_OK);
    exit;
  end;
end;

procedure Tfrm_SetParameter_MaxDate.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  orderLst.Free();
  recDataLst.Free();
  recData_fromICLst.Free();
  comReader.StopComm();
  ICFunction.ClearIDinfor; //清除从ID读取的所有信息
  Edit_old_password.Text := '';
end;

procedure Tfrm_SetParameter_MaxDate.FormShow(Sender: TObject);
begin
  comReader.StartComm();
  orderLst := TStringList.Create;
  recDataLst := tStringList.Create;
  recData_fromICLst := tStringList.Create;
  Edit_old_Password_Input.SetFocus;

end;

procedure Tfrm_SetParameter_MaxDate.comReaderReceiveData(Sender: TObject; Buffer: Pointer;
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

    if ii = BufferLength then
    begin
      tmpStrend := 'END';
    end;
  end;

  //ICFunction.loginfo('MaxdateUnit: ' + recStr);
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

procedure Tfrm_SetParameter_MaxDate.CheckCMD();
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
      Edit_old_password.Text := IntToStr(iHHSet); //将原来的密码显示，是否需要考虑变成*号显示？
      Edit_old_Password_Input.SetFocus;
                          //Label6.Caption:='请按照要求进行修改卡有效期操作';
      Edit_old_Password_Input.Text := '请输入!';
    end
    else //不是万能卡AA，也不是老板卡BB
    begin
      Edit_old_password.Text := '';
                          //Label6.Caption:='对不起！你无权限进行修改卡有效期操作';
      Edit_old_Password_Input.Text := '你无权限!';
      exit;
    end;
  end;

end;


procedure Tfrm_SetParameter_MaxDate.BitBtn3Click(Sender: TObject);
begin
  Close;
end;


procedure Tfrm_SetParameter_MaxDate.Edit_old_Password_InputKeyPress(
  Sender: TObject; var Key: Char);
begin
  if not (key in ['0'..'9', #8, #13]) then
  begin
    key := #0;
    ShowMessage('输入错误，只能输入数字');
  end
  else if key = #13 then
  begin

    if length(Edit_old_Password_Input.Text) = 6 then
      BitBtn_ChangBossPassword.setfocus;
  end;

end;




end.
