unit IC_Report_SaletotalUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DBGridEhGrouping, GridsEh, DBGridEh, StdCtrls, Buttons,
  ComCtrls, ExtCtrls, DB, ADODB, SPComm, Grids, DBGrids;

type
  Tfrm_IC_Report_Saletotal = class(TForm)
    Panel2: TPanel;
    pgcMachinerecord: TPageControl;
    Tab_Gamenameinput: TTabSheet;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    Panel6: TPanel;
    Panel7: TPanel;
    Panel4: TPanel;
    Label1: TLabel;
    Label3: TLabel;
    ComboBox1: TComboBox;
    Panel5: TPanel;
    BitBtn4: TBitBtn;
    BitBtn5: TBitBtn;
    Panel1: TPanel;
    Panel3: TPanel;
    Panel8: TPanel;
    Panel11: TPanel;
    Panel12: TPanel;
    BitBtn3: TBitBtn;
    BitBtn6: TBitBtn;
    Panel13: TPanel;
    Panel14: TPanel;
    Panel15: TPanel;
    Label11: TLabel;
    Panel19: TPanel;
    BitBtn7: TBitBtn;
    BitBtn8: TBitBtn;
    BitBtn9: TBitBtn;
    Label6: TLabel;
    Label2: TLabel;
    Label10: TLabel;
    Label14: TLabel;
    DateTimePicker_Start_Menberinfo: TDateTimePicker;
    Label9: TLabel;
    DateTimePicker_End_Menberinfo: TDateTimePicker;
    TimePicker_End_Menberinfo: TDateTimePicker;
    Combo_Sel: TComboBox;
    Panel_Man: TPanel;
    Label12: TLabel;
    Combo_OP: TComboBox;
    Panel_GameMC: TPanel;
    Label13: TLabel;
    Label15: TLabel;
    Combo_MCname: TComboBox;
    ComboBox_CardMC_ID: TComboBox;
    DataSource_Recrod: TDataSource;
    ADOQuery_Recrod: TADOQuery;
    DataSource_QueryRecord: TDataSource;
    ADOQuery_QueryRecord: TADOQuery;
    DateTimePicker_Start: TDateTimePicker;
    Label4: TLabel;
    DateTimePicker_End: TDateTimePicker;
    TimePicker_End: TDateTimePicker;
    ComboBox_SEL_INC: TComboBox;
    Label16: TLabel;
    DateTimePicker2: TDateTimePicker;
    Label7: TLabel;
    DateTimePicker3: TDateTimePicker;
    DateTimePicker4: TDateTimePicker;
    DateTimePicker1: TDateTimePicker;
    TimePicker_Start: TDateTimePicker;
    TimePicker_Start_Menberinfo: TDateTimePicker;
    DBGridEh1: TDBGridEh;
    DBGridEh2: TDBGridEh;
    DBGridEh3: TDBGridEh;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    GroupBox1: TGroupBox;
    Label_input: TLabel;
    Label_output: TLabel;
    Label_in: TLabel;
    Lab_Input: TLabel;
    Lab_output: TLabel;
    Lab_IN: TLabel;
    Panel_Man_Sale: TPanel;
    Label19: TLabel;
    ComboBox_User_Sale: TComboBox;
    Panel_GameMC_Sale: TPanel;
    Label20: TLabel;
    Label21: TLabel;
    ComboBoxMC_Sale: TComboBox;
    ComboBox_MCBit_Sale: TComboBox;
    Panel_Menber_Sale: TPanel;
    Label5: TLabel;
    ComboBox_Menber_Sale: TComboBox;
    Panel_Menber_INC: TPanel;
    Label22: TLabel;
    ComboBox_Menber_INC: TComboBox;
    Panel_Man_INC: TPanel;
    Label23: TLabel;
    ComboBox_User_INC: TComboBox;
    Edit1: TEdit;
    Label24: TLabel;
    Label25: TLabel;
    BeginDate: TLabel;
    EndDate: TLabel;
    TabSheet3: TTabSheet;
    GroupBox3: TGroupBox;
    comReader: TComm;
    Panel10: TPanel;
    Panel16: TPanel;
    Label26: TLabel;
    Label27: TLabel;
    Label31: TLabel;
    Label32: TLabel;
    DateTimePicker_Start_Del: TDateTimePicker;
    DateTimePicker_End_Del: TDateTimePicker;
    TimePicker_End_Del: TDateTimePicker;
    ComboBox_Del: TComboBox;
    Panel_Man_Del: TPanel;
    Label33: TLabel;
    Combo_OP_Del: TComboBox;
    Panel_GameMC_Del: TPanel;
    Label34: TLabel;
    Label35: TLabel;
    Combo_MCname_Del: TComboBox;
    ComboBox_CardMC_ID_Del: TComboBox;
    TimePicker_Start_Del: TDateTimePicker;
    Panel20: TPanel;
    Label29: TLabel;
    Label30: TLabel;
    BitBtn12: TBitBtn;
    BitBtn_Delete: TBitBtn;
    Panel_Menber_Del: TPanel;
    Label28: TLabel;
    ComboBox_Menber_Del: TComboBox;
    BitBtn_INC_Del: TBitBtn;
    BitBtn_exchange_Del: TBitBtn;
    Shape1: TShape;
    Lab_refund: TLabel;
    Label8: TLabel;
    Label_Refund: TLabel;
    DataSource_InitialRecord: TDataSource;
    DBGrid_InitialRecord: TDBGrid;
    ADOQuery_InitialRecord: TADOQuery;
    Label_Infor: TLabel;
    procedure Bit_FunctionMCClick(Sender: TObject);
    procedure Bit_Close_MenberinfoClick(Sender: TObject);
    procedure BitBtn5Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Combo_MCnameClick(Sender: TObject);
    procedure BitBtn7Click(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure Combo_SelClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ComboBox1Click(Sender: TObject);
    procedure ComboBox_SEL_INCClick(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn_DeleteClick(Sender: TObject);
    procedure comReaderReceiveData(Sender: TObject; Buffer: Pointer;
      BufferLength: Word);
    procedure ComboBox_DelClick(Sender: TObject);
    procedure Combo_MCname_DelClick(Sender: TObject);
    procedure BitBtn_INC_DelClick(Sender: TObject);
    procedure BitBtn_exchange_DelClick(Sender: TObject);
    procedure BitBtn4Click(Sender: TObject);
    function func_getfactor(strInput: string; strOutput: string):integer;
    procedure Combo_MCnameChange(Sender: TObject);

  private
    { Private declarations }
    procedure InitCombo_OP;
    procedure InitCombo_MCname;
    procedure InitCarMC_ID(Str1: string);
    procedure InitCarMC_ID_Del(Str1: string);
    procedure InitCombo_MCname_EBInc; //初始化充值查询
    //procedure Pan_Shape(strInput: string; strOutput: string);overload;
    procedure Pan_Shape(strInput: string; strRefund : string; strOutput: string);overload;
    procedure InitPan_Shape(strDatebegin: string; strDateend: string);
    procedure InitCombo_Menber; //初始化充值查询
    procedure DeleteTestDataFromTable;
    procedure DeleteTMembeDetail;
    procedure Delete3F_BARFLOW;
    procedure DeleteTClassChangeInfor;
    procedure CheckCMD();
    procedure InitDisplay();
    procedure initialrecord();
    procedure InsertDeleteRecord();
  public
    { Public declarations }
  end;

var
  frm_IC_Report_Saletotal: Tfrm_IC_Report_Saletotal;
  orderLst, recDataLst, recData_fromICLst: Tstrings;

implementation
uses ICDataModule, ICCommunalVarUnit, ICFunctionUnit, ICmain, ICEventTypeUnit, Fileinput_machinerecord_gamenameUnit,
  Fileinput_gamenameinputUnit, Fileinput_menbermatialupdateUnit,
  IC_Report_FunctionMCUnit;

{$R *.dfm}

procedure Tfrm_IC_Report_Saletotal.InitCombo_Menber; //初始化充值查询
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
    ComboBox_Menber_Sale.Items.Clear;
    ComboBox_Menber_INC.Items.Clear;
    ComboBox_Menber_Del.Items.Clear;
    ComboBox_Menber_Sale.Items.Add('全部');
    ComboBox_Menber_INC.Items.Add('全部');
    ComboBox_Menber_Del.Items.Add('全部');
    while not Eof do
    begin
      if INit_Wright.MenberControl_short = '0' then
      begin
        ComboBox_Menber_Sale.Items.Add(FieldByName('cUserNo').AsString);
        ComboBox_Menber_INC.Items.Add(FieldByName('cUserNo').AsString);
        ComboBox_Menber_Del.Items.Add(FieldByName('cUserNo').AsString);
      end
      else
      begin
        ComboBox_Menber_Sale.Items.Add(FieldByName('MemberName').AsString);
        ComboBox_Menber_INC.Items.Add(FieldByName('MemberName').AsString);
        ComboBox_Menber_Del.Items.Add(FieldByName('MemberName').AsString);
      end;

      Next;
    end;
  end;
  FreeAndNil(ADOQTemp);
end;

procedure Tfrm_IC_Report_Saletotal.Bit_FunctionMCClick(Sender: TObject);
begin
  frm_IC_Report_FunctionMC.show;
end;

procedure Tfrm_IC_Report_Saletotal.Bit_Close_MenberinfoClick(
  Sender: TObject);
begin
  Close;
end;

//取消

procedure Tfrm_IC_Report_Saletotal.BitBtn5Click(Sender: TObject);
begin
  close;
end;



//初始化营业员查询

procedure Tfrm_IC_Report_Saletotal.InitCombo_OP;
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
    Combo_OP_Del.Items.Clear;
    ComboBox_User_INC.Items.Clear;
    ComboBox_User_Sale.Items.Clear;
    Combo_OP.Items.Add('全部');
    Combo_OP_Del.Items.Add('全部');
    ComboBox_User_INC.Items.Add('全部');
    ComboBox_User_Sale.Items.Add('全部');
    while not Eof do
    begin
      if INit_Wright.MenberControl_short = '0' then
      begin
        Combo_OP.Items.Add(FieldByName('cUserNo').AsString);
        Combo_OP_Del.Items.Add(FieldByName('cUserNo').AsString);
        ComboBox_User_INC.Items.Add(FieldByName('cUserNo').AsString);
        ComboBox_User_Sale.Items.Add(FieldByName('UserNo').AsString);
      end
      else
      begin
        Combo_OP.Items.Add(FieldByName('UserNo').AsString);
        Combo_OP_Del.Items.Add(FieldByName('UserNo').AsString);
        ComboBox_User_INC.Items.Add(FieldByName('UserNo').AsString);
        ComboBox_User_Sale.Items.Add(FieldByName('UserNo').AsString);
      end;

      Next;
    end;
  end;
  FreeAndNil(ADOQTemp);
end;

//初始化游戏名称下来框

procedure Tfrm_IC_Report_Saletotal.InitCombo_MCname;
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
    Combo_MCname_Del.Items.Clear;
    Combo_MCname.Items.Add('全部');
    Combo_MCname_Del.Items.Add('全部');
    while not Eof do
    begin
      Combo_MCname.Items.Add(FieldByName('GameName').AsString);
      Combo_MCname_Del.Items.Add(FieldByName('GameName').AsString);
      Next;
    end;
  end;
  FreeAndNil(ADOQTemp);
end;

//初始化充值查询

procedure Tfrm_IC_Report_Saletotal.InitCombo_MCname_EBInc;
var
  ADOQTemp: TADOQuery;
  strSQL: string;
begin
  ADOQTemp := TADOQuery.Create(nil);
  strSQL := 'select distinct[cUserNo] from [EBdetail] ';
  with ADOQTemp do
  begin
    Connection := DataModule_3F.ADOConnection_Main;
    SQL.Clear;
    SQL.Add(strSQL);
    Active := True;
    ComboBox_SEL_INC.Items.Clear;
    ComboBox_SEL_INC.Items.Add('全部');
    while not Eof do
    begin
      ComboBox_SEL_INC.Items.Add(FieldByName('cUserNo').AsString);
      Next;
    end;
  end;
  FreeAndNil(ADOQTemp);
end;


procedure Tfrm_IC_Report_Saletotal.Combo_MCnameClick(
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

procedure Tfrm_IC_Report_Saletotal.InitCarMC_ID(Str1: string);
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

procedure Tfrm_IC_Report_Saletotal.InitCarMC_ID_Del(Str1: string);
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
    ComboBox_CardMC_ID_Del.Items.Clear;
    while not Eof do begin
      ComboBox_CardMC_ID_Del.Items.Add(FieldByName('MacNo').AsString);
      Next;
    end;
  end;
  FreeAndNil(ADOQTemp);

end;

procedure Tfrm_IC_Report_Saletotal.InitDisplay();
begin
  pgcMachinerecord.Pages[1].TabVisible := false;
 // pgcMachinerecord.Pages[2].TabVisible := false;

  label31.visible :=false;
  combobox_del.visible :=false;

  label28.visible :=false;
  combobox_menber_del.visible :=false;

  label35.visible := false;
  combobox_cardmc_id_del.visible := false;

  label14.Visible := false;
  combo_sel.Visible := false;
  
  
end;

procedure Tfrm_IC_Report_Saletotal.FormShow(Sender: TObject);
var

  strStartDate, strEndDate: string;
begin
   //@modified by linlf 20140329 invisible two tabsheet

  InitDisplay;
  initialrecord();


  DateTimePicker_Start_Menberinfo.Date := StrToDate(copy(FormatDateTime('yyyy-MM-dd HH:mm:ss', now), 1, 10));
  DateTimePicker_End_Menberinfo.Date := StrToDate(copy(FormatDateTime('yyyy-MM-dd HH:mm:ss', now), 1, 10));
  TimePicker_Start_Menberinfo.Time := StrToTime(copy(FormatDateTime('yyyy-MM-dd HH:mm:ss', now), 12, 8));
  TimePicker_End_Menberinfo.Time := StrToTime(copy(FormatDateTime('yyyy-MM-dd HH:mm:ss', now), 12, 8));

  DateTimePicker_Start.Date := StrToDate(copy(FormatDateTime('yyyy-MM-dd HH:mm:ss', now), 1, 10));
  DateTimePicker_End.Date := StrToDate(copy(FormatDateTime('yyyy-MM-dd HH:mm:ss', now), 1, 10));
  TimePicker_Start.Time := StrToTime(copy(FormatDateTime('yyyy-MM-dd HH:mm:ss', now), 12, 8));
  TimePicker_End.Time := StrToTime(copy(FormatDateTime('yyyy-MM-dd HH:mm:ss', now), 12, 8));

  //账目初始化
  DateTimePicker_Start_Del.Date := StrToDate(copy(FormatDateTime('yyyy-MM-dd HH:mm:ss', (now)), 1, 10));
  DateTimePicker_End_Del.Date := StrToDate(copy(FormatDateTime('yyyy-MM-dd HH:mm:ss', now), 1, 10));
  TimePicker_Start_Del.Time := StrToTime(copy(FormatDateTime('yyyy-MM-dd HH:mm:ss', now), 12, 8));
  TimePicker_End_Del.Time := StrToTime(copy(FormatDateTime('yyyy-MM-dd HH:mm:ss', now), 12, 8));


  //Total
  DateTimePicker1.Date := StrToDate(copy(FormatDateTime('yyyy-MM-dd HH:mm:ss', (now)), 1, 10));
  DateTimePicker2.Time := StrToTime(copy(FormatDateTime('yyyy-MM-dd HH:mm:ss', now), 12, 8));
  DateTimePicker3.Date := StrToDate(copy(FormatDateTime('yyyy-MM-dd HH:mm:ss', now), 1, 10));
  DateTimePicker4.Time := StrToTime(copy(FormatDateTime('yyyy-MM-dd HH:mm:ss', now), 12, 8));


  InitCombo_OP;
  InitCombo_MCname;
  InitCombo_Menber;
  strStartDate := FormatDateTime('yyyy-MM-dd', DateTimePicker1.Date) + ' ' + FormatDateTime('hh:mm:ss', DateTimePicker2.Time);
  strEndDate := FormatDateTime('yyyy-MM-dd', DateTimePicker3.Date) + ' ' + FormatDateTime('hh:mm:ss', DateTimePicker4.Time);

  InitPan_Shape(strStartDate, strEndDate); //初始化查询昨天的经营情况

  BitBtn_Delete.Enabled := false;  
  BitBtn_exchange_Del.Enabled := false;
  BitBtn_INC_Del.Enabled := false;


  comReader.StartComm();

  orderLst := TStringList.Create;
  recDataLst := tStringList.Create;

  recData_fromICLst := tStringList.Create;

end;

//柱状图展示
procedure Tfrm_IC_Report_Saletotal.InitPan_Shape(strDatebegin: string; strDateend: string);
var
  strWhere: string;
  ADOQTemp: TADOQuery;
  strSQL: string;
  reTmpStr: string;
  StrMenberNO, StrUserNO, strTuibi: string;
  strStartDate, strEndDate: string;

  strInputSQL,strInput  : string;
  strRefundSQL, strRefund : string;
  strBarflowSQL, strBarflow : string;
  
  strConditionSQL : string;
begin
  strInput := '0';
  strBarflow := '0';
  strTuibi := '1'; //退币的记录
  strWhere := '';
  strConditionSQL := '';
  
  strInputSQL := 'select sum(TotalMoney) from  [TMembeDetail] where ';
  //strRefundSQL := 'select sum(totalmoney) from t_refunddetail where ';
  strRefundSQL := 'select sum(totalmoney) from TMembeDetail where id_usercard_tuibi_flag=''1'' and ';

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
  
    strInputSQL := strInputSQL + ' ( GetTime>=''' + strStartDate + ''' and GetTime<=''' + strEndDate + ''')';
//    strRefundSQL := strRefundSQL + ' ( GetTime>=''' + strStartDate + ''' and GetTime<=''' + strEndDate + ''') ';
    strRefundSQL := strRefundSQL + ' ( tuibi_time>=''' + strStartDate + ''' and tuibi_time<=''' + strEndDate + ''') ';

      //条件二
  if ComboBox1.Text <> '整个场地' then
  begin
    if ComboBox1.Text = '机台编号' then 
    begin
      if ComboBoxMC_Sale.Text <> '全部' then
      begin
        strConditionSQL := strConditionSQL + ' and MacNo=''' + ComboBox_MCBit_Sale.Text + '''';
      end;
    end
    else if ComboBox1.Text = '会员编号' then
    begin
      if ComboBox_Menber_Sale.Text <> '全部' then //无线项目可以用
      begin
        StrMenberNO := DataModule_3F.Query_MenberNo(TrimRight(ComboBox_Menber_Sale.Text));
        strConditionSQL := strConditionSQL + ' and IDCardNo=''' + StrMenberNO + '''';
      end;
    end

    else if ComboBox1.Text = '营业员编号' then
    begin
      if ComboBox_User_Sale.Text <> '全部' then //无线项目可以用
      begin
        StrUserNO := DataModule_3F.Query_UserNo(TrimRight(ComboBox_User_Sale.Text));
        strConditionSQL := strConditionSQL + ' and cUserNo=''' + StrUserNO + '''';
      end;
    end
  end;

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



  strRefundSQL := strRefundSQL +   strConditionSQL;
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


//---------------------
  strWhere := '';
  strConditionSQL := '';
  
  strBarflowSQL :=  'select sum(COREVALU_Bili) from [3F_BARFLOW] where  ';

        //条件一

  if strDatebegin = strDateend then
  begin

    strStartDate := strDatebegin; //取得开始日期;
    strEndDate := strDateend;
  end
  else
  begin
    strStartDate := strDatebegin;
    strEndDate := strDateend;
  end;
  BeginDate.Caption := strStartDate;
  EndDate.Caption := strEndDate;
  strBarflowSQL := strBarflowSQL + ' ( DATETIME_SCAN>=''' + strStartDate + ''' and DATETIME_SCAN<=''' + strEndDate + ''')';

      //条件二
  if ComboBox1.Text <> '整个场地' then
  begin
    if ComboBox1.Text = '机台编号' then //无线项目可以用
    begin
      if ComboBoxMC_Sale.Text <> '全部' then
      begin
        strConditionSQL := strConditionSQL + ' and MacNo=''' + ComboBox_MCBit_Sale.Text + '''';
      end;
    end
    else if ComboBox1.Text = '会员编号' then
    begin
      if ComboBox_Menber_Sale.Text <> '全部' then //无线项目可以用
      begin
        StrMenberNO := DataModule_3F.Query_MenberNo(TrimRight(ComboBox_Menber_Sale.Text));
        strConditionSQL := strConditionSQL + ' and IDCardNo=''' + StrMenberNO + '''';
      end;
    end

    else if ComboBox1.Text = '营业员编号' then
    begin
      if ComboBox_User_Sale.Text <> '全部' then //无线项目可以用
      begin
        StrUserNO := DataModule_3F.Query_UserNo(TrimRight(ComboBox_User_Sale.Text));
        strConditionSQL := strConditionSQL + ' and Scaner=''' + StrUserNO + '''';
      end;
    end
  end;

  strBarflowSQL := strBarflowSQL +   strConditionSQL;
  
  ADOQTemp := TADOQuery.Create(nil);
  with ADOQTemp do
  begin
    Connection := DataModule_3F.ADOConnection_Main;
    SQL.Clear;
    SQL.Add(strBarflowSQL);
    Active := True;
    strBarflow := TrimRight(ADOQTemp.Fields[0].AsString);     //只有一个返回值
  end;
  FreeAndNil(ADOQTemp);
  if length(strBarflow) = 0 then
    strBarflow := '0';




  Pan_Shape(strInput, strRefund, strBarflow);
  


end;

//生成条状图(label),调整比例因子
procedure Tfrm_IC_Report_Saletotal.Pan_Shape(strInput: string; strRefund :string; strOutput: string);
var
  factor: integer;
begin               
  factor := func_getfactor(strInput,strOutput);

  Lab_Input.Caption := strInput;

  Lab_Output.Caption := strOutput;


  Lab_refund.Caption := strRefund;


  Lab_IN.Caption := intToStr(StrToInt(strInput) -StrToInt(strRefund)- StrToInt(strOutput));

end;

function Tfrm_IC_Report_Saletotal.func_getfactor(strInput: string; strOutput: string):integer;
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






procedure Tfrm_IC_Report_Saletotal.BitBtn7Click(Sender: TObject);
var
  i: integer;
  strSQL: string;
  LastRecord: string;
  strWhere: string;
  strStartDate, strEndDate: string;
begin
  LastRecord := '1'; //最新记录标志位

  strWhere := '';

  strWhere := strWhere + 'select * ';
  strWhere := strWhere + 'from [3F_BARFLOW] '; //扫描记录，机台位卡头ID
  strWhere := strWhere + 'where  Query_Enable=''1'' and '; //为1允许查询

        //条件一
  strStartDate := FormatDateTime('yyyy-MM-dd', DateTimePicker_Start_Menberinfo.Date) + ' ' + FormatDateTime('hh:mm:ss', TimePicker_Start_Menberinfo.Time);
  strEndDate := FormatDateTime('yyyy-MM-dd', DateTimePicker_End_Menberinfo.Date) + ' ' + FormatDateTime('hh:mm:ss', TimePicker_End_Menberinfo.Time);
 // strWhere := strWhere + ' ( DATETIME_operate>=''' + strStartDate + ''' and DATETIME_operate<=''' + strEndDate + ''')';
 strWhere := strWhere + ' ( DATETIME_SCAN >=''' + strStartDate + ''' and DATETIME_SCAN<=''' + strEndDate + ''')';


      //条件二
 {
 if Combo_Sel.Text <> '全部' then
  begin
    if Combo_Sel.Text = '机台编号' then
    begin
       //strWhere := strWhere + ' and Gamename=''' + combo_mcname.Text + '''';
      if ComboBox_CardMC_ID.Text <> '全部' then
      begin
        strWhere := strWhere + ' and MacNo=''' + ComboBox_CardMC_ID.Text + '''';
      end;
    end
  end;
  }

  if combo_mcname.Text = '全部' then
    begin
        //
    end
   else if combobox_cardmc_id.Text = '全部' then
      begin
        strWhere := strWhere + ' and Gamename=''' + combo_mcname.Text + '''';
      end
     else
      begin
        strWhere := strWhere + ' and Gamename=''' + combo_mcname.Text + ''' and MacNo=''' + ComboBox_CardMC_ID.Text +'''';
      end ;
                                 
  strSQL := '' + strWhere + '';
  ICFunction.loginfo(strSQL);
  with ADOQuery_QueryRecord do
  begin
    Connection := DataModule_3F.ADOConnection_Main;
    Active := false;
    SQL.Clear;
    SQL.Add(strSQL);
    Active := True;
  end;


  DBGridEh1.FooterRowCount := 1;
  DBGridEh1.SumList.Active := true;

  DBGridEh1.Columns[0].Footer.ValueType := fvtStaticText;
  DBGridEh1.Columns[0].Footer.Value:='合计';

  DBGridEh1.Columns[4].Footer.ValueType:=fvtSum;  //这个累加字段必须是数字类型不能是字符串
 
end;

procedure Tfrm_IC_Report_Saletotal.BitBtn1Click(Sender: TObject);
var
  strSQL: string;
  LastRecord: string;
  strWhere: string;
  i: integer;
  strStartDate, strEndDate: string;
  StrMenberNO, StrUserNO, strTuibi: string;
begin
  LastRecord := '1'; //最新记录标志位
  strTuibi := '0';
  strWhere := '';
  strWhere := strWhere + 'select * ';
  strWhere := strWhere + 'from [TMembeDetail] '; //扫描记录，机台位卡头ID
  strWhere := strWhere + 'where  ';

     //条件一
  strStartDate := FormatDateTime('yyyy-MM-dd', DateTimePicker_Start.Date) + ' ' + FormatDateTime('hh:mm:ss', TimePicker_Start.Time);
  strEndDate := FormatDateTime('yyyy-MM-dd', DateTimePicker_End.Date) + ' ' + FormatDateTime('hh:mm:ss', TimePicker_End.Time);
  strWhere := strWhere + ' ( GetTime>=''' + strStartDate + ''' and GetTime<=''' + strEndDate + ''') and (ID_UserCard_TuiBi_Flag=''' + strTuibi + ''')';


      //条件二
  if ComboBox_SEL_INC.Text <> '全部' then
  begin
    if ComboBox_SEL_INC.Text = '会员编号' then
    begin
      if ComboBox_Menber_INC.Text <> '全部' then //无线项目可以用
      begin
        StrMenberNO := DataModule_3F.Query_MenberNo(TrimRight(ComboBox_Menber_INC.Text));
        Edit1.Text := StrMenberNO;
        strWhere := strWhere + ' and IDCardNo=''' + StrMenberNO + '''';
      end;
    end

    else if ComboBox_SEL_INC.Text = '营业员编号' then
    begin
      if ComboBox_User_INC.Text <> '全部' then //无线项目可以用
      begin
        StrUserNO := DataModule_3F.Query_UserNo(TrimRight(ComboBox_User_INC.Text));
        strWhere := strWhere + ' and cUserNo=''' + StrUserNO + '''';
      end;
    end;
  end;


  strSQL := '' + strWhere + '';
  //showmessage(strSQL);
  with ADOQuery_Recrod do
  begin
    Connection := DataModule_3F.ADOConnection_Main;
    Active := false;
    SQL.Clear;
    SQL.Add(strSQL);
    Active := True;
  end;


  DBGridEh2.FooterRowCount := 1;
  DBGridEh2.SumList.Active := true;
 // DBGridEh1.Columns[2].Footer.ValueType:=fvtSum;

  for i := 0 to DBGridEh2.Columns.Count - 1 do //一共有多少列？
  begin
   //    DBGridEh1.Columns[i].Footer.FieldName:=DBGridEh1.Columns[i].Title.Caption;
    if i = 0 then
    begin
      DBGridEh2.Columns[i].Footer.ValueType := fvtStaticText;
      DBGridEh2.Columns[i].Footer.Value := '合计';
      DBGridEh2.Columns[i].Footer.Alignment := tacenter;
    end
    else
    begin
      if i = 3 then
      begin
        DBGridEh2.Columns[i].Footer.ValueType := fvtSum;
      end;
    end;
  end;

end;

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
  comReader.StopComm();
  ICFunction.ClearIDinfor; //清除从ID读取的所有信息

end;

procedure Tfrm_IC_Report_Saletotal.ComboBox1Click(Sender: TObject);
begin
  if ComboBox1.text = '机台编号' then
  begin
    Panel_GameMC_Sale.visible := true;
    Panel_Man_Sale.visible := false;
    Panel_Menber_Sale.visible := false;
    //Query_By_UserNO:='3';
  end
  else if ComboBox1.text = '营业员编号' then
  begin
    Panel_GameMC_Sale.visible := false;
    Panel_Man_Sale.visible := true;
    Panel_Menber_Sale.visible := false;
    //Query_By_UserNO:='1';
  end
  else if ComboBox1.text = '会员编号' then
  begin
    Panel_GameMC_Sale.visible := false;
    Panel_Man_Sale.visible := false;
    Panel_Menber_Sale.visible := true;
    //Query_By_UserNO:='0';
  end
  else
  begin
    Panel_GameMC_Sale.visible := false;
    Panel_Man_Sale.visible := false;
    Panel_Menber_Sale.visible := false;
    //Query_By_UserNO:='2';
  end;
end;

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

//营业汇总查询

procedure Tfrm_IC_Report_Saletotal.BitBtn2Click(Sender: TObject);
var
  strStartDate, strEndDate: string;
begin
  strStartDate := FormatDateTime('yyyy-MM-dd', DateTimePicker1.Date) + ' ' + FormatDateTime('hh:mm:ss', DateTimePicker2.Time);
  strEndDate := FormatDateTime('yyyy-MM-dd', DateTimePicker3.Date) + ' ' + FormatDateTime('hh:mm:ss', DateTimePicker4.Time);

  BeginDate.Caption := strStartDate;
  EndDate.Caption := strEndDate;

  InitPan_Shape(strStartDate, strEndDate); //初始化查询昨天的经营情况
end;

//删除全部账目

procedure Tfrm_IC_Report_Saletotal.BitBtn_DeleteClick(Sender: TObject);
begin
  if (MessageDlg('确实要清空帐目记录吗?', mtConfirmation, [mbYes, mbNo], 0) = mrYes) then
  begin
  

    DeleteTestDataFromTable; //清除所有帐目数据
    InsertDeleteRecord; //记录清账历史

    Label28.Caption := '所有帐目初始化完成';

  end
  else
  begin
    Label28.Caption := '操作取消';
  end;

  BitBtn_Delete.Enabled := false;
  exit;
end;

procedure Tfrm_IC_Report_Saletotal.BitBtn_INC_DelClick(Sender: TObject);
begin
  if (MessageDlg('确实要删除 充值帐目相关记录吗?', mtConfirmation, [mbYes, mbNo], 0) = mrYes) then
  begin
    DeleteTMembeDetail;
    Label28.Caption := '充值帐目初始化完成';
  end
  else
  begin
    Label28.Caption := '操作取消';
  end;
  BitBtn_INC_Del.Enabled := false;
  exit;
end;

procedure Tfrm_IC_Report_Saletotal.BitBtn_exchange_DelClick(
  Sender: TObject);
begin
  if (MessageDlg('确实要删除 兑换帐目相关记录吗?', mtConfirmation, [mbYes, mbNo], 0) = mrYes) then
  begin
    Delete3F_BARFLOW;

    Label28.Caption := '兑换帐目初始化完成';

  end
  else
  begin
    Label28.Caption := '操作取消';
  end;

  BitBtn_exchange_Del.Enabled := false;
  exit;
end;

procedure Tfrm_IC_Report_Saletotal.DeleteTMembeDetail;
var
  i: integer;
  strSQL: string;
  LastRecord: string;
  strWhere: string;
  strStartDate, strEndDate: string;
begin
  LastRecord := '1'; //最新记录标志位

  strWhere := '';

  strWhere := strWhere + ' delete';
  strWhere := strWhere + ' from [TMembeDetail] '; //扫描记录，机台位卡头ID
  strWhere := strWhere + ' where  '; //为1允许查询

        //条件一
  strStartDate := FormatDateTime('yyyy-MM-dd', DateTimePicker_Start_Del.Date) + ' ' + FormatDateTime('hh:mm:ss', TimePicker_Start_Del.Time);
  strEndDate := FormatDateTime('yyyy-MM-dd', DateTimePicker_End_Del.Date) + ' ' + FormatDateTime('hh:mm:ss', TimePicker_End_Del.Time);
  strWhere := strWhere + ' ( GetTime>=''' + strStartDate + ''' and GetTime<=''' + strEndDate + ''')';


      //条件二
  if ComboBox_Del.Text <> '全部' then
  begin
    if ComboBox_Del.Text = '营业员编号' then
    begin
      strWhere := strWhere + ' and cUserNo=''' + Combo_OP_Del.Text + '''';
    end
    else if ComboBox_Del.Text = '会员编号' then
    begin
      strWhere := strWhere + ' and IDCardNo=''' + ComboBox_Menber_Del.Text + '''';
    end
  end;
  strSQL := '' + strWhere + '';

  //modified by linlf 20140309
  ICDataModule.DataModule_3F.executesql(strSQL);
{

  with  ADOQuery_QueryRecord do
   begin
    Connection := DataModule_3F.ADOConnection_Main;
    Active:=false;
    SQL.Clear;
    SQL.Add(strSQL);
    Active:=True;
   end;
}

end;



procedure Tfrm_IC_Report_Saletotal.Delete3F_BARFLOW;
var
  i: integer;
  strSQL: string;
  LastRecord: string;
  strWhere: string;
  strStartDate, strEndDate: string;
begin
  LastRecord := '1'; //最新记录标志位

  strWhere := '';

  //strWhere := strWhere + ' Update [3F_BARFLOW] ';
  strWhere := strWhere + ' delete from [3F_BARFLOW] ';
  //strWhere := strWhere + ' set COREVALU_Bili=''0'',Query_Enable=''0'',CORE=''0''  '; //扫描记录，机台位卡头ID
  strWhere := strWhere + ' where  '; //为1允许查询

        //条件一
  strStartDate := FormatDateTime('yyyy-MM-dd', DateTimePicker_Start_Del.Date) + ' ' + FormatDateTime('hh:mm:ss', TimePicker_Start_Del.Time);
  strEndDate := FormatDateTime('yyyy-MM-dd', DateTimePicker_End_Del.Date) + ' ' + FormatDateTime('hh:mm:ss', TimePicker_End_Del.Time);
  strWhere := strWhere + ' ( DATETIME_OPERATE>=''' + strStartDate + ''' and DATETIME_OPERATE<=''' + strEndDate + ''')';


      //条件二
  if ComboBox_Del.Text <> '全部' then
  begin
    if ComboBox_Del.Text = '机台编号' then
    begin
      if ComboBox_CardMC_ID.Text <> '全部' then
      begin
        strWhere := strWhere + ' and MacNo=''' + ComboBox_CardMC_ID_Del.Text + '''';
      end;
    end
    else if ComboBox_Del.Text = '营业员编号' then
    begin
      strWhere := strWhere + ' and Scaner=''' + Combo_OP_Del.Text + '''';
    end

    else if ComboBox_Del.Text = '会员编号' then
    begin
      strWhere := strWhere + ' and IDCardNo=''' + ComboBox_Menber_Del.Text + '''';
    end
  end;


  strSQL := '' + strWhere + '';

 //modified by linlf 20140309
  ICDataModule.DataModule_3F.executesql(strSQL);
  {
  with  ADOQuery_QueryRecord do
   begin
    Connection := DataModule_3F.ADOConnection_Main;
    Active:=false;
    SQL.Clear;
    SQL.Add(strSQL);
    Active:=True;
   end;
  }

end;

 //没有使用
procedure Tfrm_IC_Report_Saletotal.DeleteTClassChangeInfor;
var
  i: integer;
  strSQL: string;
  LastRecord: string;
  strWhere: string;
  strStartDate, strEndDate: string;
begin
  LastRecord := '1'; //最新记录标志位

  strWhere := '';

  strWhere := strWhere + 'delete  from ';
  strWhere := strWhere + 'from [TClassChangeInfor] '; //扫描记录，机台位卡头ID
  strWhere := strWhere + 'where  '; //为1允许查询

        //条件一
  strStartDate := FormatDateTime('yyyy-MM-dd', DateTimePicker_Start_Del.Date) + ' ' + FormatDateTime('hh:mm:ss', TimePicker_Start_Del.Time);
  strEndDate := FormatDateTime('yyyy-MM-dd', DateTimePicker_End_Del.Date) + ' ' + FormatDateTime('hh:mm:ss', TimePicker_End_Del.Time);
  strWhere := strWhere + ' ( Send_Time>=''' + strStartDate + ''' and Send_Time<=''' + strEndDate + ''')';


      //条件二
  if ComboBox_Del.Text <> '全部' then
  begin
    if ComboBox_Del.Text = '营业员编号' then
    begin
      strWhere := strWhere + ' and cUserNo=''' + Combo_OP_Del.Text + '''';
    end
    else if ComboBox_Del.Text = '会员编号' then
    begin
      strWhere := strWhere + ' and IDCardNo=''' + ComboBox_Menber_Del.Text + '''';
    end
  end;
  strSQL := '' + strWhere + '';

  with ADOQuery_QueryRecord do
  begin
    Connection := DataModule_3F.ADOConnection_Main;
    Active := false;
    SQL.Clear;
    SQL.Add(strSQL);
    Active := True;
  end;


end;

//删除测试数据

procedure Tfrm_IC_Report_Saletotal.DeleteTestDataFromTable;
var
  ADOQ: TADOQuery;
  strSQL: string;
  strTemp, strTempAfter,strStartDate,strEndDate: string;
begin

  strStartDate := FormatDateTime('yyyy-MM-dd', DateTimePicker_Start_Del.Date) + ' ' + FormatDateTime('hh:mm:ss', TimePicker_Start_Del.Time);
  strEndDate := FormatDateTime('yyyy-MM-dd', DateTimePicker_End_Del.Date) + ' ' + FormatDateTime('hh:mm:ss', TimePicker_End_Del.Time);


  //1、首先清除充值记录表[TMembeDetail]
  strSQL := 'delete  from [TMembeDetail] where '
          + ' ( GetTime>=''' + strStartDate + ''' and GetTime<=''' + strEndDate + ''')';
  ICFunction.loginfo('账目初始化  '+ strSQL);
  DataModule_3F.executesql(strSQL);
  

  //2,清除兑换记录
  strSQL := 'delete from  [3F_BARFLOW] where '
            + ' ( datetime_scan>=''' + strStartDate + ''' and datetime_scan<=''' + strEndDate + ''')';

  ICFunction.loginfo('账目初始化  '+ strSQL);
  DataModule_3F.executesql(strSQL);

 

  //5、首先清除交班记录表[TClassChangeInfor]
  strSQL := 'delete  from '
    + ' [TClassChangeInfor]';

  ADOQ := TADOQuery.Create(nil);
  with ADOQ do begin
    Connection := DataModule_3F.ADOConnection_Main;
    ADOQ.Active := false;
    SQL.Clear;
    SQL.Add(strSQL);
    ADOQ.ExecSQL;
  end;
  FreeAndNil(ADOQ);


  //7、首先清除充值记录表[EBdetail]
  strSQL := 'delete  from '
    + ' [EBdetail]';

  ADOQ := TADOQuery.Create(nil);
  with ADOQ do begin
    Connection := DataModule_3F.ADOConnection_Main;
    ADOQ.Active := false;
    SQL.Clear;
    SQL.Add(strSQL);
    ADOQ.ExecSQL;
  end;
  FreeAndNil(ADOQ);
  
end;


procedure Tfrm_IC_Report_Saletotal.InsertDeleteRecord();
var
  ADOQ: TADOQuery;
  strSQL: string;
  strOperator,strOperatetime, strStartDate,strEndDate,strNote: string;
Begin
   strOperator := G_User.UserNO; //操作员
    strOperatetime :=  FormatDateTime('yyyy-MM-dd hh:mm:ss', now());
    strStartDate := FormatDateTime('yyyy-MM-dd', DateTimePicker_Start_Del.Date) + ' ' + FormatDateTime('hh:mm:ss', TimePicker_Start_Del.Time);
    strEndDate := FormatDateTime('yyyy-MM-dd', DateTimePicker_End_Del.Date) + ' ' + FormatDateTime('hh:mm:ss', TimePicker_End_Del.Time);
    strNote := strOperator + ' 操作记录 ';

    with ADOQuery_InitialRecord do begin
    Append;
    FieldByName('OPERATOR').AsString := strOperator;
    FieldByName('OPERATETIME').AsString := strOperatetime;
    FieldByName('RECORDSTART').AsString := strStartDate;
    FieldByName('RECORDEND').AsString := strEndDate;
    FieldByName('NOTE').AsString := strNote;
    try
        Post;
    except
         on e: Exception do ShowMessage(e.Message);
    end;
    end;

end;     


procedure Tfrm_IC_Report_Saletotal.comReaderReceiveData(Sender: TObject;   Buffer: Pointer; BufferLength: Word);
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
  //  if curOrderNo<orderLst.Count then    // 判断指令是否已经都发送完毕，如果指令序号小于指令总数则继续发送
  //      sendData()
  //  else begin
  //      checkOper();
  //  end;
end;



 //根据接收到的数据判断此卡是否为合法卡

procedure Tfrm_IC_Report_Saletotal.CheckCMD();
var
  tmpStr: string;
  ID_INIT: string;
  ID_3F: string;
  Password_3F: string;
  Password_USER: string;
  RevComd: string;
  ID_type: string;
begin
   //首先截取接收的信息
  tmpStr := recData_fromICLst.Strings[0];
  Receive_CMD_ID_Infor.ID_CheckNum := copy(tmpStr, 39, 4); //校验和
      // if (CheckSUMData(copy(tmpStr, 1, 38))=copy(tmpStr, 41, 2)+copy(tmpStr, 39, 2)) then//校验和
  begin
    CMD_CheckSum_OK := true;
    RevComd := copy(recData_fromICLst.Strings[0], 1, 2); //帧头43
  end;
                 //1、判断此卡是否为已经完成初始化
  if RevComd = CMD_COUMUNICATION.CMD_READ then
  begin

    ID_INIT := copy(recData_fromICLst.Strings[0], 3, 8); //卡片ID
    ID_3F := copy(recData_fromICLst.Strings[0], 11, 6); //卡厂ID
    Password_3F := copy(recData_fromICLst.Strings[0], 17, 6); //卡密
    Password_USER := copy(recData_fromICLst.Strings[0], 23, 6); //用户密码
    ID_type := copy(recData_fromICLst.Strings[0], 37, 2); //卡功能

                 //1、判断是否曾经初始化过，只有3F初始化过的卡且类型为万能卡AA 或 老板卡BB或管理人员的才能操作
                 //if ICFunction.CHECK_3F_ID(ID_INIT,ID_3F,Password_3F) and ( (ID_type=copy(INit_Wright.Produecer_3F,8,2))or (ID_type=copy(INit_Wright.BOSS,8,2)) or (ID_type=copy(INit_Wright.MANEGER,8,2)) ) then
                 //20130116修改
    if ((ID_type = copy(INit_Wright.Produecer_3F, 8, 2)) or (ID_type = copy(INit_Wright.BOSS, 8, 2))) then
    begin

      Label28.Caption := ' 权限验证通过，请进行操作           ';
      BitBtn_Delete.Enabled := true;
      //BitBtn_exchange_Del.Enabled := true;
      //BitBtn_INC_Del.Enabled := true;
    end
    else //不是万能卡AA，也不是老板卡BB ，也不是管理人员
    begin
      Label28.Caption := '对不起！当前卡无操作权限';
      BitBtn_Delete.Enabled := false;
      BitBtn_exchange_Del.Enabled := false;
      BitBtn_INC_Del.Enabled := false;
      exit;
    end;
  end;

end;

procedure Tfrm_IC_Report_Saletotal.ComboBox_DelClick(Sender: TObject);
begin
  if ComboBox_Del.text = '机台编号' then
  begin
    Panel_GameMC_Del.visible := true;
    Panel_Man_Del.visible := false;
    Panel_Menber_Del.visible := false;
    Label_Infor.Caption := '您当前选择的条件(机台编号)，只能删除兑换记录！';
  end
  else if ComboBox_Del.text = '营业员编号' then
  begin
    Panel_GameMC_Del.visible := false;
    Panel_Man_Del.visible := true;
    Panel_Menber_Del.visible := false;
    Label_Infor.Caption := '您当前选择的条件(营业员编号)，可删除当前营业员经手的兑换记录、充值记录！';
  end
  else if ComboBox_Del.text = '会员编号' then
  begin
    Panel_GameMC_Del.visible := false;
    Panel_Man_Del.visible := false;
    Panel_Menber_Del.visible := true;
    Label_Infor.Caption := '您当前选择的条件(会员编号)，可删除当前会员的兑换记录、充值记录！';

  end 
  else
  begin
    Panel_GameMC_Del.visible := false;
    Panel_Man_Del.visible := false;
    Panel_Menber_Del.visible := false;
    Label_Infor.Caption := '您当前选择的条件(全部)，可删除当前时间段的所有兑换记录、充值记录！';
  end;
end;

procedure Tfrm_IC_Report_Saletotal.Combo_MCname_DelClick(Sender: TObject);
begin
  if length(Trim(Combo_MCname_Del.Text)) = 0 then
  begin
    ShowMessage('机台游戏名称不能空');
    exit;
  end
  else
  begin
    InitCarMC_ID_Del(Combo_MCname_Del.Text);

  end;
end;


procedure Tfrm_IC_Report_Saletotal.BitBtn4Click(Sender: TObject);
begin
    //暂时没处理
end;

procedure Tfrm_IC_Report_Saletotal.Combo_MCnameChange(Sender: TObject);
var
  ADOQTemp: TADOQuery;
  strSQL: string;
  strMCName : string;
begin

  if Combo_MCname.text = '全部' then
    begin
      combobox_cardmc_id.Items.Clear;
      combobox_cardmc_id.Items.Add('全部');
    end
  else
    begin
      //根据游戏名称填充机台位
    Combobox_cardmc_id.Text := '全部';
    combobox_cardmc_id.Items.Clear;
    combobox_cardmc_id.Items.Add('全部');
      
    ADOQTemp := TADOQuery.Create(nil);
    strSQL := 'select distinct[MacNo] from [3F_barflow] where gamename =''' + Combo_MCname.Text + '''';

    ICFunction.loginfo(strSQL);
    
    with ADOQTemp do
    begin
      Connection := DataModule_3F.ADOConnection_Main;
      SQL.Clear;
      SQL.Add(strSQL);
      Active := True;

      while not Eof do
      begin
        combobox_cardmc_id.Items.Add(FieldByName('MacNo').AsString);
        Next;
      end;
    end;
    FreeAndNil(ADOQTemp);
  end   
end;




procedure Tfrm_IC_Report_Saletotal.initialrecord();
var
  strSQL:String;
begin
  with ADOQuery_InitialRecord do begin
    Connection := DataModule_3F.ADOConnection_Main;
    Active:=false;
    SQL.Clear;
    strSQL:='select * from [T_3F_INITIALRECORD] order by operatetime desc';
    SQL.Add(strSQL);
    Active:=True;
    end;
end;

end.







