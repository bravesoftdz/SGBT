unit IC_SetParameter_datamentainUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Spin, Mask, Buttons, ComCtrls, FileCtrl,
  ShellCtrls, ADODB, DB;

type
  Tfrm_IC_SetParameter_datamentain = class(TForm)
    pgcMenberfor: TPageControl;
    tbsConfig: TTabSheet;
    Panel2: TPanel;
    tbsLowLevel: TTabSheet;
    Panel1: TPanel;
    Panel4: TPanel;
    Panel7: TPanel;
    GroupBox1: TGroupBox;
    Panel15: TPanel;
    ShellListView2: TShellListView;
    Panel16: TPanel;
    DirectoryListBox2: TDirectoryListBox;
    DriveComboBox2: TDriveComboBox;
    ADOCommand1: TADOCommand;
    ADOConnection1: TADOConnection;
    ADOStoredProc1: TADOStoredProc;
    ADOStoredProc2: TADOStoredProc;
    Panel10: TPanel;
    GroupBox3: TGroupBox;
    Panel13: TPanel;
    ShellListView1: TShellListView;
    Panel14: TPanel;
    DirectoryListBox1: TDirectoryListBox;
    DriveComboBox1: TDriveComboBox;
    Panel9: TPanel;
    BitBtn20: TBitBtn;
    Image1: TImage;
    Panel17: TPanel;
    BitBtn3: TBitBtn;
    Image2: TImage;
    BitBtn1: TBitBtn;
    BitBtn17: TBitBtn;
    procedure DirectoryListBox1Change(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure BitBtn17Click(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure DirectoryListBox2Change(Sender: TObject);
    procedure BitBtn20Click(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure BitBtn4Click(Sender: TObject);
    procedure BitBtn6Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frm_IC_SetParameter_datamentain: Tfrm_IC_SetParameter_datamentain;

implementation
uses SetParameterUnit, ICDataModule, ICCommunalVarUnit, ICEventTypeUnit, ICFunctionUnit;
{$R *.dfm}

procedure Tfrm_IC_SetParameter_datamentain.DirectoryListBox1Change(
  Sender: TObject);
begin
   // Edit3.text:=DirectoryListBox1.Directory;
  ShellListView1.Root := DirectoryListBox1.Directory;
end;

procedure Tfrm_IC_SetParameter_datamentain.DirectoryListBox2Change(
  Sender: TObject);
begin
   // Edit4.text:=DirectoryListBox2.Directory;
  ShellListView2.Root := DirectoryListBox2.Directory;
end;



procedure Tfrm_IC_SetParameter_datamentain.FormShow(Sender: TObject);
begin
end;
//备份

procedure Tfrm_IC_SetParameter_datamentain.BitBtn17Click(Sender: TObject);
begin
  with DataModule_3F do
  begin
    adocommand1.Connection := DataModule_3F.ADOConnection1;
    adocommand1.CommandText := 'BACKUP DATABASE JLML TO DISK =' + '''' + 'D:\SG3F.bak' + '''' + 'WITH FORMAT';
    adocommand1.CommandType := cmdText;
    adocommand1.Execute;
  end;
  showmessage('数据库备份完成!');
end;
//恢复

procedure Tfrm_IC_SetParameter_datamentain.BitBtn1Click(Sender: TObject);
begin
  with DataModule_3F do
  begin
//  ADOQuery1.ConnectionString:='Provider=SQLOLEDB.1;Persist Security Info = False ;User ID = sa;Initial Catalog = master;Data Source = '+computername;  //注意这里连接的数据库是master

    ADOQuery1.SQL.Clear;
    ADOQuery1.SQL.Add('USE master');
    ADOQuery1.SQL.Add('RESTORE DATABASE JLML FROM disk =' + '''' + 'D:\JLML.bak' + '''');
    ADOQuery1.SQL.Add('USE JLML');
    ADOQuery1.ExecSQL;
  end;
  showmessage('数据库恢复完成!');
end;

procedure Tfrm_IC_SetParameter_datamentain.FormCreate(Sender: TObject);
var CNameBuffer: PChar;
  fl_loaded: Boolean;
  CLen: ^DWord;
  ComputerName: string;
begin
  GetMem(CNameBuffer, 255);
  New(CLen);
  CLen^ := 255;
  fl_loaded := GetComputerName(CNameBuffer, CLen^);
  if fl_loaded then
    ComputerName := StrPas(CNameBuffer) //获取计算机名即SQL Server数据库服务器名
  else ComputerName := 'Unkown';

  DataModule_3F.ADOConnection1.ConnectionString := 'Provider=SQLOLEDB.1;Integrated Security=SSPI;Persist Security Info = False ;User ID = sa;Initial Catalog = JLML;Data Source = ' + computername;
  DataModule_3F.ADOQuery1.ConnectionString := 'Provider=SQLOLEDB.1;Integrated Security=SSPI;Persist Security Info = False ;User ID = sa;Initial Catalog = master;Data Source = ' + computername; //注意这里连接的数据库是master
  FreeMem(CNameBuffer, 255);
  Dispose(CLen);
end;


procedure Tfrm_IC_SetParameter_datamentain.BitBtn20Click(Sender: TObject);
begin
  Close;
end;

procedure Tfrm_IC_SetParameter_datamentain.BitBtn3Click(Sender: TObject);
begin
  Close;
end;

procedure Tfrm_IC_SetParameter_datamentain.BitBtn4Click(Sender: TObject);
begin
  Close;
end;

procedure Tfrm_IC_SetParameter_datamentain.BitBtn6Click(Sender: TObject);
begin
  Close;
end;

end.
