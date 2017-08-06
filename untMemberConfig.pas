unit untMemberConfig;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Grids, DBGrids, SPComm, DB, ADODB, uLkJSON, StrUtils;

type
  TfrmMemberConfig = class(TForm)
    Panel1: TPanel;
    GroupBox2: TGroupBox;
    GroupBox1: TGroupBox;
    Label2: TLabel;
    edtShopID: TEdit;
    btnSubmit: TButton;
    btnCancel: TButton;
    GroupBox3: TGroupBox;
    dgRecharge: TDBGrid;
    dsRecharge: TDataSource;
    ADOQ: TADOQuery;
    lblMessage: TLabel;
    Label5: TLabel;
    edtAPPID: TEdit;
    Label6: TLabel;
    lbl1: TLabel;
    edtCoinValue: TEdit;
    edtTimes: TEdit;
    lbl2: TLabel;
   
    procedure FormShow(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnSubmitClick(Sender: TObject);


  private
    { Private declarations }
  public
    { Public declarations }

        //���ݿ����
    function initDBRecord(): string;
    procedure saveMemberConfiguration( cardtype:string);
    procedure updateMemberConfiguration(cardtype:string);
    
    function  getCoinCodeByCoinType(cardtype:string):string;
    function  getCoinByCoinType(cardtype :string):string;
    function  checkUniqueCoin(cardtype :string):Boolean;

  end;

var
  frmMemberConfig: TfrmMemberConfig;

implementation
uses ICDataModule, ICCommunalVarUnit, ICmain, ICEventTypeUnit, ICFunctionUnit, dateProcess, strprocess, IdHashMessageDigest, IdHTTP;
{$R *.dfm}


procedure TfrmMemberConfig.FormShow(Sender: TObject);
begin  

  //��ʼ������


  //��ʼ�����ݿ�����
  initDBRecord();
  ICFunction.loginfo('initDBRecord: ');

  //��ʼ����������
  edtAPPID.Text := SGBTCONFIGURE.appid;
  edtShopID.Text := SGBTCONFIGURE.shopid;


end;

function TfrmMemberConfig.initDBRecord(): string;
var
  strSQL: string;
begin
  with ADOQ do begin
    Connection := DataModule_3F.ADOConnection_Main;
    Active := false;
    SQL.Clear;
    strSQL := 'select ID,COIN_TYPE,COIN_VALUE,APPID,SHOPID ' +
            ' ,OPERATE_TIME, OPERATORNO ' +
             ' from T_MEMBER_CARD_CONFIGURATION ' +
             '  order by OPERATE_TIME desc limit 10';
    ICFunction.loginfo('strSQL: ' + strSQL);
    SQL.Add(strSQL);
    Active := True;
  end;
  result := '';

end;




procedure TfrmMemberConfig.btnCancelClick(Sender: TObject);
begin
              exit;

end;


//����޶�



function TfrmMemberConfig.checkUniqueCoin(cardtype: string): boolean;
var
  ADOQ: TADOQuery;
  strSQL :String;
begin
  ADOQ := TADOQuery.Create(Self);
  ADOQ.Connection := DataModule_3F.ADOConnection_Main;

  with ADOQ do begin
    Close;
    SQL.Clear;
    strSQL := 'select 1 from T_MEMBER_CARD_CONFIGURATION where COIN_TYPE=''' + cardtype + '''';
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


procedure TfrmMemberConfig.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin


end;

//��Ա��������

procedure TfrmMemberConfig.btnSubmitClick(Sender: TObject);
var
  operationcoin:string;
begin
  if checkUniqueCoin(edtTimes.Text) then
      updateMemberConfiguration(edtTimes.Text)
  else
      saveMemberConfiguration(edtTimes.Text);
  lblMessage.Caption := '��Ա���óɹ�';

end;


function  TfrmMemberConfig.getCoinCodeByCoinType(cardtype:string):string;
begin
    if cardtype = '�꿨' then
      result := '01'
    else if cardtype = '����' then
      result:='02'
    else if cardtype = '�¿�' then
      result:='03'
   else if cardtype = '��ͨ��' then
      result:='04' ;
end;

function  TfrmMemberConfig.getCoinByCoinType(cardtype :string):string;
var
  ADOQTemp: TADOQuery;
  strSQL: string;
  strWhere: string;

begin
  ADOQTemp := TADOQuery.Create(nil);

  strSQL := 'select COIN_VALUE from T_MEMBER_CARD_CONFIGURATION where COIN_TYPE=''' + cardtype + '''';
  ICFunction.loginfo('strSQL: ' + strSQL );
  with ADOQTemp do
  begin
    Connection := DataModule_3F.ADOConnection_Main;
    SQL.Clear;
    SQL.Add(strSQL);
    Active := True;
    Result := ADOQTemp.Fields[0].AsString;
  end;
  FreeAndNil(ADOQTemp);
end;




//�����Ա������Ϣ
procedure TfrmMemberConfig.saveMemberConfiguration(cardtype:string);
var
  strAppID, strBandid, strShopid, strPayid, strOperateTime, strOperatorNO, strPayState, strNote, strExpireTime, strsql: string;
  intCoin, intLeftCoin, intTotalCoin: Integer;
begin
   strAppID := trim(edtAppID.Text);
   strShopid := trim(edtShopID.Text);
   strOperatorNO := G_User.UserNO;
     with ADOQ do begin
    Connection := DataModule_3F.ADOConnection_Main;
    Active := false;
    SQL.Clear;
    ShortDateFormat := 'yyyy-MM-dd'; //ָ����ʽ����
    DateSeparator := '-';
    strOperateTime:=FormatDateTime('yyyy-MM-dd HH:mm:ss', now);
    strSQL := 'select * from T_MEMBER_CARD_CONFIGURATION order by OPERATE_TIME desc limit 10 '; //ΪʲôҪ��ȫ����
    ICFunction.loginfo('strSQL :' + strSQL);
    SQL.Add(strSQL);
    Active := True;
    Append;
    FieldByName('COIN_TYPE').AsString := edtTimes.Text;
    FieldByName('COIN_VALUE').AsString := edtCoinValue.Text;
    FieldByName('COIN_TIME').AsString := strOperateTime;
    FieldByName('APPID').AsString := strAppID;
    FieldByName('SHOPID').AsString := strShopid; 
    FieldByName('OPERATE_TIME').AsString := strOperateTime;
    FieldByName('OPERATORNO').AsString := strOperatorNO;
    post;
  end;
     
end;

procedure TfrmMemberConfig.updateMemberConfiguration(cardtype:string);
var
  ADOQ: TADOQuery;
  strSQL, strTemp: string;
begin
  strSQL := 'select coin_value, operate_time,OPERATORNO from  '
    + ' T_MEMBER_CARD_CONFIGURATION  where coin_type = ''' + cardtype + '''';
  strTemp := '';

  ShortDateFormat := 'yyyy-MM-dd'; //ָ����ʽ����
  DateSeparator := '-';

  ADOQ := TADOQuery.Create(nil);
  with ADOQ do begin
    Connection := DataModule_3F.ADOConnection_Main;
    Active := false;
    SQL.Clear;
    SQL.Add(strSQL);
    Active := true;     
    if (RecordCount > 0) then begin
      Edit;
      FieldByName('coin_value').AsString := edtCoinValue.text;
      FieldByName('OPERATE_TIME').AsString := FormatDateTime('yyyy-MM-dd HH:mm:ss',Now);
      FieldByName('OPERATORNO').AsString  := G_User.UserNO;      
      Post;
    end;
    Active := False;
  end;
  FreeAndNil(ADOQ);
  initDBRecord();
  lblMessage.Caption := '��Ա���������';
 end;








end.

