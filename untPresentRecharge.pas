unit untPresentRecharge;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Grids, DBGrids, SPComm, DB, ADODB, uLkJSON, StrUtils;

type
  TfrmPresentRecharge = class(TForm)
    Panel1: TPanel;
    GroupBox2: TGroupBox;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    edtPresentName: TEdit;
    btnSubmit: TButton;
    btnCancel: TButton;
    GroupBox3: TGroupBox;
    dgRecharge: TDBGrid;
    dsRecharge: TDataSource;
    ADOQ: TADOQuery;
    lblMessage: TLabel;

    lbl1: TLabel;
    edtTotalNum: TEdit;
    lbl2: TLabel;
    edtPresentValue: TEdit;
    lbl3: TLabel;
    edtOperNum: TEdit;
    procedure FormShow(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);

    procedure btnSubmitClick(Sender: TObject);


  private
    { Private declarations }
  public
    { Public declarations }

        //���ݿ����
    function initDBRecord(): string;                                               
    procedure savePresentRecord(totalnum:string;opernum:string);
    function  getOperTypeNameByCode(opertype :string ):string;
    function  getTotalNumByPresentName(presentname:string):Integer;
    function  checkUniqueCoin(presentname: string): boolean;
    procedure updateMemberConfiguration(presentname:string);
  end;

var
  frmPresentRecharge: TfrmPresentRecharge;
  curOrderNo: integer = 0; //???
  curOperNo: integer = 0;
  Operate_No: integer = 0; //ʲô����?������ڳ�ֵ��
  orderLst, recDataLst: Tstrings; //����ȫ�ֱ����������ݣ���������
  ID_UserCard_Text: string;
  IncValue_Enable: boolean; //�Ƿ�������ֵ�ı�־,��Ա����֤ͨ������ΪTrue
  buffer: array[0..2048] of byte;

  //ȫ�ֱ�����������SG3Fƽ̨����ID;
  GLOBALsg3ftrxID: string; //
  GLOBALstrPayID: string; //֧����ʽ������01/�ֽ�02
  globalOperCoin : string; //�������
  globalOperType : string; //������ʽ01��ֵ,02����
  operaSuccess : boolean;


implementation
uses ICDataModule, ICCommunalVarUnit, ICmain, ICEventTypeUnit, ICFunctionUnit, dateProcess, strprocess, IdHashMessageDigest, IdHTTP;
{$R *.dfm}


procedure TfrmPresentRecharge.FormShow(Sender: TObject);
begin  

  //��ʼ�����ݿ�����
  initDBRecord();          
  
end;

function TfrmPresentRecharge.initDBRecord(): string;
var
  strSQL: string;
  
begin
  with ADOQ do begin
    Connection := DataModule_3F.ADOConnection_Main;
    Active := false;
    SQL.Clear;
    strSQL := ' select ID,PRESENT_NAME,PRESENT_VALUE,TOTAL_NUM,OPER_NUM,OPER_TYPE,OPER_STATE  ' +
            ' ,OPERATE_TIME, OPERATOR_NO ' +
             ' from T_PRESENT_LOG ' +         
             ' order by OPERATE_TIME desc limit 10';
    ICFunction.loginfo('strSQL: ' + strSQL);
    SQL.Add(strSQL);
    Active := True;
  end;
  result := '';

end;






//��Ա��������

procedure TfrmPresentRecharge.btnSubmitClick(Sender: TObject);
var
  totalcoin :string;
  leftNumber :Integer;

begin
  globalOperType :='01';

  if( (IsNumberic(edtPresentValue.Text) = False) or (IsNumberic(edtOperNum.Text) = False) ) then
  begin
      ShowMessage('��������ȷ������');
      exit
  end;
  if (edtPresentName.Text = '') then
  begin
      ShowMessage('��������ȷ����Ʒ����');
      exit
  end;

   if checkUniqueCoin(edtPresentName.Text) then
      updateMemberConfiguration(edtPresentName.Text)
   else
   begin
      totalcoin := IntToStr(0 + StrToInt(edtOperNum.Text));
      savePresentRecord(totalcoin,edtOperNum.Text);
   end;
    edtTotalNum.Text := totalcoin;
    initDBRecord();
    lblMessage.Caption := '��Ʒ���ɹ�';

end;


function TfrmPresentRecharge.getTotalNumByPresentName(presentname:string):Integer;
var strSQL :string;
var TotalNum :Integer;
ADOQTemp: TADOQuery;
begin
  TotalNum :=0;
  strSQL := 'select total_num  from T_PRESENT_LOG where PRESENT_NAME =''' + presentname  + ''' order by operate_time desc ';
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


procedure TfrmPresentRecharge.btnCancelClick(Sender: TObject);
var
  totalcoin :string;
  leftNumber :Integer;
begin
  globalOperType := '02'; //�һ�

  if( (IsNumberic(edtPresentValue.Text) = False) or (IsNumberic(edtOperNum.Text) = False) ) then
  begin
      ShowMessage('��������ȷ������');
      exit
  end;
  if (edtPresentName.Text = '') then
  begin
      ShowMessage('��������ȷ����Ʒ����');
      exit
  end;
  leftNumber := getTotalNumByPresentName(edtPresentName.text);
  ICFunction.loginfo('leftNumber: ' + IntToStr(leftNumber));
  if  leftNumber <1  then
  begin
       ShowMessage('��Ʒ������');
       exit;
  end;
  edtTotalNum.Text := IntToStr(leftNumber);
  totalcoin := IntToStr( leftNumber - StrToInt(edtOperNum.Text));
  if  StrToInt(totalcoin) <1  then
  begin
       ShowMessage('��治��');
       exit;
  end;

  savePresentRecord(totalcoin,edtOperNum.Text);

  edtTotalNum.Text := totalcoin;
  initDBRecord();
  lblMessage.Caption := '��Ʒ�һ��ɹ�';
  
end;


procedure TfrmPresentRecharge.updateMemberConfiguration(presentname:string);
var
  ADOQ: TADOQuery;
  strSQL, strTemp: string;
begin
  strSQL := 'select TOTAL_NUM,OPER_NUM,OPER_TYPE, operate_time,OPERATORNO from  '
    + ' T_PRESENT_LOG where PRESENT_NAME = ''' + presentname + '''';
  strTemp := '';
  ADOQ := TADOQuery.Create(nil);
  with ADOQ do begin
    Connection := DataModule_3F.ADOConnection_Main;
    Active := false;
    SQL.Clear;
    SQL.Add(strSQL);
    Active := true;
    if (RecordCount > 0) then begin
      Edit;
      FieldByName('TOTAL_NUM').AsInteger := StrToInt(edtTotalNum.Text);
      FieldByName('OPER_NUM').AsInteger := StrToInt(edtOperNum.Text);
      FieldByName('OPER_TYPE').AsString := '01';
      FieldByName('OPERATE_TIME').AsString := FormatDateTime('yyyy-MM-dd HH:mm:ss',Now);
      FieldByName('OPERATORNO').AsString  := SGBTCONFIGURE.shopid;      
      Post;
    end;
    Active := False;
  end;
  FreeAndNil(ADOQ);
  initDBRecord();
  lblMessage.Caption := '��Ա���������';
 end;
 


procedure TfrmPresentRecharge.savePresentRecord(totalnum:string;opernum:string);
var
  strTrxid, strAppID, strBandid, strShopid, strPayid, strOperateTime, strOperatorNO, strPayState, strNote, strExpireTime, strsql: string;
  intCoin, intLeftCoin, intTotalCoin: Integer;

begin    
  ICFunction.loginfo('Begin savePresentRecord ');
      //ָ�����ڸ�ʽ ��Ҫ
  ShortDateFormat := 'yyyy-MM-dd'; //ָ����ʽ����
  DateSeparator := '-';
    //ָ�����ڸ�ʽ ����ᱨis not an valid date and time;
  strOperateTime := FormatDateTime('yyyy-MM-dd HH:mm:ss', now);
  strOperatorNO := '001';
  
  with ADOQ do begin
    Connection := DataModule_3F.ADOConnection_Main;
    Active := false;
    SQL.Clear;
    strSQL := 'select * from T_PRESENT_LOG order by operate_time desc';
    ICFunction.loginfo('strSQL :' + strSQL);
    SQL.Add(strSQL);
    Active := True;
    Append;
    FieldByName('PRESENT_NAME').AsString := edtPresentName.text;
    FieldByName('PRESENT_VALUE').AsString := edtPresentValue.text;
    FieldByName('TOTAL_NUM').AsInteger := StrToInt(totalnum);
    FieldByName('OPER_NUM').AsInteger := StrToInt(opernum);
    FieldByName('OPER_TYPE').AsString := getOperTypeNameByCode(globalOperType);
    FieldByName('OPER_STATE').AsString := '�ɹ�';
    FieldByName('OPERATE_TIME').AsString := strOperateTime;
    FieldByName('OPERATOR_NO').AsString := strOperatorNO;
    post;
  end;
  ICFunction.loginfo('End saveMemberRechargeRecord ');
end;

function TfrmPresentRecharge.checkUniqueCoin(presentname: string): boolean;
var
  ADOQ: TADOQuery;
  strSQL :String;
begin
  ADOQ := TADOQuery.Create(Self);
  ADOQ.Connection := DataModule_3F.ADOConnection_Main;

  with ADOQ do begin
    Close;
    SQL.Clear;
    strSQL := 'select 1 from T_PRESENT_LOG where present_name=''' + presentname + '''';
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


function TfrmPresentRecharge.getOperTypeNameByCode(opertype :string ):string;
begin
   if opertype='01' then
      Result := '���'
   else if opertype='02' then
      Result :='�һ�';

end;

end.
