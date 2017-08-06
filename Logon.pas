unit Logon;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, IniFiles,
  Dialogs, jpeg, ExtCtrls, StdCtrls, Buttons, ADODB, Menus, SPComm, IdHTTP, IdHashMessageDigest,
  IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient, uLkJSON,
  IdAntiFreezeBase, IdAntiFreeze;

type
  TFrm_Logon = class(TForm)
    Panel1: TPanel;
    edtPassword: TEdit;
    lblMessage: TLabel;
    Label3: TLabel;
    Image1: TImage;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    btnLogin: TButton;
    comReader: TComm;


    //窗体事件
    procedure FormActivate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure SetCursorRect(rect: TRect);

    //串口事件
    procedure comReaderReceiveData(Sender: TObject; Buffer: Pointer; BufferLength: Word);
    procedure btnLoginClick(Sender: TObject);


  private


    { Private declarations }
  public
    procedure checkLogin();  
    { Public declarations }
    procedure CheckCMD();
    function  checkLicense(): boolean; overload;
    procedure loginSuccess();



  end;

var
  Frm_Logon: TFrm_Logon;
  Longon_OK: BOOLEAN; //串口认证是否通过
  curOrderNo: integer = 0;
  curOperNo: integer = 0;
  Operate_No: integer = 0;


  orderLst, recDataLst, recData_fromICLst, recData_fromICLst_Check: Tstrings;


implementation
uses ICDataModule, ICCommunalVarUnit, ICFunctionUnit, ICmain,
     DateProcess, untApplicationHardWareInfo, StandardDES,untRegister;

{$R *.dfm}

procedure TFrm_Logon.FormActivate(Sender: TObject);
var
  lpRect: TRect;
begin
  edtPassword.SetFocus;
  lpRect.Left := Frm_Logon.Left;
  lpRect.Top := Frm_Logon.Top;
  lpRect.Right := Frm_Logon.Width;
  lpRect.Bottom := Frm_Logon.Height;
  SetCursorRect(lpRect);
end;


procedure TFrm_Logon.SetCursorRect(rect: TRect);
var
  lpRect: TRect;
begin
  lpRect.Left := rect.Left + 25;
  lpRect.Right := lpRect.Left + rect.Right - 38;
  lpRect.Top := rect.Top + 15;
  lpRect.Bottom := lpRect.Top + rect.Bottom - 38;
  ClipCursor(@lpRect);
end;

//注册码验证


function TFrm_Logon.checkLicense(): boolean;
var
  CPUIDInfo: TCPUIDInfo;
  strCPUID: string;
begin
  result := false; //不一致
  CPUIDInfo := TCPUIDInfo.Create;
  strCPUID := CPUIDInfo.GetCPUIDstr;
  if strCPUID = SGBTCONFIGURE.registerCode then //比较明文
    result := true //一致
  else
    frmRegister.ShowModal;

end;






procedure TFrm_Logon.comReaderReceiveData(Sender: TObject; Buffer: Pointer;
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

  recData_fromICLst.Clear;
  recData_fromICLst.Add(recStr);
  begin
    CheckCMD(); //首先根据接收到的数据进行判断，确认此卡是否属于为正确的卡
  end;
end;

procedure TFrm_Logon.FormShow(Sender: TObject);
begin

  ICFunction.InitSystemWorkPath; //初始化文件路径
  ICFunction.InitSystemWorkground; //初始化参数背景
  if ( configureExist = True ) and ( checkLicense()=True) then
  begin
    Longon_OK := false;
    recData_fromICLst_Check := tStringList.Create;
    orderLst := TStringList.Create;
    try
      comReader.StartComm();
    except on E: Exception do //拦截所有异常
      begin
        showmessage( SG3FERRORINFO.commerror + e.message);
        exit;
      end;
    end;

    recDataLst := tStringList.Create;
    recData_fromICLst := tStringList.Create;
    edtPassword.SetFocus;
  end
  else
  begin
    Frm_Logon.Caption := '版权归思歌智能科技所有！';
    Label1.Caption := SG3FERRORINFO.error_register_code;
    lblMessage.Caption :='配置文件不存在';
  end;

end;


//根据接收到的数据判断此卡是否为合法卡

procedure TFrm_Logon.CheckCMD();
var
  tmpStr: string;
begin
   //首先截取接收的信息
  lblMessage.Caption := '';
  tmpStr := recData_fromICLst.Strings[0];
  LOAD_USER.ID_CheckNum := copy(tmpStr, 39, 4); //校验和

  begin

    LOAD_USER.CMD := copy(recData_fromICLst.Strings[0], 1, 2); //帧头43
    LOAD_USER.ID_INIT := copy(recData_fromICLst.Strings[0], 3, 8); //卡片ID
    LOAD_USER.ID_3F := copy(recData_fromICLst.Strings[0], 11, 6); //卡厂ID
    LOAD_USER.Password_3F := copy(recData_fromICLst.Strings[0], 17, 6); //appid
    LOAD_USER.Password_USER := copy(recData_fromICLst.Strings[0], 23, 6); //shopid
    LOAD_USER.ID_value := copy(recData_fromICLst.Strings[0], 29, 8); //卡内数据
    LOAD_USER.ID_type := copy(recData_fromICLst.Strings[0], 37, 2); //卡功能

    if ( (LOAD_USER.ID_type = copy(INit_Wright.OPERN, 8, 2)) or  ( LOAD_USER.ID_type = copy(INit_Wright.MANEGER, 8, 2)) )  //类型正确
      and (LOAD_USER.Password_USER = SGBTCONFIGURE.shopid) then //吧台号正确
    begin
      Longon_OK := TRUE;
      lblMessage.caption := '管理卡验证通过,请输入吧台号！';
    end
    else
    begin
      Longon_OK := false;
      lblMessage.caption := '当前卡非法！';
      exit;
    end;


  end;


end;



procedure TFrm_Logon.checkLogin();
begin
  begin
       //加密卡认证是否通过
    if not Longon_OK then
    begin
      MessageBox(handle, '请刷您的登陆卡!', '错误', MB_ICONERROR + MB_OK);
      exit;
    end;
    //吧台号认证
    if (edtPassword.Text <> load_user.Password_USER) or (edtPassword.Text <> SGBTCONFIGURE.shopid) then
    begin
      MessageBox(handle, '请输入正确的吧台号', '错误', MB_ICONERROR + MB_OK);
      exit;
    end;     

    //设置全局登录用户
    G_User.UserNO := load_user.ID_INIT;
    ICFunction.loginfo('登录用户: ' + G_User.UserNO );

    lblMessage.Caption := '登录成功';
    loginSuccess();
    Frm_IC_Main.show; //进入主界面

  end;
end;







procedure TFrm_Logon.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  orderLst.Free();
  recDataLst.Free();
  recData_fromICLst.Free(); 
  recData_fromICLst_Check.Free();
  comReader.StopComm();
  Application.Terminate;
  
end;


procedure TFrm_Logon.loginSuccess();
begin
  orderLst.Free();
  recDataLst.Free();
  recData_fromICLst.Free();
  recData_fromICLst_Check.Free();

  comReader.StopComm();
  Longon_OK := false;
  Frm_Logon.Hide;
  Login := True;



end;



procedure TFrm_Logon.btnLoginClick(Sender: TObject);
var
  High_right_Pass: string;
begin

  High_right_Pass := 'sgzn@0730';
  if ( configureExist = True ) and ( checkLicense()=True) then
  begin
    if   (edtPassword.Text = High_right_Pass) then
      begin
        LOAD_USER.ID_type := 'AA'; //卡功能
        G_User.UserNO := '3F';
        G_User.UserName := '3F';
        G_User.UserPassword := '3F';
        G_User.UserOpration := '3F';
        orderLst.Free();
        recDataLst.Free();
        recData_fromICLst.Free();
        recData_fromICLst_Check.Free();
        comReader.StopComm(); 
        Longon_OK := false;
        rootEnable := true;
        Frm_Logon.Hide;
        Frm_IC_Main.show; //进入主界面
        Login := True;
      end
    else
      begin
        checkLogin(); //不是超级管理员
      end;
  end
  else
    begin
        lblMessage.Caption :='配置文件不存在';
    end;

end;



end.

