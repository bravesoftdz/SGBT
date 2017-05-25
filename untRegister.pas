unit untRegister;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,IniFiles,
  Dialogs, StdCtrls, ExtCtrls;

type
  TfrmRegister = class(TForm)
    pnl1: TPanel;
    grp1: TGroupBox;
    grp2: TGroupBox;
    edtCPUID: TEdit;
    lbl1: TLabel;
    lbl2: TLabel;
    edtRecode: TEdit;
    btnRegister: TButton;
    procedure btnRegisterClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure edtRecodeClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmRegister: TfrmRegister;

implementation
uses ICDataModule, ICCommunalVarUnit, ICFunctionUnit, ICmain,
  DateProcess, untApplicationHardWareInfo, StandardDES;
{$R *.dfm}

procedure TfrmRegister.btnRegisterClick(Sender: TObject);
var
  myIni: TiniFile;
begin
 if FileExists(SystemWorkGroundFile) then
  begin
    myIni := TIniFile.Create(SystemWorkGroundFile);
    myIni.WriteString('SGBTCONFIGURE', 'registerCode', Trim(edtRecode.Text)); //写入注册码
    FreeAndNil(myIni);
    ShowMessage('注册成功，请关闭所有窗口重新登录!');
    Close;
  end;
  
end;

procedure TfrmRegister.FormShow(Sender: TObject);
var
  CPUIDInfo: TCPUIDInfo;
  strCPUID: string;
begin
  CPUIDInfo := TCPUIDInfo.Create;
  strCPUID := CPUIDInfo.GetCPUIDstr;
  edtCPUID.Text :=strCPUID;

end;

procedure TfrmRegister.edtRecodeClick(Sender: TObject);
begin
      if edtRecode.Text = '请把注册码发回给技术人员，并把获取到的认证码填写,按确认' then
          edtRecode.Text := '' ;
        
end;

end.
