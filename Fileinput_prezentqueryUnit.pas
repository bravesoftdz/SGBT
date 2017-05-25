unit Fileinput_prezentqueryUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, Grids, DBGrids, ExtCtrls, DB, ADODB;

type
  Tfrm_Fileinput_prezentquery = class(TForm)
    Panel1: TPanel;
    DBGrid2: TDBGrid;
    Panel4: TPanel;
    BitBtn7: TBitBtn;
    BitBtn8: TBitBtn;
    ComboBox_Operator: TComboBox;
    ComboBox_Other: TComboBox;
    Edit_Other: TEdit;
    DataSource_Gift: TDataSource;
    ADOQuery_Gift: TADOQuery;
    Bit_Query: TBitBtn;
    CheckBox_Date: TCheckBox;
    CheckBox_Other: TCheckBox;
    DataSource_Operator: TDataSource;
    ADOQuery_Operator: TADOQuery;
    procedure FormCreate(Sender: TObject);
    procedure CheckBox_DateClick(Sender: TObject);
    procedure CheckBox_OtherClick(Sender: TObject);
    procedure BitBtn8Click(Sender: TObject);
  private
    { Private declarations }
    procedure InitDataBase; //初始化表格
    procedure InitOperator; //初始化操作员列表
    function SetWhere: string;
  public
    { Public declarations }
  end;

var
  frm_Fileinput_prezentquery: Tfrm_Fileinput_prezentquery;

implementation

uses ICDataModule;

{$R *.dfm}
//初始化数据表

procedure Tfrm_Fileinput_prezentquery.InitDataBase;
var
  strSQL: string;
begin
  with ADOQuery_Gift do begin
    Connection := DataModule_3F.ADOConnection_Main;
    Active := false;
    SQL.Clear;
    strSQL := 'select * from [TGifts]';
    SQL.Add(strSQL);
    Active := True;
  end;
end;

//初始化操作员列表

procedure Tfrm_Fileinput_prezentquery.InitOperator;
var
  ADOQTemp: TADOQuery;
  strSQL: string;
  nameStr: string;
  i: integer;
begin

  ADOQTemp := TADOQuery.Create(nil);
  strSQL := 'select distinct [cUserName] from [TOperator]'; //考虑追加同名的处理
  with ADOQTemp do
  begin
    Connection := DataModule_3F.ADOConnection_Main;
    SQL.Clear;
    SQL.Add(strSQL);
    Active := True;
    ComboBox_Operator.Items.Clear;
    while not Eof do
    begin
      ComboBox_Operator.Items.Add(FieldByName('cUserName').AsString);
      Next;
    end;
  end;
  FreeAndNil(ADOQTemp);

end;

procedure Tfrm_Fileinput_prezentquery.FormCreate(Sender: TObject);
begin
  InitDataBase; //初始数据表
  InitOperator; //初始化操作员列表
end;

function Tfrm_Fileinput_prezentquery.SetWhere: string;
var
  strWhere: string;
  str1, str2, str3: string;

begin
  strWhere := '';
  str1 := ComboBox_Operator.Text;
  str2 := ComboBox_Other.Text;
  str3 := Edit_Other.Text;
     //按照操作员查询  一级条件
  if (CheckBox_Date.Checked) then begin
   // strWhere := strWhere + '发卡日期>='''+strStartDate
  //    +''' and 发卡日期<='''+strEndDate+'''';
  end;

    //按操其他（礼品编号、礼品名称）查询  二级条件
  if (CheckBox_other.Checked) then begin
   // if(strWhere<>'') then strWhere:= strWhere+' and ';
  //  strWhere := strWhere+' 卡状态='''+ComboBox_Cardstate.Text+'''';
  end;

  if (strWhere <> '') then strWhere := ' where ' + strWhere;
  Result := strWhere;
end;

procedure Tfrm_Fileinput_prezentquery.CheckBox_DateClick(Sender: TObject);
begin
  if (CheckBox_Date.Checked) then
  begin
    ComboBox_Operator.Enabled := true;
    CheckBox_Other.Checked := false;
    Edit_other.Enabled := false;
    ComboBox_Other.Enabled := false;
  end
  else
  begin
    ComboBox_Operator.Enabled := false;
  end;
end;

procedure Tfrm_Fileinput_prezentquery.CheckBox_OtherClick(Sender: TObject);
begin
  if (CheckBox_Other.Checked) then
  begin
    ComboBox_Operator.Enabled := false;
    CheckBox_Date.Checked := false;
    Edit_other.Enabled := true;
    ComboBox_Other.Enabled := true;
  end
  else
  begin
    Edit_other.Enabled := false;
    ComboBox_Other.Enabled := false;
  end;
end;



procedure Tfrm_Fileinput_prezentquery.BitBtn8Click(Sender: TObject);
begin
  Close;
end;

end.
