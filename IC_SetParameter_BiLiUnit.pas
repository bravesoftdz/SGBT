unit IC_SetParameter_BiLiUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, Grids, DBGrids, IniFiles, ExtCtrls, SPComm;

type
  Tfrm_SetParameter_BILI_INIT = class(TForm)
    Panel2: TPanel;
    Panel1: TPanel;
    Panel4: TPanel;
    btnCancel: TBitBtn;
    Image1: TImage;
    Image2: TImage;
    btnConfirm: TBitBtn;
    edtProportion: TEdit;
    procedure btnConfirmClick(Sender: TObject);

    procedure FormShow(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);

    procedure InitCoinProportion();
  private
    { Private declarations }
  public
    { Public declarations }

  end;

var
  frm_SetParameter_BILI_INIT: Tfrm_SetParameter_BILI_INIT;

implementation
uses ICCommunalVarUnit, ICFunctionUnit, ICDataModule, strprocess;
{$R *.dfm}

procedure Tfrm_SetParameter_BILI_INIT.btnConfirmClick(Sender: TObject);
var
  myIni: TiniFile;
  coinproportion: string;
begin


  if  IsNumberic(edtProportion.Text) = false  and (edtProportion.Text <> '0') then
  begin
    MessageBox(handle, '请输入正确的数字', '错误', MB_ICONERROR + MB_OK);
    exit;
  end;

  if (edtProportion.Text = '') then
  begin
      ShowMessage('请输入正确数字');
      exit
  end;



  if FileExists(SystemWorkGroundFile) then
  begin
    myIni := TIniFile.Create(SystemWorkGroundFile);
    coinproportion := edtProportion.Text; //等于新输入的值  
    myIni.WriteString('SGBTCOININFO', 'coinproportion', edtProportion.Text); //写入文件
    FreeAndNil(myIni);
  end;
  ShowMessage('设置成功');
end;



procedure Tfrm_SetParameter_BILI_INIT.FormShow(Sender: TObject);
begin

  ICFunction.InitSystemWorkground;
  InitCoinProportion();
  
end;

procedure Tfrm_SetParameter_BILI_INIT.InitCoinProportion;
var
  myIni: TiniFile;
begin
 if FileExists(SystemWorkGroundFile) then
  begin
    myIni := TIniFile.Create(SystemWorkGroundFile);
    edtProportion.Text := MyIni.ReadString('SGBTCOININFO', 'coinproportion', '1'); //读取更新后的币值上限
    FreeAndNil(myIni);
  end;
end;



procedure Tfrm_SetParameter_BILI_INIT.btnCancelClick(Sender: TObject);
begin
  close;
end;



end.
