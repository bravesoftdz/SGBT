unit Fileinput_menbermatialUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, DBGrids, StdCtrls, Buttons, ExtCtrls, ComCtrls, Menus,
  DB, ADODB, DBCtrls, DBClient;

type
  Tfrm_Fileinput_menbermatial = class(TForm)
    Panel4: TPanel;
    Panel1: TPanel;
    DBGrid2: TDBGrid;
    Panel2: TPanel;
    BitBtn1: TBitBtn;
    Bit_Del: TBitBtn;
    Bit_Close: TBitBtn;
    Panel3: TPanel;
    Label1: TLabel;
    DateTimePicker_Start: TDateTimePicker;
    DateTimePicker_End: TDateTimePicker;
    ComboBox_Cardstate: TComboBox;
    ComboBox_other: TComboBox;
    Edit_other: TEdit;
    TimePicker_Start: TDateTimePicker;
    TimePicker_End: TDateTimePicker;
    PopupMenu1: TPopupMenu;
    N1111: TMenuItem;
    N11121: TMenuItem;
    Bit_Query: TBitBtn;
    DataSource_Newmenber: TDataSource;
    ADOQuery_newmenber: TADOQuery;
    CheckBox_Date: TCheckBox;
    CheckBox_Cardstate: TCheckBox;
    CheckBox_other: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure Bit_QueryClick(Sender: TObject);
    procedure CheckBox_otherClick(Sender: TObject);
    procedure CheckBox_CardstateClick(Sender: TObject);
    procedure CheckBox_DateClick(Sender: TObject);
    procedure DBGrid2DblClick(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure Bit_CloseClick(Sender: TObject);
    procedure Bit_DelClick(Sender: TObject);
  private
    { Private declarations }
   // procedure Initmenberlevel;
    procedure InitDataBase;
    procedure InitForm;
    function SetWhere: string;
    procedure Querylevel_name(S1: string);
  public
    { Public declarations }
  end;

var
  frm_Fileinput_menbermatial: Tfrm_Fileinput_menbermatial;

implementation
uses ICDataModule, ICtest_Main, ICCommunalVarUnit, ICmain, ICEventTypeUnit, Fileinput_menbermatialupdateUnit;
{$R *.dfm}

procedure Tfrm_Fileinput_menbermatial.FormCreate(Sender: TObject);
begin
  InitDataBase;
  InitForm; //初始化日期和时间
end;

procedure Tfrm_Fileinput_menbermatial.InitForm;

begin

  DateTimePicker_Start.Date := now;
  DateTimePicker_End.Date := now;
  TimePicker_Start.Time := now;
  TimePicker_End.Time := now;
end;

//初始化数据表

procedure Tfrm_Fileinput_menbermatial.InitDataBase;
var
  strSQL: string;
begin
  with ADOQuery_newmenber do begin
    Connection := DataModule_3F.ADOConnection_Main;
    Active := false;
    SQL.Clear;
    strSQL := 'select * from [TMemberInfo]';
    SQL.Add(strSQL);
    Active := True;
  end;
end;

//根据日期查询
//根据卡状态
//根据用户编号

function Tfrm_Fileinput_menbermatial.SetWhere: string;
var
  strWhere: string;
  strIsable: string; //卡状态
  strStartDate, strEndDate: string;
 // strdate_start,strdate_end,strtime_start,strtime_end,strdatetime_start,strdatetime_end:String;

begin
  strWhere := '';
  strStartDate := FormatDateTime('yyyy-MM-dd', DateTimePicker_Start.Date) + ' ' + FormatDateTime('hh:mm:ss', TimePicker_Start.Time);
  strEndDate := FormatDateTime('yyyy-MM-dd', DateTimePicker_End.Date) + ' ' + FormatDateTime('hh:mm:ss', TimePicker_End.Time);

   //按照发卡日期查询  一级条件
  if (CheckBox_Date.Checked) then begin
    strWhere := strWhere + 'OpenCardDT>=''' + strStartDate
      + ''' and OpenCardDT<=''' + strEndDate + '''';
  end;

    //按照卡状态查询   二级条件
  if (CheckBox_Cardstate.Checked) then begin
    if ComboBox_Cardstate.Text <> '全部' then
    begin
      if ComboBox_Cardstate.Text = '正常' then
        strIsable := '1';
      if ComboBox_Cardstate.Text = '损坏' then
        strIsable := '2';
      if ComboBox_Cardstate.Text = '退卡' then
        strIsable := '3';
      if ComboBox_Cardstate.Text = '冻结' then
        strIsable := '4';
    //if(strWhere<>'') then strWhere:= strWhere+' and ';
      strWhere := strWhere + ' IsAble=''' + strIsable + '''';
    end
    else
    begin
      strWhere := strWhere + ' IsAble in(1,2,3,4)';
    end;
  end;

    //按照其他条件查询   三级条件
  if (CheckBox_other.Checked) then begin
   // if(strWhere<>'') then strWhere:= strWhere+' and ';
    strWhere := strWhere + ' (MemberName=''' + Edit_other.Text + '''';
    strWhere := strWhere + ' or ';
    strWhere := strWhere + ' MemCardNo=''' + Edit_other.Text + ''')';
  end;


  if (strWhere <> '') then strWhere := ' where ' + strWhere;
  Result := strWhere;
end;

//查询记录事件

procedure Tfrm_Fileinput_menbermatial.Bit_QueryClick(Sender: TObject);
var
  strSQL: string;
begin
  strSQL := 'select * from [TMemberInfo] ' + SetWhere
    + ' order by [IDCardNo] ';
  with ADOQuery_newmenber do begin
    Active := False;
    SQL.Clear;
    SQL.Add(strSQL);
    try
      Active := True;
    except
      on e: Exception do ShowMessage(e.Message);
    end;
  end;
end;
//按其他条件查询

procedure Tfrm_Fileinput_menbermatial.CheckBox_otherClick(Sender: TObject);
begin
  if (CheckBox_other.Checked) then
  begin

    ComboBox_other.Enabled := true;
    Edit_other.Enabled := true;

    CheckBox_Cardstate.Checked := false;
    ComboBox_Cardstate.Enabled := false;


    CheckBox_Date.Checked := false;
    DateTimePicker_Start.Enabled := false;
    DateTimePicker_End.Enabled := false;
    TimePicker_Start.Enabled := false;
    TimePicker_End.Enabled := false;

  end
  else
  begin
    ComboBox_other.Enabled := false;
    Edit_other.Enabled := false;
  end;
end;
//按卡状态查询

procedure Tfrm_Fileinput_menbermatial.CheckBox_CardstateClick(Sender: TObject);
begin
  if (CheckBox_Cardstate.Checked) then
  begin
    ComboBox_Cardstate.Enabled := true;

    CheckBox_other.Checked := false;
    ComboBox_other.Enabled := false;
    Edit_other.Enabled := false;


    CheckBox_Date.Checked := false;
    DateTimePicker_Start.Enabled := false;
    DateTimePicker_End.Enabled := false;
    TimePicker_Start.Enabled := false;
    TimePicker_End.Enabled := false;
  end
  else
    ComboBox_Cardstate.Enabled := false;
end;
//按发卡日期查询

procedure Tfrm_Fileinput_menbermatial.CheckBox_DateClick(Sender: TObject);
begin
  if (CheckBox_Date.Checked) then
  begin
    DateTimePicker_Start.Enabled := true;
    DateTimePicker_End.Enabled := true;
    TimePicker_Start.Enabled := true;
    TimePicker_End.Enabled := true;

    ComboBox_Cardstate.Enabled := false;
    CheckBox_Cardstate.Checked := false;

    CheckBox_other.Checked := false;
    ComboBox_other.Enabled := false;
    Edit_other.Enabled := false;
  end
  else
  begin
    DateTimePicker_Start.Enabled := false;
    DateTimePicker_End.Enabled := false;
    TimePicker_Start.Enabled := false;
    TimePicker_End.Enabled := false;
  end;
end;

procedure Tfrm_Fileinput_menbermatial.DBGrid2DblClick(Sender: TObject);
begin
  frm_Fileinput_menbermatialupdate.Edit01.Text := DBGrid2.DataSource.DataSet.FieldByName('MemCardNo').AsString;
  frm_Fileinput_menbermatialupdate.Edit02.Text := DBGrid2.DataSource.DataSet.FieldByName('MemberName').AsString;
  frm_Fileinput_menbermatialupdate.Edit03.Text := DBGrid2.DataSource.DataSet.FieldByName('Mobile').AsString;
  frm_Fileinput_menbermatialupdate.Edit04.Text := DBGrid2.DataSource.DataSet.FieldByName('InfoKey').AsString;
  frm_Fileinput_menbermatialupdate.Edit05.Text := DBGrid2.DataSource.DataSet.FieldByName('cUserNo').AsString;
  frm_Fileinput_menbermatialupdate.Edit06.Text := DBGrid2.DataSource.DataSet.FieldByName('OpenCardDT').AsString;
  frm_Fileinput_menbermatialupdate.Edit07.Text := DBGrid2.DataSource.DataSet.FieldByName('EffectiveDT').AsString;
  frm_Fileinput_menbermatialupdate.Edit08.Text := DBGrid2.DataSource.DataSet.FieldByName('IsAble').AsString;
  frm_Fileinput_menbermatialupdate.Edit09.Text := DBGrid2.DataSource.DataSet.FieldByName('CardAmount').AsString;
  frm_Fileinput_menbermatialupdate.Edit10.Text := DBGrid2.DataSource.DataSet.FieldByName('TickAmount').AsString;
  frm_Fileinput_menbermatialupdate.Edit11.Text := DBGrid2.DataSource.DataSet.FieldByName('Deposit').AsString;
 // frm_Fileinput_menbermatialupdate.Edit12.Text := DBGrid2.DataSource.DataSet.FieldByName('Deposit').AsString;

  frm_Fileinput_menbermatialupdate.Comb_Month.Text := Copy(DBGrid2.DataSource.DataSet.FieldByName('Birthday').AsString, 1, 2);
  frm_Fileinput_menbermatialupdate.Comb_Day.Text := Copy(DBGrid2.DataSource.DataSet.FieldByName('Birthday').AsString, 4, 2);

  if DBGrid2.DataSource.DataSet.FieldByName('Sex').AsString = '1' then
    frm_Fileinput_menbermatialupdate.rgSex.ItemIndex := 1
  else
    frm_Fileinput_menbermatialupdate.rgSex.ItemIndex := 0;

  if (StrToInt(DBGrid2.DataSource.DataSet.FieldByName('IsAble').AsString) = 4) then
    frm_Fileinput_menbermatialupdate.rgIable.ItemIndex := 0
  else
    frm_Fileinput_menbermatialupdate.rgIable.ItemIndex := 1;
  Querylevel_name(DBGrid2.DataSource.DataSet.FieldByName('LevNum').AsString);
//  Bit_Update.Enabled := True;
  frm_Fileinput_menbermatialupdate.Show;
end;

procedure Tfrm_Fileinput_menbermatial.BitBtn1Click(Sender: TObject);
begin
  frm_Fileinput_menbermatialupdate.Edit01.Text := DBGrid2.DataSource.DataSet.FieldByName('MemCardNo').AsString;
  frm_Fileinput_menbermatialupdate.Edit02.Text := DBGrid2.DataSource.DataSet.FieldByName('MemberName').AsString;
  frm_Fileinput_menbermatialupdate.Edit03.Text := DBGrid2.DataSource.DataSet.FieldByName('Mobile').AsString;
  frm_Fileinput_menbermatialupdate.Edit04.Text := DBGrid2.DataSource.DataSet.FieldByName('InfoKey').AsString;
  frm_Fileinput_menbermatialupdate.Edit05.Text := DBGrid2.DataSource.DataSet.FieldByName('cUserNo').AsString;
  frm_Fileinput_menbermatialupdate.Edit06.Text := DBGrid2.DataSource.DataSet.FieldByName('OpenCardDT').AsString;
  frm_Fileinput_menbermatialupdate.Edit07.Text := DBGrid2.DataSource.DataSet.FieldByName('EffectiveDT').AsString;
  frm_Fileinput_menbermatialupdate.Edit08.Text := DBGrid2.DataSource.DataSet.FieldByName('IsAble').AsString;
  frm_Fileinput_menbermatialupdate.Edit09.Text := DBGrid2.DataSource.DataSet.FieldByName('CardAmount').AsString;
  frm_Fileinput_menbermatialupdate.Edit10.Text := DBGrid2.DataSource.DataSet.FieldByName('TickAmount').AsString;
  frm_Fileinput_menbermatialupdate.Edit11.Text := DBGrid2.DataSource.DataSet.FieldByName('Deposit').AsString;
 // frm_Fileinput_menbermatialupdate.Edit12.Text := DBGrid2.DataSource.DataSet.FieldByName('Deposit').AsString;

  frm_Fileinput_menbermatialupdate.Comb_Month.Text := Copy(DBGrid2.DataSource.DataSet.FieldByName('Birthday').AsString, 1, 2);
  frm_Fileinput_menbermatialupdate.Comb_Day.Text := Copy(DBGrid2.DataSource.DataSet.FieldByName('Birthday').AsString, 4, 2);

  if DBGrid2.DataSource.DataSet.FieldByName('Sex').AsString = '1' then
    frm_Fileinput_menbermatialupdate.rgSex.ItemIndex := 1
  else
    frm_Fileinput_menbermatialupdate.rgSex.ItemIndex := 0;

  if (DBGrid2.DataSource.DataSet.FieldByName('IsAble').AsString = '4') then
    frm_Fileinput_menbermatialupdate.rgIable.ItemIndex := 0
  else
    frm_Fileinput_menbermatialupdate.rgIable.ItemIndex := 1;

  Querylevel_name(DBGrid2.DataSource.DataSet.FieldByName('LevNum').AsString);
//  Bit_Update.Enabled := True;
  frm_Fileinput_menbermatialupdate.Show;
end;

 //查询等级名称

procedure Tfrm_Fileinput_menbermatial.Querylevel_name(S1: string);
var
  ADOQTemp: TADOQuery;
  strSQL: string;
  nameStr: string;
  i: integer;
begin

  ADOQTemp := TADOQuery.Create(nil);
  strSQL := 'select distinct [LevName] from [TLevel] where LevNo=''' + S1 + ''''; //考虑追加同名的处理
  with ADOQTemp do
  begin
    Connection := DataModule_3F.ADOConnection_Main;
    SQL.Clear;
    SQL.Add(strSQL);
    Active := True;
    frm_Fileinput_menbermatialupdate.Comb_menberlevel.text := '';
    while not Eof do
    begin
      frm_Fileinput_menbermatialupdate.Comb_menberlevel.text := FieldByName('LevName').AsString;
      Next;
    end;
  end;
  FreeAndNil(ADOQTemp);

end;

procedure Tfrm_Fileinput_menbermatial.Bit_CloseClick(Sender: TObject);
begin
  close;
end;

procedure Tfrm_Fileinput_menbermatial.Bit_DelClick(Sender: TObject);
var
  strTemp: string;
begin
  strTemp := ADOQuery_newmenber.FieldByName('MemberName').AsString;
  if (MessageDlg('确实要删除 用户名为' + strTemp + ' 的相关记录吗?', mtConfirmation, [mbYes, mbNo], 0) = mrYes) then
    DBGrid2.DataSource.DataSet.Delete;
end;

end.
