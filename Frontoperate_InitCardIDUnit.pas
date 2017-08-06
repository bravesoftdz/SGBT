unit Frontoperate_InitCardIDUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, IniFiles,
  Dialogs, DB, ADODB, SPComm, StdCtrls, Buttons, ExtCtrls, OleCtrls,
  MSCommLib_TLB, Grids, DBGrids;

type
  Tfrm_bind_cardheadid = class(TForm)
    Panel2: TPanel;
    Panel4: TPanel;
    Panel1: TPanel;
    dsBindCardHead: TDataSource;
    ADOQBindCardHead: TADOQuery;
    GroupBox2: TGroupBox;
    dbgrdCardHead: TDBGrid;
    Panel3: TPanel;
    Image1: TImage;
    Image2: TImage;
    cbMachineName: TComboBox;
    cbCardPositionNo: TComboBox;
    edtCardHeadID: TEdit;
    edtBindCount: TEdit;
    btnConfirm: TBitBtn;
    BarCodeCOM2: TComm;
    btnDelete: TButton;
    procedure FormShow(Sender: TObject);
    procedure cbMachineNameClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
//    procedure MSCbarcodeComm(Sender: TObject);
    procedure btnConfirmClick(Sender: TObject);
    procedure BarCodeCOM2ReceiveData(Sender: TObject; Buffer: Pointer;
      BufferLength: Word);
    procedure btnDeleteClick(Sender: TObject);

  private
    { Private declarations }
  public

    procedure initcbMachineName;
    procedure SaveBindCardHeadIDRecord;
    procedure InitDataBase;
    function  getBindTotalNumber():Integer;

    function getMachineNoByName(machinename:String) :String;
    function getMachineNameByCardHeadID(cardheadid:String) :String;
    function getPositionNoByCardHeadID(cardheadid:String) :String;
    function checkUniqueBindCardHeadID(cardheadid: string): boolean;
    function checkUniquePositionNo(positionno: string): boolean;
    function INit_Send_CMD(StrCMD: string; StrIncValue: string): string;
    function Date_Time_Modify(strinputdatetime: string): string;

    procedure InitCardPositionByMachineName(Str: string);
    procedure CheckCMD_BarCodeCom2();
  end;

var
  frm_bind_cardheadid: Tfrm_bind_cardheadid;

  CARDID_First, temp_First: string;
  CARDID_Comfir, temp_Comfir: string;



  curOrderNo: integer = 0;
  curOperNo: integer = 0;
  curScanNo: integer = 0;
  TotalCore: integer = 0;
  Operate_No: integer = 0;

  curOrderNo_Barcode: integer = 0;
  curOperNo_Barcode: integer = 0;
  curScanNo_Barcode: integer = 0;
  TotalCore_Barcode: integer = 0;
  Operate_No_Barcode: integer = 0;

  BAR1_CARDNO, BAR2_CARDNO: string;
  Tuibi_Operate_Enable: string;
  buffer: array[0..2048] of byte;
  BAR_Type1, BAR_Type2: string;
  orderLst, recDataLst, recData_fromICLst: Tstrings;
  orderLst_Barcode, recDataLst_Barcode, recData_fromICLst_Barcode: Tstrings;

implementation

uses SetParameterUnit, ICDataModule, ICCommunalVarUnit, ICEventTypeUnit, ICFunctionUnit;
{$R *.dfm}

procedure Tfrm_bind_cardheadid.FormShow(Sender: TObject);
begin
  InitDataBase;
  initcbMachineName;
  edtCardHeadID.Text := '';
  edtBindCount.Text :=  IntToStr(getBindTotalNumber());


  BarCodeCOM2.StartComm();
  orderLst_BarCode := TStringList.Create;
  recDataLst_BarCode := tStringList.Create;
  recData_fromICLst_BarCode := tStringList.Create;
end;

procedure Tfrm_bind_cardheadid.initcbMachineName;
var
  ADOQTemp: TADOQuery;
  strSQL: string;
begin
  ADOQTemp := TADOQuery.Create(nil);  
  strSQL := 'select MACHINE_NAME from tmachineset order by operate_time Desc ';
  ICFunction.loginfo('strSQL: ' + strSQL);
  with ADOQTemp do
  begin
    Connection := DataModule_3F.ADOConnection_Main;
    SQL.Clear;
    SQL.Add(strSQL);
    Active := True;
    cbMachineName.Items.Clear;
    while not Eof do
    begin
      cbMachineName.Items.Add(FieldByName('MACHINE_NAME').AsString);
      Next;
    end;
  end;
  FreeAndNil(ADOQTemp);

end;

function Tfrm_bind_cardheadid.getBindTotalNumber():Integer;
var strSQL :string;
var TotalNum :Integer;
ADOQTemp: TADOQuery;
begin
  TotalNum :=0;
  strSQL := 'select count(*)  from T_BIND_CARDHEADID ';
  ICFunction.loginfo('strSQL :' + strSQL);
  ADOQTemp := TADOQuery.Create(nil);
  with ADOQTemp do
  begin
    Connection := DataModule_3F.ADOConnection_Main;
    SQL.Clear;
    SQL.Add(strSQL);
    Active := True;
    if (not eof) then
    begin
      TotalNum := ADOQTemp.Fields[0].AsInteger;
      Close;
    end;
    FreeAndNil(ADOQTemp);
  end;
  result := TotalNum;
end;




//������̨��Ӧ�Ŀ�λ���
procedure Tfrm_bind_cardheadid.cbMachineNameClick(
  Sender: TObject);
begin
  InitCardPositionByMachineName(Trim(cbMachineName.Text));
end;


procedure Tfrm_bind_cardheadid.InitCardPositionByMachineName(Str: string);
var
  ADOQTemp: TADOQuery;
  strSQL: string;


begin

  if length(Trim(Str)) = 0 then
  begin
    ShowMessage('��̨��Ϸ���Ʋ��ܿ�');
    exit;
  end
  else
  begin
   cbCardPositionNo.Items.Clear;
   cbCardPositionNo.Text :='��ѡ��λ';
    ADOQTemp := TADOQuery.Create(nil);
    strSQL := 'select  CARD_POSITION_NO from TPOSITIONSET  where MACHINE_NAME =''' + cbMachineName.Text + '''';
    ICFunction.loginfo('strSQL: ' + strSQL);
    with ADOQTemp do
    begin
      Connection := DataModule_3F.ADOConnection_Main;
      SQL.Clear;
      SQL.Add(strSQL);
      Active := True;
      while not Eof do
      begin
          cbCardPositionNo.Items.Add(FieldByName('CARD_POSITION_NO').AsString);
        Next;

      end;
    end;
    FreeAndNil(ADOQTemp);

  end;
end;


procedure Tfrm_bind_cardheadid.btnCloseClick(Sender: TObject);
var strgameno: string;
var strsql: string;
begin
  ShowMessage('here');
  strGameno := ADOQBindCardHead.FieldByName('POSITION_NO').AsString;
  if (MessageDlg('ȷʵҪɾ��' + strGameno + ' ��ͷλ��?', mtConfirmation, [mbYes, mbNo], 0) = mrYes) then
  begin
    strsql := 'delete from T_BIND_CARDHEADID where POSITION_NO = ''' + strGameno + '''';
    DataModule_3F.executesql(strsql);
    ICFunction.loginfo('strSQL :' + strSQL);
    InitDataBase;
  end;


end;




procedure Tfrm_bind_cardheadid.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  cbCardPositionNo.Items.Clear;
  cbMachineName.Items.Clear;
  cbCardPositionNo.Text := '';
  cbMachineName.Text := '';

  orderLst.Free();
  recDataLst.Free();
  recData_fromICLst.Free();
  BarCodeCOM2.StopComm();
end;






procedure Tfrm_bind_cardheadid.InitDataBase;
var
  strSQL: string;
  strtemp: string;
begin
  strtemp := '1';
  with ADOQBindCardHead do begin
    Connection := DataModule_3F.ADOConnection_Main;
    Active := false;
    SQL.Clear;
    strSQL := 'SELECT * FROM T_BIND_CARDHEADID limit 10';
    SQL.Add(strSQL);
    Active := True;
  end;

end;


//��ʼ��������ָ��

function Tfrm_bind_cardheadid.INit_Send_CMD(StrCMD: string; StrIncValue: string): string;
var
  TmpStr: string; //�淶������ں�ʱ��

  TmpStr_SendCMD: string; //ָ������

  reTmpStr: string;
  myIni: TiniFile;
  strinputdatetime: string;

  i: integer;
  Strsent: array[0..21] of string; //���ͷ����Ӧ����
begin
  strinputdatetime := DateTimetostr((now()));
  TmpStr := Date_Time_Modify(strinputdatetime); //�淶���ں�ʱ���ʽ
  Strsent[0] := StrCMD; //֡����

  Strsent[5] := IntToHex(Strtoint(Copy(TmpStr, 1, 2)), 2); //���ǰ2λ
  Strsent[18] := IntToHex(Strtoint(Copy(TmpStr, 3, 2)), 2); //��ݺ�2λ
  Strsent[8] := IntToHex(Strtoint(Copy(TmpStr, 6, 2)), 2); //�·�ǰ2λ
  Strsent[10] := IntToHex(Strtoint(Copy(TmpStr, 9, 2)), 2); //����ǰ2λ
  Strsent[14] := IntToHex(Strtoint(Copy(TmpStr, 12, 2)), 2); //Сʱǰ2λ
  Strsent[6] := IntToHex(Strtoint(Copy(TmpStr, 15, 2)), 2); //����ǰ2λ
  Strsent[1] := IntToHex(Strtoint(Copy(TmpStr, 18, 2)), 2); //��ǰ2λ

  Strsent[2] := IntToHex((Strtoint('$' + Strsent[10]) + Strtoint('$' + Strsent[8])), 2);

  Strsent[3] := IntToHex((Strtoint('$' + Strsent[1]) + Strtoint('$' + Strsent[6])), 2);
  Strsent[7] := IntToHex((Strtoint('$' + Strsent[2]) + Strtoint('$' + Strsent[8])), 2);
  Strsent[16] := IntToHex((Strtoint('$' + Strsent[5]) + Strtoint('$' + Strsent[6])), 2);
  Strsent[13] := IntToHex((Strtoint('$' + Strsent[14]) + Strtoint('$' + Strsent[5])), 2);


  Strsent[4] := IntToHex(((Strtoint('$' + Strsent[7]) * Strtoint('$' + Strsent[16])) div 256), 2);
  Strsent[9] := IntToHex(((Strtoint('$' + Strsent[7]) * Strtoint('$' + Strsent[16])) mod 256), 2);
  Strsent[11] := IntToHex(((Strtoint('$' + Strsent[3]) * Strtoint('$' + Strsent[13])) mod 256), 2);
  Strsent[15] := IntToHex(((Strtoint('$' + Strsent[3]) * Strtoint('$' + Strsent[13])) div 256), 2);


  Strsent[17] := IntToHex((Strtoint('$' + Strsent[6]) + Strtoint('$' + Strsent[1])), 2);
  Strsent[12] := IntToHex((Strtoint('$' + Strsent[14]) + Strtoint('$' + Strsent[8])), 2);

    //Strsent[19]:= Receive_CMD_ID_Infor.ID_3F;
    //Strsent[20]:=Receive_CMD_ID_Infor.Password_3F;
                              //����ȡ���ĵ��еĳ�������
  if FileExists(SystemWorkGroundFile) then
  begin
    myIni := TIniFile.Create(SystemWorkGroundFile);
    INit_Wright.BossPassword := MyIni.ReadString('PLC��������', 'PC����������', 'D6077');
    FreeAndNil(myIni);
  end;

    //���������ݽ���У�˼���
  for i := 0 to 18 do
  begin
    TmpStr_SendCMD := TmpStr_SendCMD + Strsent[i];
  end;
     // TmpStr_CheckSum:=CheckSUMData(TmpStr_SendCMD);//���У���

    //TmpStr_CheckSum�ֽ���Ҫ�����Ų� �����ֽ���ǰ�����ֽ��ں�
  //  reTmpStr:=TmpStr_SendCMD+Select_CheckSum_Byte(TmpStr_CheckSum);//��ȡ���з��͸�IC������

  result := reTmpStr;
end;

//��ʱ��ɨ��ͳ�ƽ������ϸ��¼

function Tfrm_bind_cardheadid.Date_Time_Modify(strinputdatetime: string): string;
var
  strEnd: string;
  Strtemp: string;
begin

  Strtemp := Copy(strinputdatetime, length(strinputdatetime) - 8, 9);
  strinputdatetime := Copy(strinputdatetime, 1, length(strinputdatetime) - 9);
  if Copy(strinputdatetime, 7, 1) = '-' then //�·�С��10
  begin
    if length(strinputdatetime) = 8 then //�·�С��10,������С��10
    begin
      strEnd := Copy(strinputdatetime, 1, 5) + '0' + Copy(strinputdatetime, 6, 2) + '0' + Copy(strinputdatetime, 8, 1);
    end
    else
    begin
      strEnd := Copy(strinputdatetime, 1, 5) + '0' + Copy(strinputdatetime, 6, length(strinputdatetime) - 5);
    end;
  end
  else
  begin //�·ݴ���9
    if length(strinputdatetime) = 9 then //�·ݴ���9,������С��10
    begin
      strEnd := Copy(strinputdatetime, 1, 8) + '0' + Copy(strinputdatetime, 9, 1);
    end
    else
    begin
      strEnd := strinputdatetime;
    end;
  end;
  result := strEnd + Strtemp;
end;

procedure Tfrm_bind_cardheadid.btnConfirmClick(Sender: TObject);
begin
       //���������¼
     //Ψһ���ж�
  if (length(Trim(cbMachineName.Text)) = 0) or (cbMachineName.Text = '����ѡ��') then
  begin
    ShowMessage('��̨��Ϸ���Ʋ��ܿ�');
    exit;
  end;

  if (length(Trim(cbCardPositionNo.Text)) = 0) or (cbCardPositionNo.Text = '����ѡ��') then
  begin
    ShowMessage('��̨��Ϸλ��Ų��ܿ�');
    exit;
  end;

  if (length(Trim(edtCardHeadID.Text)) = 0) then
  begin
    ShowMessage('����ɨ�迨ͷ����');
    exit;
  end;

  if checkUniqueBindCardHeadID(Trim(edtCardHeadID.Text)) = true then
  begin
         ShowMessage('�˿�ͷID�Ѿ���');
         exit;
  end;

  if checkUniqueBindCardHeadID(Trim(cbCardPositionNo.Text)) = true then
  begin
         ShowMessage('�˿�̨λ�Ѿ�����');
         exit;
  end;
  
  SaveBindCardHeadIDRecord(); //���濨ͷID
  InitDataBase();
  edtBindCount.Text := IntToStr(getBindTotalNumber());
end; //




function Tfrm_bind_cardheadid.checkUniqueBindCardHeadID(cardheadid: string): boolean;
var
  ADOQ: TADOQuery;
  strSQL :String;
begin
  ADOQ := TADOQuery.Create(Self);
  ADOQ.Connection := DataModule_3F.ADOConnection_Main;

  with ADOQ do begin
    Close;
    SQL.Clear;
    strSQL := 'select 1 from T_BIND_CARDHEADID where CARDHEADID=''' + cardheadid + '''';
    ICFunction.loginfo('Exist check  strSQL: ' + strSQL);
    SQL.Add(strSQL);
    Open;
    if (Eof) then
      result := false
    else
      result := true;
  end;
  ADOQ.Close;
  ADOQ.Free;
end;


function Tfrm_bind_cardheadid.checkUniquePositionNo(positionno: string): boolean;
var
  ADOQ: TADOQuery;
  strSQL :String;
begin
  ADOQ := TADOQuery.Create(Self);
  ADOQ.Connection := DataModule_3F.ADOConnection_Main;

  with ADOQ do begin
    Close;
    SQL.Clear;
    strSQL := 'select 1 from T_BIND_CARDHEADID where POSITION_NO=''' + positionno + '''';
    ICFunction.loginfo('Exist check  strSQL: ' + strSQL);
    SQL.Add(strSQL);
    Open;
    if (Eof) then
      result := false
    else
      result := true;
  end;
  ADOQ.Close;
  ADOQ.Free;
end;




//���浱ǰ��¼��������ˮ�š�����ֵ����Ϣ

procedure Tfrm_bind_cardheadid.SaveBindCardHeadIDRecord;
var
  strSQL,strOperateTime ,strOperatorNO: string;
begin


  
  ShortDateFormat := 'yyyy-MM-dd'; //ָ����ʽ����
  DateSeparator := '-';
  strOperateTime := FormatDateTime('yyyy-MM-dd HH:mm:ss', now);
  strOperatorNO := G_User.UserNO;
    
  with ADOQBindCardHead do begin
    Connection := DataModule_3F.ADOConnection_Main;
    Active := false;
    SQL.Clear;
    strSQL := 'select * from T_BIND_CARDHEADID where MACHINE_NAME=''' + cbMachineName.text + '''';
    ICFunction.loginfo('strSQL :' + strSQL);
    SQL.Add(strSQL);
    Active := True;
    Append;
    FieldByName('CARDHEADID').AsString := edtCardHeadID.Text;
    FieldByName('MACHINE_NAME').AsString := cbMachineName.Text;
    FieldByName('MACHINE_NO').AsString := getMachineNoByName(cbMachineName.Text);
    FieldByName('POSITION_NO').AsString := cbCardPositionNo.Text;
    FieldByName('OPERATE_TIME').AsString := strOperateTime;
    FieldByName('OPERATOR_NO').AsString := strOperatorNO;
    post;
  end;

end;


function Tfrm_bind_cardheadid.getMachineNoByName(machinename:String) :String;
var
  ADOQTemp: TADOQuery;
  strSQL: string;
  MACHINE_NO:Integer;
begin
  MACHINE_NO := 0;
  ADOQTemp := TADOQuery.Create(nil);
  strSQL := 'select ID from tmachineset where MACHINE_NAME =''' + machinename  + '''';
  ICFunction.loginfo('strSQL: ' + strSQL);
  with ADOQTemp do
  begin
    Connection := DataModule_3F.ADOConnection_Main;
    SQL.Clear;
    SQL.Add(strSQL);
    Active := True;
    if (not eof) then
        begin
          MACHINE_NO := ADOQTemp.Fields[0].AsInteger;;
          Close;
        end;
        FreeAndNil(ADOQTemp);
  end;
      result := intTostr(MACHINE_NO);

end;



function Tfrm_bind_cardheadid.getMachineNameByCardHeadID(cardheadid:String) :String;
var
  ADOQTemp: TADOQuery;
  strSQL: string;
  machinename:string;
begin
  machinename := '';
  ADOQTemp := TADOQuery.Create(nil);
  strSQL := 'select MACHINE_NAME from T_BIND_CARDHEADID where CARDHEADID =''' + cardheadid  + '''';
  ICFunction.loginfo('strSQL: ' + strSQL);
  with ADOQTemp do
  begin
    Connection := DataModule_3F.ADOConnection_Main;
    SQL.Clear;
    SQL.Add(strSQL);
    Active := True;
    if (not eof) then
        begin
          machinename := ADOQTemp.Fields[0].AsString;
          Close;
        end;
        FreeAndNil(ADOQTemp);
  end;
      result := machinename;

end;


function Tfrm_bind_cardheadid.getPositionNoByCardHeadID(cardheadid:String) :String;
var
  ADOQTemp: TADOQuery;
  strSQL: string;
  positionNo:string;
begin
  positionNo := '';
  ADOQTemp := TADOQuery.Create(nil);
  strSQL := 'select POSITION_NO from T_BIND_CARDHEADID where CARDHEADID =''' + cardheadid  + '''';
  ICFunction.loginfo('strSQL: ' + strSQL);
  with ADOQTemp do
  begin
    Connection := DataModule_3F.ADOConnection_Main;
    SQL.Clear;
    SQL.Add(strSQL);
    Active := True;
    if (not eof) then
        begin
          positionNo := ADOQTemp.Fields[0].AsString;
          Close;
        end;
        FreeAndNil(ADOQTemp);
  end;
      result := positionNo;

end;




 //���ݽ��յ��������жϴ˿��Ƿ�Ϊ�Ϸ���

procedure Tfrm_bind_cardheadid.CheckCMD_BarCodeCom2();
var                      
  tmpStr_Barcode: string;
  tempStr: string;
  firstbit: string; //ȷ��ɨ�������һ������
  Firstframe_hex: string;
begin


   //���Ƚ�ȡ���յ���Ϣ
  tmpStr_Barcode := recData_fromICLst_Barcode.Strings[0];
  Firstframe_hex := copy(tmpStr_Barcode, 1, 2);
  BarCodeValue := ICFunction.ChangeAreaHEXToStr(copy(tmpStr_Barcode, 3, length(tmpStr_Barcode) - 2));
  if (Firstframe_hex = '39') then
  begin
    firstbit := 'A';
  end
  else if (Firstframe_hex = '30') then
  begin
    firstbit := 'B';
  end
  else if (Firstframe_hex = BarCodeFirstFrame[0]) then
  begin
    firstbit := 'A';
  end
  else if (Firstframe_hex = BarCodeFirstFrame[1]) then
  begin
    firstbit := 'B';
  end
  else if (Firstframe_hex = BarCodeFirstFrame[2]) then
  begin
    firstbit := 'C'; //35
  end
  else if (Firstframe_hex = BarCodeFirstFrame[3]) then
  begin
    firstbit := 'D'; //36
  end
  else if (Firstframe_hex = BarCodeFirstFrame[4]) then
  begin
    firstbit := 'E'; //37
  end
  else
  begin
    ShowMessage('�Ƿ�����,��ȷ���Ƿ�Ϊ���������룡');
    BarCodeValue := '';
    exit;
  end;

  begin
    tempStr := '0' + BarCodeValue;
//    Edit6.Text := tempStr;
      //Panel_Infor.Caption:='';
//    Edit5.Text := inttostr(length(tempStr));

        //��ˮ��̨���룬9-A
    if (firstbit = 'A') and ((length(tempStr) = 21) or (length(tempStr) = 20)) then
      //����1
    begin
//---------------
      temp_First := tempStr;
      edtCardHeadID.Text := '';
      Panel3.Caption := '��ȷ��ɨ����ȷ';
      if (length(tempStr) = 21) then
      begin
        CARDID_First := copy(tempStr, 20, 1) + copy(tempStr, 11, 1) + copy(tempStr, 6, 1) + copy(tempStr, 13, 1);
      end
      else if (length(tempStr) = 20) then
      begin
        CARDID_First := copy(tempStr, 11, 1) + copy(tempStr, 6, 1) + copy(tempStr, 13, 1);
      end;
      edtCardHeadID.Text := CARDID_First;
      BarCodeValue_CardHead := '';

//
    end
         //�������룬0-B
    else if (firstbit = 'B') and ((length(tempStr) = 23) or (length(tempStr) = 22)) then
      //����2
    begin
      temp_Comfir := tempStr;  
      Panel3.Caption := '��ȷ��ɨ����ȷ';
      if (length(tempStr) = 23) then
      begin
        CARDID_Comfir := copy(tempStr, 22, 1) + copy(tempStr, 2, 1) + copy(tempStr, 13, 1) + copy(tempStr, 8, 1);
      end
      else if (length(tempStr) = 22) then
      begin
        CARDID_Comfir := copy(tempStr, 2, 1) + copy(tempStr, 13, 1) + copy(tempStr, 8, 1);
      end;

      BarCodeValue_CardHead := '';

    end;

    //���������¼




  end;
end;



//���ܲ�Ʊ��Ϣ

procedure Tfrm_bind_cardheadid.BarCodeCOM2ReceiveData(Sender: TObject;
  Buffer: Pointer; BufferLength: Word);
var
  ii: integer;
  recStr: string;
  tmpStr: string;
  tmpStrend: string;
begin
   //����----------------
  tmpStrend := 'STR';
  recStr := '';
  SetLength(tmpStr, BufferLength);
  move(buffer^, pchar(tmpStr)^, BufferLength);
  for ii := 1 to BufferLength do
  begin
    recStr := recStr + intTohex(ord(tmpStr[ii]), 2); //���������ת��Ϊ16������

    if ii = BufferLength then
    begin
      tmpStrend := 'END';
    end;
  end;

  recData_fromICLst_Barcode.Clear;
  recData_fromICLst_Barcode.Add(recStr);

  begin
    CheckCMD_BarCodeCom2(); //���ȸ��ݽ��յ������ݽ����жϣ�ȷ�ϴ˿��Ƿ�����Ϊ��ȷ�Ŀ�

  end;



end;


procedure Tfrm_bind_cardheadid.btnDeleteClick(Sender: TObject);
var strgameno: string;
var strsql: string;
begin
  strGameno := ADOQBindCardHead.FieldByName('POSITION_NO').AsString;
  if (MessageDlg('ȷʵҪɾ��' + strGameno + ' ��ͷλ��?', mtConfirmation, [mbYes, mbNo], 0) = mrYes) then
  begin

    strsql := 'delete from T_BIND_CARDHEADID where POSITION_NO = ''' + strGameno + '''';
    DataModule_3F.executesql(strsql);
    ICFunction.loginfo('strSQL :' + strSQL);

    InitDataBase;
  end;

  
end;

end.
