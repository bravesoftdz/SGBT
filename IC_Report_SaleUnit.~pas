unit IC_Report_SaleUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DBGridEhGrouping, GridsEh, DBGridEh, StdCtrls, Buttons,
  ComCtrls, ExtCtrls, DB, ADODB, Grids, DBGrids;

type
  Tfrm_IC_Report_SaleDetial = class(TForm)
    Panel8: TPanel;
    Panel2: TPanel;
    pgcMachinerecord: TPageControl;
    TabSheet1: TTabSheet;
    Panel1: TPanel;
    Panel7: TPanel;
    DBGridEh_QueryRecord: TDBGridEh;
    Panel9: TPanel;
    Label4: TLabel;
    Label6: TLabel;
    Combo_Sel: TComboBox;
    Panel11: TPanel;
    BitBtn3: TBitBtn;
    BitBtn4: TBitBtn;
    BitBtn6: TBitBtn;
    Label5: TLabel;
    DateTimePicker_Start_Menberinfo: TDateTimePicker;
    Label9: TLabel;
    DateTimePicker_End_Menberinfo: TDateTimePicker;
    TimePicker_End_Menberinfo: TDateTimePicker;
    DataSource_Recrod: TDataSource;
    ADOQuery_Recrod: TADOQuery;
    DataSource_QueryRecord: TDataSource;
    ADOQuery_QueryRecord: TADOQuery;
    Panel_GameMC: TPanel;
    Label7: TLabel;
    Combo_MCname: TComboBox;
    Label8: TLabel;
    ComboBox_CardMC_ID: TComboBox;
    Panel_Man: TPanel;
    Label11: TLabel;
    Combo_OP: TComboBox;
    TabSheet2: TTabSheet;
    Panel3: TPanel;
    DBGridEh1: TDBGridEh;
    Panel4: TPanel;
    Panel5: TPanel;
    Label1: TLabel;
    Label3: TLabel;
    Label10: TLabel;
    DateTimePicker_Start: TDateTimePicker;
    DateTimePicker_End: TDateTimePicker;
    TimePicker_End: TDateTimePicker;
    Panel12: TPanel;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    BitBtn5: TBitBtn;
    Edit1: TEdit;
    TimePicker_Start_Menberinfo: TDateTimePicker;
    TimePicker_Start: TDateTimePicker;
    Panel_Menber: TPanel;
    Label2: TLabel;
    ComboBox1: TComboBox;
    DBGridEh2: TDBGridEh;
    DBGridEh3: TDBGridEh;
    DBGridEh4: TDBGridEh;
    Label12: TLabel;
    cob_recharge: TComboBox;
    Panel_Meber: TPanel;
    Label14: TLabel;
    ComboBox4: TComboBox;
    Panel_Operator: TPanel;
    Label13: TLabel;
    cob_recharge_operator: TComboBox;
    TabSheet3: TTabSheet;
    Panel6: TPanel;
    Panel10: TPanel;
    Panel13: TPanel;
    Panel14: TPanel;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    DTP_refund_start_date: TDateTimePicker;
    dtp_refund_end_date: TDateTimePicker;
    dtp_refund_end_time: TDateTimePicker;
    dtp_refund_start_time: TDateTimePicker;
    cob_refund: TComboBox;
    Panel15: TPanel;
    Label19: TLabel;
    ComboBox6: TComboBox;
    Panel16: TPanel;
    Label20: TLabel;
    cob_refund_operator: TComboBox;
    Panel17: TPanel;
    Bit_refund_query: TBitBtn;
    bit_refund_cancel: TBitBtn;
    bit_refund_print: TBitBtn;
    Panel18: TPanel;
    DBGrid_refund: TDBGrid;
    DataSource_refund: TDataSource;
    ADOQuery_refund: TADOQuery;
    procedure bit_refund_cancel_click(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Combo_SelClick(Sender: TObject);
    procedure Combo_MCnameClick(Sender: TObject);
    procedure cob_rechargeClick(Sender: TObject);
    procedure pgcMachinerecordChange(Sender: TObject);
    procedure Bit_charge_queryClick(Sender: TObject);
    procedure Bit_refund_queryClick(Sender: TObject);

  private
    { Private declarations }
    procedure InitCombo_OP;
    procedure InitCombo_MCname;
    procedure InitCarMC_ID(Str1: string);
    procedure InitCombo_MCname_EBInc; //初始化充值查询
    procedure InitCombo_Menber;
    procedure QueryBy_NOMenberControl;
    procedure QueryBy_MenberControl;
    procedure init_refund_history ;
  public
    { Public declarations }
  end;

var
  frm_IC_Report_SaleDetial: Tfrm_IC_Report_SaleDetial;
  Query_By_MenberNO, Query_By_UserNO: string;
implementation
uses ICDataModule, ICCommunalVarUnit, ICFunctionUnit, ICmain, ICEventTypeUnit, Fileinput_machinerecord_gamenameUnit,
  Fileinput_gamenameinputUnit, Fileinput_menbermatialupdateUnit;

{$R *.dfm}

procedure Tfrm_IC_Report_SaleDetial.bit_refund_cancel_click(Sender: TObject);
begin
  Close;
end;

//初始化退币记录
procedure Tfrm_IC_Report_SaleDetial.init_refund_history;
var
  strSQL,strwhere,strrefundstartdate,strrefundenddate: string;
begin
  strrefundstartdate := FormatDateTime('yyyy-mm-dd', dtp_refund_start_date.Date);
  strrefundenddate := FormatDateTime('yyyy-MM-dd', dtp_refund_end_date.Date) + ' ' + FormatDateTime('hh:mm:ss', dtp_refund_end_time.Time);

  strSQL := 'select * from tmembedetail where ';
  strwhere := strWhere + ' ( tuibi_time>=''' + strrefundstartdate + ''' and tuibi_time<=''' + strrefundenddate + ''')';
  strSQL := strSQL + strwhere +' order by tuibi_time desc ';

  Edit1.Text := strSQL;
  with ADOQuery_Refund do
  begin
    Connection := DataModule_3F.ADOConnection_Main;
    Active := false;
    SQL.Clear;
    SQL.Add(strSQL);
    Active := True;
  end;
end;

procedure Tfrm_IC_Report_SaleDetial.InitCombo_OP; //初始化游戏名称下来框
var
  ADOQTemp: TADOQuery;
  strSQL: string;
begin
  ADOQTemp := TADOQuery.Create(nil);
  strSQL := 'select distinct[Scaner] from [3F_BARFLOW]';
  with ADOQTemp do
  begin
    Connection := DataModule_3F.ADOConnection_Main;
    SQL.Clear;
    SQL.Add(strSQL);
    Active := True;
    Combo_OP.Items.Clear;
    Combo_OP.Items.Add('全部');
    while not Eof do
    begin
      Combo_OP.Items.Add(TrimRight(FieldByName('Scaner').AsString));
      Next;
    end;
  end;
  FreeAndNil(ADOQTemp);
end;

procedure Tfrm_IC_Report_SaleDetial.InitCombo_MCname; //初始化游戏名称下来框
var
  ADOQTemp: TADOQuery;
  strSQL: string;
begin
  ADOQTemp := TADOQuery.Create(nil);
  strSQL := 'select distinct[GameName] from [3F_BARFLOW] ';
  with ADOQTemp do
  begin
    Connection := DataModule_3F.ADOConnection_Main;
    SQL.Clear;
    SQL.Add(strSQL);
    Active := True;
    Combo_MCname.Items.Clear;
    Combo_MCname.Items.Add('全部');
    while not Eof do
    begin
      Combo_MCname.Items.Add(TrimRight(FieldByName('GameName').AsString));
      Next;
    end;
  end;
  FreeAndNil(ADOQTemp);
end;

procedure Tfrm_IC_Report_SaleDetial.InitCombo_MCname_EBInc; //初始化营业员查询
var
  ADOQTemp: TADOQuery;
  strSQL: string;
begin

  ADOQTemp := TADOQuery.Create(nil);
  if INit_Wright.MenberControl_short = '0' then
  begin
    strSQL := 'select distinct[cUserNo] from [EBdetail] ';
  end
  else
  begin
    strSQL := 'select distinct[UserNo] from [3F_SysUser] ';
  end;
  with ADOQTemp do
  begin
    Connection := DataModule_3F.ADOConnection_Main;
    SQL.Clear;
    SQL.Add(strSQL);
    Active := True;
    Combo_OP.Items.Clear;
    cob_recharge.Items.Clear;
    Combo_OP.Items.Add('全部');
    cob_recharge.Items.Add('全部');
    while not Eof do
    begin
      if INit_Wright.MenberControl_short = '0' then
      begin
        Combo_OP.Items.Add(FieldByName('cUserNo').AsString);
        cob_recharge.Items.Add(FieldByName('cUserNo').AsString);
      end
      else
      begin
        Combo_OP.Items.Add(FieldByName('UserNo').AsString);
        cob_recharge.Items.Add(FieldByName('UserNo').AsString);
      end;

      Next;
    end;
  end;
  FreeAndNil(ADOQTemp);
end;

procedure Tfrm_IC_Report_SaleDetial.InitCombo_Menber; //初始化充值查询
var
  ADOQTemp: TADOQuery;
  strSQL: string;
begin

  ADOQTemp := TADOQuery.Create(nil);
  if INit_Wright.MenberControl_short = '0' then
  begin
    strSQL := 'select distinct[cUserNo] from [EBdetail] ';
  end
  else
  begin
    strSQL := 'select distinct[MemberName] from [TMemberInfo] ';
  end;
  with ADOQTemp do
  begin
    Connection := DataModule_3F.ADOConnection_Main;
    SQL.Clear;
    SQL.Add(strSQL);
    Active := True;
    ComboBox1.Items.Clear;
    ComboBox4.Items.Clear;
    ComboBox1.Items.Add('全部');
    ComboBox4.Items.Add('全部');
    while not Eof do
    begin
      if INit_Wright.MenberControl_short = '0' then
      begin
        ComboBox1.Items.Add(FieldByName('cUserNo').AsString);
        ComboBox4.Items.Add(FieldByName('cUserNo').AsString);
      end
      else
      begin
        ComboBox1.Items.Add(FieldByName('MemberName').AsString);
        ComboBox4.Items.Add(FieldByName('MemberName').AsString);
      end;

      Next;
    end;
  end;
  FreeAndNil(ADOQTemp);
end;

procedure Tfrm_IC_Report_SaleDetial.Combo_MCnameClick(
  Sender: TObject);
begin

  if length(Trim(Combo_MCname.Text)) = 0 then
  begin
    ShowMessage('机台游戏名称不能空');
    exit;
  end
  else
  begin
    InitCarMC_ID(Combo_MCname.Text);

  end;
end;

//初始化机台编号
procedure Tfrm_IC_Report_SaleDetial.InitCarMC_ID(Str1: string);
var
  ADOQTemp: TADOQuery;
  strSQL, comp: string;
begin


  comp := '1';
  ADOQTemp := TADOQuery.Create(nil);
  strSQL := 'select distinct[MacNo] from [3F_BARFLOW] where ([GameName]=''' + Combo_MCname.Text + ''')';
  with ADOQTemp do begin
    Connection := DataModule_3F.ADOConnection_Main;
    SQL.Clear;
    SQL.Add(strSQL);
    Active := True;
    ComboBox_CardMC_ID.Items.Clear;
    while not Eof do begin
      ComboBox_CardMC_ID.Items.Add(FieldByName('MacNo').AsString);
      Next;
    end;
  end;
  FreeAndNil(ADOQTemp);

end;



procedure Tfrm_IC_Report_SaleDetial.BitBtn3Click(Sender: TObject);
var
  strSQL: string;
  LastRecord: string;
  strWhere: string;
  strStartDate, strEndDate, StrMenberNO, StrUserNO: string;
begin
  LastRecord := '1'; //最新记录标志位

  strWhere := '';

  strWhere := strWhere + 'select * ';
  strWhere := strWhere + 'from [3F_BARFLOW] '; //扫描记录，机台位卡头ID
  strWhere := strWhere + 'where  ';

        //条件一 时间
  strStartDate := FormatDateTime('yyyy-MM-dd', DateTimePicker_Start_Menberinfo.Date) + ' ' + FormatDateTime('hh:mm:ss', TimePicker_Start_Menberinfo.Time);
  strEndDate := FormatDateTime('yyyy-MM-dd', DateTimePicker_End_Menberinfo.Date) + ' ' + FormatDateTime('hh:mm:ss', TimePicker_End_Menberinfo.Time);
  strWhere := strWhere + ' ( DATETIME_SCAN>=''' + strStartDate + ''' and DATETIME_SCAN<=''' + strEndDate + ''')';


      //条件二
  if Combo_Sel.Text <> '全部' then
  begin
    if Combo_Sel.Text = '机台编号' then
    begin
      if ComboBox_CardMC_ID.Text <> '全部' then
      begin
        strWhere := strWhere + ' and MacNo=''' + ComboBox_CardMC_ID.Text + '''';
      end;
    end
      //Query_By_UserNO:='1'
    else if Combo_Sel.Text = '营业员编号' then
    begin
      StrUserNO := DataModule_3F.Query_UserNo(TrimRight(Combo_OP.Text));
      strWhere := strWhere + ' and Scaner=''' + StrUserNO + '''';
    end
    else if Combo_Sel.Text = '会员编号' then
    begin

      StrMenberNO := DataModule_3F.Query_MenberNo(TrimRight(ComboBox1.Text));
      strWhere := strWhere + ' and IDCardNo=''' + StrMenberNO + '''';
    end
  end;
  strSQL := '' + strWhere + '';
  //Edit1.Text:=strSQL;
  //showmessage(strSQL);
  with ADOQuery_QueryRecord do
  begin
    Connection := DataModule_3F.ADOConnection_Main;
    Active := false;
    SQL.Clear;
    SQL.Add(strSQL);
    Active := True;
  end;

end;

procedure Tfrm_IC_Report_SaleDetial.FormShow(Sender: TObject);
begin
  DateTimePicker_Start_Menberinfo.Date := StrToDate(copy(FormatDateTime('yyyy-MM-dd HH:mm:ss', now), 1, 10));
  DateTimePicker_End_Menberinfo.Date := StrToDate(copy(FormatDateTime('yyyy-MM-dd HH:mm:ss', now), 1, 10));
  TimePicker_Start_Menberinfo.Time := StrToTime('00:00:00');;
  TimePicker_End_Menberinfo.Time := StrToTime(copy(FormatDateTime('yyyy-MM-dd HH:mm:ss', now), 12, 8));

  DateTimePicker_Start.Date := StrToDate(copy(FormatDateTime('yyyy-MM-dd HH:mm:ss', now), 1, 10));
  DateTimePicker_End.Date := StrToDate(copy(FormatDateTime('yyyy-MM-dd HH:mm:ss', now), 1, 10));
  TimePicker_Start.Time := StrToTime('00:00:00');
  TimePicker_End.Time := StrToTime(copy(FormatDateTime('yyyy-MM-dd HH:mm:ss', now), 12, 8));




  //初始化refund date/time
  dtp_refund_start_date.Date :=  StrToDate(copy(FormatDateTime('yyyy-MM-dd HH:mm:ss', now), 1, 10));
  dtp_refund_start_time.Time := StrToTime('00:00:00');
  dtp_refund_end_date.Date :=  StrToDate(copy(FormatDateTime('yyyy-MM-dd HH:mm:ss', now), 1, 10));
  dtp_refund_end_time.Time := StrToTime(copy(FormatDateTime('yyyy-MM-dd HH:mm:ss', now), 12, 8));


  InitCombo_OP;
  InitCombo_MCname;
  InitCombo_MCname_EBInc; //营业员
  InitCombo_Menber; //会员

  {if INit_Wright.MenberControl_short = '0' then
  begin
    DBGridEh1.Visible := true;
    DBGridEh3.Visible := false;
    Panel_Operator.Visible := true;
                    //QueryBy_NOMenberControl;
  end
  else
  }
  
  begin
    DBGridEh1.Visible := false;
    DBGridEh3.Visible := true;
    Panel_Operator.Visible := false;
                    //QueryBy_MenberControl;
  end;
end;

procedure Tfrm_IC_Report_SaleDetial.Combo_SelClick(Sender: TObject);
begin
  if Combo_Sel.text = '机台编号' then
  begin
    Panel_GameMC.visible := true;
    Panel_Man.visible := false;
    Panel_Menber.visible := false;
    Query_By_UserNO := '3';
  end
  else if Combo_Sel.text = '营业员编号' then
  begin
    Panel_GameMC.visible := false;
    Panel_Man.visible := true;
    Panel_Menber.visible := false;
    Query_By_UserNO := '1';
  end
  else if Combo_Sel.text = '会员编号' then
  begin
    Panel_GameMC.visible := false;
    Panel_Man.visible := false;
    Panel_Menber.visible := true;
    Query_By_UserNO := '0';
  end
  else
  begin
    Panel_GameMC.visible := false;
    Panel_Man.visible := false;
    Panel_Menber.visible := true;
    Query_By_UserNO := '2';
  end;
end;

//会员控制查询
procedure Tfrm_IC_Report_SaleDetial.QueryBy_MenberControl;
var
  strSQL: string;
  LastRecord: string;
  strWhere: string;
  strStartDate, strEndDate, StrUserNO: string;
begin
  LastRecord := '1'; //最新记录标志位

  strWhere := '';

  strWhere := strWhere + 'select * ';
  strWhere := strWhere + 'from [TMembeDetail] '; //扫描记录，机台位卡头ID
  strWhere := strWhere + 'where  ';

        //条件一
  strStartDate := FormatDateTime('yyyy-MM-dd', DateTimePicker_Start.Date) + ' ' + FormatDateTime('hh:mm:ss', TimePicker_Start.Time);
  strEndDate := FormatDateTime('yyyy-MM-dd', DateTimePicker_End.Date) + ' ' + FormatDateTime('hh:mm:ss', TimePicker_End.Time);
  strWhere := strWhere + ' ( GetTime>=''' + strStartDate + ''' and GetTime<=''' + strEndDate + ''')';


      //条件二 营业员编号
  if Query_By_MenberNO = '1' then
  begin
    if cob_recharge.Text <> '全部' then
    begin
      StrUserNO := DataModule_3F.Query_UserNo(TrimRight(cob_recharge.Text));
      strWhere := strWhere + ' and cUserNo=''' + StrUserNO + ''' ';
    end;
  end
  else
  begin
      //条件三 会员编号
    if ComboBox4.Text <> '全部' then
    begin
      StrUserNO := DataModule_3F.Query_MenberNo(TrimRight(ComboBox4.Text));
      strWhere := strWhere + ' and IDCardNo=''' + StrUserNO + ''' ';
    end;
  end;

  strWhere := strWhere + ' order by MemberName ASC ';
  strSQL := '' + strWhere + '';
  Edit1.Text := strSQL;
  with ADOQuery_Recrod do
  begin
    Connection := DataModule_3F.ADOConnection_Main;
    Active := false;
    SQL.Clear;
    SQL.Add(strSQL);
    Active := True;
  end;

end;


procedure Tfrm_IC_Report_SaleDetial.QueryBy_NOMenberControl;
var
  strSQL: string;
  LastRecord: string;
  strWhere: string;
  strStartDate, strEndDate: string;
begin
  LastRecord := '1'; //最新记录标志位

  strWhere := '';

  strWhere := strWhere + 'select * ';
  strWhere := strWhere + 'from [EBdetail] '; //扫描记录，机台位卡头ID
  strWhere := strWhere + 'where  ';

        //条件一
  strStartDate := FormatDateTime('yyyy-MM-dd', DateTimePicker_Start.Date) + ' ' + FormatDateTime('hh:mm:ss', TimePicker_Start.Time);
  strEndDate := FormatDateTime('yyyy-MM-dd', DateTimePicker_End.Date) + ' ' + FormatDateTime('hh:mm:ss', TimePicker_End.Time);
  strWhere := strWhere + ' ( ID_INCttime>=''' + strStartDate + ''' and ID_INCttime<=''' + strEndDate + ''')';


      //条件二
  if ComboBox4.Text <> '全部' then
  begin
    strWhere := strWhere + ' and cUserNo=''' + ComboBox4.Text + '''';
  end;
  strSQL := '' + strWhere + '';
  Edit1.Text := strSQL;
  with ADOQuery_Recrod do
  begin
    Connection := DataModule_3F.ADOConnection_Main;
    Active := false;
    SQL.Clear;
    SQL.Add(strSQL);
    Active := True;
  end;

end;
{
procedure Tfrm_IC_Report_SaleDetial.BitBtnbit_refund_query_clickr: TObject);
begin
  if INit_Wright.MenberControl_short = '0' then   //会员卡
  begin
    DBGridEh1.Visible := true;
    DBGridEh3.Visible := false;
    QueryBy_NOMenberControl;
  end
  else
  begin
    DBGridEh1.Visible := false;
    DBGridEh3.Visible := true;
    QueryBy_MenberControl;
  end;
end;

}

procedure Tfrm_IC_Report_SaleDetial.cob_rechargeClick(Sender: TObject);
begin
  if cob_recharge_operator.text = '营业员编号' then
  begin
    Panel_Meber.visible := false;
    Panel_Operator.visible := true;
    Query_By_MenberNO := '1';

  end
  else if cob_recharge_operator.text = '会员编号' then
  begin
    Panel_Operator.visible := false;
    Panel_Meber.visible := true;
    Query_By_MenberNO := '0';
  end
  else
  begin
    Panel_Meber.visible := false;
    Panel_Operator.visible := false;
  end;
end;

procedure Tfrm_IC_Report_SaleDetial.pgcMachinerecordChange(
  Sender: TObject);
begin
  //init_refund_history;
    //do nothing

end;

procedure Tfrm_IC_Report_SaleDetial.Bit_refund_queryClick(Sender: TObject);
var
  strSQL: string;
  LastRecord: string;
  strWhere: string;
  strStartDate, strEndDate, StrUserNO: string;
begin
  LastRecord := '1'; //最新记录标志位

 strWhere := ' select * from [TMembeDetail] where  ';
  //strWhere := ' select * from [t_refunddetail] where  ';

  //条件一
  strStartDate := FormatDateTime('yyyy-MM-dd', dtp_refund_start_date.Date) + ' ' + FormatDateTime('hh:mm:ss', dtp_refund_start_time.Time);
  strEndDate := FormatDateTime('yyyy-MM-dd', dtp_refund_end_date.Date) + ' ' + FormatDateTime('hh:mm:ss', dtp_refund_end_time.Time);
  strWhere := strWhere + ' ( tuibi_time>=''' + strStartDate + ''' and tuibi_time<=''' + strEndDate + ''')';
  strWhere := strWhere + ' and id_usercard_tuibi_flag=''1'' order by tuibi_time ASC ';
//  strWhere := strWhere + ' order by tuibi_time ASC ';
  strSQL := '' + strWhere + '';

  ICFunction.loginfo('strRefundSQLDetail:   ' + strSQL);

  with ADOQuery_Refund do
  begin
    Connection := DataModule_3F.ADOConnection_Main;
    Active := false;
    SQL.Clear;
    SQL.Add(strSQL);
    Active := True;
  end;
end;

procedure Tfrm_IC_Report_SaleDetial.Bit_charge_queryClick(Sender: TObject);
begin
  //here
 { if INit_Wright.MenberControl_short = '0' then
  begin
    DBGridEh1.Visible := true;
    DBGridEh3.Visible := false;
    QueryBy_NOMenberControl;
  end
  else
  }
  begin
    DBGridEh1.Visible := false;
    DBGridEh3.Visible := true;
    QueryBy_MenberControl;
  end;

end;


end.
