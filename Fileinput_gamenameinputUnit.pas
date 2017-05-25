unit Fileinput_gamenameinputUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Buttons, DB, ADODB;

type
  Tfrm_Fileinput_gamenameinput = class(TForm)
    Panel1: TPanel;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    ComboBox_MacType: TComboBox;
    Label2: TLabel;
    ComboBox_ComNum: TComboBox;
    Label3: TLabel;
    ComboBox_MCNoType: TComboBox;
    Label4: TLabel;
    Edit_MacType1: TEdit;
    Edit_ComNum1: TEdit;
    Edit_Start: TEdit;
    Label5: TLabel;
    Edit_ComNum2: TEdit;
    Edit_End: TEdit;
    Edit_MacType2: TEdit;
    Label6: TLabel;
    Label7: TLabel;
    ComboBox4: TComboBox;
    Label8: TLabel;
    Memo_Remark: TMemo;
    Edit_OperationNo: TEdit;
    Combo_MCname: TComboBox;
    DataSource_Gameset: TDataSource;
    ADOQuery_Gameset: TADOQuery;
    Edit1: TEdit;
    Panel2: TPanel;
    BitBtn17: TBitBtn;
    BitBtn20: TBitBtn;
    Label9: TLabel;
    Image2: TImage;
    procedure BitBtn20Click(Sender: TObject);
    procedure ComboBox_ComNumChange(Sender: TObject);
    procedure ComboBox_MacTypeChange(Sender: TObject);
    procedure ComboBox_MCNoTypeChange(Sender: TObject);
    procedure BitBtn17Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Combo_MCnameClick(Sender: TObject);
    procedure ComboBox_MCNoTypeClick(Sender: TObject);
    procedure Edit_EndKeyPress(Sender: TObject; var Key: Char);
    procedure ComboBox_MacTypeKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
    procedure QueryMax_MacNo(S1: string; S2: string);
    procedure InitDataBase;
    procedure InitCombo_MCname;
    function Query_GameNo(S1: string): string;

  public
    { Public declarations }
  end;

var
  frm_Fileinput_gamenameinput: Tfrm_Fileinput_gamenameinput;

implementation

uses ICDataModule, ICCommunalVarUnit, Fileinput_machinerecordUnit;

{$R *.dfm}

procedure Tfrm_Fileinput_gamenameinput.BitBtn20Click(Sender: TObject);
begin
  close;
end;

procedure Tfrm_Fileinput_gamenameinput.ComboBox_ComNumChange(
  Sender: TObject);
begin
  if (length(Trim(ComboBox_MacType.Text)) = 0) then
  begin
    ShowMessage('输入内容有误，请确认');
    exit;
  end
  else
  begin
    Edit_ComNum1.Text := ComboBox_ComNum.Text;
    Edit_ComNum2.Text := ComboBox_ComNum.Text;
    QueryMax_MacNo(ComboBox_MacType.Text, ComboBox_ComNum.Text);
  end;
end;

procedure Tfrm_Fileinput_gamenameinput.ComboBox_MacTypeChange(
  Sender: TObject);
begin
  if (length(Trim(ComboBox_MacType.Text)) = 0) then
  begin
    ShowMessage('输入内容有误，请确认');
    exit;
  end
  else
  begin
    Edit_MacType1.Text := ComboBox_MacType.Text;
    Edit_MacType2.Text := ComboBox_MacType.Text;
    QueryMax_MacNo(ComboBox_MacType.Text, ComboBox_ComNum.Text);

  end;
end;



//根据游戏类型和网络号，查询机台起始地址

procedure Tfrm_Fileinput_gamenameinput.QueryMax_MacNo(S1: string; S2: string);
var
  ADOQTemp: TADOQuery;
  strSQL: string;
  nameStr: string;
  Str: string;
  i: integer;
begin
  nameStr := S1 + S2 + '%';
  ADOQTemp := TADOQuery.Create(nil);
  strSQL := 'select max(MacNo) from [TChargMacSet] where MacNo like ''' + nameStr + ''''; //考虑追加同名的处理

  with ADOQTemp do
  begin
    Connection := DataModule_3F.ADOConnection_Main;
    SQL.Clear;
    SQL.Add(strSQL);
    Open;
    if (RecordCount > 0) then
    begin
      Str := Copy(TrimRight(ADOQTemp.Fields[0].AsString), 4, 2);
      if length(Str) <> 0 then
      begin
        if (StrToInt(Str) < 32) then
        begin
          Edit_Start.Text := IntToStr(StrToInt(Str) + 1);
        end
        else
        begin
          Edit_Start.Text := '32个号已用完';
        end;
      end
      else
      begin

        Edit_Start.Text := '1';
      end;
      Close;
    end
    else
      Close;
  end;
  FreeAndNil(ADOQTemp);

end;



//根据游戏名称，查询游戏编号

function Tfrm_Fileinput_gamenameinput.Query_GameNo(S1: string): string;
var
  ADOQTemp: TADOQuery;
  strSQL: string;
  Str: string;
  i: integer;
begin

  ADOQTemp := TADOQuery.Create(nil);
  strSQL := 'select GameNo from [TGameSet] where GameName= ''' + S1 + '''';
  with ADOQTemp do
  begin
    Connection := DataModule_3F.ADOConnection_Main;
    SQL.Clear;
    SQL.Add(strSQL);
    Open;
    if (RecordCount > 0) then
    begin
      Str := TrimRight(ADOQTemp.Fields[0].AsString);

      Close;
    end
    else
      Close;
  end;
  FreeAndNil(ADOQTemp);
  result := Str;
end;

procedure Tfrm_Fileinput_gamenameinput.ComboBox_MCNoTypeChange(
  Sender: TObject);
begin
  if (ComboBox_MCNoType.Text = '多台') then
    //Edit_End.Enabled:=true;
end;



//添加游戏编号为001的设备记录

procedure Tfrm_Fileinput_gamenameinput.BitBtn17Click(Sender: TObject);
var
  str3, str4, str5, str7, str8, strinputdatetime, gameno: string;
  strcore, strlevel, strMemo_instruction, strOperator: string;
  str6: Boolean;
  i, leng: integer;
label ExitSub;
begin
  i := 0;
  leng := 0;
  if length(Trim(ComboBox_MacType.Text)) = 0 then
  begin
    ShowMessage('机台类型不能空');
    exit;
  end;
  if length(Trim(ComboBox_ComNum.Text)) = 0 then
  begin
    ShowMessage('总线编号不能为空');
    exit;
  end;

  if length(Trim(Edit_Start.Text)) > 2 then
  begin
    ShowMessage('机台起始编号输入错误，请确认');
    exit;
  end;
  if (ComboBox_MCNoType.Text = '多台') and (length(Trim(Edit_End.Text)) = 0) then
  begin
    ShowMessage('机台结束编号不能空');
    exit;
  end;


  str3 := ComboBox_MCNoType.Text; //分单台、多台  ，若为多台时需要进行后续处理
  str8 := IntToStr(StrToInt(ComboBox_ComNum.Text));
  str5 := ComboBox_MacType.Text + ComboBox_ComNum.Text; //MacNo结果类似A01

 //处理机台状态
  if ComboBox4.Text = '正常' then
    str6 := true
  else
    str6 := false;

  strOperator := G_User.UserNO;
  strinputdatetime := DateTimetostr((now())); //录入时间，读取系统时间
  strMemo_instruction := Memo_Remark.Text;
  strcore := str5 + str7; //OK的机台编号


  //处理单台、多台时的记录
  if str3 = '单台' then
  begin
    leng := 1;
  end
  else if str3 = '多台' then
  begin
    leng := StrToInt(Edit_End.Text) - StrToInt(Edit_Start.Text) + 1;
    if (Strtoint(Edit_End.Text) > 32) or (Strtoint(Edit_End.Text) < Strtoint(Edit_Start.Text)) then
    begin
      Edit_End.Text := '32';
      ShowMessage('输入错误，输入值只能不大于32，而且不能比开始值小！');
      exit;
    end;
  end
  else
  begin
    ShowMessage('机台编号输入错误');
    exit;
  end;


  if length(Trim(Combo_MCname.Text)) = 0 then
  begin
    ShowMessage('没有选择游戏机台名称，请确认');
    exit;
  end;

  if Trim(Combo_MCname.Text) = '请点击选择' then
  begin
    ShowMessage('没有选择游戏机台名称，请确认');
    exit;
  end;




  //--------------------------------写入数据库表
  //Append

  begin
    for i := 0 to leng - 1 do
    begin //for 循环开始

      //判断单数还是双数
      if (StrToInt(Edit_Start.Text) + i) < 10 then //单数
        str7 := '0' + IntToStr(StrToInt(Edit_Start.Text) + i)
      else //双数
        str7 := IntToStr(StrToInt(Edit_Start.Text) + i);


      gameno := Query_GameNo(trim(Combo_MCname.Text)); //查询游戏编号
      Edit1.Text := gameno;
      with frm_Fileinput_machinerecord.ADOQuery_TChargMacSet do
      begin
        if (Locate('MacNo', strcore, [])) then
        begin
          if (MessageDlg('已经存在  ' + strcore + '  要更新吗？', mtInformation, [mbYes, mbNo], 0) = mrYes) then
            Edit
          else
            goto ExitSub;
        end



        else
        begin
                  //added by linlf
          Connection := DataModule_3F.ADOConnection_Main;
          Active := false;
          SQL.Clear;
    //strsql := 'select * from tchargmacset;';
          SQL.Add('select * from tchargmacset;');
          Active := True;


          Append;
          FieldByName('MacNo').AsString := str5 + str7; //机台编号
          FieldByName('GameNo').AsString := gameno; //游戏编号，此文本框隐藏了
          FieldByName('ComNum').AsString := str8; //串口号
          FieldByName('State').AsBoolean := str6; //机台状态
          FieldByName('MacID').AsString := '00' + Copy((str5 + str7), 2, 4); //机台状态
          FieldByName('cUserNo').AsString := strOperator;
          FieldByName('GetTime').AsString := strinputdatetime;
          FieldByName('MsState').AsBoolean := str6; //
          FieldByName('PerState').AsBoolean := str6; //
          FieldByName('SetMark').AsString := '000000'; //
          FieldByName('Compter').AsString := '0';
          FieldByName('Card_MC_ID').AsString := '0';
          try
            Post;
          except
            on e: Exception do ShowMessage(e.Message);
          end;
        end;
      end;
    end; //for循环结束
    frm_Fileinput_gamenameinput.InitDataBase;

    ExitSub:
    ComboBox_MacType.Text := '';
    ComboBox_ComNum.Text := '';
    Edit_Start.Text := '';
    Memo_Remark.Text := '';
                 // close;
  end;
  close;
end;


procedure Tfrm_Fileinput_gamenameinput.InitDataBase;
var
  strSQL: string;
begin
  frm_Fileinput_machinerecord.displayallgameslot;
end;

procedure Tfrm_Fileinput_gamenameinput.FormShow(Sender: TObject);
begin
  QueryMax_MacNo('A', '03');
  InitCombo_MCname;
end;

procedure Tfrm_Fileinput_gamenameinput.InitCombo_MCname; //初始化游戏名称下来框
var
  ADOQTemp: TADOQuery;
  strSQL: string;
  nameStr: string;
  i: integer;
begin
  ADOQTemp := TADOQuery.Create(nil);
  nameStr := '1'; //此针脚显示有效，0为无效
  strSQL := 'select [GameName],[ID] from [TGameSet]  order by ID ASC ';
  with ADOQTemp do
  begin
    Connection := DataModule_3F.ADOConnection_Main;
    SQL.Clear;
    SQL.Add(strSQL);
    Active := True;
    Combo_MCname.Items.Clear;
    while not Eof do
    begin
      Combo_MCname.Items.Add(FieldByName('GameName').AsString);
      Next;
    end;
  end;
  FreeAndNil(ADOQTemp);

end;


procedure Tfrm_Fileinput_gamenameinput.Combo_MCnameClick(Sender: TObject);
var
  ADOQTemp: TADOQuery;
  strSQL: string;
  nameStr: string;
  i: integer;
begin
  if length(Trim(Combo_MCname.Text)) = 0 then
  begin
    ShowMessage('没有选择游戏机台名称，请确认');
    exit;
  end;
  if Trim(Combo_MCname.Text) = '请点击选择' then
  begin
    ShowMessage('没有选择游戏机台名称，请确认');
    exit;
  end;

  ADOQTemp := TADOQuery.Create(nil);
  nameStr := '1'; //此针脚显示有效，0为无效
  strSQL := 'select [GameNo],[ID] from [TGameSet] where GameName=''' + Combo_MCname.Text + ''' order by ID ASC ';
  with ADOQTemp do
  begin
    Connection := DataModule_3F.ADOConnection_Main;
    SQL.Clear;
    SQL.Add(strSQL);
    Active := True;
    Edit_OperationNo.Text := '';
    while not Eof do
    begin
      Edit_OperationNo.Text := FieldByName('GameNo').AsString;
      Next;
    end;
  end;
  FreeAndNil(ADOQTemp);

end;

procedure Tfrm_Fileinput_gamenameinput.ComboBox_MCNoTypeClick(
  Sender: TObject);
begin
  if (ComboBox_MCNoType.Text = '多台') and (length(Edit_Start.Text) < 3) then
  begin
    Edit_End.Enabled := true;
  end
  else
  begin
    Edit_End.Enabled := false;
  end;
end;

procedure Tfrm_Fileinput_gamenameinput.Edit_EndKeyPress(Sender: TObject;
  var Key: Char);
begin
  if not (key in ['0'..'9', #8, #13]) then
  begin
    key := #0;
    ShowMessage('输入错误，只能输入数字和字符！');
    exit;
  end;


end;

procedure Tfrm_Fileinput_gamenameinput.ComboBox_MacTypeKeyPress(
  Sender: TObject; var Key: Char);
begin
  ShowMessage('机台类型不能空');
  exit;
end;

end.
