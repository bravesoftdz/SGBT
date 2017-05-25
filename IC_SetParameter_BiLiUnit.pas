unit IC_SetParameter_BiLiUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, Grids, DBGrids, IniFiles, ExtCtrls, SPComm;

type
  Tfrm_SetParameter_BILI_INIT = class(TForm)
    Panel2: TPanel;
    Panel1: TPanel;
    comReader: TComm;
    Panel4: TPanel;
    BitBtn1: TBitBtn;
    Image1: TImage;
    Image2: TImage;
    Edit_BiLi: TEdit;
    BitBtn_BiLiSetComfir: TBitBtn;
    edit_exchangerate: TEdit;
    Lableexchangerate: TLabel;
    Label1: TLabel;
    procedure BitBtn_BiLiSetComfirClick(Sender: TObject);
    procedure Edit_BiLiKeyPress(Sender: TObject; var Key: Char);
    procedure comReaderReceiveData(Sender: TObject; Buffer: Pointer;
      BufferLength: Word);
    procedure FormShow(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure CheckCMD();
  end;

var
  frm_SetParameter_BILI_INIT: Tfrm_SetParameter_BILI_INIT;
  orderLst, recDataLst, recData_fromICLst: Tstrings;
implementation
uses ICCommunalVarUnit, ICFunctionUnit, ICDataModule, strprocess;
{$R *.dfm}

procedure Tfrm_SetParameter_BILI_INIT.BitBtn_BiLiSetComfirClick(Sender: TObject);
var
  myIni: TiniFile;
  Edit_old_BiLi_check: string;
  Edit_comfir_BiLi_check: string;
begin




    //首先要读取币值最大许可值INit_Wright.MaxValue
  if FileExists(SystemWorkGroundFile) then
  begin
    myIni := TIniFile.Create(SystemWorkGroundFile);
    INit_Wright.MaxValue := MyIni.ReadString('PLC工作区域', 'PC运行', '500'); //读取更新后的币值上限
    Edit_old_BiLi_check := MyIni.ReadString('PLC工作区域', 'PLC缸体报废标志', 'D6010');
    //edit_exchangerate.Text :=  MyIni.ReadString('PLC工作区域', 'exchangerate','1');
    FreeAndNil(myIni);
  end;
    //调用算法，将输入的旧密码计算得到算法值 Edit_old_password_check
  if Edit_BiLi.Text = '' then
  begin
    MessageBox(handle, '请输入代币比例值！', '错误', MB_ICONERROR + MB_OK);
    exit;
  end;


  begin
            // ShowMessage('输入的值太大，乘于500后不能大于'+INit_Wright.MaxValue+'，请重新输入！');
            // exit;
  end;
  if FileExists(SystemWorkGroundFile) then
  begin
    myIni := TIniFile.Create(SystemWorkGroundFile);
    Edit_comfir_BiLi_check := Edit_BiLi.Text; //等于新输入的值

    myIni.WriteString('PLC工作区域', 'PLC缸体报废标志', Edit_comfir_BiLi_check); //写入文件

    if not IsNumberic(edit_exchangerate.Text) then
    begin
      ShowMessage('输入错误，彩票兑换比只能输入数字！');
//          exit
    end;
    myIni.WriteString('PLC工作区域', 'exchangerate', edit_exchangerate.Text); //写入文件

    SystemWorkground.ErrorGTState := MyIni.ReadString('PLC工作区域', 'PLC缸体报废标志', 'D6010');
    FreeAndNil(myIni);
  end;
  if SystemWorkground.ErrorGTState = Edit_comfir_BiLi_check then
  begin
    //Edit_BiLi.Text := '';
    BitBtn_BiLiSetComfir.Enabled := false;
    MessageBox(handle, '修改代币比例操作成功！', '成功', MB_OK);
    exit;
  end
  else
  begin
    SystemWorkground.ErrorGTState := Edit_old_BiLi_check;
    MessageBox(handle, '修改代币比例操作失败！', '失败', MB_ICONERROR + MB_OK);
    exit;
  end;


end;

procedure Tfrm_SetParameter_BILI_INIT.Edit_BiLiKeyPress(Sender: TObject;
  var Key: Char);
begin
  if not (key in ['0'..'9', #8, #13]) then
  begin
    key := #0;
    ShowMessage('输入错误，只能输入数字！');
  end
  else if key = #13 then
  begin
    if length(Edit_BiLi.Text) > 0 then
    begin
      BitBtn_BiLiSetComfir.Enabled := true;
    end
    else
    begin
      BitBtn_BiLiSetComfir.Enabled := false;
    end;
  end;
end;

procedure Tfrm_SetParameter_BILI_INIT.comReaderReceiveData(Sender: TObject;
  Buffer: Pointer; BufferLength: Word);
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
    {
    if curOrderNo<orderLst.Count then    // 判断指令是否已经都发送完毕，如果指令序号小于指令总数则继续发送
        sendData()
    else begin
        checkOper();
    end;
    }


end;
 //根据接收到的数据判断此卡是否为合法卡

procedure Tfrm_SetParameter_BILI_INIT.CheckCMD();
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
                 //if ICFunction.CHECK_3F_ID(Receive_CMD_ID_Infor.ID_INIT,Receive_CMD_ID_Infor.ID_3F,Receive_CMD_ID_Infor.Password_3F) and ( (Receive_CMD_ID_Infor.ID_type=copy(INit_Wright.Produecer_3F,8,2))or (Receive_CMD_ID_Infor.ID_type=copy(INit_Wright.BOSS,8,2)) ) then
    if DataModule_3F.Query_ID_OK(Receive_CMD_ID_Infor.ID_INIT) then
    begin
      if (Receive_CMD_ID_Infor.ID_type = copy(INit_Wright.BOSS, 8, 2)) or (Receive_CMD_ID_Infor.ID_type = copy(INit_Wright.MANEGER, 8, 2)) then
      begin
        begin
          Edit_BiLi.Enabled := true; //许可修改比例值操作
          edit_exchangerate.Enabled := true;

          BitBtn_BiLiSetComfir.Enabled := true; //许可修改比例值操作
          Edit_BiLi.Text := SystemWorkground.ErrorGTState;
          edit_exchangerate.Text := SystemWorkground.exchangerate;

        end;

      end
      else //不是万能卡AA，也不是老板卡BB
      begin
                          //Label6.Caption:='你无权限！';
        Edit_BiLi.Text := '你无权限！';
        exit;
      end;
    end
    else //不是万能卡AA，也不是老板卡BB
    begin
                          //Label6.Caption:='你无权限！';
      Edit_BiLi.Text := '你无权限！';
      exit;
    end;
  end;

end;


procedure Tfrm_SetParameter_BILI_INIT.FormShow(Sender: TObject);
begin

  ICFunction.InitSystemWorkground;
  Edit_BiLi.Text := '请刷权限卡';
  Edit_BiLi.Enabled := false; //许可修改比例值操作

  edit_exchangerate.Enabled := false;

  BitBtn_BiLiSetComfir.Enabled := false; //许可修改比例值操作
  comReader.StartComm();
  recDataLst := tStringList.Create;
  recData_fromICLst := tStringList.Create;
  orderLst := TStringList.Create;
end;

procedure Tfrm_SetParameter_BILI_INIT.BitBtn1Click(Sender: TObject);
begin
  close;
end;

procedure Tfrm_SetParameter_BILI_INIT.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  orderLst.Free();
  recDataLst.Free();
  recData_fromICLst.Free();

  comReader.StopComm();
end;

end.
