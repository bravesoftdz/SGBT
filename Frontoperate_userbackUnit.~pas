unit Frontoperate_userbackUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, DBGrids, StdCtrls, ExtCtrls, Buttons, SPComm, DB, ADODB;

type
  Tfrm_Frontoperate_userback = class(TForm)
    Panel2: TPanel;
    Panel1: TPanel;
    DBGrid2: TDBGrid;
    DataSource_Incvalue: TDataSource;
    ADOQuery_Incvalue: TADOQuery;
    DataSource_Newmenber: TDataSource;
    ADOQuery_newmenber: TADOQuery;
    comReader: TComm;
    DataSource_Userback: TDataSource;
    ADOQuery_Userback: TADOQuery;
    Panel3: TPanel;
    Panel4: TPanel;
    GroupBox4: TGroupBox;
    Label1: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Edit_Havecore: TEdit;
    Edit_Backmoney: TEdit;
    Edit_Pwdcomfir: TEdit;
    Bit_Corequery: TBitBtn;
    GroupBox5: TGroupBox;
    Label3: TLabel;
    Label4: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label5: TLabel;
    Edit_ID: TEdit;
    Edit_PrintNO: TEdit;
    Edit_Username: TEdit;
    Edit_Certify: TEdit;
    Edit_SaveMoney: TEdit;
    Edit_Prepassword: TEdit;
    Comb_menberlevel: TComboBox;
    Edit_Mobile: TEdit;
    rgSexOrg: TRadioGroup;
    Edit_UserNo: TEdit;
    BitBtn1: TBitBtn;
    BitBtn3: TBitBtn;
    Image1: TImage;
    Bit_Saverintouserback: TBitBtn;
    procedure BitBtn1Click(Sender: TObject);
    procedure comReaderReceiveData(Sender: TObject; Buffer: Pointer;
      BufferLength: Word);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BitBtn3Click(Sender: TObject);
    procedure Bit_SaverintouserbackClick(Sender: TObject);
    procedure Bit_CorequeryClick(Sender: TObject);
  private
    { Private declarations }
    function exchData(orderStr: string): string;
    procedure sendData();
    procedure checkOper();
    procedure InitDataBase;
    procedure Getmenberinfo(S: string);
    procedure Getmenbercore(S: string);
    procedure Updatemenberinfo;
  public
    { Public declarations }
  end;

var
  frm_Frontoperate_userback: Tfrm_Frontoperate_userback;
  curOrderNo: integer = 0;
  curOperNo: integer = 0;
  Backmoney: string = ''; //押金
  orderLst, recDataLst: Tstrings;
  buffer: array[0..2048] of byte;
implementation
uses ICDataModule, ICtest_Main, ICCommunalVarUnit, ICmain, ICEventTypeUnit;
{$R *.dfm}

procedure Tfrm_Frontoperate_userback.InitDataBase;
var
  strSQL: string;
begin
  with ADOQuery_newmenber do begin
    Connection := DataModule_3F.ADOConnection_Main;
    Active := false;
    SQL.Clear;
    strSQL := 'select * from [3F_Menber]';
    SQL.Add(strSQL);
    Active := True;
  end;
  with ADOQuery_Incvalue do begin
    Connection := DataModule_3F.ADOConnection_Main;
    Active := false;
    SQL.Clear;
    strSQL := 'select * from [3F_Menberincvalue]';
    SQL.Add(strSQL);
    Active := True;
  end;
  with ADOQuery_Userback do begin
    Connection := DataModule_3F.ADOConnection_Main;
    Active := false;
    SQL.Clear;
    strSQL := 'select * from [3F_Menberuserback]';
    SQL.Add(strSQL);
    Active := True;
  end;


end;


//转找发送数据格式

function Tfrm_Frontoperate_userback.exchData(orderStr: string): string;
var
  ii, jj: integer;
  TmpStr: string;
  reTmpStr: string;
begin
  if (length(orderStr) = 0) then
  begin
    MessageBox(handle, '传入参数不能为空!', '错误', MB_ICONERROR + MB_OK);
    result := '';
    exit;
  end;
  if (length(orderStr) mod 2) <> 0 then
  begin
    MessageBox(handle, '传入参数错误!', '错误', MB_ICONERROR + MB_OK);
    result := '';
    exit;
  end;
  for ii := 1 to (length(orderStr) div 2) do
  begin
    tmpStr := copy(orderStr, ii * 2 - 1, 2);
    jj := strToint('$' + tmpStr);
    reTmpStr := reTmpStr + chr(jj);
  end;
  result := reTmpStr;
end;

//发送数据过程

procedure Tfrm_Frontoperate_userback.sendData();
var
  orderStr: string;
begin
  if orderLst.Count > curOrderNo then
  begin
    orderStr := orderLst.Strings[curOrderNo];
        //memComSeRe.Lines.Add('==>> '+orderStr);
    orderStr := exchData(orderStr);
    comReader.WriteCommData(pchar(orderStr), length(orderStr));
    inc(curOrderNo);
  end;
end;

//检查返回的数据

procedure Tfrm_Frontoperate_userback.checkOper();
var
  i: integer;
  tmpStr: string;
begin
  case curOperNo of
    0: begin
        for i := 0 to recDataLst.Count - 1 do
          if copy(recDataLst.Strings[i], 3, 2) <> '00' then
          begin
                      //  memComSet.Lines.Add('读卡器连结失败');
                      //  memComSet.Lines.Add('');
            exit;
          end;
              //  memComSet.Lines.Add('读卡器连结成功');
              //  memComSet.Lines.Add('');
      end;
    1: begin
             //   memLowRe.Lines.Add('命令: 寻卡');
        if copy(recDataLst.Strings[0], 3, 2) <> '00' then
                //    memLowRe.Lines.Add('结果: 寻卡失败')
        else begin
                  //  memLowRe.Lines.Add('结果: 寻卡成功');
          if copy(recDataLst.Strings[0], 5, 2) = '04' then
                   //     memLowRe.Lines.Add('该卡片为Mifare one')
          else
                   //     memLowRe.Lines.Add('该卡片为其它类型');
        end;
              //  memLowRe.Lines.Add('');
      end;
    2: begin
                //memLowRe.Lines.Add('命令: 防冲突');
                //  AND (copy(recDataLst.Strings[0],23,2)='4A')
        if (copy(recDataLst.Strings[0], 9, 2) = 'A1') and (copy(recDataLst.Strings[0], 23, 2) = '4A') then
        begin
          Edit_ID.Text := copy(recDataLst.Strings[0], 13, 8);
          tmpStr := copy(recDataLst.Strings[0], 13, 8);
                   // Edit_IDNo.Text:=tmpStr;
          Edit_ID.Text := tmpStr;
          Getmenberinfo(tmpStr);
          Bit_Corequery.Enabled := True;
                   // memLowRe.Lines.Add('结果: 防冲突失败')
        end
        else begin
                  //  memLowRe.Lines.Add('结果: 防冲突成功');
          tmpStr := recDataLst.Strings[0];
          tmpStr := copy(tmpStr, 5, length(tmpStr) - 4);
                   // memLowRe.Lines.Add('序号: '+tmpStr);
        end;
                 // memLowRe.Lines.Add('');

      end;
    3: begin
               // memLowRe.Lines.Add('命令: 选择');
        if copy(recDataLst.Strings[0], 3, 2) <> '00' then
                  //  memLowRe.Lines.Add('结果: 选择失败')
        else
                   // memLowRe.Lines.Add('结果: 选择成功');
             //   memLowRe.Lines.Add('');
      end;
    4: begin
               // memLowRe.Lines.Add('命令: 终止');
        if copy(recDataLst.Strings[0], 3, 2) <> '00' then
                 //   memLowRe.Lines.Add('结果: 终止失败')
        else
                  //  memLowRe.Lines.Add('结果: 终止成功');
                //memLowRe.Lines.Add('');
      end;
    5: begin
        for i := 0 to recDataLst.Count - 1 do
          if copy(recDataLst.Strings[i], 3, 2) <> '00' then
          begin
            MessageBox(handle, '密码下载失败', '失败', MB_OK);
            exit;
          end;
        MessageBox(handle, '密码下载成功', '成功', MB_OK);
      end;
    6: begin
        for i := 0 to 3 do
        begin
          if copy(recDataLst.Strings[i + 4], 3, 2) <> '00' then
          begin
                      //  gbRWSector.Caption:=cbRWSec.Text+'读取失败';
            exit;
          end;
        end;
             //   edtBlock0.Text:=copy(recDataLst.Strings[4],5,32);
             //   edtBlock1.Text:=copy(recDataLst.Strings[5],5,32);
            //    edtBlock2.Text:=copy(recDataLst.Strings[6],5,32);
             //   edtBlock3.Text:=copy(recDataLst.Strings[7],5,32);
             //   gbRWSector.Caption:=cbRWSec.Text+'读取成功';
      end;
    7: begin
        for i := 0 to recDataLst.Count - 1 do
          if copy(recDataLst.Strings[i], 3, 2) <> '00' then
          begin
                  //      gbRWSector.Caption:=cbRWSec.Text+'写入失败';
            exit;
          end;
               // gbRWSector.Caption:=cbRWSec.Text+'写入成功';
      end;
    8: begin
        for i := 0 to recDataLst.Count - 1 do
          if copy(recDataLst.Strings[i], 3, 2) <> '00' then
          begin
                   //     MessageBox(handle,'块值初始化失败','失败',MB_OK);
            exit;
          end;
        MessageBox(handle, '块值初始化成功', '成功', MB_OK);
      end;
    9: begin
        for i := 0 to recDataLst.Count - 1 do
          if copy(recDataLst.Strings[i], 3, 2) <> '00' then
          begin
            MessageBox(handle, '块值读取失败', '失败', MB_OK);
            exit;
          end;
               // edtCurValue.Text:=copy(recDataLst.Strings[4],5,8);
        MessageBox(handle, '块值读取成功', '成功', MB_OK);
      end;
    10: begin
        for i := 0 to recDataLst.Count - 1 do
          if copy(recDataLst.Strings[i], 3, 2) <> '00' then
          begin
            MessageBox(handle, '块值加值失败', '失败', MB_OK);
            exit;
          end;
        MessageBox(handle, '块值加值成功', '成功', MB_OK);
      end;
    11: begin
        for i := 0 to recDataLst.Count - 1 do
          if copy(recDataLst.Strings[i], 3, 2) <> '00' then
          begin
            MessageBox(handle, '块值减值失败', '失败', MB_OK);
            exit;
          end;
        MessageBox(handle, '块值减值成功', '成功', MB_OK);
      end;
    12: begin
        for i := 0 to recDataLst.Count - 1 do
          if copy(recDataLst.Strings[i], 3, 2) <> '00' then
          begin
            MessageBox(handle, '密码修改失败', '失败', MB_OK);
            exit;
          end;
        MessageBox(handle, '密码修改成功', '成功', MB_OK);
      end;
  end;
end;




procedure Tfrm_Frontoperate_userback.FormCreate(Sender: TObject);
begin
  //   Initmenberlevel;
  EventObj := EventUnitObj.Create;
  EventObj.LoadEventIni;
 // InitStringGrid;
 // InitWorkParam;                          //初始化PLC事件定义参数
  InitDataBase; //显示出型号
 // InitEdit;                               //清空Edit框
 // InitDuanXH;                             //初始化型号Combox_Type_JH
 // PageControl_Set.ActivePageIndex:=0;
 // InitUser;
end;

procedure Tfrm_Frontoperate_userback.comReaderReceiveData(Sender: TObject;
  Buffer: Pointer; BufferLength: Word);
var
  ii: integer;
  recStr: string;
  tmpStr: string;
begin
  recStr := '';
  SetLength(tmpStr, BufferLength);
  move(buffer^, pchar(tmpStr)^, BufferLength);
  for ii := 1 to BufferLength do
  begin
    recStr := recStr + intTohex(ord(tmpStr[ii]), 2);
  end;
  //  memComSeRe.Lines.Add('<<== '+recStr);
  recDataLst.Add(recStr);
  if curOrderNo < orderLst.Count then
    sendData()
  else begin
    checkOper();
       // memComSeRe.Lines.Append('');
  end;

end;

procedure Tfrm_Frontoperate_userback.FormShow(Sender: TObject);
begin
  comReader.StartComm();
  orderLst := TStringList.Create;
  recDataLst := tStringList.Create;
end;

procedure Tfrm_Frontoperate_userback.FormClose(Sender: TObject;
  var Action: TCloseAction);
var
  i: integer;
begin
  orderLst.Free();
  recDataLst.Free();
  comReader.StopComm();
  for i := 0 to ComponentCount - 1 do
  begin
    if components[i] is TEdit then
    begin
      (components[i] as TEdit).Clear;
    end
  end;

end;


procedure Tfrm_Frontoperate_userback.BitBtn1Click(Sender: TObject);
begin
  orderLst.Clear();
  recDataLst.Clear();
  curOrderNo := 0;
  curOperNo := 2;
    //orderLst.Add('0103');
    //orderLst.Add('020B0F');
  orderLst.Add('AA8A5F5FA101004A');
  sendData();
end;


 //根据查询得到卡的ID，查询个人信息，为充值做准备

procedure Tfrm_Frontoperate_userback.Getmenberinfo(S: string);
var
  ADOQ: TADOQuery;
  strSQL, strRet: string;
  strsexOrg: string;

begin
  strRet := '0';
  strSQL := 'select 印刷卡号,用户编号,用户姓名,性别类型,身份证号,用户类型,预留密码,账户余额,手机号码,卡押金 from 3F_Menber where [卡ID]=''' + S + '''';
  ADOQ := TADOQuery.Create(nil);

  with ADOQ do begin
    Connection := DataModule_3F.ADOConnection_Main;
    SQL.Clear;
    SQL.Add(strSQL);
    Open;
    if (not eof) then
      Edit_PrintNO.Text := ADOQ.Fields[0].AsString;
    Edit_UserNo.Text := ADOQ.Fields[1].AsString;
    Edit_Username.Text := ADOQ.Fields[2].AsString;
    strsexOrg := ADOQ.Fields[3].AsString;
    if strsexOrg = '男' then
      rgSexOrg.ItemIndex := 0
    else
      rgSexOrg.ItemIndex := 1;

    Edit_Certify.Text := ADOQ.Fields[4].AsString;
    Comb_menberlevel.Text := ADOQ.Fields[5].AsString;
    Edit_Prepassword.Text := ADOQ.Fields[6].AsString;
    Edit_SaveMoney.Text := ADOQ.Fields[7].AsString;
    Edit_Mobile.Text := ADOQ.Fields[8].AsString;
    Backmoney := ADOQ.Fields[9].AsString; //押金
    Close;
  end;
  FreeAndNil(ADOQ);

 // Result:=strRet;
end;




//查询可退的积分和押金

procedure Tfrm_Frontoperate_userback.Bit_CorequeryClick(Sender: TObject);
begin
  Edit_Backmoney.Text := Backmoney; //押金可退的积分押金


  Getmenbercore(Edit_UserNo.Text); //根据用户编号查询 积分
end;

//根据用户编号，查询对应记录里面有多少分可以退

procedure Tfrm_Frontoperate_userback.Getmenbercore(S: string);
var
  ADOQ: TADOQuery;
  strSQL, strRet: string;
  strsexOrg: string;
  totalvalueinc: double;
  totalvaluelost: double;
begin
  totalvalueinc := 0;
  totalvaluelost := 0;
  strSQL := 'select 送分,消分 from 3F_Menberincvalue where [用户编号]=''' + S + '''';

  ADOQ := TADOQuery.Create(nil);
  with ADOQ do begin
    Connection := DataModule_3F.ADOConnection_Main;
    SQL.Clear;
    SQL.Add(strSQL);
    Open;
    first;
    while not eof do //累加送分栏和消分栏，以确认还有多少积分可以进行消分操作
    begin
      if trim(ADOQ.Fields[0].asstring) = '' then
        totalvalueinc := totalvalueinc
      else
        totalvalueinc := totalvalueinc + StrToFloat(ADOQ.Fields[0].AsString);
      if trim(ADOQ.Fields[1].asstring) = '' then
        totalvaluelost := totalvaluelost
      else
        totalvaluelost := totalvaluelost + StrToFloat(ADOQ.Fields[1].AsString);
      next;
    end; //while
  end; //with

  Edit_Havecore.Text := FloatToStr(totalvalueinc - totalvaluelost); //可以进行消分的积分数
  FreeAndNil(ADOQ);
end;


//保存退卡记录

procedure Tfrm_Frontoperate_userback.Bit_SaverintouserbackClick(Sender: TObject);
var
  strUserNo, strID, strOperator, strinputdatetime: string;
  i: integer;
label ExitSub;
begin
  strUserNo := Edit_UserNo.Text; //用户编号
  strOperator := G_User.UserNO; //操作员
  strID := Edit_ID.Text; //退卡ID
  strinputdatetime := DateTimetostr((now())); //录入时间，读取系统时间

  if Edit_Pwdcomfir.Text <> Edit_Prepassword.Text then
    ShowMessage('客户输入确认密码错误，请重新输入')
  else begin
    with ADOQuery_Userback do begin

      Append;
      FieldByName('用户编号').AsString := strUserNo;
      FieldByName('退卡ID').AsString := strID;
      FieldByName('退卡时间').AsString := strinputdatetime;
      FieldByName('操作员').AsString := strOperator;

      try
        Post;
      except
        on e: Exception do ShowMessage(e.Message);
      end;
    end;

    Updatemenberinfo; //更新用户表中的卡ID值

    Bit_Saverintouserback.Enabled := False; //关闭输入许可

    ExitSub:
   //情况输入框
    for i := 0 to ComponentCount - 1 do
    begin
      if components[i] is TEdit then
      begin
        (components[i] as TEdit).Clear;
      end
    end;
  end;

end;

//更新用户表，更改ID卡号内容=原内容+@，防止此卡给新的用户后出现冲突

procedure Tfrm_Frontoperate_userback.Updatemenberinfo;
var
  strID, strinputdatetime, strlevel: string;
begin
  strinputdatetime := DateTimetostr((now())); //录入时间，读取系统时间
  strlevel := Edit_UserNo.Text; //用户编号

  if Edit_Pwdcomfir.Text <> Edit_Prepassword.Text then
    ShowMessage('客户输入确认密码错误，请重新输入')
  else begin
    with ADOQuery_Incvalue do begin
      if (not Locate('用户编号', strlevel, [])) then
        Exit;
      Edit;
      FieldByName('卡ID').AsString := FieldByName('卡ID').AsString + '@';
      try
        Post;
      except
        on e: Exception do ShowMessage(e.Message);
      end;
    end;

  end;
end;


procedure Tfrm_Frontoperate_userback.BitBtn3Click(Sender: TObject);
begin
  Close;
end;

end.
