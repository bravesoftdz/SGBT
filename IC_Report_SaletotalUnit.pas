unit IC_Report_SaletotalUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DBGridEhGrouping, GridsEh, DBGridEh, StdCtrls, Buttons,
  ComCtrls, ExtCtrls, DB, ADODB, SPComm, Grids, DBGrids;

type
  TfrmReport = class(TForm)
    Panel2: TPanel;
    pgcMachinerecord: TPageControl;
    Tab_Gamenameinput: TTabSheet;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    Panel6: TPanel;
    Panel7: TPanel;
    Panel4: TPanel;
    Label1: TLabel;
    Panel5: TPanel;
    BitBtn5: TBitBtn;
    Panel1: TPanel;
    Panel3: TPanel;
    Panel8: TPanel;
    Panel12: TPanel;
    BitBtn6: TBitBtn;
    Panel13: TPanel;
    Panel14: TPanel;
    Panel15: TPanel;
    Label11: TLabel;
    Panel19: TPanel;
    btnSumBarFlow: TBitBtn;
    BitBtn9: TBitBtn;
    Label6: TLabel;
    Label2: TLabel;
    Label10: TLabel;
    DateTimePicker_Start_Menberinfo: TDateTimePicker;
    Label9: TLabel;
    DateTimePicker_End_Menberinfo: TDateTimePicker;
    TimePicker_End_Menberinfo: TDateTimePicker;
    dsCoinRecharge: TDataSource;
    ADOQCoinRecharge: TADOQuery;
    dsBarFlow: TDataSource;
    ADOQBarFlow: TADOQuery;
    DateTimePicker_Start: TDateTimePicker;
    Label4: TLabel;
    DateTimePicker_End: TDateTimePicker;
    TimePicker_End: TDateTimePicker;
    Label7: TLabel;
    dtpTotalEndDate: TDateTimePicker;
    dtpTotalBeginDate: TDateTimePicker;
    TimePicker_Start: TDateTimePicker;
    TimePicker_Start_Menberinfo: TDateTimePicker;
    dgCoinRecharge: TDBGridEh;
    DBGridEh3: TDBGridEh;
    btnSumRecharge: TBitBtn;
    btnTotal: TBitBtn;
    GroupBox1: TGroupBox;
    Label_input: TLabel;
    Label_output: TLabel;
    Label_in: TLabel;
    Lab_Input: TLabel;
    Lab_output: TLabel;
    Lab_IN: TLabel;
    Label24: TLabel;
    Label25: TLabel;
    BeginDate: TLabel;
    EndDate: TLabel;
    Shape1: TShape;
    Lab_refund: TLabel;
    Label8: TLabel;
    Label_Refund: TLabel;
    dtpTotalBeginTime: TDateTimePicker;
    dtpTotalEndTime: TDateTimePicker;
    dbgrdBarFlow: TDBGrid;
    lblTotal: TLabel;
    edtBarFlowTotal: TEdit;
    lbl1: TLabel;
    edtCoinRechargeTotal: TEdit;
    ts1: TTabSheet;
    grp1: TGroupBox;
    pnl1: TPanel;
    pnl2: TPanel;
    lbl3: TLabel;
    lbl4: TLabel;
    lbl5: TLabel;
    lblInfo: TLabel;
    dtpRefundStartDate: TDateTimePicker;
    dtpRefundEndDate: TDateTimePicker;
    dtpRefundEndTime: TDateTimePicker;
    dtpRefundStartTime: TDateTimePicker;
    pnl3: TPanel;
    btn1: TBitBtn;
    btnSumRefund: TBitBtn;
    ADOQCoinRefund: TADOQuery;
    dsCoinRefund: TDataSource;
    dgCoinRefund: TDBGrid;
    lbl2: TLabel;
    edtRefundTotal: TEdit;
    procedure Bit_FunctionMCClick(Sender: TObject);
    procedure Bit_Close_MenberinfoClick(Sender: TObject);
    procedure BitBtn5Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
//    procedure Combo_MCnameClick(Sender: TObject);
    procedure btnSumBarFlowClick(Sender: TObject);
    procedure btnSumRechargeClick(Sender: TObject);
//    procedure Combo_SelClick(Sender: TObject);
//    procedure FormClose(Sender: TObject; var Action: TCloseAction);

//    procedure ComboBox_SEL_INCClick(Sender: TObject);
    procedure btnTotalClick(Sender: TObject);
//    procedure BitBtn_DeleteClick(Sender: TObject);
//    procedure comReaderReceiveData(Sender: TObject; Buffer: Pointer;        BufferLength: Word);
//    procedure ComboBox_DelClick(Sender: TObject);
//    procedure Combo_MCname_DelClick(Sender: TObject);
//    procedure btnClearRechargeClick(Sender: TObject);
//    procedure btnClearBarFlowClick(Sender: TObject);
    procedure BitBtn4Click(Sender: TObject);
    function func_getfactor(strInput: string; strOutput: string): integer;
    procedure btnSumRefundClick(Sender: TObject);


  private
    { Private declarations }
//    procedure InitCombo_OP;
//    procedure InitCombo_MCname;
//    procedure InitCarMC_ID(Str1: string);
//    procedure InitCarMC_ID_Del(Str1: string);
//    procedure InitCombo_MCname_EBInc; //初始化充值查询
    //procedure Pan_Shape(strInput: string; strOutput: string);overload;
    procedure Pan_Shape(strInput: string; strRefund: string; strOutput: string); overload;
    procedure InitPan_Shape(strDatebegin: string; strDateend: string);

//    procedure DeleteTestDataFromTable;
  public
    { Public declarations }
  end;

var
  frmReport: TfrmReport;
  orderLst, recDataLst, recData_fromICLst: Tstrings;

implementation
uses ICDataModule, ICCommunalVarUnit, ICFunctionUnit, ICmain, ICEventTypeUnit, Fileinput_machinerecord_gamenameUnit,
  Fileinput_gamenameinputUnit, Fileinput_menbermatialupdateUnit,
  IC_Report_FunctionMCUnit;

{$R *.dfm}

procedure TfrmReport.Bit_FunctionMCClick(Sender: TObject);
begin
  frm_IC_Report_FunctionMC.show;
end;

procedure TfrmReport.Bit_Close_MenberinfoClick(
  Sender: TObject);
begin
  Close;
end;

//取消

procedure TfrmReport.BitBtn5Click(Sender: TObject);
begin
  close;
end;





procedure TfrmReport.FormShow(Sender: TObject);
var

  strStartDate, strEndDate: string;
begin
   //@modified by linlf 20140329 invisible two tabsheet

//  InitDisplay;
//  initialrecord();

//  ICFunction.loginfo('1');
//  DateTimePicker_Start_Menberinfo.Date := StrToDate(copy(FormatDateTime('yyyy-MM-dd HH:mm:ss', now), 1, 10));
//  ICFunction.loginfo('2');
//  DateTimePicker_End_Menberinfo.Date := StrToDate(copy(FormatDateTime('yyyy-MM-dd HH:mm:ss', now), 1, 10));
//  TimePicker_Start_Menberinfo.Time := StrToTime(copy(FormatDateTime('yyyy-MM-dd HH:mm:ss', now), 12, 8));
//  TimePicker_End_Menberinfo.Time := StrToTime(copy(FormatDateTime('yyyy-MM-dd HH:mm:ss', now), 12, 8));
//
//  DateTimePicker_Start.Date := StrToDate(copy(FormatDateTime('yyyy-MM-dd HH:mm:ss', now), 1, 10));
//  DateTimePicker_End.Date := StrToDate(copy(FormatDateTime('yyyy-MM-dd HH:mm:ss', now), 1, 10));
//  TimePicker_Start.Time := StrToTime(copy(FormatDateTime('yyyy-MM-dd HH:mm:ss', now), 12, 8));
//  TimePicker_End.Time := StrToTime(copy(FormatDateTime('yyyy-MM-dd HH:mm:ss', now), 12, 8));
//
//  //账目初始化
//  DateTimePicker_Start_Del.Date := StrToDate(copy(FormatDateTime('yyyy-MM-dd HH:mm:ss', (now)), 1, 10));
//  DateTimePicker_End_Del.Date := StrToDate(copy(FormatDateTime('yyyy-MM-dd HH:mm:ss', now), 1, 10));
//  TimePicker_Start_Del.Time := StrToTime(copy(FormatDateTime('yyyy-MM-dd HH:mm:ss', now), 12, 8));
//  TimePicker_End_Del.Time := StrToTime(copy(FormatDateTime('yyyy-MM-dd HH:mm:ss', now), 12, 8));
//

  //Total
  DateSeparator := '-';
  TimeSeparator := ':';
  LongTimeFormat :='yyyy-MM-dd HH:mm:ss';


  //InitCombo_OP;
  //InitCombo_MCname;

//  strStartDate := FormatDateTime('yyyy-MM-dd', dtpBegin.DateTime) ;
//  ICFunction.loginfo('3');
//  strEndDate := FormatDateTime('yyyy-MM-dd', dtpEnd.DateTime) ;
//
//  InitPan_Shape(strStartDate, strEndDate); //初始化查询昨天的经营情况


//  comReader.StartComm();
//  orderLst := TStringList.Create;
//  recDataLst := tStringList.Create;
//  recData_fromICLst := tStringList.Create;

end;

//柱状图展示

procedure TfrmReport.InitPan_Shape(strDatebegin: string; strDateend: string);
var
  strWhere: string;
  ADOQTemp: TADOQuery;
  strSQL: string;
  reTmpStr: string;
  StrMenberNO, StrUserNO, strTuibi: string;
  strStartDate, strEndDate: string;

  strInputSQL, strInput: string;
  strRefundSQL, strRefund: string;
  strBarflowSQL, strBarflow: string;

  strConditionSQL: string;
begin
  strInput := '0';
  strBarflow := '0';
  strTuibi := '1'; //退币的记录
  strWhere := '';
  strConditionSQL := '';

  strInputSQL := 'select sum(OPER_COIN) from   T_COIN_RECHARGE where ';

  strRefundSQL := 'select sum(OPER_COIN) from T_COIN_REFUND where  ';

  if strDatebegin = strDateend then
  begin  
    strStartDate := strDatebegin;
    strEndDate := strDateend;
  end
  else
  begin
    strStartDate := strDatebegin;
    strEndDate := strDateend;
  end;

  strInputSQL := strInputSQL + ' ( OPERATE_TIME>=''' + strStartDate + ''' and OPERATE_TIME <=''' + strEndDate + ''')';

  strRefundSQL := strRefundSQL + ' ( OPERATE_TIME >=''' + strStartDate + ''' and OPERATE_TIME <=''' + strEndDate + ''') ';

   strInputSQL := strInputSQL + strConditionSQL;
  ICFunction.loginfo('strInputSQL:   ' + strInputSQL);
  ADOQTemp := TADOQuery.Create(nil);
  with ADOQTemp do
  begin
    Connection := DataModule_3F.ADOConnection_Main;
    SQL.Clear;
    SQL.Add(strInputSQL);
    Active := True;
    strInput := TrimRight(ADOQTemp.Fields[0].AsString);
  end;
  FreeAndNil(ADOQTemp);
  if length(strInput) = 0 then
    strInput := '0';



  strRefundSQL := strRefundSQL + strConditionSQL;
  //linlf20160509
  ICFunction.loginfo('strRefundSQL:   ' + strRefundSQL);
  ADOQTemp := TADOQuery.Create(nil);
  with ADOQTemp do
  begin
    Connection := DataModule_3F.ADOConnection_Main;
    SQL.Clear;
    SQL.Add(strRefundSQL);
    Active := True;
    strRefund := TrimRight(ADOQTemp.Fields[0].AsString);
  end;
  FreeAndNil(ADOQTemp);
  if length(strRefund) = 0 then
    strRefund := '0';


  strBarflowSQL := 'select sum(COIN) from  T_BAR_FLOW where  ';   
  strBarflowSQL := strBarflowSQL + ' ( OPERATE_TIME >=''' + strStartDate + ''' and OPERATE_TIME <=''' + strEndDate + ''') ';


  ADOQTemp := TADOQuery.Create(nil);
  with ADOQTemp do
  begin
    Connection := DataModule_3F.ADOConnection_Main;
    SQL.Clear;
    SQL.Add(strBarflowSQL);
    Active := True;
    strBarflow := TrimRight(ADOQTemp.Fields[0].AsString); //只有一个返回值
  end;
  FreeAndNil(ADOQTemp);
  if length(strBarflow) = 0 then
    strBarflow := '0';




  Pan_Shape(strInput, strRefund, strBarflow);



end;

//生成条状图(label),调整比例因子

procedure TfrmReport.Pan_Shape(strInput: string; strRefund: string; strOutput: string);
var
  factor: integer;
begin
  factor := func_getfactor(strInput, strOutput);

  Lab_Input.Caption := strInput;

  Lab_Output.Caption := strOutput;


  Lab_refund.Caption := strRefund;


  Lab_IN.Caption := intToStr(StrToInt(strInput) - StrToInt(strRefund) - StrToInt(strOutput));

end;

function TfrmReport.func_getfactor(strInput: string; strOutput: string): integer;
var factor: integer;
begin
  if ((StrToInt(strInput) > 500) and (StrToInt(strInput) < 5001)) then
  begin
    if (StrToInt(strOutput) > 500) and (StrToInt(strOutput) < 5001) then
    begin
      factor := 10;
    end
    else if (StrToInt(strOutput) > 5000) and (StrToInt(strOutput) < 50001) then
    begin
      factor := 100;
    end
    else if (StrToInt(strOutput) > 50000) and (StrToInt(strOutput) < 500001) then
    begin
      factor := 1000;
    end
    else if (StrToInt(strOutput) < 501) then
    begin
      factor := 10;
    end;
  end
  else if (StrToInt(strInput) > 5000) and (StrToInt(strInput) < 50001) then
  begin
    if (StrToInt(strOutput) > 500) and (StrToInt(strOutput) < 5001) then
    begin
      factor := 100;
    end
    else if (StrToInt(strOutput) > 5000) and (StrToInt(strOutput) < 50001) then
    begin
      factor := 100;
    end
    else if (StrToInt(strOutput) > 50000) and (StrToInt(strOutput) < 500001) then
    begin
      factor := 1000;
    end
    else if (StrToInt(strOutput) < 501) then
    begin
      factor := 100;
    end;
  end
  else if (StrToInt(strInput) > 50000) and (StrToInt(strInput) < 500001) then
  begin
    if (StrToInt(strOutput) > 500) and (StrToInt(strOutput) < 5001) then
    begin
      factor := 1000;
    end
    else if (StrToInt(strOutput) > 5000) and (StrToInt(strOutput) < 50001) then
    begin
      factor := 1000;
    end
    else if (StrToInt(strOutput) > 50000) and (StrToInt(strOutput) < 500001) then
    begin
      factor := 1000;
    end
    else if (StrToInt(strOutput) < 501) then
    begin
      factor := 1000;
    end;
  end
  else if (StrToInt(strInput) < 501) then
  begin
    if (StrToInt(strOutput) > 500) and (StrToInt(strOutput) < 5001) then
    begin
      factor := 10;
    end
    else if (StrToInt(strOutput) > 5000) and (StrToInt(strOutput) < 50001) then
    begin
      factor := 100;
    end
    else if (StrToInt(strOutput) > 50000) and (StrToInt(strOutput) < 500001) then
    begin
      factor := 1000;
    end
    else if (StrToInt(strOutput) < 501) then
    begin
      factor := 1;
    end;
  end;
  result := factor;
end;

{
procedure Tfrm_IC_Report_Saletotal.Pan_Shape(strInput: string; strRefund : string; strOutput: string);
var
  factor: integer;
begin
  factor :=  func_getfactor(strInput,strOutput);
  Shape_Input.Width := StrToInt(strInput) div factor;  //条状长度
  Lab_Input.Left := Shape_Input.Left + Shape_Input.Width; //label的位置
  Lab_Input.Caption := strInput;

  //退币
  Shape_Refund.Left := Shape_Input.Left;
  Shape_Refund.Width := StrToInt(strRefund) div factor;
  Lab_Refund.Left := Shape_Refund.Left + Shape_Refund.Width;
  Lab_Refund.Caption := strRefund;

  Shape_Output.Left := Shape_Refund.right;
  Shape_Output.Width := StrToInt(strOutput) div factor;
  Lab_Output.Left := Shape_Output.right;
  Lab_Output.Caption := strOutput;

  Shape_IN.Left := Shape_Output.Left + Shape_Output.Width;
  Shape_IN.Width := Shape_Input.Width - Shape_Output.Width;
  Lab_IN.Left := Shape_IN.Left + Shape_IN.Width;
  Lab_IN.Caption := intToStr(StrToInt(strInput) - StrToInt(strOutput));

end;

}






procedure TfrmReport.btnSumBarFlowClick(Sender: TObject);
var
  i: integer;
  strSQL,strRecordSQL,strTotalSQL: string;
  LastRecord: string;
  strWhereSQL: string;
  strStartDate, strEndDate: string;
  ADOQTemp: TADOQuery;
begin
  LastRecord := '1'; //最新记录标志位

  strSql := '';
  strRecordSQL :=' select * from T_BAR_FLOW  where ';
  strTotalSQL := ' select sum(coin) from T_BAR_FLOW where ';


        //条件一
  strStartDate := FormatDateTime('yyyy-MM-dd', DateTimePicker_Start_Menberinfo.Date) + ' ' + FormatDateTime('hh:mm:ss', TimePicker_Start_Menberinfo.Time);
  strEndDate := FormatDateTime('yyyy-MM-dd', DateTimePicker_End_Menberinfo.Date) + ' ' + FormatDateTime('hh:mm:ss', TimePicker_End_Menberinfo.Time);
  strWhereSQL := strWhereSQL + ' ( OPERATE_TIME >=''' + strStartDate + ''' and OPERATE_TIME<=''' + strEndDate + ''')';

  strSQL := '' +  strRecordSQL + strWhereSQL + '';
  ICFunction.loginfo(strSQL);
  with ADOQBarFlow do
  begin
    Connection := DataModule_3F.ADOConnection_Main;
    Active := false;
    SQL.Clear;
    SQL.Add(strSQL);
    Active := True;
  end;

  strSQL := '' +  strTotalSQL + strWhereSQL + '';
  ICFunction.loginfo(strSQL);
  ADOQTemp := TADOQuery.Create(nil);
   with ADOQTemp do
  begin
    Connection := DataModule_3F.ADOConnection_Main;
    SQL.Clear;
    SQL.Add(strSQL);
    Active := True;
    if (not eof) then
    begin
      edtBarFlowTotal.Text := IntToStr(ADOQTemp.Fields[0].AsInteger);
      Close;
    end;
    FreeAndNil(ADOQTemp);
  end;


end;

procedure TfrmReport.btnSumRechargeClick(Sender: TObject);
var
  strSQL,strRecordSQL,strTotalSQL,strWhereSQL: string;
  ADOQTemp: TADOQuery;
  i: integer;
  strStartDate, strEndDate: string;
  StrMenberNO, StrUserNO : string;
begin

  strSql := '';
  strRecordSQL :=' select * from T_COIN_RECHARGE  where ';
  strTotalSQL := ' select sum(OPER_COIN) from T_COIN_RECHARGE where ';

     //条件一
  strStartDate := FormatDateTime('yyyy-MM-dd', DateTimePicker_Start.Date) + ' ' + FormatDateTime('hh:mm:ss', TimePicker_Start.Time);
  strEndDate := FormatDateTime('yyyy-MM-dd', DateTimePicker_End.Date) + ' ' + FormatDateTime('hh:mm:ss', TimePicker_End.Time);
  strWhereSQL := strWhereSQL + ' ( OPERATE_TIME >=''' + strStartDate + ''' and OPERATE_TIME<=''' + strEndDate + ''')';




  strSQL := '' +  strRecordSQL + strWhereSQL + '';
  ICFunction.loginfo(strSQL);
  with ADOQCoinRecharge do
  begin
    Connection := DataModule_3F.ADOConnection_Main;
    Active := false;
    SQL.Clear;
    SQL.Add(strSQL);
    Active := True;
  end;

  strSQL := '' +  strTotalSQL + strWhereSQL + '';
  ICFunction.loginfo(strSQL);
  ADOQTemp := TADOQuery.Create(nil);
   with ADOQTemp do
  begin
    Connection := DataModule_3F.ADOConnection_Main;
    SQL.Clear;
    SQL.Add(strSQL);
    Active := True;
    if (not eof) then
    begin
      edtCoinRechargeTotal.Text := IntToStr(ADOQTemp.Fields[0].AsInteger);
      Close;
    end;
    FreeAndNil(ADOQTemp);
  end;


end;

{
procedure Tfrm_IC_Report_Saletotal.Combo_SelClick(Sender: TObject);
begin
  if Combo_Sel.text = '机台编号' then
  begin
    Panel_GameMC.visible := true;
    Panel_Man.visible := false;
  end
  else if Combo_Sel.text = '营业员编号' then
  begin
    Panel_GameMC.visible := false;
    Panel_Man.visible := true;

  end
  else
  begin
    Panel_GameMC.visible := false;
    Panel_Man.visible := false;
  end;
end;

procedure Tfrm_IC_Report_Saletotal.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  DBGridEh1.SumList.Active := false;
  DBGridEh2.SumList.Active := false;
  orderLst.Free();
  recDataLst.Free();
  recData_fromICLst.Free();
//  comReader.StopComm();
  ICFunction.ClearIDinfor; //清除从ID读取的所有信息

end;

}
{
procedure Tfrm_IC_Report_Saletotal.ComboBox_SEL_INCClick(Sender: TObject);
begin
  if ComboBox_SEL_INC.text = '营业员编号' then
  begin
    Panel_Man_INC.visible := true;
    Panel_Menber_INC.visible := false;
    //Query_By_UserNO:='1';
  end
  else if ComboBox_SEL_INC.text = '会员编号' then
  begin
    Panel_Man_INC.visible := false;
    Panel_Menber_INC.visible := true;
    //Query_By_UserNO:='0';
  end
  else
  begin
    Panel_Man_INC.visible := false;
    Panel_Menber_INC.visible := false;
    //Query_By_UserNO:='2';
  end;
end;
}
//营业汇总查询

procedure TfrmReport.btnTotalClick(Sender: TObject);
var
  strStartDate, strEndDate: string;
begin
  strStartDate := FormatDateTime('yyyy-MM-dd', dtpTotalBeginDate.Date) + ' ' + FormatDateTime('hh:mm:ss', dtpTotalBeginTime.Time);
  strEndDate := FormatDateTime('yyyy-MM-dd', dtpTotalEndDate.Date) + ' ' + FormatDateTime('hh:mm:ss', dtpTotalEndTime.Time);
  BeginDate.Caption := strStartDate;
  EndDate.Caption := strEndDate;

  InitPan_Shape(strStartDate, strEndDate); //初始化查询昨天的经营情况
end;





procedure TfrmReport.BitBtn4Click(Sender: TObject);
begin
    //暂时没处理
end;




procedure TfrmReport.btnSumRefundClick(Sender: TObject);
var
  i: integer;
  strSQL,strRecordSQL,strTotalSQL: string;
  LastRecord: string;
  strWhereSQL: string;
  strStartDate, strEndDate: string;
  ADOQTemp: TADOQuery;
begin
  LastRecord := '1'; //最新记录标志位

  strSql := '';
  strRecordSQL :=' select * from T_COIN_REFUND  where ';
  strTotalSQL := ' select sum(OPER_COIN) from T_COIN_REFUND where ';


        //条件一
  strStartDate := FormatDateTime('yyyy-MM-dd', dtpRefundStartDate.Date) + ' ' + FormatDateTime('hh:mm:ss', dtpRefundStartTime.Time);
  strEndDate := FormatDateTime('yyyy-MM-dd', dtpRefundEndDate.Date) + ' ' + FormatDateTime('hh:mm:ss', dtpRefundEndTime.Time);
  strWhereSQL := strWhereSQL + ' ( OPERATE_TIME >=''' + strStartDate + ''' and OPERATE_TIME<=''' + strEndDate + ''')';

  strSQL := '' +  strRecordSQL + strWhereSQL + '';
  ICFunction.loginfo(strSQL);
  with ADOQCoinRefund do
  begin
    Connection := DataModule_3F.ADOConnection_Main;
    Active := false;
    SQL.Clear;
    SQL.Add(strSQL);
    Active := True;
  end;

  strSQL := '' +  strTotalSQL + strWhereSQL + '';
  ICFunction.loginfo(strSQL);
  ADOQTemp := TADOQuery.Create(nil);
   with ADOQTemp do
  begin
    Connection := DataModule_3F.ADOConnection_Main;
    SQL.Clear;
    SQL.Add(strSQL);
    Active := True;
    if (not eof) then
    begin
      edtRefundTotal.Text := IntToStr(ADOQTemp.Fields[0].AsInteger);
      Close;
    end;
    FreeAndNil(ADOQTemp);
  end;


end;

end.
