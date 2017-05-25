unit check_detail;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Grids, DBGrids, DB, ADODB, SPComm;

type
  Tfrm_check_detail = class(TForm)
    panel_checkdetail: TPanel;
    GroupBox_checkdetail: TGroupBox;
    Lab_id: TLabel;
    edit_id: TEdit;
    ds_checkdetail: TDataSource;
    ADOQuery_checkdetail: TADOQuery;
    DBGrid_checkdetail: TDBGrid;
    comReader: TComm;
    procedure Button1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure comReaderReceiveData(Sender: TObject; Buffer: Pointer;
      BufferLength: Word);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure initdatabase();
    procedure checkcmd();
    procedure querybyid(strID : String );
  end;

var
  frm_check_detail: Tfrm_check_detail;
  orderLst, recDataLst, recData_fromICLst: Tstrings;

  implementation
  uses ICDataModule, ICCommunalVarUnit, ICFunctionUnit;
{$R *.dfm}


procedure Tfrm_check_detail.initdatabase();
var
  strSQL:String;
  strID:String;
begin
  //测试ID
  strID := '256DCC00';
  with ADOQuery_checkdetail do begin
    Connection := DataModule_3F.ADOConnection_Main;
    Active:=false;
    SQL.Clear;
    strSQL:='select * from [tmembedetail] where id_usercard = ''' + strID + ''' order by gettime desc';
    ICFunction.loginfo(strSQL);
    SQL.Add(strSQL);
    Active:=True;
    end;
end;


procedure Tfrm_check_detail.querybyid(strID : String );
var
  strSQL:String;
  strtempID:String;
begin
  strtempID := strID;
  
   
  with ADOQuery_checkdetail do begin
    Connection := DataModule_3F.ADOConnection_Main;
    Active:=false;
    SQL.Clear;
    strSQL:='select top 5 * from [tmembedetail] where id_usercard = ''' + strtempID + ''' order by gettime desc';
    ICFunction.loginfo('check_detail: ' + strSQL);
    SQL.Add(strSQL);
    Active:=True;
    end;
end;



procedure Tfrm_check_detail.FormShow(Sender: TObject);
var
  strStartDate, strEndDate: string;
begin
       comReader.StartComm();
       orderLst := TStringList.Create;
       recDataLst := tStringList.Create;
       recData_fromICLst := tStringList.Create;   
       //initdatabase();
end;

procedure Tfrm_check_detail.FormClose(Sender: TObject; var Action: TCloseAction);
var
  i: integer;
begin
  orderLst.Free();
  recDataLst.Free();
  recData_fromICLst.Free();
  comReader.StopComm();            
end;




procedure Tfrm_check_detail.Button1Click(Sender: TObject);
begin
      initdatabase();
end;

procedure Tfrm_check_detail.comReaderReceiveData(Sender: TObject;   Buffer: Pointer; BufferLength: Word);
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


  recData_fromICLst.Clear;
  recData_fromICLst.Add(recStr);
    //接收---------------
  begin
    CheckCMD(); //首先根据接收到的数据进行判断，确认此卡是否属于为正确的卡
  end;


end;



//根据接收到的数据判断此卡是否为合法卡
procedure Tfrm_check_detail.CheckCMD();
var
  i: integer;
  tmpStr: string;
  stationNoStr: string;
  tmpStr_Hex: string;
  tmpStr_Hex_length, IDtypetemp: string;
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
  if Receive_CMD_ID_Infor.CMD = CMD_COUMUNICATION.CMD_INCValue_RE then
  begin
      //用于处理来自系统主动请求，充值卡头返回的处理结果
  end
  else if Receive_CMD_ID_Infor.CMD = CMD_COUMUNICATION.CMD_READ then  //读取电子币数据成功
  begin

    Receive_CMD_ID_Infor.ID_INIT := copy(recData_fromICLst.Strings[0], 3, 8); //卡片ID
    Receive_CMD_ID_Infor.ID_3F := copy(recData_fromICLst.Strings[0], 11, 6); //卡厂ID
    Receive_CMD_ID_Infor.Password_3F := copy(recData_fromICLst.Strings[0], 17, 6); //卡密
    Receive_CMD_ID_Infor.Password_USER := copy(recData_fromICLst.Strings[0], 23, 6); //用户密码
    Receive_CMD_ID_Infor.ID_value := copy(recData_fromICLst.Strings[0], 29, 8); //卡内数据
    Receive_CMD_ID_Infor.ID_type := copy(recData_fromICLst.Strings[0], 37, 2); //卡功能
 
  end;
  edit_id.Text :=  Receive_CMD_ID_Infor.ID_INIT;
  querybyid(edit_id.Text);
  
end;




//结束整个Unit
end.




